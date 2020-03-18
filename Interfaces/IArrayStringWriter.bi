#ifndef IARRAYATRINGWRITER_BI
#define IARRAYATRINGWRITER_BI

#include "ITextWriter.bi"

Type IArrayStringWriter As IArrayStringWriter_

Type LPIARRAYSTRINGWRITER As IArrayStringWriter Ptr

Extern IID_IArrayStringWriter Alias "IID_IArrayStringWriter" As Const IID

Type IArrayStringWriterVirtualTable
	Dim InheritedTable As ITextWriterVirtualTable
	
	Dim SetBuffer As Function( _
		ByVal this As IArrayStringWriter Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal MaxBufferLength As Integer _
	)As HRESULT
	
End Type

Type IArrayStringWriter_
	Dim pVirtualTable As IArrayStringWriterVirtualTable Ptr
End Type

#define IArrayStringWriter_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IArrayStringWriter_AddRef(this) (this)->pVirtualTable->InheritedTable.InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IArrayStringWriter_Release(this) (this)->pVirtualTable->InheritedTable.InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define IArrayStringWriter_CloseTextWriter(this) (this)->pVirtualTable->InheritedTable.CloseTextWriter(CPtr(ITextWriter Ptr, this))
#define IArrayStringWriter_OpenTextWriter(this) (this)->pVirtualTable->InheritedTable.OpenTextWriter(CPtr(ITextWriter Ptr, this))
#define IArrayStringWriter_Flush(this) (this)->pVirtualTable->InheritedTable.Flush(CPtr(ITextWriter Ptr, this))
#define IArrayStringWriter_GetCodePage(this, pCodePage) (this)->pVirtualTable->InheritedTable.GetCodePage(CPtr(ITextWriter Ptr, this), pCodePage)
#define IArrayStringWriter_SetCodePage(this, CodePage) (this)->pVirtualTable->InheritedTable.GetCodePage(CPtr(ITextWriter Ptr, this), CodePage)
#define IArrayStringWriter_WriteNewLine(this) (this)->pVirtualTable->InheritedTable.WriteNewLine(CPtr(ITextWriter Ptr, this))
#define IArrayStringWriter_WriteStringLine(this, w) (this)->pVirtualTable->InheritedTable.WriteStringLine(CPtr(ITextWriter Ptr, this), w)
#define IArrayStringWriter_WriteLengthStringLine(this, w, Length) (this)->pVirtualTable->InheritedTable.WriteLengthStringLine(CPtr(ITextWriter Ptr, this), w, Length)
#define IArrayStringWriter_WriteString(this, w) (this)->pVirtualTable->InheritedTable.WriteString(CPtr(ITextWriter Ptr, this), w)
#define IArrayStringWriter_WriteLengthString(this, w, Length) (this)->pVirtualTable->InheritedTable.WriteLengthString(CPtr(ITextWriter Ptr, this), w, Length)
#define IArrayStringWriter_WriteChar(this, wc) (this)->pVirtualTable->InheritedTable.WriteChar(CPtr(ITextWriter Ptr, this), wc)
#define IArrayStringWriter_WriteInt32(this, Value) (this)->pVirtualTable->InheritedTable.WriteInt32(CPtr(ITextWriter Ptr, this), Value)
#define IArrayStringWriter_WriteInt64(this, Value) (this)->pVirtualTable->InheritedTable.WriteInt64(CPtr(ITextWriter Ptr, this), Value)
#define IArrayStringWriter_WriteUInt64(this, Value) (this)->pVirtualTable->InheritedTable.WriteUInt64(CPtr(ITextWriter Ptr, this), Value)
#define IArrayStringWriter_SetBuffer(this, Buffer, MaxBufferLength) (this)->pVirtualTable->SetBuffer(this, Buffer, MaxBufferLength)

#endif
