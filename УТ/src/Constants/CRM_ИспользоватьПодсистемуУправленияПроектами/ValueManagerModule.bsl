#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоУХ() 
			И Значение Тогда
			Значение = Ложь;
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Константа ""Использовать подсистему управления проектами"" не используется в конфигурации ""Управление холдингом"".
						|Значение не записано!'"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
