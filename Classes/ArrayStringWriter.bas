#include "ArrayStringWriter.bi"

Common Shared GlobalArrayStringWriterTextWriterVirtualTable As ITextWriterVirtualTable
Common Shared GlobalArrayStringWriterStringableVirtualTable As IStringableVirtualTable

Declare Function itow cdecl Alias "_itow"( _
	ByVal Value As Long, _
	ByVal src As WString Ptr, _
	ByVal radix As Integer _
)As WString Ptr

Declare Function i64tow cdecl Alias "_i64tow"( _
	ByVal Value As LongInt, _
	ByVal src As WString Ptr, _
	ByVal radix As Integer _
)As WString Ptr

Declare Function ui64tow cdecl Alias "_ui64tow"( _
	ByVal Value As ULongInt, _
	ByVal src As WString Ptr, _
	ByVal radix As Integer _
)As WString Ptr

Const NewLineString = !"\r\n"

Constructor ArrayStringWriter()
	this.pTextWriterVirtualTable = @GlobalArrayStringWriterTextWriterVirtualTable
	this.pStringableVirtualTable = @GlobalArrayStringWriterStringableVirtualTable
	this.ReferenceCounter = 0
	this.CodePage = 1200
	this.BufferLength = 0
	this.Buffer[0] = 0
End Constructor

Function ArrayStringWriterTextWriterQueryInterface( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = 0
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pArrayStringWriter->pTextWriterVirtualTable)
	End If
	
	If IsEqualIID(@IID_ITEXTWRITER, riid) Then
		*ppv = CPtr(ITextWriter Ptr, @pArrayStringWriter->pTextWriterVirtualTable)
	End If
	
	If IsEqualIID(@IID_ISTRINGABLE, riid) Then
		*ppv = CPtr(IStringable Ptr, @pArrayStringWriter->pStringableVirtualTable)
	End If
	
	If *ppv = 0 Then
		Return E_NOINTERFACE
	End If
	
	ArrayStringWriterTextWriterAddRef(pArrayStringWriter)
	
	Return S_OK
End Function

Function ArrayStringWriterTextWriterAddRef( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@pArrayStringWriter->ReferenceCounter)
End Function

Function ArrayStringWriterTextWriterRelease( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr _
	)As ULONG
	
	InterlockedDecrement(@pArrayStringWriter->ReferenceCounter)
	
	If pArrayStringWriter->ReferenceCounter = 0 Then
		' DestructorIrcClient(This)
		' InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
	End If
	
	Return pArrayStringWriter->ReferenceCounter
End Function

Function ArrayStringWriterWriteLengthString( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	If pArrayStringWriter->BufferLength + Length > pArrayStringWriter->MaxBufferLength Then
		Return E_OUTOFMEMORY
	End If
	
	lstrcpyn(@pArrayStringWriter->Buffer[pArrayStringWriter->BufferLength], w, Length + 1)
	pArrayStringWriter->BufferLength += Length
	
	Return S_OK
End Function

Function ArrayStringWriterWriteNewLine( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthString(pArrayStringWriter, @NewLineString, 2)
	
End Function

Function ArrayStringWriterWriteString( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthString(pArrayStringWriter, w, lstrlen(w))
	
End Function

Function ArrayStringWriterWriteLengthStringLine( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	If FAILED(ArrayStringWriterWriteLengthString(pArrayStringWriter, w, Length)) Then
		Return E_OUTOFMEMORY
	End If
	
	If FAILED(ArrayStringWriterWriteNewLine(pArrayStringWriter)) Then
		Return E_OUTOFMEMORY
	End If
	
	Return S_OK
End Function

Function ArrayStringWriterWriteStringLine( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthStringLine(pArrayStringWriter, w, lstrlen(w))
	
End Function

Function ArrayStringWriterWriteChar( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal wc As Integer _
	)As HRESULT
	
	If pArrayStringWriter->BufferLength + 1 > pArrayStringWriter->MaxBufferLength Then
		Return E_OUTOFMEMORY
	End If
	
	pArrayStringWriter->Buffer[pArrayStringWriter->BufferLength] = wc
	pArrayStringWriter->Buffer[pArrayStringWriter->BufferLength + 1] = 0
	pArrayStringWriter->BufferLength += 1
	
	Return S_OK
End Function

Function ArrayStringWriterWriteInt32( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal Value As Long _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	itow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(pArrayStringWriter, @strValue)
	
End Function

Function ArrayStringWriterWriteInt64( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal Value As LongInt _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	i64tow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(pArrayStringWriter, @strValue)
	
End Function

Function ArrayStringWriterWriteUInt64( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal Value As ULongInt _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	ui64tow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(pArrayStringWriter, @strValue)
	
End Function

Function ArrayStringWriterGetCodePage( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal CodePage As Integer Ptr _
	)As HRESULT
	
	*CodePage = pArrayStringWriter->CodePage
	
	Return S_OK
End Function

Function ArrayStringWriterSetCodePage( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	
	pArrayStringWriter->CodePage = CodePage
	
	Return S_OK
End Function

Function ArrayStringWriterCloseTextWriter( _
		ByVal pArrayStringWriter As ArrayStringWriter Ptr _
	)As HRESULT
	
	Return S_OK
End Function

Function ArrayStringWriterStringableQueryInterface( _
		ByVal pFake As ArrayStringWriter Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = 0
	
	Dim pArrayStringWriter As ArrayStringWriter Ptr = CPtr(Any Ptr, pFake) - SizeOf(IStringableVirtualTable Ptr)
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pArrayStringWriter->pTextWriterVirtualTable)
	End If
	
	If IsEqualIID(@IID_ITEXTWRITER, riid) Then
		*ppv = CPtr(ITextWriter Ptr, @pArrayStringWriter->pTextWriterVirtualTable)
	End If
	
	If IsEqualIID(@IID_ISTRINGABLE, riid) Then
		*ppv = CPtr(IStringable Ptr, @pArrayStringWriter->pStringableVirtualTable)
	End If
	
	If *ppv = 0 Then
		Return E_NOINTERFACE
	End If
	
	ArrayStringWriterStringableAddRef(pFake)
	
	Return S_OK
End Function

Function ArrayStringWriterStringableAddRef( _
		ByVal pFake As ArrayStringWriter Ptr _
	)As ULONG
	
	Dim pArrayStringWriter As ArrayStringWriter Ptr = CPtr(Any Ptr, pFake) - SizeOf(IStringableVirtualTable Ptr)
	
	Return InterlockedIncrement(@pArrayStringWriter->ReferenceCounter)
End Function

Function ArrayStringWriterStringableRelease( _
		ByVal pFake As ArrayStringWriter Ptr _
	)As ULONG
	
	Dim pArrayStringWriter As ArrayStringWriter Ptr = CPtr(Any Ptr, pFake) - SizeOf(IStringableVirtualTable Ptr)
	
	InterlockedDecrement(@pArrayStringWriter->ReferenceCounter)
	
	If pArrayStringWriter->ReferenceCounter = 0 Then
		' DestructorIrcClient(This)
		' InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
	End If
	
	Return pArrayStringWriter->ReferenceCounter
End Function

Function ArrayStringWriterStringableToString( _
		ByVal pFake As ArrayStringWriter Ptr, _
		ByVal pResult As WString Ptr Ptr _
	)As HRESULT
	
	Dim pArrayStringWriter As ArrayStringWriter Ptr = CPtr(Any Ptr, pFake) - SizeOf(IStringableVirtualTable Ptr)
	
	*pResult = @pArrayStringWriter->Buffer
	
	Return S_OK
End Function
