#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет порядок оплаты по умолчанию.
//
// Параметры:
//  Валюта             - СправочникСсылка.Валюты - Валюта соглашения
//  НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Необязательное, тип налогообложения НДС документа
//  ВалютаОплаты       - СправочникСсылка.Валюты - Необязательное, валюта предполагаемой оплаты.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.УдалитьПорядокОплатыПоСоглашениям - порядок оплаты по умолчанию.
//
Функция ПолучитьПорядокОплатыПоУмолчанию(Валюта, НалогообложениеНДС = Неопределено, ЗНАЧ ВалютаОплаты = Неопределено) Экспорт
	
	ВалютаРегламентированногоУчета = Константы.БазоваяВалютаПоУмолчанию.Получить();
	Если НЕ ЗначениеЗаполнено(ВалютаОплаты) Тогда
		ВалютаОплаты = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если Валюта = ВалютаРегламентированногоУчета Тогда
		Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт
			ИЛИ НЕ ВалютаОплаты = ВалютаРегламентированногоУчета Тогда
			ПорядокОплаты = Перечисления.УдалитьПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте;
		Иначе
			ПорядокОплаты = Перечисления.УдалитьПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях;
		КонецЕсли;
	Иначе
		Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт 
			ИЛИ НЕ ВалютаОплаты = ВалютаРегламентированногоУчета Тогда
			ПорядокОплаты = Перечисления.УдалитьПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
		Иначе
			ПорядокОплаты = Перечисления.УдалитьПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПорядокОплаты;

КонецФункции // ПолучитьПорядокОплатыПоУмолчанию()

// Заполняет возможные порядки оплаты
//
// Параметры:
//  ВалютаРасчетов - СправочникСсылка.Валюты - Валюта расчетов.
//  ЭлементФормы   - ПолеФормы - поле на форме, список выбора которого необходимо заполнить.
//  ПорядокОплаты  - ПеречислениеСсылка.УдалитьПорядокОплатыПоСоглашениям - текущий порядок оплаты.
//
Процедура ЗаполнитьВозможныеПорядкиОплаты(ВалютаРасчетов, ЭлементФормы, ПорядокОплаты) Экспорт
	
	ВалютаРегл = Константы.БазоваяВалютаПоУмолчанию.Получить();
	
	Список = ЭлементФормы.СписокВыбора;
	Список.Очистить();
	
	ТекстВРублях = НСтр("ru='Оплата в рублях'");
	ТекстВВалюте = НСтр("ru='Оплата в валюте'");
	
	Если ВалютаРасчетов = ВалютаРегл Тогда
		Список.Добавить(РасчетыВРубляхОплатаВРублях, ТекстВРублях);
		Список.Добавить(РасчетыВРубляхОплатаВВалюте, ТекстВВалюте);
	ИначеЕсли ЗначениеЗаполнено(ВалютаРасчетов) Тогда
		Список.Добавить(РасчетыВВалютеОплатаВРублях, ТекстВРублях);
		Список.Добавить(РасчетыВВалютеОплатаВВалюте, ТекстВВалюте);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПорядокОплаты) И Список.НайтиПоЗначению(ПорядокОплаты) = Неопределено Тогда
	
		Список.Добавить(ПорядокОплаты);
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	Для Каждого ТекЭлемент Из Перечисления.УдалитьПорядокОплатыПоСоглашениям Цикл
		
		Если ТекЭлемент <> Перечисления.УдалитьПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях
			И Не ИспользоватьНесколькоВалют Тогда
			Продолжить;
		КонецЕсли;

		ДанныеВыбора.Добавить(ТекЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
