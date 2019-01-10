#include "ProcessConnectRequest.bi"
#include "WebUtils.bi"
#include "IniConst.bi"
#include "CharacterConstants.bi"
#include "Network.bi"
#include "WriteHttpError.bi"
#include "win\shlwapi.bi"
#include "Configuration.bi"
#include "NetworkStream.bi"

Type ClientServerSocket
	Dim pIStreamIn As INetworkStream Ptr
	Dim pIStreamOut As INetworkStream Ptr
	Dim ThreadId As DWord
End Type

Declare Sub SendReceiveData( _
	ByVal pIStreamIn As INetworkStream Ptr, _
	ByVal pIStreamOut As INetworkStream Ptr _
)

Declare Function SendReceiveDataThreadProc( _
	ByVal lpParam As LPVOID _
)As DWORD

Function ProcessConnectRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	' Проверка заголовка Authorization
	If HttpAuthUtil(pRequest, pResponse, pINetworkStream, pWebSite, True) = False Then
		Return False
	End If
	
	Dim SettingsFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@SettingsFileName, pWebSite->PhysicalDirectory, @WebServerIniFileString)
	
	Dim Config As Configuration = Any
	Dim pConfig As IConfiguration Ptr = CPtr(IConfiguration Ptr, New(@Config) Configuration())
	
	pConfig->pVirtualTable->SetIniFilename(pConfig, @SettingsFileName)
	
	Dim ConnectBindAddress As WString * 256 = Any
	Dim ConnectBindPort As WString * 16 = Any
	
	Dim ValueLength As Integer = Any
	
	pConfig->pVirtualTable->GetStringValue(pConfig, @WebServerSectionString, @ConnectBindAddressKeyString, @DefaultAddressString, 255, @ConnectBindAddress, @ValueLength)
	pConfig->pVirtualTable->GetStringValue(pConfig, @WebServerSectionString, @ConnectBindPortKeyString, @ConnectBindDefaultPort, 15, @ConnectBindPort, @ValueLength)
	
	Dim ServiceName As WString Ptr = Any
	Dim wColon As WString Ptr = StrChr(pRequest->RequestHeaders(HttpRequestHeaders.HeaderHost), Characters.Colon)
	If wColon = 0 Then
		ServiceName = @DefaultHttpPort
	Else
		wColon[0] = 0
		If lstrlen(wColon + 1) = 0 Then
			ServiceName = @DefaultHttpPort
		Else
			ServiceName = wColon + 1
		End If
	End If
	
	Dim ServerSocket2 As SOCKET = INVALID_SOCKET
	For i As Integer = 0 To 9
		ServerSocket2 = ConnectToServer( _
			pRequest->RequestHeaders(HttpRequestHeaders.HeaderHost), ServiceName, @ConnectBindAddress, @ConnectBindPort _
		)
		If ServerSocket2 <> INVALID_SOCKET Then
			Exit For
		End If
	Next
	
	If ServerSocket2 = INVALID_SOCKET Then
		WriteHttpGatewayTimeout(pRequest, pResponse, pINetworkStream, pWebSite)
		Return False
	End If
	
	pRequest->KeepAlive = True
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	' send(ClientSocket, @SendBuffer, AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, 0), 0)
	Dim WritedBytes As Integer = Any
	Dim hr As HRESULT = pINetworkStream->pVirtualTable->InheritedTable.Write(pINetworkStream, _
		@SendBuffer, 0, AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, 0), @WritedBytes _
	)
	If FAILED(hr) Then
		CloseSocketConnection(ServerSocket2)
		Return False
	End If
	
	Dim tcpStream As NetworkStream = Any
	Dim pINetworkStreamOut As INetworkStream Ptr = CPtr(INetworkStream Ptr, New(@tcpStream) NetworkStream())
	
	pINetworkStreamOut->pVirtualTable->SetSocket(pINetworkStreamOut, ServerSocket2)
	
	Dim CSS As ClientServerSocket = Any
	With CSS
		.pIStreamIn = pINetworkStream
		.pIStreamOut = pINetworkStreamOut
	End With
	
	Dim hThread As HANDLE = CreateThread(NULL, 0, @SendReceiveDataThreadProc, @CSS, 0, @CSS.ThreadId)
	
	If hThread <> NULL Then
		SendReceiveData(pINetworkStream, pINetworkStreamOut)
		CloseSocketConnection(ServerSocket2)
		
		WaitForSingleObject(hThread, INFINITE)
		
		CloseHandle(hThread)
	End If
	
	pRequest->KeepAlive = False
	
	Return True
	
End Function

Sub SendReceiveData( _
		ByVal pIStreamIn As INetworkStream Ptr, _
		ByVal pIStreamOut As INetworkStream Ptr _
	)
	' Читать данные из входящего сокета, отправлять на исходящий
	Const MaxBytesCount As Integer = 20 * 4096
	Dim ReceiveBuffer As ZString * (MaxBytesCount) = Any
	
	' Dim intReceivedBytesCount As Integer = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
	Dim ReadedBytes As Integer = Any
	Dim hrIn As HRESULT = pIStreamIn->pVirtualTable->InheritedTable.Read(pIStreamIn, _
		@ReceiveBuffer, 0, MaxBytesCount, @ReadedBytes _
	)
	If FAILED(hrIn) Then
		Exit Sub
	End If
	If ReadedBytes = 0 Then
		Exit Sub
	End If
	
	Do
		' If send(OutSock, ReceiveBuffer, intReceivedBytesCount, 0) = SOCKET_ERROR Then
			' Exit Sub
		' End If
		Dim WritedBytes As Integer = Any
		Dim hrOut As HRESULT = pIStreamOut->pVirtualTable->InheritedTable.Write(pIStreamOut, _
			@ReceiveBuffer, 0, ReadedBytes, @WritedBytes _
		)
		If FAILED(hrOut) Then
			Exit Sub
		End If
		
		' intReceivedBytesCount = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
		hrIn = pIStreamIn->pVirtualTable->InheritedTable.Read(pIStreamIn, _
			@ReceiveBuffer, 0, MaxBytesCount, @ReadedBytes _
		)
		If FAILED(hrIn) Then
			Exit Sub
		End If
		If ReadedBytes = 0 Then
			Exit Sub
		End If
		
	Loop
End Sub

Function SendReceiveDataThreadProc( _
		ByVal lpParam As LPVOID _
	)As DWORD
	
	Dim pClientServerSocket As ClientServerSocket Ptr = CPtr(ClientServerSocket Ptr, lpParam)
	SendReceiveData(pClientServerSocket->pIStreamOut, pClientServerSocket->pIStreamIn)
	
	Return 0
End Function
