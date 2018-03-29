#include once "ProcessPutRequest.bi"
#include once "WebUtils.bi"
#include once "WriteHttpError.bi"
#include once "HttpConst.bi"

Function ProcessPutRequest( _
		ByVal state As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal www As WebSite Ptr, _
		ByVal hOutput As Handle _
	)As Boolean
	' Проверка авторизации пользователя
	If HttpAuthUtil(state, ClientSocket, www, hOutput) = False Then
		Return False
	End If
	
	' Если какой-то из переданных серверу заголовков Content-* не опознан или не может быть использован в данной ситуации
	' сервер возвращает статус ошибки 501 (Not Implemented).
	' Если ресурс с указанным URI не может быть создан или модифицирован,
	' должно быть послано соответствующее сообщение об ошибке. 
	
	' Не указан тип содержимого
	If lstrlen(state->ClientRequest.RequestHeaders(HttpRequestHeaderIndices.HeaderContentType)) = 0 Then
		state->ServerResponse.StatusCode = 501
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError501ContentTypeEmpty, @www->VirtualPath, hOutput)
		Return False
	End If
	
	' TODO Проверить тип содержимого
	
	' Сжатое содержимое не поддерживается
	If lstrlen(state->ClientRequest.RequestHeaders(HttpRequestHeaderIndices.HeaderContentEncoding)) <> 0 Then
		state->ServerResponse.StatusCode = 501
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError501ContentEncoding, @www->VirtualPath, hOutput)
		Return False
	End If
	
	Dim RequestBodyContentLength As LARGE_INTEGER = Any
	
	' Требуется указание длины
	If StrToInt64Ex(state->ClientRequest.RequestHeaders(HttpRequestHeaderIndices.HeaderContentLength), STIF_DEFAULT, @RequestBodyContentLength.QuadPart) = 0 Then
		state->ServerResponse.StatusCode = 411
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError411LengthRequired, @www->VirtualPath, hOutput)
		Return False
	End If
	
	' Длина содержимого по заголовку Content-Length слишком большая
	If RequestBodyContentLength.QuadPart > MaxRequestBodyContentLength Then
		state->ServerResponse.StatusCode = 413
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError413RequestEntityTooLarge, @www->VirtualPath, hOutput)
		Return False
	End If
	
	REM ' Может быть указана кодировка содержимого
	REM Dim contentType() As String = state.RequestHeaders(HttpRequestHeaderIndices.HeaderContentType).Split(";"c)
	REM Dim kvp = m_ContentTypes.Find(Function(x) x.ContentType = contentType(0))
	REM If kvp Is Nothing Then
		REM ' Такое содержимое нельзя загружать
		REM state.StatusCode = 501
		REM state.ResponseHeaders(HttpResponseHeaderIndices.HeaderAllow) = AllSupportHttpMethodsWithoutPut
		REM state.WriteError(objStream, String.Format(MethodNotAllowed, state.HttpMethod), www.VirtualPath)
		REM Exit Do
	REM End If
	
	' TODO Изменить расширение файла на правильное
	REM ' нельзя оставлять отправленное пользователем расширение
	REM ' указать (новое) имя файла в заголовке Location
	REM state.FilePath = Path.ChangeExtension(state.FilePath, kvp.Extension)
	REM state.PathTranslated = state.MapPath(www.VirtualPath, state.FilePath, www.PhysicalDirectory)
	
	Dim HeaderLocation As WString * (WebSite.MaxFilePathLength + 1) = Any
	
	' Открыть существующий файл для перезаписи
	Dim hFile As HANDLE = CreateFile(@www->PathTranslated, GENERIC_READ + GENERIC_WRITE, 0, NULL, TRUNCATE_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile = INVALID_HANDLE_VALUE Then
		' Создать каталог, если ещё не создан
		
		Select Case GetLastError()
			
			Case ERROR_PATH_NOT_FOUND
				Dim FileDir As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
				lstrcpy(@FileDir, @www->PathTranslated)
				PathRemoveFileSpec(@FileDir)
				CreateDirectory(@FileDir, Null)
				
		End Select
		
		' Открыть файл с нуля
		hFile = CreateFile(@www->PathTranslated, GENERIC_READ + GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL)
		If hFile = INVALID_HANDLE_VALUE Then
			' Нельзя открыть файл для перезаписи
			' TODO Узнать код ошибки и отправить его клиенту
			state->ServerResponse.StatusCode = 500
			WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
			Return False
		End If
		
		state->ServerResponse.StatusCode = 201
		lstrcpy(@HeaderLocation, "http://")
		lstrcat(@HeaderLocation, @www->HostName)
		lstrcat(@HeaderLocation, @www->FilePath)
		state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderLocation) = @HeaderLocation
	End If
	
	Dim hFileMap As Handle = CreateFileMapping(hFile, 0, PAGE_READWRITE, RequestBodyContentLength.HighPart, RequestBodyContentLength.LowPart, 0)
	If hFileMap = 0 Then
		' TODO Узнать код ошибки и отправить его клиенту
		state->ServerResponse.StatusCode = 500
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
		
		CloseHandle(hFile)
		Return False
	End If
	
	Dim b As Byte Ptr = CPtr(Byte Ptr, MapViewOfFile(hFileMap, FILE_MAP_ALL_ACCESS, 0, 0, 0))
	If b = 0 Then
		' TODO Узнать код ошибки и отправить его клиенту
		state->ServerResponse.StatusCode = 500
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
		
		CloseHandle(hFileMap)
		CloseHandle(hFile)
		Return False
	End If
	
	' TODO Заголовки записать в специальный файл
	REM HeaderContentEncoding
	REM HeaderContentLanguage
	REM HeaderContentLocation
	REM HeaderContentMd5
	REM HeaderContentType
	
	' Записать предварительно загруженные данные и удалить их из клиентского буфера
	Dim PreloadedContentLength As Integer = state->ClientReader.BufferLength - state->ClientReader.Start
	If PreloadedContentLength > 0 Then
		RtlCopyMemory(b, @state->ClientReader.Buffer[state->ClientReader.Start], PreloadedContentLength)
		' TODO Проверить на ошибки записи
		state->ClientReader.Flush()
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
	
	' Удалить файл 410, если он был
	Dim PathTranslated410 As WString * (WebSite.MaxFilePathTranslatedLength + 4 + 1) = Any
	lstrcpy(@PathTranslated410, @www->PathTranslated)
	lstrcat(@PathTranslated410, @FileGoneExtension)
	DeleteFile(@PathTranslated410) ' не проверяем ошибку удаления
	
	' Отправить клиенту текст, что всё хорошо
	Dim WriteResult As Boolean = WriteHttp201(state, ClientSocket, www, hOutput)
	
	UnmapViewOfFile(b)
	
	CloseHandle(hFileMap)
	CloseHandle(hFile)
	
	Return WriteResult
End Function
