#ifndef IFILESTREAM_BI
#define IFILESTREAM_BI

#include "IBaseStream.bi"

Type IFileStream As IFileStream_

Type IFileStreamVirtualTable
	Dim VirtualTable As IBaseStreamVirtualTable
	
	Dim GetFileName As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal pResult As WString Ptr _
	)As HRESULT
	
	Dim SetFileName As Function( _
		ByVal this As INetworkStream Ptr, _
		ByVal hFile As WString Ptr _
	)As HRESULT
	
End Type

Type IFileStream_
	Dim pVirtualTable As IFileStreamVirtualTable Ptr
End Type

#endif
