Функция ПолучитьИдПользователя(Пользователь) Экспорт
	Если не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат Неопределено;		
	КонецЕсли;
	СтруктураОтбора = ПолучитьСтруктуруОтбора(Пользователь);
	РезультатОтбора = РегистрыСведений.cbr_СоответствиеПользователейДляИнтеграций.Получить(СтруктураОтбора);
	Возврат РезультатОтбора.АйДиПользователя;	
КонецФункции

Функция ПолучитьСтруктуруОтбора(Пользователь)
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Пользователь",Пользователь);
	СтруктураОтбора.Вставить("ТипИнтеграции",  ПредопределенноеЗначение(
			"ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Телеграм"));
	Возврат СтруктураОтбора;		
КонецФункции

Процедура УстановитьПользователяИБ(Пользователь, ТипИнтеграции, СтруктураПараметров) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	ДатаЗаписи = ТекущаяДата();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.ТипИнтеграции.Установить(ТипИнтеграции);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Пользователь = Пользователь;
		НоваяЗапись.ТипИнтеграции = ТипИнтеграции;
		НоваяЗапись.АйДиПользователя = СтруктураПараметров.АйДиПользователя;
	Иначе
		ВыбраннаяЗапись = НаборЗаписей[0];
		ВыбраннаяЗапись.АйДиПользователя = СтруктураПараметров.АйДиПользователя;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
	cbr_РаботаСTelegram.ОтправитьСообщениеПользователюПоСсылке(Пользователь,
																		Строка(ТекущаяДата()) + " " + Строка(Пользователь) + " активация интеграции Telegram",
																		Строка(ТекущаяДата()) + " " + Строка(Пользователь) + " активация интеграции Telegram");
КонецПроцедуры

Функция ПолучитьСтруктуруПараметровЗаполнения() Экспорт
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("АйДиПользователя", "");
	Возврат СтруктураРезультат;
КонецФункции