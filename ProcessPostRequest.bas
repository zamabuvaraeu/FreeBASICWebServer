#include "ProcessPostRequest.bi"
#include "HttpConst.bi"
#include "WriteHttpError.bi"
#include "Mime.bi"
#include "WebUtils.bi"
#include "CharacterConstants.bi"
#include "ProcessCgiRequest.bi"
#include "ProcessDllRequest.bi"
#include "SafeHandle.bi"

Function ProcessPostRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pIWebSite As IWebSite Ptr, _
		ByVal pIClientReader As IHttpReader Ptr, _
		ByVal pIRequestedFile As IRequestedFile Ptr _
	)As Boolean
	
	Dim PathTranslated As WString Ptr = Any
	IRequestedFile_GetPathTranslated(pIRequestedFile, @PathTranslated)
	
	Dim FileHandle As HANDLE = Any
	IRequestedFile_GetFileHandle(pIRequestedFile, @FileHandle)
	
	Dim FileExists As RequestedFileState = Any
	IRequestedFile_FileExists(pIRequestedFile, @FileExists)
	
	Select Case FileExists
		
		Case RequestedFileState.NotFound
			WriteHttpFileNotFound(pRequest, pResponse, CPtr(IBaseStream Ptr, pINetworkStream), pIWebSite)
			Return False
			
		Case RequestedFileState.Gone
			WriteHttpFileGone(pRequest, pResponse, CPtr(IBaseStream Ptr, pINetworkStream), pIWebSite)
			Return False
			
	End Select
	
	Scope
		
		Dim NeedProcessing As Boolean = Any
		
		IWebSite_NeedCgiProcessing(pIWebSite, pRequest->ClientUri.Path, @NeedProcessing)
		
		If NeedProcessing Then
			CloseHandle(FileHandle)
			Return ProcessCGIRequest(pRequest, pResponse, pINetworkStream, pIWebSite, pIClientReader, pIRequestedFile)
		End If
		
		IWebSite_NeedDllProcessing(pIWebSite, pRequest->ClientUri.Path, @NeedProcessing)
		
		If NeedProcessing Then
			CloseHandle(FileHandle)
			Return ProcessDllCgiRequest(pRequest, pResponse, pINetworkStream, pIWebSite, pIClientReader, pIRequestedFile)
		End If
		
	End Scope
	
	Dim objRequestedFile As SafeHandle = Type<SafeHandle>(FileHandle)
	
	pResponse->ResponseHeaders(HttpResponseHeaders.HeaderAllow) = @AllSupportHttpMethodsForFile
	WriteHttpNotImplemented(pRequest, pResponse, CPtr(IBaseStream Ptr, pINetworkStream), pIWebSite)
	
	Return False
End Function
