#include "InitializeVirtualTables.bi"
#include "ArrayStringWriter.bi"
#include "Configuration.bi"
#include "HttpReader.bi"
#include "NetworkStream.bi"
#include "RequestedFile.bi"
#include "ServerState.bi"
#include "WebServer.bi"
#include "WebSite.bi"
#include "WebSiteContainer.bi"

Common Shared GlobalArrayStringWriterVirtualTable As IArrayStringWriterVirtualTable
Common Shared GlobalConfigurationVirtualTable As IConfigurationVirtualTable
Common Shared GlobalHttpReaderVirtualTable As IHttpReaderVirtualTable
Common Shared GlobalNetworkStreamVirtualTable As INetworkStreamVirtualTable
Common Shared GlobalRequestedFileVirtualTable As IRequestedFileVirtualTable
Common Shared GlobalRequestedFileSendableVirtualTable As ISendableVirtualTable
Common Shared GlobalServerStateVirtualTable As IServerStateVirtualTable
Common Shared GlobalWebServerVirtualTable As IRunnableVirtualTable
Common Shared GlobalWebSiteVirtualTable As IWebSiteVirtualTable
Common Shared GlobalWebSiteContainerVirtualTable As IWebSiteContainerVirtualTable

Sub InitializeVirtualTables()
	
	' ArrayStringWriter
	GlobalArrayStringWriterVirtualTable.InheritedTable.InheritedTable.QueryInterface = CPtr(Any Ptr, @ArrayStringWriterQueryInterface)
	GlobalArrayStringWriterVirtualTable.InheritedTable.InheritedTable.AddRef = Cast(Any Ptr, @ArrayStringWriterAddRef)
	GlobalArrayStringWriterVirtualTable.InheritedTable.InheritedTable.Release = Cast(Any Ptr, @ArrayStringWriterRelease)
	GlobalArrayStringWriterVirtualTable.InheritedTable.CloseTextWriter = Cast(Any Ptr, @ArrayStringWriterCloseTextWriter)
	GlobalArrayStringWriterVirtualTable.InheritedTable.OpenTextWriter = Cast(Any Ptr, @ArrayStringWriterCloseTextWriter)
	GlobalArrayStringWriterVirtualTable.InheritedTable.Flush = Cast(Any Ptr, @ArrayStringWriterCloseTextWriter)
	GlobalArrayStringWriterVirtualTable.InheritedTable.GetCodePage = Cast(Any Ptr, @ArrayStringWriterGetCodePage)
	GlobalArrayStringWriterVirtualTable.InheritedTable.SetCodePage = Cast(Any Ptr, @ArrayStringWriterSetCodePage)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteNewLine = Cast(Any Ptr, @ArrayStringWriterWriteNewLine)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteStringLine = Cast(Any Ptr, @ArrayStringWriterWriteStringLine)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteLengthStringLine = Cast(Any Ptr, @ArrayStringWriterWriteLengthStringLine)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteString = Cast(Any Ptr, @ArrayStringWriterWriteString)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteLengthString = Cast(Any Ptr, @ArrayStringWriterWriteLengthString)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteChar = Cast(Any Ptr, @ArrayStringWriterWriteChar)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteInt32 = Cast(Any Ptr, @ArrayStringWriterWriteInt32)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteInt64 = Cast(Any Ptr, @ArrayStringWriterWriteInt64)
	GlobalArrayStringWriterVirtualTable.InheritedTable.WriteUInt64 = Cast(Any Ptr, @ArrayStringWriterWriteUInt64)
	GlobalArrayStringWriterVirtualTable.SetBuffer = Cast(Any Ptr, @ArrayStringWriterSetBuffer)
	
	' Configuration
	GlobalConfigurationVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, @ConfigurationQueryInterface)
	GlobalConfigurationVirtualTable.InheritedTable.AddRef = Cast(Any Ptr, @ConfigurationAddRef)
	GlobalConfigurationVirtualTable.InheritedTable.Release = Cast(Any Ptr, @ConfigurationRelease)
	GlobalConfigurationVirtualTable.SetIniFilename = Cast(Any Ptr, @ConfigurationSetIniFilename)
	GlobalConfigurationVirtualTable.GetStringValue = Cast(Any Ptr, @ConfigurationGetStringValue)
	GlobalConfigurationVirtualTable.GetIntegerValue = Cast(Any Ptr, @ConfigurationGetIntegerValue)
	GlobalConfigurationVirtualTable.GetAllSections = Cast(Any Ptr, @ConfigurationGetAllSections)
	GlobalConfigurationVirtualTable.GetAllKeys = Cast(Any Ptr, @ConfigurationGetAllKeys)
	GlobalConfigurationVirtualTable.SetStringValue = Cast(Any Ptr, @ConfigurationSetStringValue)
	
	' TODO HttpReader
	GlobalHttpReaderVirtualTable.InheritedTable.InheritedTable.QueryInterface = Cast(Any Ptr, @HttpReaderQueryInterface)
	GlobalHttpReaderVirtualTable.InheritedTable.InheritedTable.QueryInterface = Cast(Any Ptr, @HttpReaderAddRef)
	GlobalHttpReaderVirtualTable.InheritedTable.InheritedTable.QueryInterface = Cast(Any Ptr, @HttpReaderRelease)
	GlobalHttpReaderVirtualTable.InheritedTable.CloseTextReader = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.InheritedTable.OpenTextReader = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.InheritedTable.Peek = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.InheritedTable.ReadChar = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.InheritedTable.ReadCharArray = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.InheritedTable.ReadLine = Cast(Any Ptr, @HttpReaderReadLine)
	GlobalHttpReaderVirtualTable.InheritedTable.ReadToEnd = Cast(Any Ptr, 0)
	GlobalHttpReaderVirtualTable.Clear = Cast(Any Ptr, @HttpReaderClear)
	GlobalHttpReaderVirtualTable.GetBaseStream = Cast(Any Ptr, @HttpReaderGetBaseStream)
	GlobalHttpReaderVirtualTable.SetBaseStream = Cast(Any Ptr, @HttpReaderSetBaseStream)
	GlobalHttpReaderVirtualTable.GetPreloadedContent = Cast(Any Ptr, @HttpReaderGetPreloadedContent)
	
	' NetworkStream
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.QueryInterface = Cast(Any Ptr, @NetworkStreamQueryInterface)
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.AddRef = Cast(Any Ptr, @NetworkStreamAddRef)
	GlobalNetworkStreamVirtualTable.InheritedTable.InheritedTable.Release = Cast(Any Ptr, @NetworkStreamRelease)
	GlobalNetworkStreamVirtualTable.InheritedTable.CanRead = Cast(Any Ptr, @NetworkStreamCanRead)
	GlobalNetworkStreamVirtualTable.InheritedTable.CanSeek = Cast(Any Ptr, @NetworkStreamCanSeek)
	GlobalNetworkStreamVirtualTable.InheritedTable.CanWrite = Cast(Any Ptr, @NetworkStreamCanWrite)
	GlobalNetworkStreamVirtualTable.InheritedTable.CloseStream = Cast(Any Ptr, @NetworkStreamCloseStream)
	GlobalNetworkStreamVirtualTable.InheritedTable.Flush = Cast(Any Ptr, @NetworkStreamFlush)
	GlobalNetworkStreamVirtualTable.InheritedTable.GetLength = Cast(Any Ptr, @NetworkStreamGetLength)
	GlobalNetworkStreamVirtualTable.InheritedTable.OpenStream = Cast(Any Ptr, @NetworkStreamOpenStream)
	GlobalNetworkStreamVirtualTable.InheritedTable.Position = Cast(Any Ptr, @NetworkStreamPosition)
	GlobalNetworkStreamVirtualTable.InheritedTable.Read = Cast(Any Ptr, @NetworkStreamRead)
	GlobalNetworkStreamVirtualTable.InheritedTable.Seek = Cast(Any Ptr, @NetworkStreamSeek)
	GlobalNetworkStreamVirtualTable.InheritedTable.SetLength = Cast(Any Ptr, @NetworkStreamSetLength)
	GlobalNetworkStreamVirtualTable.InheritedTable.Write = Cast(Any Ptr, @NetworkStreamWrite)
	GlobalNetworkStreamVirtualTable.GetSocket = Cast(Any Ptr, @NetworkStreamGetSocket)
	GlobalNetworkStreamVirtualTable.SetSocket = Cast(Any Ptr, @NetworkStreamSetSocket)
	
	' TODO RequestedFile
	GlobalRequestedFileVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, @RequestedFileQueryInterface)
	GlobalRequestedFileVirtualTable.InheritedTable.Addref = Cast(Any Ptr, @RequestedFileAddRef)
	GlobalRequestedFileVirtualTable.InheritedTable.Release = Cast(Any Ptr, @RequestedFileRelease)
	GlobalRequestedFileVirtualTable.ChoiseFile = Cast(Any Ptr, 0)
	GlobalRequestedFileVirtualTable.GetFilePath = Cast(Any Ptr, @RequestedFileGetFilePath)
	GlobalRequestedFileVirtualTable.SetFilePath = Cast(Any Ptr, 0)
	GlobalRequestedFileVirtualTable.GetPathTranslated = Cast(Any Ptr, @RequestedFileGetPathTranslated)
	GlobalRequestedFileVirtualTable.SetPathTranslated = Cast(Any Ptr, 0)
	GlobalRequestedFileVirtualTable.FileExists = Cast(Any Ptr, @RequestedFileFileExists)
	GlobalRequestedFileVirtualTable.GetFileHandle = Cast(Any Ptr, @RequestedFileGetFileHandle)
	GlobalRequestedFileVirtualTable.GetLastFileModifiedDate = Cast(Any Ptr, @RequestedFileGetLastFileModifiedDate)
	GlobalRequestedFileVirtualTable.GetFileLength = Cast(Any Ptr, 0)
	GlobalRequestedFileVirtualTable.GetVaryHeaders = Cast(Any Ptr, 0)
	
	GlobalRequestedFileSendableVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, 0)
	GlobalRequestedFileSendableVirtualTable.InheritedTable.Addref = Cast(Any Ptr, 0)
	GlobalRequestedFileSendableVirtualTable.InheritedTable.Release = Cast(Any Ptr, 0)
	GlobalRequestedFileSendableVirtualTable.Send = Cast(Any Ptr, 0)
	
	' TODO ServerState
	GlobalServerStateVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, 0)
	GlobalServerStateVirtualTable.InheritedTable.Addref = Cast(Any Ptr, 0)
	GlobalServerStateVirtualTable.InheritedTable.Release = Cast(Any Ptr, 0)
	GlobalServerStateVirtualTable.GetRequestHeader = Cast(Any Ptr, @ServerStateDllCgiGetRequestHeader)
	GlobalServerStateVirtualTable.GetHttpMethod = Cast(Any Ptr, @ServerStateDllCgiGetHttpMethod)
	GlobalServerStateVirtualTable.GetHttpVersion = Cast(Any Ptr, @ServerStateDllCgiGetHttpVersion)
	GlobalServerStateVirtualTable.SetStatusCode = Cast(Any Ptr, @ServerStateDllCgiSetStatusCode)
	GlobalServerStateVirtualTable.SetStatusDescription = Cast(Any Ptr, @ServerStateDllCgiSetStatusDescription)
	GlobalServerStateVirtualTable.SetResponseHeader = Cast(Any Ptr, @ServerStateDllCgiSetResponseHeader)
	GlobalServerStateVirtualTable.WriteData = Cast(Any Ptr, @ServerStateDllCgiWriteData)
	GlobalServerStateVirtualTable.ReadData = Cast(Any Ptr, @ServerStateDllCgiReadData)
	GlobalServerStateVirtualTable.GetHtmlSafeString = Cast(Any Ptr, @ServerStateDllCgiGetHtmlSafeString)
	
	' WebServer
	GlobalWebServerVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, @WebServerQueryInterface)
	GlobalWebServerVirtualTable.InheritedTable.Addref = Cast(Any Ptr, @WebServerAddRef)
	GlobalWebServerVirtualTable.InheritedTable.Release = Cast(Any Ptr, @WebServerRelease)
	GlobalWebServerVirtualTable.Run = Cast(Any Ptr, @WebServerRun)
	GlobalWebServerVirtualTable.Stop = Cast(Any Ptr, @WebServerStop)
	
	' WebSite
	GlobalWebSiteVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, @WebSiteQueryInterface)
	GlobalWebSiteVirtualTable.InheritedTable.Addref = Cast(Any Ptr, @WebSiteAddRef)
	GlobalWebSiteVirtualTable.InheritedTable.Release = Cast(Any Ptr, @WebSiteRelease)
	GlobalWebSiteVirtualTable.GetHostName = Cast(Any Ptr, @WebSiteGetHostName)
	GlobalWebSiteVirtualTable.GetExecutableDirectory = Cast(Any Ptr, @WebSiteGetExecutableDirectory)
	GlobalWebSiteVirtualTable.GetSitePhysicalDirectory = Cast(Any Ptr, @WebSiteGetSitePhysicalDirectory)
	GlobalWebSiteVirtualTable.GetVirtualPath = Cast(Any Ptr, @WebSiteGetVirtualPath)
	GlobalWebSiteVirtualTable.GetIsMoved = Cast(Any Ptr, @WebSiteGetIsMoved)
	GlobalWebSiteVirtualTable.GetMovedUrl = Cast(Any Ptr, @WebSiteGetMovedUrl)
	GlobalWebSiteVirtualTable.MapPath = Cast(Any Ptr, @WebSiteMapPath)
	GlobalWebSiteVirtualTable.GetRequestedFile = Cast(Any Ptr, @WebSiteGetRequestedFile)
	GlobalWebSiteVirtualTable.NeedCgiProcessing = Cast(Any Ptr, @WebSiteNeedCgiProcessing)
	GlobalWebSiteVirtualTable.NeedDllProcessing = Cast(Any Ptr, @WebSiteNeedDllProcessing)
	
	' WebSiteContainer
	GlobalWebSiteContainerVirtualTable.InheritedTable.QueryInterface = Cast(Any Ptr, @WebSiteContainerQueryInterface)
	GlobalWebSiteContainerVirtualTable.InheritedTable.Addref = Cast(Any Ptr, @WebSiteContainerAddRef)
	GlobalWebSiteContainerVirtualTable.InheritedTable.Release = Cast(Any Ptr, @WebSiteContainerRelease)
	GlobalWebSiteContainerVirtualTable.GetDefaultWebSite = Cast(Any Ptr, @WebSiteContainerGetDefaultWebSite)
	GlobalWebSiteContainerVirtualTable.FindWebSite = Cast(Any Ptr, @WebSiteContainerFindWebSite)
	GlobalWebSiteContainerVirtualTable.LoadWebSites = Cast(Any Ptr, @WebSiteContainerLoadWebSites)
	
End Sub
