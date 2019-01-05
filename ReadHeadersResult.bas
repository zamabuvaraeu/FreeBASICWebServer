#include "ReadHeadersResult.bi"
#include "win\shlwapi.bi"
#include "win\wincrypt.bi"
#include "WebUtils.bi"
#include "HttpConst.bi"
#include "WebSite.bi"
#include "CharacterConstants.bi"
#include "StringConstants.bi"
#include "IniConst.bi"
#include "Classes\ArrayStringWriter.bi"
#include "IntegerToWString.bi"

Const ColonWithSpaceString = ": "
Const DefaultCacheControl = "max-age=2678400"

Sub InitializeReadHeadersResult( _
		ByVal pState As ReadHeadersResult Ptr _
	)
	InitializeWebRequest(@pState->ClientRequest)
	InitializeWebResponse(@pState->ServerResponse)
End Sub

Function ReadHeadersResult.HttpAuth( _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal ProxyAuthorization As Boolean _
	)As HttpAuthResult
	
	Dim HeaderAuthorization As WString Ptr = Any
	If ProxyAuthorization Then
		If lstrlen(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderProxyAuthorization)) = 0 Then
			HeaderAuthorization = ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderAuthorization)
		Else
			HeaderAuthorization = ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderProxyAuthorization)
		End If
	Else
		HeaderAuthorization = ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderAuthorization)
	End If
	
	If lstrlen(HeaderAuthorization) = 0 Then
		Return HttpAuthResult.NeedAuth
	End If
	
	Dim wSpace As WString Ptr = StrChr(HeaderAuthorization, Characters.WhiteSpace)
	If wSpace = 0 Then
		Return HttpAuthResult.BadAuth
	End If
	
	wSpace[0] = 0
	If lstrcmp(HeaderAuthorization, @BasicAuthorization) <> 0 Then
		Return HttpAuthResult.NeedBasicAuth
	End If
	
	Dim UsernamePasswordUtf8 As ZString * (WebRequest.MaxRequestHeaderBuffer + 1) = Any
	Dim dwUsernamePasswordUtf8Length As DWORD = WebRequest.MaxRequestHeaderBuffer
	
	CryptStringToBinary(wSpace + 1, 0, CRYPT_STRING_BASE64, @UsernamePasswordUtf8, @dwUsernamePasswordUtf8Length, 0, 0)
	
	UsernamePasswordUtf8[dwUsernamePasswordUtf8Length] = 0
	
	' Из массива байт в строку
	' Преобразуем utf8 в WString
	' -1 — значит, длина строки будет проверяться самой функцией по завершающему нулю
	Dim UsernamePassword As WString * (WebRequest.MaxRequestHeaderBuffer + 1) = Any
	MultiByteToWideChar(CP_UTF8, 0, @UsernamePasswordUtf8, -1, @UsernamePassword, WebRequest.MaxRequestHeaderBuffer)
	
	' Теперь wSpace хранит в себе указатель на разделитель‐двоеточие
	wSpace = StrChr(@UsernamePassword, Characters.Colon)
	If wSpace = 0 Then
		Return HttpAuthResult.EmptyPassword
	End If
	
	wSpace[0] = 0 ' Убрали двоеточие
	Dim SettingsFileName As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
	pWebSite->MapPath(@SettingsFileName, @UsersIniFileString)
	
	Dim PasswordBuffer As WString * (255 + 1) = Any
	GetPrivateProfileString(@AdministratorsSectionString, @UsernamePassword, @EmptyString, @PasswordBuffer, 255, @SettingsFileName)
	
	If lstrlen(@PasswordBuffer) = 0 Then
		Return HttpAuthResult.BadUserNamePassword
	End If
	
	If lstrcmp(@PasswordBuffer, wSpace + 1) <> 0 Then
		Return HttpAuthResult.BadUserNamePassword
	End If
	
	Return HttpAuthResult.Success
End Function

Function ReadHeadersResult.SetResponseCompression( _
		ByVal PathTranslated As WString Ptr, _
		ByVal pAcceptEncoding As Boolean Ptr _
	)As Handle
	
	Const GzipExtensionString = ".gz"
	Const DeflateExtensionString = ".deflate"
	
	*pAcceptEncoding = False
	
	Scope
		Dim GZipFileName As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(@GZipFileName, PathTranslated)
		lstrcat(@GZipFileName, @GZipExtensionString)
		
		Dim hFile As HANDLE = CreateFile( _
			@GZipFileName, _
			GENERIC_READ, _
			FILE_SHARE_READ, _
			NULL, _
			OPEN_EXISTING, _
			FILE_ATTRIBUTE_NORMAL Or FILE_FLAG_SEQUENTIAL_SCAN, _
			NULL _
		)
		
		If hFile <> INVALID_HANDLE_VALUE Then
			*pAcceptEncoding = True
			
			If ClientRequest.RequestZipModes(WebRequest.GZipIndex) Then
				ServerResponse.ResponseZipMode = ZipModes.GZip
				Return hFile
			End If
			
			CloseHandle(hFile)
		End If
	End Scope
	
	Scope
		Dim DeflateFileName As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(@DeflateFileName, PathTranslated)
		lstrcat(@DeflateFileName, @DeflateExtensionString)
		
		Dim hFile As HANDLE = CreateFile( _
			@DeflateFileName, _
			GENERIC_READ, _
			FILE_SHARE_READ, _
			NULL, _
			OPEN_EXISTING, _
			FILE_ATTRIBUTE_NORMAL Or FILE_FLAG_SEQUENTIAL_SCAN, _
			NULL _
		)
		
		If hFile <> INVALID_HANDLE_VALUE Then
			*pAcceptEncoding = True
		
			If ClientRequest.RequestZipModes(WebRequest.DeflateIndex) Then
				ServerResponse.ResponseZipMode = ZipModes.Deflate
				Return hFile
			End If
			
			CloseHandle(hFile)
		End If
	End Scope
	
	Return INVALID_HANDLE_VALUE
End Function

Sub ReadHeadersResult.AddResponseCacheHeaders(ByVal hFile As HANDLE)
	Dim IsFileModified As Boolean = True
	
	Dim DateLastFileModified As FILETIME = Any
	If GetFileTime(hFile, 0, 0, @DateLastFileModified) = 0 Then
		Exit Sub
	End If
	
	Scope
		' TODO Уметь распознавать все три HTTP‐формата даты
		Dim dFileLastModified As SYSTEMTIME = Any
		FileTimeToSystemTime(@DateLastFileModified, @dFileLastModified)
		
		Dim strFileLastModifiedHttpDate As WString * 256 = Any
		GetHttpDate(@strFileLastModifiedHttpDate, @dFileLastModified)
		
		ServerResponse.AddKnownResponseHeader(HttpResponseHeaders.HeaderLastModified, @strFileLastModifiedHttpDate)
		
		If lstrlen(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfModifiedSince)) <> 0 Then
			
			Dim wSeparator As WString Ptr = StrChr(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfModifiedSince), Characters.Semicolon)
			If wSeparator <> 0 Then
				wSeparator[0] = 0
			End If
			
			If lstrcmpi(@strFileLastModifiedHttpDate, ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfModifiedSince)) = 0 Then
				IsFileModified = False
			End If
		End If
		
		If lstrlen(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfUnModifiedSince)) <> 0 Then
			
			Dim wSeparator As WString Ptr = StrChr(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfUnModifiedSince), Characters.Semicolon)
			If wSeparator <> 0 Then
				wSeparator[0] = 0
			End If
			
			If lstrcmpi(@strFileLastModifiedHttpDate, ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfUnModifiedSince)) = 0 Then
				IsFileModified = True
			End If
		End If
	End Scope
	
	Scope
		Dim strETag As WString * 256 = Any
		GetETag(@strETag, @DateLastFileModified, ServerResponse.ResponseZipMode)
		
		ServerResponse.AddKnownResponseHeader(HttpResponseHeaders.HeaderEtag, @strETag)
		
		If IsFileModified Then
			If lstrlen(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfNoneMatch)) <> 0 Then
				If lstrcmpi(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfNoneMatch), @strETag) = 0 Then
					IsFileModified = False
				End If
			End If
		End If
		
		If IsFileModified = False Then
			If lstrlen(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfMatch)) <> 0 Then
				If lstrcmpi(ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderIfMatch), @strETag) = 0 Then
					IsFileModified = True
				End If
			End If
		End If
	End Scope
	
	ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderCacheControl) = @DefaultCacheControl
	
	ServerResponse.SendOnlyHeaders OrElse= Not IsFileModified
	If IsFileModified = False Then
		ServerResponse.StatusCode = 304
	End If
End Sub

Function ReadHeadersResult.AllResponseHeadersToBytes( _
		ByVal zBuffer As ZString Ptr, _
		ByVal ContentLength As ULongInt _
	)As Integer
	' TODO Найти способ откатывать изменения буфера заголовков ответа
	
	'ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderServer) = @HttpServerNameString
	
	If ServerResponse.StatusCode <> 206 Then
		ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderAcceptRanges) = @BytesString
	End If
	
	If ClientRequest.KeepAlive Then
		If ClientRequest.HttpVersion = HttpVersions.Http10 Then
			ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderConnection) = @"Keep-Alive"
		End If
	Else
		ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderConnection) = @CloseString
	End If
	
	Select Case ServerResponse.StatusCode
		
		Case 100, 204
			ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentLength) = 0
			
		Case Else
			Dim strContentLength As WString * (64) = Any
			ui64tow(ContentLength, @strContentLength, 10)
			ServerResponse.AddKnownResponseHeader(HttpResponseHeaders.HeaderContentLength, @strContentLength)
			
	End Select
	
	Dim wContentType As WString * (MaxContentTypeLength + 1) = Any
	
	If ServerResponse.Mime.ContentType <> ContentTypes.Unknown Then
		GetContentTypeOfMimeType(@wContentType, @ServerResponse.Mime)
		ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentType) = @wContentType
	End If
	
	Scope
		Dim datNowF As FILETIME = Any
		GetSystemTimeAsFileTime(@datNowF)
		
		Dim datNowS As SYSTEMTIME = Any
		FileTimeToSystemTime(@datNowF, @datNowS)
		
		Dim dtBuffer As WString * (32) = Any
		GetHttpDate(@dtBuffer, @datNowS)
		
		ServerResponse.AddKnownResponseHeader(HttpResponseHeaders.HeaderDate, @dtBuffer)
	End Scope
	
	Dim HeadersWriter As ArrayStringWriter = Any
	
	Dim pIWriter As ITextWriter Ptr = CPtr(ITextWriter Ptr, New(@HeadersWriter) ArrayStringWriter())
	
	pIWriter->pVirtualTable->WriteLengthString(pIWriter, @HttpVersion11, HttpVersion11Length)
	pIWriter->pVirtualTable->WriteChar(pIWriter, Characters.WhiteSpace)
	pIWriter->pVirtualTable->WriteInt32(pIWriter, ServerResponse.StatusCode)
	pIWriter->pVirtualTable->WriteChar(pIWriter, Characters.WhiteSpace)
	
	If ServerResponse.StatusDescription = 0 Then
		Dim BufferLength As Integer = Any
		Dim wBuffer As WString Ptr = GetStatusDescription(ServerResponse.StatusCode, @BufferLength)
		pIWriter->pVirtualTable->WriteLengthStringLine(pIWriter, wBuffer, BufferLength)
	Else
		pIWriter->pVirtualTable->WriteStringLine(pIWriter, ServerResponse.StatusDescription)
	End If
	
	For i As Integer = 0 To WebResponse.ResponseHeaderMaximum - 1
		
		If ServerResponse.ResponseHeaders(i) <> 0 Then
			
			Dim BufferLength As Integer = Any
			Dim wBuffer As WString Ptr = KnownResponseHeaderToString(i, @BufferLength)
			
			pIWriter->pVirtualTable->WriteLengthString(pIWriter, wBuffer, BufferLength)
			pIWriter->pVirtualTable->WriteLengthString(pIWriter, @ColonWithSpaceString, 2)
			pIWriter->pVirtualTable->WriteStringLine(pIWriter, ServerResponse.ResponseHeaders(i))
		End If
	Next
	
	pIWriter->pVirtualTable->WriteNewLine(pIWriter)
	
	Dim pIToString As IStringable Ptr = Any
	pIWriter->pVirtualTable->InheritedTable.QueryInterface(pIWriter, @IID_ISTRINGABLE, @pIToString)
	
	Dim wHeadersBuffer As WString Ptr = Any
	pIToString->pVirtualTable->ToString(pIToString, @wHeadersBuffer)
	
	#if __FB_DEBUG__ <> 0
		' Color RGB(255, 0, 0), RGB(0, 0, 0)
		Print *wHeadersBuffer
	#endif
	
	Dim HeadersLength As Integer = WideCharToMultiByte( _
		CP_UTF8, _
		0, _
		wHeadersBuffer, _
		-1, _
		zBuffer, _
		WebResponse.MaxResponseHeaderBuffer + 1, _
		0, _
		0 _
	) - 1
	
	pIToString->pVirtualTable->InheritedTable.Release(pIToString)
	
	' TODO Запись в лог
	' Dim LogBuffer As ZString * (StreamSocketReader.MaxBufferLength + WebResponse.MaxResponseHeaderBuffer) = Any
	' Dim WriteBytes As DWORD = Any
	' RtlCopyMemory(@LogBuffer, @ClientReader.Buffer, ClientReader.Start)
	' RtlCopyMemory(@LogBuffer + ClientReader.Start, zBuffer, HeadersLength)
	' WriteFile(hOutput, @LogBuffer, ClientReader.Start + HeadersLength, @WriteBytes, 0)
	Return HeadersLength
End Function
