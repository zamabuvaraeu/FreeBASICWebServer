#include "Main.bi"
#include "WebServer.bi"
#include "InitializeVirtualTables.bi"

#ifdef withoutruntime
Function EntryPoint Alias "EntryPoint"()As Integer
#endif
	InitializeVirtualTables()
	
	Dim objWebServer As WebServer = Any
	Dim pIWebServer As IWebServer Ptr = CPtr(IWebServer Ptr, _
		New(@objWebServer) WebServer() _
	)
	
	pIWebServer->pVirtualTable->StartServer(pIWebServer)
	
	pIWebServer->pVirtualTable->StopServer(pIWebServer)

#ifdef withoutruntime
	Return 0
End Function
#else
	End(0)
#endif
