#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Если Значение Тогда
			CRM_ПользователиПереопределяемый.СоздатьИзменитьСлужебногоПользователяСервисов();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли