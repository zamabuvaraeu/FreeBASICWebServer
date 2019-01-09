#include "ProcessCgiRequest.bi"
#include "HttpConst.bi"
#include "WriteHttpError.bi"
#include "Http.bi"
#include "win\shlwapi.bi"

Const MaxEnvironmentBlockBufferLength As Integer = 256 * 1024

Function CreateEnvironmentBlock( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As WString Ptr
	
	Dim EnvironmentBlock As WString Ptr = VirtualAlloc( _
		0, _
		MaxEnvironmentBlockBufferLength, _
		MEM_COMMIT Or MEM_RESERVE, _
		PAGE_READWRITE _
	)
	If EnvironmentBlock = 0 Then
		Dim dwError As DWORD = GetLastError()
		Return 0
	End If
	EnvironmentBlock[0] = 0
	EnvironmentBlock[1] = 0
	EnvironmentBlock[2] = 0
	EnvironmentBlock[3] = 0
	'
	Dim wStart As WString Ptr = EnvironmentBlock
	
	lstrcpy(wStart, "SCRIPT_FILENAME=")
	lstrcat(wStart, @pRequestedFile->PathTranslated)
	wStart += lstrlen(wStart) + 1
	
	lstrcpy(wStart, "PATH_INFO=")
	lstrcat(wStart, @"")
	wStart += lstrlen(wStart) + 1
	
	lstrcpy(wStart, "SCRIPT_NAME=")
	lstrcat(wStart, @"")
	wStart += lstrlen(wStart) + 1
	
	lstrcpy(wStart, "REQUEST_LINE=")
	lstrcat(wStart, pRequest->ClientURI.Url)
	wStart += lstrlen(wStart) + 1
	
	lstrcpy(wStart, "QUERY_STRING=")
	lstrcat(wStart, pRequest->ClientURI.QueryString)
	wStart += lstrlen(wStart) + 1
	
	lstrcpy(wStart, "SERVER_PROTOCOL=")
	' TODO Указать правильную версию
	lstrcat(wStart, @HttpVersion11)
	wStart += lstrlen(wStart) + 1
	
	' TODO Указать правильный порт
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
		Dim HttpMethod As WString Ptr = HttpMethodToString(pRequest->HttpMethod, 0)
		lstrcat(wStart, HttpMethod)
	End Scope
	wStart += lstrlen(wStart) + 1
	
	For i As Integer = 0 To WebRequest.RequestHeaderMaximum - 1
		lstrcpy(wStart, KnownRequestCgiHeaderToString(i, 0))
		lstrcat(wStart, "=")
		If pRequest->RequestHeaders(i) <> 0 Then
			lstrcat(wStart, pRequest->RequestHeaders(i))
		End If
		wStart += lstrlen(wStart) + 1
	Next
	
	wStart[0] = 0
	
	Dim lpflOldProtect As DWORD = Any
	If VirtualProtect(EnvironmentBlock, MaxEnvironmentBlockBufferLength, PAGE_READONLY, @lpflOldProtect) = 0 Then
		Dim dwError As DWORD = GetLastError()
	End If
	
	Return EnvironmentBlock
End Function

Function ProcessCgiRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	Const MaxBufferLength As Integer = 4096 - 1
	
	Dim Buffer As ZString * (MaxBufferLength + 1) = Any
	
	' Длина содержимого по заголовку Content-Length слишком большая
	Dim RequestBodyContentLength As LARGE_INTEGER = Any
	If StrToInt64Ex(pRequest->RequestHeaders(HttpRequestHeaders.HeaderContentLength), STIF_DEFAULT, @RequestBodyContentLength.QuadPart) = 0 Then
		RequestBodyContentLength.QuadPart = 0
	Else
		If RequestBodyContentLength.QuadPart > MaxRequestBodyContentLength Then
			WriteHttpRequestEntityTooLarge(pRequest, pResponse, pClientReader->pStream, pWebSite)
			Return False
		End If
	End If
	
	Dim EnvironmentBlock As WString Ptr = CreateEnvironmentBlock(pRequest, pResponse, pWebSite, pRequestedFile)
	If EnvironmentBlock = 0 Then
		WriteHttpNotEnoughMemory(pRequest, pResponse, pClientReader->pStream, pWebSite)
		Return False
	End If
	
	' Текущая директория дочернего процесса
	Dim CurrentChildProcessDirectory As WString * (MAX_PATH + 1) = Any
	lstrcpy(@CurrentChildProcessDirectory, @pRequestedFile->PathTranslated)
	PathRemoveFileSpec(@CurrentChildProcessDirectory)
	
	' Скопировать в буфер имя исполняемого файла
	Dim ApplicationNameBuffer As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
	lstrcpy(@ApplicationNameBuffer, @pRequestedFile->PathTranslated)
	
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
		VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pClientReader->pStream, pWebSite)
		Return False
	End If
	If SetHandleInformation(hChildStdOutRead, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pClientReader->pStream, pWebSite)
		Return False
	End If
	
	If CreatePipe(@hChildStdInRead, @hChildStdInWrite, @saAttr, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pClientReader->pStream, pWebSite)
		Return False
	End If
	If SetHandleInformation(hChildStdInWrite, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pClientReader->pStream, pWebSite)
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
		VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
		CloseHandle(hChildStdInRead)
		CloseHandle(hChildStdInWrite)
		CloseHandle(hChildStdOutRead)
		CloseHandle(hChildStdOutWrite)
		
		WriteHttpCannotCreateChildProcess(pRequest, pResponse, pClientReader->pStream, pWebSite)
		Return False
	End If
	
	If pRequest->HttpMethod = HttpMethods.HttpPost Then
		
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
			Dim ReadedBytes As Integer = Any
			Dim hr As HRESULT = pINetworkStream->pVirtualTable->InheritedTable.Read(pINetworkStream, _
				@Buffer, 0, MaxBufferLength, @ReadedBytes _
			)
			If FAILED(hr) Then
				Exit Do
			End If
			If ReadedBytes = 0 Then
				Exit Do
			End If
			
			PreloadedContentLength += ReadedBytes
			WriteFile(hChildStdInWrite, @Buffer, ReadedBytes, @WriteBytesCount, NULL)
			
		Loop
	End If
	
	If CloseHandle(hChildStdInWrite) = 0 Then
		Dim dwError As DWORD = GetLastError()
	End If
	If CloseHandle(hChildStdOutWrite) = 0 Then
		Dim dwError As DWORD = GetLastError()
	End If
	
	Do
		Dim ReadBytesCount As DWORD = Any
		
		If ReadFile(hChildStdOutRead, @Buffer, MaxBufferLength, @ReadBytesCount, NULL) = 0 Then
			Dim dwError As DWORD = GetLastError()
			Exit Do
		End If
		
		If ReadBytesCount = 0 Then
			Exit Do
		End If
		
		Buffer[ReadBytesCount] = 0
		
		Dim WritedBytes As Integer = Any
		Dim hr As HRESULT = pINetworkStream->pVirtualTable->InheritedTable.Write(pINetworkStream, _
			@Buffer, 0, ReadBytesCount, @WritedBytes _
		)
		If FAILED(hr) Then
			Exit Do
		End If
	Loop
	
	CloseHandle(hChildStdInRead)
	CloseHandle(hChildStdOutRead)
	
	CloseHandle(piProcInfo.hProcess)
	CloseHandle(piProcInfo.hThread)
	
	VirtualFree(EnvironmentBlock, 0, MEM_RELEASE)
	
	Return True
End Function
