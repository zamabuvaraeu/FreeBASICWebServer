#ifndef IREQUESTPROCESSOR_BI
#define IREQUESTPROCESSOR_BI

#include once "IAsyncResult.bi"
#include once "IClientRequest.bi"
#include once "INetworkStream.bi"
#include once "IServerResponse.bi"
#include once "IWebSite.bi"

Type _ProcessorContext
	Dim pIRequest As IClientRequest Ptr
	Dim pIResponse As IServerResponse Ptr
	Dim pINetworkStream As INetworkStream Ptr
	Dim pIWebSite As IWebSite Ptr
	Dim pIClientReader As IHttpReader Ptr
	Dim pIRequestedFile As IRequestedFile Ptr
	Dim pIMemoryAllocator As IMalloc Ptr
End Type

Type ProcessorContext As _ProcessorContext

Type LPProcessorContext As _ProcessorContext Ptr

Const REQUESTPROCESSOR_S_IO_PENDING As HRESULT = MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_ITF, &h0201)

'Prepare:
'S_OK
Const REQUESTPROCESSOR_E_FILENOTFOUND As HRESULT = MAKE_HRESULT(SEVERITY_ERROR, FACILITY_ITF, &h0201)
Const REQUESTPROCESSOR_E_FILEGONE As HRESULT = MAKE_HRESULT(SEVERITY_ERROR, FACILITY_ITF, &h0202)
Const REQUESTPROCESSOR_E_FORBIDDEN As HRESULT = MAKE_HRESULT(SEVERITY_ERROR, FACILITY_ITF, &h0203)

Type IRequestProcessor As IRequestProcessor_

Type LPIREQUESTPROCESSOR As IRequestProcessor Ptr

Extern IID_IRequestProcessor Alias "IID_IRequestProcessor" As Const IID

Type IRequestProcessorVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As IRequestProcessor Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As IRequestProcessor Ptr _
	)As ULONG
	
	Dim Prepare As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal pContext As ProcessorContext Ptr _
	)As HRESULT
	
	Dim Process As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal pContext As ProcessorContext Ptr _
	)As HRESULT
	
	Dim BeginProcess As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal pContext As ProcessorContext Ptr, _
		ByVal StateObject As IUnknown Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim EndProcess As Function( _
		ByVal this As IRequestProcessor Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr _
	)As HRESULT
	
End Type

Type IRequestProcessor_
	Dim lpVtbl As IRequestProcessorVirtualTable Ptr
End Type

#define IRequestProcessor_QueryInterface(this, riid, ppv) (this)->lpVtbl->QueryInterface(this, riid, ppv)
#define IRequestProcessor_AddRef(this) (this)->lpVtbl->AddRef(this)
#define IRequestProcessor_Release(this) (this)->lpVtbl->Release(this)
#define IRequestProcessor_Prepare(this, pContext) (this)->lpVtbl->Prepare(this, pContext)
#define IRequestProcessor_Process(this, pContext) (this)->lpVtbl->Process(this, pContext)
#define IRequestProcessor_BeginProcess(this, pContext, StateObject, ppIAsyncResult) (this)->lpVtbl->BeginProcess(this, pContext, StateObject, ppIAsyncResult)
#define IRequestProcessor_EndProcess(this, pIAsyncResult) (this)->lpVtbl->EndProcess(this, pIAsyncResult)

#endif
