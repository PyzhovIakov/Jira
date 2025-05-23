// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ТранспортноеСредство",, Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура МаркаПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Тип) Тогда
		Возврат;
	КонецЕсли;
	
	ТипПриИзмененииСервер(Объект.Тип);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Параметры:
//   Команда - КомандаФормы - выполняемая команда
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура СформироватьНаименование()
	
	Объект.Наименование = СокрЛП(Объект.Код) + " " + СокрЛП(Объект.Марка);
	
КонецПроцедуры

&НаСервере
Процедура ТипПриИзмененииСервер(ТипТС)
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ТипТС, "ВместимостьВКубическихМетрах, ГрузоподъемностьВТоннах");
	ЗаполнитьЗначенияСвойств(Объект, СтруктураРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
