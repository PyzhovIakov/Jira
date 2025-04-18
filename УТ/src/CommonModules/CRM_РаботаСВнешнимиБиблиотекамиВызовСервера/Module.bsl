////////////////////////////////////////////////////////////////////////////////
// Серверные (для вызова из клиента) процедуры и функции для работы с внешними библиотеками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при создании формы на сервере. Создает необходимые реквизиты формы для работы механизма.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - Форма, в которой срабатывает событие ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	МассивДобавляемыйРеквизитов = Новый Массив;
	
	///////////////////////////////////////////////
	
	// ИсточникиВнешнихБиблиотек
	ОписаниеТиповРеквизита	= Новый ОписаниеТипов("ТаблицаЗначений");
	НовыйРеквизитФормы		= Новый РеквизитФормы(
		"ИсточникиВнешнихБиблиотек", ОписаниеТиповРеквизита);
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	// ИсточникиВнешнихБиблиотек.ВнешняяБиблиотекаСсылка
	ОписаниеТиповРеквизита	= Новый ОписаниеТипов("СправочникСсылка.CRM_ВнешниеБиблиотеки");
	НовыйРеквизитФормы		= Новый РеквизитФормы(
		"ВнешняяБиблиотекаСсылка", ОписаниеТиповРеквизита, "ИсточникиВнешнихБиблиотек");
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	// ИсточникиВнешнихБиблиотек.ИдентификаторЗамены
	ОписаниеТиповРеквизита	= Новый ОписаниеТипов("Строка");
	НовыйРеквизитФормы		= Новый РеквизитФормы(
		"ИдентификаторЗамены", ОписаниеТиповРеквизита, "ИсточникиВнешнихБиблиотек");
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	// ИсточникиВнешнихБиблиотек.ПутьХранения
	НовыйРеквизитФормы = Новый РеквизитФормы(
		"ПутьХранения", ОписаниеТиповРеквизита, "ИсточникиВнешнихБиблиотек");
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	///////////////////////////////////////////////
	
	ОписаниеТиповРеквизита	= Новый ОписаниеТипов("Булево");
	НовыйРеквизитФормы		= Новый РеквизитФормы(
		"ФлагСовместимостиВнешнихБиблиотек", ОписаниеТиповРеквизита);
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	///////////////////////////////////////////////
	
	ОписаниеТиповРеквизита	= Новый ОписаниеТипов("Булево");
	НовыйРеквизитФормы		= Новый РеквизитФормы(
		"ВнешниеБиблиотекиИнициализированы", ОписаниеТиповРеквизита);
	
	МассивДобавляемыйРеквизитов.Добавить(НовыйРеквизитФормы);
	
	///////////////////////////////////////////////
	
	Форма.ИзменитьРеквизиты(МассивДобавляемыйРеквизитов);
	
	///////////////////////////////////////////////
	
	Форма.ФлагСовместимостиВнешнихБиблиотек = (
		ОбщегоНазначения.ЭтоLinuxКлиент() И Не ОбщегоНазначения.ЭтоВебКлиент());
	
КонецПроцедуры // ПриСозданииНаСервере()

// Используется для получения контрольной суммы двоичных данных.
//
// Параметры:
//  ДвоичныеДанные  - ДвоичныеДанные - Двоичные данные, по которым необходимо получить контрольную сумму.
//
// Возвращаемое значение:
//   Строка   - Контролная сумма строкой.
//
Функция КонтрольнаяСуммаСтрокой(ДвоичныеДанные) Экспорт
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ДвоичныеДанные);
	
КонецФункции // КонтрольнаяСуммаСтрокой()

// Используется для получения предопределенных внешних библиотек.
//
// Параметры:
//  ИспользоватьРежимСовместимости   - Булево - Признак использования библиотек для совместимости с ОС Linux.
//
// Возвращаемое значение:
//   Массив   - Массив информации о используемых внешних библиотеках.
//
Функция ПолучитьПредопределенныеВнешниеБиблиотеки(ИспользоватьРежимСовместимости = Ложь) Экспорт
	
	Если ИспользоватьРежимСовместимости Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	CRM_ВнешниеБиблиотеки.БиблиотекаСовместимости КАК Ссылка,
			|	CRM_ВнешниеБиблиотеки.БиблиотекаСовместимости.КонтрольнаяСумма КАК КонтрольнаяСумма,
			|	CRM_ВнешниеБиблиотеки.БиблиотекаСовместимости.РазмерБиблиотеки КАК РазмерБиблиотеки
			|ИЗ
			|	Справочник.CRM_ВнешниеБиблиотеки КАК CRM_ВнешниеБиблиотеки
			|ГДЕ
			|	CRM_ВнешниеБиблиотеки.Предопределенный = ИСТИНА
			|	И CRM_ВнешниеБиблиотеки.БиблиотекаСовместимости <> ЗНАЧЕНИЕ(Справочник.CRM_ВнешниеБиблиотеки.ПустаяСсылка)");
	Иначе
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	CRM_ВнешниеБиблиотеки.Ссылка КАК Ссылка,
			|	CRM_ВнешниеБиблиотеки.КонтрольнаяСумма КАК КонтрольнаяСумма,
			|	CRM_ВнешниеБиблиотеки.РазмерБиблиотеки КАК РазмерБиблиотеки
			|ИЗ
			|	Справочник.CRM_ВнешниеБиблиотеки КАК CRM_ВнешниеБиблиотеки
			|ГДЕ
			|	CRM_ВнешниеБиблиотеки.Предопределенный = ИСТИНА
			|	И CRM_ВнешниеБиблиотеки.БиблиотекаСовместимости <> ЗНАЧЕНИЕ(Справочник.CRM_ВнешниеБиблиотеки.ПустаяСсылка)");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ИспользоватьРежимСовместимости", ИспользоватьРежимСовместимости);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции // ПолучитьПредопределенныеВнешниеБиблиотеки()

// Используется для получения двоичных данных внешней библиотеки из базы.
//
// Параметры:
//  ВнешнаяБиблиотекаСсылка	 - СправочникСсылка.CRM_ВнешниеБиблиотеки	 - Внешняя библиотека, двоичные данные
//  	которой необходимо получить.
//  ПередаватьСжатыеДанные	 - Булево									 - Флаг передачи библиотеки архивом.
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено   - Двоичные данные внешней библиотеки, или Неопределено если их нет.
//
Функция ПолучитьДвоичныеДанныеВнешнейБиблиотеки(
		ВнешнаяБиблиотекаСсылка,
		ПередаватьСжатыеДанные = Истина) Экспорт
	
	Если ПередаватьСжатыеДанные Тогда
		Возврат ВнешнаяБиблиотекаСсылка.ХранилищеАрхиваБиблиотеки.Получить();
	Иначе
		Возврат ВнешнаяБиблиотекаСсылка.ХранилищеБиблиотеки.Получить();
	КонецЕсли;
	
КонецФункции // ПолучитьДвоичныеДанныеВнешнейБиблиотеки()

// Используется для получения блока интеграции внешней библиотеки.
//
// Параметры:
//  ВнешняяБиблиотекаСсылка         - СправочникСсылка.CRM_ВнешниеБиблиотеки - Ссылка на объект внешней библиотеки.
//  ИспользоватьРежимСовместимости  - Булево                                 - Признак использования библиотек для
//                                                                             совместимости с ОС Linux.
//
// Возвращаемое значение:
//   Строка   - Интеграция внешней библиотеки без подстановки путей к библиотеке.
//
Функция ПолучитьБлокИнтеграцииВнешнейБиблиотеки(ВнешняяБиблиотекаСсылка, ИспользоватьРежимСовместимости = Ложь) Экспорт
	
	ИспользуемаяВнешняяБиблиотека = ВнешняяБиблиотекаСсылка;
	
	Если ИспользоватьРежимСовместимости
			И ЗначениеЗаполнено(ВнешняяБиблиотекаСсылка.БиблиотекаСовместимости) Тогда
		ИспользуемаяВнешняяБиблиотека = ВнешняяБиблиотекаСсылка.БиблиотекаСовместимости;
	КонецЕсли;
	
	Возврат "<script src=""" + Строка(ИспользуемаяВнешняяБиблиотека.УникальныйИдентификатор()) + """></script>";
	
КонецФункции // ПолучитьБлокИнтеграцииВнешнейБиблиотеки()

// Используется для постановки вызова внешних библиотек.
//
// Параметры:
//  ИсточникиВнешнихБиблиотек  - ДанныеФормыКоллекция - Коллекция описания библиотек.
//  ИсходныйТекст              - Строка               - Исходный текст, где необходимо поставить пути вызова библиотек.
//
// Возвращаемое значение:
//   Строка   - Исходный текст с подставленными путями вызова библиотек.
//
Функция ЗаменитьПутиВызоваБиблиотек(ИсточникиВнешнихБиблиотек, ИсходныйТекст) Экспорт
	
	Для Каждого ТекущаяСтрокаВнешнейБиблиотеки Из ИсточникиВнешнихБиблиотек Цикл
		ИсходныйТекст = СтрЗаменить(
			ИсходныйТекст,
			ТекущаяСтрокаВнешнейБиблиотеки.ИдентификаторЗамены,
			ТекущаяСтрокаВнешнейБиблиотеки.ПутьХранения);
	КонецЦикла;
	
	Возврат ИсходныйТекст;
	
КонецФункции // ЗаменитьПутиВызоваБиблиотек()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Используется для размещения внешних библиотек во временном хранилище.
//
// Параметры:
//  УникальныйИдентификаторФормы    - УникальныйИдентификатор - Уникальный идентификатор формы.
//  ИспользоватьРежимСовместимости  - Булево                  - Признак использования библиотек для
//                                                              совместимости с ОС Linux.
// Возвращаемое значение:
//   Массив   - Массив структур, описывающих размещение библиотеки во временном хранилище.
//
//
Функция ИнициализироватьИсточникиВнешнихБиблиотекЧерезХранилище(
		УникальныйИдентификаторФормы, ИспользоватьРежимСовместимости) Экспорт
	
	МассивВнешнихБиблиотек = Новый Массив;
	
	Для Каждого ВнешняяБиблиотеки Из ПолучитьПредопределенныеВнешниеБиблиотеки(ИспользоватьРежимСовместимости) Цикл
		ДвоичныеДанныеВнешнейБиблиотеки = ПолучитьДвоичныеДанныеВнешнейБиблиотеки(
			ВнешняяБиблиотеки.Ссылка, Ложь);
		
		АдресРазмещенияВнешнейБиблиотеки = CRM_РаботаСHTML.ПолучитьСсылкуНаКартинкуВоВременномХранилище(
			ДвоичныеДанныеВнешнейБиблиотеки, УникальныйИдентификаторФормы);
		
		СтруктураБиблиотеки = Новый Структура;
		СтруктураБиблиотеки.Вставить("ВнешняяБиблиотекаСсылка",	ВнешняяБиблиотеки.Ссылка);
		СтруктураБиблиотеки.Вставить("ИдентификаторЗамены",		ВнешняяБиблиотеки.Ссылка.УникальныйИдентификатор());
		СтруктураБиблиотеки.Вставить("ПутьХранения",			АдресРазмещенияВнешнейБиблиотеки);
		
		МассивВнешнихБиблиотек.Добавить(СтруктураБиблиотеки);
	КонецЦикла;
	
	Возврат МассивВнешнихБиблиотек;
	
КонецФункции // ИнициализироватьИсточникиВнешнихБиблиотекЧерезХранилище()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////