#include once "HeapOnArray.bi"

Sub MyHeapCreate(ByVal hHeap As Any Ptr)
	For i As Integer = 0 To MyHeapSize - 1 Step SizeOf(HeapThreadParam)
		Dim param As HeapThreadParam Ptr = CPtr(HeapThreadParam Ptr, hHeap + i)
		param->IsUsed = False
	Next
End Sub

Sub MyHeapDestroy(ByVal hHeap As Any Ptr)
	For i As Integer = 0 To MyHeapSize - 1 Step SizeOf(HeapThreadParam)
		Dim param As HeapThreadParam Ptr = CPtr(HeapThreadParam Ptr, hHeap + i)
		If param->IsUsed Then
			CloseSocketConnection(Param->param.ClientSocket)
			WaitForSingleObject(Param->param.hThread, INFINITE)
		End If
	Next
End Sub

Function MyHeapAlloc(ByVal hHeap As Any Ptr)As ThreadParam Ptr
	For i As Integer = 0 To MyHeapSize - 1 Step SizeOf(HeapThreadParam)
		Dim param As HeapThreadParam Ptr = CPtr(HeapThreadParam Ptr, hHeap + i)
		If param->IsUsed = False Then
			param->IsUsed = True
			Return @param->param
		End If
	Next
	Return 0
End Function

Sub MyHeapFree(ByVal hMem As ThreadParam Ptr)
	CPtr(HeapThreadParam Ptr, hMem - SizeOf(Boolean))->IsUsed = False
End Sub
