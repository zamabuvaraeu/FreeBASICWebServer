﻿#include "WebSiteContainer.bi"
#include "CreateInstance.bi"
#include "HttpConst.bi"
#include "IConfiguration.bi"
#include "IMutableWebSite.bi"
#include "IniConst.bi"
#include "StringConstants.bi"
#include "win\shlwapi.bi"

Const MaxSectionsLength As Integer = 32000 - 1
Const MaxHostNameLength As Integer = 1024 - 1

Type WebSiteNode As _WebSiteNode

Type LPWebSiteNode As _WebSiteNode Ptr

Type _WebSiteNode
	Dim HostName As WString * (MaxHostNameLength + 1)
	Dim pExecutableDirectory As WString Ptr
	Dim PhysicalDirectory As WString * (MAX_PATH + 1)
	Dim VirtualPath As WString * (MaxHostNameLength + 1)
	Dim MovedUrl As WString * (MaxHostNameLength + 1)
	Dim IsMoved As Boolean
	
	Dim LeftNode As WebSiteNode Ptr
	Dim RightNode As WebSiteNode Ptr
End Type

Const WEBSITENODE_HEAPINITIALSIZE As DWORD = 50 * SizeOf(WebSiteNode)
Const WEBSITENODE_HEAPMAXIMUMSIZE As DWORD = 50 * SizeOf(WebSiteNode)

Type _WebSiteContainer
	
	Dim pVirtualTable As IWebSiteContainerVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	
	Dim ExecutableDirectory As WString * (MAX_PATH + 1)
	Dim hWebSiteNodesHeap As Handle
	Dim pDefaultNode As WebSiteNode Ptr
	Dim pTree As WebSiteNode Ptr
	
End Type

Declare Sub LoadWebSite( _
	ByVal pWebSiteContainer As WebSiteContainer Ptr, _
	ByVal pIConfig As IConfiguration Ptr, _
	ByVal HostName As WString Ptr _
)

Declare Function CreateWebSiteNode( _
	ByVal hHeap As HANDLE, _
	ByVal pIConfig As IConfiguration Ptr, _
	ByVal ExecutableDirectory As WString Ptr, _
	ByVal HostName As WString Ptr _
)As WebSiteNode Ptr

Declare Sub TreeAddNode( _
	ByVal pTree As WebSiteNode Ptr, _
	ByVal pNode As WebSiteNode Ptr _
)

Declare Function TreeFindNode( _
	ByVal pTree As WebSiteNode Ptr, _
	ByVal HostName As WString Ptr _
)As WebSiteNode Ptr

Extern CLSID_CONFIGURATION Alias "CLSID_CONFIGURATION" As Const CLSID

Dim Shared GlobalWebSiteContainerVirtualTable As IWebSiteContainerVirtualTable = Type( _
	Type<IUnknownVtbl>( _
		@WebSiteContainerQueryInterface, _
		@WebSiteContainerAddRef, _
		@WebSiteContainerRelease _
	), _
	@WebSiteContainerFindWebSite, _
	@WebSiteContainerGetDefaultWebSite, _
	@WebSiteContainerLoadWebSites _
)

Sub InitializeWebSiteContainer( _
		ByVal this As WebSiteContainer Ptr _
	)
	
	this->pVirtualTable = @GlobalWebSiteContainerVirtualTable
	this->ReferenceCounter = 0
	this->ExecutableDirectory[0] = 0
	
	this->hWebSiteNodesHeap = NULL
	this->pDefaultNode = NULL
	this->pTree = NULL
	
End Sub

Sub UnInitializeWebSiteContainer( _
		ByVal this As WebSiteContainer Ptr _
	)
	
	If this->hWebSiteNodesHeap <> NULL Then
		HeapDestroy(this->hWebSiteNodesHeap)
	End If
	
End Sub

Function CreateWebSiteContainer( _
	)As WebSiteContainer Ptr
	
	Dim pWebSiteContainer As WebSiteContainer Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(WebSiteContainer) _
	)
	
	If pWebSiteContainer = NULL Then
		Return NULL
	End If
	
	InitializeWebSiteContainer(pWebSiteContainer)
	
	pWebSiteContainer->hWebSiteNodesHeap = HeapCreate( _
		HEAP_NO_SERIALIZE, _
		WEBSITENODE_HEAPINITIALSIZE, _
		WEBSITENODE_HEAPMAXIMUMSIZE _
	)
	If pWebSiteContainer->hWebSiteNodesHeap = NULL Then
		DestroyWebSiteContainer(pWebSiteContainer)
		Return NULL
	End If
	
	Return pWebSiteContainer
	
End Function

Sub DestroyWebSiteContainer( _
		ByVal this As WebSiteContainer Ptr _
	)
	
	UnInitializeWebSiteContainer(this)
	
	HeapFree(GetProcessHeap(), 0, this)
	
End Sub

Function WebSiteContainerQueryInterface( _
		ByVal this As WebSiteContainer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_IWebSiteContainer, riid) Then
		*ppv = @this->pVirtualTable
	Else
		If IsEqualIID(@IID_IUnknown, riid) Then
			*ppv = @this->pVirtualTable
		Else
			*ppv = NULL
			Return E_NOINTERFACE
		End If
	End If
	
	WebSiteContainerAddRef(this)
	
	Return S_OK
	
End Function

Function WebSiteContainerAddRef( _
		ByVal this As WebSiteContainer Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@this->ReferenceCounter)
	
End Function

Function WebSiteContainerRelease( _
		ByVal this As WebSiteContainer Ptr _
	)As ULONG
	
	InterlockedDecrement(@this->ReferenceCounter)
	
	If this->ReferenceCounter = 0 Then
		
		DestroyWebSiteContainer(this)
		
		Return 0
	End If
	
	Return this->ReferenceCounter
	
End Function

Sub SetMutableWebSite( _
		ByVal pIMutable As IMutableWebSite Ptr, _
		ByVal pNode As WebSiteNode Ptr _
	)
	
	IMutableWebSite_SetHostName(pIMutable, @pNode->HostName)
	IMutableWebSite_SetExecutableDirectory(pIMutable, pNode->pExecutableDirectory)
	IMutableWebSite_SetSitePhysicalDirectory(pIMutable, @pNode->PhysicalDirectory)
	IMutableWebSite_SetVirtualPath(pIMutable, @pNode->VirtualPath)
	IMutableWebSite_SetIsMoved(pIMutable, pNode->IsMoved)
	IMutableWebSite_SetMovedUrl(pIMutable, @pNode->MovedUrl)
	
End Sub

Function WebSiteContainerGetDefaultWebSite( _
		ByVal this As WebSiteContainer Ptr, _
		ByVal pIWebSite As IWebSite Ptr _
	)As HRESULT
	
	Dim pIMutable As IMutableWebSite Ptr = Any
	Dim hr As HRESULT = IWebSite_QueryInterface( _
		pIWebSite, _
		@IID_IMutableWebSite, _
		@pIMutable _
	)
	
	SetMutableWebSite(pIMutable, this->pDefaultNode)
	
	IMutableWebSite_Release(pIMutable)
	
	Return S_OK
	
End Function

Function WebSiteContainerFindWebSite( _
		ByVal this As WebSiteContainer Ptr, _
		ByVal Host As WString Ptr, _
		ByVal pIWebSite As IWebSite Ptr _
	)As HRESULT
	
	Dim pNode As WebSiteNode Ptr = TreeFindNode(this->pTree, Host)
	
	If pNode = NULL Then
		Return E_FAIL
	End If
	
	Dim pIMutable As IMutableWebSite Ptr = Any
	Dim hr As HRESULT = IWebSite_QueryInterface( _
		pIWebSite, _
		@IID_IMutableWebSite, _
		@pIMutable _
	)
	
	SetMutableWebSite(pIMutable, pNode)
	
	IMutableWebSite_Release(pIMutable)
	
	Return S_OK
	
End Function

Function WebSiteContainerLoadWebSites( _
		ByVal this As WebSiteContainer Ptr, _
		ByVal ExecutableDirectory As WString Ptr _
	)As HRESULT
	
	lstrcpy(@this->ExecutableDirectory, ExecutableDirectory)
	
	Dim SettingsFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@SettingsFileName, ExecutableDirectory, @WebSitesIniFileString)
	
	Dim pIConfig As IConfiguration Ptr = Any
	Dim hr As HRESULT = CreateInstance( _
		GetProcessHeap(), _
		@CLSID_CONFIGURATION, _
		@IID_IConfiguration, _
		@pIConfig _
	)
	If FAILED(hr) Then
		Return hr
	End If
	
	IConfiguration_SetIniFilename(pIConfig, @SettingsFileName)
	
	Dim SectionsLength As Integer = Any
	
	Dim AllSections As WString * (MaxSectionsLength + 1) = Any
	
	IConfiguration_GetAllSections(pIConfig, MaxSectionsLength, @AllSections, @SectionsLength)
	
	Dim w As WString Ptr = @AllSections
	Dim wLength As Integer = lstrlen(w)
	
	Do While wLength > 0	
		
		LoadWebSite(this, pIConfig, w)

		w = @w[wLength + 1]
		wLength = lstrlen(w)
		
	Loop
	
	this->pDefaultNode = CreateWebSiteNode( _
		this->hWebSiteNodesHeap, _
		pIConfig, _
		@this->ExecutableDirectory, _
		@DefaultVirtualPath _
	)
	
	IConfiguration_Release(pIConfig)
	
	Return S_OK
	
End Function

Sub LoadWebSite( _
		ByVal this As WebSiteContainer Ptr, _
		ByVal pIConfig As IConfiguration Ptr, _
		ByVal HostName As WString Ptr _
	)
	
	Dim pNode As WebSiteNode Ptr = CreateWebSiteNode( _
		this->hWebSiteNodesHeap, _
		pIConfig, _
		@this->ExecutableDirectory, _
		HostName _
	)
	
	If this->pTree = NULL Then
		this->pTree = pNode
	Else
		TreeAddNode(this->pTree, pNode)
	End If
	
End Sub

Function CreateWebSiteNode( _
		ByVal hHeap As HANDLE, _
		ByVal pIConfig As IConfiguration Ptr, _
		ByVal ExecutableDirectory As WString Ptr, _
		ByVal Section As WString Ptr _
	)As WebSiteNode Ptr
	
	Dim pNode As WebSiteNode Ptr = HeapAlloc( _
		hHeap, _
		HEAP_NO_SERIALIZE, _
		SizeOf(WebSiteNode) _
	)
	
	If pNode = NULL Then
		Return NULL
	End If
	
	pNode->LeftNode = NULL
	pNode->RightNode = NULL
	lstrcpy(@pNode->HostName, Section)
	pNode->pExecutableDirectory = ExecutableDirectory
	
	Dim ValueLength As Integer = Any
	
	IConfiguration_GetStringValue(pIConfig, _
		Section, _
		@PhisycalDirKeyString, _
		pNode->pExecutableDirectory, _
		MAX_PATH, _
		@pNode->PhysicalDirectory, _
		@ValueLength _
	)
	
	IConfiguration_GetStringValue(pIConfig, _
		Section, _
		@VirtualPathKeyString, _
		@DefaultVirtualPath, _
		MaxHostNameLength, _
		@pNode->VirtualPath, _
		@ValueLength _
	)
	
	IConfiguration_GetStringValue(pIConfig, _
		Section, _
		@MovedUrlKeyString, _
		@EmptyString, _
		MaxHostNameLength, _
		@pNode->MovedUrl, _
		@ValueLength _
	)
	
	Dim IsMoved As Integer = Any
	IConfiguration_GetIntegerValue(pIConfig, _
		Section, _
		@IsMovedKeyString, _
		0, _
		@IsMoved _
	)
	
	If IsMoved = 0 Then
		pNode->IsMoved = False
	Else
		pNode->IsMoved = True
	End If
	
	' pNode->pIWebSite = InitializeWebSiteOfIWebSite(@pNode->objWebSite)
	
	' pNode->objWebSite.pHostName = @pNode->HostName
	' pNode->objWebSite.pPhysicalDirectory = @pNode->PhysicalDirectory
	' pNode->objWebSite.pExecutableDirectory = pNode->pExecutableDirectory
	' pNode->objWebSite.pVirtualPath = @pNode->VirtualPath
	' pNode->objWebSite.IsMoved = pNode->IsMoved
	' pNode->objWebSite.pMovedUrl = @pNode->MovedUrl
	
	Return pNode
	
End Function

Sub TreeAddNode( _
		ByVal pTree As WebSiteNode Ptr, _
		ByVal pNode As WebSiteNode Ptr _
	)
	
	Select Case lstrcmpi(pNode->HostName, pTree->HostName)
		
		Case Is > 0
			If pTree->RightNode = NULL Then
				pTree->RightNode = pNode
			Else
				TreeAddNode(pTree->RightNode, pNode)
			End If
			
		Case Is < 0
			If pTree->LeftNode = NULL Then
				pTree->LeftNode = pNode
			Else
				TreeAddNode(pTree->LeftNode, pNode)
			End If
			
	End Select
	
End Sub

Function TreeFindNode( _
		ByVal pNode As WebSiteNode Ptr, _
		ByVal HostName As WString Ptr _
	)As WebSiteNode Ptr
	
	Select Case lstrcmpi(HostName, pNode->HostName)
		
		Case Is > 0
			If pNode->RightNode = NULL Then
				Return NULL
			End If
			
			Return TreeFindNode(pNode->RightNode, HostName)
			
		Case 0
			Return pNode
			
		Case Is < 0
			If pNode->LeftNode = NULL Then
				Return NULL
			End If
			
			Return TreeFindNode(pNode->LeftNode, HostName)
			
	End Select
	
End Function
