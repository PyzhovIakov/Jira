#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив из Строка - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("УчетНДС");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("ИсправлениеДокументов");
	
	СписаниеНДСНаРасходыЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.СписаниеНДСНаРасходы") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаНДСАвансыПолученные(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДвиженияПоПрочимАктивамПассивам(Запрос, ТекстыЗапроса, Регистры);
		СписаниеНДСНаРасходыЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	СписаниеНДСНаРасходыЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	СписаниеНДСНаРасходыЛокализация.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Заполняет табличную часть Ценности с отбором по реквизитам шапки документа.
//
// Параметры:
//   ДокументОбъект - ДокументОбъект.СписаниеНДСНаРасходы - Ссылка на объект документа.
//
Процедура ЗаполнитьТаблицуЦенности(ДокументОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДСПредъявленный.ВидЦенности КАК ВидЦенности,
	|	НДСПредъявленный.СтавкаНДС КАК СтавкаНДС,
	|	НДСПредъявленный.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|	НДСПредъявленный.РеализацияЭкспорт КАК РеализацияЭкспорт,
	|	НДСПредъявленный.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НДСПредъявленный.ИсправленныйСчетФактура КАК ИсправленныйСчетФактура,
	|	НДСПредъявленный.СуммаБезНДСОстаток КАК СуммаБезНДС,
	|	НДСПредъявленный.НДСОстаток КАК НДС,
	|	НДСПредъявленный.НДСУпрОстаток КАК НДСУпр
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный.Остатки(
	|		&Период,
	|		Организация = &Организация 
	|		И СчетФактура = &СчетФактура 
	|		И Поставщик = &Поставщик) КАК НДСПредъявленный
	|";
	
	Запрос.УстановитьПараметр("Период",      Новый Граница(ДокументОбъект.Дата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ДокументОбъект.Организация);
	Запрос.УстановитьПараметр("Поставщик",   ДокументОбъект.Контрагент);
	Запрос.УстановитьПараметр("СчетФактура", ДокументОбъект.СчетФактура);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДокументОбъект.Ценности.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла; 
	
КонецПроцедуры

// Заполняет табличную часть АвансыПолученные с отбором по реквизитам шапки документа.
//
// Параметры:
//   ДокументОбъект - ДокументОбъект.СписаниеНДСНаРасходы - Ссылка на объект документа.
//
Процедура ЗаполнитьТаблицуАвансыПолученные(ДокументОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДСАвансыПолученные.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НДСАвансыПолученные.ОбъектРасчетов КАК ОбъектРасчетов,
	|	НДСАвансыПолученные.ИсправленныйСчетФактура КАК ИсправленныйСчетФактура,
	|	НДСАвансыПолученные.Подразделение КАК Подразделение,
	|	НДСАвансыПолученные.СтавкаНДС КАК СтавкаНДС,
	|	НДСАвансыПолученные.СуммаБезНДСОстаток КАК СуммаБезНДС,
	|	НДСАвансыПолученные.НДСОстаток КАК НДС,
	|	НДСАвансыПолученные.НДСУпрОстаток КАК НДСУпр
	|ИЗ
	|	РегистрНакопления.НДСАвансыПолученные.Остатки(
	|		&Период,
	|		Организация = &Организация 
	|		И ДокументОплаты = &ДокументОплаты 
	|		И Контрагент = &Контрагент) КАК НДСАвансыПолученные
	|";
	
	Запрос.УстановитьПараметр("Период",         Новый Граница(ДокументОбъект.Дата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",    ДокументОбъект.Организация);
	Запрос.УстановитьПараметр("Контрагент",     ДокументОбъект.Контрагент);
	Запрос.УстановитьПараметр("ДокументОплаты", ДокументОбъект.ДокументОплаты);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДокументОбъект.АвансыПолученные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла; 
	
КонецПроцедуры


// Возвращает параметры выбора статей в документе.
// 
// Возвращаемое значение:
//	см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики.
//
Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	МассивПаметровВыбора = Новый Массив;
	
	#Область СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным =    "Объект";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	ПараметрыВыбора.ТипСтатьи = "ТипСтатьи";
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ВыборСтатьиАктивовПассивов = Истина;
	ПараметрыВыбора.АналитикаАктивовПассивов = "АналитикаАктивовПассивов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("АналитикаАктивовПассивов");
	
	МассивПаметровВыбора.Добавить(ПараметрыВыбора);
	#КонецОбласти
	
	Возврат МассивПаметровВыбора;
	
КонецФункции


#Область ДляВызоваИзДругихПодсистем

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ИсправлениеДокументов.ДобавитьКомандуИсправление(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	ИсправлениеДокументов.ДобавитьКомандуСторно(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.СписаниеНДСНаРасходы);
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

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

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеНДСНаРасходы.Ссылка,
	|	СписаниеНДСНаРасходы.ПометкаУдаления,
	|	СписаниеНДСНаРасходы.Номер,
	|	СписаниеНДСНаРасходы.Дата,
	|	СписаниеНДСНаРасходы.Проведен,
	|	СписаниеНДСНаРасходы.ХозяйственнаяОперация,
	|	СписаниеНДСНаРасходы.Организация,
	|	СписаниеНДСНаРасходы.Контрагент,
	|	СписаниеНДСНаРасходы.СчетФактура,
	|	СписаниеНДСНаРасходы.ДокументОплаты,
	|	СписаниеНДСНаРасходы.СтатьяРасходов,
	|	СписаниеНДСНаРасходы.Подразделение,
	|	СписаниеНДСНаРасходы.АналитикаРасходов,
	|	СписаниеНДСНаРасходы.Комментарий,
	|	СписаниеНДСНаРасходы.СуммаБезНДС,
	|	СписаниеНДСНаРасходы.Исправление,
	|	СписаниеНДСНаРасходы.СторнируемыйДокумент,
	|	СписаниеНДСНаРасходы.ИсправляемыйДокумент,
	|	СписаниеНДСНаРасходы.СуммаНДС
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК СписаниеНДСНаРасходы
	|ГДЕ
	|	СписаниеНДСНаРасходы.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                     Реквизиты.Дата);
	Запрос.УстановитьПараметр("Организация",                Реквизиты.Организация);
	Запрос.УстановитьПараметр("Контрагент",                 Реквизиты.Контрагент);
	Запрос.УстановитьПараметр("СчетФактура",                Реквизиты.СчетФактура);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",      Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ДокументОплаты",             Реквизиты.ДокументОплаты);
	Запрос.УстановитьПараметр("Номер",                      Реквизиты.Номер);
	Запрос.УстановитьПараметр("Проведен",                   Реквизиты.Проведен);
	Запрос.УстановитьПараметр("Исправление",                Реквизиты.Исправление);
	Запрос.УстановитьПараметр("СторнируемыйДокумент",       Реквизиты.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("ИсправляемыйДокумент",       Реквизиты.ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("Комментарий",                Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("СуммаНДС",                   Реквизиты.СуммаНДС);
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", 	ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов"));
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",          ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		ПустаяСсылка().Метаданные().ПолноеИмя()));
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСПредъявленный";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УчетНДСУПСлужебный.УстановитьПараметрТипыНалогообложенияНДСПоступления(Запрос);
	
	ТекстЗапроса = "
	|
	|ВЫБРАТЬ
	|	&Ссылка                                КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Операция.Дата                          КАК Период,
	|	Операция.Организация                   КАК Организация,
	|	Операция.СчетФактура                   КАК СчетФактура,
	|	Операция.Контрагент                    КАК Поставщик,
	|	Строки.ВидЦенности                     КАК ВидЦенности,
	|	Строки.СтавкаНДС                       КАК СтавкаНДС,
	|	Строки.ВидДеятельностиНДС              КАК ВидДеятельностиНДС,
	|	Строки.ИсправленныйСчетФактура         КАК ИсправленныйСчетФактура,
	|	Строки.РеализацияЭкспорт               КАК РеализацияЭкспорт,
	|	Строки.НаправлениеДеятельности         КАК НаправлениеДеятельности,
	|	Строки.СуммаБезНДС                     КАК СуммаБезНДС,
	|	Строки.НДС                             КАК НДС,
	|	Строки.НДСУпр                          КАК НДСУпр,
	|	ЗНАЧЕНИЕ(Перечисление.СобытияНДСПредъявленный.СписаниеНДСНаРасходы) КАК Событие,
	|	НЕОПРЕДЕЛЕНО                           КАК КорВидДеятельностиНДС,
	|	Операция.Подразделение                 КАК Подразделение,
	|	Операция.СтатьяРасходов                КАК СтатьяРасходов,
	|	Операция.АналитикаРасходов             КАК АналитикаРасходов,
	|	""""                                     КАК ИдентификаторСтроки,
	|	ЛОЖЬ                                   КАК РегламентнаяОперация,
	|	Строки.ИдентификаторСтроки             КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка  КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.Ценности КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	И (Строки.НДС <> 0 ИЛИ Строки.НДСУпр <> 0)
	|	
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Ссылка,
	|	&Период КАК ДатаДокументаИБ,
	|	&Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&Организация КАК Организация,
	|	&Контрагент КАК Контрагент,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	&Комментарий КАК Комментарий,
	|	&СуммаНДС КАК Сумма,
	|	&Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК РазделительЗаписи,
	|	"""" КАК Дополнительно,
	|	&Период КАК ДатаПервичногоДокумента,
	|	&Номер КАК НомерПервичногоДокумента,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента           = ПустаяСсылка().Метаданные().ПолноеИмя();
	СинонимТаблицыДокумента      = "";
	ВЗапросеЕстьИсточник         = Истина;

	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента));
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ВЗапросеЕстьИсточник,,);
		
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаТаблицаНДСАвансыПолученные(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСАвансыПолученные";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = "
	|
	|ВЫБРАТЬ
	|	&Ссылка                                КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Операция.Дата                          КАК Период,
	|	Операция.Организация                   КАК Организация,
	|	Операция.ДокументОплаты                КАК ДокументОплаты,
	|	Операция.Контрагент                    КАК Контрагент,
	|	Строки.ИсправленныйСчетФактура         КАК ИсправленныйСчетФактура,
	|	Строки.Подразделение                   КАК Подразделение,
	|	Строки.НаправлениеДеятельности         КАК НаправлениеДеятельности,
	|	Строки.ОбъектРасчетов                  КАК ОбъектРасчетов,
	|	Строки.СтавкаНДС                       КАК СтавкаНДС,
	|	Строки.СуммаБезНДС                     КАК СуммаБезНДС,
	|	Строки.НДС                             КАК НДС,
	|	Строки.НДСУпр                          КАК НДСУпр,
	|	ЗНАЧЕНИЕ(Перечисление.СобытияНДСАвансы.СписаниеНДССПолученногоАванса) КАК Событие,
	|	НЕОПРЕДЕЛЕНО                           КАК ДокументЗачетаАванса,
	|	ЛОЖЬ                                   КАК РегламентнаяОперация,
	|	Строки.ИдентификаторСтроки             КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка  КАК НастройкаХозяйственнойОперации,
	|	ЛОЖЬ                                   КАК Сторно
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.АвансыПолученные КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|	
	|ГДЕ
	|	Операция.Ссылка В (&Ссылка)
	|	И Операция.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	И (Строки.НДС <> 0 ИЛИ Строки.НДСУпр <> 0)
	|	
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Операция.Дата                                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|	Операция.Организация                              КАК Организация,
	|	Операция.Подразделение                            КАК Подразделение,
	|	ТаблицаЦенности.НаправлениеДеятельности           КАК НаправлениеДеятельности,
	|	Операция.СтатьяРасходов                           КАК СтатьяРасходов,
	|	Операция.АналитикаРасходов                        КАК АналитикаРасходов,
	|
	|	0                                                 КАК Сумма,
	|	0                                                 КАК СуммаБезНДС,
	|	ТаблицаЦенности.НДС                               КАК СуммаРегл,
	|	ТаблицаЦенности.НДСУпр                            КАК СуммаУпр,
	|	ВЫБОР 
	|		КОГДА НЕ Статьи.ПринятиеКналоговомуУчету ТОГДА
	|			ТаблицаЦенности.НДС 
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ                                             КАК ПостояннаяРазница,
	|	0                                                 КАК ВременнаяРазница,
	|	
	|	Операция.ХозяйственнаяОперация                    КАК ХозяйственнаяОперация,
	|	ТаблицаЦенности.ИдентификаторСтроки               КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка             КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.Ценности КАК ТаблицаЦенности
	|	ПО 
	|		Операция.Ссылка = ТаблицаЦенности.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
	|	ПО 
	|		Операция.СтатьяРасходов = Статьи.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|
	|ГДЕ
	|	Операция.Ссылка В (&Ссылка)
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|	И Операция.СтатьяРасходов ССЫЛКА ПланВидовХарактеристик.СтатьиРасходов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Операция.Дата                                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|	Операция.Организация                              КАК Организация,
	|	Операция.Подразделение                            КАК Подразделение,
	|	ТаблицаАвансыПолученные.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|	Операция.СтатьяРасходов                           КАК СтатьяРасходов,
	|	Операция.АналитикаРасходов                        КАК АналитикаРасходов,
	|
	|	0                                                 КАК Сумма,
	|	0                                                 КАК СуммаБезНДС,
	|	ТаблицаАвансыПолученные.НДС                       КАК СуммаРегл,
	|	ТаблицаАвансыПолученные.НДСУпр                    КАК СуммаУпр,
	|	ВЫБОР 
	|		КОГДА НЕ Статьи.ПринятиеКналоговомуУчету ТОГДА
	|			ТаблицаАвансыПолученные.НДС 
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ                                             КАК ПостояннаяРазница,
	|	0                                                 КАК ВременнаяРазница,
	|	
	|	Операция.ХозяйственнаяОперация                    КАК ХозяйственнаяОперация,
	|	ТаблицаАвансыПолученные.ИдентификаторСтроки       КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка             КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.АвансыПолученные КАК ТаблицаАвансыПолученные
	|	ПО 
	|		Операция.Ссылка = ТаблицаАвансыПолученные.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
	|	ПО 
	|		Операция.СтатьяРасходов = Статьи.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|
	|ГДЕ
	|	Операция.Ссылка В (&Ссылка)
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|	И Операция.СтатьяРасходов ССЫЛКА ПланВидовХарактеристик.СтатьиРасходов
	|";

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияПоПрочимАктивамПассивам(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияПоПрочимАктивамПассивам";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Операция.Дата                                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|	Операция.Организация                              КАК Организация,
	|	Операция.Подразделение                            КАК Подразделение,
	|	ТаблицаЦенности.НаправлениеДеятельности           КАК НаправлениеДеятельности,
	|	Операция.СтатьяРасходов                           КАК Статья,
	|	Операция.АналитикаАктивовПассивов                 КАК Аналитика,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПрочихАктивовПассивов.Дебет) КАК ДебетКредит,
	|
	|	0                                                 КАК СуммаСНДС,
	|	0                                                 КАК СуммаБезНДС,
	|	ТаблицаЦенности.НДС                               КАК СуммаРегл,
	|	ТаблицаЦенности.НДСУпр                            КАК СуммаУпр,
	|	ТаблицаЦенности.НДС                               КАК ПостояннаяРазница,
	|	
	|	ТаблицаЦенности.ИдентификаторСтроки               КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка             КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.Ценности КАК ТаблицаЦенности
	|	ПО 
	|		Операция.Ссылка = ТаблицаЦенности.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|
	|ГДЕ
	|	Операция.Ссылка В (&Ссылка)
	|	И Операция.СтатьяРасходов ССЫЛКА ПланВидовХарактеристик.СтатьиАктивовПассивов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Операция.Дата                                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)            КАК ВидДвижения,
	|	Операция.Организация                              КАК Организация,
	|	Операция.Подразделение                            КАК Подразделение,
	|	ТаблицаАвансыПолученные.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|	Операция.СтатьяРасходов                           КАК Статья,
	|	Операция.АналитикаАктивовПассивов                 КАК Аналитика,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПрочихАктивовПассивов.Дебет) КАК ДебетКредит,
	|
	|	0                                                 КАК СуммаСНДС,
	|	0                                                 КАК СуммаБезНДС,
	|	ТаблицаАвансыПолученные.НДС                       КАК СуммаРегл,
	|	ТаблицаАвансыПолученные.НДСУпр                    КАК СуммаУпр,
	|	ТаблицаАвансыПолученные.НДС                       КАК ПостояннаяРазница,
	|	
	|	ТаблицаАвансыПолученные.ИдентификаторСтроки       КАК ИдентификаторФинЗаписи,
	|	НастройкиХозяйственныхОпераций.Ссылка             КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СписаниеНДСНаРасходы.АвансыПолученные КАК ТаблицаАвансыПолученные
	|	ПО 
	|		Операция.Ссылка = ТаблицаАвансыПолученные.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|	ПО
	|		Операция.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
	|
	|ГДЕ
	|	Операция.Ссылка В (&Ссылка)
	|	И Операция.СтатьяРасходов ССЫЛКА ПланВидовХарактеристик.СтатьиАктивовПассивов
	|";

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.СписаниеНДСНаРасходы.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.20.26";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Некритичный;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("d0d234a8-2316-4733-ae3a-2c2b19de17ec");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.СписаниеНДСНаРасходы.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	
	СписокОписаний = Новый Массив;
	СписокОписаний.Добавить(НСтр("ru = 'Обновление документов ""Списание НДС на расходы"":'"));
	СписокОписаний.Добавить(НСтр("ru = '- замена аналитики с перечисления ""Типы налогов"" на справочник ""Виды налогов и взносов"".';"));
	
	Обработчик.Комментарий = СтрСоединить(СписокОписаний, Символы.ПС);
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.СписаниеНДСНаРасходы.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.СписаниеНДСНаРасходы.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.СписаниеНДСНаРасходы.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = ПустаяСсылка().Метаданные().ПолноеИмя();
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписаниеНДСНаРасходы.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СписаниеНДСНаРасходы КАК СписаниеНДСНаРасходы
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(СписаниеНДСНаРасходы.АналитикаАктивовПассивов) = ТИП(Перечисление.УдалитьТипыНалогов)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

// Обработчик обновления
// 
// Параметры:
// 	Параметры - См. ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляМногопоточнойОбработки 
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	Параметры.ОбработкаЗавершена = Ложь;
	
	ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		
		Параметры.ОбработкаЗавершена =
			ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
		
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	ИсключенияПриОбновлении = Новый Массив;
	
	СписокОписаний = Новый Массив;
	СписокОписаний.Добавить(НСтр("ru = 'Не удалось обработать документы ""Списание НДС на расходы"" по обработчику:'"));
	СписокОписаний.Добавить(НСтр("ru = '- замена аналитики с типом перечисление типы налогов на справочник виды налогов и взносов';"));
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДляОбновления.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ТаблицаДокументов
		|ИЗ
		|	&ДанныеДляОбновления КАК ДанныеДляОбновления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокумента.ВерсияДанных КАК ВерсияДанных
		|ИЗ
		|	ТаблицаДокументов КАК ТаблицаДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеНДСНаРасходы КАК ДанныеДокумента
		|		ПО ТаблицаДокументов.Ссылка = ДанныеДокумента.Ссылка
		|";
	
	Запрос.УстановитьПараметр("ДанныеДляОбновления", ОбновляемыеДанные);
	
	Документ = Запрос.Выполнить().Выбрать();
	
	Пока Документ.Следующий() Цикл
		
		ПричинаИсключения = 0;
		Рекомендация = "";
		
		НачатьТранзакцию();
		
		Попытка
			
			ПричинаИсключения = 1; // Блокировка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Документ.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДокументОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(
				Документ.Ссылка, Документ.ВерсияДанных, Параметры.Очередь); // ДокументОбъект
			
			ПричинаИсключения = 2; // ПлохиеДанные
			Рекомендация = НСтр("ru = 'Перепроведите документ вручную.'");
			
			ОбъектИзменен = Ложь;
			
			Если ДокументОбъект <> Неопределено Тогда
				Перечисления.УдалитьТипыНалогов.ЗаполнитьРеквизитТипНалога(ДокументОбъект, "АналитикаАктивовПассивов");
				ОбъектИзменен = Истина;
			КонецЕсли;
			
			ПричинаИсключения = 3; // Запись
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Документ.Ссылка);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Документ.Ссылка);
			
			Если ПричинаИсключения = 2 Тогда
				
				ОписаниеПроблемы = ОбновлениеИнформационнойБазыУТ.ПроблемаСДанными(
					Документ.Ссылка, Рекомендация, ИнформацияОбОшибке());
				ИсключенияПриОбновлении.Добавить(ОписаниеПроблемы);
				
			ИначеЕсли ПричинаИсключения = 3 Тогда
				
				ОбновлениеИнформационнойБазыУТ.ЗаписатьПлохиеДанные(
					ИсключенияПриОбновлении, ОбъектовОбработано, Параметры);
				ВызватьИсключение СтрСоединить(СписокОписаний, Символы.ПС);
				
			КонецЕсли;
			
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена =
		ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
