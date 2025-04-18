
#Область СлужебныеПроцедурыИФункции

Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
		
	ИмяФормы = Параметры.ИмяФормы;
	МассивПолей      = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФормы, ".");
	ПолноеИмя        = МассивПолей[0] + "." + МассивПолей[1];
	ОбъектНазначения = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя", ПолноеИмя);
	
	Если ПолноеИмя = "Справочник.Партнеры" Тогда
		
		Справочники.Партнеры.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
		
		ИспользоватьПартнеровКакКонтрагентов = Константы.ИспользоватьПартнеровКакКонтрагентов.Получить();
		
		Для каждого КомандаОтчет Из КомандыОтчетов Цикл		
			
			Если ИспользоватьПартнеровКакКонтрагентов Тогда
			
				Если СтрНайти(КомандаОтчет.ВидимостьВФормах, "ФормаЭлементаРеквизитыКонтрагента") > 0 Тогда
				
					КомандаОтчет.ВидимостьВФормах = КомандаОтчет.ВидимостьВФормах + ", CRM_Модуль_ФормаЭлементаРеквизитыКонтрагентаНовая";
				
				КонецЕсли;
				
			Иначе
				
				Если СтрНайти(КомандаОтчет.ВидимостьВФормах, "ФормаЭлемента,") > 0 Тогда
					
					КомандаОтчет.ВидимостьВФормах = КомандаОтчет.ВидимостьВФормах + ", CRM_Модуль_ФормаЭлементаРеквизитыКонтрагентаНовая";
				
				КонецЕсли;
				
			КонецЕсли;		
		
		КонецЦикла;	
		
		СтандартнаяОбработка = Ложь;
		
	Иначе
		
		// удалим команду "ДобавитьКомандуМестаИспользования"
		Если ПолноеИмя = "Документ.CRM_Интерес" Тогда
			СтрокаДобавитьКомандуМестаИспользования = КомандыОтчетов.Найти("Отчет.МестаИспользованияСсылок", "Менеджер");
			Если НЕ СтрокаДобавитьКомандуМестаИспользования = Неопределено Тогда
				КомандыОтчетов.Удалить(СтрокаДобавитьКомандуМестаИспользования);
			КонецЕсли;	
		КонецЕсли;
		
		КоличествоКомандДоЗаполнения = КомандыОтчетов.Количество(); 
		Попытка
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя).ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
		Исключение
			Возврат;
		КонецПопытки;
		
		КоличествоКомандПослеЗаполнения = КомандыОтчетов.Количество();
		
		Для каждого КомандаОтчет Из КомандыОтчетов Цикл		
		
			Если ПолноеИмя = "Документ.КоммерческоеПредложениеКлиенту" Тогда
				Если СтрНайти(КомандаОтчет.ВидимостьВФормах, "ФормаСписка") > 0 Тогда
				
					КомандаОтчет.ВидимостьВФормах = КомандаОтчет.ВидимостьВФормах + ",CRM_Модуль_ФормаСписка";
				
				КонецЕсли;
				
				Если СтрНайти(КомандаОтчет.ВидимостьВФормах, "ФормаДокумента") > 0 Тогда
				
					КомандаОтчет.ВидимостьВФормах = КомандаОтчет.ВидимостьВФормах + ",CRM_Модуль_ФормаДокумента";
				
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		СтандартнаяОбработка = ?(КоличествоКомандДоЗаполнения = КоличествоКомандПослеЗаполнения, Истина, Ложь);
		
	КонецЕсли; 	
	
КонецПроцедуры

#КонецОбласти 
