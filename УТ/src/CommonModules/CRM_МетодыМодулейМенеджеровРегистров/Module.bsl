
////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.
// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СвязиМеждуПартнерами

// Функция - Получить таблицу связей партнера
//
// Параметры:
//  Партнер	 - СправочникСсылка	 - Ссылка справочника партнеры.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Список связей партнера.
//
Функция ПолучитьТаблицуСвязейПартнера(Партнер) Экспорт
	Таблица = Новый ТаблицаЗначений();
	Таблица.Колонки.Добавить("ПервыйПартнер",	Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	Таблица.Колонки.Добавить("ВторойПартнер",	Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
	Таблица.Колонки.Добавить("ВидСвязи",	Новый ОписаниеТипов("СправочникСсылка.ВидыСвязейМеждуПартнерами"));
	Таблица.Колонки.Добавить("Комментарий",	Новый ОписаниеТипов("Строка"));
	
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Таблица;
	КонецЕсли;
	
	МассивПартнеры = Новый Массив();
	//МассивПартнеры.Добавить(Партнер);
	МассивПартнеры.Добавить(ПолучитьГоловнойХолдинг(Партнер));
	нИндекс = 0;
	
	Пока нИндекс < МассивПартнеры.Количество() Цикл
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	СвязиМеждуПартнерами.ПервыйПартнер КАК ПервыйПартнер,
		                      |	СвязиМеждуПартнерами.ВторойПартнер КАК ВторойПартнер,
		                      |	СвязиМеждуПартнерами.ВидСвязи КАК ВидСвязи,
		                      |	ВЫРАЗИТЬ(СвязиМеждуПартнерами.Комментарий КАК СТРОКА(200)) КАК Комментарий
		                      |ИЗ
		                      |	РегистрСведений.СвязиМеждуПартнерами КАК СвязиМеждуПартнерами
		                      |ГДЕ
		                      |	СвязиМеждуПартнерами.ПервыйПартнер = &Партнер
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ
		                      |	СвязиМеждуПартнерами.ПервыйПартнер,
		                      |	СвязиМеждуПартнерами.ВторойПартнер,
		                      |	СвязиМеждуПартнерами.ВидСвязи,
		                      |	ВЫРАЗИТЬ(СвязиМеждуПартнерами.Комментарий КАК СТРОКА(200))
		                      |ИЗ
		                      |	РегистрСведений.СвязиМеждуПартнерами КАК СвязиМеждуПартнерами
		                      |ГДЕ
		                      |	СвязиМеждуПартнерами.ВторойПартнер = &Партнер");
		Запрос.УстановитьПараметр("Партнер", МассивПартнеры[нИндекс]);
		Выборка = CRM_ОбщегоНазначенияСервер.ВыполнитьЗапрос(Запрос).Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если МассивПартнеры.Найти(Выборка.ПервыйПартнер) = Неопределено Тогда
				МассивПартнеры.Добавить(Выборка.ПервыйПартнер);
			КонецЕсли;
			Если МассивПартнеры.Найти(Выборка.ВторойПартнер) = Неопределено Тогда
				МассивПартнеры.Добавить(Выборка.ВторойПартнер);
			КонецЕсли;
		КонецЦикла;
		нИндекс = нИндекс + 1;
	КонецЦикла;
	
	Таблица.Свернуть("ПервыйПартнер,ВторойПартнер,ВидСвязи,Комментарий");
	Возврат Таблица;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает Холдинг самого верхнего уровня
//
Функция ПолучитьГоловнойХолдинг(Партнер) Экспорт
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ГоловнойХолдинг = ПолучитьХолдингПартнера(Партнер);
	Если ГоловнойХолдинг = Неопределено Тогда
		Возврат Партнер;
	Иначе
		Возврат ПолучитьХолдингПартнера(ГоловнойХолдинг);
	КонецЕсли;
	
КонецФункции

Функция ПолучитьХолдингПартнера(Партнер) Экспорт
	Если Не ЗначениеЗаполнено(Партнер) Или ТипЗнч(Партнер) <> Тип("СправочникСсылка.Партнеры") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Если ЗначениеЗаполнено(Партнер["CRM_ГоловнаяОрганизация"]) Тогда
			Возврат Партнер["CRM_ГоловнаяОрганизация"];
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Партнер.Родитель) Тогда
			Возврат Партнер.Родитель;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

#Область ОпределениеФормОбъектов

Процедура ОбработкаПолученияФормОбъектовCRM(Источник, ВидФормы, Параметры, ВыбраннаяФорма,
	 ДополнительнаяИнформация,
	 СтандартнаяОбработка) Экспорт
	
	#Область ПолученияФормПользовательскиеМакетыПечати
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийМенеджер.ПользовательскиеМакетыПечати") Тогда
	
		Если ВидФормы = "ФормаОбъекта" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "РегистрСведений.ПользовательскиеМакетыПечати.Форма.CRM_ФормаРедактированияЗаписи";
		ИначеЕсли ВидФормы = "ФормаСписка" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "РегистрСведений.ПользовательскиеМакетыПечати.Форма.CRM_МакетыПечатныхФорм";
		КонецЕсли;
	
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПолученияФормЦеныНоменклатуры
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийМенеджер.ЦеныНоменклатуры") Тогда
	
		Если ВидФормы = "ФормаЗаписи" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "РегистрСведений.ЦеныНоменклатуры.Форма.CRM_ФормаЗаписи";
		КонецЕсли;
	
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти // ОпределениеФормОбъектов

#Область ВременноеОтсутствиеПользователя

Процедура CRM_НачалоОтсутствияСотрудника() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.CRM_НачалоОтсутствияСотрудников);

	РегистрыСведений.CRM_ОтсутствиеСотрудников.НачалоОтсутствияСотрудников();
	
КонецПроцедуры

Процедура CRM_ЗавершениеОтсутствияСотрудника() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.CRM_ЗавершениеОтсутствияСотрудников);

	РегистрыСведений.CRM_ОтсутствиеСотрудников.ЗавершениеОтсутствияСотрудников();
	
КонецПроцедуры

Процедура ЗавершитьОтсутствиеТекущегоПользователя() Экспорт
	
	РегистрыСведений.CRM_ОтсутствиеСотрудников.ЗавершитьОтсутствиеТекущегоПользователя();
	
КонецПроцедуры

#КонецОбласти // ВременноеОтсутствиеПользователя

#КонецОбласти
