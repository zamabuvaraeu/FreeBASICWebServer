#ifndef INETWORKSTREAM_BI
#define INETWORKSTREAM_BI

#include once "IBaseStream.bi"
#include once "win\winsock2.bi"

Type INetworkStream As INetworkStream_

Type LPINETWORKSTREAM As INetworkStream Ptr

Extern IID_INetworkStream Alias "IID_INetworkStream" As Const IID

Type INetworkStreamVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As INetworkStream Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As INetworkStream Ptr _
	)As ULONG
	
	Dim CanRead As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim CanSeek As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim CanWrite As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	Dim Flush As Function( _
		ByVal this As INetworkStream Ptr _
	)As HRESULT
	
	Dim GetLength As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	Dim Position As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	Dim Read As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal pReadedBytes As Integer Ptr _
	)As HRESULT
	
	Dim Seek As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Offset As LongInt, _
		ByVal Origin As SeekOrigin _
	)As HRESULT
	
	Dim SetLength As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Length As LongInt _
	)As HRESULT
	
	Dim Write As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal pWritedBytes As Integer Ptr _
	)As HRESULT
	
	Dim BeginRead As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal StateObject As IUnknown Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim BeginWrite As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal Buffer As UByte Ptr, _
		ByVal Count As Integer, _
		ByVal callback As AsyncCallback, _
		ByVal StateObject As IUnknown Ptr, _
		ByVal ppIAsyncResult As IAsyncResult Ptr Ptr _
	)As HRESULT
	
	Dim EndRead As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr, _
		ByVal pReadedBytes As Integer Ptr _
	)As HRESULT
	
	Dim EndWrite As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pIAsyncResult As IAsyncResult Ptr, _
		ByVal pWritedBytes As Integer Ptr _
	)As HRESULT
	
	Dim GetSocket As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As SOCKET Ptr _
	)As HRESULT
	
	Dim SetSocket As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal sock As SOCKET _
	)As HRESULT
	
	Dim Close As Function( _
		ByVal this As INetworkStream Ptr _
	)As HRESULT
	
End Type

Type INetworkStream_
	Dim lpVtbl As INetworkStreamVirtualTable Ptr
End Type

#define INetworkStream_QueryInterface(this, riid, ppv) (this)->lpVtbl->QueryInterface(this, riid, ppv)
#define INetworkStream_AddRef(this) (this)->lpVtbl->AddRef(this)
#define INetworkStream_Release(this) (this)->lpVtbl->Release(this)
#define INetworkStream_CanRead(this, pResult) (this)->lpVtbl->CanRead(this, pResult)
#define INetworkStream_CanSeek(this, pResult) (this)->lpVtbl->CanSeek(this, pResult)
#define INetworkStream_CanWrite(this, pResult) (this)->lpVtbl->CanWrite(this, pResult)
#define INetworkStream_Flush(this) (this)->lpVtbl->Flush(this)
#define INetworkStream_GetLength(this, pResult) (this)->lpVtbl->GetLength(this, pResult)
#define INetworkStream_Position(this, pResult) (this)->lpVtbl->Position(this, pResult)
#define INetworkStream_Read(this, Buffer, Count, pReadedBytes) (this)->lpVtbl->Read(this, Buffer, Count, pReadedBytes)
#define INetworkStream_Seek(this, Offset, Origin) (this)->lpVtbl->Seek(this, Offset, Origin)
#define INetworkStream_SetLength(this, Length) (this)->lpVtbl->SetLength(this, Length)
#define INetworkStream_Write(this, Buffer, Count, pWritedBytes) (this)->lpVtbl->Write(this, Buffer, Count, pWritedBytes)
#define INetworkStream_BeginRead(this, Buffer, Count, callback, StateObject, ppIAsyncResult) (this)->lpVtbl->BeginRead(this, Buffer, Count, callback, StateObject, ppIAsyncResult)
#define INetworkStream_BeginWrite(this, Buffer, Count, callback, StateObject, ppIAsyncResult) (this)->lpVtbl->BeginWrite(this, Buffer, Count, callback, StateObject, ppIAsyncResult)
#define INetworkStream_EndRead(this, pIAsyncResult, pReadedBytes) (this)->lpVtbl->EndRead(this, pIAsyncResult, pReadedBytes)
#define INetworkStream_EndWrite(this, pIAsyncResult, pWritedBytes) (this)->lpVtbl->EndWrite(this, pIAsyncResult, pWritedBytes)
#define INetworkStream_GetSocket(this, pResult) (this)->lpVtbl->GetSocket(this, pResult)
#define INetworkStream_SetSocket(this, sock) (this)->lpVtbl->SetSocket(this, sock)
#define INetworkStream_Close(this) (this)->lpVtbl->Close(this)

#endif
