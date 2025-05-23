
#Область ПрограммныйИнтерфейс

#Область ПроцедурыФормированияИОчистки

// Готовит структуру данных СКД и настроек, исходя из шаблона и данных сегмента.
//
// Параметры:
//  СегментСсылка            - СправочникСсылка.СегментыНоменклатуры, СправочникСсылка.СегментыПартнеров - сегмент, чьи
//      СКД и настройки получаются.
//  ИмяШаблонаСКД            - Строка - имя шаблона СКД
//  АдресСКД                 - Строка - адрес хранилища, в котором находится СКД.
//  АдресНастроекСКД         - Строка - адрес хранилища, в котором находятся настройки СКД.
//  УникальныйИдентификатор - УникальныйИдентификатор - идентификатор формы, из которой выполняется вызов процедуры.
//
// Возвращаемое значение:
//   Структура   -  состоит из следующих полей
//       ИмяШаблонаСКД           - Строка - имя шаблона СКД
//       ПредставлениеШаблонаСКД - Строка - пользовательское представление шаблона СКД.
//       АдресСКД                - Строка - адрес хранилища, в котором находится СКД.
//       АдресНастроекСКД        - Строка - адрес хранилища, в котором находятся настройки СКД.
//
Функция ПрименитьИзмененияКСхемеКомпоновкиДанных(СегментСсылка, ИмяШаблонаСКД, АдресСКД, АдресНастроекСКД, УникальныйИдентификатор) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяШаблонаСКД", ИмяШаблонаСКД);
	ВозвращаемоеЗначение.Вставить("ПредставлениеШаблонаСКД",НСтр("ru = 'Произвольный'"));
	ВозвращаемоеЗначение.Вставить("АдресСКД", "");
	ВозвращаемоеЗначение.Вставить("АдресНастроекСКД","");
	
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) Тогда
		
		СхемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, ИмяШаблонаСКД);
		// Если схема компоновки данных из макета <> полученной из редактора схеме компоновки данных.
		Если СегментыСервер.ПолучитьXML(СхемаИНастройки.СхемаКомпоновкиДанных) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресСКД)) Тогда
			
			ВозвращаемоеЗначение.ИмяШаблонаСКД  = "";
			ВозвращаемоеЗначение.АдресСКД = АдресСКД;
			
		Иначе
			
			ВозвращаемоеЗначение.ПредставлениеШаблонаСКД = СхемаИНастройки.Описание;
			
		КонецЕсли;
		
		// Полученные настройки могут быть равны настройкам по умолчанию схемы.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаИНастройки.СхемаКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.АдресСКД = АдресСКД;
		
		Схема = ПолучитьИзВременногоХранилища(АдресСКД);
		ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Схема);
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получает адреса СКД и настроек согласно переданным данным.
//
// Параметры:
//  СегментСсылка            - СправочникСсылка.СегментыНоменклатуры, СправочникСсылка.СегментыПартнеров - сегмент, чьи
//      СКД и настройки получаются.
//  ИмяШаблонаСКД            - Строка - имя шаблона СКД
//  АдресСКД                 - Строка - адрес хранилища, в котором находится СКД.
//  АдресНастроекСКД         - Строка - адрес хранилища, в котором находятся настройки СКД.
//  УникальныйИдентификатор   - УникальныйИдентификатор - идентификатор формы, из которой выполняется вызов процедуры.
//
// Возвращаемое значение:
//   Структура   -  состоит из следующих полей
//       СхемаКомпоновкиДанных     - Строка - адрес шаблона СКД.
//       НастройкиКомпоновкиДанных - Строка - адрес настроек СКД.
//
Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(СегментСсылка,
	                                                            ИмяШаблонаСКД,
	                                                            АдресСКД,
	                                                            АдресНастроекСКД,
	                                                            УникальныйИдентификатор) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	// Схема
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) И ПустаяСтрока(АдресСКД) Тогда
		СхемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, ИмяШаблонаСКД);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
		Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных,УникальныйИдентификатор)
	Иначе
		Адреса.СхемаКомпоновкиДанных = АдресСКД;
	КонецЕсли;

	// Настройки
	Если НЕ ПустаяСтрока(АдресНастроекСКД) Тогда
		Адреса.НастройкиКомпоновкиДанных = АдресНастроекСКД;
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

// Заполняет регистр сведений объектами, вошедшими в сегмент.
//
// Параметры:
//   СегментСсылка - СправочникСсылка.СегментыПартнеров, СправочникСсылка.СегментыНоменклатуры - сегмент, элементы
//       входящие в который получаются.
//
Процедура Сформировать(СегментСсылка) Экспорт

	ПР = ПривилегированныйРежим();
	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;

	СписокЭлементов = СегментыСервер.СписокЭлементовСКД(СегментСсылка);
	ВключатьХарактеристики =
		СписокЭлементов.Колонки.Найти("ХарактеристикаЭлемента") <> Неопределено;

	Если ТипЗнч(СегментСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		Для Каждого Элемент Из СписокЭлементов Цикл
			Если НЕ ЗначениеЗаполнено(Элемент.ЭлементСписка) Тогда
				Продолжить;
			КонецЕсли;
			Запись = НаборЗаписей.Добавить();
			Запись.Сегмент = СегментСсылка;
			Запись.Номенклатура = Элемент.ЭлементСписка;
			Если ВключатьХарактеристики Тогда
				Запись.Характеристика = Элемент.ХарактеристикаЭлемента;
			КонецЕсли;
		КонецЦикла;
	Иначе
		НаборЗаписей = РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		Для Каждого Элемент Из СписокЭлементов Цикл
			Если НЕ ЗначениеЗаполнено(Элемент.ЭлементСписка) Тогда
				Продолжить;
			КонецЕсли;
			Запись = НаборЗаписей.Добавить();
			Запись.Сегмент = СегментСсылка;
			Запись.Партнер = Элемент.ЭлементСписка;
		КонецЦикла;
	КонецЕсли;

	НаборЗаписей.Записать();

	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

КонецПроцедуры

// Удаляет из регистра сведений записи, относящиеся к сегменту
//
// Параметры:
//   СегментСсылка - СправочникСсылка.СегментыПартнеров, СправочникСсылка.СегментыНоменклатуры - сегмент, элементы
//       входящие в который получаются.
//
Процедура Очистить(СегментСсылка) Экспорт

	НаборСегмента = ?(
		ТипЗнч(СегментСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры"),
		РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей(),
		РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей());
	НаборСегмента.Отбор.Сегмент.Установить(СегментСсылка);
	НаборСегмента.Записать();

КонецПроцедуры

#КонецОбласти

#Область ФункцииОбработкиНабораЭлементов

// Возвращает список значений, содержащий элементы, входящие в сегмент,
// с учетом способа формирования сегмента.
//
// Параметры:
//   СегментСсылка - СправочникСсылка.СегментыПартнеров, СправочникСсылка.СегментыНоменклатуры - сегмент, элементы
//       входящие в который получаются.
//
// Возвращаемое значение:
//   СписокЗначений - список элементов, входящих в сегмент.
//
Функция СписокЗначений(СегментСсылка) Экспорт

	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(СегментыСервер.ТаблицаЗначений(СегментСсылка).ВыгрузитьКолонку(0));
	
	Возврат Список;

КонецФункции

#КонецОбласти

#КонецОбласти
