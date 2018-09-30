#ifndef INETWORKSTREAM_BI
#define INETWORKSTREAM_BI

#include "IBaseStream.bi"
#include once "win\winsock2.bi"

Type INetworkStream As INetworkStream_

Type INetworkStreamVirtualTable
	Dim VirtualTable As IBaseStreamVirtualTable
	
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

#endif
