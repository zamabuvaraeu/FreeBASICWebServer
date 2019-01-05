#ifndef PROCESSDELETEREQUEST_BI
#define PROCESSDELETEREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\winsock2.bi"
#include "win\ws2tcpip.bi"
#include "WebSite.bi"
#include "ReadHeadersResult.bi"

Declare Function ProcessDeleteRequest( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal ClientSocket As SOCKET, _
	ByVal pWebSite As SimpleWebSite Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr, _
	ByVal hRequestedFile As RequestedFile Ptr _
)As Boolean

#endif
