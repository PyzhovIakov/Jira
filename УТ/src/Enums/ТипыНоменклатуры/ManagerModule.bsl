#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст подсказки по типу номенклатуры
//
// Параметры:
//  ТипНоменклатуры	 - ПеречислениеСсылка.ТипыНоменклатуры	 - тип номенклатуры.
// 
// Возвращаемое значение:
//  Строка - подсказка по типу номенклатуры.
//
Функция ПодсказкаПоТипуНоменклатуры(ТипНоменклатуры) Экспорт
	
	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
		Возврат НСтр("ru = 'Материальные ценности, которые закупаются, производятся, реализуются предприятием и учитываются на складах. Возможен контроль остатков на складах, учет себестоимости, обеспечение потребностей и др.'");
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор Тогда
		ТекстПодсказки = НСтр("ru = 'Комплекты, которые не хранятся на складе, а собираются динамически. Используются для удобного выбора связанных позиций в документах продажи, ценообразовании и печати.'");
		Возврат ТекстПодсказки;
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
		Возврат НСтр("ru = 'Нематериальные ценности, которые закупаются предприятием или реализуются клиентам. Для услуг не ведется учет себестоимости. В момент приобретения услуги указывается статья расходов, определяющая дальнейший учет расходов.'");
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
		Возврат НСтр("ru = 'Нематериальные ценности, которые закупаются или производятся, реализуются клиентам и учитываются в подразделении-получателе. Ведется количественный учет и учет себестоимости.'");
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
		Возврат НСтр("ru = 'Тара, которая учитывается отдельно на складе и может возвращаться поставщику товаров или передаваться на условиях возврата клиенту.'");
	Иначе
		Возврат НСтр("ru = 'Определяет возможности по учету номенклатуры в различных механизмах'");
	КонецЕсли;	
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ИспользоватьМногооборотнуюТару = ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару");
	ИспользоватьНаборы = ПолучитьФункциональнуюОпцию("ИспользоватьНаборы");
	НесколькоВидовНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры");
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	Для Каждого ТекЭлемент Из Перечисления.ТипыНоменклатуры Цикл
		Если ТекЭлемент = Перечисления.ТипыНоменклатуры.МногооборотнаяТара
			И (Не ИспользоватьМногооборотнуюТару ИЛИ Не НесколькоВидовНоменклатуры) Тогда
			Продолжить;
		ИначеЕсли ТекЭлемент = Перечисления.ТипыНоменклатуры.Набор
			И (Не ИспользоватьНаборы ИЛИ Не НесколькоВидовНоменклатуры) Тогда
			Продолжить;
		ИначеЕсли ТекЭлемент = Перечисления.ТипыНоменклатуры.Работа
			И (Не НесколькоВидовНоменклатуры ИЛИ ЭтоБазовая) Тогда
			Продолжить;
		Иначе
			ДанныеВыбора.Добавить(ТекЭлемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
