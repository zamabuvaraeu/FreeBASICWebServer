#include "WriteHttpError.bi"
#include "WebUtils.bi"
#include "IntegerToWString.bi"
#include "ArrayStringWriter.bi"

' TODO Описания ошибок перевести на эсперанто

' Размер буфера в символах для записи в него кода html страницы с ошибкой
Const MaxHttpErrorBuffer As Integer = 16 * 1024 - 1

Const DefaultContentLanguage = "ru"
Const HttpErrorHead1 = "<!DOCTYPE html><html xmlns=""http://www.w3.org/1999/xhtml""><head><meta name=""viewport"" content=""width=device-width, initial-scale=1"" /><title>"
Const HttpErrorHead2 = "</title></head>"
Const HttpErrorBody1 = "<body><h1>"
Const HttpErrorBody3 = "</h1><h2>Код ответа HTTP "
Const HttpErrorBody4 = " — "
Const HttpErrorBody5 = "</h2><p>"
Const HttpErrorBody6 = "</p><p>Посетить <a href=""/"">главную страницу</a> сайта.</p></body></html>"

Const ClientCreatedString = "Ресурс создан"
Const ClientMovedString = "Ресурс перенаправлен"
Const ClientErrorString = "Клиентская ошибка"
Const ServerErrorString = "Серверная ошибка"
Const HttpErrorBody2 = " в приложении "

' TODO Исправить для ошибок HttpCreated и HttpCreatedUpdated, которые на самом деле не ошибки
Const HttpCreated201_1 = "Ресурс успешно создан."
Const HttpCreated201_2 = "Ресурс успешно обновлён."

Const HttpError400BadRequest = "Что за чушь ты несёшь?! Язык без костей — что хочет то и лопочет."
Const HttpError400BadPath = "Что за чушь ты запрашиваешь?! Язык без костей — что хочет, то и лопочет? Убирайся‐ка отсюда подобру‐поздорову, холоп."
Const HttpError400Host = "Холоп, при обращении к благородным господам этикет требует вежливо указывать заголовок Host."
Const HttpError403Forbidden = "У тебя нет привилегий доступа к этому файлу, простолюдин. Файлы такого типа предназначены только для благородных господ, а ты, как я вижу, простой холоп."
Const HttpError404FileNotFound = "Запрошенный тобою файл — это несуществующая, смешная и глупая фантазия. Отправляйся‐ка восвояси, холоп, и не докучай благородных господ своими вздорными просьбами."
Const HttpError405NotAllowed = "Метод не применим к такому файлу."
Const HttpError410Gone = "По указанию благородных господ я удалил файл насовсем. Полностью. Он никогда не будет найден. А тебе, холоп, я приказываю удалить все ссылки на него. И больше не ходить по этому адресу."
Const HttpError411LengthRequired = "Холоп, когда ты мне отправляешь данные, то тебе следует вежливо указывать длину тела запроса."
Const HttpError413RequestEntityTooLarge = "Холоп, длина тела запроса слишком большая. Не утомляй благородных господ просьбами длиннее 4194304 байт."
Const HttpError414RequestUrlTooLarge = "Холоп, длина URL слишком большая. Больше не утомляй благородных господ досужими URL."
Const HttpError431RequestRequestHeaderFieldsTooLarge = "Холоп, длина заголовков слишком большая. Больше не утомляй благородных господ досужими заголовками."

Const HttpError500InternalServerError = "Внутренняя ошибка сервера."
Const HttpError500FileNotAvailable = "В данный момент слуги не могут получить доступ к файлу, так как его обрабатывают слуги по приказу благородных господ."
Const HttpError500CannotCreateChildProcess = "Не могу создать дочерний процесс."
Const HttpError500CannotCreatePipe = "Не могу создать трубу для чтения и записи данных дочернего процесса."
Const HttpError501NotImplemented = "Благородные господы не хотят содержать крепостных, которые бы обрабатывали этот метод. Отправляйся‐ка восвояси."
Const HttpError501ContentTypeEmpty = "Холоп, ты не указал тип содержимого. Элементарная вежливость требует указывать что ты отправляешь на сервер."
Const HttpError501ContentEncoding = "Холоп, больше не отправляй сжатое содержимое. Благородные господы не хотят содержать крепостных, разжимающих твои смешные данные."
Const HttpError502BadGateway = "Удалённый сервер не отвечает."
Const HttpError503ThreadError = "Внутренняя ошибка сервера: не могу создать поток для обработки запроса."
Const HttpError503Memory = "В данный момент все крепостные заняты выполнением запросов, куча переполнена."
Const HttpError504GatewayTimeout = "Не могу соединиться с удалённым сервером"
Const HttpError505VersionNotSupported = "Холоп, ты используешь версию протокола, которую я не поддерживаю. Благородные господы поддерживают только версии HTTP/1.0 и HTTP/1.1."

Const NeedUsernamePasswordString = "Требуется логин и пароль для доступа"
Const NeedUsernamePasswordString1 = "Параметры авторизации неверны"
Const NeedUsernamePasswordString2 = "Требуется Basic‐авторизация"
Const NeedUsernamePasswordString3 = "Пароль не может быть пустым"

Const MovedPermanently = "Ресурс перекатился на другой адрес."

Const DefaultHeaderWwwAuthenticate = "Basic realm=""Need username and password"""
Const DefaultHeaderWwwAuthenticate1 = "Basic realm=""Authorization"""
Const DefaultHeaderWwwAuthenticate2 = "Basic realm=""Use Basic auth"""

Declare Sub WriteHttpResponse( _
	ByVal pState As ReadHeadersResult Ptr, _
	ByVal pStream As IBaseStream Ptr, _
	ByVal pWebSite As SimpleWebSite Ptr, _
	ByVal BodyText As WString Ptr _
)

Declare Sub FormatErrorMessageBody( _
	ByVal pIWriter As ITextWriter Ptr, _
	ByVal StatusCode As Integer, _
	ByVal VirtualPath As WString Ptr, _
	ByVal strMessage As WString Ptr _
)

Sub WriteMovedPermanently( _
		ByVal state As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal www As SimpleWebSite Ptr _
	)
	
	state->ServerResponse.StatusCode = 301
	Dim buf As WString * (URI.MaxUrlLength * 2 + 1) = Any
	lstrcpy(@buf, www->MovedUrl)
	lstrcat(@buf, state->ClientRequest.ClientURI.Url)
	state->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderLocation) = @buf
	
	WriteHttpResponse(state, pStream, www, @MovedPermanently)
End Sub

Sub WriteHttpBadRequest( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 400
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError400BadRequest)
End Sub

Sub WriteHttpPathNotValid( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 400
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError400BadPath)
End Sub

Sub WriteHttpHostNotFound( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 400
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError400Host)
End Sub

Sub WriteHttpNeedAuthenticate( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderWwwAuthenticate) = @DefaultHeaderWwwAuthenticate
	pState->ServerResponse.StatusCode = 401
	WriteHttpResponse(pState, pStream, pWebSite, @NeedUsernamePasswordString)
End Sub

Sub WriteHttpBadAuthenticateParam( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderWwwAuthenticate) = @DefaultHeaderWwwAuthenticate1
	pState->ServerResponse.StatusCode = 401
	WriteHttpResponse(pState, pStream, pWebSite, @NeedUsernamePasswordString1)
End Sub

Sub WriteHttpNeedBasicAuthenticate( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderWwwAuthenticate) = @DefaultHeaderWwwAuthenticate2
	pState->ServerResponse.StatusCode = 401
	WriteHttpResponse(pState, pStream, pWebSite, @NeedUsernamePasswordString2)
End Sub

Sub WriteHttpEmptyPassword( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderWwwAuthenticate) = @DefaultHeaderWwwAuthenticate
	pState->ServerResponse.StatusCode = 401
	WriteHttpResponse(pState, pStream, pWebSite, @NeedUsernamePasswordString3)
End Sub

Sub WriteHttpBadUserNamePassword( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderWwwAuthenticate) = @DefaultHeaderWwwAuthenticate
	pState->ServerResponse.StatusCode = 401
	WriteHttpResponse(pState, pStream, pWebSite, @NeedUsernamePasswordString)
End Sub

Sub WriteHttpForbidden( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 403
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError403Forbidden)
End Sub

Sub WriteHttpFileNotFound( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 404
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError404FileNotFound)
End Sub

Sub WriteHttpMethodNotAllowed( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 405
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError405NotAllowed)
End Sub

Sub WriteHttpFileGone( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 410
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError410Gone)
End Sub

Sub WriteHttpLengthRequired( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 411
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError411LengthRequired)
End Sub

Sub WriteHttpRequestEntityTooLarge( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 413
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError413RequestEntityTooLarge)
End Sub

Sub WriteHttpRequestUrlTooLarge( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 414
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError414RequestUrlTooLarge)
End Sub

Sub WriteHttpRequestHeaderFieldsTooLarge( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 431
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError431RequestRequestHeaderFieldsTooLarge)
End Sub

Sub WriteHttpInternalServerError( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 500
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError500InternalServerError)
End Sub

Sub WriteHttpFileNotAvailable( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 500
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError500FileNotAvailable)
End Sub

Sub WriteHttpCannotCreateChildProcess( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 500
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError500CannotCreateChildProcess)
End Sub

Sub WriteHttpCannotCreatePipe( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 500
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError500CannotCreatePipe)
End Sub

Sub WriteHttpNotImplemented( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 501
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError501NotImplemented)
End Sub

Sub WriteHttpContentTypeEmpty( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 501
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError501ContentTypeEmpty)
End Sub

Sub WriteHttpContentEncodingNotEmpty( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 501
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError501ContentEncoding)
End Sub

Sub WriteHttpBadGateway( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 502
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError502BadGateway)
End Sub

Sub WriteHttpNotEnoughMemory( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 503
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderRetryAfter) = @"Retry-After: 300"
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError503Memory)
End Sub

Sub WriteHttpCannotCreateThread( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 503
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderRetryAfter) = @"Retry-After: 300"
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError503ThreadError)
End Sub

Sub WriteHttpGatewayTimeout( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 504
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError504GatewayTimeout)
End Sub

Sub WriteHttpVersionNotSupported( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	pState->ServerResponse.StatusCode = 505
	WriteHttpResponse(pState, pStream, pWebSite, @HttpError505VersionNotSupported)
End Sub

Sub WriteHttpCreated( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr _
	)
	
	Dim strMessage As WString Ptr = Any
	If pState->ServerResponse.StatusCode = 201 Then
		strMessage = @HttpCreated201_1
	Else
		strMessage = @HttpCreated201_2
	End If
	WriteHttpResponse(pState, pStream, pWebSite, strMessage)
End Sub

Sub WriteHttpResponse( _
		ByVal pState As ReadHeadersResult Ptr, _
		ByVal pStream As IBaseStream Ptr, _
		ByVal pWebSite As SimpleWebSite Ptr, _
		ByVal BodyText As WString Ptr _
	)
	pState->ServerResponse.Mime.ContentType = ContentTypes.TextHtml
	pState->ServerResponse.Mime.IsTextFormat = True
	pState->ServerResponse.Mime.Charset = DocumentCharsets.Utf8BOM
	
	pState->ClientRequest.KeepAlive = False
	pState->ServerResponse.ResponseHeaders(HttpResponseHeaders.HeaderContentLanguage) = @DefaultContentLanguage
	
	Dim BodyWriter As ArrayStringWriter = Any
	Dim pIWriter As ITextWriter Ptr = CPtr(ITextWriter Ptr, New(@BodyWriter) ArrayStringWriter())
	
	Scope
		Dim VirtualPath As WString Ptr = Any
		If pWebSite = 0 Then
			VirtualPath = @DefaultVirtualPath
		Else
			VirtualPath = pWebSite->VirtualPath
		End If
		FormatErrorMessageBody(pIWriter, pState->ServerResponse.StatusCode, VirtualPath, BodyText)
	End Scope
	
	Dim pIToString As IStringable Ptr = Any
	pIWriter->pVirtualTable->InheritedTable.QueryInterface(pIWriter, @IID_ISTRINGABLE, @pIToString)
	
	Dim BodyBuffer As WString Ptr = Any
	pIToString->pVirtualTable->ToString(pIToString, @BodyBuffer)
	
	Dim Utf8Body As ZString * (WebResponse.MaxResponseHeaderBuffer + 1) = Any
	Dim ContentBodyLength As Integer = WideCharToMultiByte( _
		CP_UTF8, _
		0, _
		BodyBuffer, _
		-1, _
		@Utf8Body, _
		WebResponse.MaxResponseHeaderBuffer + 1, _
		0, _
		0 _
	) - 1
	
	pIToString->pVirtualTable->InheritedTable.Release(pIToString)
	
	Dim SendBuffer As ZString * (WebResponse.MaxResponseHeaderBuffer * 2 + 1) = Any
	Dim SendBufferLength As Integer = pState->AllResponseHeadersToBytes(@SendBuffer, ContentBodyLength)
	
	RtlCopyMemory(@SendBuffer + SendBufferLength, @Utf8Body, ContentBodyLength)
	SendBufferLength += ContentBodyLength
	
	Dim BytesWrited As Integer = Any
	pStream->pVirtualTable->Write(pStream, @SendBuffer, 0, SendBufferLength, @BytesWrited)
	
End Sub

Sub FormatErrorMessageBody( _
		ByVal pIWriter As ITextWriter Ptr, _
		ByVal StatusCode As Integer, _
		ByVal VirtualPath As WString Ptr, _
		ByVal BodyText As WString Ptr _
	)
	
	Dim DescriptionBuffer As WString Ptr = GetStatusDescription(StatusCode, 0)
	
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorHead1)
	pIWriter->pVirtualTable->WriteString(pIWriter, DescriptionBuffer)
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorHead2)
	
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody1)
	
	' Заголовок <h1>
	Select Case StatusCode
		Case 200 To 299
			pIWriter->pVirtualTable->WriteString(pIWriter, ClientCreatedString)
			
		Case 300 To 399
			pIWriter->pVirtualTable->WriteString(pIWriter, ClientMovedString)
			
		Case 400 To 499
			pIWriter->pVirtualTable->WriteString(pIWriter, ClientErrorString)
			
		Case 500 To 599
			pIWriter->pVirtualTable->WriteString(pIWriter, ServerErrorString)
			
	End Select
	
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody2)
	
	' Имя приложения в заголовке <h1>
	pIWriter->pVirtualTable->WriteString(pIWriter, VirtualPath)
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody3)
	
	' Код статуса в заголовке <h2>
	pIWriter->pVirtualTable->WriteInt32(pIWriter, StatusCode)
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody4)
	
	' Описание ошибки в заголовке <h2>
	pIWriter->pVirtualTable->WriteString(pIWriter, DescriptionBuffer)
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody5)
	
	' Текст сообщения между <p></p>
	pIWriter->pVirtualTable->WriteString(pIWriter, BodyText)
	pIWriter->pVirtualTable->WriteString(pIWriter, HttpErrorBody6)
	
End Sub
