#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтрокиОтчета.ДатаР					КАК Период,
	|	СтрокиОтчета.Ссылка					КАК Регистратор,
	|	
	|	СтрокиОтчета.Ссылка.Сотрудник		КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА СтрокиОтчета.ПодразделениеРабот = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) ТОГДА СтрокиОтчета.Ссылка.Подразделение
	|		ИНАЧЕ СтрокиОтчета.ПодразделениеРабот
	|	КОНЕЦ								КАК ПодразделениеРабот,
	|	СтрокиОтчета.Проект					КАК Проект,
	|	СтрокиОтчета.Этап					КАК Этап,
	|	СтрокиОтчета.ДатаР					КАК ДатаРабот,
	|	СУММА(СтрокиОтчета.Часов)			КАК Часов
	|ИЗ
	|	Документ.CRM_ОтчетОРаботе.СтрокиОтчета КАК СтрокиОтчета
	|ГДЕ
	|	СтрокиОтчета.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	СтрокиОтчета.Ссылка,
	|	ВЫБОР
	|		КОГДА СтрокиОтчета.ПодразделениеРабот = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) ТОГДА СтрокиОтчета.Ссылка.Подразделение
	|		ИНАЧЕ СтрокиОтчета.ПодразделениеРабот
	|	КОНЕЦ,
	|	СтрокиОтчета.Проект,
	|	СтрокиОтчета.Этап,
	|	СтрокиОтчета.ДатаР
	|";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРабочееВремя", Запрос.Выполнить().Выгрузить());
КонецПроцедуры

#КонецОбласти

#КонецЕсли