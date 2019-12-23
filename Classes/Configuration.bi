﻿#ifndef CONFIGURATION_BI
#define CONFIGURATION_BI

#include "IConfiguration.bi"

Type Configuration
	Dim pVirtualTable As IConfigurationVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	Dim ExistsInStack As Boolean
	
	Dim IniFileName As WString * (MAX_PATH + 1)
	
End Type

Declare Function InitializeConfigurationOfIConfiguration( _
	ByVal pConfiguration As Configuration Ptr _
)As IConfiguration Ptr

Declare Function ConfigurationQueryInterface( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ConfigurationAddRef( _
	ByVal pConfiguration As Configuration Ptr _
)As ULONG

Declare Function ConfigurationRelease( _
	ByVal pConfiguration As Configuration Ptr _
)As ULONG

Declare Function ConfigurationSetIniFilename( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal pFileName As WString Ptr _
)As HRESULT

Declare Function ConfigurationGetStringValue( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal Section As WString Ptr, _
	ByVal Key As WString Ptr, _
	ByVal DefaultValue As WString Ptr, _
	ByVal BufferLength As Integer, _
	ByVal pValue As WString Ptr, _
	ByVal pValueLength As Integer Ptr _
)As HRESULT

Declare Function ConfigurationGetIntegerValue( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal Section As WString Ptr, _
	ByVal Key As WString Ptr, _
	ByVal DefaultValue As Integer, _
	ByVal pValue As Integer Ptr _
)As HRESULT

Declare Function ConfigurationGetAllSections( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal BufferLength As Integer, _
	ByVal pSections As WString Ptr, _
	ByVal pSectionsLength As Integer Ptr _
)As HRESULT

Declare Function ConfigurationGetAllKeys( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal Section As WString Ptr, _
	ByVal BufferLength As Integer, _
	ByVal pKeys As WString Ptr, _
	ByVal pKeysLength As Integer Ptr _
)As HRESULT

Declare Function ConfigurationSetStringValue( _
	ByVal pConfiguration As Configuration Ptr, _
	ByVal Section As WString Ptr, _
	ByVal Key As WString Ptr, _
	ByVal pValue As WString Ptr _
)As HRESULT

#define Configuration_NonVirtualQueryInterface(pIConfiguration, riid, ppv) ConfigurationQueryInterface(CPtr(Configuration Ptr, pIConfiguration), riid, ppv)
#define Configuration_NonVirtualAddRef(pIConfiguration) ConfigurationAddRef(CPtr(Configuration Ptr, pIConfiguration))
#define Configuration_NonVirtualRelease(pIConfiguration) ConfigurationRelease(CPtr(Configuration Ptr, pIConfiguration))
#define Configuration_NonVirtualSetIniFilename(pIConfiguration, pFileName) ConfigurationSetIniFilename(CPtr(Configuration Ptr, pIConfiguration), pFileName)
#define Configuration_NonVirtualGetStringValue(pIConfiguration, Section, Key, DefaultValue, BufferLength, pValue, pValueLength) ConfigurationGetStringValue(CPtr(Configuration Ptr, pIConfiguration), Section, Key, DefaultValue, BufferLength, pValue, pValueLength)
#define Configuration_NonVirtualGetIntegerValue(pIConfiguration, Section, Key, DefaultValue, pValue) ConfigurationGetIntegerValue(CPtr(Configuration Ptr, pIConfiguration), Section, Key, DefaultValue, pValue)
#define Configuration_NonVirtualGetAllSections(pIConfiguration, BufferLength, pSections, pSectionsLength) ConfigurationGetAllSections(CPtr(Configuration Ptr, pIConfiguration), BufferLength, pSections, pSectionsLength)
#define Configuration_NonVirtualGetAllKeys(pIConfiguration, Section, BufferLength, pKeys, pKeysLength) ConfigurationGetAllKeys(CPtr(Configuration Ptr, pIConfiguration), Section, BufferLength, pKeys, pKeysLength)
#define Configuration_NonVirtualSetStringValue(pIConfiguration, Section, Keys, pValue) ConfigurationSetStringValue(CPtr(Configuration Ptr, pIConfiguration), Section, Keys, pValue)

#endif
