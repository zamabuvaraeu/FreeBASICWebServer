#ifndef REQUESTEDFILE_BI
#define REQUESTEDFILE_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"

Enum FileState
	Exist
	NotFound
	Gone
End Enum

Type RequestedFile
	Const MaxFilePathLength As Integer = 4095 + 32
	Const MaxFilePathTranslatedLength As Integer = MaxFilePathLength + 256
	
	Dim FilePath As WString * (MaxFilePathLength + 1)
	Dim PathTranslated As WString * (MaxFilePathTranslatedLength + 1)
	
	Dim FileExists As FileState
	Dim LastFileModifiedDate As FILETIME
	
	Dim FileHandle As Handle
	Dim FileDataLength As Integer
	
	Dim GZipFileHandle As Handle
	Dim GZipFileDataLength As Integer
	
	Dim DeflateFileHandle As Handle
	Dim DeflateFileDataLength As Integer
	
End Type

#endif
