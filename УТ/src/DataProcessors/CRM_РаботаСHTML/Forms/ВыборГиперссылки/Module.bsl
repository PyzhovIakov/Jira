
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьПоOK(Команда)
	Закрыть(URLТекст);
КонецПроцедуры

&НаКлиенте
Процедура URLАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Список = Новый СписокЗначений;
	Список.Добавить("http://", "http://");
	Список.Добавить("file://", "file://");
	Список.Добавить("mailto:", "mailto:");
	Список.Добавить("#", "#");
	ФлагНеНашел = Истина;
	
	Для Каждого ЭлементСписка Из Список Цикл 
		ВариантЗаголовка = ЭлементСписка.Значение;
		Если Лев(Текст, СтрДлина(ВариантЗаголовка)) = ВариантЗаголовка Тогда 
			ФлагНеНашел = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ФлагНеНашел Тогда 
		Элемент.СписокВыбора.Очистить();
		Для Каждого ЭлементСписка Из Список Цикл 
			ВариантЗаголовка = ЭлементСписка.Значение;
			Элемент.СписокВыбора.Добавить("" + ВариантЗаголовка + Текст);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура URLОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	URLТекст = ВыбранноеЗначение;
	Элемент.СписокВыбора.Очистить();
КонецПроцедуры

#КонецОбласти
