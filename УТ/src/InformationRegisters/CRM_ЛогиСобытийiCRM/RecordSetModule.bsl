#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
         Возврат;
    КонецЕсли;
	
	ВестиЛогиiCRM = Истина;
	
	Если НЕ ВестиЛогиiCRM Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Запись.ДатаСобытия = ТекущаяДатаСеанса();
		Если НЕ ЗначениеЗаполнено(Запись.ТипСобытия) Тогда
			Запись.ТипСобытия = Перечисления.CRM_ТипыСобытийЛогаiCRM.Информация;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Запись.ИдентификаторСобытия) Тогда
			Запись.ИдентификаторСобытия = Новый УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
