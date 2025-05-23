////////////////////////////////////////////////////////////////////////////////
// Модуль содержит общие процедуры и функции для форм регламентированной
// отчетности.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПолучитьСведенияОбОрганизации(Знач Организация, Знач ДатаЗначения = Неопределено, Знач СписокПоказателей = Неопределено) Экспорт

	Если НЕ ТипЗнч(СписокПоказателей) = Тип("Строка") Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	// ИННЮЛ, КППЮЛ, НаимЮЛПол, КодНО, ФИО, ФИОРук
	СведенияОбОрганизации = Новый Структура(СписокПоказателей);
	
	СтруктураСведений = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, ДатаЗначения);
	Если СведенияОбОрганизации.Свойство("ИННЮЛ") Тогда
		СведенияОбОрганизации.ИННЮЛ = СтруктураСведений.ИНН;
	КонецЕсли;
	Если СведенияОбОрганизации.Свойство("КППЮЛ") Тогда
		СведенияОбОрганизации.КППЮЛ = СтруктураСведений.КПП;
	КонецЕсли;
	Если СведенияОбОрганизации.Свойство("НаимЮЛПол") Тогда
		СведенияОбОрганизации.НаимЮЛПол = СтруктураСведений.НаименованиеДляПечатныхФорм;
	КонецЕсли;
	Если СведенияОбОрганизации.Свойство("ФИО") Тогда
		СведенияОбОрганизации.ФИО = СтруктураСведений.ФИОФизлица;
	КонецЕсли;
	
	СведенияОРегистрации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "КодНалоговогоОргана, РегистрацияВНалоговомОргане");
	Если СведенияОбОрганизации.Свойство("КодНО") Тогда
		Если ЗначениеЗаполнено(СведенияОРегистрации.РегистрацияВНалоговомОргане) Тогда
			СведенияОбОрганизации.КодНО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СведенияОРегистрации.РегистрацияВНалоговомОргане, "Код");
		Иначе
			СведенияОбОрганизации.КодНО = СведенияОРегистрации.КодНалоговогоОргана;
		КонецЕсли;
	КонецЕсли;
	
	ОтветственыеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация, ДатаЗначения);
	Если СведенияОбОрганизации.Свойство("ФИОРук") Тогда
		СведенияОбОрганизации.ФИОРук = ОтветственыеЛица.Руководитель;
	КонецЕсли;
	
	Возврат СведенияОбОрганизации;
	
КонецФункции

Функция ЭтоЮридическоеЛицо(Организация) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ЮрЛицо;
	
КонецФункции

Функция ПолучитьПоКодамСведенияОПредставителе(Организация, КодНО, КПП = Неопределено) Экспорт
	
	ТипПодписанта = "1";
	флПредставительЮрЛицо = Истина;
	НаименованиеОрганизацииПредставителя = "";
	ФИОПредставителя = "";
	ПредставительСсылка = Неопределено;
	ДокументПредставителя = "";
	               	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	РегистрацииВНалоговомОргане.Представитель,
	               |	РегистрацииВНалоговомОргане.УполномоченноеЛицоПредставителя,
	               |	РегистрацииВНалоговомОргане.ДокументПредставителя
	               |ИЗ
	               |	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	               |ГДЕ
	               |	(РегистрацииВНалоговомОргане.Владелец = &Организация
				   |			ИЛИ РегистрацииВНалоговомОргане.Владелец = &ГоловнаяОрганизация)
				   |	И РегистрацииВНалоговомОргане.Код = &КодНО
				   |	И НЕ РегистрацииВНалоговомОргане.ПометкаУдаления";
				   
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("КодНО", КодНО);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", РегламентированнаяОтчетность.ГоловнаяОрганизация(Организация));
		
	Если КПП <> Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + " И РегистрацииВНалоговомОргане.КПП = &КПП";
		Запрос.УстановитьПараметр("КПП", КПП);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Представитель) Тогда
		ТипПодписанта = "2";
		ПредставительСсылка = Выборка.Представитель;
		ДокументПредставителя = Выборка.ДокументПредставителя;
		
		Если НЕ РегламентированнаяОтчетность.ПредставительЯвляетсяФизЛицом(Выборка.Представитель) Тогда
			
			флПредставительЮрЛицо = Истина;
			
			НаименованиеОрганизацииПредставителя = СокрЛП(ПредставительСсылка);
			
			Если ТипЗнч(ПредставительСсылка) = Тип("СправочникСсылка.Контрагенты")
			   И НЕ ПредставительСсылка.Метаданные().Реквизиты.Найти("НаименованиеПолное") = Неопределено
			   И ЗначениеЗаполнено(ПредставительСсылка.НаименованиеПолное) Тогда
			   
				НаименованиеОрганизацииПредставителя = СокрЛП(ПредставительСсылка.НаименованиеПолное);
					
			КонецЕсли;
						
			ФИОПредставителя = СокрЛП(Выборка.УполномоченноеЛицоПредставителя);
			
		Иначе
			
			флПредставительЮрЛицо = Ложь;
						
			ФИОПредставителя = СокрЛП(ПредставительСсылка);
			
			Если ТипЗнч(ПредставительСсылка) = Тип("СправочникСсылка.ФизическиеЛица")
			   И НЕ ПредставительСсылка.Метаданные().Реквизиты.Найти("ФИО") = Неопределено
			   И ЗначениеЗаполнено(ПредставительСсылка.ФИО) Тогда
			   
				ФИОПредставителя = СокрЛП(ПредставительСсылка.ФИО);
					
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ТипПодписанта", ТипПодписанта);
	Результат.Вставить("флПредставительЮрЛицо", флПредставительЮрЛицо);
	Результат.Вставить("НаименованиеОрганизацииПредставителя", НаименованиеОрганизацииПредставителя);
	Результат.Вставить("ФИОПредставителя", ФИОПредставителя);
	Результат.Вставить("ПредставительСсылка", ПредставительСсылка);
	Результат.Вставить("ДокументПредставителя", ДокументПредставителя);
	
	Возврат Результат;						 
							 
КонецФункции

Функция ОбъектОтчета(ЭтаФормаИмя) Экспорт
	
	Возврат Отчеты[Сред(Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1), 7)].Создать();
	
КонецФункции

Функция ПолныйПутьКФорме(ИсточникОтчета, ВыбраннаяФорма) Экспорт
	
	Возврат "Отчет." + ИсточникОтчета + ".Форма." + ВыбраннаяФорма;
	
КонецФункции

#КонецОбласти
