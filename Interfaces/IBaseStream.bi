﻿#ifndef IBASESTREAM_BI
#define IBASESTREAM_BI

#include "IAsyncResult.bi"

Enum SeekOrigin
	SeekBegin
	SeekCurrent
	SeekEnd
End Enum

' S_OK, S_FALSE, E_FAIL

Type IBaseStream As IBaseStream_

Type LPIBASESTREAM As IBaseStream Ptr

Extern IID_IBaseStream Alias "IID_IBaseStream" As Const IID

Type IBaseStreamVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim CanRead As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim CanSeek As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim CanWrite As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim Flush As Function( _
		ByVal this As IBaseStream Ptr _
	)As HRESULT
	
	Dim GetLength As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	Dim Position As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	Dim Read As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Offset As Integer, _
		ByVal Count As Integer, _
		ByVal pReadedBytes As Integer Ptr _
	)As HRESULT
	
	Dim Seek As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Offset As LongInt, _
		ByVal Origin As SeekOrigin _
	)As HRESULT
	
	Dim SetLength As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Length As LongInt _
	)As HRESULT
	
	Dim Write As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Offset As Integer, _
		ByVal Count As Integer, _
		ByVal pWritedBytes As Integer Ptr _
	)As HRESULT
	
	Dim BeginRead As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Offset As Integer, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal pState As Any Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim BeginWrite As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Offset As Integer, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal pState As Any Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim EndRead As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr _
	)As HRESULT
	
	Dim EndWrite As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr _
	)As HRESULT
	
End Type

Type IBaseStream_
	Dim pVirtualTable As IBaseStreamVirtualTable Ptr
End Type

#define IBaseStream_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IBaseStream_AddRef(this) (this)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IBaseStream_Release(this) (this)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define IBaseStream_CanRead(this, pResult) (this)->pVirtualTable->CanRead(this, pResult)
#define IBaseStream_CanSeek(this, pResult) (this)->pVirtualTable->CanSeek(this, pResult)
#define IBaseStream_CanWrite(this, pResult) (this)->pVirtualTable->CanWrite(this, pResult)
#define IBaseStream_CloseStream(this) (this)->pVirtualTable->CloseStream(this)
#define IBaseStream_Flush(this) (this)->pVirtualTable->Flush(this)
#define IBaseStream_GetLength(this, pResult) (this)->pVirtualTable->GetLength(this, pResult)
#define IBaseStream_Position(this, pResult) (this)->pVirtualTable->Position(this, pResult)
#define IBaseStream_Read(this, Buffer, Offset, Count, pReadedBytes) (this)->pVirtualTable->Read(this, Buffer, Offset, Count, pReadedBytes)
#define IBaseStream_Seek(this, Offset, Origin) (this)->pVirtualTable->Seek(this, Offset, Origin)
#define IBaseStream_SetLength(this, Length) (this)->pVirtualTable->SetLength(this, Length)
#define IBaseStream_Write(this, Buffer, Offset, Count, pWritedBytes) (this)->pVirtualTable->Write(this, Buffer, Offset, Count, pWritedBytes)

#endif
