#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет вид цены по умолчанию
//
// Параметры:
//  ВидЦены - СправочникСсылка.ВидыЦенПоставщиков - Вид цены,
//	Отборы -  Структура - Структура отборов, где Ключ - имя реквизита, Значение - значение реквизита.
//
// Возвращаемое значение:
//	СправочникСсылка.ВидыЦенПоставщиков - Найденный вид цен.
//
Функция ВидЦеныПоУмолчанию(Знач ВидЦены, Отборы = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат ВидЦены;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ВидыЦен.Ссылка КАК ВидЦены
	|ИЗ
	|	Справочник.ВидыЦенПоставщиков КАК ВидыЦен
	|ГДЕ
	|	НЕ ВидыЦен.ПометкаУдаления
	|");
	
	Если Отборы <> Неопределено Тогда
		Для каждого Отбор Из Отборы Цикл
			Запрос.Текст = Запрос.Текст + "
				|	И ВидыЦен." + Отбор.Ключ + " = &" + Отбор.Ключ;
			Запрос.УстановитьПараметр(Отбор.Ключ, Отбор.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ВидЦены = Выборка.ВидЦены;
	Иначе
		ВидЦены = Справочники.ВидыЦенПоставщиков.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВидЦены;

КонецФункции

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	Результат.Добавить("Валюта");
	Результат.Добавить("ЦенаВключаетНДС");
	Результат.Добавить("ДоступноДляЗакупки");
	Результат.Добавить("ДоступноДляПродажиКлиентам");

	Возврат Результат;

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли