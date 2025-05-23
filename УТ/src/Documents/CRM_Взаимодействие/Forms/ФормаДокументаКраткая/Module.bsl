
#Область ОписаниеПеременных

&НаКлиенте
Перем ВремяТемп;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Свойство("ДокументОснование") Тогда
			Объект.ДокументОснование = Параметры.ДокументОснование;
		КонецЕсли;
		Объект.ПлановаяДата = ТекущаяДатаСеанса();
		Объект.ПлановаяДатаЗавершение = Объект.ПлановаяДата + 3600;
		Направление = Перечисления.CRM_ВходящееИсходящееСобытие.Исходящее;
		Если Параметры.Свойство("ВидВзаимодействия") Тогда
			Объект.ВидВзаимодействия = Параметры.ВидВзаимодействия;
			ВидВзаимодействияПриИзмененииНаСервере();
		КонецЕсли;
		Объект.Автор			= Пользователи.АвторизованныйПользователь();
		Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
			Объект.Ответственный	= Объект.Автор;
		КонецЕсли;
		Объект.Подразделение = Объект.Ответственный.Подразделение;
		Объект.Организация = CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
		Объект.СтатусВзаимодействия = Справочники.CRM_СостоянияСобытий.Запланировано;
		Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.CRM_Интерес") Тогда	
				CRM_ОбщегоНазначенияСервер.ОбработкаЗаполнения(Объект, Объект.ДокументОснование);
				Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.CRM_Интерес") Тогда
					Объект.ДокументОснование	= Объект.ДокументОснование.Ссылка;
					Объект.КонтактноеЛицо		= Объект.ДокументОснование.КонтактноеЛицо;
					Объект.ОжидаемаяВыручка		= Объект.ДокументОснование.ОжидаемаяВыручка;
					Объект.Ответственный		= Объект.ДокументОснование.Ответственный;
					Объект.Партнер				= Объект.ДокументОснование.Партнер;
					Объект.Подразделение		= Объект.ДокументОснование.Подразделение;
					Объект.ПотенциальныйКлиент	= Объект.ДокументОснование.ПотенциальныйКлиент;
					Объект.Организация			= Объект.ДокументОснование.Организация;
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;
		ТекущийЭлемент = Элементы.ПлановаяДата;
		Элементы.Отменить.Видимость = Ложь;
	Иначе
		ТекущийЭлемент = Элементы.Результат;
		Входящее = (Объект.ВидВзаимодействия.Направление = Перечисления.CRM_ВходящееИсходящееСобытие.Входящее);
		Элементы.Редактировать.Видимость = НЕ Входящее;
		Направление = Объект.ВидВзаимодействия.Направление;
	КонецЕсли;
	Если Параметры.Свойство("СостояниеИнтереса") Тогда
		Объект.СостояниеИнтереса = Параметры.СостояниеИнтереса;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		Если ЗначениеЗаполнено(Объект.ДокументОснование) 
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект.ДокументОснование, "СостояниеИнтереса") Тогда
			Объект.СостояниеИнтереса = Объект.ДокументОснование.СостояниеИнтереса;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Партнер) И Параметры.Свойство("Партнер") Тогда
		Объект.Партнер = Параметры.Партнер;
		Параметры.Свойство("КонтактноеЛицо", Объект.КонтактноеЛицо); 
	КонецЕсли;
	СостоянияИнтереса = Новый Массив;
	СостоянияИнтереса.Добавить(Объект.СостояниеИнтереса);
	СостоянияИнтереса.Добавить(Справочники.CRM_СостоянияИнтересов.ПустаяСсылка());
	ПараметрыВыбораВида = Новый Массив;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.CRM_Интерес") Тогда
			ПараметрыВыбораВида.Добавить(Новый ПараметрВыбора("Отбор.Направление",
				 Перечисления.CRM_ВходящееИсходящееСобытие.Исходящее));
			ПараметрыВыбораВида.Добавить(Новый ПараметрВыбора("Отбор.СостояниеИнтереса",
				 Новый ФиксированныйМассив(СостоянияИнтереса)));
			ПараметрыВыбораВида.Добавить(Новый ПараметрВыбора("Отбор.ВидДела",
				 Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес));
		Иначе
			ПараметрыВыбораВида.Добавить(Новый ПараметрВыбора("Отбор.ВидДела",
				 Справочники.CRM_ВидыДелВзаимодействий.ПрочиеДокументы));
		КонецЕсли;
	Иначе
		ПараметрыВыбораВида.Добавить(Новый ПараметрВыбора("Отбор.ВидДела",
			 Справочники.CRM_ВидыДелВзаимодействий.ПрочиеДокументы));
	КонецЕсли;
	
	Элементы.ВидВзаимодействия.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораВида);
	ПлановаяДатаНачала = Объект.ПлановаяДата;
	Элементы.ПлановаяДатаВремя.Видимость			= (Не Объект.НаВесьДень);
	Элементы.ПлановаяДатаЗавершениеВремя.Видимость	= (Не Объект.НаВесьДень);
	
	CRM_ОбщегоНазначенияПовтИсп.ЗаполнитьСписокВыбораВариантовСроков(Элементы.ПлановаяДата);
	
	CRM_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Группа = Элементы.Найти("ГруппаКомманднаяПанельПодменюОтчетыСмТакже");
		Если Группа <> Неопределено Тогда
			Группа.Видимость = Ложь;
		КонецЕсли;
		Группа = Элементы.Найти("ПодменюОтчетыСмТакже");
		Если Группа <> Неопределено Тогда
			Группа.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	CRM_РаботаСЯзыковымиМоделямиСервер.ПриСозданииНаСервере(ЭтотОбъект, "ГруппаАссистент");

	CRM_ОбщегоНазначенияСервер.ЗакончитьЗамерВремениСозданияФормы(ЭтотОбъект, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		// CRM_УправлениеДоступом
		МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступомУровниДоступа");
		Если МодульУправлениеДоступом <> Неопределено Тогда
			МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
		КонецЕсли;
		// Конец CRM_УправлениеДоступом
	Иначе
		// СтандартныеПодсистемы.УправлениеДоступом
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
			МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
		КонецЕсли;
		// Конец СтандартныеПодсистемы.УправлениеДоступом
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	CRM_ОбщегоНазначенияКлиент.НачатьЗамерВремениОткрытияФормы(ЭтотОбъект);
	CRM_ТрудозатратыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УстановитьВидимость();
	Элементы.Результат.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	
	CRM_РаботаСЯзыковымиМоделямиКлиент.ПриОткрытии(ЭтотОбъект);

	CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Взаимодействия.Взаимодействие.ДлительностьСценариев.ВремяРаботыВФорме");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	CRM_СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		// СтандартныеПодсистемы.УправлениеДоступом
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
			МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
		КонецЕсли;
		// Конец СтандартныеПодсистемы.УправлениеДоступом
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Отменить", "Видимость", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_Взаимодействие", Объект.Ссылка, Объект.ДокументОснование);
	Оповестить("ЛентаСобытий_Обновить", Объект.ДокументОснование);
	Оповестить("ОбновитьПланировщик", Объект.ДокументОснование);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	CRM_ТрудозатратыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	CRM_ЦентрМониторингаКлиент.ЗавершитьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Взаимодействия.Взаимодействие.ДлительностьСценариев.ВремяРаботыВФорме");
	
	CRM_ТрудозатратыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	CRM_ОбщегоНазначенияКлиент.НачатьЗамерВремениЗаписиВФорме(ЭтотОбъект, ПараметрыЗаписи);
	
	Если Элементы.ПотенциальныйКлиент.Видимость Тогда
		Объект.Партнер = ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка");
		Объект.КонтактноеЛицо = ПредопределенноеЗначение("Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка");
	Иначе
		Объект.ПотенциальныйКлиент = ПредопределенноеЗначение("Справочник.CRM_ПотенциальныеКлиенты.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПлановаяДатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("ЭтоРезультатРаботыСКалендарем") Тогда
			СтандартнаяОбработка = Ложь;
			
			Объект.ПлановаяДата = ВыбранноеЗначение.Начало;
			Объект.ПлановаяДатаЗавершение = ВыбранноеЗначение.Конец;
			
			ПлановаяДатаПриИзменении(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.CRM_ВариантыУстановкиДаты") Тогда
		СтандартнаяОбработка = Ложь;
		
		ДлительностьИнтервала = Объект.ПлановаяДатаЗавершение - Объект.ПлановаяДата;
		
		Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.CRM_ВариантыУстановкиДаты.Вручную") Тогда
			ОписаниеОповещения	= Новый ОписаниеОповещения(
				"ДатаНачалаОбработкаВыбораЗавершение", ЭтотОбъект, ДлительностьИнтервала);
			ОткрытьФорму("ОбщаяФорма.CRM_ФормаРучногоПереносаВремени", , ЭтотОбъект, КлючУникальности, , , ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			// Осуществляется перенос обеих дат на указанный интервал
			Объект.ПлановаяДата = CRM_ОбщегоНазначенияСервер.ДатаПоВариантуИнтервала(
				CRM_ОбщегоНазначенияСервер.БазоваяДатаПоВариантуИнтервала(Объект.ПлановаяДата, ВыбранноеЗначение),
				ВыбранноеЗначение);
			
			Объект.ПлановаяДатаЗавершение = CRM_ОбщегоНазначенияСервер.ДатаПоВариантуИнтервала(
				CRM_ОбщегоНазначенияСервер.БазоваяДатаПоВариантуИнтервала(Объект.ПлановаяДатаЗавершение, ВыбранноеЗначение),
				ВыбранноеЗначение,
				ДлительностьИнтервала);
			
			ПлановаяДатаНачала = Объект.ПлановаяДата;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.ПлановаяДата = Результат;
		Объект.ПлановаяДатаЗавершение = Объект.ПлановаяДата + ДополнительныеПараметры;
		
		ПлановаяДатаНачала = Объект.ПлановаяДата;
	КонецЕсли;
	
КонецПроцедуры // ДатаНачалаОбработкаВыбораЗавершение()

&НаКлиенте
Процедура ПлановаяДатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураПараметров = Новый Структура();
	
	Если ЗначениеЗаполнено(Объект.ПлановаяДата) Тогда
		СтруктураПараметров.Вставить("ДатаПоУмолчанию", Объект.ПлановаяДата);
	КонецЕсли;
	
	ДанныеБыстрогоВвода = Новый Структура("Тема, НеРедактировать", Объект.Тема);
	ДанныеБыстрогоВвода.Вставить("ПлановаяДата",			Объект.ПлановаяДата);
	ДанныеБыстрогоВвода.Вставить("ПлановаяДатаЗавершение",	Объект.ПлановаяДатаЗавершение);
	ДанныеБыстрогоВвода.Вставить("НаВесьДень",				Объект.НаВесьДень);
	
	СтруктураПараметров.Вставить("ДанныеБыстрогоВвода", ДанныеБыстрогоВвода);
	
	ВремяТемп = Объект.ПлановаяДата - НачалоДня(Объект.ПлановаяДата);
	CRM_ВзаимодействияКлиент.ДатаВзаимодействияНачалоВыбора(
		Объект, Элемент, ДанныеВыбора, СтандартнаяОбработка, СтруктураПараметров, РежимОткрытияОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаПриИзменении(Элемент)
		
	Если Объект.ПлановаяДата = НачалоДня(Объект.ПлановаяДата) И ЗначениеЗаполнено(ВремяТемп) Тогда
		Объект.ПлановаяДата = Объект.ПлановаяДата + ВремяТемп;
		ВремяТемп = Неопределено;
	КонецЕсли;
	Если НачалоДня(ПлановаяДатаНачала) = НачалоДня(Объект.ПлановаяДатаЗавершение) Тогда
		ВремяЗавершения = Объект.ПлановаяДатаЗавершение - НачалоДня(Объект.ПлановаяДатаЗавершение);
		Объект.ПлановаяДатаЗавершение = НачалоДня(Объект.ПлановаяДата) + ВремяЗавершения;
	КонецЕсли;		
	Если Объект.ПлановаяДата > Объект.ПлановаяДатаЗавершение Тогда
		Объект.ПлановаяДатаЗавершение = Объект.ПлановаяДата + 3600;
	КонецЕсли;
	ПлановаяДатаНачала = Объект.ПлановаяДата;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПлановаяДатаВремяНачалоВыбораЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, Объект.ПлановаяДата,
		Элемент, Объект.ПлановаяДата, , ОписаниеОповещения, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаВремяНачалоВыбораЗавершение(ВыбранноеВремя, Элемент) Экспорт
	
	Если ВыбранноеВремя <> Неопределено Тогда
		Объект.ПлановаяДата = ВыбранноеВремя.Значение;
		ПлановаяДатаПриИзменении(Элементы.ПлановаяДата);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаЗавершениеВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПлановаяДатаЗавершениеВремяНачалоВыбораЗавершение",
		 ЭтотОбъект,
		 Элемент);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, Объект.ПлановаяДатаЗавершение,
		Элемент, Объект.ПлановаяДата, Истина, ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаЗавершениеВремяНачалоВыбораЗавершение(ВыбранноеВремя, Элемент) Экспорт
	
	Если ВыбранноеВремя <> Неопределено Тогда
		Объект.ПлановаяДатаЗавершение = ВыбранноеВремя.Значение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриИзменении(Элемент)
	УстановитьВидимость();	
КонецПроцедуры

&НаКлиенте
Процедура РезультатИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.ДатаЗавершенияВзаимодействия) Тогда
		ВидимостьЗавершения = ЗначениеЗаполнено(Текст);
		Если Элементы.Завершить.Видимость <> ВидимостьЗавершения Тогда
			Элементы.Завершить.Видимость = ВидимостьЗавершения;
			Элементы.Завершить.КнопкаПоУмолчанию = ВидимостьЗавершения;
			Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = НЕ ВидимостьЗавершения;
			#Если ВебКлиент Тогда
				Объект.Результат = Текст;
				Элемент.ВыделенныйТекст = "";
			#КонецЕсли
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидВзаимодействияПриИзменении(Элемент)
	ВидВзаимодействияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НаВесьДеньПриИзменении(Элемент)
	
	Элементы.ПлановаяДатаВремя.Видимость			= (Не Объект.НаВесьДень);
	Элементы.ПлановаяДатаЗавершениеВремя.Видимость	= (Не Объект.НаВесьДень);
	
	Если Объект.НаВесьДень Тогда
		ПараметрыДня = CRM_ЛентаСобытий.ПараметрыРабочегоДня(Объект.Ответственный);
		Объект.ПлановаяДата = НачалоДня(Объект.ПлановаяДата) + (ПараметрыДня.ВремяНачала - Дата('00010101'));
		Объект.ПлановаяДатаЗавершение = НачалоДня(Объект.ПлановаяДатаЗавершение) 
			+ (ПараметрыДня.ВремяОкончания - Дата('00010101'));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Если Объект.СвоиЛица.Количество() = 1 Тогда
			Объект.СвоиЛица.Очистить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Редактировать(Команда)
	Если ПроверитьЗаполнение() Тогда
		Если Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
			Записать();
		КонецЕсли;	
		ОткрытьФорму("Документ.CRM_Взаимодействие.Форма.ФормаДокумента", Новый Структура("Ключ,
			| ОткрыватьФорму", Объект.Ссылка, Истина),
			 ВладелецФормы);
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
	Если Объект.ЧекЛист.Количество() > 0 Тогда
		СтруктураПоиска = Новый Структура("Выполнено", Истина);
		СтрокиЗавершено = Объект.ЧекЛист.НайтиСтроки(СтруктураПоиска);
		Если СтрокиЗавершено.Количество() <> Объект.ЧекЛист.Количество() Тогда
			Если ПроверитьВозможностьЗавершения() Тогда
				ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОтветаОЗавершении", ЭтотОбъект,
					 Новый Структура("ПосещениеПодтверждено",
					 Ложь));
				ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Не все задачи по чек-листу выполнены. 
				|Завершить взаимодействие ?'"), РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ОбработкаОтветаОЗавершении(КодВозвратаДиалога.Да, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	ТекстВопроса = НСтр("ru='Взаимодействие будет отменено. Продолжить?';en='Interaction will be cancelled. Continue?'");
	ОповещениеЗавершения = Новый ОписаниеОповещения("ОтменитьЗавершение", ЭтотОбъект, Новый Структура);
	ПоказатьВопрос(ОповещениеЗавершения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Модифицированность = Ложь;
		Закрыть();
	Иначе
		СтатусОтменено = ПредопределенноеЗначение("Справочник.CRM_СостоянияСобытий.Отменено");
		ЗавершитьНаСервере(СтатусОтменено);
		Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Позвонить(Команда)
	
	CRM_ВзаимодействияКлиент.CRM_Позвонить(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьEmailКлиент(Команда)

	CRM_ВзаимодействияКлиент.CRM_ОткрытьФормуОтправкиПочтовогоСообщенияПоДаннымФормы(ЭтотОбъект);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВидВзаимодействияПриИзмененииНаСервере()
	Объект.Тема = Объект.ВидВзаимодействия.Описание;
	Объект.Баллы = Объект.ВидВзаимодействия.Баллы;
	Если ЗначениеЗаполнено(Объект.ВидВзаимодействия.ПлановыйСрокДней) Тогда
		Объект.ПлановаяДата = ТекущаяДатаСеанса() + Объект.ВидВзаимодействия.ПлановыйСрокДней * 60 * 60 * 24;
		Объект.ПлановаяДатаЗавершение = Объект.ПлановаяДата + 3600;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗавершитьНаСервере(СостояниеСобытия = Неопределено)
	
	Если СостояниеСобытия = Неопределено Тогда
		СостояниеСобытия = Справочники.CRM_СостоянияСобытий.Завершено;
	КонецЕсли;
	
	Объект.ДатаЗавершенияВзаимодействия = ТекущаяДатаСеанса();
	Объект.СтатусВзаимодействия = СостояниеСобытия;
	Объект.ЗавершившийПользователь = Пользователи.ТекущийПользователь();
	Если ЗначениеЗаполнено(Объект.ДокументОснование) 
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект.ДокументОснование, "СостояниеИнтереса") Тогда
		Объект.СостояниеИнтереса = Объект.ДокументОснование.СостояниеИнтереса;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если ЗначениеЗаполнено(Объект.ДатаЗавершенияВзаимодействия) Тогда
		Элементы.Завершить.Видимость = Ложь;
		Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.Завершить.Видимость = ЗначениеЗаполнено(Объект.Результат);
		Элементы.Завершить.КнопкаПоУмолчанию = Элементы.Завершить.Видимость;
		Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = НЕ Элементы.Завершить.КнопкаПоУмолчанию;
	КонецЕсли;
	
	ВидимостьПартнера = Не ЗначениеЗаполнено(Объект.КонтактноеЛицо) И ЗначениеЗаполнено(Объект.Партнер);
	ВидимостьПотенциального = Не ЗначениеЗаполнено(Объект.КонтактноеЛицо) 
		И ЗначениеЗаполнено(Объект.ПотенциальныйКлиент) И Не ВидимостьПартнера;
		
	Элементы.Партнер.Видимость = ВидимостьПартнера;
	Элементы.ПотенциальныйКлиент.Видимость = ВидимостьПотенциального;
	Элементы.КонтактноеЛицо.Видимость = Не ВидимостьПартнера И Не ВидимостьПотенциального;
	
КонецПроцедуры

#Область УчетРабочегоВремени

&НаКлиенте
Процедура Подключаемый_Команда_CRM_УказатьТрудозатраты(Команда) Экспорт // АПК:78 процедура вызывается из общего модуля CRM_ТрудозатратыКлиент.
	
	Подключаемый_Команда_CRM_УказатьТрудозатратыНаСервере();
	CRM_ТрудозатратыКлиент.УказатьТрудозатраты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатраты(Команда)
	
	Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатратыНаСервере(Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатратыНаСервере(ИмяКоманды)
	
	CRM_ТрудозатратыСервер.ВыполнитьДействиеНадТаблицейЗаписейТрудозатраты(ЭтотОбъект, ИмяКоманды);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_Команда_CRM_УказатьТрудозатратыНаСервере()
	
	CRM_ТрудозатратыСервер.УказатьТрудозатратыНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиПанельТрудозатрат()
	
	CRM_ТрудозатратыКлиент.ВывестиПанельТрудозатрат(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьПанельТрудозатрат()
	
	CRM_ТрудозатратыКлиент.ЗакрытьПанельТрудозатрат(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_РабочееВремяПользователейПриИзменении(Элемент)
	
	Отказ = Ложь;
	CRM_ТрудозатратыКлиент.РабочееВремяПользователейПриИзменении(ЭтотОбъект, Элемент, Отказ);
	
	Если НЕ Отказ Тогда
		Подключаемый_CRM_РабочееВремяПользователейПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_РабочееВремяПользователейПриИзмененииНаСервере()
	
	CRM_ТрудозатратыСервер.ТаблицаЗаписейПриИзмененииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавления(Элемент, Отказ,
	 Копирование, Родитель, Группа,
	 Параметр)
	
	Отказ = Истина;
	Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавленияНаСервере()
	
	CRM_ТрудозатратыСервер.ТаблицаЗаписейПередНачаломДобавленияНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ПроверитьВозможностьЗавершения()
	СтруктураПоиска = Новый Структура("Выполнено", Ложь);
	СтрокиНЕЗавершено = Объект.ЧекЛист.НайтиСтроки(СтруктураПоиска);
	МожноЗавершить = Истина;
	Для Каждого СтрокаЧЛ Из СтрокиНЕЗавершено Цикл
		Если СтрокаЧЛ.Обязательный Тогда
			МожноЗавершить = Ложь;
		КонецЕсли;	
	КонецЦикла;
	Если НЕ МожноЗавершить Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не выполнены обязательные пункты чек-листа. 
			|Завершить взаимодействие невозможно'"));
	КонецЕсли;	
	Возврат МожноЗавершить;
КонецФункции

&НаКлиенте
Процедура ОбработкаОтветаОЗавершении(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗавершитьНаСервере();
		Записать();
		Закрыть();
	КонецЕсли;
КонецПроцедуры


#Область ЯзыковыеМодели

&НаКлиенте
Процедура Подключаемый_ДоступностьМенюАссистент()
	
	CRM_РаботаСЯзыковымиМоделямиКлиент.ДоступностьМенюАссистент(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	CRM_СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
КонецПроцедуры

#КонецОбласти // ЯзыковыеМодели

#КонецОбласти
