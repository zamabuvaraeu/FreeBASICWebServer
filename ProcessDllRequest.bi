#ifndef PROCESSDLLREQUEST_BI
#define PROCESSDLLREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\winsock2.bi"
#include "win\ws2tcpip.bi"
#include "WebSite.bi"
#include "ReadHeadersResult.bi"

Declare Function ProcessDllCgiRequest( _
	ByVal state As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal www As SimpleWebSite Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr, _
	ByVal pRequestedFile As RequestedFile Ptr _
)As Boolean

#endif
