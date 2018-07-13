#include once "ProcessCgiRequest.bi"
#include once "HttpConst.bi"
#include once "WriteHttpError.bi"
#include once "Http.bi"

Const MaxEnvironmentBlockBufferLength As Integer = 8 * WebResponse.MaxResponseHeaderBuffer

Function ProcessCgiRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr _
	)As Boolean
	Const MaxBufferLength As Integer = 4096 - 1
	
	Dim Buffer As ZString * (MaxBufferLength + 1) = Any
	
	' Длина содержимого по заголовку Content-Length слишком большая
	Dim RequestBodyContentLength As LARGE_INTEGER = Any
	If StrToInt64Ex(pState->ClientRequest.RequestHeaders(HttpRequestHeaders.HeaderContentLength), STIF_DEFAULT, @RequestBodyContentLength.QuadPart) = 0 Then
		RequestBodyContentLength.QuadPart = 0
	Else
		If RequestBodyContentLength.QuadPart > MaxRequestBodyContentLength Then
			WriteHttpRequestEntityTooLarge(pState, ClientSocket, pWebSite)
			Return False
		End If
	End If
	
	' Создать блок переменных окружения
	Dim hMapFile As HANDLE = CreateFileMapping(INVALID_HANDLE_VALUE, 0, PAGE_READWRITE, 0, MaxEnvironmentBlockBufferLength, NULL)
	If hMapFile = 0 Then
		WriteHttpNotEnoughMemory(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	Dim EnvironmentBlock As WString Ptr = CPtr(WString Ptr, MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, MaxEnvironmentBlockBufferLength))
	If EnvironmentBlock = 0 Then
		CloseHandle(hMapFile)
		WriteHttpNotEnoughMemory(pState, ClientSocket, pWebSite)
		Return False
	End If
	EnvironmentBlock[0] = 0
	EnvironmentBlock[1] = 0
	EnvironmentBlock[2] = 0
	EnvironmentBlock[3] = 0
	'
	Scope
		Dim wStart As WString Ptr = EnvironmentBlock
		
		lstrcpy(wStart, "SCRIPT_FILENAME=")
		lstrcat(wStart, pWebSite->PathTranslated)
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "PATH_INFO=")
		lstrcat(wStart, @"")
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "SCRIPT_NAME=")
		lstrcat(wStart, @"")
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "REQUEST_LINE=")
		lstrcat(wStart, pState->ClientRequest.ClientURI.Url)
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "QUERY_STRING=")
		lstrcat(wStart, pState->ClientRequest.ClientURI.QueryString)
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "SERVER_PROTOCOL=")
		' TODO Указать правильную версию
		lstrcat(wStart, @HttpVersion11)
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "SERVER_PORT=80")
		REM lstrcat(wStart, @pWebSite->HostName)
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "GATEWAY_INTERFACE=")
		lstrcat(wStart, @"CGI/1.1")
		wStart += lstrlen(wStart) + 1
		
		
		lstrcpy(wStart, "REMOTE_ADDR=")
		lstrcat(wStart, @"")
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "REMOTE_HOST=")
		lstrcat(wStart, @"")
		wStart += lstrlen(wStart) + 1
		
		lstrcpy(wStart, "REQUEST_METHOD=")
		Scope
			Dim HttpMethod As WString Ptr = HttpMethodToString(pState->ClientRequest.HttpMethod, 0)
			lstrcat(wStart, HttpMethod)
		End Scope
		wStart += lstrlen(wStart) + 1
		
		For i As Integer = 0 To WebRequest.RequestHeaderMaximum - 1
			lstrcpy(wStart, KnownRequestCgiHeaderToString(i, 0))
			lstrcat(wStart, "=")
			If pState->ClientRequest.RequestHeaders(i) <> 0 Then
				lstrcat(wStart, pState->ClientRequest.RequestHeaders(i))
			End If
			wStart += lstrlen(wStart) + 1
		Next
		
		' Завершить брок переменных окружения
		wStart[0] = 0
	End Scope
	
	' Текущая директория дочернего процесса
	Dim CurrentChildProcessDirectory As WString * (MAX_PATH + 1) = Any
	lstrcpy(@CurrentChildProcessDirectory, pWebSite->PathTranslated)
	PathRemoveFileSpec(@CurrentChildProcessDirectory)
	
	' Скопировать в буфер имя исполняемого файла
	Dim ApplicationNameBuffer As WString * (SimpleWebSite.MaxFilePathTranslatedLength + 1) = Any
	lstrcpy(@ApplicationNameBuffer, pWebSite->PathTranslated)
	
	' Атрибуты защиты
	Dim saAttr As SECURITY_ATTRIBUTES = Any
	With saAttr
		.nLength = SizeOf(SECURITY_ATTRIBUTES)
		.lpSecurityDescriptor = NULL
		.bInheritHandle = TRUE
	End With
	
	Dim hChildStdInRead As Handle = NULL
	Dim hChildStdInWrite As Handle = NULL
	Dim hChildStdOutRead As Handle = NULL
	Dim hChildStdOutWrite As Handle = NULL
	
	' Каналы чтения‐записи
	If CreatePipe(@hChildStdOutRead, @hChildStdOutWrite, @saAttr, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу создать трубу", dwError
		#endif
		UnmapViewOfFile(EnvironmentBlock)
		CloseHandle(hMapFile)
		WriteHttpCannotCreatePipe(pState, ClientSocket, pWebSite)
		Return False
	End If
	If SetHandleInformation(hChildStdOutRead, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу SetHandleInformation", dwError
		#endif
		UnmapViewOfFile(EnvironmentBlock)
		CloseHandle(hMapFile)
		WriteHttpCannotCreatePipe(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	If CreatePipe(@hChildStdInRead, @hChildStdInWrite, @saAttr, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу создать трубу", dwError
		#endif
		UnmapViewOfFile(EnvironmentBlock)
		CloseHandle(hMapFile)
		WriteHttpCannotCreatePipe(pState, ClientSocket, pWebSite)
		Return False
	End If
	If SetHandleInformation(hChildStdInWrite, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу SetHandleInformation", dwError
		#endif
		UnmapViewOfFile(EnvironmentBlock)
		CloseHandle(hMapFile)
		WriteHttpCannotCreatePipe(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	' Информация о процессе
	Dim siStartInfo As STARTUPINFO
	With siStartInfo
		.cb = SizeOf(STARTUPINFO)
		.hStdInput = hChildStdInRead
		.hStdOutput = hChildStdOutWrite
		.hStdError = hChildStdOutWrite
		.dwFlags = STARTF_USESTDHANDLES
	End With
	
	Dim piProcInfo As PROCESS_INFORMATION
	
	If CreateProcess(@ApplicationNameBuffer, NULL, NULL, NULL, True, CREATE_UNICODE_ENVIRONMENT, EnvironmentBlock, @CurrentChildProcessDirectory, @siStartInfo, @piProcInfo) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу создать дочерний процесс", dwError
		#endif
		UnmapViewOfFile(EnvironmentBlock)
		CloseHandle(hMapFile)
		CloseHandle(hChildStdInRead)
		CloseHandle(hChildStdInWrite)
		CloseHandle(hChildStdOutRead)
		CloseHandle(hChildStdOutWrite)
		
		WriteHttpCannotCreateChildProcess(pState, ClientSocket, pWebSite)
		Return False
	End If
	
	#if __FB_DEBUG__ <> 0
		Print "Создал процесс, ошибок вроде не было"
	#endif
	
	If pState->ClientRequest.HttpMethod = HttpMethods.HttpPost Then
		
		Dim WriteBytesCount As DWORD = Any
		
		' Записать предварительно загруженные данные
		Dim PreloadedContentLength As Integer = pClientReader->BufferLength - pClientReader->Start
		If PreloadedContentLength > 0 Then
			WriteFile(hChildStdInWrite, @pClientReader->Buffer[pClientReader->Start], PreloadedContentLength, @WriteBytesCount, NULL)
			' TODO Проверить на ошибки записи
			pClientReader->Flush()
		End If
		
		' Записать всё остальное
		Do While PreloadedContentLength < RequestBodyContentLength.QuadPart
			Dim numReceived As Integer = recv(ClientSocket, @Buffer, MaxBufferLength, 0)
			
			' TODO Проверить на ошибки записи
			Select Case numReceived
				
				Case SOCKET_ERROR
					Exit Do
					
				Case 0
					Exit Do
					
				Case Else
					' Сколько байт получили, на столько и увеличили буфер
					PreloadedContentLength += numReceived
					WriteFile(hChildStdInWrite, @Buffer, numReceived, @WriteBytesCount, NULL)
					
			End Select
			
		Loop
	End If
	
	If CloseHandle(hChildStdInWrite) = 0 Then
		Dim CloseHandleResultError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу закрыть трубу для записи", CloseHandleResultError
		#endif
	End If
	
	Do
		Dim ReadBytesCount As DWORD = Any
		Dim ReadFileResult As Integer = ReadFile(hChildStdOutRead, @Buffer, MaxBufferLength, @ReadBytesCount, NULL)
		Dim ReadFileResultError As DWORD = GetLastError()
		If ReadFileResult = 0 Then
			#if __FB_DEBUG__ <> 0
				Print "Чтение трубы", ReadFileResult
				Print "Ошибка", ReadFileResultError
			#endif
			Exit Do
		End If
		
		If ReadBytesCount = 0 Then
			Exit Do
		End If
		
		Buffer[ReadBytesCount] = 0
		If send(ClientSocket, @Buffer, ReadBytesCount, 0) = SOCKET_ERROR Then
			Exit Do
		End If
	Loop
	
	#if __FB_DEBUG__ <> 0
		Print "Завершаю работу скрипта"
	#endif
	UnmapViewOfFile(EnvironmentBlock)
	CloseHandle(hMapFile)
	
	CloseHandle(hChildStdInRead)
	CloseHandle(hChildStdOutRead)
	CloseHandle(hChildStdOutWrite)
	
	CloseHandle(piProcInfo.hProcess)
	CloseHandle(piProcInfo.hThread)
	
	Return True
End Function
