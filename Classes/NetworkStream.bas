#include "NetworkStream.bi"

Function NetworkStreamCanRead( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	*pResult = True
	Return S_OK
End If

Function NetworkStreamCanSeek As Function( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	*pResult = False
	Return S_OK
End If

Function NetworkStreamCanWrite As Function( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As Boolean Ptr _
	)As HRESULT
	
	*pResult = True
	Return S_OK
End If

Function NetworkStreamCloseStream( _
		ByVal this As NetworkStream Ptr _
	)As HRESULT
	
	Return S_OK
End If

Function NetworkStreamFlush( _
		ByVal this As NetworkStream Ptr _
	)As HRESULT
	
	Return S_OK
End If

Function NetworkStreamGetLength( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	*pResult = 0
	Return S_OK
End If

Function NetworkStreamOpenStream( _
		ByVal this As NetworkStream Ptr _
	)As HRESULT
	
	Return S_OK
End If

Function NetworkStreamPosition( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As LongInt Ptr _
	)As HRESULT
	
	*pResult = 0
	Return S_OK
End If

Function NetworkStreamRead( _
		ByVal this As NetworkStream Ptr, _
		ByVal buffer As UByte Ptr, _
		ByVal offset As Integer, _
		ByVal Count As Integer, _
		ByVal pReadedBytes As LongInt Ptr _
	)As HRESULT
	
	*pReadedBytes = recv(this->m_Socket, @buffer[offset], Count, 0)
	Return S_OK
End If

Function NetworkStreamSeek( _
		ByVal this As NetworkStream Ptr, _
		ByVal offset As LongInt, _
		ByVal origin As SeekOrigin _
	)As HRESULT
	
	Return S_OK
End If

Function NetworkStreamSetLength( _
		ByVal this As NetworkStream Ptr, _
		ByVal length As LongInt _
	)As HRESULT
	
	Return S_OK
End If

Declare Function NetworkStreamWrite As Function( _
	ByVal this As NetworkStream Ptr, _
	ByVal buffer As UByte Ptr, _
	ByVal offset As Integer, _
	ByVal Count As Integer _
)As HRESULT

Function NetworkStreamGetSocket( _
		ByVal this As NetworkStream Ptr, _
		ByVal pResult As SOCKET Ptr _
	)As HRESULT
	
	*pResult = this->m_Socket
	Return S_OK
End If

Function NetworkStreamSetSocket( _
		ByVal this As NetworkStream Ptr, _
		ByVal sock As SOCKET _
	)As HRESULT
	
	this->m_Socket = sock
	Return S_OK
End If
