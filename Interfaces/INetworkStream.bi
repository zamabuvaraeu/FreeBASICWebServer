#ifndef INETWORKSTREAM_BI
#define INETWORKSTREAM_BI

#include "IBaseStream.bi"
#include "win\winsock2.bi"

Type INetworkStream As INetworkStream_

Type LPINETWORKSTREAM As INetworkStream Ptr

Extern IID_INetworkStream Alias "IID_INetworkStream" As Const IID

Type INetworkStreamVirtualTable
	Dim InheritedTable As IBaseStreamVirtualTable
	
	Dim GetSocket As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As SOCKET Ptr _
	)As HRESULT
	
	Dim SetSocket As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal sock As SOCKET _
	)As HRESULT
	
End Type

Type INetworkStream_
	Dim pVirtualTable As INetworkStreamVirtualTable Ptr
End Type

#define INetworkStream_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define INetworkStream_AddRef(this) (this)->pVirtualTable->InheritedTable.InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define INetworkStream_Release(this) (this)->pVirtualTable->InheritedTable.InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define INetworkStream_CanRead(this, pResult) (this)->pVirtualTable->InheritedTable.CanRead(CPtr(IBaseStream Ptr, this), pResult)
#define INetworkStream_CanSeek(this, pResult) (this)->pVirtualTable->InheritedTable.CanSeek(CPtr(IBaseStream Ptr, this), pResult)
#define INetworkStream_CanWrite(this, pResult) (this)->pVirtualTable->InheritedTable.CanWrite(CPtr(IBaseStream Ptr, this), pResult)
#define INetworkStream_Flush(this) (this)->pVirtualTable->InheritedTable.Flush(CPtr(IBaseStream Ptr, this))
#define INetworkStream_GetLength(this, pResult) (this)->pVirtualTable->InheritedTable.GetLength(CPtr(IBaseStream Ptr, this), pResult)
#define INetworkStream_Position(this, pResult) (this)->pVirtualTable->InheritedTable.Position(CPtr(IBaseStream Ptr, this), pResult)
#define INetworkStream_Read(this, Buffer, Offset, Count, pReadedBytes) (this)->pVirtualTable->InheritedTable.Read(CPtr(IBaseStream Ptr, this), Buffer, Offset, Count, pReadedBytes)
#define INetworkStream_Seek(this, Offset, Origin) (this)->pVirtualTable->InheritedTable.Seek(CPtr(IBaseStream Ptr, this), Offset, Origin)
#define INetworkStream_SetLength(this, Length) (this)->pVirtualTable->InheritedTable.SetLength(CPtr(IBaseStream Ptr, this), Length)
#define INetworkStream_Write(this, Buffer, Offset, Count, pWritedBytes) (this)->pVirtualTable->InheritedTable.Write(CPtr(IBaseStream Ptr, this), Buffer, Offset, Count, pWritedBytes)
#define INetworkStream_GetSocket(this, pResult) (this)->pVirtualTable->GetSocket(this, pResult)
#define INetworkStream_SetSocket(this, sock) (this)->pVirtualTable->SetSocket(this, sock)

#endif
