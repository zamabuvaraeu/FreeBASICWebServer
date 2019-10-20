#include "WebSiteContainer.bi"
#include "Configuration.bi"
#include "HttpConst.bi"
#include "IniConst.bi"
#include "StringConstants.bi"
#include "win\shlwapi.bi"

' TODO Убрать манипуляцию данными объекта, использовать интерфейс

Const MaxSectionsLength As Integer = 32000 - 1

Dim Shared GlobalWebSiteContainerVirtualTable As IWebSiteContainerVirtualTable = Type<IWebSiteContainerVirtualTable>( _
	Type<IUnknownVtbl>( _
		@WebSiteContainerQueryInterface, _
		@WebSiteContainerAddRef, _
		@WebSiteContainerRelease _
	), _
	@WebSiteContainerGetDefaultWebSite, _
	@WebSiteContainerFindWebSite, _
	@WebSiteContainerLoadWebSites _
)


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

Sub InitializeWebSiteContainer( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr _
	)
	
	pWebSiteContainer->pVirtualTable = @GlobalWebSiteContainerVirtualTable
	pWebSiteContainer->ReferenceCounter = 0
	pWebSiteContainer->ExecutableDirectory[0] = 0
	
	pWebSiteContainer->hTreeHeap = HeapCreate(HEAP_NO_SERIALIZE, 0, 0)
	pWebSiteContainer->pTree = NULL
	pWebSiteContainer->pDefaultNode = NULL
	
End Sub

Sub UnInitializeWebSiteContainer( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr _
	)
	
	HeapDestroy(pWebSiteContainer->hTreeHeap)
	
End Sub

Function CreateWebSiteContainerOfIWebSiteContainer( _
	)As IWebSiteContainer Ptr
	
	Dim pWebSiteContainer As WebSiteContainer Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(WebSiteContainer) _
	)
	
	If pWebSiteContainer = NULL Then
		Return NULL
	End If
	
	InitializeWebSiteContainer(pWebSiteContainer)
	
	pWebSiteContainer->ExistsInStack = False
	
	Dim pIWebSiteContainer As IWebSiteContainer Ptr = Any
	
	WebSiteContainerQueryInterface( _
		pWebSiteContainer, @IID_IWEBSITECONTAINER, @pIWebSiteContainer _
	)
	
	Return pIWebSiteContainer
	
End Function

Function WebSiteContainerQueryInterface( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = 0
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pWebSiteContainer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IWEBSITECONTAINER, riid) Then
		*ppv = CPtr(IWebSiteContainer Ptr, @pWebSiteContainer->pVirtualTable)
	End If
	
	If *ppv = 0 Then
		Return E_NOINTERFACE
	End If
	
	WebSiteContainerAddRef(pWebSiteContainer)
	
	Return S_OK
	
End Function

Function WebSiteContainerAddRef( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@pWebSiteContainer->ReferenceCounter)
	
End Function

Function WebSiteContainerRelease( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr _
	)As ULONG
	
	InterlockedDecrement(@pWebSiteContainer->ReferenceCounter)
	
	If pWebSiteContainer->ReferenceCounter = 0 Then
		
		UnInitializeWebSiteContainer(pWebSiteContainer)
		
		If pWebSiteContainer->ExistsInStack = False Then
			HeapFree(GetProcessHeap(), 0, pWebSiteContainer)
		End If
		
		Return 0
	End If
	
	Return pWebSiteContainer->ReferenceCounter
	
End Function

Function WebSiteContainerGetDefaultWebSite( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr, _
		ByVal ppIWebSite As IWebSite Ptr Ptr _
	)As HRESULT
	
	*ppIWebSite = pWebSiteContainer->pDefaultNode->pIWebSite
	
	Return S_OK
	
End Function

Function WebSiteContainerFindWebSite( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr, _
		ByVal Host As WString Ptr, _
		ByVal ppIWebSite As IWebSite Ptr Ptr _
	)As HRESULT
	
	Dim pNode As WebSiteNode Ptr = TreeFindNode(pWebSiteContainer->pTree, Host)
	
	If pNode = NULL Then
		*ppIWebSite = NULL
		Return E_FAIL
	End If
	
	*ppIWebSite = pNode->pIWebSite
	
	Return S_OK
	
End Function

Function WebSiteContainerLoadWebSites( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr, _
		ByVal ExecutableDirectory As WString Ptr _
	)As HRESULT
	
	lstrcpy(@pWebSiteContainer->ExecutableDirectory, ExecutableDirectory)
	
	Dim SettingsFileName As WString * (MAX_PATH + 1) = Any
	PathCombine(@SettingsFileName, ExecutableDirectory, @WebSitesIniFileString)
	
	Dim Config As Configuration = Any
	Dim pIConfig As IConfiguration Ptr = InitializeConfigurationOfIConfiguration(@Config)
	
	Configuration_NonVirtualSetIniFilename(pIConfig, @SettingsFileName)
	
	Dim SectionsLength As Integer = Any
	
	Dim AllSections As WString * (MaxSectionsLength + 1) = Any
	
	Configuration_NonVirtualGetAllSections(pIConfig, MaxSectionsLength, @AllSections, @SectionsLength)
	
	Dim w As WString Ptr = @AllSections
	Dim wLength As Integer = lstrlen(w)
	
	Do While wLength > 0	
		
		LoadWebSite(pWebSiteContainer, pIConfig, w)

		w = @w[wLength + 1]
		wLength = lstrlen(w)
		
	Loop
	
	pWebSiteContainer->pDefaultNode = CreateWebSiteNode( _
		pWebSiteContainer->hTreeHeap, _
		pIConfig, _
		@pWebSiteContainer->ExecutableDirectory, _
		@DefaultVirtualPath _
	)
	
	Configuration_NonVirtualRelease(pIConfig)
	
	Return S_OK
	
End Function

Sub LoadWebSite( _
		ByVal pWebSiteContainer As WebSiteContainer Ptr, _
		ByVal pIConfig As IConfiguration Ptr, _
		ByVal HostName As WString Ptr _
	)
	
	Dim pNode As WebSiteNode Ptr = CreateWebSiteNode( _
		pWebSiteContainer->hTreeHeap, _
		pIConfig, _
		@pWebSiteContainer->ExecutableDirectory, _
		HostName _
	)
	
	If pWebSiteContainer->pTree = NULL Then
		pWebSiteContainer->pTree = pNode
	Else
		TreeAddNode(pWebSiteContainer->pTree, pNode)
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
		0, _
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
	
	Configuration_NonVirtualGetStringValue(pIConfig, _
		Section, _
		@PhisycalDirKeyString, _
		pNode->pExecutableDirectory, _
		MAX_PATH, _
		@pNode->PhysicalDirectory, _
		@ValueLength _
	)
	
	Configuration_NonVirtualGetStringValue(pIConfig, _
		Section, _
		@VirtualPathKeyString, _
		@DefaultVirtualPath, _
		WebSiteNode.MaxHostNameLength, _
		@pNode->VirtualPath, _
		@ValueLength _
	)
	
	Configuration_NonVirtualGetStringValue(pIConfig, _
		Section, _
		@MovedUrlKeyString, _
		@EmptyString, _
		WebSiteNode.MaxHostNameLength, _
		@pNode->MovedUrl, _
		@ValueLength _
	)
	
	Dim IsMoved As Integer = Any
	Configuration_NonVirtualGetIntegerValue(pIConfig, _
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
	
	pNode->pIWebSite = InitializeWebSiteOfIWebSite(@pNode->objWebSite)
	
	pNode->objWebSite.pHostName = @pNode->HostName
	pNode->objWebSite.pPhysicalDirectory = @pNode->PhysicalDirectory
	pNode->objWebSite.pExecutableDirectory = pNode->pExecutableDirectory
	pNode->objWebSite.pVirtualPath = @pNode->VirtualPath
	pNode->objWebSite.IsMoved = pNode->IsMoved
	pNode->objWebSite.pMovedUrl = @pNode->MovedUrl
	
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
