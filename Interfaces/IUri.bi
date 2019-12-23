﻿#ifndef IURI_BI
#define IURI_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Type IUri As IUri_

Type LPIURI As IUri Ptr

Extern IID_IClientUri Alias "IID_IClientUri" As Const IID

Type IUriVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim PathDecode As Function( _
		ByVal pIUri As IUri Ptr, _
		ByVal Buffer As WString Ptr _
	)As HRESULT
End Type

Type IUri_
	Dim pVirtualTable As IUriVirtualTable Ptr
End Type

#endif
