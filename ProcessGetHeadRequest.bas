#include once "ProcessGetHeadRequest.bi"
#include once "HttpConst.bi"
#include once "WriteHttpError.bi"
#include once "Mime.bi"
#include once "WebUtils.bi"
#include once "CharConstants.bi"
#include once "ProcessCgiRequest.bi"
#include once "ProcessDllRequest.bi"
#include "win\Mswsock.bi"

Type SafeHandle
	Declare Constructor(ByVal hFile As HANDLE)
	Declare Destructor()
	Dim FileHandle As HANDLE
End Type

Constructor SafeHandle(ByVal hFile As HANDLE)
	#if __FB_DEBUG__ <> 0
		Print "Захватываю описатель файла hFile"
	#endif
	FileHandle = hFile
End Constructor

Destructor SafeHandle()
	#if __FB_DEBUG__ <> 0
		Print "Закрываю файл hFile"
	#endif
	If FileHandle <> INVALID_HANDLE_VALUE Then
		CloseHandle(FileHandle)
	End If
End Destructor

Function ProcessGetHeadRequest( _
		ByVal This As IProcessRequest Ptr, _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As WebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal hRequestedFile As Handle _
	)As Boolean
	
	If hRequestedFile = INVALID_HANDLE_VALUE Then
		' TODO Проверить код ошибки через GetLastError, могут быть не только File Not Found.
		' Файла не существет, записать ошибку клиенту
		Dim buf410 As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(buf410, @pWebSite->PathTranslated)
		lstrcat(buf410, @FileGoneExtension)
		
		Dim hFile410 As HANDLE = CreateFile(@buf410, 0, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
		Dim objHFile410 As SafeHandle = Type<SafeHandle>(hFile410)
		If hFile410 = INVALID_HANDLE_VALUE Then
			WriteHttpFileNotFound(pState, ClientSocket, pWebSite)
		Else
			WriteHttpFileGone(pState, ClientSocket, pWebSite)
		End If
		Return False
	End If
	
	' Проверка на CGI
	If NeedCGIProcessing(pState->ClientRequest.ClientUri.Path) Then
		CloseHandle(hRequestedFile)
		Return ProcessCGIRequest(pState, ClientSocket, pWebSite, fileExtention, pClientReader)
	End If
	
	' Проверка на dll-cgi
	If NeedDLLProcessing(pState->ClientRequest.ClientUri.Path) Then
		CloseHandle(hRequestedFile)
		Return ProcessDllCgiRequest(pState, ClientSocket, pWebSite, fileExtention)
	End If
	
	Dim objRequestedFile As SafeHandle = Type<SafeHandle>(hRequestedFile)
	
	Dim mt As MimeType = Any
	If GetMimeOfFileExtension(@mt, fileExtention) = False Then
		WriteHttpForbidden(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' TODO Проверить идентификацию для запароленных ресурсов
	
	' Заголовки сжатия
	Dim hZipFile As Handle = Any
	If mt.IsTextFormat Then
		hZipFile = pState->SetResponseCompression(@pWebSite->PathTranslated)
	Else
		hZipFile = INVALID_HANDLE_VALUE
	End If
	
	Dim objHZipFile As SafeHandle = Type<SafeHandle>(hZipFile)
	
	' Нельзя отображать файлы нулевого размера
	Dim FileSize As LARGE_INTEGER = Any
	Dim GetFileSizeExResult As Integer = Any
	If hZipFile = INVALID_HANDLE_VALUE Then
		GetFileSizeExResult = GetFileSizeEx(hRequestedFile, @FileSize)
	Else
		GetFileSizeExResult = GetFileSizeEx(hZipFile, @FileSize)
	End If
	
	If GetFileSizeExResult = 0 Then
		' TODO узнать причину неудачи через GetLastError() = ERROR_ALREADY_EXISTS
		WriteHttpInternalServerError(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' Строка с типом документа
	Dim wContentType As WString * (2 * MaxContentTypeLength + 1) = Any
	lstrcpy(@wContentType, ContentTypeToString(mt.ContentType))
	
	Dim FileBytesStartIndex As Integer = Any
	
	If mt.IsTextFormat Then
		Dim FileBytes As ZString * (3 + 1) = Any
		Dim BytesReaded As DWORD = Any
		ReadFile(hRequestedFile, @FileBytes, 3, @BytesReaded, 0)
		
		If hZipFile = INVALID_HANDLE_VALUE Then
			
			If FileSize.QuadPart > 3 Then
				
				Select Case GetDocumentCharset(@FileBytes)
					Case DocumentCharsets.Utf8BOM
						lstrcat(@wContentType, @ContentCharsetUtf8)
						FileBytesStartIndex = 3
						
					Case DocumentCharsets.Utf16LE
						lstrcat(wContentType, @ContentCharsetUtf16)
						FileBytesStartIndex = 0
						
					Case DocumentCharsets.Utf16BE
						lstrcat(wContentType, @ContentCharsetUtf16)
						FileBytesStartIndex = 2
						
					Case Else
						FileBytesStartIndex = 0
						
				End Select
				
			Else
				FileBytesStartIndex = 0
			End If
		Else
			FileBytesStartIndex = 0
			
			Select Case GetDocumentCharset(@FileBytes)
				Case DocumentCharsets.ASCII
					' Ничего
					
				Case DocumentCharsets.Utf8BOM
					lstrcat(wContentType, @ContentCharsetUtf8)
					
				Case DocumentCharsets.Utf16LE
					lstrcat(wContentType, @ContentCharsetUtf16)
					
				Case DocumentCharsets.Utf16BE
					lstrcat(wContentType, @ContentCharsetUtf16)
					
			End Select
			
		End If
		Dim liDistanceToMove As LARGE_INTEGER = Any
		liDistanceToMove.QuadPart = FileBytesStartIndex
		
		SetFilePointerEx(hRequestedFile, liDistanceToMove, NULL, FILE_BEGIN)
	Else
		FileBytesStartIndex = 0
	End If
	
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentType) = @wContentType
	pState->AddResponseCacheHeaders(hRequestedFile)
	
	' Добавить пользовательские заголовки ответа
	' TODO Может быть переполнение буфера при слишком длинных заголовках ответа
	Dim sExtHeadersFile As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
	lstrcpy(@sExtHeadersFile, @pWebSite->PathTranslated)
	lstrcat(@sExtHeadersFile, @HeadersExtensionString)
	Dim hExtHeadersFile As HANDLE = CreateFile(@sExtHeadersFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	Dim objHFileExtHeaders As SafeHandle = Type<SafeHandle>(hExtHeadersFile)
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
							pState->ServerResponse.AddResponseHeader(wName, wColon)
						End If
					Loop While lstrlen(w) > 0
				End If
			End If
		End If
	End If
	
	' В основном анализируются заголовки
	' Accept: text/css, */*
	' Accept-Charset: utf-8
	' Accept-Encoding: gzip, deflate
	' Accept-Language: ru-RU
	' User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063
	' Серверу желательно включать в ответ заголовок Vary с указанием параметров,
	' по которым различается содержимое по запрашиваемому URI.
	
	' TODO вместо перезаписывания заголовка его нужно добавить
	If hZipFile <> INVALID_HANDLE_VALUE Then
		pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderVary) = @"Accept-Encoding"
	End If
	
	Select Case pState->ServerResponse.ResponseZipMode
		
		Case ZipModes.GZip
			pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentEncoding) = @GZipString
			
		Case ZipModes.Deflate
			pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentEncoding) = @DeflateString
			
	End Select
	
	' Создать и отправить заголовки ответа
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	Dim BodyLength As Integer = FileSize.QuadPart - FileBytesStartIndex
	Dim HeadersLength As Integer = pState->AllResponseHeadersToBytes(@SendBuffer, BodyLength)
	
	If pState->ServerResponse.SendOnlyHeaders Then
		If send(ClientSocket, @SendBuffer, HeadersLength, 0) = SOCKET_ERROR Then
			Return False
		End If
	Else
		Dim TransmitHeader As TRANSMIT_FILE_BUFFERS = Any
		With TransmitHeader
			.Head = @SendBuffer
			.HeadLength = Cast(DWORD, HeadersLength)
			.Tail = NULL
			.TailLength = Cast(DWORD, 0)
		End With
		
		Dim TransmitResult As Integer = Any
		If hZipFile <> INVALID_HANDLE_VALUE Then
			TransmitResult = TransmitFile(ClientSocket, hZipFile, 0, 0, NULL, @TransmitHeader, 0)
		Else
			TransmitResult = TransmitFile(ClientSocket, hRequestedFile, 0, 0, NULL, @TransmitHeader, 0)
		End If
		
		If TransmitResult = 0 Then
			Return False
		End If
	End If
	
	Return True
End Function
