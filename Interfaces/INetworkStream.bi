#ifndef INETWORKSTREAM_BI
#define INETWORKSTREAM_BI

#include "IBaseStream.bi"
#include "win\winsock2.bi"

' {A4C7EAED-5EC0-4B7C-81D2-05BE69E63A1F}
Dim Shared IID_INETWORKSTREAM As IID = Type(&ha4c7eaed, &h5ec0, &h4b7c, _
	{&h81, &hd2, &h5, &hbe, &h69, &he6, &h3a, &h1f})

Type LPINETWORKSTREAM As INetworkStream Ptr

Type INetworkStream As INetworkStream_

Type INetworkStreamVirtualTable
	Dim InheritedTable As IBaseStreamVirtualTable
	
	Dim GetSocket As Function( _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pResult As SOCKET Ptr _
	)As HRESULT
	
	Dim SetSocket As Function( _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal sock As SOCKET _
	)As HRESULT
	
End Type

Type INetworkStream_
	Dim pVirtualTable As INetworkStreamVirtualTable Ptr
End Type

#define INetworkStream_QueryInterface(pINetworkStream, riid, ppv) (pINetworkStream)->pVirtualTable->InheritedTable.InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pINetworkStream), riid, ppv)
#define INetworkStream_AddRef(pINetworkStream) (pINetworkStream)->pVirtualTable->InheritedTable.InheritedTable.AddRef(CPtr(IUnknown Ptr, pINetworkStream))
#define INetworkStream_Release(pINetworkStream) (pINetworkStream)->pVirtualTable->InheritedTable.InheritedTable.Release(CPtr(IUnknown Ptr, pINetworkStream))
#define INetworkStream_CanRead(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->InheritedTable.CanRead(CPtr(IBaseStream Ptr, pINetworkStream), pResult)
#define INetworkStream_CanSeek(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->InheritedTable.CanSeek(CPtr(IBaseStream Ptr, pINetworkStream), pResult)
#define INetworkStream_CanWrite(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->InheritedTable.CanWrite(CPtr(IBaseStream Ptr, pINetworkStream), pResult)
#define INetworkStream_CloseStream(pINetworkStream) (pINetworkStream)->pVirtualTable->InheritedTable.CloseStream(CPtr(IBaseStream Ptr, pINetworkStream))
#define INetworkStream_Flush(pINetworkStream) (pINetworkStream)->pVirtualTable->InheritedTable.Flush(CPtr(IBaseStream Ptr, pINetworkStream))
#define INetworkStream_GetLength(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->InheritedTable.GetLength(CPtr(IBaseStream Ptr, pINetworkStream), pResult)
#define INetworkStream_OpenStream(pINetworkStream) (pINetworkStream)->pVirtualTable->InheritedTable.OpenStream(CPtr(IBaseStream Ptr, pINetworkStream))
#define INetworkStream_Position(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->InheritedTable.Position(CPtr(IBaseStream Ptr, pINetworkStream), pResult)
#define INetworkStream_Read(pINetworkStream, Buffer, Offset, Count, pReadedBytes) (pINetworkStream)->pVirtualTable->InheritedTable.Read(CPtr(IBaseStream Ptr, pINetworkStream), Buffer, Offset, Count, pReadedBytes)
#define INetworkStream_Seek(pINetworkStream, Offset, Origin) (pINetworkStream)->pVirtualTable->InheritedTable.Seek(CPtr(IBaseStream Ptr, pINetworkStream), Offset, Origin)
#define INetworkStream_SetLength(pINetworkStream, Length) (pINetworkStream)->pVirtualTable->InheritedTable.SetLength(CPtr(IBaseStream Ptr, pINetworkStream), Length)
#define INetworkStream_Write(pINetworkStream, Buffer, Offset, Count, pWritedBytes) (pINetworkStream)->pVirtualTable->InheritedTable.Write(CPtr(IBaseStream Ptr, pINetworkStream), Buffer, Offset, Count, pWritedBytes)
#define INetworkStream_GetSocket(pINetworkStream, pResult) (pINetworkStream)->pVirtualTable->GetSocket(pINetworkStream, pResult)
#define INetworkStream_SetSocket(pINetworkStream, sock) (pINetworkStream)->pVirtualTable->SetSocket(pINetworkStream, sock)

#endif
