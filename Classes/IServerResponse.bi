#ifndef ISERVERRESPONSE_BI
#define ISERVERRESPONSE_BI

' {C1BFB23D-79B3-4AE9-BEF9-5BF9D3073B84}
Dim Shared IID_IServerResponse As IID = Type(&hc1bfb23d, &h79b3, &h4ae9, _
	{&hbe, &hf9, &h5b, &hf9, &hd3, &h7, &h3b, &h84})

Type LPISERVERRESPONSE As IServerResponse Ptr

Type IServerResponse As IServerResponse_

Type IServerResponseVirtualTable
	Dim VirtualTable As IUnknownVtbl
	
End Type

Type IServerResponse_
	Dim pVirtualTable As IServerResponseVirtualTable Ptr
End Type

#endif
