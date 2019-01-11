#include "Main.bi"
#include "WebServer.bi"
#include "InitializeVirtualTables.bi"

Function EntryPoint Alias "EntryPoint"()As Integer
	InitializeVirtualTables()
	
	Dim objWebServer As WebServer = Any
	Dim pIWebServer As IWebServer Ptr = CPtr(IWebServer Ptr, New(@objWebServer) WebServer())
	
	pIWebServer->pVirtualTable->StartServer(pIWebServer)
	
	pIWebServer->pVirtualTable->StopServer(pIWebServer)
	
	Return 0
End Function

#if __FB_DEBUG__ <> 0
End(EntryPoint())
#endif