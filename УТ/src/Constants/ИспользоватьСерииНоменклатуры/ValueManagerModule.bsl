#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ИспользуетсяСборкаРазборкаИСерииНоменклатуры.Установить(
		(Константы.ИспользоватьСборкуРазборку.Получить()
			ИЛИ Ложь)
		И Константы.ИспользоватьСерииНоменклатуры.Получить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли