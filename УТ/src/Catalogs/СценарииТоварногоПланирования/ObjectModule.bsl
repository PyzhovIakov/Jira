#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(СпособРасчетаПотребностейВМатериалах) Тогда
		СпособРасчетаПотребностейВМатериалах = ПредопределенноеЗначение("Перечисление.СпособыРасчетаМатериалов.ВероятноеПотребление");
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме) 
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		И Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Валюта"". Установите валюту управленческого учета!'");
		КонецЕсли;
	КонецЕсли;
	
	Если Периодичность = Перечисления.Периодичность.Год
		ИЛИ Периодичность = Перечисления.Периодичность.Декада Тогда
	
		ОтображатьНомерПериода = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(СпособРасчетаПотребностейВМатериалах) Тогда
		СпособРасчетаПотребностейВМатериалах = ПредопределенноеЗначение("Перечисление.СпособыРасчетаМатериалов.ВероятноеПотребление");
	КонецЕсли;
	
	Если НЕ (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	Если НЕ ИспользоватьДляПланированияМатериалов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособРасчетаПотребностейВМатериалах");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОтражаетсяВБюджетировании");
		МассивНепроверяемыхРеквизитов.Добавить("СценарийБюджетирования");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме)  
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		И Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Валюта"". Установите валюту управленческого учета!'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
