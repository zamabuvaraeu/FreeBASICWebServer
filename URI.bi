Type URI
	' Максимальная длина Url
	Const MaxUrlLength As Integer = 4095
	
	' Запрошенный клиентом адрес
	Dim Url As WString Ptr
	' Путь, указанный клиентом (без строки запроса и раскодированный)
	Dim Path As WString * (MaxUrlLength + 1)
	' Строка запроса
	Dim QueryString As WString Ptr

End Type