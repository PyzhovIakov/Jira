#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа
//
// Параметры:
//  Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ЭлектронныйДокумент)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ЭлектронныйДокумент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияДокументовЭДО;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ЭлектронныйДокумент = Неопределено;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("ЭлектронныйДокумент");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("ЭлектронныйДокумент");

	Запрос = Новый Запрос;
		Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияДокументовЭДО.ЭлектронныйДокумент КАК ЭлектронныйДокумент
	|ИЗ
	|	РегистрСведений.СостоянияДокументовЭДО КАК СостоянияДокументовЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СообщениеЭДО КАК СообщениеЭДО
	|		ПО СостоянияДокументовЭДО.ЭлектронныйДокумент = СообщениеЭДО.ЭлектронныйДокумент
	// Не верное состояние ЭДО при отклонении по регламенту 14н.
	|			И (СостоянияДокументовЭДО.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению)
	|					И СообщениеЭДО.ТипЭлементаРегламента = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ_ПДП)
	// Неактуальное состояние ЭДО после отмены ИОП на УОУ
	|				ИЛИ СостоянияДокументовЭДО.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению)
	|					И СообщениеЭДО.ТипЭлементаРегламента = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ))
	|ГДЕ
	|	(&ЭлектронныйДокумент = НЕОПРЕДЕЛЕНО
	|			ИЛИ СостоянияДокументовЭДО.ЭлектронныйДокумент > &ЭлектронныйДокумент)
	// Не верное состояние ЭДО при отклонении по регламенту 14н.
	|			И (СостоянияДокументовЭДО.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению)
	|					И СообщениеЭДО.ТипЭлементаРегламента = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ_ПДП)
	// Неактуальное состояние ЭДО после отмены ИОП на УОУ
	|				ИЛИ СостоянияДокументовЭДО.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению)
	|					И СообщениеЭДО.ТипЭлементаРегламента = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовРегламентаЭДО.УОУ))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭлектронныйДокумент";
	
	ОтработаныВсеДанные = Ложь;
	
	Пока Не ОтработаныВсеДанные Цикл
		
		Запрос.УстановитьПараметр("ЭлектронныйДокумент", ЭлектронныйДокумент);
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		КоличествоСтрок = Выгрузка.Количество();
		
		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			ЭлектронныйДокумент = Выгрузка[КоличествоСтрок - 1].ЭлектронныйДокумент;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры


// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияДокументовЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	МассивПроверяемыхОбъектов = Новый Массив;
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументВходящийЭДО");
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументИсходящийЭДО");

	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, МассивПроверяемыхОбъектов) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ДанныеДляОбновления = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ДанныеДляОбновления.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из ДанныеДляОбновления Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("ЭлектронныйДокумент", СтрокаДанных.ЭлектронныйДокумент);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Набор = РегистрыСведений.СостоянияДокументовЭДО.СоздатьНаборЗаписей();
			Набор.Отбор.ЭлектронныйДокумент.Установить(СтрокаДанных.ЭлектронныйДокумент);
			Набор.Прочитать();
			
			ОбработатьДанные_ЗаменитьСостояниеОжидаетсяИзвещениеПоОтклонению(Набор, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов 
		+ ДанныеДляОбновления.Количество();
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращаемое значение:
//  Структура:
//  * СостояниеДополнение - Строка
//  * ДатаИзменения - Дата
//  * Комментарий - Строка
//  * ИдентификаторДокумента - Строка
//  * ИдентификаторОрганизации - Строка
Функция НовыеДополнительныеПараметрыУстановкиСостояния() Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("СостояниеДополнение", "");
	Параметры.Вставить("ДатаИзменения", '00010101');
	Параметры.Вставить("Комментарий", "");
	Параметры.Вставить("ИдентификаторДокумента", "");
	Параметры.Вставить("ИдентификаторОрганизации", "");
	Возврат Параметры;
КонецФункции

// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//  ДополнительныеПараметры - См. НовыеДополнительныеПараметрыУстановкиСостояния
Процедура УстановитьСостояние(ЭлектронныйДокумент, Состояние, ДополнительныеПараметры = Неопределено) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЭлектронныйДокумент.Установить(ЭлектронныйДокумент);
	ЗаписьНабора = НаборЗаписей.Добавить();
	ЗаписьНабора.ЭлектронныйДокумент = ЭлектронныйДокумент;
	ЗаписьНабора.Состояние = Состояние;
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаписьНабора.СостояниеДополнение = ДополнительныеПараметры.СостояниеДополнение;
		ЗаписьНабора.ДатаИзменения = ?(ЗначениеЗаполнено(ДополнительныеПараметры.ДатаИзменения),
			ДополнительныеПараметры.ДатаИзменения, ТекущаяДатаСеанса());
		ЗаписьНабора.Комментарий = ДополнительныеПараметры.Комментарий;
		Если ЗначениеЗаполнено(ДополнительныеПараметры.ИдентификаторОрганизации)
			И ЗначениеЗаполнено(ДополнительныеПараметры.ИдентификаторДокумента) Тогда
			СвойстваДокумента = Новый Структура("ИдентификаторОрганизации, ИдентификаторДокумента",
				ДополнительныеПараметры.ИдентификаторОрганизации, ДополнительныеПараметры.ИдентификаторДокумента);
			НаборЗаписей.ДополнительныеСвойства.Вставить("СвойстваДокумента", СвойстваДокумента);
		КонецЕсли;
	КонецЕсли;
	НаборЗаписей.Записать();
КонецПроцедуры

// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
// 
// Возвращаемое значение:
//  См. НовоеСостояниеДокументаПолное
Функция СостояниеДокументаПолное(ЭлектронныйДокумент) Экспорт
	
	ОписаниеСостояния = НовоеСостояниеДокументаПолное();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СостоянияДокументовЭДО.Состояние КАК Состояние,
		|	СостоянияДокументовЭДО.СостояниеДополнение КАК Дополнение,
		|	СостоянияДокументовЭДО.ДатаИзменения КАК ДатаИзменения,
		|	СостоянияДокументовЭДО.Комментарий КАК Комментарий
		|ИЗ
		|	РегистрСведений.СостоянияДокументовЭДО КАК СостоянияДокументовЭДО
		|ГДЕ
		|	СостоянияДокументовЭДО.ЭлектронныйДокумент = &ЭлектронныйДокумент";
	Запрос.УстановитьПараметр("ЭлектронныйДокумент", ЭлектронныйДокумент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ОписаниеСостояния, Выборка);
	КонецЕсли;
	
	Возврат ОписаниеСостояния;
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//  * Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//  * Дополнение - Строка
//  * ДатаИзменения - Дата
//  * Комментарий - Строка
Функция НовоеСостояниеДокументаПолное() Экспорт
	ОписаниеСостояния = Новый Структура;
	ОписаниеСостояния.Вставить("Состояние", Перечисления.СостоянияДокументовЭДО.ПустаяСсылка());
	ОписаниеСостояния.Вставить("Дополнение", "");
	ОписаниеСостояния.Вставить("ДатаИзменения", '00010101');
	ОписаниеСостояния.Вставить("Комментарий", "");
	Возврат ОписаниеСостояния;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДанные_ЗаменитьСостояниеОжидаетсяИзвещениеПоОтклонению(Набор, Записать) 
	
	Для Каждого Запись Из Набор Цикл
		
		Если Запись.Состояние <> Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеПоОтклонению Тогда
			Продолжить;
		КонецЕсли;
		
		Запись.Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		
		Записать = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли