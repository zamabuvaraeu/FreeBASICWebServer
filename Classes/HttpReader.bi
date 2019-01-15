#ifndef HTTPREADER_BI
#define HTTPREADER_BI

#include "IHttpReader.bi"
#include "IBaseStream.bi"

Type HttpReader
	Const MaxBufferLength As Integer = 16 * 1024 - 1
	
	Dim pVirtualTable As IHttpReaderVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	
	Dim pIStream As IBaseStream Ptr
	Dim Buffer As ZString * (HttpReader.MaxBufferLength + 1)
	Dim BufferLength As Integer
	Dim StartLineIndex As Integer
	
End Type

Declare Function InitializeHttpReaderOfIHttpReader( _
	ByVal pHttpReader As HttpReader Ptr _
)As IHttpReader Ptr

Declare Function HttpReaderQueryInterface( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function HttpReaderAddRef( _
	ByVal pHttpReader As HttpReader Ptr _
)As ULONG

Declare Function HttpReaderRelease( _
	ByVal pHttpReader As HttpReader Ptr _
)As ULONG

Declare Function HttpReaderCloseTextReader( _
	ByVal pHttpReader As HttpReader Ptr _
)As HRESULT
	
Declare Function HttpReaderOpenTextReader( _
	ByVal pHttpReader As HttpReader Ptr _
)As HRESULT
	
Declare Function HttpReaderPeek( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal pChar As Integer Ptr _
)As HRESULT
	
Declare Function HttpReaderReadChar( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal pChar As Integer Ptr _
)As HRESULT
	
Declare Function HttpReaderReadCharArray( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal Buffer As WString Ptr, _
	ByVal Index As Integer, _
	ByVal Count As Integer, _
	ByVal pReadedChars As Integer Ptr _
)As HRESULT
	
Declare Function HttpReaderReadLine( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal Buffer As WString Ptr, _
	ByVal BufferLength As Integer, _
	ByVal pLineLength As Integer Ptr _
)As HRESULT
	
Declare Function HttpReaderReadToEnd( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal Buffer As WString Ptr, _
	ByVal BufferLength As Integer, _
	ByVal pLineLength As Integer Ptr _
)As HRESULT

Declare Function HttpReaderClear( _
	ByVal pHttpReader As HttpReader Ptr _
)As HRESULT

Declare Function HttpReaderGetBaseStream( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal ppResult As IBaseStream Ptr Ptr _
)As HRESULT

Declare Function HttpReaderSetBaseStream( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal pIStream As IBaseStream Ptr _
)As HRESULT

Declare Function HttpReaderGetPreloadedContent( _
	ByVal pHttpReader As HttpReader Ptr, _
	ByVal pPreloadedContentLength As Integer Ptr, _
	ByVal ppPreloadedContent As UByte Ptr Ptr _
)As HRESULT

#endif
