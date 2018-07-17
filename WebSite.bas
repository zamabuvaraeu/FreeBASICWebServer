#ifndef unicode
#define unicode
#endif

#include once "WebSite.bi"
#include once "win\shlwapi.bi"
#include once "IniConst.bi"
#include "CharConstants.bi"

Const DotDotString = ".."

Const DefaultFileNameString1 = "default.xml"
Const DefaultFileNameString2 = "default.xhtml"
Const DefaultFileNameString3 = "default.htm"
Const DefaultFileNameString4 = "default.html"
Const DefaultFileNameString5 = "index.xml"
Const DefaultFileNameString6 = "index.xhtml"
Const DefaultFileNameString7 = "index.htm"
Const DefaultFileNameString8 = "index.html"

Const MaxDefaultFileNameLength As Integer = 15

Declare Function OpenFileForReading( _
	ByVal PathTranslated As WString Ptr, _
	ByVal ForReading As FileAccess _
)As Handle

Declare Function GetDefaultFileName( _
	ByVal Buffer As WString Ptr, _
	ByVal Index As Integer _
)As Boolean

Declare Sub LoadWebSite( _
	ByVal ExeDir As WString Ptr, _
	ByVal www As WebSiteItem Ptr, _
	ByVal HostName As WString Ptr _
)

Function GetWebSitesArray( _
		ByVal ExeDir As WString Ptr, _
		ByVal ppWebSitesArray As WebSitesArray Ptr Ptr _
	)As Integer
	
	*ppWebSitesArray = 0
	
	Const SectionsLength As Integer = 32000 - 1
	Dim AllSections As WString * (SectionsLength + 1) = Any
	' Имя файла настроек программы
	Dim IniFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@IniFileName, ExeDir, @WebSitesIniFileString)
	
	Dim DefaultValue As WString * 2 = Any
	DefaultValue[0] = 0
	DefaultValue[1] = 0
	' Получить имена всех секций
	Dim Result As DWORD = GetPrivateProfileString(Null, Null, @DefaultValue, @AllSections, SectionsLength, @IniFileName)
	
	' Определить количество сайтов
	Dim WebSitesCount As Integer = 0
	
	Dim Start As Integer = 0
	Dim w As WString Ptr = Any
	Do While Start < Result
		' Получить указатель на начало строки
		w = @AllSections[Start]
		' Измерить длину строки, прибавить это к указателю + 1
		Start += lstrlen(w) + 1
		' Увеличить счётчик сайтов
		WebSitesCount += 1
		If WebSitesCount > MaxWebSitesCount Then
			Exit Do
		End If
	Loop
	
	If WebSitesCount = 0 Then
		Return 0
	End If
	
	*ppWebSitesArray = CPtr(WebSitesArray Ptr, VirtualAlloc(0, SizeOf(WebSitesArray), MEM_COMMIT Or MEM_RESERVE, PAGE_READWRITE))
	If *ppWebSitesArray = 0 Then
		Dim dwError As DWORD = GetLastError()
		Return 0
	End If
	
	(*ppWebSitesArray)->WebSitesCount = WebSitesCount
	
	' Получить имена всех секций
	Result = GetPrivateProfileString(Null, Null, @DefaultValue, @AllSections, SectionsLength, @IniFileName)
	
	' Получить конфигурацию для каждого сайта
	Start = 0
	Dim i As Integer = 0
	Do While Start < Result
		' Получить указатель на начало строки
		w = @AllSections[Start]
		LoadWebSite(ExeDir, @((*ppWebSitesArray)->WebSites(i)), w)
		' Измерить длину строки, прибавить это к указателю + 1
		Start += lstrlen(w) + 1
		i += 1
		If i > MaxWebSitesCount Then
			Exit Do
		End If
	Loop
	
	Dim lpflOldProtect As DWORD = Any
	If VirtualProtect(*ppWebSitesArray, SizeOf(WebSitesArray), PAGE_READONLY, @lpflOldProtect) = 0 Then
		Dim dwError As DWORD = GetLastError()
	End If
	
	Return WebSitesCount
End Function

Sub LoadWebSite( _
		ByVal ExeDir As WString Ptr, _
		ByVal www As WebSiteItem Ptr, _
		ByVal HostName As WString Ptr _
	)
	' Имя файла настроек программы
	Dim IniFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@IniFileName, ExeDir, @WebSitesIniFileString)
	Dim DefaultValue As WString * 2 = Any
	DefaultValue[0] = 0
	DefaultValue[1] = 0
	
	GetPrivateProfileString(HostName, @VirtualPathSectionString, @DefaultValue, @www->VirtualPath, WebSiteItem.MaxHostNameLength, IniFileName)
	GetPrivateProfileString(HostName, @PhisycalDirSectionString, @DefaultValue, @www->PhysicalDirectory, MAX_PATH, IniFileName)
	Dim Result2 As UINT = GetPrivateProfileInt(HostName, @IsMovedSectionString, 0, IniFileName)
	If Result2 = 0 Then
		www->IsMoved = False
	Else
		www->IsMoved = True
	End If
	GetPrivateProfileString(HostName, @MovedUrlSectionString, @DefaultValue, @www->MovedUrl, WebSiteItem.MaxHostNameLength, IniFileName)
	lstrcpy(@www->HostName, HostName)
End sub

Function WebSitesArray.FindSimpleWebSite( _
		ByVal www As SimpleWebSite Ptr, _
		ByVal HostName As WString Ptr _
	)As Boolean
	
	For i As Integer = 0 To WebSitesCount - 1
		If lstrcmpi(@WebSites(i).HostName, HostName) = 0 Then
			www->HostName = @WebSites(i).HostName
			www->PhysicalDirectory = @WebSites(i).PhysicalDirectory
			www->VirtualPath = @WebSites(i).VirtualPath
			www->IsMoved = WebSites(i).IsMoved
			www->MovedUrl = @WebSites(i).MovedUrl
			
			Return True
		End If
	Next
	
	www->HostName = HostName
	www->PhysicalDirectory = 0
	www->VirtualPath = @DefaultVirtualPath
	www->IsMoved = False
	www->MovedUrl = 0
	
	Return False
End Function

Function IsBadPath( _
		ByVal Path As WString Ptr _
	)As Boolean
	' TODO Звёздочка в пути допустима при методе OPTIONS
	Dim PathLen As Integer = lstrlen(Path)
	If PathLen = 0 Then
		Return True
	End If
	If Path[PathLen - 1] = &h2e Then ' .
		Return True
	End If
	For i As Integer = 0 To PathLen - 1
		Dim c As Integer = Path[i]
		Select Case c
			Case Is < 32
				Return True
			Case 34 ' "
				Return True
			Case 36 ' $
				Return True
			Case 37 ' %
				Return True
			Case 60 ' <
				Return True
			Case 62 ' >
				Return True
			Case 63 ' ?
				Return True
			Case 124 ' |
				Return True
		End Select
	Next
	If StrStr(Path, DotDotString) > 0 Then
		Return True
	End If
	Return False
End Function


Function NeedCgiProcessing( _
		ByVal Path As WString Ptr _
	)As Boolean
	
	If StrStrI(Path, "/cgi-bin/") = Path Then
		Return True
	End If
	
	Return False
End Function

Function NeedDllProcessing( _
		ByVal Path As WString Ptr _
	)As Boolean
	
	If StrStrI(Path, "/cgi-dll/") = Path Then
		Return True
	End If
	
	Return False
End Function

Sub SimpleWebSite.MapPath( _
		ByVal Buffer As WString Ptr, _
		ByVal path As WString Ptr _
	)
	lstrcpy(Buffer, PhysicalDirectory)
	Dim BufferLength As Integer = lstrlen(Buffer)
	
	' Добавить \ если там его нет
	If Buffer[BufferLength - 1] <> ReverseSolidusChar Then
		Buffer[BufferLength] = ReverseSolidusChar
		BufferLength += 1
		Buffer[BufferLength] = 0
	End If
	
	' Объединение физической директории и пути
	If lstrlen(path) <> 0 Then
		If path[0] = SolidusChar Then
			lstrcat(Buffer, @path[1])
		Else
			lstrcat(Buffer, path)
		End If
	End If
	
	' замена / на \
	For i As Integer = 0 To lstrlen(Buffer) - 1
		If Buffer[i] = SolidusChar Then
			Buffer[i] = ReverseSolidusChar
		End If
	Next
End Sub

Function SimpleWebSite.GetRequestedFile( _
		ByVal pFile As RequestedFile Ptr, _
		ByVal Path As WString Ptr, _
		ByVal ForReading As FileAccess _
	)As Boolean
	
	If Path[lstrlen(Path) - 1] <> SolidusChar Then
		' Path содержит имя конкретного файла
		lstrcpy(@pFile->FilePath, Path)														'!
		MapPath(@pFile->PathTranslated, @pFile->FilePath)											'!
		pFile->FileHandle = OpenFileForReading(@pFile->PathTranslated, ForReading)
		Return True
	Else
		' Получить имя файла по умолчанию
		Dim DefaultFilenameIndex As Integer = 0
		Dim DefaultFilename As WString * (MaxDefaultFileNameLength + 1) = Any
		
		Dim GetDefaultFileNameResult As Boolean = GetDefaultFileName(@DefaultFilename, DefaultFilenameIndex)
		
		Do
			lstrcpy(@pFile->FilePath, Path)
			lstrcat(@pFile->FilePath, DefaultFilename)
			
			MapPath(@pFile->PathTranslated, @pFile->FilePath)
			
			pFile->FileHandle = OpenFileForReading(@pFile->PathTranslated, ForReading)
			If pFile->FileHandle <> INVALID_HANDLE_VALUE Then
				Return True
			End If
			
			DefaultFilenameIndex += 1
			GetDefaultFileNameResult = GetDefaultFileName(@DefaultFilename, DefaultFilenameIndex)
			
		Loop While GetDefaultFileNameResult
		
		' Файл по умолчанию не найден
		GetDefaultFileName(DefaultFilename, 0)
		lstrcpy(@pFile->FilePath, Path)
		lstrcat(@pFile->FilePath, @DefaultFilename)
		
		MapPath(@pFile->PathTranslated, @pFile->FilePath)
		
		pFile->FileHandle = INVALID_HANDLE_VALUE
		Return False
	End If
End Function

Function GetDefaultFileName( _
		ByVal Buffer As WString Ptr, _
		ByVal Index As Integer _
	)As Boolean
	
	Select Case Index
		Case 0
			lstrcpy(Buffer, @DefaultFileNameString1)
		Case 1
			lstrcpy(Buffer, @DefaultFileNameString2)
		Case 2
			lstrcpy(Buffer, @DefaultFileNameString3)
		Case 3
			lstrcpy(Buffer, @DefaultFileNameString4)
		Case 4
			lstrcpy(Buffer, @DefaultFileNameString5)
		Case 5
			lstrcpy(Buffer, @DefaultFileNameString6)
		Case 6
			lstrcpy(Buffer, @DefaultFileNameString7)
		Case 7
			lstrcpy(Buffer, @DefaultFileNameString8)
		Case Else
			Buffer[0] = 0
			Return False
	End Select
	
	Return True
End Function

Function OpenFileForReading( _
		ByVal PathTranslated As WString Ptr, _
		ByVal ForReading As FileAccess _
	)As Handle
	
	Select Case ForReading
		Case FileAccess.ForPut
			Return INVALID_HANDLE_VALUE
			
		Case FileAccess.ForGetHead
			' Для GetHead
			Return CreateFile(PathTranslated, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL Or FILE_FLAG_SEQUENTIAL_SCAN, NULL)
			
		Case FileAccess.ForDelete
			' Для Delete
			Return CreateFile(PathTranslated, 0, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
			
	End Select
End Function
