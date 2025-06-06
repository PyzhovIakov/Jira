#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает таблицу диалогов группировок.
//
// Параметры:
//  Отбор			 - Отбор	 - Отбор.
//  ТаблицаКонтактов - ТаблицаЗначений	 - Таблица контактов.
// 
// Возвращаемое значение:
//   - ТаблицаЗначений
//
Функция ПолучитьДиалогиВПапку(Отбор, ТаблицаКонтактов) Экспорт
	
	Схема = ПолучитьСхемуКомпоновки(ТаблицаКонтактов);
	АдресСхемы = ПоместитьВоВременноеХранилище(Схема, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	Настройки.Отбор.Элементы.Очистить();
	Справочники.CRM_УровниПоддержки.СкопироватьОтборКомпоновкиДанных(Настройки.Отбор, Отбор);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , ,
		 Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	НаборыДанных = Новый Структура;
	НаборыДанных.Вставить("ДанныеКонтакты", ТаблицаКонтактов);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, НаборыДанных);
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ПроцессорВыводаРезультата = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВыводаРезультата.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВыводаРезультата.Вывести(ПроцессорКомпоновки);
	
	Возврат ТаблицаРезультат;
	
КонецФункции // ПолучитьДиалогиВПапку()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОписаниеОтбораСхемыКомпоновкиДанных() Экспорт
	
	ОписаниеПолей	= Новый ТаблицаЗначений;
	РеквизитыОтбора	= Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	/////////////////////////
	// Реквизиты отбора пользователя.
	
	ОписаниеПолей.Колонки.Добавить(
		"Диалог",
		Новый ОписаниеТипов("СправочникСсылка.CRM_Диалоги"),
		НСтр("ru = 'Диалог'"));
	
	ОписаниеПолей.Колонки.Добавить(
		"УчетнаяЗапись",
		Новый ОписаниеТипов("СправочникСсылка.CRM_УчетныеЗаписиМессенджеров"),
		НСтр("ru = 'Учетная запись'"));
	
	Возврат ОписаниеПолей;
	
КонецФункции // ОписаниеТипаДанныхОтбораСхемыКомпоновкиДанных()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСхемуКомпоновки(ОписаниеПолей = Неопределено) Экспорт
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновки.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	Наборданных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Имя = "ДанныеКонтакты";
	Наборданных.ИмяОбъекта = "ДанныеКонтакты";
	
	Если ОписаниеПолей = Неопределено Тогда
		ОписаниеПолей = ОписаниеОтбораСхемыКомпоновкиДанных();
	КонецЕсли;
	
	НастройкиКомпоновки = СхемаКомпоновки.ВариантыНастроек[0].Настройки;
	
	Для Каждого Поле Из ОписаниеПолей.Колонки Цикл
		ПолеНабора = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеНабора.Заголовок	= Поле.Заголовок;
		ПолеНабора.Поле			= Поле.Имя;
		ПолеНабора.ПутьКДанным	= Поле.Имя;
		ПолеНабора.ТипЗначения	= Поле.ТипЗначения;
		
		ВыбранноеПоле = НастройкиКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(Поле.Имя);
	КонецЦикла;
	
	Группировка = НастройкиКомпоновки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Возврат СхемаКомпоновки;
	
КонецФункции // ПолучитьСхемуКомпоновки()

#КонецОбласти

#КонецЕсли