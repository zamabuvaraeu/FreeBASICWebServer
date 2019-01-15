#ifndef WEBRESPONSE_BI
#define WEBRESPONSE_BI

#include "Http.bi"
#include "Mime.bi"
#include "IServerResponse.bi"

Type WebResponse
	' Размер буфера для строки с заголовками ответа в символах
	Const MaxResponseHeaderBuffer As Integer = 32 * 1024 - 1
	
	' Максимальное количество заголовков ответа
	Const ResponseHeaderMaximum As Integer = 30
	
	' Буфер заголовков ответа
	Dim ResponseHeaderBuffer As WString * (MaxResponseHeaderBuffer + 1)
	' Указатель на свободное место в буфере заголовков ответа
	Dim StartResponseHeadersPtr As WString Ptr
	' Заголовки ответа
	Dim ResponseHeaders(ResponseHeaderMaximum - 1) As WString Ptr
	
	Dim StatusCode As Integer
	Dim StatusDescription As WString Ptr
	
	' Отправлять клиенту только заголовки
	Dim SendOnlyHeaders As Boolean
	' Поддержка соединения с клиентом
	Dim KeepAlive As Boolean
	
	' Сжатие данных, поддерживаемое сервером
	Dim ResponseZipMode As ZipModes
	
	Dim Mime As MimeType
	
	' Добавляет заголовок к заголовкам ответа
	Declare Sub AddResponseHeader( _
		ByVal HeaderName As WString Ptr, _
		ByVal Value As WString Ptr _
	)
	
	' Добавляет известный заголовок к заголовкам ответа
	Declare Sub AddKnownResponseHeader( _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)
	
	' Устанавливает описание кода ответа
	Declare Sub SetStatusDescription( _
		ByVal Description As WString Ptr _
	)
	
End Type

' Инициализация объекта состояния в начальное значение
Declare Sub InitializeWebResponse( _
	ByVal pWebResponse As WebResponse Ptr _
)

#endif
