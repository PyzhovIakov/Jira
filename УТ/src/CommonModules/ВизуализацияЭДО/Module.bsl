// @strict-types
#Область ПрограммныйИнтерфейс

// Возвращает структуру свойств визуализации
// 
// Возвращаемое значение:
//  Структура:
//  * ПросмотрДоступен - Булево
//  * ТребуетсяОбновить - Булево
//  * ПредставлениеДокумента - Неопределено - Пустое представление
//                           - Строка
//                           - ТабличныйДокумент
//                           - ДвоичныеДанные
//  * ФайлВизуализации - СправочникСсылка.КэшВизуализацииДокументовЭДОПрисоединенныеФайлы
//  * ТипДанных - ПеречислениеСсылка.ТипыДанныхВизуализацииДокументаЭДО
//  * ИмяФайла - Строка
//  * РасширениеФайла - Строка
//  * РазмерФайла - Число
//  * ТекстОшибки - Строка - информация о ошибке при подготовке визуализации
//  * ДатаВыполнения - Дата
//  * ХешШтампа - Строка
//  * НастройкиПредставления - см. НовыеНастройкиПредставления
//  * ПолученИзКэша - Булево
//  * ПользовательскиеНастройкиПредставления - см. ПользовательскиеНастройкиПредставления
Функция НовыеСвойстваВизуализации() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ПросмотрДоступен", Ложь);
	Результат.Вставить("ТребуетсяОбновить", Истина);
	Результат.Вставить("ПредставлениеДокумента", Неопределено);
	Результат.Вставить("ФайлВизуализации", Справочники.КэшВизуализацииДокументовЭДОПрисоединенныеФайлы.ПустаяСсылка());
	Результат.Вставить("ТипДанных", Перечисления.ТипыДанныхВизуализацииДокументаЭДО.ПустаяСсылка());
	Результат.Вставить("ИмяФайла", "");
	Результат.Вставить("РасширениеФайла", "");
	Результат.Вставить("РазмерФайла", 0);
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("ДатаВыполнения", Дата(1, 1, 1));
	Результат.Вставить("ХешШтампа", "");
	Результат.Вставить("НастройкиПредставления", НовыеНастройкиПредставления());
	Результат.Вставить("ПолученИзКэша", Ложь);
	Результат.Вставить("ПользовательскиеНастройкиПредставления", ПользовательскиеНастройкиПредставления());

	Возврат Результат;
КонецФункции

// Возвращает структуру настроек представления
// 
// Возвращаемое значение:
//  Структура:
// * ЕстьНастройкаВыводаДополнительныхДанных - Булево
// * ЕстьНастройкаВыводаБанковскихРеквизитов - Булево
// * ЕстьНастройкаВыводаКопияВерна - Булево
// * ЕстьИдДокумента - Булево
// * ЕстьQRКод - Булево
Функция НовыеНастройкиПредставления() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ЕстьНастройкаВыводаДополнительныхДанных", Ложь);
	Результат.Вставить("ЕстьНастройкаВыводаБанковскихРеквизитов", Ложь);
	Результат.Вставить("ЕстьНастройкаВыводаКопияВерна", Ложь);
	Результат.Вставить("ЕстьИдДокумента", Ложь);
	Результат.Вставить("ЕстьQRКод", Ложь);
	Возврат Результат;
КонецФункции

// Возвращает структуру пользовательских настроек представления
// 
// Возвращаемое значение:
//  Структура:
// * ЕстьНастройкаВыводаДополнительныхДанных - Булево
// * ЕстьНастройкаВыводаБанковскихРеквизитов - Булево
// * ЕстьНастройкаВыводаКопияВерна - Булево
Функция ПользовательскиеНастройкиПредставления() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ЕстьНастройкаВыводаДополнительныхДанных", Ложь);
	Результат.Вставить("ЕстьНастройкаВыводаБанковскихРеквизитов", Ложь);
	Результат.Вставить("ЕстьНастройкаВыводаКопияВерна", Ложь);

	Возврат Результат;
КонецФункции

// Новые параметры предварительной визуализации документа.
// 
// Возвращаемое значение:
//  см. ВизуализацияЭДОСлужебный.НовыеПараметрыПредварительнойВизуализацииДокумента
Функция НовыеПараметрыПредварительнойВизуализацииДокумента() Экспорт
	Возврат ВизуализацияЭДОСлужебный.НовыеПараметрыПредварительнойВизуализацииДокумента();
КонецФункции

// Сохранить кэш визуализации документа.
// 
// Параметры:
//  ДокументЭДО - ОпределяемыйТип.ВладелецФайлаВизуализацииЭДО
//  ВизуализацияДокумента - см. НовыеСвойстваВизуализации
//  ОбработатьОчередь - Булево - Обработать очередь
Процедура СохранитьКэшВизуализацииДокумента(ДокументЭДО, ВизуализацияДокумента, ОбработатьОчередь = Ложь) Экспорт
	ЕстьДополнительныеДанные = ВизуализацияДокумента.НастройкиПредставления.ЕстьНастройкаВыводаДополнительныхДанных;
	ЕстьБанковскиеРеквизиты = ВизуализацияДокумента.НастройкиПредставления.ЕстьНастройкаВыводаБанковскихРеквизитов;
	ЕстьКопияВерна = ВизуализацияДокумента.НастройкиПредставления.ЕстьНастройкаВыводаКопияВерна;
	ЕстьИдДокумента = ВизуализацияДокумента.НастройкиПредставления.ЕстьИдДокумента;
	ЕстьQRКод = ВизуализацияДокумента.НастройкиПредставления.ЕстьQRКод;
	ВизуализацияЭДОСлужебный.СохранитьДанныеВФайлКэша(ДокументЭДО, ВизуализацияДокумента);
	
	МенеджерЗаписиОчереди = РегистрыСведений.ОчередьЗапросовВизуализацииЭДО.СоздатьМенеджерЗаписи();
	МенеджерЗаписиКэшаВизуализации = РегистрыСведений.КэшВизуализацииДокументовЭДО.СоздатьМенеджерЗаписи();

	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных();
		Если ОбработатьОчередь Тогда
			ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ОчередьЗапросовВизуализацииЭДО");
			ЭлементБлокировки.УстановитьЗначение("ВладелецФайла", ДокументЭДО);
		КонецЕсли;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.КэшВизуализацииДокументовЭДО");
		ЭлементБлокировки.УстановитьЗначение("ВладелецФайла", ДокументЭДО);
		ЭлементБлокировки.УстановитьЗначение("ЕстьДополнительныеДанные", ЕстьДополнительныеДанные);
		ЭлементБлокировки.УстановитьЗначение("ЕстьБанковскиеРеквизиты", ЕстьБанковскиеРеквизиты);
		ЭлементБлокировки.УстановитьЗначение("ЕстьКопияВерна", ЕстьКопияВерна);
		ЭлементБлокировки.УстановитьЗначение("ЕстьИдДокумента", ЕстьИдДокумента);
		ЭлементБлокировки.УстановитьЗначение("ЕстьQRКод", ЕстьQRКод);
		БлокировкаДанных.Заблокировать();
		
		Если ОбработатьОчередь Тогда
			МаксимальноеЧислоПопытокЗапросаСервиса = 5;
			ПериодОжидания = 3600;
			МенеджерЗаписиОчереди.ВладелецФайла = ДокументЭДО;
			МенеджерЗаписиОчереди.Прочитать();
			Если (ВизуализацияДокумента.ПросмотрДоступен И ВизуализацияДокумента.ТекстОшибки = "")
				Или МенеджерЗаписиОчереди.НомерПопытки > МаксимальноеЧислоПопытокЗапросаСервиса Тогда
				МенеджерЗаписиОчереди.Удалить();
			Иначе
				МенеджерЗаписиОчереди.ВладелецФайла = ДокументЭДО;
				МенеджерЗаписиОчереди.НомерПопытки = МенеджерЗаписиОчереди.НомерПопытки + 1;
				МенеджерЗаписиОчереди.ПлановаяДатаСледующейПопытки = ТекущаяУниверсальнаяДата() + ПериодОжидания;
				МенеджерЗаписиОчереди.Записать();
			КонецЕсли;
		КонецЕсли;
		МенеджерЗаписиКэшаВизуализации.ВладелецФайла = ДокументЭДО;
		МенеджерЗаписиКэшаВизуализации.ЕстьДополнительныеДанные = ЕстьДополнительныеДанные;
		МенеджерЗаписиКэшаВизуализации.ЕстьБанковскиеРеквизиты = ЕстьБанковскиеРеквизиты;
		МенеджерЗаписиКэшаВизуализации.ЕстьКопияВерна = ЕстьКопияВерна;
		МенеджерЗаписиКэшаВизуализации.ЕстьИдДокумента = ЕстьИдДокумента;
		МенеджерЗаписиКэшаВизуализации.ЕстьQRКод = ЕстьQRКод;
		МенеджерЗаписиКэшаВизуализации.Прочитать();
		
		МенеджерЗаписиКэшаВизуализации.ВладелецФайла = ДокументЭДО;
		МенеджерЗаписиКэшаВизуализации.ЕстьДополнительныеДанные = ЕстьДополнительныеДанные;
		МенеджерЗаписиКэшаВизуализации.ЕстьБанковскиеРеквизиты = ЕстьБанковскиеРеквизиты;
		МенеджерЗаписиКэшаВизуализации.ЕстьКопияВерна = ЕстьКопияВерна;
		МенеджерЗаписиКэшаВизуализации.ЕстьИдДокумента = ЕстьИдДокумента;
		МенеджерЗаписиКэшаВизуализации.ЕстьQRКод = ЕстьQRКод;
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиКэшаВизуализации, ВизуализацияДокумента);
		
		МенеджерЗаписиКэшаВизуализации.ДатаВыполнения = ТекущаяУниверсальнаяДата();
		МенеджерЗаписиКэшаВизуализации.ТребуетсяОбновить = Ложь;
		МенеджерЗаписиКэшаВизуализации.Записать();

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
КонецПроцедуры

// Получить визуализацию из кэша.
// 
// Параметры:
//  ДокументЭДО - ОпределяемыйТип.ВладелецФайлаВизуализацииЭДО - Электронные документы ЭДО
//  НастройкиПредставления - см. НовыеНастройкиПредставления
// 
// Возвращаемое значение:
// см. НовыеСвойстваВизуализации
Функция ПолучитьВизуализациюИзКэша(ДокументЭДО, НастройкиПредставления) Экспорт
	Возврат ВизуализацияЭДОСлужебный.ПолучитьВизуализациюИзКэша(ДокументЭДО, НастройкиПредставления);
КонецФункции

// Готовит визуализацию документа и возвращает результат
//  Параметры:
//  ДанныеДокумента - См. ВизуализацияЭДОСлужебный.НовыеСвойстваДокументаДляФормированияВизуализации
//  ПараметрыВизуализации - См. ФорматыЭДО.НовыеПараметрыВизуализацииДокумента
//  ТребуетсяОбновитьКэш - Булево
// 
// Возвращаемое значение:
//  См. ВизуализацияЭДОСлужебный.ВизуализацияДокумента
Функция ВизуализацияДокумента(ДанныеДокумента, ПараметрыВизуализации, ТребуетсяОбновитьКэш = Ложь) Экспорт
	Возврат ВизуализацияЭДОСлужебный.ВизуализацияДокумента(ДанныеДокумента,
		ПараметрыВизуализации, ТребуетсяОбновитьКэш);
КонецФункции

// Возвращает предварительную визуализацию формализованного документа до записи
// 
//  Параметры:
//  ПараметрыПредварительнойВизуализации - см. НовыеПараметрыПредварительнойВизуализацииДокумента
// 
// Возвращаемое значение:
//  См. ВизуализацияЭДОСлужебный.ПредварительнаяВизуализацияДокумента
Функция ПредварительнаяВизуализацияДокумента(ПараметрыПредварительнойВизуализации) Экспорт
	Возврат ВизуализацияЭДОСлужебный.ПредварительнаяВизуализацияДокумента(ПараметрыПредварительнойВизуализации);
КонецФункции

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов 
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить("ПолучитьДанныеВизуализацииЭДО");
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
// 
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	НоваяСтрока = Настройки.Добавить();
	НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПолучитьДанныеВизуализацииЭДО;
	НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьОбменЭД;
	НоваяСтрока.РаботаетСВнешнимиРесурсами = Истина;
	НоваяСтрока.ДоступноВМоделиСервиса = Истина;
	НоваяСтрока.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ПолучитьДанныеВизуализацииЭДО.ИмяМетода);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработкаСобытийЭлектронныхДокументов
// Событие возникает после формирования электронного документа.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеФормированияЭлектронногоДокумента
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеФормированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после полного подписания электронного документа.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеПодписанияЭлектронногоДокумента
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеПодписанияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после завершения регламента по электронному документу.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеЗавершенияОбменаЭлектроннымДокументом
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗавершенияОбменаЭлектроннымДокументом(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после аннулирования электронного документа.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеАннулированияЭлектронногоДокумента
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеАннулированияЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после загрузки документов: подтверждения даты получения оператором (ПДП),
// подтверждения даты отправки оператором (ПДО), извещение о получении покупателя (ИОП),
// подтверждения даты отправки оператором извещение о получении покупателя (ИОППДО)
// по документообороту счета-фактуры.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеЗагрузкиПодтвержденияПоСчетуФактуре
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО, 
//  					- ДокументСсылка.ЭлектронныйДокументВходящийЭДО - Ссылка на электронный документ.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗагрузкиПодтвержденияПоСчетуФактуре(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после загрузки информации получателя по документообороту акта сверки взаиморасчетов.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеЗагрузкиИнформацииПолучателяПоАктуСверкиВзаиморасчетов
// 
// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗагрузкиИнформацииПолучателяПоАктуСверкиВзаиморасчетов(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после загрузки дополнительных сведений по документообороту акта о расхождениях.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеЗагрузкиДополнительныхСведенийПоАктуОРасхождениях
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - ссылка исходящего документа.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеЗагрузкиДополнительныхСведенийПоАктуОРасхождениях(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает перед непосредственным удалением электронного документа из базы данных.
// см. ЭлектронныеДокументыЭДОСобытия.ПередУдалениемДокумента
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО
// 						- ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - Ссылка на электронный документ.
// 	Отказ - Булево - признак отказа от удаления электронного документа.
//
Процедура ПередУдалениемДокумента(ЭлектронныйДокумент, Отказ) Экспорт
	ВизуализацияЭДОСлужебный.УдалитьКэшВизуализацииДокументаЭДО(ЭлектронныйДокумент, Новый Массив);
КонецПроцедуры

// Событие возникает при изменении данных основного файла Электронного документа.
// см. ЭлектронныеДокументыЭДОСобытия.ПриИзмененииДанныхОсновногоФайлаДокумента
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - Ссылка на электронный документ.
Процедура ПриИзмененииДанныхОсновногоФайлаДокумента(ЭлектронныйДокумент) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

// Событие возникает после проверки подписи документа.
// см. ЭлектронныеДокументыЭДОСобытия.ПослеПроверкиПодписиЭлектронногоДокумента
// 
// Параметры:
// 	ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО
// 						- ДокументСсылка.ЭлектронныйДокументИсходящийЭДО - Ссылка на электронный документ.
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики.
Процедура ПослеПроверкиПодписиЭлектронногоДокумента(ЭлектронныйДокумент, КонтекстДиагностики) Экспорт
	ВизуализацияЭДОСлужебный.ОбновитьКэшВизуализации(ЭлектронныйДокумент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти