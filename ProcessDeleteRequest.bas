#include "ProcessDeleteRequest.bi"
#include "HttpConst.bi"
#include "WriteHttpError.bi"
#include "WebUtils.bi"

Function ProcessDeleteRequest( _
		ByVal pRequest As WebRequest Ptr, _
		ByVal pResponse As WebResponse Ptr, _
		ByVal pINetworkStream As INetworkStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal pClientReader As StreamSocketReader Ptr, _
		ByVal pRequestedFile As RequestedFile Ptr _
	)As Boolean
	
	If pRequestedFile->FileHandle = INVALID_HANDLE_VALUE Then
		' TODO Проверить код ошибки через GetLastError, могут быть не только File Not Found
		Dim buf410 As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(buf410, @pRequestedFile->PathTranslated)
		lstrcat(buf410, @FileGoneExtension)
		
		Dim hFile410 As HANDLE = CreateFile(@buf410, 0, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
		If hFile410 = INVALID_HANDLE_VALUE Then
			WriteHttpFileNotFound(pRequest, pResponse, pINetworkStream, pWebSite)
		Else
			CloseHandle(hFile410)
			WriteHttpFileGone(pRequest, pResponse, pINetworkStream, pWebSite)
		End If
		Return False
	End If
	
	CloseHandle(pRequestedFile->FileHandle)
	
	' Проверка заголовка Authorization
	If HttpAuthUtil(pRequest, pResponse, pINetworkStream, pWebSite, False) = False Then
		Return False
	End If
	
	' TODO Узнать код ошибки и отправить его клиенту
	If DeleteFile(pRequestedFile->PathTranslated) <> 0 Then
		' Удалить возможные заголовочные файлы
		Dim sExtHeadersFile As WString * (RequestedFile.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(@sExtHeadersFile, @pRequestedFile->PathTranslated)
		lstrcat(@sExtHeadersFile, @HeadersExtensionString)
		DeleteFile(@sExtHeadersFile)
		
		' Создать файл «.410», показывающий, что файл был удалён
		lstrcpy(@sExtHeadersFile, pRequestedFile->PathTranslated)
		lstrcat(@sExtHeadersFile, @FileGoneExtension)
		Dim hFile As HANDLE = CreateFile( _
			@sExtHeadersFile, _
			GENERIC_WRITE, _
			0, _
			NULL, _
			CREATE_NEW, _
			FILE_ATTRIBUTE_NORMAL, _
			NULL _
		)
		CloseHandle(hFile)
	Else
		WriteHttpFileNotAvailable(pRequest, pResponse, pINetworkStream, pWebSite)
		Return False
	End If
	
	pResponse->StatusCode = 204
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	
	Dim WritedBytes As Integer = Any
	Dim hr As HRESULT = pINetworkStream->pVirtualTable->InheritedTable.Write(pINetworkStream, _
		@SendBuffer, 0, AllResponseHeadersToBytes(pRequest, pResponse, @SendBuffer, 0), @WritedBytes _
	)
	If FAILED(hr) Then
		Return False
	End If
	
	Return True
End Function
