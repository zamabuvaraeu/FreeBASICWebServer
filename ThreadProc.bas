#include once "ThreadProc.bi"
#include once "win\winsock2.bi"
#include once "win\ws2tcpip.bi"
#include once "win\shlwapi.bi"
#include once "Network.bi"
#include once "ReadHeadersResult.bi"
#include once "WebUtils.bi"
#include once "ProcessConnectRequest.bi"
#include once "ProcessDeleteRequest.bi"
#include once "ProcessGetHeadRequest.bi"
#include once "ProcessOptionsRequest.bi"
#include once "ProcessPutRequest.bi"
#include once "ProcessTraceRequest.bi"
#include once "Http.bi"
#include once "HeapOnArray.bi"
#include once "WriteHttpError.bi"

Function ThreadProc(ByVal lpParam As LPVOID)As DWORD
	Dim param As ThreadParam Ptr = CPtr(ThreadParam Ptr, lpParam)
	
	Scope
		Dim ReceiveTimeOut As DWORD = 90 * 1000
		setsockopt(param->ClientSocket, SOL_SOCKET, SO_RCVTIMEO, CPtr(ZString Ptr, @ReceiveTimeOut), SizeOf(DWORD))
	End Scope
	
	Dim state As ReadHeadersResult = Any
	Dim ClientReader As StreamSocketReader = Any
	InitializeStreamSocketReader(@ClientReader)
	ClientReader.ClientSocket = param->ClientSocket
	
	Do
		ClientReader.Flush()
		InitializeReadHeadersResult(@state)
		
		If state.ClientRequest.ReadClientHeaders(@ClientReader) = False Then
			Select Case GetLastError()
				
				Case ParseRequestLineResult.HTTPVersionNotSupported
					WriteHttpVersionNotSupported(@state, param->ClientSocket, 0)
					
				Case ParseRequestLineResult.BadRequest
					WriteHttpBadRequest(@state, param->ClientSocket, 0)
					
				Case ParseRequestLineResult.BadPath
					WriteHttpPathNotValid(@state, param->ClientSocket, 0)
					
				Case ParseRequestLineResult.EmptyRequest
					' Пустой запрос, клиент закрыл соединение
					
				Case ParseRequestLineResult.SocketError
					' Ошибка сокета
					
				Case ParseRequestLineResult.RequestUrlTooLong
					WriteHttpRequestUrlTooLarge(@state, param->ClientSocket, 0)
					
				Case ParseRequestLineResult.RequestHeaderFieldsTooLarge
					WriteHttpRequestHeaderFieldsTooLarge(@state, param->ClientSocket, 0)
					
			End Select
			
			Exit Do
			
		End If
		
		' TODO Заголовок Host может не быть в версии 1.0
		If lstrlen(state.ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderHost)) = 0 Then
			If state.ClientRequest.HttpVersion = HttpVersions.Http10 Then
				state.ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderHost) = state.ClientRequest.ClientURI.Url
			Else
				WriteHttpHostNotFound(@state, param->ClientSocket, 0)
				Exit Do
			End If
		End If
		
		#if __FB_DEBUG__ <> 0
			' Распечатать весь запрос
			Print "Распечатываю весь запрос"
			Print ClientReader.Buffer
		#endif
		
		' Найти сайт по его имени
		Dim www As SimpleWebSite = Any
		If GetSimpleWebSite(@www, state.ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderHost), param->pWebSitesArray) = False Then
			If state.ClientRequest.HttpMethod = HttpMethods.HttpConnect Then
				www.PhysicalDirectory = param->ExeDir
			Else
				WriteHttpHostNotFound(@state, param->ClientSocket, 0)
				Exit Do
			End If
		End If
		
		If www.IsMoved <> False Then
			' Сайт перемещён на другой ресурс
			' если запрошен документ /robots.txt то не перенаправлять
			If lstrcmpi(state.ClientRequest.ClientURI.Url, "/robots.txt") <> 0 Then
				WriteMovedPermanently(@state, param->ClientSocket, @www)
				Exit Do
			End If
		End If
		
		' Обработка запроса
		
		Dim hRequestedFile As Handle = Any
		Dim ProcessRequestVirtualTable As Function( _
			ByVal pState As ReadHeadersResult Ptr, _
			ByVal ClientSocket As SOCKET, _
			ByVal pWebSite As SimpleWebSite Ptr, _
			ByVal fileExtention As WString Ptr, _
			ByVal pClientReader As StreamSocketReader Ptr, _
			ByVal hRequestedFile As Handle _
		)As Boolean = Any
		
		Select Case state.ClientRequest.HttpMethod
			
			Case HttpMethods.HttpGet
				hRequestedFile = www.GetFilePath(@state.ClientRequest.ClientURI.Path, FileAccess.ForGetHead)
				ProcessRequestVirtualTable = @ProcessGetHeadRequest
				
			Case HttpMethods.HttpHead
				state.ServerResponse.SendOnlyHeaders = True
				hRequestedFile = www.GetFilePath(@state.ClientRequest.ClientURI.Path, FileAccess.ForGetHead)
				ProcessRequestVirtualTable = @ProcessGetHeadRequest
				
			Case HttpMethods.HttpPut
				hRequestedFile = www.GetFilePath(@state.ClientRequest.ClientURI.Path, FileAccess.ForPut)
				ProcessRequestVirtualTable = @ProcessPutRequest
				
			Case HttpMethods.HttpDelete
				hRequestedFile = INVALID_HANDLE_VALUE
				ProcessRequestVirtualTable = @ProcessDeleteRequest
				
			Case HttpMethods.HttpOptions
				hRequestedFile = INVALID_HANDLE_VALUE
				ProcessRequestVirtualTable = @ProcessOptionsRequest
				
			Case HttpMethods.HttpTrace
				hRequestedFile = INVALID_HANDLE_VALUE
				ProcessRequestVirtualTable = @ProcessTraceRequest
				
			Case HttpMethods.HttpConnect
				hRequestedFile = INVALID_HANDLE_VALUE
				' TODO Устранить грязный хак с конфигурацией метода CONNECT
				lstrcpy(www.PhysicalDirectory, param->ExeDir)
				lstrcpy(www.VirtualPath, @SlashString)
				ProcessRequestVirtualTable = @ProcessConnectRequest
				
			Case Else
				' TODO Выделить в отдельную функцию
				hRequestedFile = INVALID_HANDLE_VALUE
				ProcessRequestVirtualTable = 0
				WriteHttpMethodNotAllowed(@state, param->ClientSocket, 0)
				Exit Do
				
		End Select
		
		If ProcessRequestVirtualTable( _
			@state, _
			param->ClientSocket, _
			@www, _
			PathFindExtension(www.PathTranslated), _
			@ClientReader, _
			hRequestedFile _
		) = False Then
			Exit Do
		End If
		
	Loop While state.ClientRequest.KeepAlive
	
	CloseSocketConnection(param->ClientSocket)
	CloseHandle(param->hThread)
	MyHeapFree(param)
	
	Return 0
End Function
