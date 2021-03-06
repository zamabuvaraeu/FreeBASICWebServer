#include once "ServerState.bi"
#include once "WebUtils.bi"

Extern GlobalServerStateVirtualTable As Const IServerStateVirtualTable

Function ServerStateDllCgiGetRequestHeader( _
		ByVal this As ServerState Ptr, _
		ByVal Value As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HeaderIndex As HttpRequestHeaders _
	)As Integer
	
	Dim pHeader As WString Ptr = Any
	IClientRequest_GetHttpHeader(this->pIRequest, HeaderIndex, @pHeader)
	
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
		ByVal this As ServerState Ptr _
	)As HttpMethods
	
	Dim HttpMethod As HttpMethods = Any
	IClientRequest_GetHttpMethod(this->pIRequest, @HttpMethod)
	
	SetLastError(ERROR_SUCCESS)
	
	Return HttpMethod
	
End Function

Function ServerStateDllCgiGetHttpVersion( _
		ByVal this As ServerState Ptr _
	)As HttpVersions
	
	Dim HttpVersion As HttpVersions = Any
	IClientRequest_GetHttpVersion(this->pIRequest, @HttpVersion)
	
	SetLastError(ERROR_SUCCESS)
	
	Return HttpVersion
	
End Function

Sub ServerStateDllCgiSetStatusCode( _
		ByVal this As ServerState Ptr, _
		ByVal Code As Integer _
	)
	
	IServerResponse_SetStatusCode(this->pIResponse, Code)
	
End Sub

Sub ServerStateDllCgiSetStatusDescription( _
		ByVal this As ServerState Ptr, _
		ByVal Description As WString Ptr _
	)
	
	' TODO ��������� ������������� ������������ ������
	IServerResponse_SetStatusDescription(this->pIResponse, Description)
	
End Sub

Sub ServerStateDllCgiSetResponseHeader( _
		ByVal this As ServerState Ptr, _
		ByVal HeaderIndex As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)
	
	' TODO ��������� ������������� ������������ ������
	IServerResponse_AddKnownResponseHeader(this->pIResponse, HeaderIndex, Value)
	
End Sub

Function ServerStateDllCgiWriteData( _
		ByVal this As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BytesCount As Integer _
	)As Boolean
	
	If BytesCount > MaxClientBufferLength - this->BufferLength Then
		SetLastError(ERROR_BUFFER_OVERFLOW)
		Return False
	End If
	
	RtlCopyMemory(this->ClientBuffer, Buffer, BytesCount)
	this->BufferLength += BytesCount
	SetLastError(ERROR_SUCCESS)
	
	Return True
	
End Function

Function ServerStateDllCgiReadData( _
		ByVal this As ServerState Ptr, _
		ByVal Buffer As Any Ptr, _
		ByVal BufferLength As Integer, _
		ByVal ReadedBytesCount As Integer Ptr _
	)As Boolean
	
	Return False
	
End Function

Function ServerStateDllCgiGetHtmlSafeString( _
		ByVal this As IServerState Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal HtmlSafeLength As Integer Ptr _
	)As Boolean
	
	Return GetHtmlSafeString(Buffer, BufferLength, HtmlSafe, HtmlSafeLength)
	
End Function

Sub InitializeServerState( _
		ByVal this As ServerState Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pIRequest As IClientRequest Ptr, _
		ByVal pIResponse As IServerResponse Ptr, _
		ByVal pIWebSite As IWebSite Ptr, _
		ByVal hMapFile As HANDLE, _
		ByVal ClientBuffer As Any Ptr _
	)
	
	this->lpVtbl = @GlobalServerStateVirtualTable
	this->ReferenceCounter = 1
	this->pStream = pStream
	this->pIRequest = pIRequest
	this->pIResponse = pIResponse
	this->pIWebSite = pIWebSite
	this->hMapFile = hMapFile
	this->ClientBuffer = ClientBuffer
	this->BufferLength = 0
	this->ExistsInStack = True
	
End Sub

' TODO ��������� ����������� ������� GlobalServerStateVirtualTable
Dim GlobalServerStateVirtualTable As Const IServerStateVirtualTable = Type( _
	NULL, _
	NULL, _
	NULL, _
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
