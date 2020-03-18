#ifndef IREQUESTPROCESSOR_BI
#define IREQUESTPROCESSOR_BI

#include "IWebSite.bi"
#include "IClientRequest.bi"
#include "IHttpReader.bi"
#include "INetworkStream.bi"

Type IRequestProcessor As IRequestProcessor_

Type LPIREQUESTPROCESSOR As IRequestProcessor Ptr

Extern IID_IRequestProcessor Alias "IID_IRequestProcessor" As Const IID

Type IRequestProcessorVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim Process As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal pIWebSite As IWebSite Ptr, _
		ByVal pIRequest As IClientRequest Ptr, _
		ByVal pIHttpReader As IHttpReader Ptr, _
		ByVal pIWriter As INetworkStream Ptr, _
		ByVal dwError As DWORD _
	)As HRESULT
End Type

Type IRequestProcessor_
	Dim pVirtualTable As IRequestProcessorVirtualTable Ptr
End Type

#endif
