#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеВЕТИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовВЕТИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.КПередаче);
		Возврат ПараметрыОбновления;
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийВЕТИС - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовВЕТИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если СтатусОбработки = Неопределено Тогда
		СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаПринята;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовВЕТИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.Обрабатывается;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеЗавершенияОбработкиДанныхВЕТИС);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусы(
			ДокументСсылка, 
			СтатусОбработки, 
			СтатусыБазовыйПроцесс);
		Возврат ПараметрыОбновления;
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	
КонецФункции

// Статус после получения данных из ВЕТИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  См. РегистрыСведений.СтатусыДокументовВЕТИС.ВозвращаемоеЗначениеДальнейшиеДействияСтатус
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовВЕТИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ЗагруженыОстатки;
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОтклоненВЕТИС;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусы(
			ДокументСсылка,
			ДополнительныеПараметры.СтатусОбработки,
			СтатусыБазовыйПроцесс);
		Возврат ПараметрыОбновления;
		
	ИначеЕсли Операция = Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхЗаписейСкладскогоЖурнала Тогда
		
		// Выполнена проверка корректности оформления.
		// Из ВетИС получен пустой ответ на запрос измененных записей складского журнала. 
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовВЕТИС.СтруктураСтатусы();
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(
			Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(
			Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеКорректностьДанных);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.РассчитатьСтатусы(
			ДокументСсылка,
			ДополнительныеПараметры.СтатусОбработки, СтатусыБазовыйПроцесс);
		Возврат ПараметрыОбновления;
		
	Иначе
		ВызватьИсключение ОбщегоНазначенияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
КонецФункции


// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Ссылка на документ.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ВЕТИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийВЕТИС - Операция обмена с ВЕТИС.
//  ДополнительныеПараметры - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Изменяет и возвращает статус документа ВЕТИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ, для которого требуется обновить статус.
//  ПараметрыОбновления - Структура - со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие 3.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - новый статус документа ВЕТИС.
Функция ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры) Экспорт
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ПротоколОбменаИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица   = ПротоколОбменаИС.ПустаяТаблицаПоследовательностьОпераций();
	Исходящий = Перечисления.ТипыЗапросовИС.Исходящий;
	Входящий  = Перечисления.ТипыЗапросовИС.Входящий;
	
	ПротоколОбменаИС.ДобавитьОперациюВПоследовательность(Таблица, 0,
		Исходящий,
		Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	ПротоколОбменаИС.ДобавитьОперациюВПоследовательность(Таблица, 0,
		Входящий,
		Перечисления.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала);
	
	Возврат Таблица;
	
КонецФункции

// Определить необходимость перезаписи движений.
//
// Параметры:
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перезаписи движений.
//
Функция ОбновлятьДвижения(ПредыдущийСтатус, НовыйСтатус) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросСкладскогоЖурналаВЕТИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Предыдущий статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияВЕТИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ИнтеграцияВЕТИСПереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
КонецПроцедуры

// Операции допустимых действий.
// 
// Возвращаемое значение:
//  Соответствие Из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС-  Операции допустимых действий
Функция ОперацииДопустимыхДействий() Экспорт
	
	СоответствиеОпераций = Новый Соответствие;
	СоответствиеОпераций.Вставить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные,
		Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	
	Возврат СоответствиеОпераций
	
КонецФункции

#КонецОбласти

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий.
//
// Возвращаемое значение:
//	Строка - Имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	ТипДокумента = ТипДокумента();
	ИменаРеквизитов = ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(ТипДокумента);
	Возврат ИменаРеквизитов;
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//	Объект - Структура - Значения реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  см. ИнтеграцияИС.ПараметрыУказанияСерий
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ТипДокумента = ТипДокумента();
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерий(ТипДокумента, Объект);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//
// Параметры:
//   ПараметрыУказанияСерий - см. ИнтеграцияИС.ПараметрыУказанияСерий
//
// Возвращаемое значение:
//   Строка - Текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТипДокумента = ТипДокумента();
	ТекстЗапроса = ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(ТипДокумента, ПараметрыУказанияСерий);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.Черновик;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи);
	Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОтклоненВЕТИС);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
// 
// Параметры:
//  ТребуетсяПовторноеОформление - Булево -  требуется повторное оформление документа
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС - Конечные статусы.
Функция КонечныеСтатусы(ТребуетсяПовторноеОформление = Истина) Экспорт
	
	Статусы = Новый Массив;
	
	Если Не ТребуетсяПовторноеОформление Тогда
		Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ЗагруженыОстатки);
	КонецЕсли;
	
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСВЕТИС

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
//   Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - дальшейшие действия
//
Функция ВсеТребующиеДействия() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ВыполнитеОбмен);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает массив дальнейших действий с документом, ожидающих регламентных операций
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС - дальшейшие действия
//
Функция ВсеТребующиеОжидания() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеЗавершенияОбработкиДанныхВЕТИС);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	
	Возврат МассивДействий;
	
КонецФункции

#КонецОбласти


#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

//@skip-check module-accessibility-at-client
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СообщенияВЕТИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  ПараметрыПередачи - Структура - Параметры передачи данных
//  ДополнительныеПараметры - Неопределено - 
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПараметрыПередачи.ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные Тогда
		
		Возврат СкладскойЖурналВЕТИСXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецФункции

Функция СкладскойЖурналВЕТИСXML(ДокументСсылка, ПараметрыПередачи, ДополнительныеПараметры)
	
	ДанныеДокумента = ДанныеЗапросаСкладскогоЖурналаВЕТИС(ДокументСсылка, Перечисления.ВидыОперацийВЕТИС.ЗапросЗаписейСкладскогоЖурнала);
	
	Шапка = ДанныеДокумента.Шапка.Выбрать();
	Шапка.Следующий();
	
	ПараметрыОбмена = ИнтеграцияВЕТИС.ПараметрыОбмена(Шапка.ХозяйствующийСубъект);
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ХозяйствующийСубъект",   Шапка.ХозяйствующийСубъект);
	ПараметрыЗапроса.Вставить("Предприятие",            Шапка.Предприятие);
	ПараметрыЗапроса.Вставить("КоличествоЭлементов",    ПараметрыОбмена.РазмерПорции);
	ПараметрыЗапроса.Вставить("Смещение",               0);
	ПараметрыЗапроса.Вставить("ПервыйЗапрос",           Истина);
	ПараметрыЗапроса.Вставить("ПоследнийЗапрос",        Ложь);
	ПараметрыЗапроса.Вставить("СмещениеПервогоЗапроса", 0);
	ПараметрыЗапроса.Вставить("Документ",               ДокументСсылка);
	ПараметрыЗапроса.Вставить("Версия",                 НомерВерсии);
	
	СообщенияXML = ЗаявкиВЕТИС.ЗапросЗаписейСкладскогоЖурналаXML(
		Шапка.ХозяйствующийСубъект,
		ПараметрыЗапроса,
		ПараметрыОбмена);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция ДанныеЗапросаСкладскогоЖурналаВЕТИС(ДокументСсылка, Операция)
	
	СписокЗапросов = Новый СписокЗначений;
	
	#Область Версии
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВЕТИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
	|ПОМЕСТИТЬ Версии
	|ИЗ
	|	Справочник.ВЕТИСПрисоединенныеФайлы КАК ВЕТИСПрисоединенныеФайлы
	|ГДЕ
	|	ВЕТИСПрисоединенныеФайлы.Документ = &Ссылка
	|	И ВЕТИСПрисоединенныеФайлы.Операция = &Операция
	|	И ВЕТИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)";
	
	СписокЗапросов.Добавить(ТекстЗапроса, "Версии");
	
	#КонецОбласти
	
	#Область Шапка
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Шапка.Номер                         КАК Номер,
	|	Шапка.Дата                          КАК Дата,
	|	Шапка.Идентификатор                 КАК Идентификатор,
	|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)  КАК ПоследнийНомерВерсии,
	|	
	|	&Операция                           КАК Операция,
	|	
	|	Шапка.ХозяйствующийСубъект               КАК ХозяйствующийСубъект,
	|	Шапка.ХозяйствующийСубъект.Идентификатор КАК ХозяйствующийСубъектGUID,
	|	
	|	Шапка.Предприятие                      КАК Предприятие,
	|	Шапка.Предприятие.Идентификатор        КАК ПредприятиеGUID,
	|	
	|	Шапка.Ответственный                    КАК Ответственный,
	|	Шапка.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ЗапросСкладскогоЖурналаВЕТИС КАК Шапка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
	|		ПО (Истина)
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка";
	
	СписокЗапросов.Добавить(ТекстЗапроса, "Шапка");
	
	#КонецОбласти
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Операция);
	
	Результат = ОбщегоНазначенияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов, Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//   МассивОбъектов        - Массив из Произвольный         - ссылки на объекты, которые нужно распечатать
//   ПараметрыПечати       - Структура                      - дополнительные настройки печати
//   КоллекцияПечатныхФорм - ТаблицаЗначений                - сформированные табличные документы (выходной параметр)
//   ОбъектыПечати         - СписокЗначений из Произвольный - имя области, в которой был выведен объект (выходной параметр)
//   ПараметрыВывода       - Структура                      - дополнительные параметры сформированных табличных документов (выходной параметр)
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДвиженияСерийТоваров(ТекстыЗапроса, Регистры);
	
	ИнтеграцияИС.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаДвиженияСерийТоваров(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ИнтеграцияИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли; 
	
	ТекстЗапроса = ИнтеграцияВЕТИС.ТекстЗапросаДвижениеСерийТоваров(Метаданные.Документы.ЗапросСкладскогоЖурналаВЕТИС);
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата   КАК Период,
	|	ДанныеШапки.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗапросСкладскогоЖурналаВЕТИС КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Возврат;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

Функция ТипДокумента()
	
	ТипДокумента = Метаданные.Документы.ЗапросСкладскогоЖурналаВЕТИС;
	
	Возврат ТипДокумента;
	
КонецФункции

#КонецОбласти

#КонецЕсли