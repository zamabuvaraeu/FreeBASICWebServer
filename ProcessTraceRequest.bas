#include "ProcessTraceRequest.bi"
#include "Mime.bi"
#include "WebUtils.bi"
#include "HttpReader.bi"

Function ProcessTraceRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pIWebSite As IWebSite Ptr, _
		ByVal pIClientReader As IHttpReader Ptr, _
		ByVal pIRequestedFile As IRequestedFile Ptr _
	)As Boolean
	
	pResponse->Mime.ContentType = ContentTypes.MessageHttp
	pResponse->Mime.IsTextFormat = True
	pResponse->Mime.Charset = DocumentCharsets.ASCII
	
	Dim pRequestedBytes As UByte  Ptr = Any
	Dim RequestedBytesLength As Integer = Any
	
	IHttpReader_GetRequestedBytes(pIClientReader, @RequestedBytesLength, @pRequestedBytes)
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + HttpReader.MaxBufferLength) = Any
	Dim HeadersLength As Integer = AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, RequestedBytesLength)
	
	RtlCopyMemory(@SendBuffer[HeadersLength], pRequestedBytes, RequestedBytesLength)
	
	Dim WritedBytes As Integer = Any
	Dim hr As HRESULT = INetworkStream_Write(pINetworkStream, _
		@SendBuffer, 0, HeadersLength + RequestedBytesLength, @WritedBytes _
	)
	
	If FAILED(hr) Then
		Return False
	End If
	
	Return True
End Function
