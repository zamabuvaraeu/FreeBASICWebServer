﻿#ifndef ISENDABLE_BI
#define ISENDABLE_BI

#include "INetworkStream.bi"

Type ISendable As ISendable_

Type LPISENDABLE As ISendable Ptr

Extern IID_ISendable Alias "IID_ISendable" As Const IID

Type ISendableVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim Send As Function( _
		ByVal this As ISendable Ptr, _
		ByVal pIStream As INetworkStream Ptr _
	)As HRESULT
	
End Type

Type ISendable_
	Dim pVirtualTable As ISendableVirtualTable Ptr
End Type

#endif
