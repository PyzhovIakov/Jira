// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращаемое значение:
//  ОбщийМодуль
Функция МенеджерДействийСПакетамиДокументовИнтеграцииОблачногоЭДО() Экспорт
	Возврат ПакетыДокументовЭДОИнтеграцияОблака;
КонецФункции

// Параметры:
//  ЭлектронныеДокументы - Массив Из ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
//  Идентификатор - Неопределено,УникальныйИдентификатор - если не передан - документам будет присвоен новый идентификатор пакета
// 
// Возвращаемое значение:
//  См. ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом
Функция СоздатьПакетДокументов(ЭлектронныеДокументы, КонтекстДиагностики, Идентификатор = Неопределено) Экспорт
	
	Результат = ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом();
	Результат.КонтекстДиагностики = КонтекстДиагностики;
	
	ИдентификаторыДокументовИОрганизаций = ЭлектронныеДокументыЭДОИнтеграцияОблака.ИдентификаторыДокументовИОрганизаций(
		ЭлектронныеДокументы);
	ИдентификаторыОрганизаций = ОбщегоНазначения.ВыгрузитьКолонку(ИдентификаторыДокументовИОрганизаций, "Ключ");
	
	УчетныеЗаписиПоИдентификаторамЭДО = РегистрыСведений.НастройкиОблачногоЭДО.УчетныеЗаписиПоИдентификаторамЭДО(
		ИдентификаторыОрганизаций);
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	РезультатВыполнения = Неопределено;
	
	Для Каждого УчетнаяЗаписьПоИдентификаторуЭДО Из УчетныеЗаписиПоИдентификаторамЭДО Цикл
		
		ИдентификаторЭДО = УчетнаяЗаписьПоИдентификаторуЭДО.Ключ;
		УчетнаяЗаписьОблачногоЭДО = УчетнаяЗаписьПоИдентификаторуЭДО.Значение;
		ИдентификаторыДокументовЭДО = ИдентификаторыДокументовИОрганизаций[ИдентификаторЭДО];
		
		Если ИдентификаторыДокументовЭДО = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыВыполнения = ИнтеграцияОблачногоЭДОПовтИсп.ПараметрыВыполненияМетодаСервиса(
			УчетнаяЗаписьОблачногоЭДО, ТекущийПользователь);
		
		ОписаниеМетода = ИнтеграцияОблачногоЭДО.ОписаниеМетодаСервиса(
			"СоздатьПакетДокументовЭДО", ИдентификаторыДокументовЭДО);
		
		РезультатВыполнения = ИнтеграцияОблачногоЭДО.ВыполнитьМетодСервиса(
			ПараметрыВыполнения, ОписаниеМетода, КонтекстДиагностики); // См. ПрограммныйИнтерфейсОблачногоЭДОВерсия1.СоздатьПакетДокументовЭДО
		
	КонецЦикла;

	Если Не МетодВыполненУспешно(РезультатВыполнения, КонтекстДиагностики) Тогда
		Возврат Результат;
	КонецЕсли;

	ИдентификаторПакета = Новый УникальныйИдентификатор(РезультатВыполнения.ИдентификаторПакета);
	
	Возврат ПакетыДокументовЭДО.СоздатьПакетДокументовЛокально(ЭлектронныеДокументы, КонтекстДиагностики,
		ИдентификаторПакета);
	
КонецФункции

// @skip-check property-return-type
// 
// Параметры:
//  ИдентификаторПакета - УникальныйИдентификатор
//  ЭлектронныеДокументы - Массив Из ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  КонтекстДиагностики - Неопределено - если контекст не инициализирован.
//                      - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 
// Возвращаемое значение:
//  См. ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом
Функция ДобавитьДокументыВПакет(ИдентификаторПакета, ЭлектронныеДокументы, КонтекстДиагностики = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(КонтекстДиагностики) Тогда
		КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	КонецЕсли;
	
	Результат = ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом();
	Результат.КонтекстДиагностики = КонтекстДиагностики;
	
	ИдентификаторыДокументовИОрганизаций = ЭлектронныеДокументыЭДОИнтеграцияОблака.ИдентификаторыДокументовИОрганизаций(
		ЭлектронныеДокументы);
	ИдентификаторыОрганизаций = ОбщегоНазначения.ВыгрузитьКолонку(ИдентификаторыДокументовИОрганизаций, "Ключ");
	
	УчетныеЗаписиПоИдентификаторамЭДО = РегистрыСведений.НастройкиОблачногоЭДО.УчетныеЗаписиПоИдентификаторамЭДО(
		ИдентификаторыОрганизаций);
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	РезультатВыполнения = Неопределено;
	
	Для Каждого УчетнаяЗаписьПоИдентификаторуЭДО Из УчетныеЗаписиПоИдентификаторамЭДО Цикл
	
		ИдентификаторЭДО = УчетнаяЗаписьПоИдентификаторуЭДО.Ключ;
		УчетнаяЗаписьОблачногоЭДО = УчетнаяЗаписьПоИдентификаторуЭДО.Значение;
		ИдентификаторыДокументовЭДО = ИдентификаторыДокументовИОрганизаций[ИдентификаторЭДО];
		
		Если ИдентификаторыДокументовЭДО = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ПараметрыВыполнения = ИнтеграцияОблачногоЭДОПовтИсп.ПараметрыВыполненияМетодаСервиса(
			УчетнаяЗаписьОблачногоЭДО, ТекущийПользователь);
		
		ОписаниеМетода = ИнтеграцияОблачногоЭДО.ОписаниеМетодаСервиса(
			"ДобавитьДокументыЭДОВПакет", Строка(ИдентификаторПакета), ИдентификаторыДокументовЭДО);
		
		РезультатВыполнения = ИнтеграцияОблачногоЭДО.ВыполнитьМетодСервиса(ПараметрыВыполнения, ОписаниеМетода,
			КонтекстДиагностики); // См. ПрограммныйИнтерфейсОблачногоЭДОВерсия1.ДобавитьДокументыЭДОВПакет

	КонецЦикла;
	
	Если Не МетодВыполненУспешно(РезультатВыполнения, КонтекстДиагностики) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Возврат ПакетыДокументовЭДО.ДобавитьДокументыВПакетЛокально(ИдентификаторПакета, ЭлектронныеДокументы,
		КонтекстДиагностики);
	
КонецФункции

// @skip-check property-return-type
// 
// Параметры:
//  ИдентификаторПакета - УникальныйИдентификатор
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  КонтекстДиагностики - Неопределено - если контекст не инициализирован.
//                      - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 
// Возвращаемое значение:
//  см. ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом
Функция УдалитьДокументИзПакета(ИдентификаторПакета, ЭлектронныйДокумент, КонтекстДиагностики = Неопределено) Экспорт
	
	Результат = ПакетыДокументовЭДО.НовыйРезультатДействийСПакетом();
	Результат.КонтекстДиагностики = КонтекстДиагностики;
	
	Если Не ЗначениеЗаполнено(КонтекстДиагностики) Тогда
		КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	КонецЕсли;
	
	ИдентификаторыДокументаИОрганизации = ЭлектронныеДокументыЭДО.СвойстваДокумента(ЭлектронныйДокумент,
		"ИдентификаторДокумента, ИдентификаторОрганизации");
	ИдентификаторДокумента = ИдентификаторыДокументаИОрганизации.ИдентификаторДокумента; // Строка
	ИдентификаторОрганизации = ИдентификаторыДокументаИОрганизации.ИдентификаторОрганизации; // Строка
	
	УчетнаяЗаписьОблачногоЭДО = РегистрыСведений.НастройкиОблачногоЭДО.УчетнаяЗаписьОблачногоЭДО(
		ИдентификаторОрганизации);
		
	ПараметрыВыполнения = ИнтеграцияОблачногоЭДОПовтИсп.ПараметрыВыполненияМетодаСервиса(
		УчетнаяЗаписьОблачногоЭДО, Пользователи.ТекущийПользователь());
		
	ОписаниеМетода = ИнтеграцияОблачногоЭДО.ОписаниеМетодаСервиса(
		"УдалитьДокументЭДОИзПакета", Строка(ИдентификаторПакета), ИдентификаторДокумента);
	
	РезультатВыполнения = ИнтеграцияОблачногоЭДО.ВыполнитьМетодСервиса(ПараметрыВыполнения, ОписаниеМетода,
		КонтекстДиагностики); // См. ПрограммныйИнтерфейсОблачногоЭДОВерсия1.УдалитьДокументЭДОИзПакета
	
	Если Не МетодВыполненУспешно(РезультатВыполнения, КонтекстДиагностики) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Возврат ПакетыДокументовЭДО.УдалитьДокументИзПакетаЛокально(ИдентификаторПакета, ЭлектронныйДокумент,
		КонтекстДиагностики);
	
КонецФункции

// Обновить состав пакета.
// 
// Параметры:
//  ИдентификаторПакета - УникальныйИдентификатор
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  ДополнительныеПараметры - Структура:
//  * ИдентификаторОрганизации - Строка
//  * ИдентификаторДокумента - Строка
Процедура ОбновитьСоставПакета(Знач ИдентификаторПакета, ЭлектронныйДокумент, ДополнительныеПараметры = Неопределено) Экспорт
	
	НаборЗаписей = РегистрыСведений.СоставПакетовДокументовЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЭлектронныйДокумент.Установить(ЭлектронныйДокумент);
	
	НачатьТранзакцию();
	Попытка
		
		НаборЗаписей.Прочитать();
		ОбновитьОписаниеПакета = Ложь;
		Если ЗначениеЗаполнено(НаборЗаписей) И Не ЗначениеЗаполнено(ИдентификаторПакета) Тогда // Удаление
			ИдентификаторПакета = НаборЗаписей[0].ИдентификаторПакета;
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
			
			ДокументыПакета = ПакетыДокументовЭДО.ДокументыПакета(ИдентификаторПакета);
			Если ДокументыПакета = 1 Тогда
				РегистрыСведений.СоставПакетовДокументовЭДО.Удалить(ЭлектронныйДокумент, ДополнительныеПараметры);
				РегистрыСведений.ПакетыДокументовЭДО.Удалить(ИдентификаторПакета);
			ИначеЕсли ДокументыПакета = 0 Тогда
				РегистрыСведений.ПакетыДокументовЭДО.Удалить(ИдентификаторПакета);
			Иначе
				ОбновитьОписаниеПакета = Истина;
			КонецЕсли;
			
		ИначеЕсли Не ЗначениеЗаполнено(НаборЗаписей) И ЗначениеЗаполнено(ИдентификаторПакета) Тогда // Добавление
			ЗаписьНабора = НаборЗаписей.Добавить();
			ЗаписьНабора.ИдентификаторПакета = ИдентификаторПакета;
			ЗаписьНабора.ЭлектронныйДокумент = ЭлектронныйДокумент;
			НаборЗаписей.Записать();
			
			ДокументыПакета = ПакетыДокументовЭДО.ДокументыПакета(ИдентификаторПакета);
			ОбновитьОписаниеПакета = Истина;
			
		КонецЕсли;
		
		Если ОбновитьОписаниеПакета Тогда
			СвойстваДокументов = ЭлектронныеДокументыЭДО.СвойстваДокументовДляОписанияПакетов(ДокументыПакета);
			РегистрыСведений.ПакетыДокументовЭДО.ОбновитьОписание(ИдентификаторПакета, СвойстваДокументов);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  РезультатМетода - Неопределено,Структура:
//  * Успех - Булево
//  * Ошибки - Массив Из Строка
//  КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 
// Возвращаемое значение:
//  Булево
Функция МетодВыполненУспешно(РезультатМетода, КонтекстДиагностики)
	
	Если Не ЗначениеЗаполнено(РезультатМетода) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатМетода.Ошибки) Тогда
		Возврат РезультатМетода.Успех;
	КонецЕсли;
	
	ВидОперации = ПакетыДокументовЭДОКлиентСервер.ВидОперацииДействияСПакетамиДокументов();
	Для Каждого Ошибка Из РезультатМетода.Ошибки Цикл
		ИнтеграцияОблачногоЭДО.ДобавитьНеизвестнуюОшибку(КонтекстДиагностики, ВидОперации, Ошибка);
	КонецЦикла;
	
	Возврат РезультатМетода.Успех
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции