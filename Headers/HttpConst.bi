#ifndef HTTPCONST_BI
#define HTTPCONST_BI

Const BytesString = WStr("bytes")
Const BytesStringWithSpace = WStr("bytes ")
Const BytesStringWithSpaceLength As Integer = 6
Const CloseString = WStr("Close")
Const GzipString = WStr("gzip")
Const DeflateString = WStr("deflate")
Const HeadersExtensionString = WStr(".headers")
Const FileGoneExtension = WStr(".410")
Const KeepAliveString = WStr("Keep-Alive")
Const QuoteString = WStr("""")
Const BasicAuthorization = WStr("Basic")
Const WebSocketGuidString = WStr("258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
Const UpgradeString = WStr("Upgrade")
Const WebSocketString = WStr("websocket")
Const WebSocketVersionString = WStr("13")

Const DefaultVirtualPath = WStr("/")

' ������������ ������ ����������� �� ������� ���� �������
' TODO ������� � ������������ ����������� �� ������������ ������ ���� �������
Const MaxRequestBodyContentLength As LongInt = 20 * 1024 * 1024

#endif
