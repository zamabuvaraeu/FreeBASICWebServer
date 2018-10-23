#ifndef ISERVERRESPONSE_BI
#define ISERVERRESPONSE_BI

#include "IBaseStream.bi"

' {C1BFB23D-79B3-4AE9-BEF9-5BF9D3073B84}
Dim Shared IID_IServerResponse As IID = Type(&hc1bfb23d, &h79b3, &h4ae9, _
	{&hbe, &hf9, &h5b, &hf9, &hd3, &h7, &h3b, &h84})

Type LPISERVERRESPONSE As IServerResponse Ptr

Type IServerResponse As IServerResponse_

Type IServerResponseVirtualTable
	Dim VirtualTable As IUnknownVtbl
	
	Dim GetStatusCode As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal pStatusCode As Integer Ptr _
	)As HRESULT
	
	Dim SetStatusCode As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal StatusCode As Integer _
	)As HRESULT
	
	Dim GetStatusDescription As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pStatusDescription As WString Ptr _
	)As HRESULT
	
	Dim SetStatusDescription As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal pStatusDescription As WString Ptr _
	)As HRESULT
	
	Dim GetKeepAlive As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal pKeepAlive As Boolean Ptr _
	)As HRESULT
	
	Dim SetKeepAlive As Function( _
		ByVal this As IServerResponse Ptr, _
		ByVal KeepAlive As Boolean _
	)As HRESULT
	
End Type

Type IServerResponse_
	Dim pVirtualTable As IServerResponseVirtualTable Ptr
End Type

#endif
