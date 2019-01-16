#ifndef ISERVERSTATE_BI
#define ISERVERSTATE_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\ole2.bi"
#include once "Http.bi"

Const ProgID_ServerState = "BatchedFiles.Station922"

Const CLSIDS_SERVERSTATE = "{E9BE6663-1ED6-45A4-9090-01FF8A82AB99}"

' {E9BE6663-1ED6-45A4-9090-01FF8A82AB99}
Dim Shared CLSID_SERVERSTATE As CLSID = Type(&he9be6663, &h1ed6, &h45a4, _
	{&h90, &h90, &h01, &hff, &h8a, &h82, &hab, &h99})

' {226A7229-6122-45C4-AFFB-C7DEB403A13A}
Dim Shared IID_ISERVERSTATE As IID = Type(&h226a7229, &h6122, &h45c4, _
	{&haf, &hfb, &hc7, &hde, &hb4, &h3, &ha1, &h3a})

Type LPISERVERSTATE As IServerState Ptr

Type IServerState As IServerState_

Type IServerStateVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim GetRequestHeader As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Value As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HeaderIndex As HttpRequestHeaders, _
		ByVal pHeaderLength As Integer Ptr _
	)As HRESULT
	
	Dim GetHttpMethod As Function( _
		ByVal this As IServerState Ptr, _
		ByVal pMethod As HttpMethods Ptr _
	)As HRESULT
	
	Dim GetHttpVersion As Function( _
		ByVal this As IServerState Ptr, _
		ByVal pVersion As HttpVersions Ptr _
	)As HRESULT
	
	Dim SetStatusCode As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Code As Integer _
	)As HRESULT
	
	Dim GetStatusCode As Function( _
		ByVal this As IServerState Ptr, _
		ByVal pStatusCode As Integer Ptr _
	)As HRESULT
	
	Dim SetStatusDescription As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Description As WString Ptr _
	)As HRESULT
	
	Dim GetStatusDescription As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Description As WString Ptr _
	)As HRESULT
	
	Dim SetResponseHeader As Function( _
		ByVal this As IServerState Ptr, _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)As HRESULT
	
	Dim WriteData As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BytesCount As Integer, _
		ByVal pResult As Integer Ptr _
	)As HRESULT
	
	Dim ReadData As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BufferLength As Integer, _
		ByVal ReadedBytesCount As Integer Ptr, _
		ByVal pResult As Integer Ptr _
	)As HRESULT
	
	Dim GetHtmlSafeString As Function( _
		ByVal this As IServerState Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal HtmlSafeLength As Integer Ptr, _
		ByVal pResult As Integer Ptr _
	)As HRESULT
	
End Type

Type IServerState_
	Dim pVirtualTable As IServerStateVirtualTable Ptr
End Type

#endif
