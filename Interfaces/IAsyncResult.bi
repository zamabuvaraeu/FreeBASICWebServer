﻿#ifndef IASYNCRESULT_BI
#define IASYNCRESULT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Type IAsyncResult As IAsyncResult_

Type LPIASYNCRESULT As IAsyncResult Ptr

Type AsyncCallback As Sub(ByVal ar As IAsyncResult Ptr, ByVal ReadedBytes As Integer)

Extern IID_IAsyncResult Alias "IID_IAsyncResult" As Const IID

Type IAsyncResultVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim GetAsyncState As Function( _
		ByVal this As IAsyncResult Ptr, _
		ByVal ppState As Any Ptr Ptr _
	)As HRESULT
	
	Dim SetAsyncState As Function( _
		ByVal this As IAsyncResult Ptr, _
		ByVal pState As Any Ptr _
	)As HRESULT
	
End Type

Type IAsyncResult_
	Dim pVirtualTable As IAsyncResultVirtualTable Ptr
End Type

#define IAsyncResult_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IAsyncResult_AddRef(this) (this)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IAsyncResult_Release(this) (this)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, this))

#endif
