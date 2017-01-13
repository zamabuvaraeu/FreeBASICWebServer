#include once "WebUtils.bi"
#include once "Extensions.bi"
#include once "HttpConst.bi"
#include once "Network.bi"
#include once "URI.bi"

Sub UrlDecode(ByVal Buffer As WString Ptr, ByVal strUrl As WString Ptr)
	' Расшифровываем url-кодировку %XY
	Dim iAcc As UInteger = 0
	Dim iHex As UInteger = 0
	Dim j As Integer = 0
	
	Dim DecodedBytes As ZString * (URI.MaxUrlLength + 1) = Any
	
	For i As Integer = 0 To lstrlen(strUrl) - 1
		Dim c As UInteger = strUrl[i]
		If iHex <> 0 Then
			' 0 = 30 = 48 = 0
			' 1 = 31 = 49 = 1
			' 2 = 32 = 50 = 2
			' 3 = 33 = 51 = 3
			' 4 = 34 = 52 = 4
			' 5 = 35 = 53 = 5
			' 6 = 36 = 54 = 6
			' 7 = 37 = 55 = 7
			' 8 = 38 = 56 = 8
			' 9 = 39 = 57 = 9
			' A = 41 = 65 = 10
			' B = 42 = 66 = 11
			' C = 43 = 67 = 12
			' D = 44 = 68 = 13
			' E = 45 = 69 = 14
			' F = 46 = 70 = 15
			iHex += 1 ' раскодировать
			iAcc *= 16
			Select Case c
				Case &h30, &h31, &h32, &h33, &h34, &h35, &h36, &h37, &h38, &h39
					iAcc += c - &h30 ' 48
				Case &h41, &h42, &h43, &h44, &h45, &h46 ' Коды ABCDEF
					iAcc += c - &h37 ' 55
				Case &h61, &h62, &h63, &h64, &h65, &h66 ' Коды abcdef
					iAcc += c - &h57 ' 87
			End Select
			
			If iHex = 3 Then
				c = iAcc
				iAcc = 0
				iHex = 0
			End if
		End if
		If c = &h25 Then '37 % hex code coming?
			iHex = 1
			iAcc = 0
		End if
		If iHex = 0 Then
			DecodedBytes[j] = c
			j += 1
		End If
	Next
	' Завершающий ноль
	DecodedBytes[j] = 0
	' Преобразовать
	MultiByteToWideChar(CP_UTF8, 0, @DecodedBytes, -1, Buffer, URI.MaxUrlLength)
End Sub

Sub GetSafeString(ByVal Buffer As WString Ptr, ByVal strSafe As WString Ptr)
	Dim Counter As Integer = 0
	For i As Integer = 0 To lstrlen(strSafe) - 1
		Dim Number As Integer = strSafe[i]
		Select Case Number
			Case 34 ' "
				' &quot;
				Buffer[Counter] = 38			' &
				Buffer[Counter + 1] = &h71	' q
				Buffer[Counter + 2] = &h75	' u
				Buffer[Counter + 3] = &h6f	' o
				Buffer[Counter + 4] = &h74	' t
				Buffer[Counter + 5] = &h3b	' ;
				Counter += 6
			Case 38 ' &
				' &amp;
				Buffer[Counter] = 38			' &
				Buffer[Counter + 1] = &h61			' a
				Buffer[Counter + 2] = &h6d			' m
				Buffer[Counter + 3] = &h70			' p
				Buffer[Counter + 4] = &h3b			' ;
				Counter += 5
			Case 39 ' '
				' &apos;
				Buffer[Counter] = 38			' &
				Buffer[Counter + 1] = &h61			' a
				Buffer[Counter + 2] = &h70			' p
				Buffer[Counter + 3] = &h6f			' o
				Buffer[Counter + 4] = &h73			' s
				Buffer[Counter + 5] = &h3b	' ;
				Counter += 6
			Case 60 ' <
				' &lt;
				Buffer[Counter] = 38			' &
				Buffer[Counter + 1] = &h6c			' l
				Buffer[Counter + 2] = &h74			' t
				Buffer[Counter + 3] = &h3b	' ;
				Counter += 4
			Case 62 ' >
				' &gt;
				Buffer[Counter] = 38			' &
				Buffer[Counter + 1] = &h67			' g
				Buffer[Counter + 2] = &h74			' t
				Buffer[Counter + 3] = &h3b	' ;
				Counter += 4
			Case Else
				Buffer[Counter] = Number
				Counter += 1
		End Select
	Next
	' Завершающий нулевой символ
	Buffer[Counter] = 0
End Sub

Function GetDocumentCharset(ByVal b As UByte Ptr)As DocumentCharsets
	If b[0] = 239 AndAlso b[1] = 187 AndAlso b[2] = 191 Then
		Return DocumentCharsets.Utf8BOM
	End If
	If b[0] = 255 AndAlso b[1] = 254 Then
		Return DocumentCharsets.Utf16LE
	End If
	If b[0] = 254 AndAlso b[1] = 255 Then
		Return DocumentCharsets.Utf16BE
	End If
	Return DocumentCharsets.ASCII
End Function

Sub GetHttpDate(ByVal Buffer As WString Ptr, ByVal dt As SYSTEMTIME Ptr)
	' Tue, 15 Nov 1994 12:45:26 GMT
	Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, dt, @DateFormatString, Buffer, 31) - 1
	GetTimeFormat(LOCALE_INVARIANT, 0, dt, @TimeFormatString, @Buffer[dtBufferLength], 31 - dtBufferLength)
End Sub

Sub GetHttpDate(ByVal Buffer As WString Ptr)
	Dim dt As SYSTEMTIME = Any
	GetSystemTime(@dt)
	GetHttpDate(Buffer, @dt)
End Sub

Function FormatErrorMessageBody(ByVal Buffer As WString Ptr, ByVal StatusCode As Integer, ByVal VirtualPath As WString Ptr, ByVal strMessage As WString Ptr)As LongInt
	Dim strStatusCode As WString * 8 = Any
	itow(StatusCode, @strStatusCode, 10) ' Число в строку
	
	Dim desc As WString * 32 = Any
	GetStatusDescription(@desc, statusCode)
	
	lstrcpy(Buffer, HttpErrorHead1)
	lstrcat(Buffer, @desc) ' тег <title>
	lstrcat(Buffer, HttpErrorHead2)
	
	lstrcat(Buffer, HttpErrorBody1)
	
	' Заголовок <h1>
	If statusCode >= 500 Then
		lstrcat(Buffer, @ServerErrorString)
	Else
		lstrcat(Buffer, @ClientErrorString)
	End If
	
	lstrcat(Buffer, HttpErrorBody2)
	' Имя приложения в заголовке <h1>
	lstrcat(Buffer, VirtualPath)
	lstrcat(Buffer, HttpErrorBody3)
	' Код статуса в заголовке <h2>
	lstrcat(Buffer, @strStatusCode)
	lstrcat(Buffer, HttpErrorBody4)
	' Описание ошибки в заголовке <h2>
	lstrcat(Buffer, desc)
	lstrcat(Buffer, HttpErrorBody5)
	' Текст сообщения между <p></p>
	lstrcat(Buffer, strMessage)
	lstrcat(Buffer, HttpErrorBody6)
	Return lstrlen(Buffer)
End Function

Sub InitializeState(ByVal state As ReadHeadersResult Ptr)
	memset(@state->RequestHeaders(0), 0, ReadHeadersResult.RequestHeaderMaximum * SizeOf(WString Ptr))
	memset(@state->ResponseHeaders(0), 0, ReadHeadersResult.ResponseHeaderMaximum * SizeOf(WString Ptr))
	With *state
		.KeepAlive = False
		.SendOnlyHeaders = False
		.HttpVersion = HttpVersions.Http11
		.EndHeadersOffset = 0
		.HeaderBytesLength = 0
		.RequestHeaderBufferLength = 0
		.StatusDescription = 0
		.URI.Url = 0
		.URI.QueryString = 0
		.StartResponseHeadersPtr = @state->ResponseHeaderBuffer
	End With
End Sub

Function FindCrLfA(ByVal Buffer As ZString Ptr, ByVal Start As Integer, ByVal BufferLength As Integer)As Integer
	For i As Integer = Start To BufferLength - 2 ' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
		If Buffer[i] = 13 AndAlso Buffer[i + 1] = 10 Then
			Return i
		End If
	Next
	Return -1
End Function

Function FindCrLfW(ByVal Buffer As WString Ptr, ByVal Start As Integer, ByVal BufferLength As Integer)As Integer
	For i As Integer = Start To BufferLength - 2 ' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
		If Buffer[i] = 13 AndAlso Buffer[i + 1] = 10 Then
			Return i
		End If
	Next
	Return -1
End Function

Sub SendReceiveData(ByVal OutSock As SOCKET, ByVal InSock As SOCKET)
	' Читать данные из входящего сокета, отправлять на исходящий
	Const MaxBytesCount As Integer = 20 * 4096
	Dim ReceiveBuffer As ZString * (MaxBytesCount) = Any
	
	' Получаем данные
	Dim intReceivedBytesCount As Integer = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
	Do
		Select Case intReceivedBytesCount
			Case SOCKET_ERROR
				' Недействительное ответное сообщение от сервера
				' state->StatusCode = 502
				' WriteHttpError(state, ClientSocket, @HttpError504GatewayTimeout, @www->VirtualPath, hOutput)
				Exit Sub
			Case 0
				Exit Sub
			Case Else
				' Отправить данные
				If send(OutSock, ReceiveBuffer, intReceivedBytesCount, 0) = SOCKET_ERROR Then
					Exit Sub
				End If
				intReceivedBytesCount = recv(InSock, ReceiveBuffer, MaxBytesCount, 0)
		End Select
	Loop
End Sub

Function SendReceiveDataThreadProc(ByVal lpParam As LPVOID)As DWORD
	Dim CSS As ClientServerSocket Ptr = CPtr(ClientServerSocket Ptr, lpParam)
	SendReceiveData(CSS->OutSock, CSS->InSock)
	
	CloseSocketConnection(CSS->OutSock)
	CloseHandle(CSS->hThread)
	Return 0
End Function
