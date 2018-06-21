#ifndef unicode
#define unicode
#endif

#include once "WebRequest.bi"
#include once "windows.bi"
#include once "win\shlwapi.bi"
#include once "CharConstants.bi"
#include once "HttpConst.bi"
#include once "WebSite.bi"

Declare Function AddRequestHeader( _
	ByVal pWebRequest As WebRequest Ptr, _
	ByVal Header As WString Ptr, _
	ByVal Value As WString Ptr _
)As Integer

Sub InitializeWebRequest( _
		ByVal pRequest As WebRequest Ptr _
	)
	memset(@pRequest->RequestHeaders(0), 0, WebRequest.RequestHeaderMaximum * SizeOf(WString Ptr))
	memset(@pRequest->RequestZipModes(0), 0, WebRequest.MaxRequestZipEnabled * SizeOf(Boolean))
	pRequest->KeepAlive = False
	pRequest->RequestByteRange.StartIndexIsSet = False
	pRequest->RequestByteRange.EndIndexIsSet = False
	pRequest->RequestByteRange.StartIndex = 0
	pRequest->RequestByteRange.EndIndex = 0
	pRequest->HttpVersion = HttpVersions.Http11
	pRequest->RequestHeaderBufferLength = 0
	InitializeURI(@pRequest->ClientURI)
End Sub

Function WebRequest.ReadClientHeaders( _
		ByVal ClientReader As StreamSocketReader Ptr _
	)As Boolean
	
	Dim wLine As WString Ptr = @RequestHeaderBuffer[RequestHeaderBufferLength]
	
	Dim wLineLength As Integer = Any
	
	If ClientReader->ReadLine(@RequestHeaderBuffer[RequestHeaderBufferLength], MaxRequestHeaderBuffer - RequestHeaderBufferLength, @wLineLength) = False Then
		
		Select Case GetLastError()
			Case StreamSocketReader.BufferOverflowError
				SetLastError(ParseRequestLineResult.RequestHeaderFieldsTooLarge)
				
			Case StreamSocketReader.SocketError
				SetLastError(ParseRequestLineResult.SocketError)
				
			Case StreamSocketReader.ClientClosedSocketError
				SetLastError(ParseRequestLineResult.EmptyRequest)
				
		End Select
		
		Return False
	End If
	
	RequestHeaderBufferLength += wLineLength + 1
	
	' Метод, запрошенный ресурс и версия протокола
	' Первый пробел
	Dim wSpace As WString Ptr = StrChr(wLine, SpaceChar)
	If wSpace = 0 Then
		SetLastError(ParseRequestLineResult.BadRequest)
		Return False
	End If
	
	' Удалить пробел и найти начало непробела
	wSpace[0] = 0
	Do
		wSpace += 1
	Loop While wSpace[0] = SpaceChar
	
	' Теперь в RequestLine содержится имя метода
	HttpMethod = GetHttpMethod(wLine)
	
	' Здесь начинается Url
	ClientURI.Url = wSpace
	
	' Второй пробел
	wSpace = StrChr(wSpace, SpaceChar)
	If wSpace = 0 Then
		' Есть только метод и Url, значит, версия HTTP = 0.9
		HttpVersion = HttpVersions.Http09
	Else
		' Убрать пробел и найти начало непробела
		wSpace[0] = 0
		Do
			wSpace += 1
		Loop While wSpace[0] = SpaceChar
		
		' Третий пробел
		If StrChr(ClientURI.Url, SpaceChar) <> 0 Then
			' Слишком много пробелов
			SetLastError(ParseRequestLineResult.BadRequest)
			Return False
		End If
		
		' Теперь в wSpace находится версия протокола, определить
		If lstrcmp(wSpace, HttpVersion10) = 0 Then
			HttpVersion = HttpVersions.Http10
		Else
			If lstrcmp(wSpace, HttpVersion11) = 0 Then
				HttpVersion = HttpVersions.Http11
				KeepAlive = True ' Для версии 1.1 это по умолчанию
			Else
				' Версия не поддерживается
				SetLastError(ParseRequestLineResult.HTTPVersionNotSupported)
				Return False
			End If
		End If
	End If
	
	If lstrlen(ClientURI.Url) > URI.MaxUrlLength Then
		SetLastError(ParseRequestLineResult.RequestUrlTooLong)
		Return False
	End If
	
	' Если есть «?», значит там строка запроса
	Dim wQS As WString Ptr = StrChr(ClientURI.Url, QuestionMarkChar)
	If wQS = 0 Then
		lstrcpy(@ClientURI.Path, ClientURI.Url)
	Else
		ClientURI.QueryString = wQS + 1
		' Получение пути
		wQS[0] = 0 ' убрать вопросительный знак
		lstrcpy(@ClientURI.Path, ClientURI.Url)
		wQS[0] = &h3F ' вернуть, чтобы не портить Url
	End If
	
	' Раскодировка пути
	If StrChr(@ClientURI.Path, PercentSign) <> 0 Then
		Dim DecodedPath As WString * (ClientURI.MaxUrlLength + 1) = Any
		ClientURI.PathDecode(@DecodedPath)
		lstrcpy(@ClientURI.Path, @DecodedPath)
	End If
	
	If IsBadPath(@ClientURI.Path) Then
		SetLastError(ParseRequestLineResult.BadPath)
		Return False
	End If
	
	' Получить все заголовки запроса
	Dim PreviousHeaderIndex As Integer = -1
	Do
		wLine = @RequestHeaderBuffer[RequestHeaderBufferLength]
		
		If ClientReader->ReadLine(@RequestHeaderBuffer[RequestHeaderBufferLength], MaxRequestHeaderBuffer - RequestHeaderBufferLength, @wLineLength) = False Then
			
			Select Case GetLastError()
				Case StreamSocketReader.BufferOverflowError
					SetLastError(ParseRequestLineResult.RequestHeaderFieldsTooLarge)
					
				Case StreamSocketReader.SocketError
					SetLastError(ParseRequestLineResult.SocketError)
					
				Case StreamSocketReader.ClientClosedSocketError
					SetLastError(ParseRequestLineResult.EmptyRequest)
					
			End Select
			
			Return False
		End If
		
		RequestHeaderBufferLength += wLineLength + 1
		
		If lstrlen(wLine) = 0 Then
			' Клиент отправил все данные, можно приступать к обработке
			Exit Do
		End If
		
		If wLine[0] = SpaceChar Then
			Do
				wLine += 1
			Loop While wLine[0] = SpaceChar
			lstrcat(RequestHeaders(PreviousHeaderIndex), wLine)
			
		Else
			
			Dim wColon As WString Ptr = StrChr(wLine, ColonChar)
			If wColon <> 0 Then
				wColon[0] = 0
				Do
					wColon += 1
				Loop While wColon[0] = SpaceChar
				
				PreviousHeaderIndex = AddRequestHeader(@this, wLine, wColon)
				
			End If
		End If
	Loop
	
	Scope
		If StrStrI(RequestHeaders(HttpRequestHeaders.HeaderConnection), @CloseString) <> 0 Then
			KeepAlive = False
		Else
			If StrStrI(RequestHeaders(HttpRequestHeaders.HeaderConnection), @"Keep-Alive") <> 0 Then
				KeepAlive = True
			End If
		End If
			
		If StrStrI(RequestHeaders(HttpRequestHeaders.HeaderAcceptEncoding), @GzipString) <> 0 Then
			RequestZipModes(GZipIndex) = True
		End If
		If StrStrI(RequestHeaders(HttpRequestHeaders.HeaderAcceptEncoding), @DeflateString) <> 0 Then
			RequestZipModes(DeflateIndex) = True
		End If
			
		' Убрать UTC и заменить на GMT
		'If-Modified-Since: Thu, 24 Mar 2016 16:10:31 UTC
		'If-Modified-Since: Tue, 11 Mar 2014 20:07:57 GMT
		Dim wUTC As WString Ptr = StrStr(RequestHeaders(HttpRequestHeaders.HeaderIfModifiedSince), "UTC")
		If wUTC <> 0 Then
			lstrcpy(wUTC, "GMT")
		End If
		
		If lstrlen(RequestHeaders(HttpRequestHeaders.HeaderRange)) > 0 Then
			Dim wHeaderRange As WString Ptr = RequestHeaders(HttpRequestHeaders.HeaderRange)
			
			' TODO Обрабатывать несколько байтовых диапазонов
			Dim wCommaChar As WString Ptr = StrChr(wHeaderRange, CommaChar)
			If wCommaChar <> 0 Then
				wCommaChar[0] = 0
			End If
			
			Dim wStart As WString Ptr = StrStr(wHeaderRange, "bytes=")
			If wStart = wHeaderRange Then
				wStart = @wHeaderRange[6]
				Dim wStartIndex As WString Ptr = wStart
				
				Dim wHyphenMinusChar As WString Ptr = StrChr(wStart, HyphenMinusChar)
				If wHyphenMinusChar <> 0 Then
					wHyphenMinusChar[0] = 0
					Dim wEndIndex As WString Ptr = @wHyphenMinusChar[1]
					
					RequestByteRange.StartIndexIsSet = StrToInt64Ex(wStartIndex, STIF_DEFAULT, @RequestByteRange.StartIndex)
					RequestByteRange.EndIndexIsSet = StrToInt64Ex(wEndIndex, STIF_DEFAULT, @RequestByteRange.EndIndex)
				Else
					SetLastError(ParseRequestLineResult.BadRequest)
					Return False
				End If
			Else
				SetLastError(ParseRequestLineResult.BadRequest)
				Return False
			End If
		End If
	End Scope
	
	SetLastError(ParseRequestLineResult.Success)
	Return True
End Function

Function AddRequestHeader( _
		ByVal pWebRequest As WebRequest Ptr, _
		ByVal Header As WString Ptr, _
		ByVal Value As WString Ptr _
	)As Integer
	Dim HeaderIndex As HttpRequestHeaders = Any
	If GetKnownRequestHeader(Header, @HeaderIndex) = False Then
		' TODO Добавить в нераспознанные заголовки запроса
		Return -1
	End If
	
	pWebRequest->RequestHeaders(HeaderIndex) = Value
	Return HeaderIndex
End Function
