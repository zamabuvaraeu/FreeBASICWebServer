﻿#include "ConsoleMain.bi"
#include "WebServer.bi"

#ifndef WINDOWS_SERVICE

Function ConsoleMain()As Integer
	
	Dim objWebServer As WebServer = Any
	Dim pIWebServer As IRunnable Ptr = InitializeWebServerOfIRunnable(@objWebServer)
	
	WebServer_NonVirtualRun(pIWebServer)
	
	WebServer_NonVirtualStop(pIWebServer)
	
	WebServer_NonVirtualRelease(pIWebServer)
	
	Return 0
	
End Function

#endif
