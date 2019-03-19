#ifndef PROCESSOPTIONSREQUEST_BI
#define PROCESSOPTIONSREQUEST_BI

#include "INetworkStream.bi"
#include "IWebSite.bi"
#include "WebRequest.bi"
#include "WebResponse.bi"

Declare Function ProcessOptionsRequest( _
	ByVal pRequest As WebRequest Ptr, _
	ByVal pResponse As WebResponse Ptr, _
	ByVal pINetworkStream As INetworkStream Ptr, _
	ByVal pIWebSite As IWebSite Ptr, _
	ByVal pIClientReader As IHttpReader Ptr, _
	ByVal pIRequestedFile As IRequestedFile Ptr _
)As Boolean

#endif
