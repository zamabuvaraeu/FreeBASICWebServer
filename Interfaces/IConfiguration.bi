#ifndef ICONFIGURATION_BI
#define ICONFIGURATION_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\objbase.bi"

' {76A3EA34-6604-4126-9550-54280EAA291A}
Dim Shared IID_ICONFIGURATION As IID = Type(&h76a3ea34, &h6604, &h4126, _
	{&h95, &h50, &h54, &h28, &he, &haa, &h29, &h1a})

Type LPICONFIGURATION As IConfiguration Ptr

Type IConfiguration As IConfiguration_

Type IConfigurationVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim SetIniFilename As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal pFileName As WString Ptr _
	)As HRESULT
	
	Dim GetStringValue As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal DefaultValue As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pValue As WString Ptr, _
		ByVal pValueLength As Integer Ptr _
	)As HRESULT
	
	Dim GetIntegerValue As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal DefaultValue As Integer, _
		ByVal pValue As Integer Ptr _
	)As HRESULT
	
	Dim GetAllSections As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pSections As WString Ptr, _
		ByVal pSectionsLength As Integer Ptr _
	)As HRESULT
	
	Dim GetAllKeys As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pKeys As WString Ptr, _
		ByVal pKeysLength As Integer Ptr _
	)As HRESULT
	
	Dim SetStringValue As Function( _
		ByVal pIConfiguration As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal pValue As WString Ptr _
	)As HRESULT
	
End Type

Type IConfiguration_
	Dim pVirtualTable As IConfigurationVirtualTable Ptr
End Type

#define IConfiguration_QueryInterface(pIConfiguration, riid, ppv) (pIConfiguration)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pIConfiguration), riid, ppv)
#define IConfiguration_AddRef(pIConfiguration) (pIConfiguration)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, pIConfiguration))
#define IConfiguration_Release(pIConfiguration) (pIConfiguration)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, pIConfiguration))
#define IConfiguration_SetIniFilename(pIConfiguration, pFileName) (pIConfiguration)->pVirtualTable->SetIniFilename(pIConfiguration, pFileName)
#define IConfiguration_GetStringValue(pIConfiguration, Section, Key, DefaultValue, BufferLength, pValue, pValueLength) (pIConfiguration)->pVirtualTable->GetStringValue(pIConfiguration, Section, Key, DefaultValue, BufferLength, pValue, pValueLength)
#define IConfiguration_GetIntegerValue(pIConfiguration, Section, Key, DefaultValue, pValue) (pIConfiguration)->pVirtualTable->GetIntegerValue(pIConfiguration, Section, Key, DefaultValue, pValue)
#define IConfiguration_GetAllSections(pIConfiguration, BufferLength, pSections, pSectionsLength) (pIConfiguration)->pVirtualTable->GetAllSections(pIConfiguration, BufferLength, pSections, pSectionsLength)
#define IConfiguration_GetAllKeys(pIConfiguration, Section, BufferLength, pKeys, pKeysLength) (pIConfiguration)->pVirtualTable->GetAllKeys(pIConfiguration, Section, BufferLength, pKeys, pKeysLength)
#define IConfiguration_SetStringValue(pIConfiguration, Section, Keys, pValue) (pIConfiguration)->pVirtualTable->SetStringValue(pIConfiguration, Section, Keys, pValue)

#endif
