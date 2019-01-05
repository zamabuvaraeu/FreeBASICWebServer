#include "StreamSocketReader.bi"

Sub InitializeStreamSocketReader( _
		ByVal pReader As StreamSocketReader Ptr _
	)
	pReader->Buffer[0] = 0
	pReader->BufferLength = 0
	pReader->Start = 0
End Sub

Function StreamSocketReader.ReadLine( _
		ByVal wLine As WString Ptr, _
		ByVal LineBufferLength As Integer, _
		ByVal pLineLength As Integer Ptr _
	)As Boolean
	
	Dim CrLfIndex As Integer = Any
	
	Do While FindCrLfA(@CrLfIndex) = False
		
		If BufferLength >= MaxBufferLength Then
			wLine[0] = 0
			SetLastError(BufferOverflowError)
			Return -1
		End If
		
		Dim ReceivedBytesCount As Integer = Any
		' recv(ClientSocket, @Buffer[BufferLength], MaxBufferLength - BufferLength, 0)
		pStream->pVirtualTable->Read(pStream, @Buffer, BufferLength, MaxBufferLength - BufferLength, @ReceivedBytesCount)
		
		Select Case ReceivedBytesCount
			
			Case -1
				wLine[0] = 0
				Buffer[0] = 0
				SetLastError(SocketError)
				Return False
				
			Case 0
				wLine[0] = 0
				Buffer[BufferLength] = 0
				SetLastError(ClientClosedSocketError)
				Return False
				
			Case Else
				BufferLength += ReceivedBytesCount
				Buffer[BufferLength] = 0
				
		End Select
		
	Loop
	
	' vbCrLf найдено, получить строку
	
	' На место CrLf записываем ноль
	' Теперь валидная строка для винапи
	Buffer[CrLfIndex] = 0
	
	' Преобразуем utf-8 в WString
	' Нулевой символ будет записан в буфер автоматически
	' Длина строки будет указывать на следующий символ после нулевого
	*pLineLength = MultiByteToWideChar(CP_UTF8, 0, @Buffer[Start], -1, wLine, LineBufferLength) - 1
	' Вернуть символ на место
	Buffer[CrLfIndex] = 13
	
	' Сдвинуть конец заголовков вправо на CrLfIndex + len(vbCrLf)
	Start = CrLfIndex + 2
	
	SetLastError(ERROR_SUCCESS)
	Return True
End Function

Sub StreamSocketReader.Flush()
	If Start = 0 Then
		Exit Sub
	End If
	
	If MaxBufferLength - Start <= 0 Then
		Buffer[0] = 0
		BufferLength = 0
	Else
		RtlMoveMemory(@Buffer, @Buffer + Start, MaxBufferLength - Start + 1)
		BufferLength -= Start
	End If
	
	Start = 0
End Sub

Function StreamSocketReader.FindCrLfA( _
		ByVal pFindedIndex As Integer Ptr _
	)As Boolean
	
	' Минус 1 под Lf и минус 1, чтобы не выйти за границу
	For i As Integer = Start To BufferLength - 1 - 1
		If Buffer[i] = 13 AndAlso Buffer[i + 1] = 10 Then
			*pFindedIndex = i
			Return True
		End If
	Next
	
	*pFindedIndex = 0
	Return False
End Function
