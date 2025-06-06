
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сопоставить(Команда)
	
	Ссылки = Новый Массив;
	Для Каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(СтрокаСписка);
		Ссылки.Добавить(ДанныеСтроки.НоменклатураПартнера);
	КонецЦикла;
	
	НоменклатураДляСопоставления = НоменклатураКонтрагентовПоСсылкам(Ссылки);
	
	Если Не ЗначениеЗаполнено(НоменклатураДляСопоставления) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сопоставление номенклатуры не требуется.'"));
		Возврат;
	КонецЕсли;
	
	Настройки = Новый Структура;
	Настройки.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Настройки.Вставить("ВладелецФормы",     ЭтотОбъект);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьСопоставлениеНоменклатуры", ЭтотОбъект);
	
	СопоставлениеНоменклатурыКонтрагентовКлиент.ОткрытьСопоставлениеНоменклатуры(НоменклатураДляСопоставления, 
		Настройки, 
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция НоменклатураКонтрагентовПоСсылкам(Знач Ссылки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураКонтрагентов.Владелец КАК Владелец,
		|	НоменклатураКонтрагентов.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ втОтбор
		|ИЗ
		|	Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
		|ГДЕ
		|	НоменклатураКонтрагентов.Ссылка В(&Ссылки)";
	
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	Возврат СопоставлениеНоменклатурыКонтрагентов.ДанныеНоменклатурыКонтрагентаПоЗапросу(Запрос);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьСопоставлениеНоменклатуры(РезультатСопоставления, ДополнительныеПараметры) Экспорт

	Если РезультатСопоставления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Список.Обновить();

КонецПроцедуры

#КонецОбласти
