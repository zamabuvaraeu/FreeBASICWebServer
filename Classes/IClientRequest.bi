#ifndef ICLIENTREQUEST_BI
#define ICLIENTREQUEST_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\objbase.bi"
#include once "..\Http.bi"

' {E998CAB4-5559-409C-93BC-97AFDF6A3921}
Dim Shared IID_ICLIENTREQUEST As IID = Type(&he998cab4, &h5559, &h409c, _
	{&h93, &hbc, &h97, &haf, &hdf, &h6a, &h39, &h21})

Type LPICLIENTREQUEST As IClientRequest Ptr

Type IClientRequest As IClientRequest_

Type IClientRequestVirtualTable
	Dim VirtualTable As IUnknownVtbl
	
	Dim GetHttpMethod As Function( _
		ByVal this As IClientRequest Ptr, _
		ByVal pHttpMethod As HttpMethods Ptr _
	)As HRESULT
	
	Dim GetHttpVersion As Function( _
		ByVal this As IClientRequest Ptr, _
		ByVal pHttpVersions As HttpVersions Ptr _
	)As HRESULT
	
	'uri
	'httpheaders
End Type

Type IClientRequest_
	Dim pVirtualTable As IClientRequestVirtualTable Ptr
End Type

#endif
