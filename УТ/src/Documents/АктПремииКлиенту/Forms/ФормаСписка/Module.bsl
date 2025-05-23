//@strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		Элементы.Список.ИзменятьСоставСтрок = Ложь;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	ИменаЭлементов = Новый Массив; // Массив из Строка
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		
		ИменаЭлементов.Добавить(Элементы.ОтборОрганизация.Имя);
		ИменаЭлементов.Добавить(Элементы.ОрганизацияОтборКОформлению.Имя);
		
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		
		ИменаЭлементов.Добавить(Элементы.ВалютаОтборКОформлению.Имя);
		
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Документы.АктПремииКлиенту) Тогда
		
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		ИменаЭлементов.Добавить(Элементы.СтраницаДокументыКОформлению.Имя);
		ИменаЭлементов.Добавить(Элементы.ГруппаБыстрыеОтборыКОформлению.Имя);
		ИменаЭлементов.Добавить(Элементы.ДатаФормированияДокументов.Имя);
		ИменаЭлементов.Добавить(Элементы.ОрганизацияОтборКОформлению.Имя);
		ИменаЭлементов.Добавить(Элементы.КонтрагентОтборКОформлению.Имя);
		ИменаЭлементов.Добавить(Элементы.ВалютаОтборКОформлению.Имя);
		ИменаЭлементов.Добавить(Элементы.СводноПоКонтрагенту.Имя);
		ИменаЭлементов.Добавить(Элементы.СписокКОформлениюОформитьДокумент.Имя);
		ИменаЭлементов.Добавить(Элементы.СписокКОформлению.Имя);
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, ИменаЭлементов, "Видимость", Ложь);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Организация", "Видимость", НЕ ЗначениеЗаполнено(Организация));
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		Список, "Статус", Статус, СтруктураБыстрогоОтбора);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Статус", "Видимость", НЕ ЗначениеЗаполнено(Статус));
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Ответственный", "Видимость", НЕ ЗначениеЗаполнено(Ответственный));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ДатаФормированияДокументов = ТекущаяДатаСеанса();
	
	УстановитьСвойстваДинамическогоСпискаКОформлению();
	ГраницаОстатков = ДатаАктуальности();
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокКОформлению, "ГраницаОстатков", ГраницаОстатков);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		Список, "Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		Список, "Статус", Статус, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_АктПремииКлиенту" Тогда
		
		Элементы.СписокКОформлению.Обновить();
		
		// СтандартныеПодсистемы.ПодключаемыеКоманды
		ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОрганизацияЗаполнена = ЗначениеЗаполнено(Организация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОрганизацияЗаполнена);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Организация", "Видимость", НЕ ОрганизацияЗаполнена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	СтатусЗаполнен = ЗначениеЗаполнено(Статус);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Статус,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		СтатусЗаполнен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Статус", "Видимость", НЕ СтатусЗаполнен);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйЗаполнен = ЗначениеЗаполнено(Ответственный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОтветственныйЗаполнен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Ответственный", "Видимость", НЕ ОтветственныйЗаполнен);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборКОформлениюПриИзменении(Элемент)
	
	ОрганизацияЗаполнена = ЗначениеЗаполнено(ОрганизацияОтборКОформлению);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению,
		"Организация",
		ОрганизацияОтборКОформлению,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОрганизацияЗаполнена);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтборКОформлениюПриИзменении(Элемент)
	
	КонтрагентЗаполнен = ЗначениеЗаполнено(КонтрагентОтборКОформлению);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению,
		"Контрагент",
		КонтрагентОтборКОформлению,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		КонтрагентЗаполнен);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаОтборКОформлениюПриИзменении(Элемент)
	
	ВалютаЗаполнена = ЗначениеЗаполнено(ВалютаОтборКОформлению);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению,
		"Валюта",
		ВалютаОтборКОформлению,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ВалютаЗаполнена);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаФормированияДокументовПриИзменении(Элемент)
	
	ДатаФормированияДокументовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СводноПоКонтрагентуПриИзменении(Элемент)
	
	СводноПоКонтрагентуПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Параметры:
//   Команда - КомандаФормы - выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом

// Параметры:
//   Команда - КомандаФормы - выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура ОформитьДокумент(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если ДатаФормированияДокументов = Дата(1, 1, 1) Тогда
		
		ВидПоля = "Поле";
		ВидСообщения = "Заполнение";
		
		ИмяПоля = НСтр("ru = 'Дата формирования документов'");
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(ВидПоля, ВидСообщения, ИмяПоля);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ДатаФормированияДокументов",, Отказ);
		
	КонецЕсли;
	
	ТекущиеДанные = Элементы.СписокКОформлению.ТекущиеДанные; // ДанныеФормыСтруктура
	Если ТекущиеДанные = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбрана строка остатков для оформления документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СписокКОформлению",, Отказ);
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если СводноПоКонтрагенту Тогда
			ПартнерДляЗаполнения = ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка");
		Иначе
			ПартнерДляЗаполнения = ТекущиеДанные.Партнер;
		КонецЕсли;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Организация", ТекущиеДанные.Организация);
		ДанныеЗаполнения.Вставить("Дата", ДатаФормированияДокументов);
		ДанныеЗаполнения.Вставить("Контрагент", ТекущиеДанные.Контрагент);
		ДанныеЗаполнения.Вставить("ВалютаДокумента", ТекущиеДанные.Валюта);
		ДанныеЗаполнения.Вставить("ВалютаВзаиморасчетов", ТекущиеДанные.Валюта);
		ДанныеЗаполнения.Вставить("Партнер", ПартнерДляЗаполнения);
		ДанныеЗаполнения.Вставить("ЗаполнениеПоОстаткам", Истина);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ДанныеЗаполнения);
		
		ОткрытьФорму("Документ.АктПремииКлиенту.Форма.ФормаДокумента", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийЭлементовШапкиФормыВспомогательные

&НаСервере
Процедура СводноПоКонтрагентуПриИзмененииСервер()
	
	УстановитьСвойстваДинамическогоСпискаКОформлению();
	
	Элементы.СписокКОформлениюПартнер.Видимость = НЕ СводноПоКонтрагенту;
	
КонецПроцедуры

&НаСервере
Процедура ДатаФормированияДокументовПриИзмененииСервер()
	
	ГраницаОстатков = ДатаАктуальности();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокКОформлению, "ГраницаОстатков", ГраницаОстатков);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьСвойстваДинамическогоСпискаКОформлению()
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "РегистрНакопления.РетроБонусыКлиентов.Остатки";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокКОформлению, СвойстваСписка);
	
	УстановитьСортировкуСпискаДокументовКОформлению();
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаДинамическогоСписка()
	
	Если СводноПоКонтрагенту Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОстаткиНаДату.Организация КАК Организация,
		|	ОстаткиНаДату.Контрагент КАК Контрагент,
		|	ОстаткиНаДату.Валюта КАК Валюта,
		|	ВЫБОР
		|		КОГДА СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток) > СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток)
		|			ТОГДА СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток)
		|		ИНАЧЕ СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток)
		|	КОНЕЦ КАК Сумма,
		|	"""" КАК Отступ
		|{ВЫБРАТЬ
		|	Организация.*,
		|	Контрагент.*,
		|	Валюта.*,
		|	Сумма,
		|	Отступ}
		|ИЗ
		|	РегистрНакопления.РетроБонусыКлиентов.Остатки(&ГраницаОстатков, {(Организация) КАК Организация, (Контрагент) КАК Контрагент, (Валюта) КАК Валюта}) КАК ОстаткиНаДату
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РетроБонусыКлиентов.Остатки(, {(Организация) КАК Организация, (Контрагент) КАК Контрагент, (Валюта) КАК Валюта}) КАК ОстаткиКонец
		|		ПО ОстаткиНаДату.Организация = ОстаткиКонец.Организация
		|			И ОстаткиНаДату.Контрагент = ОстаткиКонец.Контрагент
		|			И ОстаткиНаДату.Валюта = ОстаткиКонец.Валюта
		|			И ОстаткиНаДату.НачалоПериода = ОстаткиКонец.НачалоПериода
		|			И ОстаткиНаДату.ОкончаниеПериода = ОстаткиКонец.ОкончаниеПериода
		|			И ОстаткиНаДату.ДокументУсловий = ОстаткиКонец.ДокументУсловий
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиНаДату.Организация,
		|	ОстаткиНаДату.Контрагент,
		|	ОстаткиНаДату.Валюта
		|
		|ИМЕЮЩИЕ
		|	СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток) > 0 И
		|	СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток) > 0";
		
	Иначе
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОстаткиНаДату.Организация КАК Организация,
		|	ОстаткиНаДату.Контрагент КАК Контрагент,
		|	ОстаткиНаДату.Партнер КАК Партнер,
		|	ОстаткиНаДату.Валюта КАК Валюта,
		|	ВЫБОР
		|		КОГДА СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток) > СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток)
		|			ТОГДА СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток)
		|		ИНАЧЕ СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток)
		|	КОНЕЦ КАК Сумма,
		|	"""" КАК Отступ
		|{ВЫБРАТЬ
		|	Организация.*,
		|	Контрагент.*,
		|	Партнер.*,
		|	Валюта.*,
		|	Сумма,
		|	Отступ}
		|ИЗ
		|	РегистрНакопления.РетроБонусыКлиентов.Остатки(&ГраницаОстатков, {(Организация) КАК Организация, (Контрагент) КАК Контрагент, (Валюта) КАК Валюта}) КАК ОстаткиНаДату
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РетроБонусыКлиентов.Остатки(, {(Организация) КАК Организация, (Контрагент) КАК Контрагент, (Валюта) КАК Валюта}) КАК ОстаткиКонец
		|		ПО ОстаткиНаДату.Организация = ОстаткиКонец.Организация
		|			И ОстаткиНаДату.Контрагент = ОстаткиКонец.Контрагент
		|			И ОстаткиНаДату.Партнер = ОстаткиКонец.Партнер
		|			И ОстаткиНаДату.Валюта = ОстаткиКонец.Валюта
		|			И ОстаткиНаДату.НачалоПериода = ОстаткиКонец.НачалоПериода
		|			И ОстаткиНаДату.ОкончаниеПериода = ОстаткиКонец.ОкончаниеПериода
		|			И ОстаткиНаДату.ДокументУсловий = ОстаткиКонец.ДокументУсловий
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиНаДату.Организация,
		|	ОстаткиНаДату.Контрагент,
		|	ОстаткиНаДату.Партнер,
		|	ОстаткиНаДату.Валюта
		|
		|ИМЕЮЩИЕ
		|	СУММА(ОстаткиНаДату.СуммаБонусОстаток - ОстаткиНаДату.КАктированиюОстаток - ОстаткиНаДату.КПодписаниюОстаток - ОстаткиНаДату.КСписаниюОстаток) > 0 И
		|	СУММА(ОстаткиКонец.СуммаБонусОстаток - ОстаткиКонец.КАктированиюОстаток - ОстаткиКонец.КПодписаниюОстаток - ОстаткиКонец.КСписаниюОстаток) > 0";
		
	КонецЕсли;
		
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура УстановитьСортировкуСпискаДокументовКОформлению()
	
	СписокКОформлению.Порядок.Элементы.Очистить();
	
	ЭлементПорядка = СписокКОформлению.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Организация");
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = СписокКОформлению.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Контрагент");
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.Использование = Истина;
	
	Если НЕ СводноПоКонтрагенту Тогда
		
		ЭлементПорядка = СписокКОформлению.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Партнер");
		ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ЭлементПорядка.Использование = Истина;
		
	КонецЕсли;
	
	ЭлементПорядка = СписокКОформлению.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Валюта");
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = СписокКОформлению.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Сумма");
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

// Возвращаемое значение:
//  Дата, Граница - Дата актуальности
//
&НаСервере
Функция ДатаАктуальности()
	
	Если ЗначениеЗаполнено(ДатаФормированияДокументов) Тогда
		
		Результат = Новый Граница(КонецДня(ДатаФормированияДокументов), ВидГраницы.Включая);
		
	Иначе
		
		Результат = Дата(1, 1, 1);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Подключаемый продолжить выполнение команды на сервере.
// 
// Параметры:
//  ПараметрыВыполнения - Структура -
//  ДополнительныеПараметры - Структура -
//
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти