#ifndef ISTRING_BI
#define ISTRING_BI

#include once "windows.bi"
#include once "win\ole2.bi"

Type IString As IString_

Type LPISTRING As IString Ptr

Extern IID_IString Alias "IID_IString" As Const IID

Type IStringVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As IString Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As IString Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As IString Ptr _
	)As ULONG
		
End Type

Type IString_
	Dim lpVtbl As IStringVirtualTable Ptr
End Type

#define IString_QueryInterface(this, riid, ppv) (this)->lpVtbl->QueryInterface(this, riid, ppv)
#define IString_AddRef(this) (this)->lpVtbl->AddRef(this)
#define IString_Release(this) (this)->lpVtbl->Release(this)

#endif
