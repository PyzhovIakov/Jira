#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контракт = Параметры.Контракт;
	ДанныеКонтракта = ЭлектронноеАктированиеЕИС.ДанныеГосударственногоКонтракта(Контракт);
	ИдентификаторОбъектаЗакупки = Параметры.ИдентификаторОбъектаЗакупки;
	КодМНН = Параметры.КодМНН;
	
	Для каждого Объект Из ДанныеКонтракта.ОбъектыЗакупки Цикл
		Если Объект.Идентификатор = ИдентификаторОбъектаЗакупки Тогда
			СведенияОЛекарственномПрепарате = Объект.СведенияОЛекарственномПрепарате;
			Наименование = Объект.Наименование;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Позиция Из СведенияОЛекарственномПрепарате.СписокМНН Цикл
		Если Позиция.КодМНН = КодМНН Тогда
			ПозицияМНН = Позиция;
			НаименованиеМНН = Позиция.НаименованиеМНН;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Позиция Из ПозицияМНН.ПозицииПоТорговомуНаименованиюЛП Цикл
		Строка = ПозицииПоТНЛП.Добавить();
		Строка.Представление = Позиция.ТорговоеНаименование;
		Строка.Код = Позиция.КодПоСправочникуЛП;
		Строка.ГиперСсылка = "Сведения о позиции по торговому наименованию";
		Строка.Идентификатор = Позиция.Идентификатор;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПозицииПоТНЛП

&НаКлиенте
Процедура ПозицииПоТНЛПВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПозицииПоТНЛПГиперСсылка" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИдентификаторОбъектаЗакупки", ИдентификаторОбъектаЗакупки);
		ПараметрыФормы.Вставить("Контракт", Контракт);
		ПараметрыФормы.Вставить("КодМНН", КодМНН);
		ПараметрыФормы.Вставить("КодЛП", Элемент.ТекущиеДанные.Код);
		ПараметрыФормы.Вставить("ИдентификаторЛП", Элемент.ТекущиеДанные.Идентификатор);
		
		ОткрытьФорму("Справочник.ГосударственныеКонтракты.Форма.ФормаПозицииПоТорговомуНаименованиюЛП",
			ПараметрыФормы, , УникальныйИдентификатор, , , ,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	ЭтотОбъект.Закрыть();
КонецПроцедуры

#КонецОбласти