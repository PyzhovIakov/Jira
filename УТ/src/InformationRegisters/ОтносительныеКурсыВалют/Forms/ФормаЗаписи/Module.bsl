
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОтносительныеКурсыВалют", ПараметрыЗаписи, Запись);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Запись.БазоваяВалюта = Справочники.Валюты.ПолучитьВалютуПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти