#include once "ProcessOptionsRequest.bi"

Function ProcessOptionsRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	' Если звёздочка, то ко всему серверу
	If lstrcmp(pState->ClientRequest.ClientURI.Url, "*") = 0 Then
		pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethods
	Else
		' К конкретному ресурсу
		' Проверка на CGI
		If NeedCGIProcessing(pState->ClientRequest.ClientUri.Path) Then
			pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForScript
		Else
			' Проверка на dll-cgi
			If NeedDLLProcessing(pState->ClientRequest.ClientUri.Path) Then
				pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForScript
			Else
				pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForFile
			End If
		End If
	End If
	
	pState->ServerResponse.StatusCode = 204
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	If send(ClientSocket, @SendBuffer, pState->AllResponseHeadersToBytes(@SendBuffer, 0), 0) = SOCKET_ERROR Then
		Return False
	End If
	
	Return True
End Function
