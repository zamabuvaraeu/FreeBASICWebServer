#ifndef unicode
#define unicode
#endif
#include once "AppendingBuffer.bi"
#include once "windows.bi"

Const NewLineString = !"\r\n"

Sub AppendingBuffer.AppendWLine()
	lstrcpy(Buffer + BufferLength, @NewLineString)
	BufferLength += 2
End Sub

Sub AppendingBuffer.AppendWLine(ByVal w As WString Ptr)
	AppendWString(w)
	AppendWString(@NewLineString, 2)
End Sub

Sub AppendingBuffer.AppendWLine(ByVal w As WString Ptr, ByVal Length As Integer)
	AppendWString(w, Length)
	AppendWString(@NewLineString, 2)
End Sub

Sub AppendingBuffer.AppendWString(ByVal w As WString Ptr)
	lstrcpy(Buffer + BufferLength, w)
	BufferLength += lstrlen(w)
End Sub

Sub AppendingBuffer.AppendWString(ByVal w As WString Ptr, ByVal Length As Integer)
	lstrcpy(Buffer + BufferLength, w)
	BufferLength += Length
End Sub

Sub AppendingBuffer.AppendWChar(ByVal wc As Integer)
	Buffer[BufferLength] = wc
	Buffer[BufferLength + 1] = 0
	BufferLength += 1
End Sub
