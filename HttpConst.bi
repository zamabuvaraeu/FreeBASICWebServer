#ifndef HTTPCONST_BI
#define HTTPCONST_BI

Const HttpVersion10 = "HTTP/1.0"
Const HttpVersion11 = "HTTP/1.1"

Const HttpVersion10Length As Integer = 8
Const HttpVersion11Length As Integer = 8

Const BytesString = "bytes"
Const CloseString = "Close"
Const GzipString = "gzip"
Const DeflateString = "deflate"
Const HeadersExtensionString = ".headers"
Const FileGoneExtension = ".410"
Const QuoteString = """"
Const ContentCharsetUtf8 = "; charset=utf-8"
Const ContentCharsetUtf16 = "; charset=utf-16"
Const BasicAuthorization = "Basic"

' Максимальный размер полученного от клиента тела запроса
' TODO Вынести в конфигурацию ограничение на максимальный размер тела запроса
Const MaxRequestBodyContentLength As LongInt = 20 * 1024 * 1024

#endif
