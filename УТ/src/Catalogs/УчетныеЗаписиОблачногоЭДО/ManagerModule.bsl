// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ДанныеУчетнойЗаписи

// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиОблачногоЭДО
// 
// Возвращаемое значение:
//  Строка
Функция АдресСервиса(УчетнаяЗапись) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "АдресСервиса");
КонецФункции

// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиОблачногоЭДО
// 
// Возвращаемое значение:
//  - Неопределено
//  - См. ИнтеграцияОблачногоЭДО.НовыйТокенАвторизации
Функция ТокенАвторизацииСлужебный(УчетнаяЗапись) Экспорт
	ТокенАвторизации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись, "ТокенАвторизации"); // См. ИнтеграцияОблачногоЭДО.НовыйТокенАвторизации
	Возврат ТокенАвторизации;
КонецФункции

// Возвращаемое значение:
//  - Неопределено - если нет элементов или элементов больше одного.
//  - СправочникСсылка.УчетныеЗаписиОблачногоЭДО
Функция ЕдинственнаяУчетнаяЗапись() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 2
		|	УчетныеЗаписиОблачногоЭДО.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиОблачногоЭДО КАК УчетныеЗаписиОблачногоЭДО";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ВыборкаУчетныхЗаписей

// Параметры:
//  АдресСервиса - Строка
// 
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиОблачногоЭДО
Функция НайтиПоАдресуСервиса(АдресСервиса) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УчетныеЗаписиОблачногоЭДО.Ссылка,
		|	УчетныеЗаписиОблачногоЭДО.АдресСервиса
		|ИЗ
		|	Справочник.УчетныеЗаписиОблачногоЭДО КАК УчетныеЗаписиОблачногоЭДО
		|ГДЕ
		|	УчетныеЗаписиОблачногоЭДО.ХешАдресаСервиса = &ХешАдресаСервиса";
		
	ХешАдресаСервиса = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(АдресСервиса);
	Запрос.УстановитьПараметр("ХешАдресаСервиса", ХешАдресаСервиса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.АдресСервиса = АдресСервиса Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПустаяСсылка();
КонецФункции

#КонецОбласти

#Область ПодключениеОблачногоЭДО

// Параметры:
//  ПараметрыПользователя - См. РегистрыСведений.ПользователиОблачногоЭДО.НовыеПараметрыПользователя
//  КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиОблачногоЭДО
Функция Добавить(ПараметрыПользователя, КонтекстДиагностики) Экспорт
	
	ПараметрыДобавления = ПараметрыДобавленияУчетнойЗаписиОблачногоЭДО(ПараметрыПользователя, КонтекстДиагностики);
	
	Если Не ЗначениеЗаполнено(ПараметрыДобавления.ТокенАвторизации) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		УчетнаяЗапись = СоздатьЭлемент();
		УчетнаяЗапись.Наименование = ПараметрыДобавления.Наименование;
		УчетнаяЗапись.АдресСервиса = ПараметрыПользователя.АдресСервиса;
		УчетнаяЗапись.Записать();
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись.Ссылка,
			ПараметрыДобавления.ТокенАвторизации, "ТокенАвторизации");
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru = 'Ошибка создания учетной записи облачного ЭДО.'") + Символы.ПС
			+ ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(НСтр("ru = 'Создание учетной записи облачного ЭДО.'"),
			ОбработкаНеисправностейБЭДКлиентСервер.ВидОшибкиНеизвестнаяОшибка(),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ТекстСообщения);
		ПодсистемыБЭД = ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД();
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка, ПодсистемыБЭД.ОбменСКонтрагентами);
		Возврат ПустаяСсылка();
	КонецПопытки;
	
	Возврат УчетнаяЗапись.Ссылка;
	
КонецФункции

// Параметры:
//  ПараметрыПользователя - См. Добавить.ПараметрыПользователя
//  КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 
// Возвращаемое значение:
//  Структура:
//  * Наименование - Строка
//  * ТокенАвторизации - Неопределено
//                     - См. ИнтеграцияОблачногоЭДО.НовыйТокенАвторизации
Функция ПараметрыДобавленияУчетнойЗаписиОблачногоЭДО(ПараметрыПользователя, КонтекстДиагностики)
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("Наименование", "");
	ПараметрыДобавления.Вставить("ТокенАвторизации", Неопределено);
	
	ПараметрыВыполнения = ИнтеграцияОблачногоЭДО.НовыеПараметрыВыполненияМетодаСервиса();
	ПараметрыВыполнения.АдресСервиса = ПараметрыПользователя.АдресСервиса;
	ПараметрыВыполнения.ТокенАвторизации = ИнтеграцияОблачногоЭДО.ТокенАвторизацииБазовый(
		ПараметрыПользователя.Логин, ПараметрыПользователя.Пароль);
	
	ОписаниеМетода = ИнтеграцияОблачногоЭДО.ОписаниеМетодаСервиса("НастройкаПодключения",
		ОбщегоНазначенияБЭД.ИдентификаторПриложения());
	НастройкаПодключения = ИнтеграцияОблачногоЭДО.ВыполнитьМетодСервиса(ПараметрыВыполнения, ОписаниеМетода,
		КонтекстДиагностики); // См. ПрограммныйИнтерфейсОблачногоЭДОВерсия1.НастройкаПодключения
	
	Если Не ЗначениеЗаполнено(НастройкаПодключения) Тогда
		Возврат ПараметрыДобавления;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкаПодключения.Ошибка) Тогда
		ТекстОшибки = НастройкаПодключения.Ошибка;
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(
			НСтр("ru = 'Получение настройки подключения.'"),
			ОбработкаНеисправностейБЭДКлиентСервер.ВидОшибкиНеизвестнаяОшибка(),
			ТекстОшибки, ТекстОшибки);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами);
		Возврат ПараметрыДобавления;
	КонецЕсли;
	
	ПараметрыДобавления.Наименование = НастройкаПодключения.Наименование;
	ПараметрыДобавления.ТокенАвторизации = НастройкаПодключения.ТокенАвторизации;
	
	Возврат ПараметрыДобавления;
	
КонецФункции

// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиОблачногоЭДО
// 
// Возвращаемое значение:
//  См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
Функция Обновить(УчетнаяЗапись) Экспорт
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	Попытка
		ПараметрыВыполнения = ИнтеграцияОблачногоЭДОПовтИсп.ПараметрыВыполненияМетодаСервиса(
		УчетнаяЗапись, Пользователи.ТекущийПользователь());
	Исключение
		ВидОперации = НСтр("ru = 'Обновление настроек учетной записи'");
		ВидОшибки = ИнтеграцияОблачногоЭДО.ВидОшибкиОтсутствуютДанныеАвторизации(УчетнаяЗапись);
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(ВидОперации, ВидОшибки, ТекстОшибки, ТекстОшибки);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ИнтеграцияОблачногоЭДО);
		Возврат КонтекстДиагностики;
	КонецПопытки;
	
	ОписаниеМетода = ИнтеграцияОблачногоЭДО.ОписаниеМетодаСервиса("НастройкаПодключения",
		ОбщегоНазначенияБЭД.ИдентификаторПриложения());
	НастройкаПодключения = ИнтеграцияОблачногоЭДО.ВыполнитьМетодСервиса(ПараметрыВыполнения, ОписаниеМетода,
		КонтекстДиагностики); // См. ПрограммныйИнтерфейсОблачногоЭДОВерсия1.НастройкаПодключения
	
	ОшибкиДиагностики = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	Если ЗначениеЗаполнено(ОшибкиДиагностики) Тогда
		Возврат КонтекстДиагностики;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись, 
		НастройкаПодключения.ТокенАвторизации, "ТокенАвторизации");
	УстановитьПривилегированныйРежим(Ложь);
	Возврат КонтекстДиагностики;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
