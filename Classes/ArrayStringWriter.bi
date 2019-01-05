#ifndef ARRAYSTRINGWRITER_BI
#define ARRAYSTRINGWRITER_BI

#include "ITextWriter.bi"
#include "IStringable.bi"

Type ArrayStringWriter
	
	Const MaxBufferLength As Integer = 32 * 1024 - 1
	
	Dim pTextWriterVirtualTable As ITextWriterVirtualTable Ptr
	Dim pStringableVirtualTable As IStringableVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	
	Dim CodePage As Integer
	Dim BufferLength As Integer
	Dim Buffer As WString * (ArrayStringWriter.MaxBufferLength + 1)
	
	Declare Constructor()
	
End Type

Declare Function ArrayStringWriterTextWriterQueryInterface( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ArrayStringWriterTextWriterAddRef( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As ULONG

Declare Function ArrayStringWriterTextWriterRelease( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As ULONG

Declare Function ArrayStringWriterWriteLengthString( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal w As WString Ptr, _
	ByVal Length As Integer _
)As HRESULT

Declare Function ArrayStringWriterWriteNewLine( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As HRESULT

Declare Function ArrayStringWriterWriteString( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal w As WString Ptr _
)As HRESULT

Declare Function ArrayStringWriterWriteLengthStringLine( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal w As WString Ptr, _
	ByVal Length As Integer _
)As HRESULT

Declare Function ArrayStringWriterWriteStringLine( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal w As WString Ptr _
)As HRESULT

Declare Function ArrayStringWriterWriteChar( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal wc As Integer _
)As HRESULT

Declare Function ArrayStringWriterWriteInt32( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal Value As Long _
)As HRESULT

Declare Function ArrayStringWriterWriteInt64( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal Value As LongInt _
)As HRESULT

Declare Function ArrayStringWriterWriteUInt64( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal Value As ULongInt _
)As HRESULT

Declare Function ArrayStringWriterGetCodePage( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal CodePage As Integer Ptr _
)As HRESULT

Declare Function ArrayStringWriterSetCodePage( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal CodePage As Integer _
)As HRESULT

Declare Function ArrayStringWriterCloseTextWriter( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As HRESULT

Declare Function ArrayStringWriterStringableQueryInterface( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ArrayStringWriterStringableAddRef( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As ULONG

Declare Function ArrayStringWriterStringableRelease( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr _
)As ULONG

Declare Function ArrayStringWriterStringableToString( _
	ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
	ByVal pResult As WString Ptr Ptr _
)As HRESULT

#endif
