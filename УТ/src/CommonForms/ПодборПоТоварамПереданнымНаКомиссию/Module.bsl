
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаТоваровОткрытьКарточкуТовара.Видимость = ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();

	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Соглашение = Параметры.Соглашение;
	Дата = Параметры.Дата;
	АдресПлатежейВХранилище = Параметры.АдресПлатежейВХранилище;
	ПоРезультатамИнвентаризации = Параметры.ПоРезультатамИнвентаризации;
	
	Если Параметры.Свойство("СкрыватьОтбор") И Параметры.СкрыватьОтбор Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОрганизация", "Видимость", Ложь);
	КонецЕсли;
	
	ИспользоватьУчетПрослеживаемыхИмпортныхТоваров =
		УчетПрослеживаемыхТоваровЛокализация.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(Дата);
	
	КомиссионерНеВедетУчетПоРНПТ =
		Не Справочники.СоглашенияСКлиентами.КомиссионерВедетУчетПоРНПТ(Соглашение);
		
	УчетПрослеживаемыхТоваровЛокализация.УстановитьЗаголовокНомерГТД(Элементы, "ТоварыНомерГТД");
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = (СтрокаТаблицы.КоличествоУпаковок <> 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокФактПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь()
		И Поле.Имя = "ТаблицаТоваровНоменклатура"
		ИЛИ Поле.Имя = "ТаблицаТоваровХарактеристика" Тогда
		
		ОткрытьКарточкуНоменклатуры();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуТовара(Команда)
	
	ОткрытьКарточкуНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);
	
	// Ошибка встраивания
	ПараметрыУсловногоОформления = УчетПрослеживаемыхТоваровЛокализация.ПараметрыУстановкиУсловногоОформленияКоличестваПоРНПТ();
	ПараметрыУсловногоОформления.ПутьКПолюВедетсяУчетПоРНПТ		= "ТаблицаТоваров.ВедетсяУчетПоРНПТ";
	ПараметрыУсловногоОформления.ПутьКПолюТипНомераГТД			= "ТаблицаТоваров.ТипНомераГТД";
	ПараметрыУсловногоОформления.ПутьКПолюДатаДокумента			= "Дата";
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьУсловноеОформлениеКоличестваПоРНПТ(ЭтаФорма,
																						ПараметрыУсловногоОформления);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьУсловноеОформлениеУчетаПоГТДВДокументахКомиссионера(ЭтаФорма);
	
КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Отбор = Новый Структура("Выбран", Истина);
	Товары =
		ТаблицаТоваров.Выгрузить(
			Отбор,
			"Выбран, Номенклатура, Характеристика, НомерГТД, СтранаПроисхождения, КоличествоУпаковок, Количество,
			|КоличествоУпаковокФакт, КоличествоУпаковокУчет");
	
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		Если ПоРезультатамИнвентаризации Тогда
			СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.КоличествоУпаковокУчет - СтрокаТаблицы.КоличествоУпаковокФакт;
		КонецЕсли;
		СтрокаТаблицы.Количество = СтрокаТаблицы.КоличествоУпаковок;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Товары, АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.НомерГТД КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	Товары.Количество КАК Количество,
	|	Товары.КоличествоПоРНПТ КАК КоличествоПоРНПТ
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ
	|	Аналитика.Ссылка КАК КлючАналитики
	|
	|ПОМЕСТИТЬ ВтАналитика
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|ГДЕ
	|	Аналитика.МестоХранения = &Партнер
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Остатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	Остатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	Остатки.НомерГТД КАК НомерГТД,
	|	Остатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	Остатки.КоличествоОстаток КАК КоличествоОстаток,
	|	Остатки.КоличествоПоРНПТОстаток КАК КоличествоПоРНПТОстаток
	|
	|ПОМЕСТИТЬ ТоварыПереданные
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(&Граница,
	|		Организация = &Организация
	|		И Соглашение = &Соглашение
	|		И АналитикаУчетаНоменклатуры В (
	|			ВЫБРАТЬ
	|				Аналитика.КлючАналитики
	|			ИЗ
	|				ВтАналитика КАК Аналитика
	|			)
	|	) КАК Остатки
	|
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Остатки.НомерГТД КАК НомерГТД,
	|	Остатки.КоличествоОстаток КАК КоличествоОстаток,
	|	Остатки.КоличествоПоРНПТОстаток КАК КоличествоПоРНПТОстаток,
	|	ВЫБОР КОГДА Остатки.КоличествоОстаток < 0 ТОГДА
	|		-1
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ КАК Знак
	|
	|ПОМЕСТИТЬ ТоварыПереданныеОстатки
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(,
	|		Организация = &Организация
	|		И Соглашение = &Соглашение
	|		И АналитикаУчетаНоменклатуры В (
	|			ВЫБРАТЬ
	|				Аналитика.КлючАналитики
	|			ИЗ
	|				ВтАналитика КАК Аналитика
	|			)
	|	) КАК Остатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	НомерГТД
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ТоварыПереданные.Номенклатура КАК Номенклатура,
	|	ТоварыПереданные.Номенклатура.ВестиУчетПоГТД КАК ВедетсяУчетПоГТД,
	|	ЕСТЬNULL(ТоварыПереданные.Номенклатура.ПрослеживаемыйТовар, ЛОЖЬ) КАК ВедетсяУчетПоРНПТ,
	|	ТоварыПереданные.Характеристика КАК Характеристика,
	|	ТоварыПереданные.НомерГТД КАК НомерГТД,
	|	ТоварыПереданные.НомерГТД.ТипНомераГТД КАК ТипНомераГТД,
	|	ТоварыПереданные.НомерГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ТоварыПереданные.Серия КАК Серия,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(Остатки.КоличествоОстаток * Остатки.Знак, 0)
	|		< (ТоварыПереданные.КоличествоОстаток * ЕСТЬNULL(Остатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(Остатки.КоличествоОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыПереданные.КоличествоОстаток
	|	КОНЕЦ КАК КоличествоУпаковокУчет,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(Остатки.КоличествоПоРНПТОстаток * Остатки.Знак, 0)
	|		< (ТоварыПереданные.КоличествоПоРНПТОстаток * ЕСТЬNULL(Остатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(Остатки.КоличествоПоРНПТОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыПереданные.КоличествоПоРНПТОстаток
	|	КОНЕЦ КАК КоличествоПоРНПТУчет,
	|
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ВЫБОР КОГДА ЕСТЬNULL(Остатки.КоличествоОстаток * Остатки.Знак, 0)
	|			< (ТоварыПереданные.КоличествоОстаток * ЕСТЬNULL(Остатки.Знак, 1))
	|		ТОГДА
	|			ЕСТЬNULL(Остатки.КоличествоОстаток, 0)
	|		ИНАЧЕ
	|			ТоварыПереданные.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТоварыПереданные КАК ТоварыПереданные
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТоварыПереданныеОстатки КАК Остатки
	|	ПО
	|		ТоварыПереданные.АналитикаУчетаНоменклатуры = Остатки.АналитикаУчетаНоменклатуры
	|		И ТоварыПереданные.НомерГТД = Остатки.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ТоварыПереданные.Номенклатура = Товары.Номенклатура
	|		И ТоварыПереданные.Характеристика = Товары.Характеристика
	|		И ТоварыПереданные.НомерГТД = Товары.НомерГТД
	|		И ТоварыПереданные.Серия = Товары.Серия
	|
	|ГДЕ
	|	ТоварыПереданные.КоличествоОстаток <> 0
	|	И ЕСТЬNULL(Остатки.КоличествоОстаток, 0) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыПереданные.Номенклатура,
	|	ТоварыПереданные.Характеристика,
	|	ТоварыПереданные.Серия
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(Дата), КонецДня(Дата), ТекущаяДатаСеанса());
	Граница = Новый Граница(ДатаЗаполнения, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Товары = ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище); // ТаблицаЗначений
	Товары.Свернуть("Номенклатура, Характеристика, НомерГТД", "Количество, КоличествоПоРНПТ");
	Запрос.УстановитьПараметр("Товары", Товары);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаТоваров.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);
	
	Элементы.ТаблицаТоваровКоличествоУпаковок.Видимость = Не ПоРезультатамИнвентаризации;
	Элементы.ТаблицаТоваровКоличествоУпаковокФакт.Видимость = ПоРезультатамИнвентаризации;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНоменклатуры()

	ТекущиеДанные = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
