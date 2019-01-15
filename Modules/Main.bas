#include "Main.bi"
#include "WebServer.bi"
#include "InitializeVirtualTables.bi"

#ifdef withoutruntime
Function EntryPoint Alias "EntryPoint"()As Integer
#endif
	InitializeVirtualTables()
	
	Dim objWebServer As WebServer = Any
	Dim pIWebServer As IWebServer Ptr = InitializeWebServerOfIWebServer(@objWebServer)
	
	WebServer_NonVirtualStartServer(pIWebServer)
	
	WebServer_NonVirtualStopServer(pIWebServer)

#ifdef withoutruntime
	Return 0
End Function
#else
	End(0)
#endif
