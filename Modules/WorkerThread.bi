#ifndef WORKERTHREAD_BI
#define WORKERTHREAD_BI

#include once "IWebSiteCollection.bi"

Type WorkerThreadContext
	Dim hIOCompletionPort As HANDLE
	Dim hIOCompletionClosePort As HANDLE
	Dim pIWebSites As IWebSiteCollection Ptr
	Dim hThread As HANDLE
	Dim ThreadId As DWORD
End Type

Declare Function WorkerThread( _
	ByVal lpParam As LPVOID _
)As DWORD

Type CloserThreadContext
	Dim hIOCompletionClosePort As HANDLE
	Dim hThread As HANDLE
	Dim ThreadId As DWORD
End Type

Declare Function CloserThread( _
	ByVal lpParam As LPVOID _
)As DWORD

#endif
