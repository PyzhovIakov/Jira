
Процедура ПередЗаписью(Отказ, Замещение)
	Перем ОписаниеОшибки;
	
	Если гбСерверПовтИсп.ПолучитьКэшКонтекста().Свойство("гбОжидаемыеДанные_ОписаниеОшибки", ОписаниеОшибки) тогда
		ВызватьИсключение(ОписаниеОшибки);
	КонецЕсли;
	
	
КонецПроцедуры
