#ifndef unicode
#define unicode
#endif

#include once "Http.bi"
#include once "windows.bi"

Const HttpMethodCopy = 			"COPY"
Const HttpMethodConnect = 		"CONNECT"
Const HttpMethodDelete = 		"DELETE"
Const HttpMethodGet = 			"GET"
Const HttpMethodHead = 			"HEAD"
Const HttpMethodMove = 			"MOVE"
Const HttpMethodOptions = 		"OPTIONS"
Const HttpMethodPatch = 		"PATCH"
Const HttpMethodPost = 			"POST"
Const HttpMethodPropfind = 		"PROPFIND"
Const HttpMethodPut = 			"PUT"
Const HttpMethodTrace = 		"TRACE"

Const HttpMethodCopyLength As Integer = 	4
Const HttpMethodConnectLength As Integer = 	7
Const HttpMethodDeleteLength As Integer = 	6
Const HttpMethodGetLength As Integer = 		3
Const HttpMethodHeadLength As Integer = 	4
Const HttpMethodMoveLength As Integer = 	4
Const HttpMethodOptionsLength As Integer = 	7
Const HttpMethodPatchLength As Integer = 	5
Const HttpMethodPostLength As Integer = 	4
Const HttpMethodPropfindLength As Integer = 8
Const HttpMethodPutLength As Integer = 		3
Const HttpMethodTraceLength As Integer = 	5

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

Function GetHttpMethodString(ByVal Buffer As WString Ptr, ByVal HttpMethod As HttpMethods)As Integer
	Select Case HttpMethod
		Case HttpMethods.HttpGet
			lstrcpy(Buffer, @HttpMethodGet)
			Return HttpMethodGetLength
			
		Case HttpMethods.HttpHead
			lstrcpy(Buffer, @HttpMethodHead)
			Return HttpMethodHeadLength
			
		Case HttpMethods.HttpPost
			lstrcpy(Buffer, @HttpMethodPost)
			Return HttpMethodPostLength
			
		Case HttpMethods.HttpPut
			lstrcpy(Buffer, @HttpMethodPut)
			Return HttpMethodPutLength
			
		Case HttpMethods.HttpDelete
			lstrcpy(Buffer, @HttpMethodDelete)
			Return HttpMethodDeleteLength
			
		Case HttpMethods.HttpOptions
			lstrcpy(Buffer, @HttpMethodOptions)
			Return HttpMethodOptionsLength
			
		Case HttpMethods.HttpTrace
			lstrcpy(Buffer, @HttpMethodTrace)
			Return HttpMethodTraceLength
			
		Case HttpMethods.HttpConnect
			lstrcpy(Buffer, @HttpMethodConnect)
			Return HttpMethodConnectLength
			
		Case HttpMethods.HttpPatch
			lstrcpy(Buffer, @HttpMethodPatch)
			Return HttpMethodPatchLength
			
		Case HttpMethods.HttpCopy
			lstrcpy(Buffer, @HttpMethodCopy)
			Return HttpMethodCopyLength
			
		Case HttpMethods.HttpMove
			lstrcpy(Buffer, @HttpMethodMove)
			Return HttpMethodMoveLength
			
		Case HttpMethods.HttpPropfind
			lstrcpy(Buffer, @HttpMethodPropfind)
			Return HttpMethodPropfindLength
			
	End Select
	
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

Function GetKnownResponseHeaderName(ByVal Buffer As WString Ptr, ByVal HeaderIndex As HttpResponseHeaderIndices)As Integer
	Select Case HeaderIndex
		
		Case HttpResponseHeaderIndices.HeaderAcceptRanges
			lstrcpy(Buffer, @HeaderAcceptRangesString)
			Return HeaderAcceptRangesStringLength
			
		Case HttpResponseHeaderIndices.HeaderAge
			lstrcpy(Buffer, @HeaderAgeString)
			Return HeaderAgeStringLength
			
		Case HttpResponseHeaderIndices.HeaderAllow
			lstrcpy(Buffer, @HeaderAllowString)
			Return HeaderAllowStringLength
			
		Case HttpResponseHeaderIndices.HeaderCacheControl
			lstrcpy(Buffer, @HeaderCacheControlString)
			Return HeaderCacheControlStringLength
			
		Case HttpResponseHeaderIndices.HeaderConnection
			lstrcpy(Buffer, @HeaderConnectionString)
			Return HeaderConnectionStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentEncoding
			lstrcpy(Buffer, @HeaderContentEncodingString)
			Return HeaderContentEncodingStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentLength
			lstrcpy(Buffer, @HeaderContentLengthString)
			Return HeaderContentLengthStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentLanguage
			lstrcpy(Buffer, @HeaderContentLanguageString)
			Return HeaderContentLanguageStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentLocation
			lstrcpy(Buffer, @HeaderContentLocationString)
			Return HeaderContentLocationStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentMd5
			lstrcpy(Buffer, @HeaderContentMd5String)
			Return HeaderContentMd5StringLength
			
		Case HttpResponseHeaderIndices.HeaderContentRange
			lstrcpy(Buffer, @HeaderContentRangeString)
			Return HeaderContentRangeStringLength
			
		Case HttpResponseHeaderIndices.HeaderContentType
			lstrcpy(Buffer, @HeaderContentTypeString)
			Return HeaderContentTypeStringLength
			
		Case HttpResponseHeaderIndices.HeaderDate
			lstrcpy(Buffer, @HeaderDateString)
			Return HeaderDateStringLength
			
		Case HttpResponseHeaderIndices.HeaderEtag
			lstrcpy(Buffer, @HeaderETagString)
			Return HeaderETagStringLength
			
		Case HttpResponseHeaderIndices.HeaderExpires
			lstrcpy(Buffer, @HeaderExpiresString)
			Return HeaderExpiresStringLength
			
		Case HttpResponseHeaderIndices.HeaderKeepAlive
			lstrcpy(Buffer, @HeaderKeepAliveString)
			Return HeaderKeepAliveStringLength
			
		Case HttpResponseHeaderIndices.HeaderLastModified
			lstrcpy(Buffer, @HeaderLastModifiedString)
			Return HeaderLastModifiedStringLength
			
		Case HttpResponseHeaderIndices.HeaderLocation
			lstrcpy(Buffer, @HeaderLocationString)
			Return HeaderLocationStringLength
			
		Case HttpResponseHeaderIndices.HeaderPragma
			lstrcpy(Buffer, @HeaderPragmaString)
			Return HeaderPragmaStringLength
			
		Case HttpResponseHeaderIndices.HeaderProxyAuthenticate
			lstrcpy(Buffer, @HeaderProxyAuthenticateString)
			Return HeaderProxyAuthenticateStringLength
			
		Case HttpResponseHeaderIndices.HeaderRetryAfter
			lstrcpy(Buffer, @HeaderRetryAfterString)
			Return HeaderRetryAfterStringLength
			
		Case HttpResponseHeaderIndices.HeaderServer
			lstrcpy(Buffer, @HeaderServerString)
			Return HeaderServerStringLength
			
		Case HttpResponseHeaderIndices.HeaderSetCookie
			lstrcpy(Buffer, @HeaderSetCookieString)
			Return HeaderSetCookieStringLength
			
		Case HttpResponseHeaderIndices.HeaderTrailer
			lstrcpy(Buffer, @HeaderTrailerString)
			Return HeaderTrailerStringLength
			
		Case HttpResponseHeaderIndices.HeaderTransferEncoding
			lstrcpy(Buffer, @HeaderTransferEncodingString)
			Return HeaderTransferEncodingStringLength
			
		Case HttpResponseHeaderIndices.HeaderUpgrade
			lstrcpy(Buffer, @HeaderUpgradeString)
			Return HeaderUpgradeStringLength
			
		Case HttpResponseHeaderIndices.HeaderVary
			lstrcpy(Buffer, @HeaderVaryString)
			Return HeaderVaryStringLength
			
		Case HttpResponseHeaderIndices.HeaderVia
			lstrcpy(Buffer, @HeaderViaString)
			Return HeaderViaStringLength
			
		Case HttpResponseHeaderIndices.HeaderWarning
			lstrcpy(Buffer, @HeaderWarningString)
			Return HeaderWarningStringLength
			
		Case HttpResponseHeaderIndices.HeaderWwwAuthenticate
			lstrcpy(Buffer, @HeaderWWWAuthenticateString)
			Return HeaderWWWAuthenticateStringLength
			
	End Select
	
	Return 0
End Function

Function GetStatusDescription(ByVal Buffer As WString Ptr, ByVal StatusCode As Integer)As Integer
	
	Select Case StatusCode
		
		Case 100
			lstrcpy(Buffer, @HttpStatusCodeString100)
			Return HttpStatusCodeString100Length
			
		Case 101
			lstrcpy(Buffer, @HttpStatusCodeString101)
			Return HttpStatusCodeString101Length
			
		Case 102
			lstrcpy(Buffer, @HttpStatusCodeString102)
			Return HttpStatusCodeString102Length
			
		Case 200
			lstrcpy(Buffer, @HttpStatusCodeString200)
			Return HttpStatusCodeString200Length
			
		Case 201
			lstrcpy(Buffer, @HttpStatusCodeString201)
			Return HttpStatusCodeString201Length
			
		Case 202
			lstrcpy(Buffer, @HttpStatusCodeString202)
			Return HttpStatusCodeString202Length
			
		Case 203
			lstrcpy(Buffer, @HttpStatusCodeString203)
			Return HttpStatusCodeString203Length
			
		Case 204
			lstrcpy(Buffer, @HttpStatusCodeString204)
			Return HttpStatusCodeString204Length
			
		Case 205
			lstrcpy(Buffer, @HttpStatusCodeString205)
			Return HttpStatusCodeString205Length
			
		Case 206
			lstrcpy(Buffer, @HttpStatusCodeString206)
			Return HttpStatusCodeString206Length
			
		Case 207
			lstrcpy(Buffer, @HttpStatusCodeString207)
			Return HttpStatusCodeString207Length
			
		Case 226
			lstrcpy(Buffer, @HttpStatusCodeString226)
			Return HttpStatusCodeString226Length
			
		Case 300
			lstrcpy(Buffer, @HttpStatusCodeString300)
			Return HttpStatusCodeString300Length
			
		Case 301
			lstrcpy(Buffer, @HttpStatusCodeString301)
			Return HttpStatusCodeString301Length
			
		Case 302
			lstrcpy(Buffer, @HttpStatusCodeString302)
			Return HttpStatusCodeString302Length
			
		Case 303
			lstrcpy(Buffer, @HttpStatusCodeString303)
			Return HttpStatusCodeString303Length
			
		Case 304
			lstrcpy(Buffer, @HttpStatusCodeString304)
			Return HttpStatusCodeString304Length
			
		Case 305
			lstrcpy(Buffer, @HttpStatusCodeString305)
			Return HttpStatusCodeString305Length
			
		Case 307
			lstrcpy(Buffer, @HttpStatusCodeString307)
			Return HttpStatusCodeString307Length
			
		Case 400
			lstrcpy(Buffer, @HttpStatusCodeString400)
			Return HttpStatusCodeString400Length
			
		Case 401
			lstrcpy(Buffer, @HttpStatusCodeString401)
			Return HttpStatusCodeString401Length
			
		Case 402
			lstrcpy(Buffer, @HttpStatusCodeString402)
			Return HttpStatusCodeString402Length
			
		Case 403
			lstrcpy(Buffer, @HttpStatusCodeString403)
			Return HttpStatusCodeString403Length
			
		Case 404
			lstrcpy(Buffer, @HttpStatusCodeString404)
			Return HttpStatusCodeString404Length
			
		Case 405
			lstrcpy(Buffer, @HttpStatusCodeString405)
			Return HttpStatusCodeString405Length
			
		Case 406
			lstrcpy(Buffer, @HttpStatusCodeString406)
			Return HttpStatusCodeString406Length
			
		Case 407
			lstrcpy(Buffer, @HttpStatusCodeString407)
			Return HttpStatusCodeString407Length
			
		Case 408
			lstrcpy(Buffer, @HttpStatusCodeString408)
			Return HttpStatusCodeString408Length
			
		Case 409
			lstrcpy(Buffer, @HttpStatusCodeString409)
			Return HttpStatusCodeString409Length
			
		Case 410
			lstrcpy(Buffer, @HttpStatusCodeString410)
			Return HttpStatusCodeString410Length
			
		Case 411
			lstrcpy(Buffer, @HttpStatusCodeString411)
			Return HttpStatusCodeString411Length
			
		Case 412
			lstrcpy(Buffer, @HttpStatusCodeString412)
			Return HttpStatusCodeString412Length
			
		Case 413
			lstrcpy(Buffer, @HttpStatusCodeString413)
			Return HttpStatusCodeString413Length
			
		Case 414
			lstrcpy(Buffer, @HttpStatusCodeString414)
			Return HttpStatusCodeString414Length
			
		Case 415
			lstrcpy(Buffer, @HttpStatusCodeString415)
			Return HttpStatusCodeString415Length
			
		Case 416
			lstrcpy(Buffer, @HttpStatusCodeString416)
			Return HttpStatusCodeString416Length
			
		Case 417
			lstrcpy(Buffer, @HttpStatusCodeString417)
			Return HttpStatusCodeString417Length
			
		Case 418
			lstrcpy(Buffer, @HttpStatusCodeString418)
			Return HttpStatusCodeString418Length
			
		Case 426
			lstrcpy(Buffer, @HttpStatusCodeString426)
			Return HttpStatusCodeString426Length
			
		Case 428
			lstrcpy(Buffer, @HttpStatusCodeString428)
			Return HttpStatusCodeString428Length
			
		Case 429
			lstrcpy(Buffer, @HttpStatusCodeString429)
			Return HttpStatusCodeString429Length
			
		Case 431
			lstrcpy(Buffer, @HttpStatusCodeString431)
			Return HttpStatusCodeString431Length
			
		Case 451
			lstrcpy(Buffer, @HttpStatusCodeString451)
			Return HttpStatusCodeString451Length
			
		Case 500
			lstrcpy(Buffer, @HttpStatusCodeString500)
			Return HttpStatusCodeString500Length
			
		Case 501
			lstrcpy(Buffer, @HttpStatusCodeString501)
			Return HttpStatusCodeString501Length
			
		Case 502
			lstrcpy(Buffer, @HttpStatusCodeString502)
			Return HttpStatusCodeString502Length
			
		Case 503
			lstrcpy(Buffer, @HttpStatusCodeString503)
			Return HttpStatusCodeString503Length
			
		Case 504
			lstrcpy(Buffer, @HttpStatusCodeString504)
			Return HttpStatusCodeString504Length
			
		Case 505
			lstrcpy(Buffer, @HttpStatusCodeString505)
			Return HttpStatusCodeString505Length
			
		Case 506
			lstrcpy(Buffer, @HttpStatusCodeString506)
			Return HttpStatusCodeString506Length
			
		Case 507
			lstrcpy(Buffer, @HttpStatusCodeString507)
			Return HttpStatusCodeString507Length
			
		Case 508
			lstrcpy(Buffer, @HttpStatusCodeString508)
			Return HttpStatusCodeString508Length
			
		Case 509
			lstrcpy(Buffer, @HttpStatusCodeString509)
			Return HttpStatusCodeString509Length
			
		Case 510
			lstrcpy(Buffer, @HttpStatusCodeString510)
			Return HttpStatusCodeString510Length
			
		Case 511
			lstrcpy(Buffer, @HttpStatusCodeString511)
			Return HttpStatusCodeString511Length
			
	End Select
	
	lstrcpy(Buffer, @HttpStatusCodeString200)
	Return HttpStatusCodeString200Length
End Function

Function GetKnownRequestHeaderNameCGI(ByVal HeaderIndex As HttpRequestHeaderIndices)As WString Ptr
	Select Case HeaderIndex
		
		Case HttpRequestHeaderIndices.HeaderAccept
			Return @"HTTP_ACCEPT"
			
		Case HttpRequestHeaderIndices.HeaderAcceptCharset
			Return @"HTTP_ACCEPT_CHARSET"
			
		Case HttpRequestHeaderIndices.HeaderAcceptEncoding
			Return @"HTTP_ACCEPT_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderAcceptLanguage
			Return @"HTTP_ACCEPT_LANGUAGE"
			
		Case HttpRequestHeaderIndices.HeaderAuthorization
			Return @"AUTH_TYPE"
			
		Case HttpRequestHeaderIndices.HeaderCacheControl
			Return @"HTTP_CACHE_CONTROL"
			
		Case HttpRequestHeaderIndices.HeaderConnection
			Return @"HTTP_CONNECTION"
			
		Case HttpRequestHeaderIndices.HeaderContentEncoding
			Return @"HTTP_CONTENT_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderContentLanguage
			Return @"HTTP_CONTENT_LANGUAGE"
			
		Case HttpRequestHeaderIndices.HeaderContentLength
			Return @"CONTENT_LENGTH"
			
		Case HttpRequestHeaderIndices.HeaderContentMd5
			Return @"HTTP_CONTENT_MD5"
			
		Case HttpRequestHeaderIndices.HeaderContentRange
			Return @"HTTP_CONTENT_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderContentType
			Return @"CONTENT_TYPE"
			
		Case HttpRequestHeaderIndices.HeaderCookie
			Return @"HTTP_COOKIE"
			
		Case HttpRequestHeaderIndices.HeaderExpect
			Return @"HTTP_EXPECT"
			
		Case HttpRequestHeaderIndices.HeaderFrom
			Return @"HTTP_FROM"
			
		Case HttpRequestHeaderIndices.HeaderHost
			Return @"HTTP_HOST"
			
		Case HttpRequestHeaderIndices.HeaderIfMatch
			Return @"HTTP_IF_MATCH"
			
		Case HttpRequestHeaderIndices.HeaderIfModifiedSince
			Return @"HTTP_IF_MODIFIED_SINCE"
			
		Case HttpRequestHeaderIndices.HeaderIfNoneMatch
			Return @"HTTP_IF_NONE_MATCH"
			
		Case HttpRequestHeaderIndices.HeaderIfRange
			Return @"HTTP_IF_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderIfUnmodifiedSince
			Return @"HTTP_IF_UNMODIFIED_SINCE"
			
		Case HttpRequestHeaderIndices.HeaderKeepAlive
			Return @"HTTP_KEEP_ALIVE"
			
		Case HttpRequestHeaderIndices.HeaderMaxForwards
			Return @"HTTP_MAX_FORWARDS"
			
		Case HttpRequestHeaderIndices.HeaderPragma
			Return @"HTTP_PRAGMA"
			
		Case HttpRequestHeaderIndices.HeaderProxyAuthorization
			Return @"HTTP_PROXY_AUTHORIZATION"
			
		Case HttpRequestHeaderIndices.HeaderRange
			Return @"HTTP_RANGE"
			
		Case HttpRequestHeaderIndices.HeaderReferer
			Return @"HTTP_REFERER"
			
		Case HttpRequestHeaderIndices.HeaderTe
			Return @"HTTP_TE"
			
		Case HttpRequestHeaderIndices.HeaderTrailer
			Return @"HTTP_TRAILER"
			
		Case HttpRequestHeaderIndices.HeaderTransferEncoding
			Return @"HTTP_TRANSFER_ENCODING"
			
		Case HttpRequestHeaderIndices.HeaderUpgrade
			Return @"HTTP_UPGRADE"
			
		Case HttpRequestHeaderIndices.HeaderUserAgent
			Return @"HTTP_USER_AGENT"
			
		Case HttpRequestHeaderIndices.HeaderVia
			Return @"HTTP_VIA"
			
		Case HttpRequestHeaderIndices.HeaderWarning
			Return @"HTTP_WARNING"
			
	End Select
	
	Return 0
End Function

