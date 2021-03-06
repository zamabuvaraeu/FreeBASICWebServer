#ifndef IBASESTREAM_BI
#define IBASESTREAM_BI

#include once "IAsyncResult.bi"

Const BASESTREAM_S_IO_PENDING As HRESULT = MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_ITF, &h0201)

Enum SeekOrigin
	SeekBegin
	SeekCurrent
	SeekEnd
End Enum

' IBaseStream.Read:
' S_OK, S_FALSE, E_FAIL

' IBaseStream.BeginRead:
' S_OK, BASESTREAM_S_IO_PENDING, E_FAIL

' IBaseStream.EndRead:
' S_OK, S_FALSE, BASESTREAM_S_IO_PENDING, E_FAIL


Type IBaseStream As IBaseStream_

Type LPIBASESTREAM As IBaseStream Ptr

Extern IID_IBaseStream Alias "IID_IBaseStream" As Const IID

Type IBaseStreamVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As IBaseStream Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As IBaseStream Ptr _
	)As ULONG
	
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
		ByVal Count As Integer, _
		ByVal pWritedBytes As Integer Ptr _
	)As HRESULT
	
	Dim BeginRead As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal StateObject As IUnknown Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim BeginWrite As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal StateObject As IUnknown Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim EndRead As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr, _
		ByVal pReadedBytes As Integer Ptr _
	)As HRESULT
	
	Dim EndWrite As Function( _
		ByVal this As IBaseStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr, _
		ByVal pWritedBytes As Integer Ptr _
	)As HRESULT
	
End Type

Type IBaseStream_
	Dim lpVtbl As IBaseStreamVirtualTable Ptr
End Type

#define IBaseStream_QueryInterface(this, riid, ppv) (this)->lpVtbl->QueryInterface(this, riid, ppv)
#define IBaseStream_AddRef(this) (this)->lpVtbl->AddRef(this)
#define IBaseStream_Release(this) (this)->lpVtbl->Release(this)
#define IBaseStream_CanRead(this, pResult) (this)->lpVtbl->CanRead(this, pResult)
#define IBaseStream_CanSeek(this, pResult) (this)->lpVtbl->CanSeek(this, pResult)
#define IBaseStream_CanWrite(this, pResult) (this)->lpVtbl->CanWrite(this, pResult)
#define IBaseStream_CloseStream(this) (this)->lpVtbl->CloseStream(this)
#define IBaseStream_Flush(this) (this)->lpVtbl->Flush(this)
#define IBaseStream_GetLength(this, pResult) (this)->lpVtbl->GetLength(this, pResult)
#define IBaseStream_Position(this, pResult) (this)->lpVtbl->Position(this, pResult)
#define IBaseStream_Read(this, Buffer, Count, pReadedBytes) (this)->lpVtbl->Read(this, Buffer, Count, pReadedBytes)
#define IBaseStream_Seek(this, Offset, Origin) (this)->lpVtbl->Seek(this, Offset, Origin)
#define IBaseStream_SetLength(this, Length) (this)->lpVtbl->SetLength(this, Length)
#define IBaseStream_Write(this, Buffer, Count, pWritedBytes) (this)->lpVtbl->Write(this, Buffer, Count, pWritedBytes)
#define IBaseStream_BeginRead(this, Buffer, Count, callback, StateObject, ppIAsyncResult) (this)->lpVtbl->BeginRead(this, Buffer, Count, callback, StateObject, ppIAsyncResult)
#define IBaseStream_BeginWrite(this, Buffer, Count, callback, StateObject, ppIAsyncResult) (this)->lpVtbl->BeginWrite(this, Buffer, Count, callback, StateObject, ppIAsyncResult)
#define IBaseStream_EndRead(this, pIAsyncResult, pReadedBytes) (this)->lpVtbl->EndRead(this, pIAsyncResult, pReadedBytes)
#define IBaseStream_EndWrite(this, pIAsyncResult, pWritedBytes) (this)->lpVtbl->EndWrite(this, pIAsyncResult, pWritedBytes)

#endif
