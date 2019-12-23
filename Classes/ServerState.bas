﻿#include "ServerState.bi"
#include "WebUtils.bi"

Extern IID_IUnknown_WithoutMinGW As Const IID

' TODO Заполнить виртуальную таблицу GlobalServerStateVirtualTable
Dim Shared GlobalServerStateVirtualTable As IServerStateVirtualTable = Type( _
	Type<IUnknownVtbl>( _
		NULL, _
		NULL, _
		NULL _
	), _
	@ServerStateDllCgiGetRequestHeader, _
	@ServerStateDllCgiGetHttpMethod, _
	@ServerStateDllCgiGetHttpVersion, _
	@ServerStateDllCgiSetStatusCode, _
	NULL, _
	@ServerStateDllCgiSetStatusDescription, _
	NULL, _
	@ServerStateDllCgiSetResponseHeader, _
	@ServerStateDllCgiWriteData, _
	@ServerStateDllCgiReadData, _
	@ServerStateDllCgiGetHtmlSafeString _
)

Function ServerStateDllCgiGetRequestHeader( _
		ByVal objState As ServerState Ptr, _
		ByVal Value As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HeaderIndex As HttpRequestHeaders _
	)As Integer
	
	Dim pHeader As WString Ptr = Any
	IClientRequest_GetHttpHeader(objState->pIRequest, HeaderIndex, @pHeader)
	
	Dim HeaderLength As Integer = lstrlen(pHeader)
	
	If HeaderLength > BufferLength Then
		SetLastError(ERROR_INSUFFICIENT_BUFFER)
		Return -1
	End If
	
	lstrcpy(Value, pHeader)
	
	SetLastError(ERROR_SUCCESS)
	
	Return HeaderLength
	
End Function

Function ServerStateDllCgiGetHttpMethod( _
		ByVal objState As ServerState Ptr _
	)As HttpMethods
	
	Dim HttpMethod As HttpMethods = Any
	IClientRequest_GetHttpMethod(objState->pIRequest, @HttpMethod)
	
	SetLastError(ERROR_SUCCESS)
	
	Return HttpMethod
	
End Function

Function ServerStateDllCgiGetHttpVersion( _
		ByVal objState As ServerState Ptr _
	)As HttpVersions
	
	Dim HttpVersion As HttpVersions = Any
	IClientRequest_GetHttpVersion(objState->pIRequest, @HttpVersion)
	
	SetLastError(ERROR_SUCCESS)
	
	Return HttpVersion
	
End Function

Sub ServerStateDllCgiSetStatusCode( _
		ByVal objState As ServerState Ptr, _
		ByVal Code As Integer _
	)
	
	IServerResponse_SetStatusCode(objState->pIResponse, Code)
	
End Sub

Sub ServerStateDllCgiSetStatusDescription( _
		ByVal objState As ServerState Ptr, _
		ByVal Description As WString Ptr _
	)
	
	' TODO Устранить потенциальное переполнение буфера
	IServerResponse_SetStatusDescription(objState->pIResponse, Description)
	
End Sub

Sub ServerStateDllCgiSetResponseHeader( _
		ByVal objState As ServerState Ptr, _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)
	
	' TODO Устранить потенциальное переполнение буфера
	IServerResponse_AddKnownResponseHeader(objState->pIResponse, HeaderIndex, Value)
	
End Sub

Function ServerStateDllCgiWriteData( _
		ByVal objState As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BytesCount As Integer _
	)As Boolean
	
	If BytesCount > MaxClientBufferLength - objState->BufferLength Then
		SetLastError(ERROR_BUFFER_OVERFLOW)
		Return False
	End If
	
	RtlCopyMemory(objState->ClientBuffer, Buffer, BytesCount)
	objState->BufferLength += BytesCount
	SetLastError(ERROR_SUCCESS)
	
	Return True
	
End Function

Function ServerStateDllCgiReadData( _
		ByVal objState As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BufferLength As Integer, _
		ByVal ReadedBytesCount As Integer Ptr _
	)As Boolean
	
	Return False
	
End Function

Function ServerStateDllCgiGetHtmlSafeString( _
		ByVal objState As IServerState Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal HtmlSafeLength As Integer Ptr _
	)As Boolean
	
	Return GetHtmlSafeString(Buffer, BufferLength, HtmlSafe, HtmlSafeLength)
	
End Function

Sub InitializeServerState( _
		ByVal objServerState As ServerState Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pIRequest As IClientRequest Ptr, _
		ByVal pIResponse As IServerResponse Ptr, _
		ByVal pIWebSite As IWebSite Ptr, _
		ByVal hMapFile As HANDLE, _
		ByVal ClientBuffer As Any Ptr _
	)
	
	objServerState->pVirtualTable = @GlobalServerStateVirtualTable
	objServerState->ReferenceCounter = 1
	objServerState->pStream = pStream
	objServerState->pIRequest = pIRequest
	objServerState->pIResponse = pIResponse
	objServerState->pIWebSite = pIWebSite
	objServerState->hMapFile = hMapFile
	objServerState->ClientBuffer = ClientBuffer
	objServerState->BufferLength = 0
	objServerState->ExistsInStack = True
	
End Sub
