﻿#ifndef IRUNNABLE_BI
#define IRUNNABLE_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Type IRunnable As IRunnable_

Type LPIRUNNABLE As IRunnable Ptr

Extern IID_IRunnable Alias "IID_IRunnable" As Const IID

Type IRunnableVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim Run As Function( _
		ByVal this As IRunnable Ptr _
	)As HRESULT
	
	Dim Stop As Function( _
		ByVal this As IRunnable Ptr _
	)As HRESULT
	
End Type

Type IRunnable_
	Dim pVirtualTable As IRunnableVirtualTable Ptr
End Type

#define IRunnable_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IRunnable_AddRef(this) (this)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IRunnable_Release(this) (this)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define IRunnable_Run(this) (this)->pVirtualTable->Run(this)
#define IRunnable_Stop(this) (this)->pVirtualTable->Stop(this)

#endif
