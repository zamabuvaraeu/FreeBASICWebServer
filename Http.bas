#ifndef unicode
#define unicode
#endif

#include once "Http.bi"
#include once "windows.bi"

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

Function GetHttpMethod(ByVal s As WString Ptr)As HttpMethods
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
	
	Return HttpMethods.None
End Function

Function GetHttpMethodString(ByVal HttpMethod As HttpMethods, ByRef BufferLength As Integer)As WString Ptr
	Select Case HttpMethod
		Case HttpMethods.HttpGet
			BufferLength = HttpMethodGetLength
			Return @HttpMethodGet
			
		Case HttpMethods.HttpHead
			BufferLength = HttpMethodHeadLength
			Return @HttpMethodHead
			
		Case HttpMethods.HttpPost
			BufferLength = HttpMethodPostLength
			Return @HttpMethodPost
			
		Case HttpMethods.HttpPut
			BufferLength = HttpMethodPutLength
			Return @HttpMethodPut
			
		Case HttpMethods.HttpDelete
			BufferLength = HttpMethodDeleteLength
			Return @HttpMethodDelete
			
		Case HttpMethods.HttpOptions
			BufferLength = HttpMethodOptionsLength
			Return @HttpMethodOptions
			
		Case HttpMethods.HttpTrace
			BufferLength = HttpMethodTraceLength
			Return @HttpMethodTrace
			
		Case HttpMethods.HttpConnect
			BufferLength = HttpMethodConnectLength
			Return @HttpMethodConnect
			
		Case HttpMethods.HttpPatch
			BufferLength = HttpMethodPatchLength
			Return @HttpMethodPatch
			
		Case HttpMethods.HttpCopy
			BufferLength = HttpMethodCopyLength
			Return @HttpMethodCopy
			
		Case HttpMethods.HttpMove
			BufferLength = HttpMethodMoveLength
			Return @HttpMethodMove
			
		Case HttpMethods.HttpPropfind
			BufferLength = HttpMethodPropfindLength
			Return @HttpMethodPropfind
			
	End Select
	
	BufferLength = 0
	Return 0
End Function

Function GetKnownRequestHeaderIndex(ByVal Header As WString Ptr)As Integer
	If lstrcmpi(Header, HeaderAcceptString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderAccept
	End If
	
	If lstrcmpi(Header, HeaderAcceptCharsetString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderAcceptCharset
	End If
	
	If lstrcmpi(Header, HeaderAcceptEncodingString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderAcceptEncoding
	End If
	
	If lstrcmpi(Header, HeaderAcceptLanguageString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderAcceptLanguage
	End If
	
	If lstrcmpi(Header, HeaderAuthorizationString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderAuthorization
	End If
	
	If lstrcmpi(Header, HeaderCacheControlString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderCacheControl
	End If
	
	If lstrcmpi(Header, HeaderConnectionString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderConnection
	End If
	
	If lstrcmpi(Header, HeaderContentEncodingString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentEncoding
	End If
	
	If lstrcmpi(Header, HeaderContentLanguageString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentLanguage
	End If
	
	If lstrcmpi(Header, HeaderContentLengthString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentLength
	End If
	
	If lstrcmpi(Header, HeaderContentMd5String) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentMd5
	End If
	
	If lstrcmpi(Header, HeaderContentRangeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentRange
	End If
	
	If lstrcmpi(Header, HeaderContentTypeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderContentType
	End If
	
	If lstrcmpi(Header, HeaderCookieString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderCookie
	End If
	
	If lstrcmpi(Header, HeaderExpectString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderExpect
	End If
	
	If lstrcmpi(Header, HeaderFromString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderFrom
	End If
	
	If lstrcmpi(Header, HeaderHostString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderHost
	End If
	
	If lstrcmpi(Header, HeaderIfMatchString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderIfMatch
	End If
	
	If lstrcmpi(Header, HeaderIfModifiedSinceString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderIfModifiedSince
	End If
	
	If lstrcmpi(Header, HeaderIfNoneMatchString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderIfNoneMatch
	End If
	
	If lstrcmpi(Header, HeaderIfRangeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderIfRange
	End If
	
	If lstrcmpi(Header, HeaderIfUnmodifiedSinceString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderIfUnmodifiedSince
	End If
	
	If lstrcmpi(Header, HeaderKeepAliveString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderKeepAlive
	End If
	
	If lstrcmpi(Header, HeaderMaxForwardsString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderMaxForwards
	End If
	
	If lstrcmpi(Header, HeaderPragmaString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderPragma
	End If
	
	If lstrcmpi(Header, HeaderProxyAuthorizationString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderProxyAuthorization
	End If
	
	If lstrcmpi(Header, HeaderRangeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderRange
	End If
	
	If lstrcmpi(Header, HeaderRefererString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderReferer
	End If
	
	If lstrcmpi(Header, HeaderTeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderTe
	End If
	
	If lstrcmpi(Header, HeaderTrailerString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderTrailer
	End If
	
	If lstrcmpi(Header, HeaderTransferEncodingString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderTransferEncoding
	End If
	
	If lstrcmpi(Header, HeaderUpgradeString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderUpgrade
	End If
	
	If lstrcmpi(Header, HeaderTransferEncodingString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderTransferEncoding
	End If
	
	If lstrcmpi(Header, HeaderUserAgentString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderUserAgent
	End If
	
	If lstrcmpi(Header, HeaderViaString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderVia
	End If
	
	If lstrcmpi(Header, HeaderWarningString) = 0 Then
		Return HttpRequestHeaderIndices.HeaderWarning
	End If
	
	Return -1
	
End Function

Function GetKnownResponseHeaderIndex(ByVal Header As WString Ptr)As Integer
	If lstrcmpi(Header, @HeaderAcceptRangesString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderAcceptRanges
	End If
	
	If lstrcmpi(Header, @HeaderAgeString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderAge
	End If
	
	If lstrcmpi(Header, @HeaderAllowString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderAllow
	End If
	
	If lstrcmpi(Header, @HeaderCacheControlString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderCacheControl
	End If
	
	If lstrcmpi(Header, @HeaderConnectionString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderConnection
	End If
	
	If lstrcmpi(Header, @HeaderContentEncodingString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentEncoding
	End If
	
	If lstrcmpi(Header, @HeaderContentLanguageString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentLanguage
	End If
	
	If lstrcmpi(Header, @HeaderContentLengthString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentLength
	End If
	
	If lstrcmpi(Header, @HeaderContentLocationString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentLocation
	End If
	
	If lstrcmpi(Header, @HeaderContentMd5String) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentMd5
	End If
	
	If lstrcmpi(Header, @HeaderContentRangeString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentRange
	End If
	
	If lstrcmpi(Header, @HeaderContentTypeString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderContentType
	End If
	
	If lstrcmpi(Header, @HeaderDateString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderDate
	End If
	
	If lstrcmpi(Header, @HeaderETagString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderETag
	End If
	
	If lstrcmpi(Header, @HeaderExpiresString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderExpires
	End If
	
	If lstrcmpi(Header, @HeaderKeepAliveString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderKeepAlive
	End If
	
	If lstrcmpi(Header, @HeaderLastModifiedString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderLastModified
	End If
	
	If lstrcmpi(Header, @HeaderLocationString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderLocation
	End If
	
	If lstrcmpi(Header, @HeaderPragmaString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderPragma
	End If
	
	If lstrcmpi(Header, @HeaderProxyAuthenticateString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderProxyAuthenticate
	End If
	
	If lstrcmpi(Header, @HeaderRetryAfterString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderRetryAfter
	End If
	
	If lstrcmpi(Header, @HeaderServerString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderServer
	End If
	
	If lstrcmpi(Header, @HeaderSetCookieString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderSetCookie
	End If
	
	If lstrcmpi(Header, @HeaderTrailerString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderTrailer
	End If
	
	If lstrcmpi(Header, @HeaderTransferEncodingString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderTransferEncoding
	End If
	
	If lstrcmpi(Header, @HeaderUpgradeString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderUpgrade
	End If
	
	If lstrcmpi(Header, @HeaderVaryString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderVary
	End If
	
	If lstrcmpi(Header, @HeaderViaString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderVia
	End If
	
	If lstrcmpi(Header, @HeaderWarningString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderWarning
	End If
	
	If lstrcmpi(Header, @HeaderWWWAuthenticateString) = 0 Then
		Return HttpResponseHeaderIndices.HeaderWwwAuthenticate
	End If
	
	Return -1
	
End Function

Function GetKnownResponseHeaderName(ByVal HeaderIndex As HttpResponseHeaderIndices, ByRef BufferLength As Integer)As WString Ptr
	Select Case HeaderIndex
		
		Case HttpResponseHeaderIndices.HeaderAcceptRanges
			BufferLength = HeaderAcceptRangesStringLength
			Return @HeaderAcceptRangesString
			
		Case HttpResponseHeaderIndices.HeaderAge
			BufferLength = HeaderAgeStringLength
			Return @HeaderAgeString
			
		Case HttpResponseHeaderIndices.HeaderAllow
			BufferLength = HeaderAllowStringLength
			Return @HeaderAllowString
			
		Case HttpResponseHeaderIndices.HeaderCacheControl
			BufferLength = HeaderCacheControlStringLength
			Return @HeaderCacheControlString
			
		Case HttpResponseHeaderIndices.HeaderConnection
			BufferLength = HeaderConnectionStringLength
			Return @HeaderConnectionString
			
		Case HttpResponseHeaderIndices.HeaderContentEncoding
			BufferLength = HeaderContentEncodingStringLength
			Return @HeaderContentEncodingString
			
		Case HttpResponseHeaderIndices.HeaderContentLength
			BufferLength = HeaderContentLengthStringLength
			Return @HeaderContentLengthString
			
		Case HttpResponseHeaderIndices.HeaderContentLanguage
			BufferLength = HeaderContentLanguageStringLength
			Return @HeaderContentLanguageString
			
		Case HttpResponseHeaderIndices.HeaderContentLocation
			BufferLength = HeaderContentLocationStringLength
			Return @HeaderContentLocationString
			
		Case HttpResponseHeaderIndices.HeaderContentMd5
			BufferLength = HeaderContentMd5StringLength
			Return @HeaderContentMd5String
			
		Case HttpResponseHeaderIndices.HeaderContentRange
			BufferLength = HeaderContentRangeStringLength
			Return @HeaderContentRangeString
			
		Case HttpResponseHeaderIndices.HeaderContentType
			BufferLength = HeaderContentTypeStringLength
			Return @HeaderContentTypeString
			
		Case HttpResponseHeaderIndices.HeaderDate
			BufferLength = HeaderDateStringLength
			Return @HeaderDateString
			
		Case HttpResponseHeaderIndices.HeaderEtag
			BufferLength = HeaderETagStringLength
			Return @HeaderETagString
			
		Case HttpResponseHeaderIndices.HeaderExpires
			BufferLength = HeaderExpiresStringLength
			Return @HeaderExpiresString
			
		Case HttpResponseHeaderIndices.HeaderKeepAlive
			BufferLength = HeaderKeepAliveStringLength
			Return @HeaderKeepAliveString
			
		Case HttpResponseHeaderIndices.HeaderLastModified
			BufferLength = HeaderLastModifiedStringLength
			Return @HeaderLastModifiedString
			
		Case HttpResponseHeaderIndices.HeaderLocation
			BufferLength = HeaderLocationStringLength
			Return @HeaderLocationString
			
		Case HttpResponseHeaderIndices.HeaderPragma
			BufferLength = HeaderPragmaStringLength
			Return @HeaderPragmaString
			
		Case HttpResponseHeaderIndices.HeaderProxyAuthenticate
			BufferLength = HeaderProxyAuthenticateStringLength
			Return @HeaderProxyAuthenticateString
			
		Case HttpResponseHeaderIndices.HeaderRetryAfter
			BufferLength = HeaderRetryAfterStringLength
			Return @HeaderRetryAfterString
			
		Case HttpResponseHeaderIndices.HeaderServer
			BufferLength = HeaderServerStringLength
			Return @HeaderServerString
			
		Case HttpResponseHeaderIndices.HeaderSetCookie
			BufferLength = HeaderSetCookieStringLength
			Return @HeaderSetCookieString
			
		Case HttpResponseHeaderIndices.HeaderTrailer
			BufferLength = HeaderTrailerStringLength
			Return @HeaderTrailerString
			
		Case HttpResponseHeaderIndices.HeaderTransferEncoding
			BufferLength = HeaderTransferEncodingStringLength
			Return @HeaderTransferEncodingString
			
		Case HttpResponseHeaderIndices.HeaderUpgrade
			BufferLength = HeaderUpgradeStringLength
			Return @HeaderUpgradeString
			
		Case HttpResponseHeaderIndices.HeaderVary
			BufferLength = HeaderVaryStringLength
			Return @HeaderVaryString
			
		Case HttpResponseHeaderIndices.HeaderVia
			BufferLength = HeaderViaStringLength
			Return @HeaderViaString
			
		Case HttpResponseHeaderIndices.HeaderWarning
			BufferLength = HeaderWarningStringLength
			Return @HeaderWarningString
			
		Case HttpResponseHeaderIndices.HeaderWwwAuthenticate
			BufferLength = HeaderWWWAuthenticateStringLength
			Return @HeaderWWWAuthenticateString
			
	End Select
	
	BufferLength = 0
	Return 0
End Function

Function GetStatusDescription(ByVal StatusCode As Integer, ByRef BufferLength As Integer)As WString Ptr
	
	Select Case StatusCode
		
		Case 100
			BufferLength = HttpStatusCodeString100Length
			Return @HttpStatusCodeString100
			
		Case 101
			BufferLength = HttpStatusCodeString101Length
			Return @HttpStatusCodeString101
			
		Case 102
			BufferLength = HttpStatusCodeString102Length
			Return @HttpStatusCodeString102
			
		Case 200
			BufferLength = HttpStatusCodeString200Length
			Return @HttpStatusCodeString200
			
		Case 201
			BufferLength = HttpStatusCodeString201Length
			Return @HttpStatusCodeString201
			
		Case 202
			BufferLength = HttpStatusCodeString202Length
			Return @HttpStatusCodeString202
			
		Case 203
			BufferLength = HttpStatusCodeString203Length
			Return @HttpStatusCodeString203
			
		Case 204
			BufferLength = HttpStatusCodeString204Length
			Return @HttpStatusCodeString204
			
		Case 205
			BufferLength = HttpStatusCodeString205Length
			Return @HttpStatusCodeString205
			
		Case 206
			BufferLength = HttpStatusCodeString206Length
			Return @HttpStatusCodeString206
			
		Case 207
			BufferLength = HttpStatusCodeString207Length
			Return @HttpStatusCodeString207
			
		Case 226
			BufferLength = HttpStatusCodeString226Length
			Return @HttpStatusCodeString226
			
		Case 300
			BufferLength = HttpStatusCodeString300Length
			Return @HttpStatusCodeString300
			
		Case 301
			BufferLength = HttpStatusCodeString301Length
			Return @HttpStatusCodeString301
			
		Case 302
			BufferLength = HttpStatusCodeString302Length
			Return @HttpStatusCodeString302
			
		Case 303
			BufferLength = HttpStatusCodeString303Length
			Return @HttpStatusCodeString303
			
		Case 304
			BufferLength = HttpStatusCodeString304Length
			Return @HttpStatusCodeString304
			
		Case 305
			BufferLength = HttpStatusCodeString305Length
			Return @HttpStatusCodeString305
			
		Case 307
			BufferLength = HttpStatusCodeString307Length
			Return @HttpStatusCodeString307
			
		Case 400
			BufferLength = HttpStatusCodeString400Length
			Return @HttpStatusCodeString400
			
		Case 401
			BufferLength = HttpStatusCodeString401Length
			Return @HttpStatusCodeString401
			
		Case 402
			BufferLength = HttpStatusCodeString402Length
			Return @HttpStatusCodeString402
			
		Case 403
			BufferLength = HttpStatusCodeString403Length
			Return @HttpStatusCodeString403
			
		Case 404
			BufferLength = HttpStatusCodeString404Length
			Return @HttpStatusCodeString404
			
		Case 405
			BufferLength = HttpStatusCodeString405Length
			Return @HttpStatusCodeString405
			
		Case 406
			BufferLength = HttpStatusCodeString406Length
			Return @HttpStatusCodeString406
			
		Case 407
			BufferLength = HttpStatusCodeString407Length
			Return @HttpStatusCodeString407
			
		Case 408
			BufferLength = HttpStatusCodeString408Length
			Return @HttpStatusCodeString408
			
		Case 409
			BufferLength = HttpStatusCodeString409Length
			Return @HttpStatusCodeString409
			
		Case 410
			BufferLength = HttpStatusCodeString410Length
			Return @HttpStatusCodeString410
			
		Case 411
			BufferLength = HttpStatusCodeString411Length
			Return @HttpStatusCodeString411
			
		Case 412
			BufferLength = HttpStatusCodeString412Length
			Return @HttpStatusCodeString412
			
		Case 413
			BufferLength = HttpStatusCodeString413Length
			Return @HttpStatusCodeString413
			
		Case 414
			BufferLength = HttpStatusCodeString414Length
			Return @HttpStatusCodeString414
			
		Case 415
			BufferLength = HttpStatusCodeString415Length
			Return @HttpStatusCodeString415
			
		Case 416
			BufferLength = HttpStatusCodeString416Length
			Return @HttpStatusCodeString416
			
		Case 417
			BufferLength = HttpStatusCodeString417Length
			Return @HttpStatusCodeString417
			
		Case 418
			BufferLength = HttpStatusCodeString418Length
			Return @HttpStatusCodeString418
			
		Case 426
			BufferLength = HttpStatusCodeString426Length
			Return @HttpStatusCodeString426
			
		Case 428
			BufferLength = HttpStatusCodeString428Length
			Return @HttpStatusCodeString428
			
		Case 429
			BufferLength = HttpStatusCodeString429Length
			Return @HttpStatusCodeString429
			
		Case 431
			BufferLength = HttpStatusCodeString431Length
			Return @HttpStatusCodeString431
			
		Case 451
			BufferLength = HttpStatusCodeString451Length
			Return @HttpStatusCodeString451
			
		Case 500
			BufferLength = HttpStatusCodeString500Length
			Return @HttpStatusCodeString500
			
		Case 501
			BufferLength = HttpStatusCodeString501Length
			Return @HttpStatusCodeString501
			
		Case 502
			BufferLength = HttpStatusCodeString502Length
			Return @HttpStatusCodeString502
			
		Case 503
			BufferLength = HttpStatusCodeString503Length
			Return @HttpStatusCodeString503
			
		Case 504
			BufferLength = HttpStatusCodeString504Length
			Return @HttpStatusCodeString504
			
		Case 505
			BufferLength = HttpStatusCodeString505Length
			Return @HttpStatusCodeString505
			
		Case 506
			BufferLength = HttpStatusCodeString506Length
			Return @HttpStatusCodeString506
			
		Case 507
			BufferLength = HttpStatusCodeString507Length
			Return @HttpStatusCodeString507
			
		Case 508
			BufferLength = HttpStatusCodeString508Length
			Return @HttpStatusCodeString508
			
		Case 509
			BufferLength = HttpStatusCodeString509Length
			Return @HttpStatusCodeString509
			
		Case 510
			BufferLength = HttpStatusCodeString510Length
			Return @HttpStatusCodeString510
			
		Case 511
			BufferLength = HttpStatusCodeString511Length
			Return @HttpStatusCodeString511
			
	End Select
	
	BufferLength = HttpStatusCodeString200Length
	Return @HttpStatusCodeString200
End Function

Function GetKnownRequestHeaderNameCGI(ByVal HeaderIndex As HttpRequestHeaderIndices, ByRef BufferLength As Integer)As WString Ptr
	Select Case HeaderIndex
		
		Case HttpRequestHeaderIndices.HeaderAccept
			BufferLength = 11
			Return @"HTTP_ACCEPT"
			
		Case HttpRequestHeaderIndices.HeaderAcceptCharset
			BufferLength = 19
			Return @"HTTP_ACCEPT_CHARSET"
			
		Case HttpRequestHeaderIndices.HeaderAcceptEncoding
			BufferLength = 20
			Return @"HTTP_ACCEPT_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderAcceptLanguage
			BufferLength = 20
			Return @"HTTP_ACCEPT_LANGUAGE"
			
		Case HttpRequestHeaderIndices.HeaderAuthorization
			BufferLength = 9
			Return @"AUTH_TYPE"
			
		Case HttpRequestHeaderIndices.HeaderCacheControl
			BufferLength = 18
			Return @"HTTP_CACHE_CONTROL"
			
		Case HttpRequestHeaderIndices.HeaderConnection
			BufferLength = 15
			Return @"HTTP_CONNECTION"
			
		Case HttpRequestHeaderIndices.HeaderContentEncoding
			BufferLength = 21
			Return @"HTTP_CONTENT_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderContentLanguage
			BufferLength = 21
			Return @"HTTP_CONTENT_LANGUAGE"
			
		Case HttpRequestHeaderIndices.HeaderContentLength
			BufferLength = 14
			Return @"CONTENT_LENGTH"
			
		Case HttpRequestHeaderIndices.HeaderContentMd5
			BufferLength = 16
			Return @"HTTP_CONTENT_MD5"
			
		Case HttpRequestHeaderIndices.HeaderContentRange
			BufferLength = 18
			Return @"HTTP_CONTENT_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderContentType
			BufferLength = 12
			Return @"CONTENT_TYPE"
			
		Case HttpRequestHeaderIndices.HeaderCookie
			BufferLength = 11
			Return @"HTTP_COOKIE"
			
		Case HttpRequestHeaderIndices.HeaderExpect
			BufferLength = 11
			Return @"HTTP_EXPECT"
			
		Case HttpRequestHeaderIndices.HeaderFrom
			BufferLength = 9
			Return @"HTTP_FROM"
			
		Case HttpRequestHeaderIndices.HeaderHost
			BufferLength = 9
			Return @"HTTP_HOST"
			
		Case HttpRequestHeaderIndices.HeaderIfMatch
			BufferLength = 13
			Return @"HTTP_IF_MATCH"
			
		Case HttpRequestHeaderIndices.HeaderIfModifiedSince
			BufferLength = 22
			Return @"HTTP_IF_MODIFIED_SINCE"
			
		Case HttpRequestHeaderIndices.HeaderIfNoneMatch
			BufferLength = 18
			Return @"HTTP_IF_NONE_MATCH"
			
		Case HttpRequestHeaderIndices.HeaderIfRange
			BufferLength = 13
			Return @"HTTP_IF_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderIfUnmodifiedSince
			BufferLength = 24
			Return @"HTTP_IF_UNMODIFIED_SINCE"
			
		Case HttpRequestHeaderIndices.HeaderKeepAlive
			BufferLength = 15
			Return @"HTTP_KEEP_ALIVE"
			
		Case HttpRequestHeaderIndices.HeaderMaxForwards
			BufferLength = 17
			Return @"HTTP_MAX_FORWARDS"
			
		Case HttpRequestHeaderIndices.HeaderPragma
			BufferLength = 11
			Return @"HTTP_PRAGMA"
			
		Case HttpRequestHeaderIndices.HeaderProxyAuthorization
			BufferLength = 24
			Return @"HTTP_PROXY_AUTHORIZATION"
			
		Case HttpRequestHeaderIndices.HeaderRange
			BufferLength = 10
			Return @"HTTP_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderReferer
			BufferLength = 12
			Return @"HTTP_REFERER"
			
		Case HttpRequestHeaderIndices.HeaderTe
			BufferLength = 7
			Return @"HTTP_TE"
			
		Case HttpRequestHeaderIndices.HeaderTrailer
			BufferLength = 12
			Return @"HTTP_TRAILER"
			
		Case HttpRequestHeaderIndices.HeaderTransferEncoding
			BufferLength = 22
			Return @"HTTP_TRANSFER_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderUpgrade
			BufferLength = 12
			Return @"HTTP_UPGRADE"
			
		Case HttpRequestHeaderIndices.HeaderUserAgent
			BufferLength = 15
			Return @"HTTP_USER_AGENT"
			
		Case HttpRequestHeaderIndices.HeaderVia
			BufferLength = 8
			Return @"HTTP_VIA"
			
		Case HttpRequestHeaderIndices.HeaderWarning
			BufferLength = 12
			Return @"HTTP_WARNING"
			
	End Select
	
	BufferLength = 0
	Return 0
End Function

