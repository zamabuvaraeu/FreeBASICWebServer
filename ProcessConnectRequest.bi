﻿#ifndef PROCESSCONNECTREQUEST_BI
#define PROCESSCONNECTREQUEST_BI

#include "IClientRequest.bi"
#include "INetworkStream.bi"
#include "IServerResponse.bi"
#include "IWebSite.bi"

Declare Function ProcessConnectRequest( _
	ByVal pIRequest As IClientRequest Ptr, _
	ByVal pIResponse As IServerResponse Ptr, _
	ByVal pINetworkStream As INetworkStream Ptr, _
	ByVal pIWebSite As IWebSite Ptr, _
	ByVal pIClientReader As IHttpReader Ptr, _
	ByVal pIRequestedFile As IRequestedFile Ptr _
)As Boolean

#endif
