#ifndef WEBSERVER_BI
#define WEBSERVER_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\winsock2.bi"
#include once "HeapOnArray.bi"

Type WebServer
	Dim ExeDir As WString * (MAX_PATH + 1)
	Dim LogDir As WString * (MAX_PATH + 1)
	Dim ListenSocket As SOCKET
	Dim hHeap As ZString * MyHeapSize
End Type

Declare Function InitializeWebServer( _
	ByVal pWebServer As WebServer Ptr _
)As Integer

Declare Sub UninitializeWebServer( _
	ByVal pWebServer As WebServer Ptr _
)

Declare Function WebServerMainLoop( _
	ByVal lpParam As LPVOID _
)As DWORD

#endif
