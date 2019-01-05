#ifndef WEBSERVER_BI
#define WEBSERVER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\winsock2.bi"
#include "WebSite.bi"

Type WebServer
	Dim ExeDir As WString * (MAX_PATH + 1)
	Dim LogDir As WString * (MAX_PATH + 1)
	Dim ListenSocket As SOCKET
	Dim pWebSitesArray As WebSitesArray Ptr
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
