#ifndef INTERFACEHELPER_BI
#define INTERFACEHELPER_BI

#MACRO LET_INTERFACE(lhs, rhs)
	(rhs)->lpVtbl->AddRef(rhs)
	lhs = rhs
#ENDMACRO

#MACRO RELEASE_INTERFACE(lhs)
	(lhs)->lpVtbl->Release(lhs)
	lhs = 0
#ENDMACRO

#endif