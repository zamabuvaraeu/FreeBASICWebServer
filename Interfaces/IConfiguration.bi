#ifndef ICONFIGURATION_BI
#define ICONFIGURATION_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Type IConfiguration As IConfiguration_

Type LPICONFIGURATION As IConfiguration Ptr

Extern IID_IConfiguration Alias "IID_IConfiguration" As Const IID

Type IConfigurationVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim SetIniFilename As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal pFileName As WString Ptr _
	)As HRESULT
	
	Dim GetStringValue As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal DefaultValue As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pValue As WString Ptr, _
		ByVal pValueLength As Integer Ptr _
	)As HRESULT
	
	Dim GetIntegerValue As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal DefaultValue As Integer, _
		ByVal pValue As Integer Ptr _
	)As HRESULT
	
	Dim GetAllSections As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pSections As WString Ptr, _
		ByVal pSectionsLength As Integer Ptr _
	)As HRESULT
	
	Dim GetAllKeys As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pKeys As WString Ptr, _
		ByVal pKeysLength As Integer Ptr _
	)As HRESULT
	
	Dim SetStringValue As Function( _
		ByVal this As IConfiguration Ptr, _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal pValue As WString Ptr _
	)As HRESULT
	
End Type

Type IConfiguration_
	Dim pVirtualTable As IConfigurationVirtualTable Ptr
End Type

#define IConfiguration_QueryInterface(this, riid, ppv) (this)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppv)
#define IConfiguration_AddRef(this) (this)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define IConfiguration_Release(this) (this)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define IConfiguration_SetIniFilename(this, pFileName) (this)->pVirtualTable->SetIniFilename(this, pFileName)
#define IConfiguration_GetStringValue(this, Section, Key, DefaultValue, BufferLength, pValue, pValueLength) (this)->pVirtualTable->GetStringValue(this, Section, Key, DefaultValue, BufferLength, pValue, pValueLength)
#define IConfiguration_GetIntegerValue(this, Section, Key, DefaultValue, pValue) (this)->pVirtualTable->GetIntegerValue(this, Section, Key, DefaultValue, pValue)
#define IConfiguration_GetAllSections(this, BufferLength, pSections, pSectionsLength) (this)->pVirtualTable->GetAllSections(this, BufferLength, pSections, pSectionsLength)
#define IConfiguration_GetAllKeys(this, Section, BufferLength, pKeys, pKeysLength) (this)->pVirtualTable->GetAllKeys(this, Section, BufferLength, pKeys, pKeysLength)
#define IConfiguration_SetStringValue(this, Section, Keys, pValue) (this)->pVirtualTable->SetStringValue(this, Section, Keys, pValue)

#endif
