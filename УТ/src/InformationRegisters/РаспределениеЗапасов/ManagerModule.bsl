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
	|	ЗначениеРазрешено(Склад)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.РаспределениеЗапасов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.21.76";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("d05af858-ca38-4f1b-a9fc-ae8050472af0");
	Обработчик.Многопоточный = Истина;
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Некритичный;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.РаспределениеЗапасов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Синхронизирует записи регистра сведений ""Распределение запасов"" с остатками в регистре накопления ""Запасы и потребности""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.РаспределениеЗапасов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ЗапасыИПотребности.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.РаспределениеЗапасов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ЗапасыИПотребности.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Вынести из тегов при появляении первого обработчика для УТ.
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.РаспределениеЗапасов";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.РаспределениеЗапасов");
	
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.РаспределениеЗапасов";
	
	Если Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "РегистрНакопления.ЗапасыИПотребности") Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;

	ТаблицаОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Для Каждого Строка Из ТаблицаОбновляемыеДанные Цикл
		
		Набор = Неопределено;
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных();
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РаспределениеЗапасов");
			ЭлементБлокировки.УстановитьЗначение("Номенклатура", Строка.Номенклатура);
			ЭлементБлокировки.УстановитьЗначение("Характеристика", Строка.Характеристика);
			ЭлементБлокировки.УстановитьЗначение("Склад", Строка.Склад);
			ЭлементБлокировки.УстановитьЗначение("Назначение", Строка.Назначение);
			
			Блокировка.Заблокировать();
			
			Набор = РаспределениеЗапасов.ОбновлениеИБПоТовару(Строка);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			Если Набор = Неопределено Тогда
				Набор = СоздатьНаборЗаписей();
				Набор.Отбор.Номенклатура.Установить(Строка.Номенклатура);
				Набор.Отбор.Характеристика.Установить(Строка.Характеристика);
				Набор.Отбор.Склад.Установить(Строка.Склад);
				Набор.Отбор.Назначение.Установить(Строка.Назначение);
			КонецЕсли;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Набор);
		КонецПопытки;
		
	КонецЦикла;
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
