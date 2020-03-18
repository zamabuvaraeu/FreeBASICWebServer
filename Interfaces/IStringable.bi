#ifndef ISTRINGABLE_BI
#define ISTRINGABLE_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Type LPISTRINGABLE As IStringable Ptr

Type IStringable As IStringable_

Extern IID_IStringable Alias "IID_IStringable" As Const IID

Type IStringableVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim ToString As Function( _
		ByVal this As IStringable Ptr, _
		ByVal ppResult As WString Ptr Ptr _
	)As HRESULT
	
End Type

Type IStringable_
	Dim pVirtualTable As IStringableVirtualTable Ptr
End Type

#define IStringable_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IStringable_AddRef(this) (this)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IStringable_Release(this) (this)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define IStringable_ToString(this, ppResult) (this)->pVirtualTable->ToString(this, ppResult)

#endif
