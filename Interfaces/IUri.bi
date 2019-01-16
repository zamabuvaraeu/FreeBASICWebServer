#ifndef IURI_BI
#define IURI_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

' {FA6493DA-9102-4FF6-822E-163399BF9E81}
Dim Shared IID_IURI As IID = Type(&hfa6493da, &h9102, &h4ff6, _
	{&h82, &h2e, &h16, &h33, &h99, &hbf, &h9e, &h81})

Type LPIURI As IUri Ptr

Type IUri As IUri_

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
