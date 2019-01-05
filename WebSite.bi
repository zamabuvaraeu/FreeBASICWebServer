#ifndef WEBSITE_BI
#define WEBSITE_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "RequestedFile.bi"

Const MaxWebSitesCount As Integer = 50
Const DefaultVirtualPath = "/"

Enum FileAccess
	ForPut
	ForGetHead
	ForDelete
End Enum

Type WebSiteItem
	Const MaxHostNameLength As Integer = 1024 - 1
	
	Dim HostName As WString * (MaxHostNameLength + 1)
	Dim PhysicalDirectory As WString * (MAX_PATH + 1)
	Dim VirtualPath As WString * (MaxHostNameLength + 1)
	Dim MovedUrl As WString * (MaxHostNameLength + 1)
	Dim IsMoved As Boolean
End Type

Type SimpleWebSite
	Dim HostName As WString Ptr
	Dim PhysicalDirectory As WString Ptr
	Dim VirtualPath As WString Ptr
	Dim IsMoved As Boolean
	Dim MovedUrl As WString Ptr
	
	Declare Function GetRequestedFile( _
		ByVal pFile As RequestedFile Ptr, _
		ByVal Path As WString Ptr, _
		ByVal ForReading As FileAccess _
	)As Boolean
	
	Declare Sub MapPath( _
		ByVal Buffer As WString Ptr, _
		ByVal Path As WString Ptr _
	)
End Type

Type WebSitesArray
	Dim WebSitesCount As Integer
	Dim WebSites(MaxWebSitesCount - 1) As WebSiteItem
	
	Declare Function FindSimpleWebSite( _
		ByVal www As SimpleWebSite Ptr, _
		ByVal HostName As WString Ptr _
	)As Boolean
End Type

Declare Function IsBadPath( _
	ByVal Path As WString Ptr _
)As Boolean

Declare Function NeedCgiProcessing( _
	ByVal Path As WString Ptr _
)As Boolean

Declare Function NeedDllProcessing( _
	ByVal Path As WString Ptr _
)As Boolean

Declare Function GetWebSitesArray( _
	ByVal ppWebSitesArray As WebSitesArray Ptr Ptr, _
	ByVal ExeDir As WString Ptr _
)As Integer

#endif
