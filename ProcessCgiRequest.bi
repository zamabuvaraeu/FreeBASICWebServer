#ifndef PROCESSCGIREQUEST_BI
#define PROCESSCGIREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "WebSite.bi"
#include once "ReadHeadersResult.bi"

Declare Function ProcessCgiRequest( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal pWebSite As WebSite Ptr, _
	ByVal fileExtention As WString Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr _
)As Boolean

#endif
