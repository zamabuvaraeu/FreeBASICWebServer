#include once "ProcessPutRequest.bi"
#include once "WebUtils.bi"
#include once "WriteHttpError.bi"
#include once "HttpConst.bi"

Function ProcessPutRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal hRequestedFile As Handle _
	)As Boolean
	' Проверка авторизации пользователя
	If HttpAuthUtil(pState, ClientSocket, pWebSite, False) = False Then
		Return False
	End If
	
	' Если какой-то из переданных серверу заголовков Content-* не опознан или не может быть использован в данной ситуации
	' сервер возвращает статус ошибки 501 (Not Implemented).
	
	If lstrlen(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderContentType)) = 0 Then
		WriteHttpContentTypeEmpty(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' TODO Проверить тип содержимого
	
	' TODO Сохранить сжатое содержимое
	If lstrlen(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderContentEncoding)) <> 0 Then
		WriteHttpContentEncodingNotEmpty(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	Dim RequestBodyContentLength As LARGE_INTEGER = Any
	
	' Требуется указание длины
	If StrToInt64Ex(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderContentLength), STIF_DEFAULT, @RequestBodyContentLength.QuadPart) = 0 Then
		WriteHttpLengthRequired(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' TODO Максимальная длина загружаемого содержимого
	' If RequestBodyContentLength.QuadPart > MaxRequestBodyContentLength Then
		' WriteHttpRequestEntityTooLarge(pState, ClientSocket, pWebSite)
		' Return False
	' End If
	
	REM ' Может быть указана кодировка содержимого
	REM Dim contentType() As String = pState.RequestHeaders(HttpRequestHeaders.HeaderContentType).Split(";"c)
	REM Dim kvp = m_ContentTypes.Find(Function(x) x.ContentType = contentType(0))
	REM If kvp Is Nothing Then
		REM ' Такое содержимое нельзя загружать
		REM pState.StatusCode = 501
		REM pState.ResponseHeaders(HttpResponseHeaderIndices.HeaderAllow) = AllSupportHttpMethodsWithoutPut
		REM pState.WriteError(objStream, String.Format(MethodNotAllowed, pState.HttpMethod), pWebSite.VirtualPath)
		REM Exit Do
	REM End If
	
	Dim HeaderLocation As WString * (SimpleWebSite.MaxFilePathLength + 1) = Any
	
	' Открыть существующий файл для перезаписи
	Dim hFile As HANDLE = CreateFile(pWebSite->PathTranslated, GENERIC_READ + GENERIC_WRITE, 0, NULL, TRUNCATE_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile = INVALID_HANDLE_VALUE Then
		' Создать каталог, если ещё не создан
		
		Select Case GetLastError()
			
			Case ERROR_PATH_NOT_FOUND
				Dim FileDir As WString * (SimpleWebSite.MaxFilePathTranslatedLength + 1) = Any
				lstrcpy(@FileDir, pWebSite->PathTranslated)
				PathRemoveFileSpec(@FileDir)
				CreateDirectory(@FileDir, Null)
				
		End Select
		
		hFile = CreateFile(pWebSite->PathTranslated, GENERIC_READ + GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL)
		If hFile = INVALID_HANDLE_VALUE Then
			' TODO Узнать код ошибки и отправить его клиенту
			WriteHttpFileNotAvailable(pState, ClientSocket, pWebSite)
			Return False
		End If
		
		pState->ServerResponse.StatusCode = 201
		lstrcpy(@HeaderLocation, "http://")
		lstrcat(@HeaderLocation, pWebSite->HostName)
		lstrcat(@HeaderLocation, pWebSite->FilePath)
	End If
	
	Dim hFileMap As Handle = CreateFileMapping(hFile, 0, PAGE_READWRITE, RequestBodyContentLength.HighPart, RequestBodyContentLength.LowPart, 0)
	If hFileMap = 0 Then
		' TODO Узнать код ошибки и отправить его клиенту
		WriteHttpFileNotAvailable(pState, ClientSocket, pWebSite)
		
		CloseHandle(hFile)
		Return False
	End If
	
	Dim b As Byte Ptr = CPtr(Byte Ptr, MapViewOfFile(hFileMap, FILE_MAP_ALL_ACCESS, 0, 0, 0))
	If b = 0 Then
		' TODO Узнать код ошибки и отправить его клиенту
		WriteHttpFileNotAvailable(pState, ClientSocket, pWebSite)
		
		CloseHandle(hFileMap)
		CloseHandle(hFile)
		Return False
	End If
	
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderLocation) = @HeaderLocation
	
	' TODO Заголовки записать в специальный файл
	REM HeaderContentEncoding
	REM HeaderContentLanguage
	REM HeaderContentLocation
	REM HeaderContentMd5
	REM HeaderContentType
	
	' Записать предварительно загруженные данные и удалить их из клиентского буфера
	Dim PreloadedContentLength As Integer = pClientReader->BufferLength - pClientReader->Start
	If PreloadedContentLength > 0 Then
		RtlCopyMemory(b, @pClientReader->Buffer[pClientReader->Start], PreloadedContentLength)
		' TODO Проверить на ошибки записи
		pClientReader->Flush()
	End If
	
	' Записать всё остальное
	Do While PreloadedContentLength < RequestBodyContentLength.QuadPart
		Dim numReceived As Integer = recv(ClientSocket, @b[PreloadedContentLength], RequestBodyContentLength.QuadPart - PreloadedContentLength, 0)
		
		' TODO Проверить на ошибки получения данных из сокета
		Select Case numReceived
			
			Case SOCKET_ERROR
				Exit Do
				
			Case 0
				Exit Do
				
			Case Else
				' Сколько байт получили, на столько и увеличили буфер
				PreloadedContentLength += numReceived
				
		End Select
		
	Loop
	
	UnmapViewOfFile(b)
	CloseHandle(hFileMap)
	CloseHandle(hFile)
	
	' Удалить файл 410, если он был
	Dim PathTranslated410 As WString * (SimpleWebSite.MaxFilePathTranslatedLength + 4 + 1) = Any
	lstrcpy(@PathTranslated410, pWebSite->PathTranslated)
	lstrcat(@PathTranslated410, @FileGoneExtension)
	DeleteFile(@PathTranslated410)
	
	WriteHttpCreated(pState, ClientSocket, pWebSite)
	
	Return True
End Function
