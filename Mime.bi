#ifndef MIME_BI
#define MIME_BI

' Размер буфера для записи в него типа документа
Const MaxContentTypeLength As Integer = 128 - 1

' Миме‐типы
' При добавлении нового типа необходимо изменять функцию GetStringOfContentType чтобы не было неопределённого поведения
Enum ContentTypes
	None
	
	' Изображения
	ImageGif
	ImageJpeg
	ImagePjpeg
	ImagePng
	ImageSvg
	ImageTiff
	ImageIco
	ImageWbmp
	ImageWebp
	
	' Текст
	TextCmd
	TextCss
	TextCsv
	TextHtml
	TextPlain
	TextPhp
	TextXml
	
	' Xml как текст
	ApplicationXml
	ApplicationXmlXslt
	ApplicationXhtml
	ApplicationAtom
	ApplicationRssXml
	ApplicationJavascript
	ApplicationXJavascript
	ApplicationJson
	ApplicationSoapxml
	ApplicationXmldtd
	
	' Архивы
	Application7z
	ApplicationRar
	ApplicationZip
	ApplicationGzip
	ApplicationXCompressed
	
	' Документы
	ApplicationRtf
	ApplicationPdf
	ApplicationOpenDocumentText
	ApplicationOpenDocumentTextTemplate
	ApplicationOpenDocumentGraphics
	ApplicationOpenDocumentGraphicsTemplate
	ApplicationOpenDocumentPresentation
	ApplicationOpenDocumentPresentationTemplate
	ApplicationOpenDocumentSpreadsheet
	ApplicationOpenDocumentSpreadsheetTemplate
	ApplicationOpenDocumentChart
	ApplicationOpenDocumentChartTemplate
	ApplicationOpenDocumentImage
	ApplicationOpenDocumentImageTemplate
	ApplicationOpenDocumentFormula
	ApplicationOpenDocumentFormulaTemplate
	ApplicationOpenDocumentMaster
	ApplicationOpenDocumentWeb
	ApplicationVndmsexcel
	ApplicationVndopenxmlformatsofficedocumentspreadsheetmlsheet
	ApplicationVndmspowerpoint
	ApplicationVndopenxmlformatsofficedocumentpresentationmlpresentation
	ApplicationMsword
	ApplicationVndopenxmlformatsofficedocumentwordprocessingmldocument
	ApplicationFontwoff
	ApplicationXfontttf
	
	' Аудио
	AudioBasic
	AudioL24
	AudioMp4
	AudioAac
	AudioMpeg
	AudioOgg
	AudioVorbis
	AudioXmswma
	AudioXmswax
	AudioRealaudio
	AudioVndwave
	AudioWebm
	
	' Видео
	VideoMpeg
	VideoOgg
	VideoMp4
	VideoQuicktime
	VideoWebm
	VideoXmswmv
	VideoXflv
	Video3gpp
	Video3gpp2
	
	' Сообщения
	MessageHttp
	MessageImdnxml
	MessagePartial
	MessageRfc822
	
	' Данные формы
	MultipartMixed
	MultipartAlternative
	MultipartRelated
	MultipartFormdata
	MultipartSigned
	MultipartEncrypted
	ApplicationXwwwformurlencoded
	
	ApplicationFlash
	
	ApplicationOctetStream
	ApplicationXbittorrent
	ApplicationOgg
	
	ApplicationCertx509
End Enum

Declare Function ContentTypeToString( _
	ByVal ContentType As ContentTypes _
)As WString Ptr

Type MimeType
	Dim ContentType As ContentTypes
	Dim IsTextFormat As Boolean
End Type

Declare Function GetMimeOfFileExtension( _
	ByVal mt As MimeType Ptr, _
	ByVal ext As WString Ptr _
)As Boolean

' TODO Реализовать функцию, возвращающую тип документа в зависимости от миме‐типа
Declare Function GetMimeOfContentType( _
	ByVal mt As MimeType Ptr, _
	ByVal ContentType As WString Ptr _
)As Boolean

#endif
