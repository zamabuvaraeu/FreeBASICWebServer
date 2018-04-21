#ifndef WRITEHTTPERROR_BI
#define WRITEHTTPERROR_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "ReadHeadersResult.bi"

Enum HttpErrors
	' TODO Исправить для ошибок HttpCreated и HttpCreatedUpdated, которые на самом деле не ошибки
	HttpCreated
	HttpCreatedUpdated
	HttpError400BadRequest
	HttpError400BadPath
	HttpError400Host
	HttpError403File
	HttpError411LengthRequired
	HttpError413RequestEntityTooLarge
	HttpError414RequestUrlTooLarge
	HttpError431RequestRequestHeaderFieldsTooLarge
	HttpError500NotAvailable
	HttpError501MethodNotAllowed
	HttpError501ContentTypeEmpty
	HttpError501ContentEncoding
	HttpError502BadGateway
	HttpError503Memory
	HttpError503ThreadError
	HttpError504GatewayTimeout
	HttpError505VersionNotSupported
	' TODO Заменить на говорящие названия
	NeedUsernamePasswordString
	NeedUsernamePasswordString1
	NeedUsernamePasswordString2
	NeedUsernamePasswordString3
	HttpError404FileNotFound
	HttpError410Gone
	MovedPermanently
End Enum

' Записывает ошибку ответа в поток
Declare Sub WriteHttpError( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal MessageType As HttpErrors, _
	ByVal VirtualPath As WString Ptr _
)

' Отправляет клиенту «Ресурс создан»
Declare Function WriteHttp201( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal www As WebSite Ptr _
)As Boolean

' Отправляет клиенту перенаправление
Declare Sub WriteHttp301( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal www As WebSite Ptr _
)

#endif
