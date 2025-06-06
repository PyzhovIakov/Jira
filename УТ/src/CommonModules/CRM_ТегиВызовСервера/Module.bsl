
////////////////////////////////////////////////////////////////////////////////
// Теги вызов сервера
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОтборыОбъектовПоТегам

// Функция получения объектов по тегам. 
// Сюда можно добавлять другие отборы.
//
// Параметры:
//  ИмяОбъектаМетаданных	- имя объекта метаданных, в которых ищем теги.
//  Теги 					- массив - СправочникСсылка.Теги - теги по которым необходимо.
// Возвращаемое значение:
//  МассивОбъектов 			- объекты по тегам.
Функция ОбъектыПоТегамПоВсемОтборам(ИмяОбъектаМетаданных, Теги, ОтбиратьОбъектыБезТегов = Ложь,
	 СписокВышестоящихПодразделений = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	// Если Теги.Количество() > 0 Тогда
	//	МассивОбъектов = ОбъектыПоТегам(ИмяОбъектаМетаданных, Теги);
	//КонецЕсли;
	
	Если Теги.Количество() > 0  И ОтбиратьОбъектыБезТегов Тогда
		МассивОбъектов = Новый Массив;
	ИначеЕсли Теги.Количество() > 0  И НЕ ОтбиратьОбъектыБезТегов  Тогда
		МассивОбъектов = ОбъектыПоТегам(ИмяОбъектаМетаданных, Теги, СписокВышестоящихПодразделений);
	ИначеЕсли ОтбиратьОбъектыБезТегов Тогда
		МассивОбъектов = ОбъектыБезТегов(ИмяОбъектаМетаданных, СписокВышестоящихПодразделений);
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

// Функция получения объектов по тегам.
//
// Параметры:
//  ИмяОбъектаМетаданных	- имя объекта метаданных, в которых ищем теги.
//  Теги 					- массив - СправочникСсылка.Теги - теги по которым необходимо получить объекты.
// Возвращаемое значение:
//  МассивОбъектов 			-  объекты, содержащие все заданные теги.
Функция ОбъектыПоТегам(ИмяОбъектаМетаданных, Теги, СписокВышестоящихПодразделений = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	Запрос = Новый Запрос;
	// Запрос.Текст = 
	//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//	|	Объект.Ссылка КАК ОбъектСсылка,
	//	|	Объект.Теги.(
	//	|		Тег
	//	|	)
	//	|ИЗ
	//	|	" + ИмяОбъектаМетаданных +  " КАК Объект";
		
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОбъектТеги.Ссылка
	|ПОМЕСТИТЬ ОбъектыСТегами
	|ИЗ
	|	" + ИмяОбъектаМетаданных +  ".CRM_Теги КАК ОбъектТеги
	|";
	Если ЗначениеЗаполнено(СписокВышестоящихПодразделений) Тогда
		Запрос.Текст = Запрос.Текст + "
		| ГДЕ ОбъектТеги.Ссылка.Подразделение В ИЕРАРХИИ(&СписокВышестоящихПодразделений)";
		Запрос.УстановитьПараметр("СписокВышестоящихПодразделений", СписокВышестоящихПодразделений);	
	КонецЕсли; 
	Запрос.Текст = Запрос.Текст + "
	|СГРУППИРОВАТЬ ПО
	|	ОбъектТеги.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объект.Ссылка КАК ОбъектСсылка,
	|	Объект.CRM_Теги.(
	|		Ссылка,
	|		НомерСтроки,
	|		Тег
	|	)
	|ИЗ
	|	ОбъектыСТегами КАК ОбъектыСТегами
	|		ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяОбъектаМетаданных +  " КАК Объект
	|		ПО ОбъектыСТегами.Ссылка = Объект.Ссылка";	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Отбор = Новый Структура("Тег");
	
	Пока Выборка.Следующий() Цикл
		
		ВыборкаТеги = Выборка.CRM_Теги.Выбрать();
		ЕстьВсеТеги = Истина;
		
		Для Каждого Тег Из Теги Цикл
			Отбор.Тег = Тег;
			ВыборкаТеги.Сбросить();
			Если НЕ ВыборкаТеги.НайтиСледующий(Отбор) Тогда
				ЕстьВсеТеги = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьВсеТеги Тогда
			МассивОбъектов.Добавить(Выборка.ОбъектСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивОбъектов;
	
КонецФункции

// Функция получения объектов без тегов
//
// Параметры:
//  ИмяОбъектаМетаданных	- имя объекта метаданных, в которых ищем теги
// Возвращаемое значение:
//  МассивОбъектов 			-  объекты, содержащие все заданные теги.
Функция ОбъектыБезТегов(ИмяОбъектаМетаданных, СписокВышестоящихПодразделений = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;		
	
	Запрос = Новый Запрос;
	
	Если ЗначениеЗаполнено(СписокВышестоящихПодразделений) Тогда
		Запрос.Текст = "

		|ВЫБРАТЬ
		|	Объект.Ссылка КАК ОбъектСсылка
		|ПОМЕСТИТЬ ОбъектыПоПодразделению
		|ИЗ
		|	" + ИмяОбъектаМетаданных + " КАК Объект
		|ГДЕ
		|	Объект.Подразделение В ИЕРАРХИИ(&СписокВышестоящихПодразделений)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Объекты.ОбъектСсылка КАК ОбъектСсылка
		|ИЗ
		|	ОбъектыПоПодразделению КАК Объекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяОбъектаМетаданных +  ".CRM_Теги  КАК ОбъектТЧ
		|		ПО Объекты.ОбъектСсылка = ОбъектТЧ.Ссылка
		|ГДЕ  ОбъектТЧ.Ссылка ЕСТЬ NULL";
		
	    Запрос.УстановитьПараметр("СписокВышестоящихПодразделений", СписокВышестоящихПодразделений);
	Иначе		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Объект.Ссылка КАК ОбъектСсылка
		|ИЗ
		|	" + ИмяОбъектаМетаданных + " КАК Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяОбъектаМетаданных +  ".CRM_Теги  КАК ОбъектТЧ
		|		ПО Объект.Ссылка = ОбъектТЧ.Ссылка
		|ГДЕ  ОбъектТЧ.Ссылка ЕСТЬ NULL";		
	
	КонецЕсли; 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивОбъектов.Добавить(Выборка.ОбъектСсылка);
	КонецЦикла;
	
	Возврат МассивОбъектов;
	
КонецФункции

#КонецОбласти

#КонецОбласти
