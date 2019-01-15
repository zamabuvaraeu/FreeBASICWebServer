#include "ProcessCgiRequest.bi"
#include "ArrayStringWriter.bi"
#include "CharacterConstants.bi"
#include "Http.bi"
#include "HttpConst.bi"
#include "StringConstants.bi"
#include "WriteHttpError.bi"
#include "win\shlwapi.bi"

Const MaxEnvironmentBlockBufferLength As Integer = 256 * 1024

Declare Function CreateEnvironmentBlock( _
	ByVal pRequest As WebRequest Ptr, _
	ByVal pResponse As WebResponse Ptr, _
	ByVal pWebSite As SimpleWebSite Ptr, _
	ByVal pRequestedFile As RequestedFile Ptr _
)As WString Ptr

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
			WriteHttpRequestEntityTooLarge(pRequest, pResponse, pINetworkStream, pWebSite)
			Return False
		End If
	End If
	
	Dim pEnvironmentBlock As WString Ptr = CreateEnvironmentBlock(pRequest, pResponse, pWebSite, pRequestedFile)
	If pEnvironmentBlock = 0 Then
		WriteHttpNotEnoughMemory(pRequest, pResponse, pINetworkStream, pWebSite)
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
		VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pINetworkStream, pWebSite)
		Return False
	End If
	
	If SetHandleInformation(hChildStdOutRead, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pINetworkStream, pWebSite)
		Return False
	End If
	
	If CreatePipe(@hChildStdInRead, @hChildStdInWrite, @saAttr, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pINetworkStream, pWebSite)
		Return False
	End If
	If SetHandleInformation(hChildStdInWrite, HANDLE_FLAG_INHERIT, 0) = 0 Then
		Dim dwError As DWORD = GetLastError()
		VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
		WriteHttpCannotCreatePipe(pRequest, pResponse, pINetworkStream, pWebSite)
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
	
	If CreateProcess(@ApplicationNameBuffer, NULL, NULL, NULL, True, CREATE_UNICODE_ENVIRONMENT, pEnvironmentBlock, @CurrentChildProcessDirectory, @siStartInfo, @piProcInfo) = 0 Then
		Dim dwError As DWORD = GetLastError()
		#if __FB_DEBUG__ <> 0
			Print "Не могу создать дочерний процесс", dwError
		#endif
		VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
		CloseHandle(hChildStdInRead)
		CloseHandle(hChildStdInWrite)
		CloseHandle(hChildStdOutRead)
		CloseHandle(hChildStdOutWrite)
		
		WriteHttpCannotCreateChildProcess(pRequest, pResponse, pINetworkStream, pWebSite)
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
			Dim hr As HRESULT = INetworkStream_Read(pINetworkStream, _
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
		Dim hr As HRESULT = INetworkStream_Write(pINetworkStream, _
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
	
	VirtualFree(pEnvironmentBlock, 0, MEM_RELEASE)
	
	Return True
End Function

Function CreateEnvironmentBlock( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As WString Ptr
	
	Dim EnvironmentBlockWriter As ArrayStringWriter = Any
	Dim pIWriter As IArrayStringWriter Ptr = InitializeArrayStringWriterOfIArrayStringWriter(@EnvironmentBlockWriter)
	
	Dim pEnvironmentBlock As WString Ptr = VirtualAlloc( _
		0, _
		MaxEnvironmentBlockBufferLength, _
		MEM_COMMIT Or MEM_RESERVE, _
		PAGE_READWRITE _
	)
	
	If pEnvironmentBlock = 0 Then
		' TODO Узнать ошибку и вывести
		Dim dwError As DWORD = GetLastError()
		Return 0
	End If
	
	ArrayStringWriter_NonVirtualSetBuffer(pIWriter, pEnvironmentBlock, MaxEnvironmentBlockBufferLength)
	
	' pEnvironmentBlock[0] = 0
	' pEnvironmentBlock[1] = 0
	' pEnvironmentBlock[2] = 0
	' pEnvironmentBlock[3] = 0
	'
	' Dim wStart As WString Ptr = pEnvironmentBlock
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"SCRIPT_FILENAME=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @pRequestedFile->PathTranslated)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, "PATH_INFO=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @EmptyString)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"SCRIPT_NAME=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @EmptyString)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"REQUEST_LINE=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, pRequest->ClientURI.Url)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"QUERY_STRING=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, pRequest->ClientURI.QueryString)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"SERVER_PROTOCOL=")
	' TODO Указать правильную версию
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @HttpVersion11)
	
	' TODO Указать правильный порт
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"SERVER_PORT=80")
	REM lstrcat(wStart, @pWebSite->HostName)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"GATEWAY_INTERFACE=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"CGI/1.1")
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"REMOTE_ADDR=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @EmptyString)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @"REMOTE_HOST=")
	ArrayStringWriter_NonVirtualWriteString(pIWriter, @EmptyString)
	
	ArrayStringWriter_NonVirtualWriteString(pIWriter, "REQUEST_METHOD=")
	Scope
		Dim HttpMethod As WString Ptr = HttpMethodToString(pRequest->HttpMethod, 0)
		ArrayStringWriter_NonVirtualWriteString(pIWriter, HttpMethod)
	End Scope
	
	For i As Integer = 0 To WebRequest.RequestHeaderMaximum - 1
		
		ArrayStringWriter_NonVirtualWriteString(pIWriter, KnownRequestCgiHeaderToString(i, 0))
		ArrayStringWriter_NonVirtualWriteChar(pIWriter, Characters.EqualsSign)
		
		If pRequest->RequestHeaders(i) <> 0 Then
			ArrayStringWriter_NonVirtualWriteString(pIWriter, pRequest->RequestHeaders(i))
		End If
		
	Next
	
	ArrayStringWriter_NonVirtualWriteChar(pIWriter, Characters.NullChar)
	
	Dim lpflOldProtect As DWORD = Any
	If VirtualProtect(pEnvironmentBlock, MaxEnvironmentBlockBufferLength, PAGE_READONLY, @lpflOldProtect) = 0 Then
		Dim dwError As DWORD = GetLastError()
	End If
	
	Return pEnvironmentBlock
End Function
