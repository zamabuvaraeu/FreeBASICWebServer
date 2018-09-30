#ifndef ARRAYSTRINGWRITER_BI
#define ARRAYSTRINGWRITER_BI

#include "ITextWriter.bi"

Type ArrayStringWriter
	Dim pVirtualTable As ITextWriterVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	Dim Buffer As WString Ptr
	Dim BufferLength As Integer
	Dim MaxBufferLength As Integer
	Dim CodePage As Integer
End Type

Declare Sub InitializeArrayStringWriter( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal pVirtualTable As ITextWriterVirtualTable Ptr, _
	ByVal Buffer As WString Ptr, _
	ByVal MaxBufferLength As Integer _
)

#endif
