#ifndef unicode
	#define unicode
#endif
#include once "windows.bi"
#include once "ThreadProc.bi"

' Диапазон байт запроса
Type ByteRange
	Dim StartIndex As Integer
	Dim Count As Integer
End Type

' Точка входа
Declare Function EntryPoint Alias "EntryPoint"()As Integer

' Функция сервисного потока
#ifdef service
Declare Function ServiceProc(ByVal lpParam As LPVOID)As DWORD
#endif

' Выделяет память в импровизированной куче
' При ошибке возвращает 0
Declare Function MyHeapAlloc(ByVal hHeap As ThreadParam Ptr)As ThreadParam Ptr

' Подготавливает импровизированную кучу
Declare Sub MyHeapCreate(ByVal hHeap As ThreadParam Ptr)

' Уничтожает импровизированную кучу
Declare Sub MyHeapDestroy(ByVal hHeap As ThreadParam Ptr)

' Получение идентификатора лог‐файла
Declare Function GetLogFileHandle(ByVal dtCurrent As SYSTEMTIME Ptr, ByVal LogDir As WString Ptr)As Handle
