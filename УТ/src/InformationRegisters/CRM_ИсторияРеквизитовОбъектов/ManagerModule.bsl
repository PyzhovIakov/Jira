
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает соответствие из значений реквизитов объекта, для которых включено ведение истории изменений.
//
Функция ПолучитьСтарыеЗначенияРеквизитовОбъекта(Ссылка) Экспорт
	
	СтарыеЗначенияРеквизитовОбъекта = Новый Соответствие;
	
	НастройкиИстории = Неопределено;
	НастройкиИсторииЗначение = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ПолучитьНастройку();
	
	Если НастройкиИсторииЗначение = Неопределено Тогда
		Возврат СтарыеЗначенияРеквизитовОбъекта;
	ИначеЕсли НастройкиИсторииЗначение.Свойство("СтруктураНастройки") Тогда
		Если РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ОбновитьНастройкиВерсионирования(НастройкиИсторииЗначение) Тогда
			НастройкиИстории =
				РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ПолучитьНастройку().СтруктураНастройки;
		Иначе
			НастройкиИстории = НастройкиИсторииЗначение.СтруктураНастройки;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Партнеры") Тогда
		МассивРеквизитовНастройкиИстории = НастройкиИстории.Реквизиты;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		МассивРеквизитовНастройкиИстории = НастройкиИстории.РеквизитыКонтактногоЛица;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.CRM_Интерес") Тогда
		МассивРеквизитовНастройкиИстории = НастройкиИстории.РеквизитыИнтереса;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.CRM_ПотенциальныеКлиенты") Тогда
		МассивРеквизитовНастройкиИстории = НастройкиИстории.РеквизитыПотенциальногоКлиента;
	Иначе
		Возврат СтарыеЗначенияРеквизитовОбъекта;
	КонецЕсли;
	
	Для Каждого Реквизит Из МассивРеквизитовНастройкиИстории Цикл
		
		Если ТипЗнч(Реквизит) = Тип("СправочникСсылка.ВидыКонтактнойИнформации")
			 И Ссылка.КонтактнаяИнформация.Количество() > 0 Тогда
			Для Каждого Строка Из Ссылка.КонтактнаяИнформация Цикл
				Если Строка.Вид = Реквизит Тогда
					СтарыеЗначенияРеквизитовОбъекта.Вставить(Реквизит, Строка.Представление);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() И Реквизит = "CRM_УровниДоступа"
			 И Ссылка.CRM_УровниДоступа.Количество() > 0 Тогда
			НовыйЭлемент = Новый ТаблицаЗначений;
			НовыйЭлемент.Колонки.Добавить("УровеньДоступа", Новый ОписаниеТипов("СправочникСсылка.CRM_УровниДоступа"));
			НовыйЭлемент.Колонки.Добавить("ТолькоЧтение", Новый ОписаниеТипов("Булево"));
			Для Каждого Строка Из Ссылка.CRM_УровниДоступа Цикл
				НоваяСтрока = НовыйЭлемент.Добавить();
				НоваяСтрока.УровеньДоступа = Строка.УровеньДоступа;
				НоваяСтрока.ТолькоЧтение = Строка.ТолькоЧтение;
			КонецЦикла;
			СтарыеЗначенияРеквизитовОбъекта.Вставить(Реквизит, НовыйЭлемент);
			
		ИначеЕсли ТипЗнч(Реквизит) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			Для Каждого Строка Из Ссылка.ДополнительныеРеквизиты Цикл
				Если Строка.Свойство = Реквизит Тогда
					СтарыеЗначенияРеквизитовОбъекта.Вставить(Реквизит, Строка.Значение);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(Реквизит) = Тип("Строка") И Реквизит <> "Сегмент" Тогда
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Ссылка, Реквизит) Тогда
				СтарыеЗначенияРеквизитовОбъекта.Вставить(Реквизит, Ссылка[Реквизит]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтарыеЗначенияРеквизитовОбъекта;
	
КонецФункции

#КонецОбласти

#КонецЕсли
