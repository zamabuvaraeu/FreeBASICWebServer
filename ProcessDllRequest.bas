#include once "ProcessDllRequest.bi"
#include once "Http.bi"
#include once "WriteHttpError.bi"
#include once "Classes\ServerState.bi"

Function ProcessDllCgiRequest( _
		ByVal state As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal www As SimpleWebSite Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	' Создать клиентский буфер
	Dim hMapFile As HANDLE = CreateFileMapping(INVALID_HANDLE_VALUE, 0, PAGE_READWRITE, 0, MaxClientBufferLength, NULL)
	If hMapFile = 0 Then
		Dim intError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Ошибка CreateFileMapping", intError
		#endif
		WriteHttpNotEnoughMemory(state, ClientSocket, www)
		Return False
	End If
	
	Dim ClientBuffer As Any Ptr = MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, MaxClientBufferLength)
	If ClientBuffer = 0 Then
		Dim intError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Ошибка MapViewOfFile", intError
		#endif
		CloseHandle(hMapFile)
		WriteHttpNotEnoughMemory(state, ClientSocket, www)
		Return False
	End If
	
	Dim hModule As HINSTANCE = LoadLibrary(pRequestedFile->PathTranslated)
	If hModule = NULL Then
		Dim intError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Ошибка загрузки DLL", intError
		#endif
		UnmapViewOfFile(ClientBuffer)
		CloseHandle(hMapFile)
		WriteHttpNotEnoughMemory(state, ClientSocket, www)
		Return False
	End If
	
	Dim ProcessDllRequest As Function(ByVal objServerState As ServerState Ptr)As Boolean = GetProcAddress(hModule, "ProcessDllRequest")
	
	If CInt(ProcessDllRequest) = 0 Then
		#if __FB_DEBUG__ <> 0
			Dim intError As DWORD = GetLastError()
			Print "Ошибка поиска функции ProcessDllRequest", intError
		#endif
		UnmapViewOfFile(ClientBuffer)
		CloseHandle(hMapFile)
		FreeLibrary(hModule)
		WriteHttpBadGateway(state, ClientSocket, www)
		Return False
	End If
	
	' TODO Указать функции для IUnknown
	Dim objVirtualTable As IServerStateVirtualTable = Any
	objVirtualTable.VirtualTable.QueryInterface = 0
	objVirtualTable.VirtualTable.Addref = 0
	objVirtualTable.VirtualTable.Release = 0
	objVirtualTable.GetRequestHeader = @ServerStateDllCgiGetRequestHeader
	objVirtualTable.GetHttpMethod = @ServerStateDllCgiGetHttpMethod
	objVirtualTable.GetHttpVersion = @ServerStateDllCgiGetHttpVersion
	objVirtualTable.SetStatusCode = @ServerStateDllCgiSetStatusCode
	objVirtualTable.SetStatusDescription = @ServerStateDllCgiSetStatusDescription
	objVirtualTable.SetResponseHeader = @ServerStateDllCgiSetResponseHeader
	objVirtualTable.WriteData = @ServerStateDllCgiWriteData
	objVirtualTable.ReadData = @ServerStateDllCgiReadData
	objVirtualTable.GetHtmlSafeString = @ServerStateDllCgiGetHtmlSafeString
	
	Dim objServerState As ServerState = Any
	objServerState.pVirtualTable = @objVirtualTable
	objServerState.ClientSocket = ClientSocket
	objServerState.state = state
	objServerState.www = www
	objServerState.hMapFile = hMapFile
	objServerState.ClientBuffer = ClientBuffer
	objServerState.BufferLength = 0
	
	Dim Result As Boolean = ProcessDllRequest(@objServerState)
	If Result = False Then
		Dim intError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Функция ProcessDllRequest завершилась ошибкой", intError
		#endif
		UnmapViewOfFile(objServerState.ClientBuffer)
		CloseHandle(hMapFile)
		WriteHttpNotEnoughMemory(state, ClientSocket, www)
		Return False
	End If
	
	' Создать и отправить заголовки ответа
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	If send(ClientSocket, @SendBuffer, state->AllResponseHeadersToBytes(@SendBuffer, objServerState.BufferLength), 0) = SOCKET_ERROR Then
		UnmapViewOfFile(objServerState.ClientBuffer)
		CloseHandle(hMapFile)
		Return False
	End If
	
	' Тело
	If state->ServerResponse.SendOnlyHeaders = False Then
		If send(ClientSocket, objServerState.ClientBuffer, objServerState.BufferLength, 0) = SOCKET_ERROR Then
			UnmapViewOfFile(objServerState.ClientBuffer)
			CloseHandle(hMapFile)
			Return False
		End If
	End If
	
	UnmapViewOfFile(objServerState.ClientBuffer)
	CloseHandle(hMapFile)
	FreeLibrary(hModule)
	Return True
End Function
