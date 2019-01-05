#include "WebResponse.bi"

#ifndef unicode
#define unicode
#endif
#include "windows.bi"

Sub InitializeWebResponse( _
		ByVal pWebResponse As WebResponse Ptr _
	)
	memset(@pWebResponse->ResponseHeaders(0), 0, WebResponse.ResponseHeaderMaximum * SizeOf(WString Ptr))
	pWebResponse->SendOnlyHeaders = False
	pWebResponse->StatusDescription = 0
	pWebResponse->ResponseZipMode = ZipModes.None
	pWebResponse->StartResponseHeadersPtr = @pWebResponse->ResponseHeaderBuffer
	pWebResponse->StatusCode = 200
	pWebResponse->Mime.ContentType = ContentTypes.Unknown
End Sub

Sub WebResponse.AddResponseHeader( _
		ByVal HeaderName As WString Ptr, _
		ByVal Value As WString Ptr _
	)
	' TODO Устранить переполнение буфера
	Dim HeaderIndex As HttpResponseHeaders = Any
	If GetKnownResponseHeader(HeaderName, @HeaderIndex) Then
		AddKnownResponseHeader(HeaderIndex, Value)
	End If
End Sub

Sub WebResponse.AddKnownResponseHeader( _
		ByVal Header As HttpResponseHeaders, _
		ByVal Value As WString Ptr _
	)
	' TODO Избежать многократного добавления заголовка
	lstrcpy(StartResponseHeadersPtr, Value)
	ResponseHeaders(Header) = StartResponseHeadersPtr
	StartResponseHeadersPtr += lstrlen(Value) + 2
End Sub

Sub WebResponse.SetStatusDescription( _
		ByVal Description As WString Ptr _
	)
	lstrcpy(StartResponseHeadersPtr, Description)
	StatusDescription = StartResponseHeadersPtr
	StartResponseHeadersPtr += lstrlen(Description) + 2
End Sub
