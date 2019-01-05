#include "Http.bi"

#ifndef unicode
#define unicode
#endif
#include "windows.bi"

Const HttpMethodCopy =     "COPY"
Const HttpMethodConnect =  "CONNECT"
Const HttpMethodDelete =   "DELETE"
Const HttpMethodGet =      "GET"
Const HttpMethodHead =     "HEAD"
Const HttpMethodMove =     "MOVE"
Const HttpMethodOptions =  "OPTIONS"
Const HttpMethodPatch =    "PATCH"
Const HttpMethodPost =     "POST"
Const HttpMethodPropfind = "PROPFIND"
Const HttpMethodPut =      "PUT"
Const HttpMethodTrace =    "TRACE"

Const HttpMethodCopyLength As Integer =     4
Const HttpMethodConnectLength As Integer =  7
Const HttpMethodDeleteLength As Integer =   6
Const HttpMethodGetLength As Integer =      3
Const HttpMethodHeadLength As Integer =     4
Const HttpMethodMoveLength As Integer =     4
Const HttpMethodOptionsLength As Integer =  7
Const HttpMethodPatchLength As Integer =    5
Const HttpMethodPostLength As Integer =     4
Const HttpMethodPropfindLength As Integer = 8
Const HttpMethodPutLength As Integer =      3
Const HttpMethodTraceLength As Integer =    5

Const HeaderAcceptString =             "Accept"
Const HeaderAcceptCharsetString =      "Accept-Charset"
Const HeaderAcceptEncodingString =     "Accept-Encoding"
Const HeaderAcceptLanguageString =     "Accept-Language"
Const HeaderAcceptRangesString =       "Accept-Ranges"
Const HeaderAgeString =                "Age"
Const HeaderConnectionString =         "Connection"
Const HeaderCacheControlString =       "Cache-Control"
Const HeaderDateString =               "Date"
Const HeaderKeepAliveString =          "Keep-Alive"
Const HeaderPragmaString =             "Pragma"
Const HeaderTrailerString =            "Trailer"
Const HeaderTransferEncodingString =   "Transfer-Encoding"
Const HeaderUpgradeString =            "Upgrade"
Const HeaderViaString =                "Via"
Const HeaderWarningString =            "Warning"
Const HeaderAllowString =              "Allow"
Const HeaderContentLengthString =      "Content-Length"
Const HeaderContentTypeString =        "Content-Type"
Const HeaderContentEncodingString =    "Content-Encoding"
Const HeaderContentLanguageString =    "Content-Language"
Const HeaderContentLocationString =    "Content-Location"
Const HeaderContentMd5String =         "Content-MD5"
Const HeaderContentRangeString =       "Content-Range"
Const HeaderExpiresString =            "Expires"
Const HeaderLastModifiedString =       "Last-Modified"
Const HeaderAuthorizationString =      "Authorization"
Const HeaderCookieString =             "Cookie"
Const HeaderExpectString =             "Expect"
Const HeaderFromString =               "From"
Const HeaderHostString =               "Host"
Const HeaderIfMatchString =            "If-Match"
Const HeaderIfModifiedSinceString =    "If-Modified-Since"
Const HeaderIfNoneMatchString =        "If-None-Match"
Const HeaderIfRangeString =            "If-Range"
Const HeaderIfUnmodifiedSinceString =  "If-Unmodified-Since"
Const HeaderMaxForwardsString =        "Max-Forwards"
Const HeaderProxyAuthorizationString = "Proxy-Authorization"
Const HeaderRefererString =            "Referer"
Const HeaderRangeString =              "Range"
Const HeaderTeString =                 "TE"
Const HeaderUserAgentString =          "User-Agent"
Const HeaderETagString =               "ETag"
Const HeaderLocationString =           "Location"
Const HeaderProxyAuthenticateString =  "Proxy-Authenticate"
Const HeaderRetryAfterString =         "Retry-After"
Const HeaderServerString =             "Server"
Const HeaderSetCookieString =          "Set-Cookie"
Const HeaderVaryString =               "Vary"
Const HeaderWWWAuthenticateString =    "WWW-Authenticate"

Const HeaderAcceptRangesStringLength As Integer =      13
Const HeaderAgeStringLength As Integer =               3
Const HeaderAllowStringLength As Integer =             5
Const HeaderCacheControlStringLength As Integer =      13
Const HeaderConnectionStringLength As Integer =        10
Const HeaderContentEncodingStringLength As Integer =   16
Const HeaderContentLengthStringLength As Integer =     14
Const HeaderContentLanguageStringLength As Integer =   16
Const HeaderContentLocationStringLength As Integer =   16
Const HeaderContentMd5StringLength As Integer =        11
Const HeaderContentRangeStringLength As Integer =      13
Const HeaderContentTypeStringLength As Integer =       12
Const HeaderDateStringLength As Integer =              4
Const HeaderETagStringLength As Integer =              4
Const HeaderExpiresStringLength As Integer =           7
Const HeaderKeepAliveStringLength As Integer =         10
Const HeaderLastModifiedStringLength As Integer =      13
Const HeaderLocationStringLength As Integer =          8
Const HeaderPragmaStringLength As Integer =            6
Const HeaderProxyAuthenticateStringLength As Integer = 18
Const HeaderRetryAfterStringLength As Integer =        11
Const HeaderServerStringLength As Integer =            6
Const HeaderSetCookieStringLength As Integer =         10
Const HeaderTrailerStringLength As Integer =           7
Const HeaderTransferEncodingStringLength As Integer =  17
Const HeaderUpgradeStringLength As Integer =           7
Const HeaderVaryStringLength As Integer =              4
Const HeaderViaStringLength As Integer =               3
Const HeaderWarningStringLength As Integer =           7
Const HeaderWWWAuthenticateStringLength As Integer =   16

Const HttpStatusCodeString100 = "Continue"
Const HttpStatusCodeString101 = "Switching Protocols"
Const HttpStatusCodeString102 = "Processing"

Const HttpStatusCodeString200 = "OK"
Const HttpStatusCodeString201 = "Created"
Const HttpStatusCodeString202 = "Accepted"
Const HttpStatusCodeString203 = "Non-Authoritative Information"
Const HttpStatusCodeString204 = "No Content"
Const HttpStatusCodeString205 = "Reset Content"
Const HttpStatusCodeString206 = "Partial Content"
Const HttpStatusCodeString207 = "Multi-Status"
Const HttpStatusCodeString226 = "IM Used"

Const HttpStatusCodeString300 = "Multiple Choices"
Const HttpStatusCodeString301 = "Moved Permanently"
Const HttpStatusCodeString302 = "Found"
Const HttpStatusCodeString303 = "See Other"
Const HttpStatusCodeString304 = "Not Modified"
Const HttpStatusCodeString305 = "Use Proxy"
Const HttpStatusCodeString307 = "Temporary Redirect"

Const HttpStatusCodeString400 = "Bad Request"
Const HttpStatusCodeString401 = "Unauthorized"
Const HttpStatusCodeString402 = "Payment Required"
Const HttpStatusCodeString403 = "Forbidden"
Const HttpStatusCodeString404 = "Not Found"
Const HttpStatusCodeString405 = "Method Not Allowed"
Const HttpStatusCodeString406 = "Not Acceptable"
Const HttpStatusCodeString407 = "Proxy Authentication Required"
Const HttpStatusCodeString408 = "Request Timeout"
Const HttpStatusCodeString409 = "Conflict"
Const HttpStatusCodeString410 = "Gone"
Const HttpStatusCodeString411 = "Length Required"
Const HttpStatusCodeString412 = "Precondition Failed"
Const HttpStatusCodeString413 = "Request Entity Too Large"
Const HttpStatusCodeString414 = "Request-URI Too Large"
Const HttpStatusCodeString415 = "Unsupported Media Type"
Const HttpStatusCodeString416 = "Requested Range Not Satisfiable"
Const HttpStatusCodeString417 = "Expectation Failed"
Const HttpStatusCodeString418 = "I am a teapot"
Const HttpStatusCodeString422 = "Unprocessable Entity"
Const HttpStatusCodeString423 = "Locked"
Const HttpStatusCodeString424 = "Failed Dependency"
Const HttpStatusCodeString425 = "Unordered Collection"
Const HttpStatusCodeString426 = "Upgrade Required"
Const HttpStatusCodeString428 = "Precondition Required"
Const HttpStatusCodeString429 = "Too Many Requests"
Const HttpStatusCodeString431 = "Request Header Fields Too Large"
Const HttpStatusCodeString449 = "Retry With"
Const HttpStatusCodeString451 = "Unavailable For Legal Reasons"

Const HttpStatusCodeString500 = "Internal Server Error"
Const HttpStatusCodeString501 = "Not Implemented"
Const HttpStatusCodeString502 = "Bad Gateway"
Const HttpStatusCodeString503 = "Service Unavailable"
Const HttpStatusCodeString504 = "Gateway Timeout"
Const HttpStatusCodeString505 = "HTTP Version Not Supported"
Const HttpStatusCodeString506 = "Variant Also Negotiates"
Const HttpStatusCodeString507 = "Insufficient Storage"
Const HttpStatusCodeString508 = "Loop Detected"
Const HttpStatusCodeString509 = "Bandwidth Limit Exceeded"
Const HttpStatusCodeString510 = "Not Extended"
Const HttpStatusCodeString511 = "Network Authentication Required"

Const HttpStatusCodeString100Length As Integer = 8
Const HttpStatusCodeString101Length As Integer = 19
Const HttpStatusCodeString102Length As Integer = 10

Const HttpStatusCodeString200Length As Integer = 2
Const HttpStatusCodeString201Length As Integer = 7
Const HttpStatusCodeString202Length As Integer = 8
Const HttpStatusCodeString203Length As Integer = 29
Const HttpStatusCodeString204Length As Integer = 10
Const HttpStatusCodeString205Length As Integer = 13
Const HttpStatusCodeString206Length As Integer = 15
Const HttpStatusCodeString207Length As Integer = 12
Const HttpStatusCodeString226Length As Integer = 7

Const HttpStatusCodeString300Length As Integer = 16
Const HttpStatusCodeString301Length As Integer = 17
Const HttpStatusCodeString302Length As Integer = 5
Const HttpStatusCodeString303Length As Integer = 9
Const HttpStatusCodeString304Length As Integer = 12
Const HttpStatusCodeString305Length As Integer = 9
Const HttpStatusCodeString307Length As Integer = 18

Const HttpStatusCodeString400Length As Integer = 11
Const HttpStatusCodeString401Length As Integer = 12
Const HttpStatusCodeString402Length As Integer = 16
Const HttpStatusCodeString403Length As Integer = 9
Const HttpStatusCodeString404Length As Integer = 9
Const HttpStatusCodeString405Length As Integer = 18
Const HttpStatusCodeString406Length As Integer = 14
Const HttpStatusCodeString407Length As Integer = 29
Const HttpStatusCodeString408Length As Integer = 15
Const HttpStatusCodeString409Length As Integer = 8
Const HttpStatusCodeString410Length As Integer = 4
Const HttpStatusCodeString411Length As Integer = 15
Const HttpStatusCodeString412Length As Integer = 19
Const HttpStatusCodeString413Length As Integer = 24
Const HttpStatusCodeString414Length As Integer = 21
Const HttpStatusCodeString415Length As Integer = 22
Const HttpStatusCodeString416Length As Integer = 31
Const HttpStatusCodeString417Length As Integer = 18
Const HttpStatusCodeString418Length As Integer = 13
Const HttpStatusCodeString422Length As Integer = 20
Const HttpStatusCodeString423Length As Integer = 6
Const HttpStatusCodeString424Length As Integer = 17
Const HttpStatusCodeString425Length As Integer = 20
Const HttpStatusCodeString426Length As Integer = 16
Const HttpStatusCodeString428Length As Integer = 21
Const HttpStatusCodeString429Length As Integer = 17
Const HttpStatusCodeString431Length As Integer = 31
Const HttpStatusCodeString449Length As Integer = 10
Const HttpStatusCodeString451Length As Integer = 29

Const HttpStatusCodeString500Length As Integer = 21
Const HttpStatusCodeString501Length As Integer = 15
Const HttpStatusCodeString502Length As Integer = 11
Const HttpStatusCodeString503Length As Integer = 19
Const HttpStatusCodeString504Length As Integer = 15
Const HttpStatusCodeString505Length As Integer = 26
Const HttpStatusCodeString506Length As Integer = 23
Const HttpStatusCodeString507Length As Integer = 20
Const HttpStatusCodeString508Length As Integer = 13
Const HttpStatusCodeString509Length As Integer = 24
Const HttpStatusCodeString510Length As Integer = 12
Const HttpStatusCodeString511Length As Integer = 31

Function GetHttpMethod( _
		ByVal s As WString Ptr _
	)As HttpMethods
	
	If lstrcmp(s, HttpMethodGet) = 0 Then
		Return HttpMethods.HttpGet
	End If
	
	If lstrcmp(s, HttpMethodHead) = 0 Then
		Return HttpMethods.HttpHead
	End If
	
	If lstrcmp(s, HttpMethodPost) = 0 Then
		Return HttpMethods.HttpPost
	End If
	
	If lstrcmp(s, HttpMethodPut) = 0 Then
		Return HttpMethods.HttpPut
	End If
	
	If lstrcmp(s, HttpMethodConnect) = 0 Then
		Return HttpMethods.HttpConnect
	End If
	
	If lstrcmp(s, HttpMethodDelete) = 0 Then
		Return HttpMethods.HttpDelete
	End If
	
	If lstrcmp(s, HttpMethodOptions) = 0 Then
		Return HttpMethods.HttpOptions
	End If
	
	If lstrcmp(s, HttpMethodTrace) = 0 Then
		Return HttpMethods.HttpTrace
	End If
	
	Return HttpMethods.Unknown
End Function

Function HttpMethodToString( _
		ByVal HttpMethod As HttpMethods, _
		ByVal BufferLength As Integer Ptr _
	)As WString Ptr
	
	Dim intBufferLength As Integer = 0
	Select Case HttpMethod
		Case HttpMethods.HttpGet
			intBufferLength = HttpMethodGetLength
			HttpMethodToString = @HttpMethodGet
			
		Case HttpMethods.HttpHead
			intBufferLength = HttpMethodHeadLength
			HttpMethodToString = @HttpMethodHead
			
		Case HttpMethods.HttpPost
			intBufferLength = HttpMethodPostLength
			HttpMethodToString = @HttpMethodPost
			
		Case HttpMethods.HttpPut
			intBufferLength = HttpMethodPutLength
			HttpMethodToString = @HttpMethodPut
			
		Case HttpMethods.HttpDelete
			intBufferLength = HttpMethodDeleteLength
			HttpMethodToString = @HttpMethodDelete
			
		Case HttpMethods.HttpOptions
			intBufferLength = HttpMethodOptionsLength
			HttpMethodToString = @HttpMethodOptions
			
		Case HttpMethods.HttpTrace
			intBufferLength = HttpMethodTraceLength
			HttpMethodToString = @HttpMethodTrace
			
		Case HttpMethods.HttpConnect
			intBufferLength = HttpMethodConnectLength
			HttpMethodToString = @HttpMethodConnect
			
		Case HttpMethods.HttpPatch
			intBufferLength = HttpMethodPatchLength
			HttpMethodToString = @HttpMethodPatch
			
		Case HttpMethods.HttpCopy
			intBufferLength = HttpMethodCopyLength
			HttpMethodToString = @HttpMethodCopy
			
		Case HttpMethods.HttpMove
			intBufferLength = HttpMethodMoveLength
			HttpMethodToString = @HttpMethodMove
			
		Case HttpMethods.HttpPropfind
			intBufferLength = HttpMethodPropfindLength
			HttpMethodToString = @HttpMethodPropfind
			
		Case Else
			intBufferLength = 0
			HttpMethodToString = 0
			
	End Select
	
	If BufferLength <> 0 Then
		*BufferLength = intBufferLength
	End If
End Function

Function GetKnownRequestHeader( _
		ByVal wHeader As WString Ptr, _
		ByVal pHeader As HttpRequestHeaders Ptr _
	)As Boolean
	If lstrcmpi(wHeader, HeaderAcceptString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderAccept
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderAcceptCharsetString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderAcceptCharset
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderAcceptEncodingString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderAcceptEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderAcceptLanguageString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderAcceptLanguage
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderAuthorizationString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderAuthorization
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderCacheControlString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderCacheControl
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderConnectionString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderConnection
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentEncodingString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentLanguageString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentLanguage
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentLengthString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentLength
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentMd5String) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentMd5
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentRangeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentRange
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderContentTypeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderContentType
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderCookieString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderCookie
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderExpectString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderExpect
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderFromString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderFrom
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderHostString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderHost
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderIfMatchString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderIfMatch
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderIfModifiedSinceString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderIfModifiedSince
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderIfNoneMatchString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderIfNoneMatch
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderIfRangeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderIfRange
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderIfUnmodifiedSinceString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderIfUnmodifiedSince
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderKeepAliveString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderKeepAlive
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderMaxForwardsString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderMaxForwards
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderPragmaString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderPragma
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderProxyAuthorizationString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderProxyAuthorization
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderRangeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderRange
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderRefererString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderReferer
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderTeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderTe
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderTrailerString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderTrailer
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderTransferEncodingString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderTransferEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderUpgradeString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderUpgrade
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderTransferEncodingString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderTransferEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderUserAgentString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderUserAgent
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderViaString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderVia
		Return True
	End If
	
	If lstrcmpi(wHeader, HeaderWarningString) = 0 Then
		*pHeader = HttpRequestHeaders.HeaderWarning
		Return True
	End If
	
	*pHeader = 0
	Return False
	
End Function

Function GetKnownResponseHeader( _
		ByVal wHeader As WString Ptr, _
		ByVal pHeader As HttpResponseHeaders Ptr _
	)As Boolean
	
	If lstrcmpi(wHeader, @HeaderAcceptRangesString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderAcceptRanges
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderAgeString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderAge
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderAllowString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderAllow
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderCacheControlString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderCacheControl
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderConnectionString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderConnection
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentEncodingString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentLanguageString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentLanguage
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentLengthString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentLength
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentLocationString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentLocation
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentMd5String) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentMd5
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentRangeString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentRange
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderContentTypeString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderContentType
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderDateString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderDate
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderETagString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderETag
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderExpiresString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderExpires
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderKeepAliveString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderKeepAlive
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderLastModifiedString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderLastModified
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderLocationString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderLocation
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderPragmaString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderPragma
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderProxyAuthenticateString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderProxyAuthenticate
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderRetryAfterString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderRetryAfter
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderServerString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderServer
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderSetCookieString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderSetCookie
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderTrailerString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderTrailer
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderTransferEncodingString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderTransferEncoding
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderUpgradeString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderUpgrade
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderVaryString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderVary
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderViaString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderVia
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderWarningString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderWarning
		Return True
	End If
	
	If lstrcmpi(wHeader, @HeaderWWWAuthenticateString) = 0 Then
		*pHeader = HttpResponseHeaders.HeaderWwwAuthenticate
		Return True
	End If
	
	*pHeader = 0
	Return False
	
End Function

Function KnownResponseHeaderToString( _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal BufferLength As Integer Ptr _
	)As WString Ptr
	
	Dim intBufferLength As Integer = 0
	Select Case HeaderIndex
		
		Case HttpResponseHeaders.HeaderAcceptRanges
			intBufferLength = HeaderAcceptRangesStringLength
			KnownResponseHeaderToString = @HeaderAcceptRangesString
			
		Case HttpResponseHeaders.HeaderAge
			intBufferLength = HeaderAgeStringLength
			KnownResponseHeaderToString = @HeaderAgeString
			
		Case HttpResponseHeaders.HeaderAllow
			intBufferLength = HeaderAllowStringLength
			KnownResponseHeaderToString = @HeaderAllowString
			
		Case HttpResponseHeaders.HeaderCacheControl
			intBufferLength = HeaderCacheControlStringLength
			KnownResponseHeaderToString = @HeaderCacheControlString
			
		Case HttpResponseHeaders.HeaderConnection
			intBufferLength = HeaderConnectionStringLength
			KnownResponseHeaderToString = @HeaderConnectionString
			
		Case HttpResponseHeaders.HeaderContentEncoding
			intBufferLength = HeaderContentEncodingStringLength
			KnownResponseHeaderToString = @HeaderContentEncodingString
			
		Case HttpResponseHeaders.HeaderContentLength
			intBufferLength = HeaderContentLengthStringLength
			KnownResponseHeaderToString = @HeaderContentLengthString
			
		Case HttpResponseHeaders.HeaderContentLanguage
			intBufferLength = HeaderContentLanguageStringLength
			KnownResponseHeaderToString = @HeaderContentLanguageString
			
		Case HttpResponseHeaders.HeaderContentLocation
			intBufferLength = HeaderContentLocationStringLength
			KnownResponseHeaderToString = @HeaderContentLocationString
			
		Case HttpResponseHeaders.HeaderContentMd5
			intBufferLength = HeaderContentMd5StringLength
			KnownResponseHeaderToString = @HeaderContentMd5String
			
		Case HttpResponseHeaders.HeaderContentRange
			intBufferLength = HeaderContentRangeStringLength
			KnownResponseHeaderToString = @HeaderContentRangeString
			
		Case HttpResponseHeaders.HeaderContentType
			intBufferLength = HeaderContentTypeStringLength
			KnownResponseHeaderToString = @HeaderContentTypeString
			
		Case HttpResponseHeaders.HeaderDate
			intBufferLength = HeaderDateStringLength
			KnownResponseHeaderToString = @HeaderDateString
			
		Case HttpResponseHeaders.HeaderEtag
			intBufferLength = HeaderETagStringLength
			KnownResponseHeaderToString = @HeaderETagString
			
		Case HttpResponseHeaders.HeaderExpires
			intBufferLength = HeaderExpiresStringLength
			KnownResponseHeaderToString = @HeaderExpiresString
			
		Case HttpResponseHeaders.HeaderKeepAlive
			intBufferLength = HeaderKeepAliveStringLength
			KnownResponseHeaderToString = @HeaderKeepAliveString
			
		Case HttpResponseHeaders.HeaderLastModified
			intBufferLength = HeaderLastModifiedStringLength
			KnownResponseHeaderToString = @HeaderLastModifiedString
			
		Case HttpResponseHeaders.HeaderLocation
			intBufferLength = HeaderLocationStringLength
			KnownResponseHeaderToString = @HeaderLocationString
			
		Case HttpResponseHeaders.HeaderPragma
			intBufferLength = HeaderPragmaStringLength
			KnownResponseHeaderToString = @HeaderPragmaString
			
		Case HttpResponseHeaders.HeaderProxyAuthenticate
			intBufferLength = HeaderProxyAuthenticateStringLength
			KnownResponseHeaderToString = @HeaderProxyAuthenticateString
			
		Case HttpResponseHeaders.HeaderRetryAfter
			intBufferLength = HeaderRetryAfterStringLength
			KnownResponseHeaderToString = @HeaderRetryAfterString
			
		Case HttpResponseHeaders.HeaderServer
			intBufferLength = HeaderServerStringLength
			KnownResponseHeaderToString = @HeaderServerString
			
		Case HttpResponseHeaders.HeaderSetCookie
			intBufferLength = HeaderSetCookieStringLength
			KnownResponseHeaderToString = @HeaderSetCookieString
			
		Case HttpResponseHeaders.HeaderTrailer
			intBufferLength = HeaderTrailerStringLength
			KnownResponseHeaderToString = @HeaderTrailerString
			
		Case HttpResponseHeaders.HeaderTransferEncoding
			intBufferLength = HeaderTransferEncodingStringLength
			KnownResponseHeaderToString = @HeaderTransferEncodingString
			
		Case HttpResponseHeaders.HeaderUpgrade
			intBufferLength = HeaderUpgradeStringLength
			KnownResponseHeaderToString = @HeaderUpgradeString
			
		Case HttpResponseHeaders.HeaderVary
			intBufferLength = HeaderVaryStringLength
			KnownResponseHeaderToString = @HeaderVaryString
			
		Case HttpResponseHeaders.HeaderVia
			intBufferLength = HeaderViaStringLength
			KnownResponseHeaderToString = @HeaderViaString
			
		Case HttpResponseHeaders.HeaderWarning
			intBufferLength = HeaderWarningStringLength
			KnownResponseHeaderToString = @HeaderWarningString
			
		Case HttpResponseHeaders.HeaderWwwAuthenticate
			intBufferLength = HeaderWWWAuthenticateStringLength
			KnownResponseHeaderToString = @HeaderWWWAuthenticateString
			
		Case Else
			intBufferLength = 0
			KnownResponseHeaderToString = 0
			
	End Select
	
	If BufferLength <> 0 Then
		*BufferLength = intBufferLength
	End If
End Function

Function GetStatusDescription( _
		ByVal StatusCode As Integer, _
		ByVal BufferLength As Integer Ptr _
	)As WString Ptr
	
	Dim intBufferLength As Integer = 0
	
	Select Case StatusCode
		
		Case 100
			intBufferLength = HttpStatusCodeString100Length
			GetStatusDescription = @HttpStatusCodeString100
			
		Case 101
			intBufferLength = HttpStatusCodeString101Length
			GetStatusDescription = @HttpStatusCodeString101
			
		Case 102
			intBufferLength = HttpStatusCodeString102Length
			GetStatusDescription = @HttpStatusCodeString102
			
		Case 200
			intBufferLength = HttpStatusCodeString200Length
			GetStatusDescription = @HttpStatusCodeString200
			
		Case 201
			intBufferLength = HttpStatusCodeString201Length
			GetStatusDescription = @HttpStatusCodeString201
			
		Case 202
			intBufferLength = HttpStatusCodeString202Length
			GetStatusDescription = @HttpStatusCodeString202
			
		Case 203
			intBufferLength = HttpStatusCodeString203Length
			GetStatusDescription = @HttpStatusCodeString203
			
		Case 204
			intBufferLength = HttpStatusCodeString204Length
			GetStatusDescription = @HttpStatusCodeString204
			
		Case 205
			intBufferLength = HttpStatusCodeString205Length
			GetStatusDescription = @HttpStatusCodeString205
			
		Case 206
			intBufferLength = HttpStatusCodeString206Length
			GetStatusDescription = @HttpStatusCodeString206
			
		Case 207
			intBufferLength = HttpStatusCodeString207Length
			GetStatusDescription = @HttpStatusCodeString207
			
		Case 226
			intBufferLength = HttpStatusCodeString226Length
			GetStatusDescription = @HttpStatusCodeString226
			
		Case 300
			intBufferLength = HttpStatusCodeString300Length
			GetStatusDescription = @HttpStatusCodeString300
			
		Case 301
			intBufferLength = HttpStatusCodeString301Length
			GetStatusDescription = @HttpStatusCodeString301
			
		Case 302
			intBufferLength = HttpStatusCodeString302Length
			GetStatusDescription = @HttpStatusCodeString302
			
		Case 303
			intBufferLength = HttpStatusCodeString303Length
			GetStatusDescription = @HttpStatusCodeString303
			
		Case 304
			intBufferLength = HttpStatusCodeString304Length
			GetStatusDescription = @HttpStatusCodeString304
			
		Case 305
			intBufferLength = HttpStatusCodeString305Length
			GetStatusDescription = @HttpStatusCodeString305
			
		Case 307
			intBufferLength = HttpStatusCodeString307Length
			GetStatusDescription = @HttpStatusCodeString307
			
		Case 400
			intBufferLength = HttpStatusCodeString400Length
			GetStatusDescription = @HttpStatusCodeString400
			
		Case 401
			intBufferLength = HttpStatusCodeString401Length
			GetStatusDescription = @HttpStatusCodeString401
			
		Case 402
			intBufferLength = HttpStatusCodeString402Length
			GetStatusDescription = @HttpStatusCodeString402
			
		Case 403
			intBufferLength = HttpStatusCodeString403Length
			GetStatusDescription = @HttpStatusCodeString403
			
		Case 404
			intBufferLength = HttpStatusCodeString404Length
			GetStatusDescription = @HttpStatusCodeString404
			
		Case 405
			intBufferLength = HttpStatusCodeString405Length
			GetStatusDescription = @HttpStatusCodeString405
			
		Case 406
			intBufferLength = HttpStatusCodeString406Length
			GetStatusDescription = @HttpStatusCodeString406
			
		Case 407
			intBufferLength = HttpStatusCodeString407Length
			GetStatusDescription = @HttpStatusCodeString407
			
		Case 408
			intBufferLength = HttpStatusCodeString408Length
			GetStatusDescription = @HttpStatusCodeString408
			
		Case 409
			intBufferLength = HttpStatusCodeString409Length
			GetStatusDescription = @HttpStatusCodeString409
			
		Case 410
			intBufferLength = HttpStatusCodeString410Length
			GetStatusDescription = @HttpStatusCodeString410
			
		Case 411
			intBufferLength = HttpStatusCodeString411Length
			GetStatusDescription = @HttpStatusCodeString411
			
		Case 412
			intBufferLength = HttpStatusCodeString412Length
			GetStatusDescription = @HttpStatusCodeString412
			
		Case 413
			intBufferLength = HttpStatusCodeString413Length
			GetStatusDescription = @HttpStatusCodeString413
			
		Case 414
			intBufferLength = HttpStatusCodeString414Length
			GetStatusDescription = @HttpStatusCodeString414
			
		Case 415
			intBufferLength = HttpStatusCodeString415Length
			GetStatusDescription = @HttpStatusCodeString415
			
		Case 416
			intBufferLength = HttpStatusCodeString416Length
			GetStatusDescription = @HttpStatusCodeString416
			
		Case 417
			intBufferLength = HttpStatusCodeString417Length
			GetStatusDescription = @HttpStatusCodeString417
			
		Case 418
			intBufferLength = HttpStatusCodeString418Length
			GetStatusDescription = @HttpStatusCodeString418
			
		Case 426
			intBufferLength = HttpStatusCodeString426Length
			GetStatusDescription = @HttpStatusCodeString426
			
		Case 428
			intBufferLength = HttpStatusCodeString428Length
			GetStatusDescription = @HttpStatusCodeString428
			
		Case 429
			intBufferLength = HttpStatusCodeString429Length
			GetStatusDescription = @HttpStatusCodeString429
			
		Case 431
			intBufferLength = HttpStatusCodeString431Length
			GetStatusDescription = @HttpStatusCodeString431
			
		Case 451
			intBufferLength = HttpStatusCodeString451Length
			GetStatusDescription = @HttpStatusCodeString451
			
		Case 500
			intBufferLength = HttpStatusCodeString500Length
			GetStatusDescription = @HttpStatusCodeString500
			
		Case 501
			intBufferLength = HttpStatusCodeString501Length
			GetStatusDescription = @HttpStatusCodeString501
			
		Case 502
			intBufferLength = HttpStatusCodeString502Length
			GetStatusDescription = @HttpStatusCodeString502
			
		Case 503
			intBufferLength = HttpStatusCodeString503Length
			GetStatusDescription = @HttpStatusCodeString503
			
		Case 504
			intBufferLength = HttpStatusCodeString504Length
			GetStatusDescription = @HttpStatusCodeString504
			
		Case 505
			intBufferLength = HttpStatusCodeString505Length
			GetStatusDescription = @HttpStatusCodeString505
			
		Case 506
			intBufferLength = HttpStatusCodeString506Length
			GetStatusDescription = @HttpStatusCodeString506
			
		Case 507
			intBufferLength = HttpStatusCodeString507Length
			GetStatusDescription = @HttpStatusCodeString507
			
		Case 508
			intBufferLength = HttpStatusCodeString508Length
			GetStatusDescription = @HttpStatusCodeString508
			
		Case 509
			intBufferLength = HttpStatusCodeString509Length
			GetStatusDescription = @HttpStatusCodeString509
			
		Case 510
			intBufferLength = HttpStatusCodeString510Length
			GetStatusDescription = @HttpStatusCodeString510
			
		Case 511
			intBufferLength = HttpStatusCodeString511Length
			GetStatusDescription = @HttpStatusCodeString511
			
		Case Else
			intBufferLength = HttpStatusCodeString200Length
			GetStatusDescription = @HttpStatusCodeString200
			
	End Select
	
	If BufferLength <> 0 Then
		*BufferLength = intBufferLength
	End If
End Function

Function KnownRequestCgiHeaderToString( _
		ByVal HeaderIndex As HttpRequestHeaders, _
		ByVal BufferLength As Integer Ptr _
	)As WString Ptr
	
	Dim intBufferLength As Integer = 0
	Select Case HeaderIndex
		
		Case HttpRequestHeaders.HeaderAccept
			intBufferLength = 11
			KnownRequestCgiHeaderToString = @"HTTP_ACCEPT"
			
		Case HttpRequestHeaders.HeaderAcceptCharset
			intBufferLength = 19
			KnownRequestCgiHeaderToString = @"HTTP_ACCEPT_CHARSET"
			
		Case HttpRequestHeaders.HeaderAcceptEncoding
			intBufferLength = 20
			KnownRequestCgiHeaderToString = @"HTTP_ACCEPT_ENCODING"
			
		Case HttpRequestHeaders.HeaderAcceptLanguage
			intBufferLength = 20
			KnownRequestCgiHeaderToString = @"HTTP_ACCEPT_LANGUAGE"
			
		Case HttpRequestHeaders.HeaderAuthorization
			intBufferLength = 9
			KnownRequestCgiHeaderToString = @"AUTH_TYPE"
			
		Case HttpRequestHeaders.HeaderCacheControl
			intBufferLength = 18
			KnownRequestCgiHeaderToString = @"HTTP_CACHE_CONTROL"
			
		Case HttpRequestHeaders.HeaderConnection
			intBufferLength = 15
			KnownRequestCgiHeaderToString = @"HTTP_CONNECTION"
			
		Case HttpRequestHeaders.HeaderContentEncoding
			intBufferLength = 21
			KnownRequestCgiHeaderToString = @"HTTP_CONTENT_ENCODING"
			
		Case HttpRequestHeaders.HeaderContentLanguage
			intBufferLength = 21
			KnownRequestCgiHeaderToString = @"HTTP_CONTENT_LANGUAGE"
			
		Case HttpRequestHeaders.HeaderContentLength
			intBufferLength = 14
			KnownRequestCgiHeaderToString = @"CONTENT_LENGTH"
			
		Case HttpRequestHeaders.HeaderContentMd5
			intBufferLength = 16
			KnownRequestCgiHeaderToString = @"HTTP_CONTENT_MD5"
			
		Case HttpRequestHeaders.HeaderContentRange
			intBufferLength = 18
			KnownRequestCgiHeaderToString = @"HTTP_CONTENT_RANGE"
			
		Case HttpRequestHeaders.HeaderContentType
			intBufferLength = 12
			KnownRequestCgiHeaderToString = @"CONTENT_TYPE"
			
		Case HttpRequestHeaders.HeaderCookie
			intBufferLength = 11
			KnownRequestCgiHeaderToString = @"HTTP_COOKIE"
			
		Case HttpRequestHeaders.HeaderExpect
			intBufferLength = 11
			KnownRequestCgiHeaderToString = @"HTTP_EXPECT"
			
		Case HttpRequestHeaders.HeaderFrom
			intBufferLength = 9
			KnownRequestCgiHeaderToString = @"HTTP_FROM"
			
		Case HttpRequestHeaders.HeaderHost
			intBufferLength = 9
			KnownRequestCgiHeaderToString = @"HTTP_HOST"
			
		Case HttpRequestHeaders.HeaderIfMatch
			intBufferLength = 13
			KnownRequestCgiHeaderToString = @"HTTP_IF_MATCH"
			
		Case HttpRequestHeaders.HeaderIfModifiedSince
			intBufferLength = 22
			KnownRequestCgiHeaderToString = @"HTTP_IF_MODIFIED_SINCE"
			
		Case HttpRequestHeaders.HeaderIfNoneMatch
			intBufferLength = 18
			KnownRequestCgiHeaderToString = @"HTTP_IF_NONE_MATCH"
			
		Case HttpRequestHeaders.HeaderIfRange
			intBufferLength = 13
			KnownRequestCgiHeaderToString = @"HTTP_IF_RANGE"
			
		Case HttpRequestHeaders.HeaderIfUnmodifiedSince
			intBufferLength = 24
			KnownRequestCgiHeaderToString = @"HTTP_IF_UNMODIFIED_SINCE"
			
		Case HttpRequestHeaders.HeaderKeepAlive
			intBufferLength = 15
			KnownRequestCgiHeaderToString = @"HTTP_KEEP_ALIVE"
			
		Case HttpRequestHeaders.HeaderMaxForwards
			intBufferLength = 17
			KnownRequestCgiHeaderToString = @"HTTP_MAX_FORWARDS"
			
		Case HttpRequestHeaders.HeaderPragma
			intBufferLength = 11
			KnownRequestCgiHeaderToString = @"HTTP_PRAGMA"
			
		Case HttpRequestHeaders.HeaderProxyAuthorization
			intBufferLength = 24
			KnownRequestCgiHeaderToString = @"HTTP_PROXY_AUTHORIZATION"
			
		Case HttpRequestHeaders.HeaderRange
			intBufferLength = 10
			KnownRequestCgiHeaderToString = @"HTTP_RANGE"
			
		Case HttpRequestHeaders.HeaderReferer
			intBufferLength = 12
			KnownRequestCgiHeaderToString = @"HTTP_REFERER"
			
		Case HttpRequestHeaders.HeaderTe
			intBufferLength = 7
			KnownRequestCgiHeaderToString = @"HTTP_TE"
			
		Case HttpRequestHeaders.HeaderTrailer
			intBufferLength = 12
			KnownRequestCgiHeaderToString = @"HTTP_TRAILER"
			
		Case HttpRequestHeaders.HeaderTransferEncoding
			intBufferLength = 22
			KnownRequestCgiHeaderToString = @"HTTP_TRANSFER_ENCODING"
			
		Case HttpRequestHeaders.HeaderUpgrade
			intBufferLength = 12
			KnownRequestCgiHeaderToString = @"HTTP_UPGRADE"
			
		Case HttpRequestHeaders.HeaderUserAgent
			intBufferLength = 15
			KnownRequestCgiHeaderToString = @"HTTP_USER_AGENT"
			
		Case HttpRequestHeaders.HeaderVia
			intBufferLength = 8
			KnownRequestCgiHeaderToString = @"HTTP_VIA"
			
		Case HttpRequestHeaders.HeaderWarning
			intBufferLength = 12
			KnownRequestCgiHeaderToString = @"HTTP_WARNING"
			
		Case Else
			intBufferLength = 0
			KnownRequestCgiHeaderToString = 0
			
	End Select
	
	If BufferLength <> 0 Then
		*BufferLength = intBufferLength
	End If
End Function
