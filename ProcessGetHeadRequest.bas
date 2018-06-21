#include once "ProcessGetHeadRequest.bi"
#include once "HttpConst.bi"
#include once "WriteHttpError.bi"
#include once "Mime.bi"
#include once "WebUtils.bi"
#include once "CharConstants.bi"
#include once "ProcessCgiRequest.bi"
#include once "ProcessDllRequest.bi"
#include "win\Mswsock.bi"

Const MaxTransmitSize As DWORD = 2147483646 - 1 - 1 * 1024 * 1024

Type SafeHandle
	Declare Constructor(ByVal h As HANDLE)
	Declare Destructor()
	Dim WinAPIHandle As HANDLE
End Type

Constructor SafeHandle(ByVal h As HANDLE)
	WinAPIHandle = h
End Constructor

Destructor SafeHandle()
	If WinAPIHandle <> INVALID_HANDLE_VALUE Then
		CloseHandle(WinAPIHandle)
	End If
End Destructor

Function Minimum( _
		ByVal a As ULongInt, _
		ByVal b As ULongInt _
	)As ULongInt
	
	If a < b Then
		Return a
	End If
	
	Return b
End Function

Function GetFileBytesStartingIndex( _
		ByVal wContentType As WString Ptr, _
		ByVal mt As MimeType Ptr, _
		ByVal hRequestedFile As HANDLE, _
		ByVal hZipFile As HANDLE _
	)As LongInt
	
	lstrcpy(wContentType, ContentTypeToString(mt->ContentType))
	
	If mt->IsTextFormat Then
		Const MaxBytesRead As Integer = 15
		Dim FileBytes As ZString * (MaxBytesRead + 1) = Any
		Dim BytesReaded As DWORD = Any
		
		If ReadFile(hRequestedFile, @FileBytes, MaxBytesRead, @BytesReaded, 0) <> 0 Then
			Dim FileBytesStartIndex As LongInt = Any
			
			If hZipFile = INVALID_HANDLE_VALUE Then
				
				If BytesReaded >= 3 Then
					
					Select Case GetDocumentCharset(@FileBytes)
						Case DocumentCharsets.Utf8BOM
							lstrcat(wContentType, @ContentCharsetUtf8)
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
			
			Return FileBytesStartIndex
		End If
	End If
	
	Return 0
End Function

Sub AddExtendedHeaders( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pWebSite As WebSite Ptr _
	)
	
	' TODO Убрать переполнение буфера при слишком длинных заголовках
	Dim wExtHeadersFile As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
	lstrcpy(@wExtHeadersFile, @pWebSite->PathTranslated)
	lstrcat(@wExtHeadersFile, @HeadersExtensionString)
	
	Dim hExtHeadersFile As HANDLE = CreateFile(@wExtHeadersFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL Or FILE_FLAG_SEQUENTIAL_SCAN, NULL)
	
	If hExtHeadersFile <> INVALID_HANDLE_VALUE Then
		Dim zExtHeaders As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
		Dim wExtHeaders As WString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
		
		Dim BytesReaded As DWORD = Any
		If ReadFile(hExtHeadersFile, @zExtHeaders, WebResponse.MaxResponseHeaderBuffer, @BytesReaded, 0) <> 0 Then
			
			If BytesReaded > 2 Then
				zExtHeaders[BytesReaded] = 0
				
				If MultiByteToWideChar(CP_UTF8, 0, @zExtHeaders, -1, @wExtHeaders, WebResponse.MaxResponseHeaderBuffer) > 0 Then
					Dim w As WString Ptr = @wExtHeaders
					
					Do
						Dim wName As WString Ptr = w
						Dim wColon As WString Ptr = StrChr(w, ColonChar)
						
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
		
		CloseHandle(hExtHeadersFile)
	End If
End Sub

Function ProcessGetHeadRequest( _
		ByVal This As IProcessRequest Ptr, _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As WebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal hRequestedFile As Handle _
	)As Boolean
	
	' Проверка существования файла
	If hRequestedFile = INVALID_HANDLE_VALUE Then
		' TODO Проверить код ошибки через GetLastError, могут быть не только File Not Found.
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
	
	' Проверка запрещённого MIME
	Dim mt As MimeType = Any
	If GetMimeOfFileExtension(@mt, fileExtention) = False Then
		WriteHttpForbidden(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' TODO Проверить идентификацию для запароленных ресурсов
	
	' Заголовки сжатия
	Dim hZipFile As Handle = Any
	Dim IsAcceptEncoding As Boolean = Any
	If mt.IsTextFormat Then
		hZipFile = pState->SetResponseCompression(@pWebSite->PathTranslated, @IsAcceptEncoding)
	Else
		hZipFile = INVALID_HANDLE_VALUE
		IsAcceptEncoding = False
	End If
	
	Dim objHZipFile As SafeHandle = Type<SafeHandle>(hZipFile)
	
	Dim FileSize As LARGE_INTEGER = Any
	Dim GetFileSizeExResult As Integer = Any
	If hZipFile = INVALID_HANDLE_VALUE Then
		GetFileSizeExResult = GetFileSizeEx(hRequestedFile, @FileSize)
	Else
		GetFileSizeExResult = GetFileSizeEx(hZipFile, @FileSize)
	End If
	
	If GetFileSizeExResult = 0 Then
		' TODO Оработать код ошибки через GetLastError()
		WriteHttpInternalServerError(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' Строка с типом документа
	Dim wContentType As WString * (2 * MaxContentTypeLength + 1) = Any
	
	Dim FileBytesStartingIndex As LongInt = GetFileBytesStartingIndex(@wContentType, @mt, hRequestedFile, hZipFile)
	
	'/
		' Проверить частичный запрос
		' Выдать только диапазон
		
		' Range: bytes=0-255 — фрагмент от 0-го до 255-го байта включительно.
		
		' Range: bytes=42-42 — запрос одного 42-го байта.
		
		' Range: bytes=4000-7499,1000-2999 — два фрагмента.
		' Так как первый выходит за пределы, то он интерпретируется как «4000-4999».
		
		' Range: bytes=3000-,6000-8055 — первый интерпретируется как «3000-4999»,
		' а второй игнорируется.
		
		' Range: bytes=-400,-9000 — последние 400 байт (от 4600 до 4999),
		' а второй подгоняется под рамки содержимого (от 0 до 4999)
		' обозначая как фрагмент весь объём.
		' Range: bytes=500-799,600-1023,800-849 — при пересечениях диапазоны
		' могут объединяться в один (от 500 до 1023).
	'/
	
	If pState->ClientRequest.RequestByteRange.StartIndexIsSet OrElse pState->ClientRequest.RequestByteRange.EndIndexIsSet Then
		#if __FB_DEBUG__ <> 0
			Print "Байтовый диапазон", pState->ClientRequest.RequestByteRange.StartIndex, pState->ClientRequest.RequestByteRange.EndIndex
		#endif
		'Content-Range: bytes 88080384-160993791/160993792
		'Код ответа статуса успешного HTTP-кода 206 Partial Content указывает, что запрос преуспел, и тело содержит запрошенные диапазоны данных, как описано в заголовке диапазона запроса.
		'Если имеется только один диапазон, для Content-Type для всего ответа задается тип документа и предоставляется Content-Range . 
		'Если несколько диапазонов отправлены обратно, Content-Type устанавливается в multipart/byteranges и каждый фрагмент охватывает один диапазон, с описанием Content-Range и Content-Type описывающим его. 
	End If
	
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentType) = @wContentType
	pState->AddResponseCacheHeaders(hRequestedFile)
	
	AddExtendedHeaders(pState, pWebSite)
	
	' В основном анализируются заголовки
	' Accept: text/css, */*
	' Accept-Charset: utf-8
	' Accept-Encoding: gzip, deflate
	' Accept-Language: ru-RU
	' User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063
	' Серверу желательно включать в ответ заголовок Vary с указанием параметров,
	' по которым различается содержимое по запрашиваемому URI.
	
	' TODO вместо перезаписывания заголовка его нужно добавить
	If IsAcceptEncoding Then
		pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderVary) = @"Accept-Encoding"
	End If
	
	Select Case pState->ServerResponse.ResponseZipMode
		
		Case ZipModes.GZip
			pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentEncoding) = @GZipString
			
		Case ZipModes.Deflate
			pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentEncoding) = @DeflateString
			
	End Select
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	Dim BodyLength As ULongInt = FileSize.QuadPart - FileBytesStartingIndex
	Dim HeadersLength As Integer = pState->AllResponseHeadersToBytes(@SendBuffer, BodyLength)
	
	Dim TransmitHeader As TRANSMIT_FILE_BUFFERS = Any
	With TransmitHeader
		.Head = @SendBuffer
		.HeadLength = Cast(DWORD, HeadersLength)
		.Tail = NULL
		.TailLength = Cast(DWORD, 0)
	End With
	
	Dim hTransmitFile As HANDLE = Any
	If pState->ServerResponse.SendOnlyHeaders Then
		hTransmitFile = NULL
	Else
		If hZipFile <> INVALID_HANDLE_VALUE Then
			hTransmitFile = hZipFile
		Else
			hTransmitFile = hRequestedFile
		End If
	End If
	
	If TransmitFile(ClientSocket, hTransmitFile, Cast(DWORD, Minimum(MaxTransmitSize, BodyLength)), 0, NULL, @TransmitHeader, 0) = 0 Then
		Return False
	End If
	
	If hTransmitFile <> NULL Then
		
		Dim i As ULongInt = 1
		
		Do While BodyLength > Cast(ULongInt, MaxTransmitSize)
			BodyLength -= Cast(ULongInt, MaxTransmitSize)
			
			Dim NewPointer As LARGE_INTEGER = Any
			NewPointer.QuadPart = i * Cast(LongInt, MaxTransmitSize)
			SetFilePointerEx(hTransmitFile, NewPointer, NULL, FILE_BEGIN)
			
			If BodyLength <> 0 Then
				If TransmitFile(ClientSocket, hTransmitFile, Cast(DWORD, Minimum(MaxTransmitSize, BodyLength)), 0, NULL, NULL, 0) = 0 Then
					Return False
				End If
			End If
			
			i += 1
		Loop
		
	End If
	
	Return True
End Function
