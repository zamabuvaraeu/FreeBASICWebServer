#include "ProcessDeleteRequest.bi"
#include "HttpConst.bi"
#include "WriteHttpError.bi"
#include "WebUtils.bi"

Function ProcessDeleteRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
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
			WriteHttpFileNotFound(pState, pClientReader->pStream, pWebSite)
		Else
			CloseHandle(hFile410)
			WriteHttpFileGone(pState, pClientReader->pStream, pWebSite)
		End If
		Return False
	End If
	
	CloseHandle(pRequestedFile->FileHandle)
	
	' Проверка заголовка Authorization
	If HttpAuthUtil(pState, pClientReader->pStream, pWebSite, False) = False Then
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
		Dim hFile As HANDLE = CreateFile(@sExtHeadersFile, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL)
		CloseHandle(hFile)
	Else
		WriteHttpFileNotAvailable(pState, pClientReader->pStream, pWebSite)
		Return False
	End If
	
	pState->ServerResponse.StatusCode = 204
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	
	If send(ClientSocket, @SendBuffer, pState->AllResponseHeadersToBytes(@SendBuffer, 0), 0) = SOCKET_ERROR Then
		Return False
	End If
	
	Return True
End Function
