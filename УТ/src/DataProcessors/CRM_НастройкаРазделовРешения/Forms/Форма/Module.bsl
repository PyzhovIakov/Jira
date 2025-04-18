
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// +Рабочий стол
	CRM_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// -Рабочий стол

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОтметитьНастроенныеРазделы", 0.1, Истина);
	#Иначе
		ОтметитьНастроенныеРазделы();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьНастроенныеРазделы" Тогда
		ОтметитьНастроенныеРазделы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияБлокПродажиНажатие(Элемент)
	ОткрытьФорму("Обработка.CRM_НастройкаСценарияПродаж.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПочтовыйКлиентНажатие(Элемент)
	ОткрытьФорму("Обработка.CRM_МенеджерПочты.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТелефонияНажатие(Элемент)
	ОткрытьФорму("Обработка.сфпАРМ_Телефония.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПортретКлиентаНажатие(Элемент)
	
	ОткрытьФорму("Обработка.CRM_НастройкаРазделовРешения.Форма.ФормаФильтра", , ЭтотОбъект,
		 УникальныйИдентификатор, , , ,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПоказателиНажатие(Элемент)
	ФормаПоказателей = ПолучитьФорму("Обработка.CRM_АРМ_УправлениеПоказателями.Форма.ФормаИспользуемыеПоказатели",
		 Новый Структура(), ЭтотОбъект,
		 УникальныйИдентификатор);
	ФормаПоказателей.ЧьиПоказатели = "Подразделения";
	ФормаПоказателей.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДиалогиНажатие(Элемент)
	УстановитьКонстантуИнтеграцияСМессенджерами();
	ОткрытьФорму("Обработка.CRM_Мессенджер.Форма.ФормаМессенджера", Новый Структура(), ЭтотОбъект,
		 УникальныйИдентификатор);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокНастроенныхРазделов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	CRM_НастроенныеРазделыРешения.РазделНастройки.Ссылка КАК РазделНастройкиСсылка
	|ИЗ
	|	РегистрСведений.CRM_НастроенныеРазделыРешения КАК CRM_НастроенныеРазделыРешения";
	
	МассивРазделов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("РазделНастройкиСсылка");
	
	СписокНастроенныхРазделов = Новый СписокЗначений;
	Для каждого ЭлементМассива Из МассивРазделов Цикл
		СписокНастроенныхРазделов.Добавить(ОбщегоНазначения.ИмяЗначенияПеречисления(ЭлементМассива));
	КонецЦикла;
	
	Возврат СписокНастроенныхРазделов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокРазделов()
	
	СписокРазделов = Новый СписокЗначений;
	Для Каждого Раздел Из Метаданные.Перечисления.CRM_РазделыНастройкиРешения.ЗначенияПеречисления Цикл
		СписокРазделов.Добавить(Раздел.Имя);
	КонецЦикла;
	
	Возврат СписокРазделов;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьНастроенныеРазделы()
	
	СписокНастроенныхРазделов = ПолучитьСписокНастроенныхРазделов();
	
	Для каждого ЭлементСписка Из СписокНастроенныхРазделов Цикл
		ИмяРаздела = ЭлементСписка.Значение;
		Элементы["Надпись" + ИмяРаздела].ЦветТекста = Новый Цвет(59, 176, 117);
		//Элементы["Галка" + ИмяРаздела].Видимость = Истина;
		Элементы["Декорация" + ИмяРаздела].Картинка = КартинкаРаздела(ИмяРаздела, "Галочка");
	КонецЦикла;
	СписокРазделов = ПолучитьСписокРазделов();
	Для Каждого Раздел Из СписокРазделов Цикл
		ИмяРаздела = Раздел.Значение;
		Если СписокНастроенныхРазделов.НайтиПоЗначению(ИмяРаздела) = Неопределено Тогда
			Элементы["Декорация" + ИмяРаздела].Картинка = КартинкаРаздела(ИмяРаздела, "");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция КартинкаРаздела(ИмяРаздела, Постфикс)
	Если ИмяРаздела = "Диалоги" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокДиалоги" + Постфикс];
	ИначеЕсли ИмяРаздела = "ПортретКлиента" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокКлиенты" + Постфикс];
	ИначеЕсли ИмяРаздела = "Показатели" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокПоказатели" + Постфикс];
	ИначеЕсли ИмяРаздела = "ПочтовыйКлиент" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокПочта" + Постфикс];
	ИначеЕсли ИмяРаздела = "СценарииПродаж" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокПродажи" + Постфикс];
	ИначеЕсли ИмяРаздела = "Телефония" Тогда
		Картинка = БиблиотекаКартинок["CRM_БлокТелефония" + Постфикс];
	КонецЕсли;
	Возврат Картинка;
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьКонстантуИнтеграцияСМессенджерами()
	
	Если НЕ Константы.CRM_ИспользоватьИнтеграциюСМессенджерами.Получить() Тогда
		Константы.CRM_ИспользоватьИнтеграциюСМессенджерами.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

// +Рабочий стол
#Область Подключаемый_РабочийСтол

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	CRM_СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеHTMLЗаметокПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	CRM_РабочийСтолКлиент.ПолеHTMLЗаметокПриНажатии(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_ПолеHTMLЗаметокПриНажатии()

#КонецОбласти

// -Рабочий стол

#КонецОбласти // СлужебныеПроцедурыИФункции
