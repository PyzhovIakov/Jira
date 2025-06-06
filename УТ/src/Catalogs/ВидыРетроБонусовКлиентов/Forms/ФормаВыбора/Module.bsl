//@strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		
		Элементы.Список.ИзменятьСоставСтрок = Ложь;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	УстановитьУсловноеОформление();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Параметры:
//   Команда - КомандаФормы - выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом

// Параметры:
//   Команда - КомандаФормы - выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ИменаПолей = Новый Массив; // Массив из Строка
	ИменаПолей.Добавить(Элементы.СоставТоваров.Имя);
	ИменаПолей.Добавить(Элементы.БазаРасчетаПродаж.Имя);
	ИменаПолей.Добавить(Элементы.ПериодичностьУсловий.Имя);
	РетроБонусыСервер.УстановитьУсловноеОформлениеСпискаВидаБезРасчета(ЭтотОбъект, ИменаПолей);
	
	ИменаПолей = Новый Массив; // Массив из Строка
	ИменаПолей.Добавить(Элементы.ПериодичностьУсловий.Имя);
	РетроБонусыСервер.УстановитьУсловноеОформлениеСпискаВидаПоказательТоваровНеИспользуется(ЭтотОбъект, ИменаПолей);
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Подключаемый продолжить выполнение команды на сервере.
// 
// Параметры:
//  ПараметрыВыполнения - Структура -
//  ДополнительныеПараметры - Структура -
//
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти