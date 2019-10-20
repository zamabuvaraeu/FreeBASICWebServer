#include "InitializeVirtualTables.bi"
#include "ArrayStringWriter.bi"
#include "ClientRequest.bi"
#include "Configuration.bi"
#include "HttpReader.bi"
#include "NetworkStream.bi"
#include "RequestedFile.bi"
#include "ServerResponse.bi"
#include "ServerState.bi"
#include "WebServer.bi"
#include "WebSite.bi"

Sub InitializeVirtualTables()
	
	InitializeArrayStringWriterVirtualTable()
	InitializeClientRequestVirtualTable()
	InitializeConfigurationVirtualTable()
	InitializeHttpReaderVirtualTable()
	InitializeNetworkStreamVirtualTable()
	InitializeRequestedFileVirtualTable()
	InitializeServerResponseVirtualTable()
	InitializeServerStateVirtualTable()
	InitializeWebServerVirtualTable()
	InitializeWebSiteVirtualTable()
	
End Sub
