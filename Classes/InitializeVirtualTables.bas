#include "InitializeVirtualTables.bi"
#include "ArrayStringWriter.bi"
#include "Configuration.bi"
#include "NetworkStream.bi"
#include "ServerState.bi"

Common Shared GlobalArrayStringWriterTextWriterVirtualTable As ITextWriterVirtualTable
Common Shared GlobalArrayStringWriterStringableVirtualTable As IStringableVirtualTable
Common Shared GlobalConfigurationVirtualTable As IConfigurationVirtualTable
Common Shared GlobalNetworkStreamVirtualTable As INetworkStreamVirtualTable
Common Shared GlobalServerStateVirtualTable As IServerStateVirtualTable

Sub InitializeVirtualTables()
	
	' ArrayStringWriter
	GlobalArrayStringWriterTextWriterVirtualTable.InheritedTable.QueryInterface = @ArrayStringWriterTextWriterQueryInterface
	GlobalArrayStringWriterTextWriterVirtualTable.InheritedTable.AddRef = @ArrayStringWriterTextWriterAddRef
	GlobalArrayStringWriterTextWriterVirtualTable.InheritedTable.Release = @ArrayStringWriterTextWriterRelease
	GlobalArrayStringWriterTextWriterVirtualTable.CloseTextWriter = @ArrayStringWriterCloseTextWriter
	GlobalArrayStringWriterTextWriterVirtualTable.OpenTextWriter = @ArrayStringWriterCloseTextWriter
	GlobalArrayStringWriterTextWriterVirtualTable.Flush = @ArrayStringWriterCloseTextWriter
	GlobalArrayStringWriterTextWriterVirtualTable.GetCodePage = @ArrayStringWriterGetCodePage
	GlobalArrayStringWriterTextWriterVirtualTable.SetCodePage = @ArrayStringWriterSetCodePage
	GlobalArrayStringWriterTextWriterVirtualTable.WriteNewLine = @ArrayStringWriterWriteNewLine
	GlobalArrayStringWriterTextWriterVirtualTable.WriteStringLine = @ArrayStringWriterWriteStringLine
	GlobalArrayStringWriterTextWriterVirtualTable.WriteLengthStringLine = @ArrayStringWriterWriteLengthStringLine
	GlobalArrayStringWriterTextWriterVirtualTable.WriteString = @ArrayStringWriterWriteString
	GlobalArrayStringWriterTextWriterVirtualTable.WriteLengthString = @ArrayStringWriterWriteLengthString
	GlobalArrayStringWriterTextWriterVirtualTable.WriteChar = @ArrayStringWriterWriteChar
	GlobalArrayStringWriterTextWriterVirtualTable.WriteInt32 = @ArrayStringWriterWriteInt32
	GlobalArrayStringWriterTextWriterVirtualTable.WriteInt64 = @ArrayStringWriterWriteInt64
	GlobalArrayStringWriterTextWriterVirtualTable.WriteUInt64 = @ArrayStringWriterWriteUInt64
	GlobalArrayStringWriterStringableVirtualTable.InheritedTable.QueryInterface = @ArrayStringWriterStringableQueryInterface
	GlobalArrayStringWriterStringableVirtualTable.InheritedTable.AddRef = @ArrayStringWriterStringableAddRef
	GlobalArrayStringWriterStringableVirtualTable.InheritedTable.Release = @ArrayStringWriterStringableRelease
	GlobalArrayStringWriterStringableVirtualTable.ToString = @ArrayStringWriterStringableToString
	
	' Configuration
	GlobalConfigurationVirtualTable.InheritedTable.QueryInterface = @ConfigurationQueryInterface
	GlobalConfigurationVirtualTable.InheritedTable.AddRef = @ConfigurationAddRef
	GlobalConfigurationVirtualTable.InheritedTable.Release = @ConfigurationRelease
	GlobalConfigurationVirtualTable.SetIniFilename = @ConfigurationSetIniFilename
	GlobalConfigurationVirtualTable.GetStringValue = @ConfigurationGetStringValue
	GlobalConfigurationVirtualTable.GetIntegerValue = @ConfigurationGetIntegerValue
	GlobalConfigurationVirtualTable.GetAllSections = @ConfigurationGetAllSections
	GlobalConfigurationVirtualTable.GetAllKeys = @ConfigurationGetAllKeys
	GlobalConfigurationVirtualTable.SetStringValue = @ConfigurationSetStringValue
	
	' NetworkStream
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.QueryInterface = @NetworkStreamQueryInterface
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.AddRef = @NetworkStreamAddRef
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.Release = @NetworkStreamRelease
	GlobalNetworkStreamVirtualTable.InheritedTable.CanRead = @NetworkStreamCanRead
	GlobalNetworkStreamVirtualTable.InheritedTable.CanSeek = @NetworkStreamCanSeek
	GlobalNetworkStreamVirtualTable.InheritedTable.CanWrite = @NetworkStreamCanWrite
	GlobalNetworkStreamVirtualTable.InheritedTable.CloseStream = @NetworkStreamCloseStream
	GlobalNetworkStreamVirtualTable.InheritedTable.Flush = @NetworkStreamFlush
	GlobalNetworkStreamVirtualTable.InheritedTable.GetLength = @NetworkStreamGetLength
	GlobalNetworkStreamVirtualTable.InheritedTable.OpenStream = @NetworkStreamOpenStream
	GlobalNetworkStreamVirtualTable.InheritedTable.Position = @NetworkStreamPosition
	GlobalNetworkStreamVirtualTable.InheritedTable.Read = @NetworkStreamRead
	GlobalNetworkStreamVirtualTable.InheritedTable.Seek = @NetworkStreamSeek
	GlobalNetworkStreamVirtualTable.InheritedTable.SetLength = @NetworkStreamSetLength
	GlobalNetworkStreamVirtualTable.InheritedTable.Write = @NetworkStreamWrite
	GlobalNetworkStreamVirtualTable.GetSocket = @NetworkStreamGetSocket
	GlobalNetworkStreamVirtualTable.SetSocket = @NetworkStreamSetSocket
	
	' ServerState
	GlobalServerStateVirtualTable.InheritedTable.QueryInterface = 0
	GlobalServerStateVirtualTable.InheritedTable.Addref = 0
	GlobalServerStateVirtualTable.InheritedTable.Release = 0
	GlobalServerStateVirtualTable.GetRequestHeader = @ServerStateDllCgiGetRequestHeader
	GlobalServerStateVirtualTable.GetHttpMethod = @ServerStateDllCgiGetHttpMethod
	GlobalServerStateVirtualTable.GetHttpVersion = @ServerStateDllCgiGetHttpVersion
	GlobalServerStateVirtualTable.SetStatusCode = @ServerStateDllCgiSetStatusCode
	GlobalServerStateVirtualTable.SetStatusDescription = @ServerStateDllCgiSetStatusDescription
	GlobalServerStateVirtualTable.SetResponseHeader = @ServerStateDllCgiSetResponseHeader
	GlobalServerStateVirtualTable.WriteData = @ServerStateDllCgiWriteData
	GlobalServerStateVirtualTable.ReadData = @ServerStateDllCgiReadData
	GlobalServerStateVirtualTable.GetHtmlSafeString = @ServerStateDllCgiGetHtmlSafeString
	
End Sub
