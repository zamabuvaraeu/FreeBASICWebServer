#ifndef ITEXTREADER_BI
#define ITEXTREADER_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\objbase.bi"

Type ITextReader As ITextReader_

Type ITextReaderVirtualTable
	Dim VirtualTable As IUnknownVtbl
	
	Dim CloseTextReader As Function( _
		ByVal this As ITextReader Ptr _
	)As HRESULT
	
	Dim OpenTextReader As Function( _
		ByVal this As ITextReader Ptr _
	)As HRESULT
	
End Type

Type ITextReader_
	Dim pVirtualTable As ITextReaderVirtualTable Ptr
End Type

#endif
