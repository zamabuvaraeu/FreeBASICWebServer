#include once "ProcessTraceRequest.bi"
#include once "Mime.bi"

Function ProcessTraceRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As WebSite Ptr, _
		ByVal fileExtention As WString Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal hRequestedFile As Handle _
	)As Boolean
	
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaderIndices.HeaderContentType) = ContentTypeToString(ContentTypes.MessageHttp)
	
	Dim ContentLength As Integer = pClientReader->Start - 2
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + StreamSocketReader.MaxBufferLength) = Any
	Dim HeadersLength As Integer = pState->AllResponseHeadersToBytes(@SendBuffer, ContentLength)
	
	RtlCopyMemory(@SendBuffer + HeadersLength, @pClientReader->Buffer, ContentLength)
	
	If send(ClientSocket, @SendBuffer, HeadersLength + ContentLength, 0) = SOCKET_ERROR Then
		Return False
	End If
	
	Return True
End Function
