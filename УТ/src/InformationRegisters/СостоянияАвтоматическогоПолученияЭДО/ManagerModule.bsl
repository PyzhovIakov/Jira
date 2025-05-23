// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ИдентификаторЭДО - Строка
//  ЕстьОшибки - Булево
//  ДатаНачала - Дата
//  ДатаОкончания - Дата
// 
// Возвращаемое значение:
//  См. НовоеСостояниеПолучения
Функция Записать(ИдентификаторЭДО, ЕстьОшибки, ДатаНачала, ДатаОкончания = '00010101') Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторЭДО);
	
	Если ЕстьОшибки Тогда
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() Тогда
			ЗаписьНабора = НаборЗаписей[0];
		Иначе
			ЗаписьНабора = НаборЗаписей.Добавить();
		КонецЕсли;
		ЗаписьНабора.НомерПопытки = ЗаписьНабора.НомерПопытки + 1;
	Иначе
		ЗаписьНабора = НаборЗаписей.Добавить();
	КонецЕсли;
	
	ЗаписьНабора.ИдентификаторЭДО = ИдентификаторЭДО;
	ЗаписьНабора.ДатаНачала = ДатаНачала;
	ЗаписьНабора.ДатаОкончания = ?(ЗначениеЗаполнено(ДатаОкончания), ДатаОкончания, ТекущаяДатаСеанса());
	ЗаписьНабора.ЕстьОшибки = ЕстьОшибки;
	
	Если ЕстьОшибки И ЗаписьНабора.НомерПопытки >= 3 Тогда
		ЗаписьНабора.Остановлено = Истина;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
	Состояние = НовоеСостояниеПолучения();
	ЗаполнитьЗначенияСвойств(Состояние, ЗаписьНабора);
	
	Возврат Состояние;
	
КонецФункции

// Параметры:
//  ИдентификаторЭДО - Строка
Процедура Удалить(ИдентификаторЭДО) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторЭДО);
	НаборЗаписей.Записать();
КонецПроцедуры

// Параметры:
//  ИдентификаторыЭДО - Неопределено,Массив из Строка
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//  * Ключ - Строка
//  * Значение - См. НовоеСостояниеПолучения
Функция СостояниеПоИдентификаторамЭДО(ИдентификаторыЭДО = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СостоянияАвтоматическогоПолученияЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
		|	СостоянияАвтоматическогоПолученияЭДО.ЕстьОшибки КАК ЕстьОшибки,
		|	СостоянияАвтоматическогоПолученияЭДО.Остановлено КАК Остановлено
		|ИЗ
		|	РегистрСведений.СостоянияАвтоматическогоПолученияЭДО КАК СостоянияАвтоматическогоПолученияЭДО
		|ГДЕ
		|	&УсловиеПоИдентификаторамЭДО";
	
	Если ИдентификаторыЭДО = Неопределено Тогда
		Запрос.УстановитьПараметр("УсловиеПоИдентификаторамЭДО", Истина);
	Иначе
		УсловиеПоИдентификаторамЭДО = "СостоянияАвтоматическогоПолученияЭДО.ИдентификаторЭДО В (&ИдентификаторыЭДО)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоИдентификаторамЭДО", УсловиеПоИдентификаторамЭДО);
		Запрос.УстановитьПараметр("ИдентификаторыЭДО", ИдентификаторыЭДО);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Состояние = НовоеСостояниеПолучения();
		Состояние.ЕстьОшибки = Выборка.ЕстьОшибки;
		Состояние.Остановлено = Выборка.Остановлено;
		Результат.Вставить(Выборка.ИдентификаторЭДО, Состояние);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ИдентификаторЭДО - Строка
// 
// Возвращаемое значение:
//  - Неопределено,Произвольный
//  - См. НовоеСостояниеПолучения
Функция СостояниеПоИдентификаторуЭДО(ИдентификаторЭДО) Экспорт
	
	ИдентификаторыЭДО = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторЭДО);
	СостояниеПоИдентификаторамЭДО = СостояниеПоИдентификаторамЭДО(ИдентификаторыЭДО);
	Возврат СостояниеПоИдентификаторамЭДО[ИдентификаторЭДО];
	
КонецФункции

// Параметры:
//  ИдентификаторЭДО - Строка
// 
// Возвращаемое значение:
//  Неопределено,Структура:
//  * ДатаНачала - Дата
//  * ДатаОкончания - Дата
Функция ПериодПолученияПоИдентификаторуЭДО(ИдентификаторЭДО) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СостоянияАвтоматическогоПолученияЭДО.ДатаНачала,
		|	СостоянияАвтоматическогоПолученияЭДО.ДатаОкончания
		|ИЗ
		|	РегистрСведений.СостоянияАвтоматическогоПолученияЭДО КАК СостоянияАвтоматическогоПолученияЭДО
		|ГДЕ
		|	СостоянияАвтоматическогоПолученияЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторЭДО);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Период = Новый Структура;
		Период.Вставить("ДатаНачала", Выборка.ДатаНачала);
		Период.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
		Возврат Период;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Возвращаемое значение:
//  Структура:
// * ЕстьОшибки - Булево
// * Остановлено - Булево
Функция НовоеСостояниеПолучения() Экспорт
	Состояние = Новый Структура;
	Состояние.Вставить("ЕстьОшибки", Ложь);
	Состояние.Вставить("Остановлено", Ложь);
	Возврат Состояние;
КонецФункции

// Параметры:
//  ИдентификаторЭДО - Строка
Процедура УстановитьПризнакОстановки(ИдентификаторЭДО) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторЭДО);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() Тогда
		ЗаписьНабора = НаборЗаписей[0];
	Иначе
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ИдентификаторЭДО = ИдентификаторЭДО;
	КонецЕсли;
	Если ЗаписьНабора.Остановлено Тогда
		Возврат;
	КонецЕсли;
	ЗаписьНабора.Остановлено = Истина;
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	ЗаписьНабора.ДатаНачала = ТекущаяДатаСеанса;
	ЗаписьНабора.ДатаОкончания = ТекущаяДатаСеанса;
	НаборЗаписей.Записать();
КонецПроцедуры

// Параметры:
//  СосотоянияДоПолучения - см. СостояниеПоИдентификаторамЭДО
//  СостоянияПослеПолучения - см. СостояниеПоИдентификаторамЭДО
// 
// Возвращаемое значение:
//  См. СостояниеПоИдентификаторамЭДО
Функция ИзмененныеСостоянияПоИдентификаторамЭДО(СосотоянияДоПолучения, СостоянияПослеПолучения) Экспорт
	
	Результат = Новый Соответствие;
	
	Для Каждого СостояниеПоИдентификаторуЭДОПослеПолучения Из СостоянияПослеПолучения Цикл
		
		ИдентификаторЭДО = СостояниеПоИдентификаторуЭДОПослеПолучения.Ключ;
		СостояниеПослеПолучения = СостояниеПоИдентификаторуЭДОПослеПолучения.Значение;
		
		СостояниеДоПолучения = СосотоянияДоПолучения[ИдентификаторЭДО];
		Если СостояниеДоПолучения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьИзменения = Ложь;
		Для Каждого Свойство Из СостояниеПослеПолучения Цикл
			Если СостояниеДоПолучения[Свойство.Ключ] <> Свойство.Значение Тогда
				ЕстьИзменения = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьИзменения Тогда
			Результат.Вставить(ИдентификаторЭДО, СостояниеПослеПолучения);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
