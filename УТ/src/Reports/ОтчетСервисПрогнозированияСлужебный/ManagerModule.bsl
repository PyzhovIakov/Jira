#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задает расширенные настройки отчета
//
// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ОтчетСервисПрогнозированияСлужебный);
	ОписаниеОтчета.ВидимостьПоУмолчанию = Ложь;
	ОписаниеОтчета.Описание = НСтр("ru= 'Просмотр и управление прогнозами продаж, полученными из сервиса прогнозирования.'");
	ОписаниеОтчета.Размещение.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "Форма" Тогда
		ВыбраннаяФорма = "Обработка.ПанельУправленияСервисомПрогнозирования.Форма.ПланированиеИПрогнозированиеПродажФормаОтчета";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли