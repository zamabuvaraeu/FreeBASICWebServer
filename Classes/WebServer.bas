#include "WebServer.bi"
#include "win\shlwapi.bi"
#include "ThreadProc.bi"
#include "Network.bi"
#include "WebUtils.bi"
#include "IniConst.bi"
#include "WriteHttpError.bi"
#include "WebSite.bi"
#include "NetworkStream.bi"
#include "Configuration.bi"
#include "WebRequest.bi"
#include "WebResponse.bi"

Common Shared GlobalWebServerVirtualTable As IWebServerVirtualTable

Constructor WebServer()
	this.pVirtualTable = @GlobalWebServerVirtualTable
	this.ReferenceCounter = 0
	
	Dim ExeFileName As WString * (MAX_PATH + 1) = Any
	Dim ExeFileNameLength As DWORD = GetModuleFileName(0, @ExeFileName, MAX_PATH)
	If ExeFileNameLength = 0 Then
		' Return 4
	End If
	
	lstrcpy(@this.ExeDir, @ExeFileName)
	PathRemoveFileSpec(@this.ExeDir)
	
	PathCombine(@this.SettingsFileName, @this.ExeDir, @WebServerIniFileString)
	
	Scope
		Dim objWsaData As WSAData = Any
		If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> NO_ERROR Then
			' Return 1
		End If
	End Scope
	
	this.ReListenSocket = True
	
	' Return 0
End Constructor

Function WebServerQueryInterface( _
		ByVal pWebServer As WebServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = 0
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pWebServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IWEBSERVER, riid) Then
		*ppv = CPtr(IWebServer Ptr, @pWebServer->pVirtualTable)
	End If
	
	If *ppv = 0 Then
		Return E_NOINTERFACE
	End If
	
	WebServerAddRef(pWebServer)
	
	Return S_OK
End Function

Function WebServerAddRef( _
		ByVal pWebServer As WebServer Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@pWebServer->ReferenceCounter)
End Function

Function WebServerRelease( _
		ByVal pWebServer As WebServer Ptr _
	)As ULONG
	
	InterlockedDecrement(@pWebServer->ReferenceCounter)
	
	If pWebServer->ReferenceCounter = 0 Then
		' DestructorIrcClient(This)
		' InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
	End If
	
	Return pWebServer->ReferenceCounter
End Function

Function WebServerStartServer( _
		ByVal pWebServer As WebServer Ptr _
	)As HRESULT
	
	Dim Config As Configuration = Any
	Dim pIConfig As IConfiguration Ptr = CPtr(IConfiguration Ptr, New(@Config) Configuration())
	
	pIConfig->pVirtualTable->SetIniFilename(pIConfig, @pWebServer->SettingsFileName)
	
	Dim ValueLength As Integer = Any
	
	pIConfig->pVirtualTable->GetStringValue(pIConfig, _
		@WebServerSectionString, _
		@ListenAddressKeyString, _
		@DefaultAddressString, _
		WebServer.ListenAddressLengthMaximum, _
		@pWebServer->ListenAddress, _
		@ValueLength _
	)
	pIConfig->pVirtualTable->GetStringValue(pIConfig, _
		@WebServerSectionString, _
		@PortKeyString, _
		@DefaultHttpPort, _
		WebServer.ListenPortLengthMaximum, _
		@pWebServer->ListenPort, _
		@ValueLength _
	)
	
	Dim WebSitesLength As Integer = GetWebSitesArray(@pWebServer->pWebSitesArray, @pWebServer->ExeDir)
	
	pWebServer->ListenSocket = CreateSocketAndListen(@pWebServer->ListenAddress, @pWebServer->ListenPort)
	If pWebServer->ListenSocket = INVALID_SOCKET Then
		WSACleanup()
		Return E_FAIL
	End If
	
	Dim RemoteAddress As SOCKADDR_IN = Any
	Dim RemoteAddressLength As Long = SizeOf(RemoteAddress)
	
	Dim ClientSocket As SOCKET = accept( _
		pWebServer->ListenSocket, _
		CPtr(SOCKADDR Ptr, @RemoteAddress), _
		@RemoteAddressLength _
	)
	
	Do While pWebServer->ReListenSocket
		If ClientSocket = INVALID_SOCKET Then
			SleepEx(60 * 1000, True)
		Else
			Dim param As ThreadParam Ptr = VirtualAlloc(0, SizeOf(ThreadParam), MEM_COMMIT Or MEM_RESERVE, PAGE_READWRITE)
			
			If param = 0 Then
				Dim tcpStream As NetworkStream = Any
				Dim pINetworkStream As INetworkStream Ptr = CPtr(INetworkStream Ptr, New(@tcpStream) NetworkStream())
				pINetworkStream->pVirtualTable->SetSocket(pINetworkStream, ClientSocket)
				
				' Dim ClientReader As StreamSocketReader = Any
				' InitializeStreamSocketReader(@ClientReader)
				' ClientReader.pStream = pINetworkStream
				
				Dim request As WebRequest = Any
				InitializeWebRequest(@request)
				Dim response As WebResponse = Any
				InitializeWebResponse(@response)
				
				WriteHttpNotEnoughMemory(@request, @response, pINetworkStream, 0)
				
				CloseSocketConnection(ClientSocket)
			Else
				param->pINetworkStream = CPtr(INetworkStream Ptr, New(@param->tcpStream) NetworkStream())
				param->pINetworkStream->pVirtualTable->SetSocket(param->pINetworkStream, ClientSocket)
				
				param->ClientSocket = ClientSocket
				param->RemoteAddress = RemoteAddress
				param->RemoteAddressLength = RemoteAddressLength
				param->ServerSocket = pWebServer->ListenSocket
				param->pExeDir = @pWebServer->ExeDir
				param->pWebSitesArray = pWebServer->pWebSitesArray
				
				param->hThread = CreateThread(NULL, 0, @ThreadProc, param, 0, @param->ThreadId)
				
				If param->hThread = NULL Then
					' TODO Узнать ошибку и обработать
					Dim request As WebRequest = Any
					InitializeWebRequest(@request)
					Dim response As WebResponse = Any
					InitializeWebResponse(@response)
					
					WriteHttpCannotCreateThread(@request, @response, param->pINetworkStream, 0)
					
					CloseSocketConnection(ClientSocket)
					VirtualFree(param, 0, MEM_RELEASE)
				End If
			End If
		End If
		
		ClientSocket = accept(pWebServer->ListenSocket, CPtr(SOCKADDR Ptr, @RemoteAddress), @RemoteAddressLength)
	Loop
	
	Return S_OK
End Function

Function WebServerStopServer( _
		ByVal pWebServer As WebServer Ptr _
	)As HRESULT
	
	pWebServer->ReListenSocket = False
	CloseSocketConnection(pWebServer->ListenSocket)
	WSACleanup()
	
	Return S_OK
End Function
