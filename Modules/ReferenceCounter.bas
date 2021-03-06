#include once "ReferenceCounter.bi"

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Sub ReferenceCounterInitialize( _
		ByVal pCounter As ReferenceCounter Ptr _
	)
	
	pCounter->Counter = 0
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		' ������ ������
	#else
		InitializeCriticalSectionAndSpinCount( _
			@pCounter->crSection, _
			MAX_CRITICAL_SECTION_SPIN_COUNT _
		)
	#endif
	
End Sub

Sub ReferenceCounterUnInitialize( _
		ByVal pCounter As ReferenceCounter Ptr _
	)
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		' ������ ������
	#else
		DeleteCriticalSection(@pCounter->crSection)
	#endif
	
End Sub

#ifdef __FB_64BIT__

Function ReferenceCounterIncrement64 Alias "ReferenceCounterIncrement64"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG64
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		Return InterlockedIncrement64(@pCounter->Counter)
	#else
		EnterCriticalSection(@pCounter->crSection)
		pCounter->Counter += 1
		LeaveCriticalSection(@pCounter->crSection)
		Return pCounter->Counter
	#endif
	
End Function

Function ReferenceCounterDecrement64 Alias "ReferenceCounterDecrement64"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG64
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		Return InterlockedDecrement64(@pCounter->Counter)
	#else
		EnterCriticalSection(@pCounter->crSection)
		pCounter->Counter -= 1
		LeaveCriticalSection(@pCounter->crSection)
		Return pCounter->Counter
	#endif
	
End Function

Function ReferenceCounterGetValue64 Alias "ReferenceCounterGetValue64"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG64
	
	Return pCounter->Counter
	
End Function

#else

Function ReferenceCounterIncrement Alias "ReferenceCounterIncrement"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		Return InterlockedIncrement(@pCounter->Counter)
	#else
		EnterCriticalSection(@pCounter->crSection)
		pCounter->Counter += 1
		LeaveCriticalSection(@pCounter->crSection)
		Return pCounter->Counter
	#endif
	
End Function

Function ReferenceCounterDecrement Alias "ReferenceCounterDecrement"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG
	
	#ifdef WITHOUT_CRITICAL_SECTIONS
		Return InterlockedDecrement(@pCounter->Counter)
	#else
		EnterCriticalSection(@pCounter->crSection)
		pCounter->Counter -= 1
		LeaveCriticalSection(@pCounter->crSection)
		Return pCounter->Counter
	#endif
	
End Function

Function ReferenceCounterGetValue Alias "ReferenceCounterGetValue"( _
		ByVal pCounter As ReferenceCounter Ptr _
	)As LONG
	
	Return pCounter->Counter
	
End Function

#endif
