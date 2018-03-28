#include once "ProcessGetHeadRequest.bi"
#include once "HttpConst.bi"
#include once "WriteHttpError.bi"
#include once "Mime.bi"
#include once "WebUtils.bi"
#include once "CharConstants.bi"
#include once "ProcessCgiRequest.bi"
#include once "ProcessDllRequest.bi"

Function ProcessGetHeadRequest( _
		ByVal state As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal www As WebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal hOutput As Handle, _
		ByVal hFile As Handle _
	)As Boolean
	
	If hFile = INVALID_HANDLE_VALUE Then
		' TODO Проверить код ошибки через GetLastError, могут быть не только File Not Found.
		' Файла не существет, записать ошибку клиенту
		Dim buf410 As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(buf410, @www->PathTranslated)
		lstrcat(buf410, @FileGoneExtension)
		
		Dim hFile410 As HANDLE = CreateFile(@buf410, 0, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
		If hFile410 = INVALID_HANDLE_VALUE Then
			' Файлы не существует, но она может появиться позже
			state->ServerResponse.StatusCode = 404
			WriteHttpError(state, ClientSocket, HttpErrors.HttpError404FileNotFound, www->VirtualPath, hOutput)
		Else
			' Файла раньше существовала, но теперь удалена навсегда
			CloseHandle(hFile410)
			state->ServerResponse.StatusCode = 410
			WriteHttpError(state, ClientSocket, HttpErrors.HttpError410Gone, www->VirtualPath, hOutput)
		End If
		Return False
	End If
	
	' Проверка на CGI
	If NeedCGIProcessing(state->ClientRequest.ClientUri.Path) Then
		CloseHandle(hFile)
		Return ProcessCGIRequest(state, ClientSocket, www, fileExtention, hOutput)
	End If
	
	' Проверка на dll-cgi
	If NeedDLLProcessing(state->ClientRequest.ClientUri.Path) Then
		CloseHandle(hFile)
		Return ProcessDllCgiRequest(state, ClientSocket, www, fileExtention, hOutput)
	End If
	
	' Не обрабатываем файлы с неизвестным типом
	Dim mt As MimeType = Any
	If GetMimeOfFileExtension(@mt, fileExtention) = False Then
		state->ServerResponse.StatusCode = 403
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError403File, @www->VirtualPath, hOutput)
		CloseHandle(hFile)
		Return False
	End If
	
	' TODO Проверить идентификацию для запароленных ресурсов
	
	' Заголовки сжатия
	Dim hZipFile As Handle = Any
	If mt.IsTextFormat Then
		hZipFile = state->SetResponseCompression(@www->PathTranslated)
	Else
		hZipFile = INVALID_HANDLE_VALUE
	End If
	
	' Нельзя отображать файлы нулевого размера
	Dim FileSize As LARGE_INTEGER = Any
	Dim GetFileSizeExResult As Integer = Any
	If hZipFile = INVALID_HANDLE_VALUE Then
		GetFileSizeExResult = GetFileSizeEx(hFile, @FileSize)
	Else
		GetFileSizeExResult = GetFileSizeEx(hZipFile, @FileSize)
	End If
	
	If GetFileSizeExResult = 0 Then
		' TODO узнать причину неудачи через GetLastError() = ERROR_ALREADY_EXISTS
		state->ServerResponse.StatusCode = 500
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
		CloseHandle(hZipFile)
		CloseHandle(hFile)
		Return False
	End If
	
	' Строка с типом документа
	Dim wContentType As WString * (2 * MaxContentTypeLength + 1) = Any
	lstrcpy(@wContentType, ContentTypeToString(mt.ContentType))
	
	If FileSize.QuadPart = 0 Then
		' Создать заголовки ответа и отправить клиенту
		state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderContentType) = @wContentType
		state->AddResponseCacheHeaders(hFile)
		Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
		Dim SendResult As Integer = send(ClientSocket, @SendBuffer, state->AllResponseHeadersToBytes(@SendBuffer, 0, hOutput), 0)
		CloseHandle(hZipFile)
		CloseHandle(hFile)
		If SendResult = SOCKET_ERROR Then
			Return False
		End If
		Return True
	End If
	
	' Отобразить файл
	Dim hFileMap As Handle = Any
	If hZipFile = INVALID_HANDLE_VALUE Then
		hFileMap = CreateFileMapping(hFile, 0, PAGE_READONLY, 0, 0, 0)
	Else
		hFileMap = CreateFileMapping(hZipFile, 0, PAGE_READONLY, 0, 0, 0)
	End If
	If hFileMap = 0 Then
		' TODO узнать причину неудачи через GetLastError() = ERROR_ALREADY_EXISTS
		' Чтение файла завершилось неудачей
		state->ServerResponse.StatusCode = 500
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
		CloseHandle(hZipFile)
		CloseHandle(hFile)
		Return False
	End If
	
	' Всё хорошо
	' Создать представление файла
	Dim pFileBytes As UByte Ptr = CPtr(UByte Ptr, MapViewOfFile(hFileMap, FILE_MAP_READ, 0, 0, 0))
	If pFileBytes = 0 Then
		' Чтение файла завершилось неудачей
		' TODO Узнать код ошибки и отправить его клиенту
		state->ServerResponse.StatusCode = 500
		WriteHttpError(state, ClientSocket, HttpErrors.HttpError500NotAvailable, @www->VirtualPath, hOutput)
		CloseHandle(hFileMap)
		CloseHandle(hZipFile)
		CloseHandle(hFile)
		Return False
	End If
	
	' HTTP/1.1 206 Partial Content
	' Обратите внимание на заголовок Content-Length — в нём указывается размер тела сообщения,
	' то есть передаваемого фрагмента. Если сервер вернёт несколько фрагментов,
	' то Content-Length будет содержать их суммарный объём.
	' Content-Range: bytes 471104-2355520/2355521
	' state->ResponseHeaders(HttpResponseHeaderIndices.HeaderContentRange) = "bytes 471104-2355520/2355521"
	
	Dim FileBytesStartIndex As Integer = Any
	If mt.IsTextFormat Then
		If hZipFile = INVALID_HANDLE_VALUE Then
			' pFileBytes указывает на настоящий файл
			If FileSize.QuadPart > 3 Then
				Select Case GetDocumentCharset(pFileBytes)
					Case DocumentCharsets.ASCII
						' Ничего
						FileBytesStartIndex = 0
					Case DocumentCharsets.Utf8BOM
						lstrcat(@wContentType, @ContentCharsetUtf8)
						FileBytesStartIndex = 3
					Case DocumentCharsets.Utf16LE
						lstrcat(wContentType, @ContentCharsetUtf16)
						FileBytesStartIndex = 0
					Case DocumentCharsets.Utf16BE
						lstrcat(wContentType, @ContentCharsetUtf16)
						FileBytesStartIndex = 2
				End Select
			Else
				' Кодировка ASCII
				FileBytesStartIndex = 0
			End If
		Else
			' pFileBytes указывает на сжатый файл
			FileBytesStartIndex = 0
			Dim b2 As ZString * 4 = Any
			Dim BytesCount As DWORD = Any
			If ReadFile(hFile, @b2, 3, @BytesCount, 0) <> 0 Then
				If BytesCount >= 3 Then
					Select Case GetDocumentCharset(@b2)
						Case DocumentCharsets.ASCII
							' Ничего
						Case DocumentCharsets.Utf8BOM
							lstrcat(wContentType, @ContentCharsetUtf8)
						Case DocumentCharsets.Utf16LE
							lstrcat(wContentType, @ContentCharsetUtf16)
						Case DocumentCharsets.Utf16BE
							lstrcat(wContentType, @ContentCharsetUtf16)
					End Select
				REM Else
					REM ' Кодировка ASCII
				End If
			End If
		End If
	Else
		FileBytesStartIndex = 0
	End If
	
	state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderContentType) = @wContentType
	state->AddResponseCacheHeaders(hFile)
	
	' Добавить пользовательские заголовки ответа
	' TODO Может быть переполнение буфера при слишком длинных заголовках ответа
	Dim sExtHeadersFile As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
	lstrcpy(@sExtHeadersFile, @www->PathTranslated)
	lstrcat(@sExtHeadersFile, @HeadersExtensionString)
	Dim hExtHeadersFile As HANDLE = CreateFile(@sExtHeadersFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hExtHeadersFile <> INVALID_HANDLE_VALUE Then
		Dim zExtHeaders As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
		Dim wExtHeaders As WString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
		
		Dim ReadedBytesCount As DWORD = Any
		If ReadFile(hExtHeadersFile, @zExtHeaders, WebResponse.MaxResponseHeaderBuffer, @ReadedBytesCount, 0) <> 0 Then
			If ReadedBytesCount > 2 Then
				zExtHeaders[ReadedBytesCount] = 0
				If MultiByteToWideChar(CP_UTF8, 0, @zExtHeaders, -1, @wExtHeaders, WebResponse.MaxResponseHeaderBuffer) > 0 Then
					Dim w As WString Ptr = @wExtHeaders
					Do
						Dim wName As WString Ptr = w
						' Найти двоеточие
						Dim wColon As WString Ptr = StrChr(w, ColonChar)
						' Найти vbCrLf и убрать
						w = StrStr(w, NewLineString)
						If w <> 0 Then
							w[0] = 0 ' и ещё w[1] = 0
							' Указываем на следующий символ после vbCrLf, если это ноль — то это конец
							w += 2
						End If
						If wColon > 0 Then
							wColon[0] = 0
							Do
								wColon += 1
							Loop While wColon[0] = 32
							state->ServerResponse.AddResponseHeader(wName, wColon)
						End If
					Loop While lstrlen(w) > 0
				End If
			End If
		End If
		CloseHandle(hExtHeadersFile)
	End If
	
	' В основном анализируются заголовки
	' Accept: text/css, */*
	' Accept-Charset: utf-8
	' Accept-Encoding: gzip, deflate
	' Accept-Language: ru-RU
	' User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063
	' Серверу желательно включать в ответ заголовок Vary с указанием параметров,
	' по которым различается содержимое по запрашиваемому URI.
	
	' Заголовки сжатия
	' TODO вместо перезаписывания заголовка его нужно добавить
	Select Case state->ServerResponse.ResponseZipMode
		
		Case ZipModes.GZip
			state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderContentEncoding) = @GZipString
			state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderVary) = @"Accept-Encoding"
			
		Case ZipModes.Deflate
			state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderContentEncoding) = @DeflateString
			state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderVary) = @"Accept-Encoding"
			
		Case Else
			state->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderVary) = 0
			
	End Select
	
	' Создать и отправить заголовки ответа
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	Dim BodyLength As Integer = FileSize.QuadPart - FileBytesStartIndex
	Dim HeadersLength As Integer = state->AllResponseHeadersToBytes(@SendBuffer, BodyLength, hOutput)
	
	If HeadersLength + BodyLength < WebResponse.MaxResponseHeaderBuffer Then
		' Заголовки и тело в одном ответе
		
		#if __FB_DEBUG__ <> 0
			Print "Заголовки и тело в одном ответе"
		#endif
		
		If state->ServerResponse.SendOnlyHeaders = False Then
			memcpy	(@SendBuffer + HeadersLength, pFileBytes + FileBytesStartIndex, BodyLength)
		End If
		If send(ClientSocket, @SendBuffer, HeadersLength + BodyLength, 0) = SOCKET_ERROR Then
			UnmapViewOfFile(pFileBytes)
			CloseHandle(hFileMap)
			CloseHandle(hZipFile)
			CloseHandle(hFile)
			Return False
		End If
	Else
		' Заголовки и тело в двух ответах
		If send(ClientSocket, @SendBuffer, HeadersLength, 0) = SOCKET_ERROR Then
			UnmapViewOfFile(pFileBytes)
			CloseHandle(hFileMap)
			CloseHandle(hZipFile)
			CloseHandle(hFile)
			Return False
		End If
		
		If state->ServerResponse.SendOnlyHeaders = False Then
			If send(ClientSocket, pFileBytes + FileBytesStartIndex, BodyLength, 0) = SOCKET_ERROR Then
				UnmapViewOfFile(pFileBytes)
				CloseHandle(hFileMap)
				CloseHandle(hZipFile)
				CloseHandle(hFile)
				Return False
			End If
		End If
	End If
	
	' Закрыть
	UnmapViewOfFile(pFileBytes)
	CloseHandle(hFileMap)
	#if __FB_DEBUG__ <> 0
		Print "Закрываю отображённый в память файл hFileMap"
	#endif
	
	' Закрыть
	If hZipFile <> INVALID_HANDLE_VALUE Then
		CloseHandle(hZipFile)
		#if __FB_DEBUG__ <> 0
			Print "Закрываю сжатый файл hZipFile"
		#endif
	End If
	CloseHandle(hFile)
	#if __FB_DEBUG__ <> 0
		Print "Закрываю файл hFile"
	#endif
	Return True
End Function
