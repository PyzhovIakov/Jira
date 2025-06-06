#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Записывает ставки НДС для всей номенклатуры. Используется в длительной операции "Рабочего места"
//
// Параметры:
//  Схема - СхемаКомпоновкиДанных
//  Настройки - НастройкиКомпоновкиДанных
//  Параметры - Структура - дополнительные параметры для записи
//
Процедура УстановитьСтавкуНДСНоменклатурыПоТекущемуОтбору(Схема, Настройки, Параметры) Экспорт
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "ЭтоГруппа", Ложь);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = МакетКомпоновки.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос;	
	Для Каждого ЗначениеПараметра Из МакетКомпоновки.ЗначенияПараметров Цикл
		Запрос.УстановитьПараметр(ЗначениеПараметра.Имя,ЗначениеПараметра.Значение);
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДобавитьЗаписьВРегистр(Выборка, Параметры);
	КонецЦикла;
	
КонецПроцедуры

// Записывает ставки НДС для списка номенклатуры. Используется в длительной операции "Рабочего места"
//
// Параметры:
//  СписокНоменклатуры - СписокЗначений - Список номенклатуры
//  Параметры - Структура - дополнительные параметры для записи
//
Процедура УстановитьСтавкуНДСНоменклатурыПоВыделеннымСтрокам(СписокНоменклатуры, Параметры) Экспорт
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	
	Для Каждого Строка Из СписокНоменклатуры Цикл
		Если Строка.Значение.ЭтоГруппа Тогда
			ОбработатьГруппуНоменклатуры(ТаблицаЗначений, Строка.Значение);
		Иначе
			НоваяСтрока = ТаблицаЗначений.Добавить();
			НоваяСтрока.Номенклатура = Строка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаЗначений Цикл
		ДобавитьЗаписьВРегистр(Строка, Параметры);
	КонецЦикла;
	
КонецПроцедуры

// Записывает актуальную ставку НДС для номенклатуры по основной стране в РС.СтавкиНДСНоменклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура
//  СтавкаНДС - СправочникСсылка.СтавкиНДС
//  ЗаписьНового - Булево
//  Дата - Дата - Необязательный, если не указана, то происходит запись на дату 01.01.1980
//
Процедура УстановитьАктуальнуюСтавкуНДСНоменклатурыПоОсновнойСтране(Номенклатура, СтавкаНДС, ЗаписьНового, Дата = '00010101') Экспорт
	
	ОсновнаяСтрана = ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана();
	
	Если ЗначениеЗаполнено(Дата) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СтавкиНДСНоменклатуры.Период КАК Период,
			|	СтавкиНДСНоменклатуры.Номенклатура КАК Номенклатура,
			|	СтавкиНДСНоменклатуры.Страна КАК Страна
			|ИЗ
			|	РегистрСведений.СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
			|ГДЕ
			|	СтавкиНДСНоменклатуры.Номенклатура = &Номенклатура
			|	И СтавкиНДСНоменклатуры.Страна = &Страна
			|	И СтавкиНДСНоменклатуры.Период > &Период";
		
		Запрос.УстановитьПараметр("Страна", ОсновнаяСтрана);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.УстановитьПараметр("Период", Дата);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
				НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
				НаборЗаписей.Отбор.Страна.Установить(ОсновнаяСтрана);
				
				НаборЗаписей.Записать();
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗаписьНового Тогда
		Дата = Дата("19800101");
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(НачалоМесяца(Дата));
	НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
	НаборЗаписей.Отбор.Страна.Установить(ОсновнаяСтрана);

	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = НачалоМесяца(Дата);
	НоваяЗапись.Номенклатура = Номенклатура;
	НоваяЗапись.Страна = ОсновнаяСтрана;
	НоваяЗапись.СтавкаНДС = СтавкаНДС;
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьАктуализациюСтавкиНДСНоменклатуры");
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Получает актуальную ставку НДС для номенклатуры по основной стране из РС.СтавкиНДСНоменклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура
//
// Возвращаемое значение:
//  СправочникСсылка.СтавкиНДС
//
Функция АктуальнаяСтавкаНДСНоменклатурыПоОсновнойСтране(Номенклатура) Экспорт
	
	СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
	ОсновнаяСтрана = ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтавкиНДСНоменклатурыСрезПоследних.СтавкаНДС КАК СтавкаНДС
		|ИЗ
		|	РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(
		|			,
		|			(Страна = &Страна
		|				ИЛИ Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка))
		|				И Номенклатура = &Номенклатура) КАК СтавкиНДСНоменклатурыСрезПоследних";
	
	Запрос.УстановитьПараметр("Страна", ОсновнаяСтрана);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		СтавкаНДС = Выборка.СтавкаНДС;
	КонецЕсли;
	
	Возврат СтавкаНДС;
	
КонецФункции

// Получает таблицу ставок НДС для номенклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - 
//  ОтборПоСтране - СправочникСсылка.СтраныМира - Если без отбора, то Неопределено
//  ОтборПоПериоду - Дата - Если без отбора, то Неопределено
//
// Возвращаемое значение:
//  ТаблицаЗначений - Содержит колонки:
//  	* Период - Дата -
//  	* Страна - СправочникСсылка.СтраныМира -
//  	* СтавкаНДС - СправочникСсылка.СтавкиНДС -
//  	* ОсновнаяСтавка - СправочникСсылка.СтавкиНДС -
Функция ТаблицаСтавокНДСНоменклатуры(Номенклатура, ОтборПоСтране = Неопределено, ОтборПоПериоду = Неопределено)  Экспорт
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтавкиНДСНоменклатуры.Период КАК Период,
	|	СтавкиНДСНоменклатуры.Страна КАК Страна,
	|	СтавкиНДСНоменклатуры.СтавкаНДС КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА СтавкиНДСНоменклатуры.СтавкаНДС.КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(3999, 1, 1)
	|		ИНАЧЕ СтавкиНДСНоменклатуры.СтавкаНДС.КонецПериода
	|	КОНЕЦ КАК СтавкаНДСДействуетДо,
	|	ВЫБОР
	|		КОГДА СтавкиНДСНоменклатуры.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НачальноеЗаполнение
	|ПОМЕСТИТЬ СтавкиНДСНоменклатуры
	|ИЗ
	|	РегистрСведений.СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
	|ГДЕ
	|	СтавкиНДСНоменклатуры.Номенклатура = &Номенклатура
	|	И (&ФильтрПоСтране1
	|			ИЛИ СтавкиНДСНоменклатуры.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	Страна,
	|	НачальноеЗаполнение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтавкиНДСНоменклатуры.Страна КАК Страна
	|ПОМЕСТИТЬ СтраныСтавокНДСНоменклатуры
	|ИЗ
	|	СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
	|ГДЕ
	|	НЕ СтавкиНДСНоменклатуры.НачальноеЗаполнение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатуры.Период КАК Период,
	|	СтраныСтавокНДСНоменклатуры.Страна КАК Страна,
	|	СтавкиНДСНоменклатуры.СтавкаНДС КАК СтавкаНДС,
	|	СтавкиНДСНоменклатуры.СтавкаНДСДействуетДо КАК СтавкаНДСДействуетДо
	|ПОМЕСТИТЬ СтавкиНДСНоменклатурыПоСтранам
	|ИЗ
	|	СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтраныСтавокНДСНоменклатуры КАК СтраныСтавокНДСНоменклатуры
	|		ПО (ИСТИНА)
	|ГДЕ
	|	СтавкиНДСНоменклатуры.НачальноеЗаполнение
	|	И НЕ СтраныСтавокНДСНоменклатуры.Страна ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатуры.Период,
	|	СтавкиНДСНоменклатуры.Страна,
	|	СтавкиНДСНоменклатуры.СтавкаНДС,
	|	СтавкиНДСНоменклатуры.СтавкаНДСДействуетДо
	|ИЗ
	|	СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
	|ГДЕ
	|	НЕ СтавкиНДСНоменклатуры.НачальноеЗаполнение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыПоСтранам.Период КАК Начало,
	|	ДОБАВИТЬКДАТЕ(ВЫБОР
	|			КОГДА СтавкиНДСНоменклатурыПоСтранам.СтавкаНДСДействуетДо > МИНИМУМ(ЕСТЬNULL(СтавкиНДСНоменклатурыПоСтранам1.Период, СтавкиНДСНоменклатурыПоСтранам.СтавкаНДСДействуетДо))
	|				ТОГДА МИНИМУМ(ЕСТЬNULL(СтавкиНДСНоменклатурыПоСтранам1.Период, СтавкиНДСНоменклатурыПоСтранам.СтавкаНДСДействуетДо))
	|			ИНАЧЕ СтавкиНДСНоменклатурыПоСтранам.СтавкаНДСДействуетДо
	|		КОНЕЦ, ДЕНЬ, 1) КАК Окончание,
	|	СтавкиНДСНоменклатурыПоСтранам.Страна КАК Страна,
	|	СтавкиНДСНоменклатурыПоСтранам.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ СтавкиНДСНоменклатурыПоПериодам
	|ИЗ
	|	СтавкиНДСНоменклатурыПоСтранам КАК СтавкиНДСНоменклатурыПоСтранам
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтавкиНДСНоменклатурыПоСтранам КАК СтавкиНДСНоменклатурыПоСтранам1
	|		ПО СтавкиНДСНоменклатурыПоСтранам.Период < СтавкиНДСНоменклатурыПоСтранам1.Период
	|			И СтавкиНДСНоменклатурыПоСтранам.Страна = СтавкиНДСНоменклатурыПоСтранам1.Страна
	|
	|СГРУППИРОВАТЬ ПО
	|	СтавкиНДСНоменклатурыПоСтранам.Период,
	|	СтавкиНДСНоменклатурыПоСтранам.Страна,
	|	СтавкиНДСНоменклатурыПоСтранам.СтавкаНДС,
	|	СтавкиНДСНоменклатурыПоСтранам.СтавкаНДСДействуетДо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна,
	|	Начало
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыПоПериодам.Страна КАК Страна,
	|	МАКСИМУМ(СтавкиНДСНоменклатурыПоПериодам.Окончание) КАК Окончание
	|ПОМЕСТИТЬ СтавкиНДСНоменклатурыМаксДата
	|ИЗ
	|	СтавкиНДСНоменклатурыПоПериодам КАК СтавкиНДСНоменклатурыПоПериодам
	|
	|СГРУППИРОВАТЬ ПО
	|	СтавкиНДСНоменклатурыПоПериодам.Страна
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыПоПериодам.Страна КАК Страна,
	|	МИНИМУМ(СтавкиНДСНоменклатурыПоПериодам.Начало) КАК Начало
	|ПОМЕСТИТЬ СтавкиНДСНоменклатурыМинДата
	|ИЗ
	|	СтавкиНДСНоменклатурыПоПериодам КАК СтавкиНДСНоменклатурыПоПериодам
	|
	|СГРУППИРОВАТЬ ПО
	|	СтавкиНДСНоменклатурыПоПериодам.Страна
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДС.Период КАК Период,
	|	ОсновныеСтавкиНДС.Страна КАК Страна,
	|	ОсновныеСтавкиНДС.СтавкаНДС КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА ОсновныеСтавкиНДС.СтавкаНДС.КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(3999, 1, 1)
	|		ИНАЧЕ ОсновныеСтавкиНДС.СтавкаНДС.КонецПериода
	|	КОНЕЦ КАК СтавкаНДСДействуетДо
	|ПОМЕСТИТЬ ОсновныеСтавкиНДС
	|ИЗ
	|	РегистрСведений.ОсновныеСтавкиНДС КАК ОсновныеСтавкиНДС
	|ГДЕ
	|	&ФильтрПоСтране2
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период,
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДС.Период КАК Начало,
	|	ДОБАВИТЬКДАТЕ(ВЫБОР
	|			КОГДА ОсновныеСтавкиНДС.СтавкаНДСДействуетДо > МИНИМУМ(ЕСТЬNULL(ОсновныеСтавкиНДС1.Период, ОсновныеСтавкиНДС.СтавкаНДСДействуетДо))
	|				ТОГДА МИНИМУМ(ЕСТЬNULL(ОсновныеСтавкиНДС1.Период, ОсновныеСтавкиНДС.СтавкаНДСДействуетДо))
	|			ИНАЧЕ ОсновныеСтавкиНДС.СтавкаНДСДействуетДо
	|		КОНЕЦ, ДЕНЬ, 1) КАК Окончание,
	|	ОсновныеСтавкиНДС.Страна КАК Страна,
	|	ОсновныеСтавкиНДС.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ОсновныеСтавкиНДСПоПериодам
	|ИЗ
	|	ОсновныеСтавкиНДС КАК ОсновныеСтавкиНДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсновныеСтавкиНДС КАК ОсновныеСтавкиНДС1
	|		ПО ОсновныеСтавкиНДС.Страна = ОсновныеСтавкиНДС1.Страна
	|			И ОсновныеСтавкиНДС.Период < ОсновныеСтавкиНДС1.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсновныеСтавкиНДС.Период,
	|	ОсновныеСтавкиНДС.Страна,
	|	ОсновныеСтавкиНДС.СтавкаНДС,
	|	ОсновныеСтавкиНДС.СтавкаНДСДействуетДо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна,
	|	Начало,
	|	Окончание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСПоПериодам.Страна КАК Страна,
	|	МАКСИМУМ(ОсновныеСтавкиНДСПоПериодам.Окончание) КАК Окончание
	|ПОМЕСТИТЬ ОсновныеСтавкиНДСМаксДата
	|ИЗ
	|	ОсновныеСтавкиНДСПоПериодам КАК ОсновныеСтавкиНДСПоПериодам
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсновныеСтавкиНДСПоПериодам.Страна
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСПоПериодам.Страна КАК Страна,
	|	МИНИМУМ(ОсновныеСтавкиНДСПоПериодам.Начало) КАК Начало
	|ПОМЕСТИТЬ ОсновныеСтавкиНДСМинДата
	|ИЗ
	|	ОсновныеСтавкиНДСПоПериодам КАК ОсновныеСтавкиНДСПоПериодам
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсновныеСтавкиНДСПоПериодам.Страна
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыПоПериодам.Страна КАК Страна,
	|	МАКСИМУМ(ЕСТЬNULL(СтавкиНДСНоменклатурыПоПериодам1.Окончание, СтавкиНДСНоменклатурыПоПериодам.Начало)) КАК ПустойИнтервалНачало,
	|	СтавкиНДСНоменклатурыПоПериодам.Начало КАК ПустойИнтервалОкончание
	|ПОМЕСТИТЬ ПустыеИнтервалыПредварительная
	|ИЗ
	|	СтавкиНДСНоменклатурыПоПериодам КАК СтавкиНДСНоменклатурыПоПериодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтавкиНДСНоменклатурыПоПериодам КАК СтавкиНДСНоменклатурыПоПериодам1
	|		ПО СтавкиНДСНоменклатурыПоПериодам.Страна = СтавкиНДСНоменклатурыПоПериодам1.Страна
	|			И СтавкиНДСНоменклатурыПоПериодам.Начало > СтавкиНДСНоменклатурыПоПериодам1.Начало
	|
	|СГРУППИРОВАТЬ ПО
	|	СтавкиНДСНоменклатурыПоПериодам.Страна,
	|	СтавкиНДСНоменклатурыПоПериодам.Начало
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСМинДата.Страна,
	|	ОсновныеСтавкиНДСМинДата.Начало,
	|	СтавкиНДСНоменклатурыМинДата.Начало
	|ИЗ
	|	СтавкиНДСНоменклатурыМинДата КАК СтавкиНДСНоменклатурыМинДата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОсновныеСтавкиНДСМинДата КАК ОсновныеСтавкиНДСМинДата
	|		ПО СтавкиНДСНоменклатурыМинДата.Страна = ОсновныеСтавкиНДСМинДата.Страна
	|ГДЕ
	|	ОсновныеСтавкиНДСМинДата.Начало < СтавкиНДСНоменклатурыМинДата.Начало
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыМаксДата.Страна,
	|	СтавкиНДСНоменклатурыМаксДата.Окончание,
	|	ОсновныеСтавкиНДСМаксДата.Окончание
	|ИЗ
	|	СтавкиНДСНоменклатурыМаксДата КАК СтавкиНДСНоменклатурыМаксДата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОсновныеСтавкиНДСМаксДата КАК ОсновныеСтавкиНДСМаксДата
	|		ПО СтавкиНДСНоменклатурыМаксДата.Страна = ОсновныеСтавкиНДСМаксДата.Страна
	|ГДЕ
	|	СтавкиНДСНоменклатурыМаксДата.Окончание < ОсновныеСтавкиНДСМаксДата.Окончание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПустыеИнтервалыПредварительная.Страна КАК Страна,
	|	ПустыеИнтервалыПредварительная.ПустойИнтервалНачало КАК ПустойИнтервалНачало,
	|	ПустыеИнтервалыПредварительная.ПустойИнтервалОкончание КАК ПустойИнтервалОкончание
	|ПОМЕСТИТЬ ПустыеИнтервалы
	|ИЗ
	|	ПустыеИнтервалыПредварительная КАК ПустыеИнтервалыПредварительная
	|ГДЕ
	|	ПустыеИнтервалыПредварительная.ПустойИнтервалОкончание > ПустыеИнтервалыПредварительная.ПустойИнтервалНачало
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна,
	|	ПустойИнтервалНачало,
	|	ПустойИнтервалОкончание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДС.Страна КАК Страна
	|ПОМЕСТИТЬ СтраныДополнительные
	|ИЗ
	|	ОсновныеСтавкиНДС КАК ОсновныеСтавкиНДС
	|ГДЕ
	|	НЕ ОсновныеСтавкиНДС.Страна В
	|				(ВЫБРАТЬ
	|					Т.Страна
	|				ИЗ
	|					СтраныСтавокНДСНоменклатуры КАК Т)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатуры.Период КАК Начало,
	|	СтраныДополнительные.Страна КАК Страна,
	|	СтавкиНДСНоменклатуры.СтавкаНДС КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА СтавкиНДСНоменклатуры.СтавкаНДСДействуетДо > ОсновныеСтавкиНДССрезПервых.Период
	|			ТОГДА ОсновныеСтавкиНДССрезПервых.Период
	|		ИНАЧЕ СтавкиНДСНоменклатуры.СтавкаНДСДействуетДо
	|	КОНЕЦ КАК Окончание,
	|	ЛОЖЬ КАК ОсновнаяСтавка
	|ПОМЕСТИТЬ ОсновныеСтавкиНДСДополнение
	|ИЗ
	|	СтавкиНДСНоменклатуры КАК СтавкиНДСНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтраныДополнительные КАК СтраныДополнительные
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПервых КАК ОсновныеСтавкиНДССрезПервых
	|			ПО СтраныДополнительные.Страна = ОсновныеСтавкиНДССрезПервых.Страна
	|		ПО (ИСТИНА)
	|ГДЕ
	|	СтавкиНДСНоменклатуры.НачальноеЗаполнение
	|	И НЕ СтраныДополнительные.Страна ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСПоПериодам.Начало,
	|	ОсновныеСтавкиНДСПоПериодам.Страна,
	|	ОсновныеСтавкиНДСПоПериодам.СтавкаНДС,
	|	ОсновныеСтавкиНДСПоПериодам.Окончание,
	|	ИСТИНА
	|ИЗ
	|	ОсновныеСтавкиНДСПоПериодам КАК ОсновныеСтавкиНДСПоПериодам
	|ГДЕ
	|	ОсновныеСтавкиНДСПоПериодам.Страна В
	|			(ВЫБРАТЬ
	|				Т.Страна
	|			ИЗ
	|				СтраныДополнительные КАК Т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПустыеИнтервалы.Страна КАК Страна,
	|	ВЫБОР
	|		КОГДА ПустыеИнтервалы.ПустойИнтервалНачало > ОсновныеСтавкиНДСПоПериодам.Начало
	|			ТОГДА ПустыеИнтервалы.ПустойИнтервалНачало
	|		ИНАЧЕ ОсновныеСтавкиНДСПоПериодам.Начало
	|	КОНЕЦ КАК Начало,
	|	ОсновныеСтавкиНДСПоПериодам.Окончание КАК Окончание,
	|	ОсновныеСтавкиНДСПоПериодам.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ОсновныеСтавкиНДСКПустымПериодам
	|ИЗ
	|	ПустыеИнтервалы КАК ПустыеИнтервалы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОсновныеСтавкиНДСПоПериодам КАК ОсновныеСтавкиНДСПоПериодам
	|		ПО ПустыеИнтервалы.ПустойИнтервалНачало < ОсновныеСтавкиНДСПоПериодам.Окончание
	|			И ПустыеИнтервалы.ПустойИнтервалОкончание >= ОсновныеСтавкиНДСПоПериодам.Начало
	|			И ПустыеИнтервалы.Страна = ОсновныеСтавкиНДСПоПериодам.Страна
	|ГДЕ
	|	ПустыеИнтервалы.ПустойИнтервалНачало <> ПустыеИнтервалы.ПустойИнтервалОкончание
	|	И НЕ ОсновныеСтавкиНДСПоПериодам.СтавкаНДС ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДСНоменклатурыПоПериодам.Страна КАК Страна,
	|	СтавкиНДСНоменклатурыПоПериодам.Начало КАК Период,
	|	СтавкиНДСНоменклатурыПоПериодам.Окончание КАК Окончание,
	|	СтавкиНДСНоменклатурыПоПериодам.СтавкаНДС КАК СтавкаНДС,
	|	ЛОЖЬ КАК ОсновнаяСтавка
	|ПОМЕСТИТЬ ВТ_Предварительная
	|ИЗ
	|	СтавкиНДСНоменклатурыПоПериодам КАК СтавкиНДСНоменклатурыПоПериодам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСДополнение.Страна,
	|	ОсновныеСтавкиНДСДополнение.Начало,
	|	ОсновныеСтавкиНДСДополнение.Окончание,
	|	ОсновныеСтавкиНДСДополнение.СтавкаНДС,
	|	ОсновныеСтавкиНДСДополнение.ОсновнаяСтавка
	|ИЗ
	|	ОсновныеСтавкиНДСДополнение КАК ОсновныеСтавкиНДСДополнение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновныеСтавкиНДСКПустымПериодам.Страна,
	|	ОсновныеСтавкиНДСКПустымПериодам.Начало,
	|	ОсновныеСтавкиНДСКПустымПериодам.Окончание,
	|	ОсновныеСтавкиНДСКПустымПериодам.СтавкаНДС,
	|	ИСТИНА
	|ИЗ
	|	ОсновныеСтавкиНДСКПустымПериодам КАК ОсновныеСтавкиНДСКПустымПериодам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Предварительная.Страна КАК Страна,
	|	МАКСИМУМ(ЕСТЬNULL(ВТ_Предварительная1.Окончание, ВТ_Предварительная.Период)) КАК Период,
	|	ВТ_Предварительная.Период КАК Окончание
	|ПОМЕСТИТЬ ПериодыПустыхСтавок
	|ИЗ
	|	ВТ_Предварительная КАК ВТ_Предварительная
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Предварительная КАК ВТ_Предварительная1
	|		ПО ВТ_Предварительная.Страна = ВТ_Предварительная1.Страна
	|			И ВТ_Предварительная.Период > ВТ_Предварительная1.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Предварительная.Страна,
	|	ВТ_Предварительная.Период
	|
	|ИМЕЮЩИЕ
	|	ВТ_Предварительная.Период > МАКСИМУМ(ЕСТЬNULL(ВТ_Предварительная1.Окончание, ВТ_Предварительная.Период))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Предварительная.Период КАК Период,
	|	ВТ_Предварительная.Страна КАК Страна,
	|	ВТ_Предварительная.СтавкаНДС КАК СтавкаНДС,
	|	ВТ_Предварительная.ОсновнаяСтавка КАК ОсновнаяСтавка,
	|	ЛОЖЬ КАК ПустаяСтавка
	|ИЗ
	|	ВТ_Предварительная КАК ВТ_Предварительная
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СтавкиНДСНоменклатурыМаксДата.Окончание > ОсновныеСтавкиНДСМаксДата.Окончание
	|			ТОГДА СтавкиНДСНоменклатурыМаксДата.Окончание
	|		ИНАЧЕ ОсновныеСтавкиНДСМаксДата.Окончание
	|	КОНЕЦ,
	|	СтавкиНДСНоменклатурыМаксДата.Страна,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка),
	|	ЛОЖЬ,
	|	ИСТИНА
	|ИЗ
	|	СтавкиНДСНоменклатурыМаксДата КАК СтавкиНДСНоменклатурыМаксДата
	|		ПОЛНОЕ СОЕДИНЕНИЕ ОсновныеСтавкиНДСМаксДата КАК ОсновныеСтавкиНДСМаксДата
	|		ПО СтавкиНДСНоменклатурыМаксДата.Страна = ОсновныеСтавкиНДСМаксДата.Страна
	|ГДЕ
	|	ВЫБОР
	|			КОГДА СтавкиНДСНоменклатурыМаксДата.Окончание > ОсновныеСтавкиНДСМаксДата.Окончание
	|				ТОГДА СтавкиНДСНоменклатурыМаксДата.Окончание
	|			ИНАЧЕ ОсновныеСтавкиНДСМаксДата.Окончание
	|		КОНЕЦ < &ТекущаяДата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПериодыПустыхСтавок.Период,
	|	ПериодыПустыхСтавок.Страна,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка),
	|	ЛОЖЬ,
	|	ИСТИНА
	|ИЗ
	|	ПериодыПустыхСтавок КАК ПериодыПустыхСтавок
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ ПО
	|	Страна";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ФильтрПоСтране1",
			?(ЗначениеЗаполнено(ОтборПоСтране), "СтавкиНДСНоменклатуры.Страна = &Страна", "ИСТИНА"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ФильтрПоСтране2",
			?(ЗначениеЗаполнено(ОтборПоСтране), "ОсновныеСтавкиНДС.Страна = &Страна", "ИСТИНА"));
			
	Запрос.Текст = ТекстЗапроса;

	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ОсновнаяСтрана", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Если ЗначениеЗаполнено(ОтборПоСтране) Тогда
		Запрос.УстановитьПараметр("Страна", ОтборПоСтране);	
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаСтавок = Новый ТаблицаЗначений;
	ТаблицаСтавок.Колонки.Добавить("Период");
	ТаблицаСтавок.Колонки.Добавить("Страна");
	ТаблицаСтавок.Колонки.Добавить("СтавкаНДС");
	ТаблицаСтавок.Колонки.Добавить("ОсновнаяСтавка");
	ТаблицаСтавок.Колонки.Добавить("ПустаяСтавка");

	ВыборкаСтрана = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСтрана.Следующий() Цикл
	
		ВыборкаДетальныеЗаписи = ВыборкаСтрана.Выбрать();
	    СтавкаВПериоде = Неопределено;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаДетальныеЗаписи.СтавкаНДС <> СтавкаВПериоде Тогда
				Если ЗначениеЗаполнено(ОтборПоПериоду) И ВыборкаДетальныеЗаписи.Период > ОтборПоПериоду Тогда
					Продолжить;
				КонецЕсли;					
				НоваяСтрока = ТаблицаСтавок.Добавить();
				НоваяСтрока.Страна = ВыборкаСтрана.Страна;
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
				СтавкаВПериоде = ВыборкаДетальныеЗаписи.СтавкаНДС;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаСтавок;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьГруппуНоменклатуры(ТаблицаЗначений, Группа)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В ИЕРАРХИИ(&Группа)
		|	И НЕ Номенклатура.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Группа", Группа);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаЗначений.Добавить();
			НоваяСтрока.Номенклатура = Выборка.Ссылка;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЗаписьВРегистр(Данные, Параметры)
	
	НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(Параметры.Период);
	НаборЗаписей.Отбор.Номенклатура.Установить(Данные.Номенклатура);
	НаборЗаписей.Отбор.Страна.Установить(Параметры.Страна);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, Данные);
	ЗаполнитьЗначенияСвойств(НоваяЗапись, Параметры);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
