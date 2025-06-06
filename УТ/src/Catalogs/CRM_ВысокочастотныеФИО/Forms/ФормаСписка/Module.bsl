
#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗаполнитьПоМакетуНаСервере()
	
	Макет = Справочники.CRM_ВысокочастотныеФИО.ПолучитьМакет("Макет");
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(Макет.Область(1, 1,
		 Макет.ВысотаТаблицы,
		 Макет.ШиринаТаблицы));
	ПостроительЗапроса.Выполнить();
	
	ТаблицаФИО = ПостроительЗапроса.Результат.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаФИО.Наименование КАК Наименование,
	|	ВЫБОР 
	|		КОГДА ТаблицаФИО.Фамилия = ""Нет"" ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА КОНЕЦ КАК Фамилия,
	|	ВЫБОР
	|		КОГДА ТаблицаФИО.Имя = ""Нет"" ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА КОНЕЦ КАК Имя,
	|	ВЫБОР
	|		КОГДА ТаблицаФИО.Отчество = ""Нет"" ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА КОНЕЦ КАК Отчество
	|ПОМЕСТИТЬ ТаблицаИзМакета
	|ИЗ
	|&ТаблицаФИО КАК ТаблицаФИО
	|;
	|
	|ВЫБРАТЬ
	|	ТаблицаИзМакета.Наименование КАК Наименование,
	|	ТаблицаИзМакета.Фамилия КАК Фамилия,
	|	ТаблицаИзМакета.Имя КАК Имя,
	|	ТаблицаИзМакета.Отчество КАК Отчество,
	|	ВысокочастотныеФИО.Наименование КАК НаименованиеФИО
	|ИЗ 
	|	ТаблицаИзМакета КАК ТаблицаИзМакета
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.CRM_ВысокочастотныеФИО КАК ВысокочастотныеФИО
	|		ПО ВысокочастотныеФИО.Наименование = ТаблицаИзМакета.Наименование
	|		И ВысокочастотныеФИО.Фамилия = ТаблицаИзМакета.Фамилия
	|		И ВысокочастотныеФИО.Имя = ТаблицаИзМакета.Имя
	|		И ВысокочастотныеФИО.Отчество = ТаблицаИзМакета.Отчество
	|	ГДЕ
	|		ЕСТЬNULL(ВысокочастотныеФИО.Наименование, """") = """"
	|";
	
	Запрос.УстановитьПараметр("ТаблицаФИО", ТаблицаФИО);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЭтоФамилия = Ложь;
		ЭтоИмя = Ложь;
		ЭтоОтчество = Ложь;
		
		Если Выборка.Фамилия Тогда
			ЭтоФамилия = Истина;
		ИначеЕсли Выборка.Имя Тогда
			ЭтоИмя = Истина;
		Иначе
			ЭтоОтчество = Истина;
		КонецЕсли;
		
		НовыйЭлемент = Справочники.CRM_ВысокочастотныеФИО.СоздатьЭлемент();
		НовыйЭлемент.Наименование = СокрЛП(Выборка.Наименование);
		НовыйЭлемент.Фамилия = ЭтоФамилия;
		НовыйЭлемент.Имя = ЭтоИмя;
		НовыйЭлемент.Отчество = ЭтоОтчество;
		НовыйЭлемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоМакету(Команда)
	ЗаполнитьПоМакетуНаСервере();
КонецПроцедуры

#КонецОбласти
