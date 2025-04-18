
#Область ОбработчикиСобытий
//@skip-check module-accessibility-at-client
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Автор = ПараметрыСеанса.ТекущийПользователь; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Центр_ПользовательскиеНастройки.Значение,
		|	Центр_ПользовательскиеНастройки.ВидНастройки
		|ИЗ
		|	РегистрСведений.cbr_ПользовательскиеНастройки КАК Центр_ПользовательскиеНастройки
		|ГДЕ
		|	Центр_ПользовательскиеНастройки.Пользователь = &Пользователь
		|	И
		|		Центр_ПользовательскиеНастройки.ВидНастройки.Родитель = ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.НачальноеЗаполнениеЗадачи)
		|	И НЕ Центр_ПользовательскиеНастройки.ВидНастройки.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Пользователь", Автор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВидНастройки = ПредопределенноеЗначение("ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.ВидЗадачи") Тогда
			ВидЗадачи = Выборка.Значение;	
		КонецЕсли;
		Если Выборка.ВидНастройки = ПредопределенноеЗначение("ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Постановщик") Тогда
			Постановщик = Выборка.Значение;
			Если ТипЗнч(Постановщик) = Тип("СправочникСсылка.Партнеры") Тогда
				ГлавныйМенеджер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Постановщик, "ОсновнойМенеджер");
			КонецЕсли;
		КонецЕсли;
		Если Выборка.ВидНастройки = ПредопределенноеЗначение("ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Приоритет") Тогда
			Приоритет = Выборка.Значение;
		КонецЕсли;
		Если Выборка.ВидНастройки = ПредопределенноеЗначение("ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.КонтрольВремени") Тогда
			КонтрольВремени = Выборка.Значение;
		КонецЕсли;
		Если Выборка.ВидНастройки = ПредопределенноеЗначение("ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.УчетВремени") Тогда
			УчетВремени = Выборка.Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

//@skip-check module-accessibility-at-client
Процедура ОбработкаПроведения(Отказ, РежимПроведения)	
	cbr_ОбработкаТриггеров.ВызовТриггера(Перечисления.cbr_ПодпискаДляТриггера.ПроведениеДокументаЗадача, Ссылка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ТипЗнч(Постановщик) <> Тип("СправочникСсылка.Партнеры") Тогда
		Индекс = ПроверяемыеРеквизиты.Найти("ГлавныйМенеджер");
		ПроверяемыеРеквизиты.Удалить(Индекс);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти