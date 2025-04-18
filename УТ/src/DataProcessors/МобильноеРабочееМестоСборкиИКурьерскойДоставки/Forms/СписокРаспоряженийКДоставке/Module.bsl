
#Область ОбработчикиСобытийФормы
// Код процедур и функций

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ФизическоеЛицо");
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	ТекущийСклад = Параметры.ТекущийСклад;
	ТипСотрудника = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ТипСотрудникаКурьер();
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТекущаяВкладка = Настройки.Получить("ТекущаяВкладка");
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОформитьМеню();
	СфомироватьПредставлениеОтборов();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбора") Тогда
		
		ТекущийСклад = ВыбранноеЗначение;
		СфомироватьПредставлениеОтборов();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокРаспоряжений" Тогда
		ОбновитьДанныеФормы();
		ОформитьМеню();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряженийНазначенныеМне

&НаКлиенте
Процедура СписокРаспоряженийНазначенныеМнеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СписокРаспоряженийНазначенныеМне.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СписокРаспоряженийНазначенныеМнеАдресДоставкиПредставление Тогда
		ПоказатьКарту(ТекущаяСтрока);
	Иначе
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Распоряжение", ТекущаяСтрока.Распоряжение);
		ПараметрыОткрытияФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
			
		ОткрытьФорму(
			"Обработка.МобильноеРабочееМестоСборкиИКурьерскойДоставки.Форма.КарточкаРаспоряжения",
			ПараметрыОткрытияФормы,
			ЭтаФорма,,,,,
			РежимОткрытияОкнаФормы.Независимый);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряженийНераспределенные

&НаКлиенте
Процедура СписокРаспоряженийНераспределенныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СписокРаспоряженийНераспределенные.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СписокРаспоряженийНераспределенныеАдресДоставкиПредставление Тогда
		ПоказатьКарту(ТекущаяСтрока);
	Иначе
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Распоряжение", ТекущаяСтрока.Распоряжение);
		ПараметрыОткрытияФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
			
		ОткрытьФорму(
			"Обработка.МобильноеРабочееМестоСборкиИКурьерскойДоставки.Форма.КарточкаРаспоряжения",
			ПараметрыОткрытияФормы,
			ЭтаФорма,,,,,
			РежимОткрытияОкнаФормы.Независимый);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	ОбновитьДанныеФормы();
	ОформитьМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчистить(Команда)
	
	ТекущийСклад = Неопределено;
	СфомироватьПредставлениеОтборов();
	ОбновитьДанныеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ОтборыОткрыть(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("Ссылка", ДоступныеСклады()));
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаНазначенныеМне(Команда)
	
	Если ТекущаяВкладка = 1 Тогда
		ПерейтиНаВкладку(0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаНераспределенные(Команда)
	
	Если ТекущаяВкладка = 0 Тогда
		ПерейтиНаВкладку(1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьВДоставку(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженийНераспределенные.ТекущиеДанные;
	ПараметрыРаспоряжения = Новый Структура("Склад, Распоряжение", ТекущаяСтрока.Склад, ТекущаяСтрока.Распоряжение);
	НазначитьСнятьСотрудника(ПараметрыРаспоряжения, ТипСотрудника, Сотрудник);
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьСМеня(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженийНазначенныеМне.ТекущиеДанные;
	ПараметрыРаспоряжения = Новый Структура("Склад, Распоряжение", ТекущаяСтрока.Склад, ТекущаяСтрока.Распоряжение);
	НазначитьСнятьСотрудника(ПараметрыРаспоряжения, ТипСотрудника);
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДоставку(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженийНазначенныеМне.ТекущиеДанные;
	ПриступитьКДостаке(ТекущаяСтрока.Распоряжение);
	СформироватьЗаголовкиКомандМеню();

КонецПроцедуры

&НаСервере
Процедура ПриступитьКДостаке(Распоряжение);
	
	Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.УстановитьСтатусРаспоряженияДоставляется(Распоряжение);
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура НазначитьСнятьСотрудника(ПараметрыРаспоряжения, ТипСотрудника, Сотрудник = Неопределено);
	
	НастройкиСклада = СкладыСервер.НастройкиСкладаДляСборкиИДоставки(ПараметрыРаспоряжения.Склад);
	
	Если НастройкиСклада = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиСклада.КурьерыМогутНазначатьСебеЗаказы Тогда
		
		Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.НазначитьСнятьСотрудника(ПараметрыРаспоряжения.Распоряжение,
										ТипСотрудника,
										Сотрудник);
		ОбновитьДанныеФормы();
		
	Иначе
		
		ТекстОшибки = СтрШаблон(НСтр("ru='Для склада %1 курьеру запрещено назначать/снимать с себя заказ.'"), ПараметрыРаспоряжения.Склад);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиНаВкладку(КодВкладки = 0)
	
	ТекущаяВкладка = КодВкладки;
	ОбновитьДанныеФормы();
	ОформитьМеню();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиМагазинов.Склад КАК Склад
	|ПОМЕСТИТЬ ДоступныеСклады
	|ИЗ
	|	РегистрСведений.СотрудникиМагазинов КАК СотрудникиМагазинов
	|ГДЕ
	|	СотрудникиМагазинов.Сотрудник = &Сотрудник
	|	И СотрудникиМагазинов.Курьер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ЗоныДоставкиКурьеров.ЗонаДоставки) КАК КоличествоЗонДоставки
	|ПОМЕСТИТЬ ДоступныеЗоны
	|ИЗ
	|	РегистрСведений.ЗоныДоставкиКурьеров КАК ЗоныДоставкиКурьеров
	|ГДЕ
	|	ЗоныДоставкиКурьеров.Курьер = &Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение КАК Распоряжение,
	|	СтатусыСборкиИДоставки.Статус КАК Статус,
	|	Документы.Склад КАК Склад,
	|	Документы.Курьер КАК Курьер,
	|	Документы.Номер КАК Номер,
	|	Документы.ДатаОтгрузки КАК ДатаДоставки,
	|	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	Документы.АдресДоставки КАК АдресДоставкиПредставление,
	|	Документы.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта КАК Валюта,
	|	Документы.ФормаОплаты КАК ФормаОплаты,
	|	Документы.Организация КАК Организация
	|ПОМЕСТИТЬ ВременнаяТаблицаРаспоряжения
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документы
	|		ПО ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.ЗаказКлиента) = Документы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗоныДоставкиКурьеров КАК ЗоныДоставкиКурьеров
	|		ПО Документы.ЗонаДоставки = ЗоныДоставкиКурьеров.ЗонаДоставки
	|		И ЗоныДоставкиКурьеров.Курьер = &Сотрудник,
	|	ДоступныеЗоны КАК ДоступныеЗоны
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И (Документы.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	ИЛИ Документы.Курьер = &Сотрудник)
	|	И Документы.Проведен
	|	И ВЫБОР
	|		КОГДА ДоступныеЗоны.КоличествоЗонДоставки > 0
	|			ТОГДА ЗоныДоставкиКурьеров.ЗонаДоставки = Документы.ЗонаДоставки
	|			ИЛИ Документы.Курьер = &Сотрудник
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение,
	|	СтатусыСборкиИДоставки.Статус,
	|	Документы.Склад,
	|	Документы.Курьер,
	|	Документы.Номер,
	|	Документы.Дата,
	|	Документы.ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо,
	|	Документы.СуммаДокумента,
	|	Документы.АдресДоставки,
	|	Документы.АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта,
	|	Документы.ФормаОплаты,
	|	Документы.Организация
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Документы
	|		ПО ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.РеализацияТоваровУслуг) = Документы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗоныДоставкиКурьеров КАК ЗоныДоставкиКурьеров
	|		ПО Документы.ЗонаДоставки = ЗоныДоставкиКурьеров.ЗонаДоставки
	|		И ЗоныДоставкиКурьеров.Курьер = &Сотрудник,
	|	ДоступныеЗоны КАК ДоступныеЗоны
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И (Документы.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	ИЛИ Документы.Курьер = &Сотрудник)
	|	И Документы.Проведен
	|	И ВЫБОР
	|		КОГДА ДоступныеЗоны.КоличествоЗонДоставки > 0
	|			ТОГДА ЗоныДоставкиКурьеров.ЗонаДоставки = Документы.ЗонаДоставки
	|			ИЛИ Документы.Курьер = &Сотрудник
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|		КОГДА Распоряжения.Курьер = &Сотрудник
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ) КАК КоличествоНазначенныеМне,
	|	СУММА(ВЫБОР
	|		КОГДА Распоряжения.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		И НЕ ДоступныеСклады.Склад ЕСТЬ NULL
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ) КАК КоличествоНераспределенные
	|ИЗ
	|	ВременнаяТаблицаРаспоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДоступныеСклады КАК ДоступныеСклады
	|		ПО Распоряжения.Склад = ДоступныеСклады.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Кассы.Владелец КАК Организация,
	|	Кассы.Ссылка КАК Касса
	|ПОМЕСТИТЬ ВременннаяТаблицаКассы
	|ИЗ
	|	ВременнаяТаблицаРаспоряжения КАК ТаблицаРаспоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Кассы КАК Кассы
	|		ПО ТаблицаРаспоряжения.Организация = Кассы.Владелец
	|ГДЕ
	|	Кассы.ПометкаУдаления = ЛОЖЬ
	|	И Кассы.ОперационнаяКасса = ИСТИНА
	|	И Кассы.ФизическоеЛицо = &Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРаспоряжения.Распоряжение КАК Распоряжение,
	|	ТаблицаРаспоряжения.Статус КАК Статус,
	|	СУММА(ЕСТЬNULL(РасчетыСКлиентами.КОплатеОстаток, 0)) КАК СуммаКОплате
	|ПОМЕСТИТЬ ВременнаяТаблицаКОплатеПромежуточная
	|ИЗ
	|	ВременнаяТаблицаРаспоряжения КАК ТаблицаРаспоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами.Остатки(,) КАК РасчетыСКлиентами
	|		ПО ТаблицаРаспоряжения.Распоряжение = РасчетыСКлиентами.ОбъектРасчетов.Объект
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРаспоряжения.Распоряжение,
	|	ТаблицаРаспоряжения.Статус
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаКОплате.Распоряжение КАК Распоряжение,
	|	ВременнаяТаблицаКОплате.СуммаКОплате КАК СуммаКОплате,
	|	СУММА(ВЫБОР
	|		КОГДА ДенежныеСредстваНаличные.Касса = ТаблицаКассы.Касса
	|			ТОГДА ВЫБОР
	|				КОГДА ДенежныеСредстваНаличные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|					ТОГДА ДенежныеСредстваНаличные.Сумма
	|				ИНАЧЕ -ДенежныеСредстваНаличные.Сумма
	|			КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ) КАК СуммаКОплатеКурьер
	|ПОМЕСТИТЬ ВременнаяТаблицаКОплате
	|ИЗ
	|	ВременнаяТаблицаКОплатеПромежуточная КАК ВременнаяТаблицаКОплате
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредстваНаличные
	|		ПО ВременнаяТаблицаКОплате.Распоряжение = ДенежныеСредстваНаличные.ОбъектРасчетов.Объект
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременннаяТаблицаКассы КАК ТаблицаКассы
	|		ПО ДенежныеСредстваНаличные.Организация = ТаблицаКассы.Организация
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаКОплате.Распоряжение,
	|	ВременнаяТаблицаКОплате.СуммаКОплате
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Распоряжения.Курьер = &Сотрудник
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НазначеноеМне,
	|	ВЫБОР
	|		КОГДА Распоряжения.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		И НЕ ДоступныеСклады.Склад ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Нераспределенное,
	|	Распоряжения.Распоряжение КАК Распоряжение,
	|	Распоряжения.Статус КАК Статус,
	|	Распоряжения.Склад КАК Склад,
	|	Распоряжения.Курьер КАК Курьер,
	|	Распоряжения.Номер КАК Номер,
	|	Распоряжения.ДатаДоставки КАК ДатаДоставки,
	|	Распоряжения.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Распоряжения.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Распоряжения.СуммаДокумента КАК СуммаДокумента,
	|	Распоряжения.АдресДоставкиПредставление КАК АдресДоставкиПредставление,
	|	Распоряжения.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Распоряжения.ДополнительнаяИнформацияПоДоставке КАК Комментарий,
	|	Распоряжения.Валюта КАК Валюта,
	|	Распоряжения.ФормаОплаты КАК ФормаОплаты,
	|	ТаблицаКОплате.СуммаКОплате + ТаблицаКОплате.СуммаКОплатеКурьер КАК СуммаКОплате
	|ИЗ
	|	ВременнаяТаблицаРаспоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДоступныеСклады КАК ДоступныеСклады
	|		ПО Распоряжения.Склад = ДоступныеСклады.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКОплате КАК ТаблицаКОплате
	|		ПО Распоряжения.Распоряжение = ТаблицаКОплате.Распоряжение
	|ГДЕ
	|	(Распоряжения.Курьер = &Сотрудник
	|	ИЛИ НЕ ДоступныеСклады.Склад ЕСТЬ NULL)
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	ИЛИ Распоряжения.Склад В ИЕРАРХИИ (&Склад))
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДоставки,
	|	ВремяДоставкиПо";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Статусы", СкладыСервер.СтатусыРаспоряженийДляНачалаДоставкиКурьером());
	
	Результаты = Запрос.ВыполнитьПакет();
	
	РезультатСводно = Результаты[3].Выгрузить();
	ВыборкаПоРаспоряжениям = Результаты[7].Выбрать();
	
	КоличествоРаспоряженийНазначенныеМне = РезультатСводно[0].КоличествоНазначенныеМне;
	КоличествоРаспоряженийНераспределенные = РезультатСводно[0].КоличествоНераспределенные;
	
	СписокРаспоряженийНазначенныеМне.Очистить();
	СписокРаспоряженийНераспределенные.Очистить();
	
	Пока ВыборкаПоРаспоряжениям.Следующий() Цикл
		
		Если ВыборкаПоРаспоряжениям.НазначеноеМне Тогда
			НоваяСтрока = СписокРаспоряженийНазначенныеМне.Добавить();
		ИначеЕсли ВыборкаПоРаспоряжениям.Нераспределенное Тогда
			НоваяСтрока = СписокРаспоряженийНераспределенные.Добавить();
		Иначе
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРаспоряжениям);
		
		Если ЗначениеЗаполнено(НоваяСтрока.Комментарий) Тогда
			НоваяСтрока.КомментарийКартинка = 1;
		КонецЕсли;
		
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		НоваяСтрока.ДатаВремяДоставкиПредставление = Модуль.ДатаВремяДоставкиПредставление(НоваяСтрока);
		НоваяСтрока.ОсталосьВремениНаДоставку = Модуль.ОсталосьВремениНаДоставку(НоваяСтрока);
		НоваяСтрока.СуммаПредставление = Модуль.СуммаКОплатеПредставление(НоваяСтрока);
		НоваяСтрока.ФормаОплатыПредставление = Модуль.ФормаОплатыПредставление(НоваяСтрока);
		
	КонецЦикла;
	
	Если ТекущаяВкладка = 0 Тогда
		КоличествоРаспоряженийПоСкладу = СписокРаспоряженийНазначенныеМне.Количество();
	Иначе
		КоличествоРаспоряженийПоСкладу = СписокРаспоряженийНераспределенные.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СфомироватьПредставлениеОтборов()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(ТекущийСклад) Тогда
		ПредставленияОтборов = ТекущийСклад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru='Выбрать магазин/склад'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Серый;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрыть.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьМеню()
	
	Если ТекущаяВкладка = 0 Тогда
		ИмяЭлементаРамка    = "РамкаНазначенныеМне";
		ИмяЭлементаКоманда  = "КомандаНазначенныеМне";
		ИмяЭлементаСтраница = "СтраницаНазначенныеМне";
	Иначе
		ИмяЭлементаРамка    = "РамкаНераспределенные";
		ИмяЭлементаКоманда  = "КомандаНераспределенные";
		ИмяЭлементаСтраница = "СтраницаНераспределенные";
	КонецЕсли;
	
	Элементы.РамкаНазначенныеМне.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаНазначенныеМне.ЦветТекста = WebЦвета.Серый;
	
	Элементы.РамкаНераспределенные.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаНераспределенные.ЦветТекста = WebЦвета.Серый;
	
	Элементы[ИмяЭлементаРамка].Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Элементы[ИмяЭлементаКоманда].ЦветТекста = WebЦвета.Черный;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ИмяЭлементаСтраница];
	
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовкиКомандМеню()
	Элементы.КомандаНазначенныеМне.Заголовок = СтрШаблон(НСтр("ru='Мои (%1)'"), КоличествоРаспоряженийНазначенныеМне);
	Элементы.КомандаНераспределенные.Заголовок = СтрШаблон(НСтр("ru='Свободные (%1)'"), КоличествоРаспоряженийНераспределенные);
КонецПроцедуры

&НаСервере
Функция ДоступныеСклады()
	
	Возврат СкладыСервер.ДоступныеСкладыСотрудникаПоТипуСотрудника(Сотрудник, ТипСотрудника);
	
КонецФункции

&НаКлиенте
Процедура ПоказатьКарту(Данные)
 
#Если МобильныйКлиент Тогда
	СписокМестоположений = Новый СписокЗначений;
	СписокМестоположений.Добавить(ПолучитьКоординатыКлиента(Данные)); 
	ПоказатьНаКарте(СписокМестоположений);
#КонецЕсли
	 
 КонецПроцедуры

&НаКлиенте
Функция ПолучитьКоординатыКлиента(Данные)
	
	Координаты = Новый Структура();
	
#Если МобильныйКлиент Тогда
		
	Координаты = Неопределено;
	СтруктураДанныхАдреса = Новый Структура();
	СтруктураДанныхАдреса.Вставить("Представление", Данные.АдресДоставкиПредставление);
	
	ДанныеАдреса = Новый ДанныеАдреса(СтруктураДанныхАдреса);
	Координаты = ПолучитьМестоположениеПоАдресу(ДанныеАдреса);
 #КонецЕсли
	 
	Возврат Координаты;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеСтатус.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаСтатусаГотовСборкаИДоставка);

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеОсталосьВремениНаДоставку.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Опоздание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтрицательныхЗначений);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНераспределенныеСтатус.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНераспределенные.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаСтатусаГотовСборкаИДоставка);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНераспределенныеОсталосьВремениНаДоставку.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНераспределенные.Опоздание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтрицательныхЗначений);
	
КонецПроцедуры

#КонецОбласти
