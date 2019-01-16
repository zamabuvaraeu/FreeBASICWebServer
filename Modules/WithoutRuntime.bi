#ifndef WITHOUTRUNTIME_BI
#define WITHOUTRUNTIME_BI

#ifdef withoutruntime
	#define BeginMainFunction Function EntryPoint Alias "EntryPoint"()As Integer
	#define EndMainFunction End Function
	#define RetCode(Code) Return (Code)
#else
	#define BeginMainFunction
	#define EndMainFunction
	#define RetCode(Code) End (Code)
#endif

#endif
