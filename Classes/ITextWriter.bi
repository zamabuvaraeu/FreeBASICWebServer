#ifndef ITEXTWRITER_BI
#define ITEXTWRITER_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\objbase.bi"

Type ITextWriter As ITextWriter_

Type LPITEXTWRITER As ITextWriter Ptr

Type ITextWriterVirtualTable
	Dim VirtualTable As IUnknownVtbl
	
	Dim CloseTextWriter As Function( _
		ByVal this As ITextWriter Ptr _
	)As HRESULT
	
	Dim OpenTextWriter As Function( _
		ByVal this As ITextWriter Ptr _
	)As HRESULT
	
	Dim Flush As Function( _
		ByVal this As ITextWriter Ptr _
	)As HRESULT
	
	Dim GetCodePage As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal CodePage As Integer Ptr _
	)As HRESULT
	
	Dim SetCodePage As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	
	Dim WriteNewLine As Function( _
		ByVal this As ITextWriter Ptr _
	)As HRESULT
	
	Dim WriteStringLine As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Dim WriteLengthStringLine As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	Dim WriteString As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Dim WriteLengthString As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	Dim WriteChar As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal wc As Integer _
	)As HRESULT
	
	Dim WriteInt32 As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal Value As Long _
	)As HRESULT
	
	Dim WriteInt64 As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal Value As LongInt _
	)As HRESULT
	
	Dim WriteUInt64 As Function( _
		ByVal this As ITextWriter Ptr, _
		ByVal Value As ULongInt _
	)As HRESULT
	
End Type

Type ITextWriter_
	Dim pVirtualTable As ITextWriterVirtualTable Ptr
End Type

#endif
