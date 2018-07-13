#ifndef PROCESSOPTIONSREQUEST_BI
#define PROCESSOPTIONSREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "ReadHeadersResult.bi"

Declare Function ProcessOptionsRequest( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal pWebSite As SimpleWebSite Ptr, _
	ByVal fileExtention As WString Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr, _
	ByVal hRequestedFile As Handle _
)As Boolean

#endif
