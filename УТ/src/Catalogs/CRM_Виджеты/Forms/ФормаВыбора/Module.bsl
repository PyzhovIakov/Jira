////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции модуля формы "Справочники.CRM_ВариантыВиджетов.Форма.ФормаВыбора".
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокОткрытыхВиджетов") Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));   
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ЭлементОтбора.ПравоеЗначение = Параметры.СписокОткрытыхВиджетов;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = СписокПередНачаломДобавленияНаСервере();
	
КонецПроцедуры // СписокПередНачаломДобавления()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СписокПередНачаломДобавленияНаСервере()
	
	Если НЕ CRM_ЛицензированиеЭкспортныеМетоды.ВариантПоставкиКОРП() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Функция доступна только для ""КОРП"" поставки конфигурации!';
			|en='The function is only available for ""CORP"" configuration delivery!'");
		Сообщение.Сообщить();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // СписокПередНачаломДобавленияНаСервере()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////