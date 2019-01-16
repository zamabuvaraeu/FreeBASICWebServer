#include "Main.bi"
#include "WebServer.bi"
#include "InitializeVirtualTables.bi"
#include "WithoutRuntime.bi"

BeginMainFunction
	InitializeVirtualTables()
	
	Dim objWebServer As WebServer = Any
	Dim pIWebServer As IWebServer Ptr = InitializeWebServerOfIWebServer(@objWebServer)
	
	WebServer_NonVirtualStartServer(pIWebServer)
	
	WebServer_NonVirtualStopServer(pIWebServer)
	
	RetCode(0)
	
EndMainFunction
