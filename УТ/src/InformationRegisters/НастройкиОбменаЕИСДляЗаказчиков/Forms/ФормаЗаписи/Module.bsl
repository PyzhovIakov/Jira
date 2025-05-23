#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользуетсяНесколькоОрганизаций = ЭлектронноеАктированиеЕИСВызовСервера.ИспользуетсяНесколькоОрганизаций();
	
	Если НЕ ИспользуетсяНесколькоОрганизаций И НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
		Запись.Организация = ЭлектронноеАктированиеЕИС.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	ЭлектронноеАктированиеЕИСВызовСервера.
		СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтотОбъект, "Организация");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьМастерНастроек(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьМастерНастроекЗавершение", ЭтотОбъект);
	ЭлектронноеАктированиеЕИСКлиент.ОткрытьМастерНастроекДляЗаказчика(
		Запись.Организация, УникальныйИдентификатор, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьМастерНастроекЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) И Результат Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

