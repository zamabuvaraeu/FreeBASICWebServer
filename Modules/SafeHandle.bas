#include once "SafeHandle.bi"

Constructor SafeHandle(ByVal h As HANDLE)
	WinAPIHandle = h
End Constructor

Destructor SafeHandle()
	If WinAPIHandle <> INVALID_HANDLE_VALUE Then
		CloseHandle(WinAPIHandle)
	End If
End Destructor
