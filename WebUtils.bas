#include once "WebUtils.bi"
#include once "HttpConst.bi"
#include once "URI.bi"
#include once "IntegerToWString.bi"
#include once "CharConstants.bi"
#include once "WriteHttpError.bi"
#include once "Classes\ArrayStringWriter.bi"

Const DateFormatString = "ddd, dd MMM yyyy "
Const TimeFormatString = "HH:mm:ss GMT"

Function GetHtmlSafeString( _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal pHtmlSafeLength As Integer Ptr _
	)As Boolean
	
	Const MaxQuotationMarkSafeStringLength As Integer = 6
	Const MaxAmpersandSafeStringLength As Integer = 5
	Const MaxApostropheSafeStringLength As Integer = 6
	Const MaxLessThanSignSafeStringLength As Integer = 4
	Const MaxGreaterThanSignSafeStringLength As Integer = 4
	
	Dim SafeLength As Integer = Any
	
	' Посчитать размер буфера
	Scope
		
		Dim cbNeedenBufferLength As Integer = 0
		
		Dim i As Integer = 0
		Do While HtmlSafe[i] <> 0
			Dim Number As Integer = HtmlSafe[i]
			
			Select Case Number
				
				Case QuotationMarkChar
					cbNeedenBufferLength += MaxQuotationMarkSafeStringLength
					
				Case AmpersandChar
					cbNeedenBufferLength += MaxAmpersandSafeStringLength
					
				Case ApostropheChar
					cbNeedenBufferLength += MaxApostropheSafeStringLength
					
				Case LessThanSignChar
					cbNeedenBufferLength += MaxLessThanSignSafeStringLength
					
				Case GreaterThanSign
					cbNeedenBufferLength += MaxGreaterThanSignSafeStringLength
					
				Case Else
					cbNeedenBufferLength += 1
					
			End Select
			
			i += 1
		Loop
		SafeLength = i
		
		*pHtmlSafeLength = cbNeedenBufferLength
		
		If Buffer = 0 Then
			SetLastError(ERROR_SUCCESS)
			Return True
		End If
		
		If BufferLength < cbNeedenBufferLength Then
			SetLastError(ERROR_INSUFFICIENT_BUFFER)
			Return False
		End If
	End Scope
	
	Scope
		
		Dim BufferIndex As Integer = 0
		
		For OriginalIndex As Integer = 0 To SafeLength - 1
			Dim Number As Integer = HtmlSafe[OriginalIndex]
			
			Select Case Number
				Case Is < 32
					
				Case QuotationMarkChar
					' Заменить на &quot;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h71  ' q
					Buffer[BufferIndex + 2] = &h75  ' u
					Buffer[BufferIndex + 3] = &h6f  ' o
					Buffer[BufferIndex + 4] = &h74  ' t
					Buffer[BufferIndex + 5] = SemicolonChar  ' ;
					BufferIndex += MaxQuotationMarkSafeStringLength
					
				Case AmpersandChar
					' Заменить на &amp;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h61  ' a
					Buffer[BufferIndex + 2] = &h6d  ' m
					Buffer[BufferIndex + 3] = &h70  ' p
					Buffer[BufferIndex + 4] = SemicolonChar  ' ;
					BufferIndex += MaxAmpersandSafeStringLength
					
				Case ApostropheChar
					' Заменить на &apos;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h61  ' a
					Buffer[BufferIndex + 2] = &h70  ' p
					Buffer[BufferIndex + 3] = &h6f  ' o
					Buffer[BufferIndex + 4] = &h73  ' s
					Buffer[BufferIndex + 5] = SemicolonChar  ' ;
					BufferIndex += MaxApostropheSafeStringLength
					
				Case LessThanSignChar
					' Заменить на &lt;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h6c  ' l
					Buffer[BufferIndex + 2] = &h74  ' t
					Buffer[BufferIndex + 3] = SemicolonChar  ' ;
					BufferIndex += MaxLessThanSignSafeStringLength
					
				Case GreaterThanSign
					' Заменить на &gt;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h67  ' g
					Buffer[BufferIndex + 2] = &h74  ' t
					Buffer[BufferIndex + 3] = SemicolonChar  ' ;
					BufferIndex += MaxGreaterThanSignSafeStringLength
					
				Case Else
					Buffer[BufferIndex] = Number
					BufferIndex += 1
					
			End Select
			
		Next
		
		' Завершающий нулевой символ
		Buffer[BufferIndex] = 0
		SetLastError(ERROR_SUCCESS)
		Return True
	End Scope
End Function

Function GetDocumentCharset( _
		ByVal bytes As ZString Ptr _
	)As DocumentCharsets
	
	If bytes[0] = 239 AndAlso bytes[1] = 187 AndAlso bytes[2] = 191 Then
		Return DocumentCharsets.Utf8BOM
	End If
	
	If bytes[0] = 255 AndAlso bytes[1] = 254 Then
		Return DocumentCharsets.Utf16LE
	End If
	
	If bytes[0] = 254 AndAlso bytes[1] = 255 Then
		Return DocumentCharsets.Utf16BE
	End If
	
	Return DocumentCharsets.ASCII
End Function

Sub GetHttpDate( _
		ByVal Buffer As WString Ptr, _
		ByVal dt As SYSTEMTIME Ptr _
	)
	' Tue, 15 Nov 1994 12:45:26 GMT
	Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, dt, @DateFormatString, Buffer, 31) - 1
	GetTimeFormat(LOCALE_INVARIANT, 0, dt, @TimeFormatString, @Buffer[dtBufferLength], 31 - dtBufferLength)
End Sub

Sub GetHttpDate(ByVal Buffer As WString Ptr)
	Dim dt As SYSTEMTIME = Any
	GetSystemTime(@dt)
	GetHttpDate(Buffer, @dt)
End Sub

Function FindCrLfA( _
		ByVal Buffer As ZString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal Start As Integer, _
		ByVal pFindedIndex As Integer Ptr _
	)As Boolean
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = Start To BufferLength - 2
		If Buffer[i] = 13 AndAlso Buffer[i + 1] = 10 Then
			*pFindedIndex = i
			Return True
		End If
	Next
	*pFindedIndex = 0
	Return False
End Function

Function FindCrLfW( _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal Start As Integer, _
		ByVal pFindedIndex As Integer Ptr _
	)As Boolean
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = Start To BufferLength - 2
		If Buffer[i] = 13 AndAlso Buffer[i + 1] = 10 Then
			*pFindedIndex = i
			Return True
		End If
	Next
	*pFindedIndex = 0
	Return False
End Function

Function HttpAuthUtil( _
		ByVal state As ReadHeadersResult Ptr, _
		ByVal ClientSocket As SOCKET, _
		ByVal www As SimpleWebSite Ptr,  _
		ByVal ProxyAuthorization As Boolean _
	)As Boolean
	
	Dim intHttpAuth As HttpAuthResult = state->HttpAuth(www, ProxyAuthorization)
	If intHttpAuth <> HttpAuthResult.Success Then
		
		Select Case intHttpAuth
			Case HttpAuthResult.NeedAuth
				WriteHttpNeedAuthenticate(state, ClientSocket, www)
				
			Case HttpAuthResult.BadAuth
				WriteHttpBadAuthenticateParam(state, ClientSocket, www)
				
			Case HttpAuthResult.NeedBasicAuth
				WriteHttpNeedBasicAuthenticate(state, ClientSocket, www)
				
			Case HttpAuthResult.EmptyPassword
				WriteHttpEmptyPassword(state, ClientSocket, www)
				
			Case HttpAuthResult.BadUserNamePassword
				WriteHttpBadUserNamePassword(state, ClientSocket, www)
				
		End Select
		
		Return False
	End If
	
	Return True
End Function

Sub GetETag( _
		ByVal wETag As WString Ptr, _
		ByVal pDateLastFileModified As FILETIME Ptr, _
		ByVal ResponseZipMode As ZipModes _
	)
	
	lstrcpy(wETag, @QuoteString)
	
	Dim ul As ULARGE_INTEGER = Any
	With ul
		.LowPart = pDateLastFileModified->dwLowDateTime
		.HighPart = pDateLastFileModified->dwHighDateTime
	End With
	
	ui64tow(ul.QuadPart, wETag[1], 10)
	
	Select Case ResponseZipMode
		Case ZipModes.GZip
			lstrcat(wETag, @GzipString)
			
		Case ZipModes.Deflate
			lstrcat(wETag, @DeflateString)
			
	End Select
	
	lstrcat(wETag, @QuoteString)
End Sub

Sub MakeContentRangeHeader( _
		ByVal wHeader As WString Ptr, _
		ByVal FirstBytePosition As ULongInt, _
		ByVal LastBytePosition As ULongInt, _
		ByVal TotalLength As ULongInt _
	)
	
	'Content-Range: bytes 88080384-160993791/160993792
	
	Dim HeaderContentRangeAppend As ArrayStringWriter = Any
	Dim HeaderContentRangeAppendVirtualTable As ITextWriterVirtualTable = Any
	InitializeArrayStringWriter(@HeaderContentRangeAppend, @HeaderContentRangeAppendVirtualTable, wHeader, WebResponse.MaxResponseHeaderBuffer)
	
	Dim pWriter As ITextWriter Ptr = CPtr(ITextWriter Ptr, @HeaderContentRangeAppend)
	
	pWriter->pVirtualTable->WriteLengthString(pWriter, "bytes ", 6)
	
	pWriter->pVirtualTable->WriteUInt64(pWriter, FirstBytePosition)
	pWriter->pVirtualTable->WriteChar(pWriter, HyphenMinusChar)
	
	pWriter->pVirtualTable->WriteUInt64(pWriter, LastBytePosition)
	pWriter->pVirtualTable->WriteChar(pWriter, SolidusChar)
	
	pWriter->pVirtualTable->WriteUInt64(pWriter, TotalLength)
End Sub
