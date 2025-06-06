#Область ПрограммныйИнтерфейс

// В процедуре нужно заполнить реквизиты переданных контрагентов для отображения в отчете "Информация об организации ЕГАИС".
//
// Параметры:
//  СоответствиеРеквизитовКонтрагентам - Соответствие - соответствие для заполнения.
//   * Ключ - ссылка на контрагента,
//   * Значение - заполненная структура значений.
//  СписокКонтрагентов - Массив - массив контрагентов, выводимых в отчет,
//  Реквизиты - Структура - ключ - имя реквизита, значение - значение, которое нужно заполнить:
//   * ТипОрганизации - ПеречислениеСсылка.ТипыОрганизацийЕГАИС
//   * Наименование - Строка
//   * НаименованиеПолное - Строка
//   * ИНН - Строка
//   * КПП - Строка
//   * КодСтраны - Число
//   * КодРегиона - Число
//   * ПочтовыйИндекс - Число
//   * Адрес - Строка.
Процедура ЗаполнитьРеквизитыКонтрагентов(СоответствиеРеквизитовКонтрагентам, СписокКонтрагентов, Реквизиты) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	
КонецПроцедуры

// В процедуре нужно заполнить таблицу продаж по переданным параметрам для отчета "Обработанные чеки ЕГАИС".
//
// Параметры:
//  ТаблицаПродаж - ТаблицаЗначений - таблица, которую требуется заполнить. Колонки:
//   * Период - Дата
//   * ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС
//   * АлкогольнаяПродукция - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС
//   * ЧековПродаж - Число
//   * ЧековНаВозврат - Число
Процедура ЗаполнитьКоличествоЧековПродаж(ТаблицаПродаж) Экспорт
	
	//++ НЕ ГОСИС
	ТаблицаПродаж.Индексы.Добавить("Период,ОрганизацияЕГАИС,АлкогольнаяПродукция");
	УстановитьПривилегированныйРежим(Истина);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти