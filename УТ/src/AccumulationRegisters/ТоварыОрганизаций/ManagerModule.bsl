#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ТоварыОрганизаций.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.20.26";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Некритичный;
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("eea28b94-ef3f-4da3-84a2-fbf97d166e02");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ТоварыОрганизаций.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заменяет аналитику активов/пассивов с перечисления ""типы налогов"" на справочник ""виды налогов и взносов"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ТоварыОрганизаций.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ТоварыОрганизаций.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.ТоварыОрганизаций";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрганизаций.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|ГДЕ
	|	ТоварыОрганизаций.АналитикаАктивовПассивов ССЫЛКА Перечисление.УдалитьТипыНалогов";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

// Обработчик обновления
// 
// Параметры:
// 	Параметры - См. ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляМногопоточнойОбработки 
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = Метаданные.РегистрыНакопления.ТоварыОрганизаций.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущиеДанные Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ТоварыОрганизаций.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ТекущиеДанные.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыНакопления.ТоварыОрганизаций.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущиеДанные.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для каждого Запись Из НаборЗаписей Цикл
				Запись.АналитикаАктивовПассивов = Перечисления.УдалитьТипыНалогов.СсылкаВидыНалоговВзносовПоТипуНалогов(Запись.АналитикаАктивовПассивов);
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ТекущиеДанные.Регистратор);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
