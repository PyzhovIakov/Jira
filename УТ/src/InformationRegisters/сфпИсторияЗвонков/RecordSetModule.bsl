
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
         Возврат;
    КонецЕсли;
	
	Для Каждого ТекЗапись Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(ТекЗапись.НомерТелефона) Тогда
			ТекЗапись.НецелевойЗвонок = сфпСофтФонПроСервер.ОпределитьНецелевойЗвонокПоНомеру(ТекЗапись.НомерТелефона);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти