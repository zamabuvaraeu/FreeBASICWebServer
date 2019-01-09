#include "ProcessOptionsRequest.bi"
#include "WebUtils.bi"

Function ProcessOptionsRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	' Если звёздочка, то ко всему серверу
	If lstrcmp(pRequest->ClientURI.Url, "*") = 0 Then
		pResponse->ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethods
	Else
		' К конкретному ресурсу
		' Проверка на CGI
		If NeedCGIProcessing(pRequest->ClientUri.Path) Then
			pResponse->ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForScript
		Else
			' Проверка на dll-cgi
			If NeedDLLProcessing(pRequest->ClientUri.Path) Then
				pResponse->ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForScript
			Else
				pResponse->ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForFile
			End If
		End If
	End If
	
	pResponse->StatusCode = 204
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	' If send(ClientSocket, @SendBuffer, AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, 0), 0) = SOCKET_ERROR Then
		' Return False
	' End If
	Dim WritedBytes As Integer = Any
	Dim hr As HRESULT = pINetworkStream->pVirtualTable->InheritedTable.Write(pINetworkStream, _
		@SendBuffer, 0, AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, 0), @WritedBytes _
	)
	If FAILED(hr) Then
		Return False
	End If
	
	Return True
End Function
