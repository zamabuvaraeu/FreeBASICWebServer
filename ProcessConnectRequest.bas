#include once "ProcessConnectRequest.bi"
#include once "WebUtils.bi"
#include once "IniConst.bi"
#include once "CharConstants.bi"
#include once "Network.bi"
#include once "WriteHttpError.bi"
#include once "win\shlwapi.bi"
#include once "Classes\Configuration.bi"

' Инкапсуляция клиентского и серверного сокетов как параметр для процедуры потока
Type ClientServerSocket
	Dim InSock As SOCKET
	Dim OutSock As SOCKET
	Dim ThreadId As DWord
End Type

' Получение данных от входящего сокета и отправка на исходящий
Declare Sub SendReceiveData( _
	ByVal OutSock As SOCKET, _
	ByVal InSock As SOCKET _
)

Declare Function SendReceiveDataThreadProc( _
	ByVal lpParam As LPVOID _
)As DWORD

Function ProcessConnectRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	' Проверка заголовка Authorization
	If HttpAuthUtil(pState, pClientReader->pStream, pWebSite, True) = False Then
		Return False
	End If
	
	Dim SettingsFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@SettingsFileName, pWebSite->PhysicalDirectory, @WebServerIniFileString)
	
	Dim Config As Configuration = Any
	InitializeConfiguration(@Config, @SettingsFileName)
	Dim pConfig As IConfiguration Ptr = CPtr(IConfiguration Ptr, @Config)
	
	Dim ConnectBindAddress As WString * 256 = Any
	Dim ConnectBindPort As WString * 16 = Any
	
	Dim ValueLength As Integer = Any
	
	pConfig->pVirtualTable->GetStringValue(pConfig, @WebServerSectionString, @ConnectBindAddressKeyString, @DefaultAddressString, 255, @ConnectBindAddress, @ValueLength)
	pConfig->pVirtualTable->GetStringValue(pConfig, @WebServerSectionString, @ConnectBindPortKeyString, @ConnectBindDefaultPort, 15, @ConnectBindPort, @ValueLength)
	
	Dim ServiceName As WString Ptr = Any
	Dim wColon As WString Ptr = StrChr(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderHost), ColonChar)
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
		ServerSocket2 = ConnectToServer(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderHost), ServiceName, @ConnectBindAddress, @ConnectBindPort)
		If ServerSocket2 <> INVALID_SOCKET Then
			Exit For
		End If
	Next
	
	If ServerSocket2 = INVALID_SOCKET Then
		WriteHttpGatewayTimeout(pState, pClientReader->pStream, pWebSite)
		Return False
	End If
	
	pState->ClientRequest.KeepAlive = True
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	send(ClientSocket, @SendBuffer, pState->AllResponseHeadersToBytes(@SendBuffer, 0), 0)
	
	Dim CSS As ClientServerSocket = Any
	With CSS
		.InSock = ClientSocket
		.OutSock = ServerSocket2
	End With
	
	Dim hThread As HANDLE = CreateThread(NULL, 0, @SendReceiveDataThreadProc, @CSS, 0, @CSS.ThreadId)
	
	If hThread <> NULL Then
		SendReceiveData(ClientSocket, ServerSocket2)
		CloseSocketConnection(ServerSocket2)
		
		WaitForSingleObject(hThread, INFINITE)
		
		CloseHandle(hThread)
	End If
	
	pState->ClientRequest.KeepAlive = False
	
	Return True
	
End Function

Sub SendReceiveData( _
		ByVal OutSock As SOCKET, _
		ByVal InSock As SOCKET _
	)
	' Читать данные из входящего сокета, отправлять на исходящий
	Const MaxBytesCount As Integer = 20 * 4096
	Dim ReceiveBuffer As ZString * (MaxBytesCount) = Any
	
	Dim intReceivedBytesCount As Integer = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
	
	Do
		
		Select Case intReceivedBytesCount
			Case SOCKET_ERROR
				' pState->StatusCode = 502
				' WriteHttpError(pState, ClientSocket, @HttpError504GatewayTimeout, @pWebSite->VirtualPath)
				Exit Sub
				
			Case 0
				Exit Sub
				
			Case Else
				If send(OutSock, ReceiveBuffer, intReceivedBytesCount, 0) = SOCKET_ERROR Then
					Exit Sub
				End If
				intReceivedBytesCount = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
				
		End Select
		
	Loop
End Sub

Function SendReceiveDataThreadProc(ByVal lpParam As LPVOID)As DWORD
	Dim pClientServerSocket As ClientServerSocket Ptr = CPtr(ClientServerSocket Ptr, lpParam)
	SendReceiveData(pClientServerSocket->OutSock, pClientServerSocket->InSock)
	Return 0
End Function
