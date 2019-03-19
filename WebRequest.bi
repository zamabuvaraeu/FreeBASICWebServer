#ifndef WEBREQUEST_BI
#define WEBREQUEST_BI

#include "Http.bi"
#include "URI.bi"
#include "IHttpReader.bi"

Enum ParseRequestLineResult
	' Ошибок нет
	Success
	' Версия протокола не поддерживается
	HttpVersionNotSupported
	' Фальшивый Host
	BadHost
	' Ошибка в запросе, синтаксисе запроса
	BadRequest
	' Плохой путь
	BadPath
	' Клиент закрыл соединение
	EmptyRequest
	' Ошибка сокета
	SocketError
	' Url слишком длинный
	RequestUrlTooLong
	' Превышена допустимая длина заголовков
	RequestHeaderFieldsTooLarge 
	' Метод не распознан
	HpptMethodNotSupported
End Enum

Enum ByteRangeIsSet
	NotSet
	FirstBytePositionIsSet
	LastBytePositionIsSet
	FirstAndLastPositionIsSet
End Enum

Type ByteRange
	Dim IsSet As ByteRangeIsSet
	Dim FirstBytePosition As LongInt
	Dim LastBytePosition As LongInt
End Type

Type WebRequest
	' Размер буфера для строки с заголовками запроса в символах (не включая нулевой)
	Const MaxRequestHeaderBuffer As Integer = 32 * 1024 - 1
	
	' Сжатие данных, поддерживаемое клиентом
	Const MaxRequestZipEnabled As Integer = 2
	
	' Сжатие GZip
	Const GZipIndex As Integer = 0
	
	' Сжатие Deflate
	Const DeflateIndex As Integer = 1
	
	' Буфер заголовков запроса клиента
	Dim RequestHeaderBuffer As WString * (MaxRequestHeaderBuffer + 1)
	
	' Длина буфера запроса клиента
	Dim RequestHeaderBufferLength As Integer
	
	' Распознанные заголовки запроса
	Dim RequestHeaders(HttpRequestHeadersMaximum - 1) As WString Ptr
	
	' Метод HTTP
	Dim HttpMethod As HttpMethods
	
	' URI запрошенный клиентом
	Dim ClientURI As URI
	
	' Версия http‐протокола
	Dim HttpVersion As HttpVersions
	
	' Поддерживать соединение с клиентом
	Dim KeepAlive As Boolean
	
	' Список поддерживаемых сжатий данных
	Dim RequestZipModes(MaxRequestZipEnabled - 1) As Boolean
	
	' Байтовый диапазон запроса
	Dim RequestByteRange As ByteRange
	
	Declare Function ReadClientHeaders( _
		ByVal pIClientReader As IHttpReader Ptr _
	)As Boolean
	
End Type

' Инициализация объекта запроса в начальное значение
Declare Sub InitializeWebRequest( _
	ByVal pRequest As WebRequest Ptr _
)

#endif
