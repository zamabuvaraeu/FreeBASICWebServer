#include once "TestMain.bi"
#include once "CreateInstance.bi"
#include once "PrintDebugInfo.bi"

Function TestMemoryAllocator()As HRESULT
	Dim pIMalloc As IMalloc Ptr = Any
	Dim hr As HRESULT = CoGetPrivateHeapMalloc(1, @pIMalloc)
	If FAILED(hr) Then
		Return hr
	End If
	
	Dim Count As Integer = 1
	Do
		Dim pMem As Any Ptr = IMalloc_Alloc(pIMalloc, 512)
		If pMem = NULL Then
			Exit Do
		End If
		Count += 1
	Loop
	
	DebugPrint(WStr(!"Allocators Count"), Count)
	
	IMalloc_Release(pIMalloc)
	
	Return S_OK
	
End Function

Function wMain()As Long
	
	
	Return 0
	
End Function
