#ifndef NETWORKSTREAM_BI
#define NETWORKSTREAM_BI

#include "INetworkStream.bi"

Type NetworkStream
	Dim pVirtualTable As INetworkStreamVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	
	Dim m_Socket As SOCKET
	
	Declare Constructor()
End Type

Declare Function NetworkStreamQueryInterface( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function NetworkStreamAddRef( _
	ByVal pNetworkStream As NetworkStream Ptr _
)As ULONG

Declare Function NetworkStreamRelease( _
	ByVal pNetworkStream As NetworkStream Ptr _
)As ULONG

Declare Function NetworkStreamCanRead( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCanSeek( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCanWrite( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCloseStream( _
	ByVal pNetworkStream As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamFlush( _
	ByVal pNetworkStream As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamGetLength( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamOpenStream( _
	ByVal pNetworkStream As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamPosition( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamRead( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal buffer As UByte Ptr, _
	ByVal offset As Integer, _
	ByVal Count As Integer, _
	ByVal pReadedBytes As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamSeek( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal offset As LongInt, _
	ByVal origin As SeekOrigin _
)As HRESULT

Declare Function NetworkStreamSetLength( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal length As LongInt _
)As HRESULT

Declare Function NetworkStreamWrite( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal buffer As UByte Ptr, _
	ByVal offset As Integer, _
	ByVal Count As Integer, _
	ByVal pWritedBytes As Integer Ptr _
)As HRESULT

Declare Function NetworkStreamGetSocket( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal pResult As SOCKET Ptr _
)As HRESULT
	
Declare Function NetworkStreamSetSocket( _
	ByVal pNetworkStream As NetworkStream Ptr, _
	ByVal sock As SOCKET _
)As HRESULT

#endif
