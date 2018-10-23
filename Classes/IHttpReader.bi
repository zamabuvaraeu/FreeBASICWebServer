#ifndef IHTTPREADER_BI
#define IHTTPREADER_BI

#include "IBaseStream.bi"

' {D34D026F-D057-422F-9B32-C6D9424336F2}
Dim Shared IID_IHTTPREADER As IID = Type(&hd34d026f, &hd057, &h422f, _
	{&h9b, &h32, &hc6, &hd9, &h42, &h43, &h36, &hf2})

Type LPIHTTPREADER As IHttpReader Ptr

Type IHttpReader As IHttpReader_

Type IHttpReaderVirtualTable
	Dim VirtualTable As IUnknownVtbl
End Type

Type IHttpReader_
	Dim pVirtualTable As IHttpReaderVirtualTable Ptr
End Type

#endif
