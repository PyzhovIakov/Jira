#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗначения = Константы.ИспользоватьПартнеровКакКонтрагентов.СоздатьМенеджерЗначения();
	МенеджерЗначения.Значение = НЕ Значение;
	МенеджерЗначения.ОбменДанными.Загрузка = Истина;
	МенеджерЗначения.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли