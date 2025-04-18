#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СформироватьГиперссылкиУправленияОтборами(ПолучатьКоличество, ПараметрыОтборов = Неопределено) Экспорт
	
	ОбщаяСтатистика = СтатусыУведомленийПрослеживаемости();
	
	Если ПолучатьКоличество Тогда
		
		ТипыУведомлений = Новый Массив;
		Если ТипЗнч(ПараметрыОтборов) = Тип("Структура") И ПараметрыОтборов.Свойство("ТипУведомлений")
			И ЗначениеЗаполнено(ПараметрыОтборов.ТипУведомлений) Тогда
			ТипыУведомлений.Добавить(ПараметрыОтборов.ТипУведомлений);
		Иначе
			МетаданныеЖурнала = Метаданные.ЖурналыДокументов.ПрослеживаемостьУведомления;
			Для Каждого РегистрируемыйДокумент Из МетаданныеЖурнала.РегистрируемыеДокументы Цикл
				МенеджерДокумента =
					ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(РегистрируемыйДокумент.ПолноеИмя());
				ТипыУведомлений.Добавить(ТипЗнч(МенеджерДокумента.ПустаяСсылка()));
			КонецЦикла;
		КонецЕсли;
		
		Если ТипЗнч(ПараметрыОтборов) = Тип("Структура") И ПараметрыОтборов.Свойство("Организация")
			И ЗначениеЗаполнено(ПараметрыОтборов.Организация) Тогда
			Организации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыОтборов.Организация);
		Иначе
			Организации = Неопределено;
		КонецЕсли;
		
		СтатистикаПоТипам = СтатистикаОтправкиУведомлений(ТипыУведомлений, Организации);
		
		Для Каждого Статистика Из СтатистикаПоТипам Цикл
			Для Каждого Статус Из Статистика.Значение Цикл
				ОбщаяСтатистика[Статус.Ключ] = ОбщаяСтатистика[Статус.Ключ] + Статус.Значение;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	
	// Ожидают отправки
	
	ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'К отправке (%1)'"), ОбщаяСтатистика.ОжидаютОтправки);
	ДобавитьГиперссылкуВСписок(МассивСтрок, ТекстГиперссылки, "ОжидаютОтправки");
	
	
	// Архив
	
	ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Архив (%1)'"), ОбщаяСтатистика.Завершены);
	ДобавитьГиперссылкуВСписок(МассивСтрок, ТекстГиперссылки, "Завершены");
	
	// Все
	
	ТекстГиперссылки = НСтр("ru = 'Все'");
	ДобавитьГиперссылкуВСписок(МассивСтрок, ТекстГиперссылки, "Все");
	
	Если МассивСтрок.Количество() > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает статистику отправки уведомлений прослеживаемости
// 
// Параметры:
//  ТипыУведомлений - Массив из Тип - отбор по типу уведомлений, если пустой, то возвращает статистику для всех типов уведомлений
//  Организации - Массив из СправочникСсылка.Организации - если пустой, то возвращает статистику по всем организациям
// 
// Возвращаемое значение:
//  Соответствие - Статистика отправки уведомлений
//
Функция СтатистикаОтправкиУведомлений(ТипыУведомлений, Организации = Неопределено) Экспорт
	
	Статистика = Новый Соответствие;
	Для Каждого ТипУведомления Из ТипыУведомлений Цикл
		Статистика.Вставить(ТипУведомления, СтатусыУведомленийПрослеживаемости());
	КонецЦикла;
	
	Если Организации = Неопределено Тогда
		Организации = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипыУведомлений",    ТипыУведомлений);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организации));
	Запрос.УстановитьПараметр("Организации",        Организации);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Уведомление.Тип КАК ТипУведомлений,
	|	ВЫБОР
	|		КОГДА Уведомление.РНПТ ЕСТЬ NULL ТОГДА ЛОЖЬ
	|		КОГДА Уведомление.РНПТ = """" ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПолученРНПТ,
	|	КОЛИЧЕСТВО(Уведомление.Ссылка) КАК Количество
	|ИЗ
	|	ЖурналДокументов.ПрослеживаемостьУведомления КАК Уведомление
	|ГДЕ
	|	Уведомление.Проведен
	|	И Уведомление.Тип В (&ТипыУведомлений)
	|	И (&ПоВсемОрганизациям
	|		ИЛИ Уведомление.Организация В (&Организации))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА Уведомление.РНПТ ЕСТЬ NULL ТОГДА ЛОЖЬ
	|		КОГДА Уведомление.РНПТ = """" ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	Уведомление.Тип";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ТипУведомлений") Цикл
		
		СтатусыУведомлений = Статистика[Выборка.ТипУведомлений];
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.ПолученРНПТ Тогда
				СтатусыУведомлений.Завершены = СтатусыУведомлений.Завершены + Выборка.Количество;
			ИначеЕсли ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
				СтатусыУведомлений.ОжидаютОтправки = СтатусыУведомлений.ОжидаютОтправки + Выборка.Количество;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Статистика;
	
КонецФункции

Функция СформироватьГиперссылкиКОформлению(ПолучатьКоличество, Организация = Неопределено) Экспорт
	
	МассивСтрок = Новый Массив;
	
	Если ПолучатьКоличество Тогда
		КоличестваКОформлению =
			УчетПрослеживаемыхТоваровЛокализация.КоличествоРаспоряженийКОформлениюУведомлений(
				Неопределено, ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Иначе
		КоличестваКОформлению = Новый Соответствие;
		КоличестваКОформлению.Вставить(Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров"), 0);
		КоличестваКОформлению.Вставить(Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров"), 0);
		КоличестваКОформлению.Вставить(Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров"), 0);
	КонецЕсли;
	
	// Уведомления об остатках
	
	ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Уведомления об остатках (%1)'"),
		КоличестваКОформлению[Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров")]);
	
	ДобавитьГиперссылкуВСписок(МассивСтрок, ТекстГиперссылки, "УведомленияОбОстатках");
	
	// Уведомления о ввозе/перемещении
	
	ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Уведомления о ввозе и перемещении (вывозе) (%1)'"),
		КоличестваКОформлению[Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров")]
			+ КоличестваКОформлению[Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров")]);
	
	ДобавитьГиперссылкуВСписок(МассивСтрок, ТекстГиперссылки, "УведомленияОПеремещениях");
	
	Если МассивСтрок.Количество() > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает пустую структуру статусов отправки уведомлений
//
Функция СтатусыУведомленийПрослеживаемости()
	
	СтатусыУведомлений = Новый Структура;
	СтатусыУведомлений.Вставить("ОжидаютОтправки",  0);
	СтатусыУведомлений.Вставить("ОжидаютПолучения", 0);
	СтатусыУведомлений.Вставить("Завершены", 0);
	
	Возврат СтатусыУведомлений;
	
КонецФункции

Процедура ДобавитьГиперссылкуВСписок(МассивСтрок, Текст, Гиперссылка)
	
	Если ЗначениеЗаполнено(МассивСтрок) Тогда
		МассивСтрок.Добавить("  ");
	КонецЕсли;
	
	МассивСтрок.Добавить(
		Новый ФорматированнаяСтрока(Текст, , , , Гиперссылка));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли