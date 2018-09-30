#ifndef NETWORKSTREAM_BI
#define NETWORKSTREAM_BI

#include "INetworkStream.bi"

Type NetworkStream
	Dim pVirtualTable As INetworkStreamVirtualTable Ptr
	Dim ReferenceCounter As DWORD
	
	Dim m_Socket As SOCKET
End Type

Declare Function NetworkStreamCanRead( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCanSeek As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCanWrite As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As Boolean Ptr _
)As HRESULT

Declare Function NetworkStreamCloseStream As Function( _
	ByVal this As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamFlush As Function( _
	ByVal this As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamGetLength As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamOpenStream As Function( _
	ByVal this As NetworkStream Ptr _
)As HRESULT

Declare Function NetworkStreamPosition As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamRead As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal buffer As UByte Ptr, _
	ByVal offset As Integer, _
	ByVal Count As Integer, _
	ByVal pReadedBytes As LongInt Ptr _
)As HRESULT

Declare Function NetworkStreamSeek As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal offset As LongInt, _
	ByVal origin As SeekOrigin _
)As HRESULT

Declare Function NetworkStreamSetLength As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal length As LongInt _
)As HRESULT

Declare Function NetworkStreamWrite As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal buffer As UByte Ptr, _
	ByVal offset As Integer, _
	ByVal Count As Integer _
)As HRESULT

Declare Function NetworkStreamGetSocket( _
	ByVal this As NetworkStream Ptr, _
	ByVal pResult As SOCKET Ptr _
)As HRESULT

Declare Function NetworkStreamSetSocket( _
	ByVal this As NetworkStream Ptr, _
	ByVal sock As SOCKET _
)As HRESULT

#endif
