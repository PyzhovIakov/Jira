#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Местоположение        = Параметры.Местоположение;
	МестоположениеСтрокой = Параметры.МестоположениеСтрокой;
	СкладКонтрагент       = Параметры.СкладКонтрагент;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ИнициализироватьПоляКонтактнойИнформации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МестоположениеСтрокойПриИзменении(Элемент)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеОчистка(Элемент, СтандартнаяОбработка)
	
	ДополнительныеПоля = Новый Массив;
	ДополнительныеПоля.Добавить("СкладКонтрагент");
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДополнительныеПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДополнительныеПоля = Новый Соответствие;
	ДополнительныеПоля.Вставить("СкладКонтрагент", "ВладелецАдреса");
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ДополнительныеПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаАвтоПодбор(ЭтотОбъект, "СкладКонтрагентЗЕРНО",
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("Местоположение",        Местоположение);
		Результат.Вставить("МестоположениеСтрокой", МестоположениеСтрокой);
		Результат.Вставить("СкладКонтрагент",       СкладКонтрагент);
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	ВидКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
		Перечисления.ТипыКонтактнойИнформации.Адрес);
	// Считываем данные из полей адреса в реквизиты для редактирования.
	КомментарийМестоположение = ОбщегоНазначенияИС.КомментарийКонтактнойИнформации(Местоположение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеАдресаОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОкончаниеВыбора(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти
