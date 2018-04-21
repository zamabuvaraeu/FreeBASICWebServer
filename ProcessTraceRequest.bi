#ifndef PROCESSTRACEREQUEST_BI
#define PROCESSTRACEREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "ReadHeadersResult.bi"

Declare Function ProcessTraceRequest( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal pWebSite As WebSite Ptr, _
	ByVal fileExtention As WString Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr, _
	ByVal hRequestedFile As Handle _
)As Boolean

#endif
