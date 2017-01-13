#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\shlwapi.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"

#include once "Http.bi"
#include once "WebSite.bi"
#include once "URI.bi"

Declare Function itow cdecl Alias "_itow" (ByVal Value As Integer, ByVal src As WString Ptr, ByVal radix As Integer)As WString Ptr
Declare Function ltow cdecl Alias "_ltow" (ByVal Value As Long, ByVal src As WString Ptr, ByVal radix As Integer)As WString Ptr
Declare Function wtoi cdecl Alias "_wtoi" (ByVal src As WString Ptr)As Integer
Declare Function wtol cdecl Alias "_wtol" (ByVal src As WString Ptr)As Long

Const UsersIniFileString = "users.config"
Const AdministratorsSectionString = "admins"

' Флаги сжатия содержимого
Enum ZipModes
	' Без сжатия
	None
	' Сжатие Deflate
	Deflate
	' Сжатие GZip
	GZip
End Enum

Enum ParseRequestLineResult
	' Ошибок нет
	Success
	' Версия протокола не поддерживается
	HTTPVersionNotSupported
	' Метод не поддерживается сервером
	MethodNotSupported
	' Нужен заголовок Host
	HostRequired
	' Фальшивый Host
	BadHost
	' Ошибка в запросе, синтаксисе запроса
	BadRequest
	' Плохой путь
	BadPath
	' Клиент закрыл соединение
	EmptyRequest
	' Url слишком длинный
	RequestUrlTooLong
	' Превышена допустимая длина заголовков
	RequestHeaderFieldsTooLarge 
End Enum

Enum HttpAuthResult
	' Аутентификация успешно пройдена
	Success
	' Требуется авторизация
	NeedAuth
	' Параметры авторизации неверны
	BadAuth
	' Необходимо использовать Basic‐авторизацию
	NeedBasicAuth
	' Пароль не может быть пустым
	EmptyPassword
	' Имя пользователя или пароль не подходят
	BadUserNamePassword
End Enum

' Результат чтения данных от клиента
Type ReadLineResult
	Dim wLine As WString Ptr
	Dim ErrorStatus As ParseRequestLineResult
End Type

' Результат чтения заголовков запроса
Type ReadHeadersResult
	' Максимальное количество байт в запросе клиента
	Const MaxRequestHeaderBytes As Integer = 16 * 1024 - 1
	' Размер буфера для строки с заголовками запроса в символах (не включая нулевой)
	Const MaxRequestHeaderBuffer As Integer = 16 * 1024 - 1
	' Размер буфера для строки с заголовками ответа в символах (не включая нулевой)
	Const MaxResponseHeaderBuffer As Integer = 16 * 1024 - 1
	' Максимальное количество заголовков запроса
	Const RequestHeaderMaximum As Integer = 36
	' Максимальное количество заголовков ответа
	Const ResponseHeaderMaximum As Integer = 30
	
	' Буфер запроса клиента (заголовок + частично тело), с дополнительным местом для нулевого байта
	Dim HeaderBytes As ZString * (MaxRequestHeaderBytes + 1)
	' Количество байт запроса клиента
	Dim HeaderBytesLength As Integer
	' Индекс первого байта после конца заголовков HTTP (конец заголовков + пустая строка)
	' После чтения запроса клиента будет указывать на начало тела запроса (если оно есть)
	Dim EndHeadersOffset As Integer
	
	' Буфер заголовков запроса клиента
	Dim RequestHeaderBuffer As WString * (MaxRequestHeaderBuffer + 1)
	' Длина буфера запроса клиента
	Dim RequestHeaderBufferLength As Integer
	' Буфер дополнительных заголовков ответа
	Dim ResponseHeaderBuffer As WString * (MaxResponseHeaderBuffer + 1)
	' Указатель на свободное место в буфере заголовков ответа
	Dim StartResponseHeadersPtr As WString Ptr
	' Распознанные заголовки запроса
	Dim RequestHeaders(RequestHeaderMaximum - 1) As WString Ptr
	' Заголовки ответа
	Dim ResponseHeaders(ResponseHeaderMaximum - 1) As WString Ptr
	
	' Строка состояния
	Dim StatusDescription As WString Ptr
	
	' Версия http‐протокола
	Dim HttpVersion As HttpVersions
	' Метод HTTP
	Dim HttpMethod As HttpMethods
	
	' URI запрошенный клиентом
	Dim URI As URI
	
	' Код ответа клиенту
	Dim StatusCode As Integer
	' Отправлять клиенту только заголовки
	Dim SendOnlyHeaders As Boolean
	' Поддерживать соединение с клиентом
	Dim KeepAlive As Boolean
	' Сжатие данных
	Dim ZipEnabled As ZipModes
	
	' Добавляет заголовки компрессии gzip или deflate и возвращает идентификатор открытого файла
	Declare Function AddResponseCompressionMethodHeader(ByVal IsTextFormat As Boolean)As Handle
	
	' Добавляет заголовки кеширования для файла и проверяет совпадение на заголовки кэширования
	Declare Sub AddResponseCacheHeaders(ByVal hFile As HANDLE)
	
	' Добавляет любой другой заголовок к заголовкам ответа
	Declare Sub AddResponseHeader(ByVal HeaderName As WString Ptr, ByVal Value As WString Ptr)
	
	' Устанавливает описание кода ответа
	Declare Sub SetStatusDescription(ByVal Description As WString Ptr)
	
	' Добавляет заголовок в массив заголовков запроса клиента
	Declare Sub AddRequestHeader(ByVal Header As WString Ptr, ByVal Value As WString Ptr)
	
	' Читает строку от клиента
	Declare Sub ReadLine(ByVal wResult As ReadLineResult Ptr, ByVal ClientSocket As SOCKET)
	
	' Читает заголовки запроса
	Declare Function ReadAllHeaders(ByVal ClientSocket As SOCKET)As ParseRequestLineResult
	
	' Проверяет авторизацию Http
	Declare Function HttpAuth(ByVal www As WebSite Ptr)As HttpAuthResult
	
	' Заполняет буфер строкой с заголовками ответа
	' Возвращает длину буфера в символах (без учёта нулевого)
	Declare Function MakeResponseHeaders(ByVal Buffer As ZString Ptr, ByVal ContentLength As LongInt, ByVal hOutput As Handle)As Integer
	
End Type
