#ifndef PRINTDEBUGINFO_BI
#define PRINTDEBUGINFO_BI

#include once "Http.bi"
#include once "IHttpReader.bi"

Declare Sub DebugPrintHttpReaderImpl( _
	ByVal pIHttpReader As IHttpReader Ptr _
)

Declare Sub DebugPrintWStringImpl( _
	ByVal lpwsz As WString Ptr _
)

Declare Sub DebugPrintHttpStatusCodeImpl( _
	ByVal lpwsz As WString Ptr, _
	ByVal StatusCode As HttpStatusCodes _
)

Declare Sub DebugPrintIntegerImpl( _
	ByVal lpwsz As WString Ptr, _
	ByVal hr As Integer _
)

Declare Sub DebugPrintHRESULTImpl( _
	ByVal lpwsz As WString Ptr, _
	ByVal hr As HRESULT _
)

Declare Sub DebugPrintDWORDImpl( _
	ByVal lpwsz As WString Ptr, _
	ByVal dwError As DWORD _
)

Declare Sub DebugPrintPointerImpl( _
	ByVal lpwsz As WString Ptr, _
	ByVal p As Any Ptr _
)

Declare Sub DebugPrintTicksImpl( _
	ByVal pFrequency As PLARGE_INTEGER, _
	ByVal pTicks As PLARGE_INTEGER _
)

#ifdef __FB_DEBUG__
#define DebugPrintHttpReader(pIHttpReader) DebugPrintHttpReaderImpl(pIHttpReader)
#define DebugPrintWString(lpwsz) DebugPrintWStringImpl(lpwsz)
#define DebugPrintHttpStatusCode(lpwsz, StatusCode) DebugPrintHttpStatusCodeImpl(lpwsz, StatusCode)
#define DebugPrintInteger(lpwsz, i) DebugPrintIntegerImpl(lpwsz, i)
#define DebugPrintPointer(lpwsz, p) DebugPrintPointerImpl(lpwsz, p)
#define DebugPrintHRESULT(lpwsz, hr) DebugPrintHRESULTImpl(lpwsz, hr)
#define DebugPrintDWORD(lpwsz, dw) DebugPrintDWORDImpl(lpwsz, dw)
#else
#define DebugPrintHttpReader(pIHttpReader) DebugPrintHttpReaderImpl(pIHttpReader)
#define DebugPrintWString(lpwsz) DebugPrintWStringImpl(lpwsz)
#define DebugPrintHttpStatusCode(lpwsz, StatusCode) DebugPrintHttpStatusCodeImpl(lpwsz, StatusCode)
#define DebugPrintInteger(lpwsz, i) DebugPrintIntegerImpl(lpwsz, i)
#define DebugPrintPointer(lpwsz, p) DebugPrintPointerImpl(lpwsz, p)
#define DebugPrintHRESULT(lpwsz, hr) DebugPrintHRESULTImpl(lpwsz, hr)
#define DebugPrintDWORD(lpwsz, dw) DebugPrintDWORDImpl(lpwsz, dw)
#endif

#endif
