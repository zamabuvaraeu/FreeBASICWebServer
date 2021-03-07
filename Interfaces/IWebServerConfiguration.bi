#ifndef IWEBSERVERCONFIGURATION_BI
#define IWEBSERVERCONFIGURATION_BI

#include "windows.bi"
#include "win\ole2.bi"

Type IWebServerConfiguration As IWebServerConfiguration_

Type LPIWebServerConfiguration As IWebServerConfiguration Ptr

Extern IID_IWebServerConfiguration Alias "IID_IWebServerConfiguration" As Const IID

Type IWebServerConfigurationVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As IWebServerConfiguration Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As IWebServerConfiguration Ptr _
	)As ULONG
		
	Dim GetListenAddress As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal bstrListenAddress As BSTR Ptr _
	)As HRESULT
	
	Dim GetListenPort As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal pListenPort As UINT Ptr _
	)As HRESULT
	
	Dim GetConnectBindAddress As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal bstrConnectBindAddress As BSTR Ptr _
	)As HRESULT
	
	Dim GetConnectBindPort As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal pConnectBindPort As UINT Ptr _
	)As HRESULT
	
End Type

Type IWebServerConfiguration_
	Dim lpVtbl As IWebServerConfigurationVirtualTable Ptr
End Type

#define IWebServerConfiguration_QueryInterface(this, riid, ppv) (this)->lpVtbl->QueryInterface(this, riid, ppv)
#define IWebServerConfiguration_AddRef(this) (this)->lpVtbl->AddRef(this)
#define IWebServerConfiguration_Release(this) (this)->lpVtbl->Release(this)
#define IWebServerConfiguration_GetListenAddress(this, bstrListenAddress) (this)->lpVtbl->GetListenAddress(this, bstrListenAddress)
#define IWebServerConfiguration_GetListenPort(this, pListenPort) (this)->lpVtbl->GetListenPort(this, pListenPort)
#define IWebServerConfiguration_GetConnectBindAddress(this, bstrConnectBindAddress) (this)->lpVtbl->GetConnectBindAddress(this, bstrConnectBindAddress)
#define IWebServerConfiguration_GetConnectBindPort(this, pConnectBindPort) (this)->lpVtbl->GetConnectBindPort(this, pConnectBindPort)

#endif
