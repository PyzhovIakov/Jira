
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЧислоСтрок = 1;
	ЧислоКолонок = 1;
	Элементы.ДекорацияОбщаяШирина.Видимость = Ложь;
	
	Если Не Параметры.РазрешитьВставкуТЧ Тогда
		Элементы.ЭтоТЧ.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭтоТЧПриИзменении(Элемент)
	ЧислоСтрок = 2;
	Элементы.ЧислоСтрок.Доступность = НЕ ЭтоТЧ;
КонецПроцедуры

&НаКлиенте
Процедура ЧислоКолонокПриИзменении(Элемент)
	
	Если ЧислоКолонок < 1 Тогда
		ЧислоКолонок = 1;
	КонецЕсли;
	
	ШиринаТаблицы = ШиринаКолонки * ЧислоКолонок;
	ВыводШириныТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЧислоСтрокПриИзменении(Элемент)
	Если ЧислоСтрок < 1 Тогда
		ЧислоСтрок = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыводШириныТаблицы()
	Элементы.ДекорацияОбщаяШирина.Заголовок = НСтр("ru='Общая ширина таблицы'") + ": " + ШиринаТаблицы 
		+ " " 
		+ НСтр("ru='пикс.'");
КонецПроцедуры

&НаКлиенте
Процедура ШиринаКолонкиПриИзменении(Элемент)
	
	Если ШиринаКолонки < 0 Тогда
		ШиринаКолонки = 0;
	КонецЕсли;
	
	ШиринаТаблицы = ШиринаКолонки * ЧислоКолонок;
	
	Если ШиринаКолонки > 0 И НЕ Элементы.ДекорацияОбщаяШирина.Видимость Тогда
		Элементы.ДекорацияОбщаяШирина.Видимость = Истина;
		ВыводШириныТаблицы();
	ИначеЕсли ШиринаКолонки = 0 Тогда
		Элементы.ДекорацияОбщаяШирина.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Строк", ЧислоСтрок);
	СтруктураВозврата.Вставить("Колонок", ЧислоКолонок);
	СтруктураВозврата.Вставить("Ширина", ШиринаКолонки);
	СтруктураВозврата.Вставить("ЭтоТЧ", ЭтоТЧ);
	СтруктураВозврата.Вставить("БезРамки", БезРамки);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти
