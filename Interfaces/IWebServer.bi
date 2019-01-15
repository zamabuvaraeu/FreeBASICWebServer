#ifndef IWEBSERVER_BI
#define IWEBSERVER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\objbase.bi"

' {6603A8F5-FB80-4CB9-BF80-CEADE4576F52}
Dim Shared IID_IWEBSERVER As IID = Type(&h6603a8f5, &hfb80, &h4cb9, _
	{&hbf, &h80, &hce, &had, &he4, &h57, &h6f, &h52})

Type LPIWEBSERVER As IWebServer Ptr

Type IWebServer As IWebServer_

Type IWebServerVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim StartServer As Function( _
		ByVal pIWebServer As IWebServer Ptr _
	)As HRESULT
	
	Dim StopServer As Function( _
		ByVal pIWebServer As IWebServer Ptr _
	)As HRESULT
	
End Type

Type IWebServer_
	Dim pVirtualTable As IWebServerVirtualTable Ptr
End Type

#define IWebServer_QueryInterface(pIWebServer, riid, ppv) (pIWebServer)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pIWebServer), riid, ppv)
#define IWebServer_AddRef(pIWebServer) (pIWebServer)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, pIWebServer))
#define IWebServer_Release(pIWebServer) (pIWebServer)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, pIWebServer))
#define IWebServer_StartServer(pIWebServer) (pIWebServer)->pVirtualTable->StartServer(pIWebServer)
#define IWebServer_StopServer(pIWebServer) (pIWebServer)->pVirtualTable->StopServer(pIWebServer)

#endif
