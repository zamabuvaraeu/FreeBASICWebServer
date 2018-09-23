#include once "ProcessDllRequest.bi"
#include once "Interfaces\IServerState.bi"
#include once "Http.bi"
#include once "WriteHttpError.bi"
#include once "WebUtils.bi"

Const MaxClientBufferLength As Integer = 512 * 1024

Type ServerState
	Dim VirtualTable As IServerStateVirtualTable Ptr
	Dim ClientSocket As Socket
	Dim state As ReadHeadersResult Ptr
	Dim www As SimpleWebSite Ptr
	
	' Буфер памяти для сохранения клиентского ответа
	Dim hMapFile As Handle
	Dim ClientBuffer As Any Ptr
	Dim BufferLength As Integer
End Type

Function DllCgiGetRequestHeader( _
		ByVal objState As ServerState Ptr, _
		ByVal Value As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HeaderIndex As HttpRequestHeaders _
	)As Integer
	
	Dim HeaderLength As Integer = lstrlen(objState->state->ClientRequest.RequestHeaders(HeaderIndex))
	If HeaderLength > BufferLength Then
		SetLastError(ERROR_INSUFFICIENT_BUFFER)
		Return -1
	End If
	
	SetLastError(ERROR_SUCCESS)
	lstrcpy(Value, objState->state->ClientRequest.RequestHeaders(HeaderIndex))
	Return HeaderLength
End Function

Function DllCgiGetHttpMethod( _
		ByVal objState As ServerState Ptr _
	)As HttpMethods
	
	SetLastError(ERROR_SUCCESS)
	Return objState->state->ClientRequest.HttpMethod
End Function

Function DllCgiGetHttpVersion( _
		ByVal objState As ServerState Ptr _
	)As HttpVersions
	
	SetLastError(ERROR_SUCCESS)
	Return objState->state->ClientRequest.HttpVersion
End Function

Sub DllCgiSetStatusCode( _
		ByVal objState As ServerState Ptr, _
		ByVal Code As Integer _
	)
	objState->state->ServerResponse.StatusCode = Code
End Sub

Sub DllCgiSetStatusDescription( _
		ByVal objState As ServerState Ptr, _
		ByVal Description As WString Ptr _
	)
	' TODO Устранить потенциальное переполнение буфера
	objState->state->ServerResponse.SetStatusDescription(Description)
End Sub

Sub DllCgiSetResponseHeader( _
		ByVal objState As ServerState Ptr, _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)
	' TODO Устранить потенциальное переполнение буфера
	objState->state->ServerResponse.AddKnownResponseHeader(HeaderIndex, Value)
End Sub

Function DllCgiWriteData( _
		ByVal objState As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BytesCount As Integer _
	)As Boolean
	
	If BytesCount > MaxClientBufferLength - objState->BufferLength Then
		SetLastError(ERROR_BUFFER_OVERFLOW)
		Return False
	End If
	
	RtlCopyMemory(objState->ClientBuffer, Buffer, BytesCount)
	objState->BufferLength += BytesCount
	SetLastError(ERROR_SUCCESS)
	
	Return True
End Function

Function DllCgiReadData( _
		ByVal objState As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BufferLength As Integer, _
		ByVal ReadedBytesCount As Integer Ptr _
	)As Boolean
	
	Return False
End Function

Function DllCgiGetHtmlSafeString( _
		ByVal objState As IServerState Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal HtmlSafeLength As Integer Ptr _
	)As Boolean
	Return GetHtmlSafeString(Buffer, BufferLength, HtmlSafe, HtmlSafeLength)
End Function


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
		WriteHttpNotEnoughMemory(state, ClientSocket, www)
		Return False
	End If
	
	Dim ProcessDllRequest As Function(ByVal objServerState As ServerState Ptr)As Boolean
	
	Dim DllFunction As Any Ptr = GetProcAddress(hModule, "ProcessDllRequest")
	If DllFunction = 0 Then
		Dim intError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Ошибка поиска функции ProcessDllRequest", intError
		#endif
		FreeLibrary(hModule)
		WriteHttpBadGateway(state, ClientSocket, www)
		Return False
	End If
	
	ProcessDllRequest = DllFunction
	
	Dim objVirtualTable As IServerStateVirtualTable = Any
	objVirtualTable.GetRequestHeader = CPtr(Any Ptr, @DllCgiGetRequestHeader)
	objVirtualTable.GetHttpMethod = CPtr(Any Ptr, @DllCgiGetHttpMethod)
	objVirtualTable.GetHttpVersion = CPtr(Any Ptr, @DllCgiGetHttpVersion)
	objVirtualTable.SetStatusCode = CPtr(Any Ptr, @DllCgiSetStatusCode)
	objVirtualTable.SetStatusDescription = CPtr(Any Ptr, @DllCgiSetStatusDescription)
	objVirtualTable.SetResponseHeader = CPtr(Any Ptr, @DllCgiSetResponseHeader)
	objVirtualTable.WriteData = CPtr(Any Ptr, @DllCgiWriteData)
	objVirtualTable.ReadData = CPtr(Any Ptr, @DllCgiReadData)
	objVirtualTable.GetHtmlSafeString = CPtr(Any Ptr, @DllCgiGetHtmlSafeString)
	
	Dim objServerState As ServerState = Any
	objServerState.VirtualTable = @objVirtualTable
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
