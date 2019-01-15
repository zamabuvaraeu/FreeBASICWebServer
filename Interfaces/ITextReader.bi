#ifndef ITEXTREADER_BI
#define ITEXTREADER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\objbase.bi"

' {D46D4E27-B2CD-4594-96EA-5B8203D21439}
Dim Shared IID_ITEXTREADER As IID = Type(&hd46d4e27, &hb2cd, &h4594, _
	{&h96, &hea, &h5b, &h82, &h3, &hd2, &h14, &h39})

Type LPITEXTREADER As ITextReader Ptr

Type ITextReader As ITextReader_

Type ITextReaderVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
	Dim CloseTextReader As Function( _
		ByVal pITextReader As ITextReader Ptr _
	)As HRESULT
	
	Dim OpenTextReader As Function( _
		ByVal pITextReader As ITextReader Ptr _
	)As HRESULT
	
	Dim Peek As Function( _
		ByVal pITextReader As ITextReader Ptr, _
		ByVal pChar As Integer Ptr _
	)As HRESULT
	
	Dim ReadChar As Function( _
		ByVal pITextReader As ITextReader Ptr, _
		ByVal pChar As Integer Ptr _
	)As HRESULT
	
	Dim ReadCharArray As Function( _
		ByVal pITextReader As ITextReader Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal Index As Integer, _
		ByVal Count As Integer, _
		ByVal pReadedChars As Integer Ptr _
	)As HRESULT
	
	Dim ReadLine As Function( _
		ByVal pITextReader As ITextReader Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pLineLength As Integer Ptr _
	)As HRESULT
	
	Dim ReadToEnd As Function( _
		ByVal pITextReader As ITextReader Ptr, _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal pLineLength As Integer Ptr _
	)As HRESULT
	
End Type

Type ITextReader_
	Dim pVirtualTable As ITextReaderVirtualTable Ptr
End Type

#define ITextReader_QueryInterface(pITextReader, riid, ppv) (pITextReader)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pITextReader), riid, ppv)
#define ITextReader_AddRef(pITextReader) (pITextReader)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, pITextReader))
#define ITextReader_Release(pITextReader) (pITextReader)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, pITextReader))
#define ITextReader_CloseTextReader(pITextReader) (pITextReader)->pVirtualTable->CloseTextReader(pITextReader)
#define ITextReader_OpenTextReader(pITextReader) (pITextReader)->pVirtualTable->OpenTextReader(pITextReader)
#define ITextReader_Peek(pITextReader, pChar) (pITextReader)->pVirtualTable->Peek(pITextReader, pChar)
#define ITextReader_ReadChar(pITextReader, pChar) (pITextReader)->pVirtualTable->ReadChar(pITextReader, pChar)
#define ITextReader_ReadCharArray(pITextReader, Buffer, Index, Count, pReadedChars) (pITextReader)->pVirtualTable->ReadCharArray(pITextReader, Buffer, Index, Count, pReadedChars)
#define ITextReader_ReadLine(pITextReader, Buffer, BufferLength, pLineLength) (pITextReader)->pVirtualTable->ReadLine(pITextReader, Buffer, BufferLength, pLineLength)
#define ITextReader_ReadToEnd(pITextReader, Buffer, BufferLength, pLineLength) (pITextReader)->pVirtualTable->ReadToEnd(pITextReader, Buffer, BufferLength, pLineLength)

#endif
