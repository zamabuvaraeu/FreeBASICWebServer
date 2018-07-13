#include once "WebServer.bi"
#include once "win\shlwapi.bi"
#include once "ThreadProc.bi"
#include once "Network.bi"
#include once "ReadHeadersResult.bi"
#include once "WebUtils.bi"
#include once "IniConst.bi"
#include once "WriteHttpError.bi"
#include once "WebSite.bi"

Function InitializeWebServer( _
		ByVal pWebServer As WebServer Ptr _
	)As Integer
	
	' Имя исполняемого файла
	Dim ExeFileName As WString * (MAX_PATH + 1) = Any
	Dim ExeFileNameLength As DWORD = GetModuleFileName(0, @ExeFileName, MAX_PATH)
	If ExeFileNameLength = 0 Then
		Return 4
	End If
	lstrcpy(@pWebServer->ExeDir, @ExeFileName)
	' Вырезать имя файла, оставить только путь
	PathRemoveFileSpec(@pWebServer->ExeDir)
	
	' Файл с настройками
	Dim IniFileName As WString * (MAX_PATH + 1)
	PathCombine(@IniFileName, @pWebServer->ExeDir, @WebServerIniFileString)
	
	Dim ListenAddress As WString * 256 = Any
	Dim ListenPort As WString * 16 = Any
	
	GetPrivateProfileString(@WebServerSectionString, @ListenAddressSectionString, @DefaultAddressString, @ListenAddress, 255, @IniFileName)
	GetPrivateProfileString(@WebServerSectionString, @PortSectionString, @DefaultHttpPort, @ListenPort, 15, @IniFileName)
	
	Dim WebSitesLength As Integer = GetWebSitesArray(@pWebServer->ExeDir, @pWebServer->pWebSitesArray)
	
	Scope
		Dim objWsaData As WSAData = Any
		If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> NO_ERROR Then
			Return 1
		End If
	End Scope
	
	pWebServer->ListenSocket = CreateSocketAndListen(@ListenAddress, @ListenPort)
	If pWebServer->ListenSocket = INVALID_SOCKET Then
		WSACleanup()
		Return 2
	End If
	
	MyHeapCreate(@pWebServer->hHeap)
	
	Return 0
End Function

Sub UninitializeWebServer( _
		ByVal pWebServer As WebServer Ptr _
	)
	
	CloseSocketConnection(pWebServer->ListenSocket)
	MyHeapDestroy(CPtr(ThreadParam Ptr, @pWebServer->hHeap))
	WSACleanup()
End Sub

Function WebServerMainLoop( _
		ByVal lpParam As LPVOID _
	)As DWORD
	
	Dim pWebServer As WebServer Ptr = lpParam
	
	Dim RemoteAddress As SOCKADDR_IN = Any
	Dim RemoteAddressLength As Long = SizeOf(RemoteAddress)
	Dim ClientSocket As SOCKET = accept(pWebServer->ListenSocket, CPtr(SOCKADDR Ptr, @RemoteAddress), @RemoteAddressLength)
	
	Do Until ClientSocket = INVALID_SOCKET
		Dim param As ThreadParam Ptr = MyHeapAlloc(@pWebServer->hHeap)
		If param = 0 Then
			Dim state As ReadHeadersResult = Any
			InitializeReadHeadersResult(@state)
			
			WriteHttpNotEnoughMemory(@state, ClientSocket, 0)
			
			CloseSocketConnection(param->ClientSocket)
		Else
			param->ClientSocket = ClientSocket
			param->RemoteAddress = RemoteAddress
			param->RemoteAddressLength = RemoteAddressLength
			param->ServerSocket = pWebServer->ListenSocket
			param->ExeDir = @pWebServer->ExeDir
			param->pWebSitesArray = pWebServer->pWebSitesArray
			
			param->hThread = CreateThread(NULL, 0, @ThreadProc, param, 0, @param->ThreadId)
			If param->hThread = NULL Then
				' TODO Узнать ошибку и обработать
				Dim state As ReadHeadersResult = Any
				InitializeReadHeadersResult(@state)
				
				WriteHttpCannotCreateThread(@state, ClientSocket, 0)
				
				CloseSocketConnection(param->ClientSocket)
				MyHeapFree(param)
			End If
		End If
		ClientSocket = accept(pWebServer->ListenSocket, CPtr(SOCKADDR Ptr, @RemoteAddress), @RemoteAddressLength)
	Loop
	Return 0
End Function
