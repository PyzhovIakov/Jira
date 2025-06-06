
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользуемыеТипыДокументов = Новый Массив();
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.НачисленияКредитовИДепозитов"));
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.Сторно"));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	НастроитьКнопкиУправленияДокументами();
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	НавигационнаяСсылка = "e1cib/list/Документ.НачисленияКредитовИДепозитов";

	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	Список.Параметры.УстановитьЗначениеПараметра("ТипСсылки",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.НачисленияКредитовИДепозитов"));
		
	ОбщегоНазначенияУТ.ЗаменитьПолеСсылкаКонструкциейВыразитьПоТипамДокументов(Элементы.Список,
		ХозяйственныеОперацииИДокументы);

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Период = Настройки.Получить("Период");
	УстановитьОтборПоПериоду();
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Организация", 
		Организация, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Организация));
	
	Если Параметры.Свойство("Период") Тогда
		
		ПериодСписка = Элементы.Список.Период;
		ПериодСписка.Вариант = ВариантСтандартногоПериода.Месяц;
		ПериодСписка.ДатаНачала = НачалоМесяца(Параметры.Период);
		ПериодСписка.ДатаОкончания = КонецМесяца(Параметры.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Проведение_Сторно"
			Или ИмяСобытия = "Запись_Сторно"
			Или ИмяСобытия = "Запись_НачисленияКредитовИДепозитов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПерехода(ОбъектПерехода, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ОбъектПерехода) Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ВыделитьОбъектПерехода(ОбъектПерехода);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Организация", 
		Организация, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОписаниеОповещенияПослеПометкиУдаления = Новый ОписаниеОповещения("УстановитьСнятьПометкуУдаленияЗавершение",ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок, ОписаниеОповещенияПослеПометкиУдаления);

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Копирование Тогда
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
	Иначе
		ОткрытьФорму("Документ.НачисленияКредитовИДепозитов.ФормаОбъекта", , Элементы.Список);
	КонецЕсли;
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтборы = Новый Структура("Организация", Организация);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтборы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСнятьПометкуУдаленияЗавершение(Результат,ДополнительныеПараметры) Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьОбъектПерехода(ОбъектПерехода)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектПерехода",ОбъектПерехода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ИзмеренияРегистра
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.Ссылка = &ОбъектПерехода";
	
	ИзмеренияРегистра = Метаданные.РегистрыСведений.РеестрДокументов.Измерения;
	МассивИзмеренийВЗапросе = Новый Массив;
	Для Каждого ИзмерениеРегистра Из ИзмеренияРегистра Цикл
		МассивИзмеренийВЗапросе.Добавить(ИзмерениеРегистра.Имя);
	КонецЦикла;	
	ИзмеренияВЗапросе = СтрСоединить(МассивИзмеренийВЗапросе,"," + Символы.ВК);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"&ИзмеренияРегистра",ИзмеренияВЗапросе);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураКлючаЗаписи = Новый Структура(ИзмеренияВЗапросе);
		ЗаполнитьЗначенияСвойств(СтруктураКлючаЗаписи,Выборка);
		КлючЗаписи = РегистрыСведений.РеестрДокументов.СоздатьКлючЗаписи(СтруктураКлючаЗаписи);
		Элементы.Список.ТекущаяСтрока = КлючЗаписи;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		Период.ДатаОкончания);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#Область ЖурналДокументов

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Документы.НачисленияКредитовИДепозитов.ИнициализироватьХозяйственныеОперацииИДокументы(
		ХозяйственныеОперацииИДокументы.Выгрузить());
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтотОбъект;
	СтруктураПараметров.ИмяГруппыСоздать                                    = "СписокГруппаСоздатьГенерируемая";
	СтруктураПараметров.ИмяГруппыСоздатьКонтекст                            = "СписокГруппаСоздатьГенерируемаяКонтекст";
	СтруктураПараметров.ИмяКнопкиСкопировать 								= "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню 				= "СписокКонтекстноеМенюСкопировать";
	СтруктураПараметров.ИмяКнопкиИзменить 									= "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню 					= "СписокКонтекстноеМенюИзменить";
	СтруктураПараметров.ИмяКнопкиПровести 									= "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню 					= "СписокКонтекстноеМенюПровести";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения 							= "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню 			= "СписокКонтекстноеМенюОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления 					= "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню 	= "СписокКонтекстноеМенюУстановитьПометкуУдаления";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
