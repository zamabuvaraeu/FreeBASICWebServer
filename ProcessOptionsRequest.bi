#ifndef PROCESSOPTIONSREQUEST_BI
#define PROCESSOPTIONSREQUEST_BI

#include "INetworkStream.bi"
#include "WebSite.bi"
#include "WebRequest.bi"
#include "WebResponse.bi"

Declare Function ProcessOptionsRequest( _
	ByVal pRequest As WebRequest Ptr, _
	ByVal pResponse As WebResponse Ptr, _
	ByVal pINetworkStream As INetworkStream Ptr, _
	ByVal pWebSite As SimpleWebSite Ptr, _
	ByVal pClientReader As StreamSocketReader Ptr, _
	ByVal pRequestedFile As RequestedFile Ptr _
)As Boolean

#endif
