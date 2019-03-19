#include "WebRequest.bi"

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\shlwapi.bi"
#include "CharacterConstants.bi"
#include "HttpConst.bi"
#include "WebUtils.bi"

Declare Function AddRequestHeader( _
	ByVal pWebRequest As WebRequest Ptr, _
	ByVal Header As WString Ptr, _
	ByVal Value As WString Ptr _
)As Integer

Sub InitializeWebRequest( _
		ByVal pRequest As WebRequest Ptr _
	)
	
	memset(@pRequest->RequestHeaders(0), 0, HttpRequestHeadersMaximum * SizeOf(WString Ptr))
	memset(@pRequest->RequestZipModes(0), 0, WebRequest.MaxRequestZipEnabled * SizeOf(Boolean))
	
	pRequest->KeepAlive = False
	pRequest->RequestByteRange.IsSet = ByteRangeIsSet.NotSet
	pRequest->RequestByteRange.FirstBytePosition = 0
	pRequest->RequestByteRange.LastBytePosition = 0
	pRequest->HttpVersion = HttpVersions.Http11
	pRequest->RequestHeaderBufferLength = 0
	
	InitializeURI(@pRequest->ClientURI)
	
End Sub

Function WebRequest.ReadClientHeaders( _
		ByVal pIClientReader As IHttpReader Ptr _
	)As Boolean
	
	Dim pRequestedLine As WString Ptr = @RequestHeaderBuffer[0]
	Dim RequestedLineLength As Integer = Any
	
	Dim hr As HRESULT = IHttpReader_ReadLine(pIClientReader, _
		pRequestedLine, _
		MaxRequestHeaderBuffer - RequestHeaderBufferLength, _
		@RequestedLineLength _
	)
	
	If FAILED(hr) Then
		
		Select Case hr
			
			Case HTTPREADER_E_INTERNALBUFFEROVERFLOW, HTTPREADER_E_BUFFERTOOSMALL
				SetLastError(ParseRequestLineResult.RequestHeaderFieldsTooLarge)
				
			Case HTTPREADER_E_SOCKETERROR
				SetLastError(ParseRequestLineResult.SocketError)
				
			Case HTTPREADER_E_CLIENTCLOSEDCONNECTION
				SetLastError(ParseRequestLineResult.EmptyRequest)
				
		End Select
		
		Return False
		
	End If
	
	RequestHeaderBufferLength += RequestedLineLength + 1
	
	' Метод, запрошенный ресурс и версия протокола
	' Первый пробел
	Dim pSpace As WString Ptr = StrChr(pRequestedLine, Characters.WhiteSpace)
	If pSpace = 0 Then
		SetLastError(ParseRequestLineResult.BadRequest)
		Return False
	End If
	
	' Удалить пробел и найти начало непробела
	pSpace[0] = 0
	Do
		pSpace += 1
	Loop While pSpace[0] = Characters.WhiteSpace
	
	' Теперь в RequestLine содержится имя метода
	Dim GetHttpMethodResult As Boolean = GetHttpMethod(pRequestedLine, @HttpMethod)
	
	If GetHttpMethodResult = False Then
		SetLastError(ParseRequestLineResult.HpptMethodNotSupported)
		Return False
	End If
	
	' Здесь начинается Url
	ClientURI.Url = pSpace
	
	' Второй пробел
	pSpace = StrChr(pSpace, Characters.WhiteSpace)
	
	If pSpace <> 0 Then
		' Убрать пробел и найти начало непробела
		pSpace[0] = 0
		Do
			pSpace += 1
		Loop While pSpace[0] = Characters.WhiteSpace
		
		' Третий пробел
		If StrChr(ClientURI.Url, Characters.WhiteSpace) <> 0 Then
			' Слишком много пробелов
			SetLastError(ParseRequestLineResult.BadRequest)
			Return False
		End If
		
	End If
	
	Dim GetHttpVersionResult As Boolean = GetHttpVersion(pSpace, @HttpVersion)
	
	If GetHttpVersionResult = False Then
		SetLastError(ParseRequestLineResult.HttpVersionNotSupported)
		Return False
	End If
	
	Select Case HttpVersion
		
		Case HttpVersions.Http11
			KeepAlive = True ' Для версии 1.1 это по умолчанию
			
	End Select
	
	If lstrlen(ClientURI.Url) > URI.MaxUrlLength Then
		SetLastError(ParseRequestLineResult.RequestUrlTooLong)
		Return False
	End If
	
	' Если есть «?», значит там строка запроса
	Dim wQS As WString Ptr = StrChr(ClientURI.Url, Characters.QuestionMark)
	If wQS = 0 Then
		lstrcpy(@ClientURI.Path, ClientURI.Url)
	Else
		ClientURI.QueryString = wQS + 1
		' Получение пути
		wQS[0] = 0 ' убрать вопросительный знак
		lstrcpy(@ClientURI.Path, ClientURI.Url)
		wQS[0] = Characters.QuestionMark ' вернуть, чтобы не портить Url
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
		Dim pLine As WString Ptr = @RequestHeaderBuffer[RequestHeaderBufferLength]
		Dim LineLength As Integer = Any
		
		hr = IHttpReader_ReadLine(pIClientReader, _
			pLine, _
			MaxRequestHeaderBuffer - RequestHeaderBufferLength, _
			@LineLength _
		)
		
		If FAILED(hr) Then
			
			Select Case hr
				
				Case HTTPREADER_E_INTERNALBUFFEROVERFLOW
					SetLastError(ParseRequestLineResult.RequestHeaderFieldsTooLarge)
					
				Case HTTPREADER_E_SOCKETERROR
					SetLastError(ParseRequestLineResult.SocketError)
					
				Case HTTPREADER_E_CLIENTCLOSEDCONNECTION
					SetLastError(ParseRequestLineResult.EmptyRequest)
					
				Case HTTPREADER_E_BUFFERTOOSMALL
					SetLastError(ParseRequestLineResult.RequestHeaderFieldsTooLarge)
					
			End Select
			
			Return False
			
		End If
		
		RequestHeaderBufferLength += LineLength + 1
		
		If LineLength = 0 Then
			' Клиент отправил все данные, можно приступать к обработке
			Exit Do
		End If
		
		If pLine[0] = Characters.WhiteSpace Then
			Do
				pLine += 1
			Loop While pLine[0] = Characters.WhiteSpace
			
			lstrcat(RequestHeaders(PreviousHeaderIndex), pLine)
			
		Else
			
			Dim pColon As WString Ptr = StrChr(pLine, Characters.Colon)
			
			If pColon <> 0 Then
				pColon[0] = 0
				Do
					pColon += 1
				Loop While pColon[0] = Characters.WhiteSpace
				
				PreviousHeaderIndex = AddRequestHeader(@this, pLine, pColon)
				
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
		
		wUTC = StrStr(RequestHeaders(HttpRequestHeaders.HeaderIfUnModifiedSince), "UTC")
		If wUTC <> 0 Then
			lstrcpy(wUTC, "GMT")
		End If
		
		If lstrlen(RequestHeaders(HttpRequestHeaders.HeaderRange)) > 0 Then
			Dim wHeaderRange As WString Ptr = RequestHeaders(HttpRequestHeaders.HeaderRange)
			
			' TODO Обрабатывать несколько байтовых диапазонов
			Dim wCommaChar As WString Ptr = StrChr(wHeaderRange, Characters.Comma)
			If wCommaChar <> 0 Then
				wCommaChar[0] = 0
			End If
			
			Dim wStart As WString Ptr = StrStr(wHeaderRange, "bytes=")
			If wStart = wHeaderRange Then
				wStart = @wHeaderRange[6]
				Dim wStartIndex As WString Ptr = wStart
				
				Dim wHyphenMinusChar As WString Ptr = StrChr(wStart, Characters.HyphenMinus)
				If wHyphenMinusChar <> 0 Then
					wHyphenMinusChar[0] = 0
					Dim wEndIndex As WString Ptr = @wHyphenMinusChar[1]
					
					If StrToInt64Ex(wStartIndex, STIF_DEFAULT, @RequestByteRange.FirstBytePosition) <> 0 Then
						RequestByteRange.IsSet = ByteRangeIsSet.FirstBytePositionIsSet
					End If
					
					If StrToInt64Ex(wEndIndex, STIF_DEFAULT, @RequestByteRange.LastBytePosition) <> 0 Then
						If RequestByteRange.IsSet = ByteRangeIsSet.FirstBytePositionIsSet Then
							RequestByteRange.IsSet = ByteRangeIsSet.FirstAndLastPositionIsSet
						Else
							RequestByteRange.IsSet = ByteRangeIsSet.LastBytePositionIsSet
						End If
					End If
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
