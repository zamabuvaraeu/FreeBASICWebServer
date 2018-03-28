#ifndef HTTPCONST_BI
#define HTTPCONST_BI

Const HttpVersion10 = "HTTP/1.0"
Const HttpVersion11 = "HTTP/1.1"

Const HttpVersion10Length As Integer = 8
Const HttpVersion11Length As Integer = 8

Const SecondsInOneMonths As LongInt = 2678400
Const DefaultCacheControl = "max-age=2678400"

Const HttpServerNameString = "Station922/0.6.5.6 (FreeBASIC, Windows)"
Const BytesString = "bytes"
Const CloseString = "Close"
Const DeflateString = "deflate"
Const GzipString = "gzip"
Const GzipExtensionString = ".gz"
Const DeflateExtensionString = ".deflate"
Const HeadersExtensionString = ".headers"
Const FileGoneExtension = ".410"
Const QuoteString = """"
Const ContentCharsetUtf8 = "; charset=utf-8"
Const ContentCharsetUtf16 = "; charset=utf-16"
Const ContentCharset8bit = "; charset=8bit"
Const BasicAuthorization = "Basic"

' Максимальный размер полученного от клиента тела запроса
' TODO Вынести в конфигурацию ограничение на максимальный размер тела запроса
Const MaxRequestBodyContentLength As LongInt = 20 * 1024 * 1024

#endif
