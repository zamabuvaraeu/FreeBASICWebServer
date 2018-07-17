#include "RequestedFile.bi"

Function RequestedFile.Remove()As Boolean
	' TODO Узнать код ошибки и отправить его клиенту
	If DeleteFile(@pWebSite->PathTranslated) <> 0 Then
		' Удалить возможные заголовочные файлы
		Dim sExtHeadersFile As WString * (WebSite.MaxFilePathTranslatedLength + 1) = Any
		lstrcpy(@sExtHeadersFile, @pWebSite->PathTranslated)
		lstrcat(@sExtHeadersFile, @HeadersExtensionString)
		DeleteFile(@sExtHeadersFile)
		
		' Создать файл «.410», показывающий, что файл был удалён
		lstrcpy(@sExtHeadersFile, @pWebSite->PathTranslated)
		lstrcat(@sExtHeadersFile, @FileGoneExtension)
		Dim hRequestedFile As HANDLE = CreateFile(@sExtHeadersFile, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL)
		CloseHandle(hRequestedFile)
		
		Return True
	Else
		Return False
	End If
End Function

Type SafeMemoryMap
	Declare Constructor(ByVal pMemoryMap As Any Ptr)
	Declare Destructor()
	Dim MemoryMapPointer As Any Ptr
End Type

Constructor SafeMemoryMap(ByVal pMemoryMap As Any Ptr)
	#if __FB_DEBUG__ <> 0
		Print "Захватываю указатель на данные отображения hFileMap"
	#endif
	MemoryMapPointer = pMemoryMap
End Constructor

Destructor SafeMemoryMap()
	#if __FB_DEBUG__ <> 0
		Print "Выгружаю отображение из памяти hFileMap"
	#endif
	If MemoryMapPointer <> 0 Then
		UnmapViewOfFile(MemoryMapPointer)
	End If
End Destructor
