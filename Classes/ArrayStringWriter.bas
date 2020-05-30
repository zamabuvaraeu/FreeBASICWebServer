#include "ArrayStringWriter.bi"
#include "ContainerOf.bi"
#include "IntegerToWString.bi"
#include "StringConstants.bi"

Extern GlobalArrayStringWriterVirtualTable As Const IArrayStringWriterVirtualTable

Type _ArrayStringWriter
	
	Dim lpVtbl As Const IArrayStringWriterVirtualTable Ptr
	Dim ReferenceCounter As Integer
	Dim hHeap As HANDLE
	
	Dim CodePage As Integer
	Dim MaxBufferLength As Integer
	Dim BufferLength As Integer
	Dim Buffer As WString Ptr
	
End Type

Sub InitializeArrayStringWriter( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal hHeap As HANDLE _
	)
	
	this->lpVtbl = @GlobalArrayStringWriterVirtualTable
	this->ReferenceCounter = 0
	this->hHeap = hHeap
	this->CodePage = 1200
	this->MaxBufferLength = 0
	this->BufferLength = 0
	this->Buffer = NULL
	
End Sub

Sub UnInitializeArrayStringWriter( _
		ByVal this As ArrayStringWriter Ptr _
	)
	
End Sub

Function CreateArrayStringWriter( _
		ByVal hHeap As HANDLE _
	)As ArrayStringWriter Ptr
	
	Dim pWriter As ArrayStringWriter Ptr = HeapAlloc( _
		hHeap, _
		0, _ /' HEAP_NO_SERIALIZE '/
		SizeOf(ArrayStringWriter) _
	)
	
	If pWriter = NULL Then
		Return NULL
	End If
	
	InitializeArrayStringWriter(pWriter, hHeap)
	
	Return pWriter
	
End Function

Sub DestroyArrayStringWriter( _
		ByVal this As ArrayStringWriter Ptr _
	)
	
	UnInitializeArrayStringWriter(this)
	
	' HeapFree(this->hHeap, HEAP_NO_SERIALIZE, this)
	HeapFree(this->hHeap, 0, this)
	
End Sub

Function ArrayStringWriterQueryInterface( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_IArrayStringWriter, riid) Then
		*ppv = @this->lpVtbl
	Else
		If IsEqualIID(@IID_ITextWriter, riid) Then
			*ppv = @this->lpVtbl
		Else
			If IsEqualIID(@IID_IUnknown, riid) Then
				*ppv = @this->lpVtbl
			Else
				*ppv = NULL
				Return E_NOINTERFACE
			End If
		End If
	End If
	
	ArrayStringWriterAddRef(this)
	
	Return S_OK
	
End Function

Function ArrayStringWriterAddRef( _
		ByVal this As ArrayStringWriter Ptr _
	)As ULONG
	
	this->ReferenceCounter += 1
	
	Return 1
	
End Function

Function ArrayStringWriterRelease( _
		ByVal this As ArrayStringWriter Ptr _
	)As ULONG
	
	this->ReferenceCounter -= 1
	
	If this->ReferenceCounter = 0 Then
		
		DestroyArrayStringWriter(this)
		
		Return 0
	End If
	
	Return 1
	
End Function

Function ArrayStringWriterWriteLengthString( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	If this->BufferLength + Length > this->MaxBufferLength Then
		Return E_OUTOFMEMORY
	End If
	
	lstrcpyn(@this->Buffer[this->BufferLength], w, Length + 1)
	this->BufferLength += Length
	
	Return S_OK
	
End Function

Function ArrayStringWriterWriteNewLine( _
		ByVal this As ArrayStringWriter Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthString(this, @NewLineString, 2)
	
End Function

Function ArrayStringWriterWriteString( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthString(this, w, lstrlen(w))
	
End Function

Function ArrayStringWriterWriteLengthStringLine( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	If FAILED(ArrayStringWriterWriteLengthString(this, w, Length)) Then
		Return E_OUTOFMEMORY
	End If
	
	If FAILED(ArrayStringWriterWriteNewLine(this)) Then
		Return E_OUTOFMEMORY
	End If
	
	Return S_OK
	
End Function

Function ArrayStringWriterWriteStringLine( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	
	Return ArrayStringWriterWriteLengthStringLine(this, w, lstrlen(w))
	
End Function

Function ArrayStringWriterWriteChar( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal wc As wchar_t _
	)As HRESULT
	
	If this->BufferLength + 1 > this->MaxBufferLength Then
		Return E_OUTOFMEMORY
	End If
	
	this->Buffer[this->BufferLength] = wc
	this->Buffer[this->BufferLength + 1] = 0
	this->BufferLength += 1
	
	Return S_OK
	
End Function

Function ArrayStringWriterWriteInt32( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal Value As Long _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	itow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(this, @strValue)
	
End Function

Function ArrayStringWriterWriteInt64( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal Value As LongInt _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	i64tow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(this, @strValue)
	
End Function

Function ArrayStringWriterWriteUInt64( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal Value As ULongInt _
	)As HRESULT

	Dim strValue As WString * (64) = Any
	ui64tow(Value, @strValue, 10)
	
	Return ArrayStringWriterWriteString(this, @strValue)
	
End Function

Function ArrayStringWriterGetCodePage( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal CodePage As Integer Ptr _
	)As HRESULT
	
	*CodePage = this->CodePage
	
	Return S_OK
	
End Function

Function ArrayStringWriterSetCodePage( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	
	this->CodePage = CodePage
	
	Return S_OK
	
End Function

Function ArrayStringWriterCloseTextWriter( _
		ByVal this As ArrayStringWriter Ptr _
	)As HRESULT
	
	Return S_OK
	
End Function

Function ArrayStringWriterSetBuffer( _
		ByVal this As ArrayStringWriter Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal MaxBufferLength As Integer _
	)As HRESULT
	
	this->MaxBufferLength = MaxBufferLength
	this->Buffer = Buffer
	this->BufferLength = 0
	this->Buffer[0] = 0
	
	Return S_OK
	
End Function

Function IArrayStringWriterQueryInterface( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	Return ArrayStringWriterQueryInterface(ContainerOf(this, ArrayStringWriter, lpVtbl), riid, ppvObject)
End Function

Function IArrayStringWriterAddRef( _
		ByVal this As IArrayStringWriter Ptr _
	)As ULONG
	Return ArrayStringWriterAddRef(ContainerOf(this, ArrayStringWriter, lpVtbl))
End Function

Function IArrayStringWriterRelease( _
		ByVal this As IArrayStringWriter Ptr _
	)As ULONG
	Return ArrayStringWriterRelease(ContainerOf(this, ArrayStringWriter, lpVtbl))
End Function

' Function IArrayStringWriterCloseTextWriter( _
		' ByVal this As IArrayStringWriter Ptr _
	' )As HRESULT
' End Function

' Function IArrayStringWriterOpenTextWriter( _
		' ByVal this As IArrayStringWriter Ptr _
	' )As HRESULT
' End Function

' Function IArrayStringWriterFlush( _
		' ByVal this As IArrayStringWriter Ptr _
	' )As HRESULT
' End Function

Function IArrayStringWriterGetCodePage( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal pCodePage As Integer Ptr _
	)As HRESULT
	Return ArrayStringWriterGetCodePage(ContainerOf(this, ArrayStringWriter, lpVtbl), pCodePage)
End Function

Function IArrayStringWriterSetCodePage( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	Return ArrayStringWriterSetCodePage(ContainerOf(this, ArrayStringWriter, lpVtbl), CodePage)
End Function

Function IArrayStringWriterWriteNewLine( _
		ByVal this As IArrayStringWriter Ptr _
	)As HRESULT
	Return ArrayStringWriterWriteNewLine(ContainerOf(this, ArrayStringWriter, lpVtbl))
End Function

Function IArrayStringWriterWriteStringLine( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	Return ArrayStringWriterWriteStringLine(ContainerOf(this, ArrayStringWriter, lpVtbl), w)
End Function

Function IArrayStringWriterWriteLengthStringLine( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	Return ArrayStringWriterWriteLengthStringLine(ContainerOf(this, ArrayStringWriter, lpVtbl), w, Length)
End Function

Function IArrayStringWriterWriteString( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal w As WString Ptr _
	)As HRESULT
	Return ArrayStringWriterWriteString(ContainerOf(this, ArrayStringWriter, lpVtbl), w)
End Function

Function IArrayStringWriterWriteLengthString( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	Return ArrayStringWriterWriteLengthString(ContainerOf(this, ArrayStringWriter, lpVtbl), w, Length)
End Function

Function IArrayStringWriterWriteChar( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal wc As wchar_t _
	)As HRESULT
	Return ArrayStringWriterWriteChar(ContainerOf(this, ArrayStringWriter, lpVtbl), wc)
End Function

Function IArrayStringWriterWriteInt32( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal Value As Long _
	)As HRESULT
	Return ArrayStringWriterWriteInt32(ContainerOf(this, ArrayStringWriter, lpVtbl), Value)
End Function

Function IArrayStringWriterWriteInt64( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal Value As LongInt _
	)As HRESULT
	Return ArrayStringWriterWriteInt64(ContainerOf(this, ArrayStringWriter, lpVtbl), Value)
End Function

Function IArrayStringWriterWriteUInt64( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal Value As ULongInt _
	)As HRESULT
	Return ArrayStringWriterWriteUInt64(ContainerOf(this, ArrayStringWriter, lpVtbl), Value)
End Function

Function IArrayStringWriterSetBuffer( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal MaxBufferLength As Integer _
	)As HRESULT
	Return ArrayStringWriterSetBuffer(ContainerOf(this, ArrayStringWriter, lpVtbl), Buffer, MaxBufferLength)
End Function

Dim GlobalArrayStringWriterVirtualTable As Const IArrayStringWriterVirtualTable = Type( _
	@IArrayStringWriterQueryInterface, _
	@IArrayStringWriterAddRef, _
	@IArrayStringWriterRelease, _
	NULL, _ /' CloseTextWriter '/
	NULL, _ /' OpenTextWriter'/
	NULL , _ /' Flush '/
	@IArrayStringWriterGetCodePage, _
	@IArrayStringWriterSetCodePage, _
	@IArrayStringWriterWriteNewLine, _
	@IArrayStringWriterWriteStringLine, _
	@IArrayStringWriterWriteLengthStringLine, _
	@IArrayStringWriterWriteString, _
	@IArrayStringWriterWriteLengthString, _
	@IArrayStringWriterWriteChar, _
	@IArrayStringWriterWriteInt32, _
	@IArrayStringWriterWriteInt64, _
	@IArrayStringWriterWriteUInt64, _
	@IArrayStringWriterSetBuffer _
)
