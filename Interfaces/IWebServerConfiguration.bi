#ifndef IWEBSERVERCONFIGURATION_BI
#define IWEBSERVERCONFIGURATION_BI

#include once "IWebSiteCollection.bi"

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
	
	Dim GetWorkerThreadsCount As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal pWorkerThreadsCount As Integer Ptr _
	)As HRESULT
	
	Dim GetCachedClientMemoryContextCount As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal pCachedClientMemoryContextCount As Integer Ptr _
	)As HRESULT
	
	Dim GetIsPasswordValid As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal pUserName As WString Ptr, _
		ByVal pPassword As WString Ptr, _
		ByVal pIsPasswordValid As Boolean Ptr _
	)As HRESULT
	
	Dim GetWebSiteCollection As Function( _
		ByVal this As IWebServerConfiguration Ptr, _
		ByVal ppIWebSiteCollection As IWebSiteCollection Ptr Ptr _
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
#define IWebServerConfiguration_GetWorkerThreadsCount(this, pWorkerThreadsCount) (this)->lpVtbl->GetWorkerThreadsCount(this, pWorkerThreadsCount)
#define IWebServerConfiguration_GetCachedClientMemoryContextCount(this, pCachedClientMemoryContext) (this)->lpVtbl->GetCachedClientMemoryContextCount(this, pCachedClientMemoryContext)
#define IWebServerConfiguration_GetDefaultWebSite(this, ppIWebSite) (this)->lpVtbl->GetDefaultWebSite(this, ppIWebSite)
#define IWebServerConfiguration_GetIsPasswordValid(this, pUserName, pPassword, pIsPasswordValid) (this)->lpVtbl->GetIsPasswordValid(this, pUserName, pPassword, pIsPasswordValid)
#define IWebServerConfiguration_GetWebSiteCollection(this, ppIWebSiteCollection) (this)->lpVtbl->GetWebSiteCollection(this, ppIWebSiteCollection)

#endif
