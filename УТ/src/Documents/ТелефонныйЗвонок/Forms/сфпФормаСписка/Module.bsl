
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		ПараметрыРазмещения = МодульПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = Неопределено;
		ПараметрыРазмещения.ПрефиксГрупп = "";
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// +CRM
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступом");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ОграничитьВыводКлиентскойБазы(ЭтотОбъект, "Список");
	КонецЕсли;
	
	сфпЗаполнитьСостоянияЗвонков();
	
	CRM_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ТекОтбор = Список.Отбор.Элементы;
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "Входящий", Истина, "Входящие");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "Входящий", Ложь, "Исходящие");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "сфпСостояниеЗвонка",
		 Перечисления.сфпСостоянияЗвонков.Пропущенный,
		 "Пропущенные");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "АбонентКонтакт",
		 Справочники.Пользователи.ПустаяСсылка(),
		 "ОтборПоКлиенту");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "Ответственный_Роль",
		 Справочники.Пользователи.ПустаяСсылка(),
		 "ОтборПоОтветственному");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "Автор", Справочники.Пользователи.ПустаяСсылка(), "ОтборПоАвтору");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "АбонентВладелец", Справочники.Партнеры.ПустаяСсылка(), "ОтборПоВладельцу");
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "Ответственный",
		 Справочники.Пользователи.ПустаяСсылка(), "ОтборПоПользователям",
		 ВидСравненияКомпоновкиДанных.ВСписке);
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "сфпДлительностьЗвонка", Ложь, "ОтборПоДлительности",
		 ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	
	ГруппаОтбора = СоздатьГруппуЭлементовОтбора(ТекОтбор, "Отвеченные",
		 ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли,
		 Ложь);
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "сфпСостояниеЗвонка",
		 Перечисления.сфпСостоянияЗвонков.Отвеченный, "Отвеченный", , ГруппаОтбора,
		 Истина);
	УстановитьЭлементОтбораКоллекции(ТекОтбор, "сфпСостояниеЗвонка",
		 Перечисления.сфпСостоянияЗвонков.ПустаяСсылка(), "Не заполнено", , ГруппаОтбора,
		 Истина);
	
	ПользовательАдминистратор = (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("сфпУправлениеМаршрутизацией"));
	Элементы.сфпНецелевойЗвонок.Видимость = ПользовательАдминистратор;
	Элементы.ПравилаОбработки.Доступность = ПользовательАдминистратор;
		
	Если НЕ ПользовательАдминистратор Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			 "сфпНецелевойЗвонок", Ложь, ВидСравненияКомпоновкиДанных.Равно, ,
			 Истина);
	КонецЕсли;
	
	Если сфпСофтФонПроСервер.сфпИспользоватьОграничениеПоказаТелефонныхЗвонков() Тогда
		// Прежде, чем показать весь список, мы должны выяснить, телефонные звонки каких пользователей нам доступны
		ТекПользователь = сфпСофтФонПроСервер.сфпТекущийПользователь();
		МассивПрослушиваемыхПользователей = сфпСофтФонПроСервер.сфпПолучитьМассивПрослушиваемыхПользователей(ТекПользователь);
		ОтборПоПользователям =
			сфпСофтФонПроСервер.сфпПреобразоватьМассивЗвонящихВСписокЗначений(МассивПрослушиваемыхПользователей);
		
	Иначе
		ОтборПоПользователям = Новый СписокЗначений();
	КонецЕсли;
	
	Если Параметры.Свойство("РежимВыбора") Тогда
		Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборПоОтветственному") Тогда
		ОтборПоОтветственному = Параметры.ОтборПоОтветственному;
	КонецЕсли;
	
	ОбрабатыватьОбращения = Константы.сфпНастройкиТелефонии_ПрименитьПравилаОбработки.Получить();
	Если Не (ОбрабатыватьОбращения <> Неопределено И ОбрабатыватьОбращения) Тогда
		Элементы.ПравилаОбработки.Видимость = Ложь;
	КонецЕсли;
	// -CRM
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Элементы.ОтборПоДлительности.СписокВыбора.НайтиПоЗначению(ОтборПоДлительности) = Неопределено Тогда
		НовыйЭлемент				= Элементы.ОтборПоДлительности.СписокВыбора.Добавить();
		НовыйЭлемент.Значение		= ОтборПоДлительности;
		НовыйЭлемент.Представление	= Строка(ОтборПоДлительности);
		Элементы.ОтборПоДлительности.СписокВыбора.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	КонецЕсли;
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостоянияЗвонковПриАктивизацииСтроки(Элемент)
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры // СостоянияЗвонковПриАктивизацииСтроки()

&НаКлиенте
Процедура ОтборПоКлиентуПриИзменении(Элемент)
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры // ОтборПоКлиентуПриИзменении()

&НаКлиенте
Процедура ОтборПоКлиентуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ОтборПоВладельцу) Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", ОтборПоВладельцу));
		ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.ФормаВыбора", ПараметрыФормы, Элементы.ОтборПоКлиенту);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоОтветственномуПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОтборПоОтветственному) Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный_Роль",
			 ОтборПоОтветственному,
			 Истина);
	Иначе	
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный_Роль");
	КонецЕсли;
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры // ОтборПоОтветственномуПриИзменении()

&НаКлиенте
Процедура ОтборПоАвторуПриИзменении(Элемент)
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры // ОтборПоАвторуПриИзменении()

&НаКлиенте
Процедура ОтборПоДлительностиПриИзменении(Элемент)
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры // ОтборПоДлительностиПриИзменении()

&НаКлиенте
Процедура ОтборПоДлительностиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора,
	 ПараметрыПолученияДанных,
	 СтандартнаяОбработка)
	СтандартнаяОбработка	= Ложь;
	Попытка
		ВвведенноеЧисло	= Число(Текст);
	Исключение
		ВвведенноеЧисло	= ОтборПоДлительности;
	КонецПопытки;
	СписокВыбора = Элемент.СписокВыбора;
	Если Элемент.СписокВыбора.НайтиПоЗначению(ВвведенноеЧисло) = Неопределено Тогда
		НовыйЭлемент				= Элемент.СписокВыбора.Добавить();
		НовыйЭлемент.Значение		= ВвведенноеЧисло;
		НовыйЭлемент.Представление	= Текст;
		Элемент.СписокВыбора.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	КонецЕсли;	
	ОтборПоДлительности	= ВвведенноеЧисло;
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВладельцуПриИзменении(Элемент)
	сфпУстановитьТекущиеОтборы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Взамодействия.ТелефонныйЗвонок.ДлительностьСценариев.ВремяОткрытияФормы", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры // СписокПередНачаломДобавления()

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры // СписокПередУдалением()

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура сфпЗагрузитьИсториюЗвонков(Команда)
	Если НЕ сфпСофтФонПроСервер.сфпРолиДоступны("ПолныеПрава, сфпУправлениеМаршрутизацией") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недостаточно прав для загрузки истории звонков!';
			|en='Insufficient rights to download call history!'"));
		Возврат;
	КонецЕсли;
	сфпСофтФонПроСервер.сфпПолучитьИсториюЗвонков();
	Оповестить("ПолученаИсторияЗвонков");
	Элементы.Список.Обновить();
КонецПроцедуры // сфпЗагрузитьИсториюЗвонков()

&НаКлиенте
Процедура сфпРучнаяЗагрузкаЗвонков(Команда)
	Если НЕ сфпСофтФонПроСервер.сфпРолиДоступны("ПолныеПрава, сфпУправлениеМаршрутизацией") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недостаточно прав для ручной загрузки звонков!';
			|en='Insufficient rights to manually download call!'"));
		Возврат;
	КонецЕсли;
	ОповещениеЗавершения = Новый ОписаниеОповещения("РучнаяЗагрузкаЗвонковЗавершение", ЭтотОбъект, Новый Структура);
	ОткрытьФорму("Обработка.сфпРучнаяЗагрузкаЗвонков.Форма", , ЭтотОбъект, , , , ОповещениеЗавершения,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РучнаяЗагрузкаЗвонковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаОбработки(Команда)
	
	ОткрытьФорму("Документ.ТелефонныйЗвонок.Форма.CRM_ФормаНастройкиПравилОбработки", , , , , , ,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура заполняет дерево состояний звонков.
//
// Параметры:
//	Нет.
//
Процедура сфпЗаполнитьСостоянияЗвонков()
	ДеревоСостояний	= СостоянияЗвонков.ПолучитьЭлементы();
	ДеревоСостояний.Очистить();
	НоваяСтрока	= ДеревоСостояний.Добавить();
	НоваяСтрока.Состояние		= НСтр("ru='Все';en='All'");
	НоваяСтрока.ИндексКартинки	= 3;
	НоваяСтрока.Входящий		= Ложь;
	Входящие	= ДеревоСостояний.Добавить();
	Входящие.Состояние		= НСтр("ru='Входящие';en='Incoming'");
	Входящие.ИндексКартинки	= 0;
	НоваяСтрока.Входящий	= Истина;
	ВходящиеЭлементы	= Входящие.ПолучитьЭлементы();
	НоваяСтрока	= ВходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние		= НСтр("ru='Отвеченные';en='Answered'");
	НоваяСтрока.ИндексКартинки	= 3;
	НоваяСтрока.Входящий		= Истина;
	НоваяСтрока = ВходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние		= НСтр("ru='Пропущенные';en='The pass'");
	НоваяСтрока.ИндексКартинки	= 3;
	НоваяСтрока.Входящий		= Истина;
	Исходящие = ДеревоСостояний.Добавить();
	Исходящие.Состояние			= НСтр("ru='Исходящие';en='Outgoing'");
	Исходящие.ИндексКартинки	= 1;
	НоваяСтрока.Входящий		= Ложь;
	ИсходящиеЭлементы	= Исходящие.ПолучитьЭлементы();
	НоваяСтрока	= ИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние		= НСтр("ru='Отвеченные';en='Answered'");
	НоваяСтрока.ИндексКартинки	= 3;
	НоваяСтрока.Входящий		= Ложь;
	НоваяСтрока	= ИсходящиеЭлементы.Добавить();
	НоваяСтрока.Состояние		= НСтр("ru='Не дозвонились';en='Not reached'");
	НоваяСтрока.ИндексКартинки	= 3;
	НоваяСтрока.Входящий		= Ложь;
КонецПроцедуры // сфпЗаполнитьСостоянияЗвонков()

&НаКлиенте
// Процедура устанавливает текущие отборы.
//
// Параметры:
//	Нет.
//
Процедура сфпУстановитьТекущиеОтборы()
	ТД =  Элементы.СостоянияЗвонков.ТекущиеДанные;
	// Устанавливаем новые отборы.
	ЭлементыСпискаОтбора = Список.Отбор.Элементы;
	Для Каждого ТекущийОтбор Из ЭлементыСпискаОтбора Цикл
		Если ТекущийОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
			Если ТекущийОтбор.Представление = "Входящие" Тогда
				Если ТД = Неопределено Тогда
					ТекущийОтбор.Использование	= Ложь;
				ИначеЕсли ТД.Состояние = НСтр("ru='Входящие';en='Incoming'") Тогда
					ТекущийОтбор.Использование	= Истина;
				ИначеЕсли ТД.Состояние = НСтр("ru='Отвеченные';en='Answered'") Тогда
					ТекущийОтбор.Использование	= ТД.Входящий;
				ИначеЕсли ТД.Состояние = НСтр("ru='Пропущенные';en='The pass'") Тогда
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "Исходящие" Тогда
				Если ТД = Неопределено Тогда
					ТекущийОтбор.Использование	= Ложь;
				ИначеЕсли ТД.Состояние = НСтр("ru='Исходящие';en='Outgoing'") Тогда
					ТекущийОтбор.Использование	= Истина;
				ИначеЕсли ТД.Состояние = НСтр("ru='Отвеченные';en='Answered'") Тогда
					ТекущийОтбор.Использование	= НЕ ТД.Входящий;
				ИначеЕсли ТД.Состояние = НСтр("ru='Не дозвонились';en='Not reached'") Тогда
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "Отвеченные" Тогда
				Если ТД = Неопределено Тогда
					ТекущийОтбор.Использование	= Ложь;
				ИначеЕсли ТД.Состояние = НСтр("ru='Отвеченные';en='Answered'") Тогда
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "Пропущенные" Тогда
				Если ТД = Неопределено Тогда
					ТекущийОтбор.Использование	= Ложь;
				ИначеЕсли ТД.Состояние = НСтр("ru='Пропущенные';en='The pass'") Тогда
					ТекущийОтбор.Использование	= Истина;
				ИначеЕсли ТД.Состояние = НСтр("ru='Не дозвонились';en='Not reached'") Тогда
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоКлиенту" Тогда
				Если ЗначениеЗаполнено(ОтборПоКлиенту) Тогда
					ТекущийОтбор.ПравоеЗначение	= ОтборПоКлиенту;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоВладельцу" Тогда
				Если ЗначениеЗаполнено(ОтборПоВладельцу) Тогда
					ТекущийОтбор.ПравоеЗначение	= ОтборПоВладельцу;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоОтветственному" Тогда
				Если ЗначениеЗаполнено(ОтборПоОтветственному) Тогда
					ТекущийОтбор.ПравоеЗначение	= ОтборПоОтветственному;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоАвтору" Тогда
				Если ЗначениеЗаполнено(ОтборПоАвтору) Тогда
					ТекущийОтбор.ПравоеЗначение	= ОтборПоАвтору;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоДлительности" Тогда
				Если ОтборПоДлительности > 0  Тогда
					ТекущийОтбор.ПравоеЗначение	= Дата('00010101') + ОтборПоДлительности;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоПользователям" Тогда
				Если ОтборПоПользователям.Количество() > 0 Тогда
					ТекущийОтбор.ПравоеЗначение	= ОтборПоПользователям;
					ТекущийОтбор.Использование	= Истина;
				Иначе
					ТекущийОтбор.Использование	= Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // сфпУстановитьТекущиеОтборы()

&НаСервере
Функция СоздатьГруппуЭлементовОтбора(Знач КоллекцияЭлементов, Представление, ТипГруппы, Использование)
	
	ГруппаЭлементовОтбора = КоллекцияЭлементов.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Представление = Представление;
	ГруппаЭлементовОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Элементы;
	ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаЭлементовОтбора.ТипГруппы = ТипГруппы;
	ГруппаЭлементовОтбора.Использование = Использование;
	
	Возврат ГруппаЭлементовОтбора;
	
КонецФункции

&НаСервере
Процедура УстановитьЭлементОтбораКоллекции(КоллекцияЭлементов, ЛевоеЗначение, ПравоеЗначение,
	 Представление, ВидСравнения = Неопределено, Родитель = Неопределено,
	 Использование = Ложь)
	
	Если Родитель = Неопределено Тогда
		ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));

	Иначе
		ЭлементОтбора = Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ЛевоеЗначение);
	ЭлементОтбора.ВидСравнения = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование = Использование;
	ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Представление = Представление;
	
КонецПроцедуры // УстановитьЭлементОтбораКоллекции()

#КонецОбласти
