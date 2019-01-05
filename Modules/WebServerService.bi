#ifndef WEBSERVERSERVICE_BI
#define WEBSERVERSERVICE_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "WebServer.bi"

Const ServiceName = "Station922"

Type ServiceContext
	Dim ServiceStatusHandle As SERVICE_STATUS_HANDLE
	Dim ServiceStatus As SERVICE_STATUS
	'Dim ServiceStopEvent As HANDLE
	Dim ServiceCheckPoint As DWORD
	Dim WebServer As WebServer
End Type

Declare Sub ReportSvcStatus( _
	ByVal lpContext As ServiceContext Ptr, _
	ByVal dwCurrentState As DWORD, _
	ByVal dwWin32ExitCode As DWORD, _
	ByVal dwWaitHint As DWORD _
)

Declare Sub SvcMain( _
	ByVal dwNumServicesArgs As DWORD, _
	ByVal lpServiceArgVectors As LPWSTR Ptr _
)

Declare Function SvcCtrlHandlerEx( _
	ByVal dwCtrl As DWORD, _
	ByVal dwEventType As DWORD, _
	ByVal lpEventData As LPVOID, _
	ByVal lpContext As LPVOID _
)As DWORD

Declare Function ServiceProc( _
	ByVal lpParam As LPVOID _
)As DWORD

#endif
