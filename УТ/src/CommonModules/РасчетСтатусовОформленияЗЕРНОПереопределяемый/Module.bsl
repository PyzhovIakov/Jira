// Механизм расчета статусов оформления документов ЗЕРНО.
//

#Область СлужебныйПрограммныйИнтерфейс

// Позволяет переопределить имена реквизитов документа-основания для документа ВестиУчетЗернаИПродуктовПереработкиЗЕРНО.
//
// Параметры:
//  МетаданныеДокументаОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ВестиУчетЗернаИПродуктовПереработкиЗЕРНО>
//  МетаданныеДокументаЗЕРНО - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления
//  Реквизиты  - Структура - имена реквизитов:
//  * Ключ  - служебное имя реквизита в ЗЕРНО
//  * Значение - имя реквизита документа-основания, которое при необходимости надо переопределить
//  (см. РасчетСтатусовОформленияЗЕРНО.СтруктураРеквизитовДляРасчетаСтатусаОформленияДокументов).
Процедура ПриОпределенииИменРеквизитовДляРасчетаСтатусаОформления(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаЗЕРНО, Реквизиты) Экспорт
	//++ НЕ ГОСИС
	РасчетСтатусовОформленияИСУТ.ПриОпределенииРеквизитовОснованияДляЗЕРНО(МетаданныеДокументаОснования, МетаданныеДокументаЗЕРНО, Реквизиты);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Позволяет переопределить текст запроса выборки данных из документов-основания для расчета статуса оформления.
//   Требования к тексту запроса:
//     Если данные из документа выбирать не требуется, переопределение также не заполнять.
//     Результат запроса обязательно должен содержать следующие поля:
//      * Ссылка - ОпределяемыйТип.Основание<Имя документа ЗЕРНО> - ссылка на документ-основание
//      * ЭтоДвижениеПриход - Булево - вид движения ТМЦ (Истина - приход, Ложь - расход)
//      * Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура
//      * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатуры
//      * Серия - ОпределяемыйТип.СерияНоменклатуры - серия номенклатуры
//      * Количество - Число - количество номенклатуры в ее основной единице измерения
//     В результат запроса нужно включать только подконтрольную номенклатуру ЗЕРНО (табак, обувь)
//     Для отбора документов-основания в запросе нужно использовать отбор "В (&МассивДокументов)"
//     Выбранные данные необходимо поместить во временную таблицу (См. РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента).
//
//Параметры:
//   МетаданныеДокументаОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ЗЕРНО>
//   МетаданныеДокументаЗЕРНО - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЗЕРНОПоддерживающиеСтатусыОформления
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо переопределить
//   ДополнительныеПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру
//     Ключ     - имя параметры
//     Значение - значение параметра.
//
Процедура ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформления(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаЗЕРНО, ТекстЗапроса, ДополнительныеПараметрыЗапроса) Экспорт
	
	//++ НЕ ГОСИС
	РасчетСтатусовОформленияИСУТ.ПриОпределенииЗапросаДляЗЕРНО(МетаданныеДокументаОснования, МетаданныеДокументаЗЕРНО, ТекстЗапроса, ДополнительныеПараметрыЗапроса);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти