#ifndef THREADPROC_BI
#define THREADPROC_BI

#include "NetworkStream.bi"
#include "Network.bi"
#include "WebSite.bi"

Type ThreadParam
	Dim ClientSocket As SOCKET
	Dim ServerSocket As SOCKET
	Dim tcpStream As NetworkStream
	Dim pINetworkStream As INetworkStream Ptr
	Dim RemoteAddress As SOCKADDR_IN
	Dim RemoteAddressLength As Integer
	Dim hInput As HANDLE
	Dim hOutput As HANDLE
	Dim hError As HANDLE
	Dim ThreadId As DWORD
	Dim hThread As HANDLE
	Dim pExeDir As WString Ptr
	Dim pWebSitesArray As WebSitesArray Ptr
End Type

Declare Function ThreadProc( _
	ByVal lpParam As LPVOID _
)As DWORD

#endif
