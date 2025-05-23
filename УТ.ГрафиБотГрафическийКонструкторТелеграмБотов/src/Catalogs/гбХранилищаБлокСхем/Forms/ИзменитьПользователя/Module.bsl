
&НаКлиенте
Процедура СохранитьИзменения(Команда)
	Попытка
		СохранитьИзмененияНаСервере();
	
		Закрыть(ИмяПользователя);
	Исключение
		ПоказатьПредупреждение(, ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНаСервере()
	ХранилищеОбъект = Хранилище.ПолучитьОбъект();
	
	Если ПустаяСтрока(ТекИмяПользователя) тогда
		гбХранилище.ВыполнитьУдаленно(ХранилищеОбъект, "СоздатьПользователя", 
			ХранилищеОбъект.ИмяПользователя, ХранилищеОбъект.Пароль,
			ИмяПользователя, Пароль, Администрирование, ЗахватОбъектов);

	Иначе
		гбХранилище.ВыполнитьУдаленно(ХранилищеОбъект, "ИзменитьПользователя", 
			ХранилищеОбъект.ИмяПользователя, ХранилищеОбъект.Пароль,
			ТекИмяПользователя, ИмяПользователя, Пароль, Администрирование, ЗахватОбъектов, Ложь);
		
	КонецЕсли;
	
	Если УстановитьТекущим тогда
		ХранилищеОбъект.ИмяПользователя = ИмяПользователя;
		ХранилищеОбъект.Пароль = Пароль;
		ХранилищеОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекИмяПользователя = Параметры.ИмяПользователя;
	ИмяПользователя = Параметры.ИмяПользователя;
	Администрирование = Параметры.Администрирование;
	ЗахватОбъектов = Параметры.ЗахватОбъектов;
	Хранилище = Параметры.Хранилище;
	ХранилищеОбъект = Хранилище.ПолучитьОбъект();
	Если ПустаяСтрока(ХранилищеОбъект.ИмяПользователя) тогда
		УстановитьТекущим = Истина;
		Элементы.УстановитьТекущим.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры
