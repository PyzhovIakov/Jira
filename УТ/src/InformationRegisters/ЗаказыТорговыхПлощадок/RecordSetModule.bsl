#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Замещение
			И Не ЗначениеЗаполнено(Отбор.ДокументОтгрузки.Значение)
			И Отбор.ДокументОтгрузки.Значение <> Неопределено Тогда
		Для Каждого Запись Из ЭтотОбъект Цикл
			Запись.ДокументОтгрузки = Неопределено;
		КонецЦикла;
		Отбор.ДокументОтгрузки.Значение = Неопределено;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
