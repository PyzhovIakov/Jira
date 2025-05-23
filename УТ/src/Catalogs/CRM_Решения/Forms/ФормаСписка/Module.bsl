
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ CRM_ЛицензированиеЭкспортныеМетоды.ПодсистемаCRMИспользуется() Тогда
		CRM_ЛицензированиеЭкспортныеМетоды.ВывестиУведомлениеОНедоступности(НСтр("ru = 'Решения базы знаний'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьЗащищеннуюОбработку().
			АРМБазаЗнаний_ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Устанавливаем отбор по текущему пользователю и статусам решений.
	СписокСостояний = Новый СписокЗначений;
	СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.Утверждено);
	СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.Устарело);
	Если CRM_БазаЗнанийСервер.ЕстьПраваАдминистратора() Тогда
		СписокСостояний.Добавить(Перечисления.CRM_СтатусыРешений.НаРассмотрении);
	КонецЕсли;	
	Для Каждого ЭлементОтбораГруппы Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если НЕ (ЭлементОтбораГруппы.Представление = "ОтборРешений") Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого ЭлементОтбора Из ЭлементОтбораГруппы.Элементы Цикл
			Если ЭлементОтбора.Представление = "ОтборПоАвтору" Тогда
				ЭлементОтбора.ПравоеЗначение = Пользователи.АвторизованныйПользователь();
			ИначеЕсли ЭлементОтбора.Представление = "ОтборПоСтатусу" Тогда
				ЭлементОтбора.ПравоеЗначение = СписокСостояний;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
	РежимВыбора = Параметры.РежимВыбора;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		 "ТекущийПользователь", Пользователи.ТекущийПользователь(),
		 Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		 "ЕстьПраваАдминистратора", CRM_БазаЗнанийСервер.ЕстьПраваАдминистратора(),
		 Истина);
	
	Если Не Константы.CRM_ИспользоватьСтатусыОтветовБазыЗнаний.Получить() Тогда
		
		Элементы.СтатусРешения.Видимость = Ложь;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Доступно", Истина,
																						ВидСравненияКомпоновкиДанных.Равно, , Истина,
																						РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Процедура - обработчик события формы "ОбработкаОповещения".
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если (ИмяСобытия = "CRM_РешенияОбновлениеСправочника") И (Параметр = ТекущийВопрос) Тогда
		СодержимоеРезультата = CRM_БазаЗнанийСервер.ЗаполнитьПредставлениеРешенияДляСписка(Параметр, УникальныйИдентификатор);
	КонецЕсли;	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события "Выбор" табличной части "Список".
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(ВыбраннаяСтрока);
	КонецЕсли;	
КонецПроцедуры // СписокВыбор()

&НаКлиенте
// Процедура - обработчик события "ПриАктивизацииСтроки" табличной части "Список".
//
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработчикСписокПриАктивизацииСтроки", 0.5, Истина);
КонецПроцедуры // СписокПриАктивизацииСтроки()

// Процедура - обработчик события "ПриНажатии" поля описания решения.
//
&НаКлиенте
Процедура ТекстВопросаHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	CRM_ОбщегоНазначенияКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, , Элемент.Документ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПустоеОписание()
	Возврат
	"<html>
	|<head>  
	|<META http-equiv=Content-Type content=""text/html; charset=utf-8"">
	|<META content=""MSHTML 6.00.2800.1400"" name=GENERATOR>
	|<body scroll=""auto"">
	|</body>
	|</html>";
КонецФункции

&НаКлиенте
// Процедура - обработчик события "ПриАктивизацииСтроки" табличной части "Список".
//
// Параметры:
//	Нет.
//
Процедура ОбработчикСписокПриАктивизацииСтроки()
	
	Если ТекущийВопрос = Элементы.Список.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийВопрос = Элементы.Список.ТекущаяСтрока;
	
	Если ТекущийВопрос = Неопределено Тогда 
		СодержимоеРезультата = СформироватьПустоеОписание();
	Иначе
		СодержимоеРезультата = CRM_БазаЗнанийСервер.ЗаполнитьПредставлениеРешенияДляСписка(ТекущийВопрос,
			 УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры // ОбработчикСписокПриАктивизацииСтроки()

#КонецОбласти
