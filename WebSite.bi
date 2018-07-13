#ifndef WEBSITE_BI
#define WEBSITE_BI

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"

Const SlashString = "/"

Const MaxWebSitesCount As Integer = 50

' Проверяет путь на запрещённые символы
Declare Function IsBadPath( _
	ByVal Path As WString Ptr _
)As Boolean

' Проверка на CGI
Declare Function NeedCgiProcessing( _
	ByVal Path As WString Ptr _
)As Boolean

' Проверка на dll-cgi
Declare Function NeedDllProcessing( _
	ByVal Path As WString Ptr _
)As Boolean

Enum FileAccess
	ForPut
	ForGetHead
	ForDelete
End Enum

Type WebSiteItem
	Const MaxHostNameLength As Integer = 1023
	
	Dim HostName As WString * (MaxHostNameLength + 1)
	Dim PhysicalDirectory As WString * (MAX_PATH + 1)
	Dim VirtualPath As WString * (MaxHostNameLength + 1)
	Dim IsMoved As Boolean
	Dim MovedUrl As WString * (MaxHostNameLength + 1)
End Type

Type WebSitesArray
	Dim WebSitesCount As Integer
	Dim WebSites(MaxWebSitesCount - 1) As WebSiteItem
End Type

' Заполняет список сайтов из конфигурации
Declare Function GetWebSitesArray( _
	ByVal ExeDir As WString Ptr, _
	ByVal ppWebSitesArray As WebSitesArray Ptr Ptr _
)As Integer


Type SimpleWebSite
	Const MaxFilePathLength As Integer = 4095 + 32
	Const MaxFilePathTranslatedLength As Integer = MaxFilePathLength + 256
	
	Dim HostName As WString Ptr
	Dim PhysicalDirectory As WString Ptr
	Dim VirtualPath As WString Ptr
	Dim IsMoved As Boolean
	Dim MovedUrl As WString Ptr
	Dim FilePath As WString * (MaxFilePathLength + 1)
	Dim PathTranslated As WString * (MaxFilePathTranslatedLength + 1)
	
	Declare Function GetFilePath( _
		ByVal path As WString Ptr, _
		ByVal ForReading As FileAccess _
	)As Handle
	
	Declare Sub MapPath( _
		ByVal Buffer As WString Ptr, _
		ByVal path As WString Ptr _
	)
End Type

' Заполняет указатель на сайт
' При ошибке возвращает False
Declare Function GetSimpleWebSite( _
	ByVal www As SimpleWebSite Ptr, _
	ByVal HostName As WString Ptr, _
	ByVal pWebSitesArray As WebSitesArray Ptr _
)As Boolean

#endif
