﻿#include "GuidsWithoutMinGW.bi"

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "win\ole2.bi"

' {00000001-0000-0000-C000-000000000046}
DEFINE_IID(IID_IClassFactory_WithoutMinGW, _
	&h00000001, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {00020400-0000-0000-C000-000000000046}
DEFINE_IID(IID_IDispatch_WithoutMinGW, _
	&h00020400, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
DEFINE_IID(IID_IDispatchEx_WithoutMinGW, _
	&hA6EF9860, &hC720, &h11D0, &h93, &h37, &h00, &hA0, &hC9, &h0D, &hCA, &hA9 _
)

' {FC4801A3-2BA9-11CF-A229-00AA003D7352}
DEFINE_IID(IID_IObjectWithSite_WithoutMinGW, _
	&hFC4801A3, &h2BA9, &h11CF, &hA2, &h29, &h00, &hAA, &h00, &h3D, &h73, &h52 _
)

' {B196B283-BAB4-101A-B69C-00AA00341D07}
DEFINE_IID(IID_IProvideClassInfo_WithoutMinGW, _
	&hB196B283, &hBAB4, &h101A, &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 _
)

' {A7ABA9C1-8983-11CF-8F20-00805F2CD064}
DEFINE_IID(IID_IProvideMultipleClassInfo_WithoutMinGW, _
	&hA7ABA9C1, &h8983, &h11CF, &h8F, &h20, &h00, &h80, &h5F, &h2C, &hD0, &h64 _
)

' {DF0B3D60-548F-101B-8E65-08002B2BD119}
DEFINE_IID(IID_ISupportErrorInfo_WithoutMinGW, _
	&hDF0B3D60, &h548F, &h101B, &h8E, &h65, &h08, &h00, &h2B, &h2B, &hD1, &h19 _
)

' {00000000-0000-0000-C000-000000000046}
DEFINE_IID(IID_IUnknown_WithoutMinGW, _
	&h00000000, &h0000, &h0000, &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 _
)

' {00000000-0000-0000-0000-000000000000}
DEFINE_IID(IID_NULL_WithoutMinGW, _
	&h00000000, &h0000, &h0000, &h00, &h00, &h00, &h00, &h00, &h00, &h00, &h00 _
)
