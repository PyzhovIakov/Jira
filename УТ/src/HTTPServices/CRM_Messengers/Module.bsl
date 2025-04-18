
#Область СлужебныеПроцедурыИФункции

Функция pingGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("OK");
	Возврат Ответ;
КонецФункции

Функция webhookGet(Запрос)
	
	ИмяМетода = Запрос.ПараметрыURL.Получить("ИмяМетода");
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Ответ = CRM_РаботаСМессенджерамиСервер.ОбработатьWebhook(ИмяМетода, Запрос.ПолучитьТелоКакСтроку());
	Иначе
		Ответ = Ответ("CRM_Messangers/webhook", Ложь, "The requested URL was not found on this server: " + Запрос.БазовыйURL 
			+ Запрос.ОтносительныйURL);
	КонецЕсли;
	Возврат Ответ;
	
КонецФункции

Функция webhookPost(Запрос)
	
	ИмяМетода = Запрос.ПараметрыURL.Получить("ИмяМетода");
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Ответ = CRM_РаботаСМессенджерамиСервер.ОбработатьWebhook(ИмяМетода, Запрос.ПолучитьТелоКакСтроку());
	Иначе
		Ответ = Ответ("CRM_Messangers/webhook", Ложь, "The requested URL was not found on this server: " + Запрос.БазовыйURL 
			+ Запрос.ОтносительныйURL);
	КонецЕсли;
	Возврат Ответ;
	
КонецФункции

Функция Ответ(ИмяСобытия, Успешно, Текст)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("status");
    ЗаписьJSON.ЗаписатьЗначение(?(Успешно, "success", "error"));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("text");
    ЗаписьJSON.ЗаписатьЗначение(Текст);
		
	ЗаписьJSON.ЗаписатьКонецОбъекта();

	json = ЗаписьJSON.Закрыть();
	
	ДобавитьЗаписьЖурнала(ИмяСобытия, "Ответ: " + json, НЕ Успешно);
		
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	Ответ.УстановитьТелоИзСтроки(json);
	
	Возврат Ответ;
	
КонецФункции	

Процедура ДобавитьЗаписьЖурнала(ИмяСобытия, Текст, Ошибка = Ложь)
	
	Если Ошибка Тогда
		  УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
	Иначе УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации("CRM_Messangers." + ИмяСобытия, УровеньЖурнала, , , Текст);
	
КонецПроцедуры	

#КонецОбласти
