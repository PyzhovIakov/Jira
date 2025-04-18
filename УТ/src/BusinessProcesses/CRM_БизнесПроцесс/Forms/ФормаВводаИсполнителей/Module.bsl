
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КартаМаршрута				= Параметры.КартаМаршрута;
	НомерВерсииКартыМаршрута	= Параметры.НомерВерсииКартыМаршрута;
	
	Если Параметры.СписокИсполнителей.Количество() > 0 Тогда
		Для Каждого ЭлементСписка Из Параметры.СписокИсполнителей Цикл
			СписокИсполнителей.Добавить(ЭлементСписка.Значение, , ЭлементСписка.Пометка);
		КонецЦикла;
	КонецЕсли;
	
	Команда = Команды.Добавить("ПодборВидыИсполнителей");
	Команда.Заголовок	= НСтр("ru='[Виды исполнителей задач]';en='[Виды исполнителей задач]'");
	Команда.Действие	= "Подключаемый_КомандаОбработкаВыбораЭлементаПодбора";
	Команда.Отображение	= ОтображениеКнопки.КартинкаИТекст;
	
	Кнопка = Элементы.Добавить("КнопкаВидыИсполнителей", Тип("КнопкаФормы"), Элементы.СписокИсполнителейГруппаПодбор);
	Кнопка.Заголовок	= НСтр("ru='Виды исполнителей задач';en='Types of executors of tasks'");
	Кнопка.ИмяКоманды	= Команда.Имя;
	
	Команда = Команды.Добавить("ПодборПользователи");
	Команда.Заголовок	= НСтр("ru='[Пользователи]';en='[Пользователи]'");
	Команда.Действие	= "Подключаемый_КомандаОбработкаВыбораЭлементаПодбора";
	Команда.Отображение	= ОтображениеКнопки.КартинкаИТекст;
	
	Кнопка = Элементы.Добавить("КнопкаПользователи", Тип("КнопкаФормы"), Элементы.СписокИсполнителейГруппаПодбор);
	Кнопка.Заголовок	= НСтр("ru='Пользователи';en='Users'");
	Кнопка.ИмяКоманды	= Команда.Имя;
	
	Команда = Команды.Добавить("ПодборРольИсполнителя");
	Команда.Заголовок	= НСтр("ru='[Роль исполнителя]';en='[Role of executor]'");
	Команда.Действие	= "Подключаемый_КомандаОбработкаВыбораЭлементаПодбора";
	Команда.Отображение	= ОтображениеКнопки.КартинкаИТекст;
	
	Кнопка = Элементы.Добавить("КнопкаРольИсполнителя", Тип("КнопкаФормы"), Элементы.СписокИсполнителейГруппаПодбор);
	Кнопка.Заголовок	= НСтр("ru='Роль исполнителя';en='Role of executor'");
	Кнопка.ИмяКоманды	= Команда.Имя;
	
	Команда = Команды.Добавить("ПодборТочкаМаршрута");
	Команда.Заголовок	= НСтр("ru='[Точка маршрута]';en='[Route point]'");
	Команда.Действие	= "Подключаемый_КомандаОбработкаВыбораЭлементаПодбора";
	Команда.Отображение	= ОтображениеКнопки.КартинкаИТекст;
	
	Кнопка = Элементы.Добавить("КнопкаТочкаМаршрута", Тип("КнопкаФормы"), Элементы.СписокИсполнителейГруппаПодбор);
	Кнопка.Заголовок	= НСтр("ru='Точка маршрута';en='Route Point'");
	Кнопка.ИмяКоманды	= Команда.Имя;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбработкаРезультатаВыбора(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокИсполнителей

&НаКлиенте
Процедура СписокИсполнителейЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элемент, , , , ,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИсполнителейПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.СписокИсполнителей.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СписокИсполнителейПометка.ТолькоПросмотр = ПроверитьНаРоль(ТекДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(СписокИсполнителей);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПроверитьНаРоль(Исполнитель)
	
	Возврат НЕ (ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей"));
	
КонецФункции

&НаСервере
Функция ПолучитьСписокДоступныхТочек()
	
	СписокВидов = Новый СписокЗначений;
	СписокВидов.Добавить(Перечисления.CRM_ВидыТочекМаршрута.Действие);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", КартаМаршрута);
	Запрос.УстановитьПараметр("НомерВерсии", НомерВерсииКартыМаршрута);
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_ТочкиМаршрутовВходящиеТочки.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ Точки
	               |ИЗ
	               |	Справочник.CRM_ТочкиМаршрутов.ВходящиеТочки КАК CRM_ТочкиМаршрутовВходящиеТочки
	               |ГДЕ
	               |	CRM_ТочкиМаршрутовВходящиеТочки.Ссылка.Владелец = &Владелец
	               |	И CRM_ТочкиМаршрутовВходящиеТочки.НомерВерсии = &НомерВерсии
	               |	И CRM_ТочкиМаршрутовВходящиеТочки.Ссылка.Вид = ЗНАЧЕНИЕ(Перечисление.CRM_ВидыТочекМаршрута.Действие)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	CRM_ТочкиМаршрутовИсходящиеТочки.Ссылка
	               |ИЗ
	               |	Справочник.CRM_ТочкиМаршрутов.ИсходящиеТочки КАК CRM_ТочкиМаршрутовИсходящиеТочки
	               |ГДЕ
	               |	CRM_ТочкиМаршрутовИсходящиеТочки.Ссылка.Владелец = &Владелец
	               |	И CRM_ТочкиМаршрутовИсходящиеТочки.НомерВерсии = &НомерВерсии
	               |	И CRM_ТочкиМаршрутовИсходящиеТочки.Ссылка.Вид = ЗНАЧЕНИЕ(Перечисление.CRM_ВидыТочекМаршрута.Действие)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Точки.Ссылка КАК Ссылка
	               |ИЗ
	               |	Точки КАК Точки";
				   
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_КомандаОбработкаВыбораЭлементаПодбора(Команда)
	
	ИмяКоманды = Команда.Имя;
	
	Если ИмяКоманды = "ПодборВидыИсполнителей" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",				Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор",		Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Ложь);
		ОткрытьФорму("Перечисление.CRM_ВидыИсполнителейЗадач.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , ,
			 , ,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ИмяКоманды = "ПодборПользователи" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",				Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор",		Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Ложь);
		ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ИмяКоманды = "ПодборРольИсполнителя" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",				Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор",		Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Ложь);
		ОткрытьФорму("Справочник.РолиИсполнителей.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ИмяКоманды = "ПодборТочкаМаршрута" Тогда
		
		СписокТочек = Новый СписокЗначений;
		СписокТочек.ЗагрузитьЗначения(ПолучитьСписокДоступныхТочек());
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",				Истина);
		ПараметрыФормы.Вставить("МножественныйВыбор",		Ложь);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",		Истина);
		ПараметрыФормы.Вставить("Отбор",					Новый Структура("Ссылка,", СписокТочек));
		ОткрытьФорму("Справочник.CRM_ТочкиМаршрутов.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаРезультатаВыбора(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
			Если СписокИсполнителей.НайтиПоЗначению(ЭлементМассива) = Неопределено Тогда
				СписокИсполнителей.Добавить(ЭлементМассива);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если СписокИсполнителей.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			СписокИсполнителей.Добавить(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
