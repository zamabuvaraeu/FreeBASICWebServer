#ifndef PROCESSDLLREQUEST_BI
#define PROCESSDLLREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "WebSite.bi"
#include once "ReadHeadersResult.bi"

Declare Function ProcessDllCgiRequest( _
	ByVal state As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal www As SimpleWebSite Ptr, _
	ByVal pRequestedFile As RequestedFile Ptr _
)As Boolean

#endif
