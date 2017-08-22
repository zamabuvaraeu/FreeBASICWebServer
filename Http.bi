#ifndef unicode
#define unicode
#endif

' Все поддерживаемые методы
Const AllSupportHttpMethods = "CONNECT, DELETE, GET, HEAD, OPTIONS, POST, PUT, TRACE"
' Все поддерживаемые методы для файла
Const AllSupportHttpMethodsFile = "DELETE, GET, HEAD, OPTIONS, PUT, TRACE"
' Все поддерживаемые методы для скриптов
Const AllSupportHttpMethodsScript = "DELETE, GET, HEAD, OPTIONS, POST, PUT, TRACE"

' Требуемый размер буфера для описания кода состояния Http
Const MaxHttpStatusCodeBufferLength As Integer = 32 - 1

' Версии протокола http
Enum HttpVersions
	Http11
	Http10
	Http09
End Enum

' Методы Http
Enum HttpMethods
	None
	HttpGet
	HttpHead
	HttpPost
	HttpPut
	HttpDelete
	HttpOptions
	HttpTrace
	HttpConnect
	HttpPatch
	HttpCopy
	HttpMove
	HttpPropfind
End Enum

' Индексы заголовков в массиве заголовков запроса
Enum HttpRequestHeaderIndices
	HeaderAccept
	HeaderAcceptCharset
	HeaderAcceptEncoding
	HeaderAcceptLanguage
	HeaderAuthorization
	HeaderCacheControl
	HeaderConnection
	HeaderContentEncoding
	HeaderContentLanguage
	HeaderContentLength
	HeaderContentMd5
	HeaderContentRange
	HeaderContentType
	HeaderCookie
	HeaderExpect
	HeaderFrom
	HeaderHost
	HeaderIfMatch
	HeaderIfModifiedSince
	HeaderIfNoneMatch
	HeaderIfRange
	HeaderIfUnmodifiedSince
	HeaderKeepAlive
	HeaderMaxForwards
	HeaderPragma
	HeaderProxyAuthorization
	HeaderRange
	HeaderReferer
	HeaderTe
	HeaderTrailer
	HeaderTransferEncoding
	HeaderUpgrade
	HeaderUserAgent
	HeaderVia
	HeaderWarning
End Enum

' Индексы заголовков в массиве заголовков ответа
' Помечены заголовки, которые клиент не может переопределить черз файл *.headers
Enum HttpResponseHeaderIndices
	HeaderAcceptRanges
	HeaderAge
	HeaderAllow
	HeaderCacheControl
	HeaderConnection            ' *
	HeaderContentEncoding
	HeaderContentLanguage
	HeaderContentLength         ' *
	HeaderContentLocation
	HeaderContentMd5
	HeaderContentRange
	HeaderContentType
	HeaderDate                  ' *
	HeaderETag
	HeaderExpires
	HeaderKeepAlive             ' *
	HeaderLastModified
	HeaderLocation
	HeaderPragma
	HeaderProxyAuthenticate
	HeaderRetryAfter
	HeaderServer                ' *
	HeaderSetCookie
	HeaderTrailer
	HeaderTransferEncoding      ' *
	HeaderUpgrade
	HeaderVary                  ' *
	HeaderVia
	HeaderWarning
	HeaderWwwAuthenticate
End Enum


' Заполняет буфер именем метода Http
' Возвращает длину строки без учёта нулевого символа
Declare Function GetHttpMethodString(ByVal Buffer As WString Ptr, ByVal HttpMethod As HttpMethods)As Integer

' Устанавливает текущий метод http из переменной RequestLine
Declare Function GetHttpMethod(ByVal s As WString Ptr)As HttpMethods

' Возвращает индексный номер указанного заголовка HTTP запроса
Declare Function GetKnownRequestHeaderIndex(ByVal Header As WString Ptr)As Integer

' Заполняет буфер заголовком запроса по индексу
' Возвращает длину строки без учёта нулевого символа
Declare Function GetKnownRequestHeaderName(ByVal Buffer As WString Ptr, ByVal HeaderIndex As HttpRequestHeaderIndices)As Integer

' Возвращает индексный номер указанного заголовка HTTP ответа
Declare Function GetKnownResponseHeaderIndex(ByVal Header As WString Ptr)As Integer

' Заполняет буфер заголовком ответа по индексу
' Возвращает длину строки без учёта нулевого символа
Declare Function GetKnownResponseHeaderName(ByVal Buffer As WString Ptr, ByVal HeaderIndex As HttpResponseHeaderIndices)As Integer

' Возвращает заголовок HTTP для CGI
' Очищать память для строки не нужно
Declare Function GetKnownRequestHeaderNameCGI(ByVal HeaderIndex As HttpRequestHeaderIndices)As WString Ptr

' Возвращает указатель на строку с описанием кода состояния
Declare Function GetStatusDescription(ByVal Buffer As WString Ptr, ByVal StatusCode As Integer)As Integer
