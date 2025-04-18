#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Процедура ПродолжитьВводНового(Команда)
	ТД	= Элементы.ДеревоПоиска.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Закрыть(Новый Структура("Результат,Объект", "Продолжить", Неопределено));
	ИначеЕсли НЕ ЗначениеЗаполнено(ТД.Объект) Тогда
		Закрыть(Новый Структура("Результат,Объект", "Продолжить", Неопределено));
	ИначеЕсли НЕ ТД.Доступен Тогда
		Если ТипЗнч(ТД.Объект) = Тип("СправочникСсылка.Партнеры") Тогда
			Закрыть(Новый Структура("Результат,Объект", "Продолжить", ТД.Объект));
		Иначе
			Закрыть(Новый Структура("Результат,Объект", "Продолжить", Неопределено));
		КонецЕсли;	
	Иначе
		Закрыть(Новый Структура("Результат,Объект", "Продолжить", ТД.Объект));
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВводНового()
	
	Закрыть(Новый Структура("Результат", "Продолжить"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКНайденному(Команда)
	ТД	= Элементы.ДеревоПоиска.ТекущиеДанные;
	Если НЕ (ТД = Неопределено) И ТД.Доступен Тогда
		Закрыть(Новый Структура("Результат,Объект", "Перейти", ТД.Объект));
	КонецЕсли;
КонецПроцедуры

&НаСервере 
Функция НайтиДубли(СтруктураОбъекта, СтруктураПоиска)
	МассивНайденных = CRM_КлиентыСервер.НайтиДублиПартнеров(СтруктураОбъекта, СтруктураПоиска);
	Если МассивНайденных.Количество() = 0 Тогда
		ЕстьНайденные = Ложь;
	Иначе	
		ЕстьНайденные = Истина;
		Для Каждого СтрокаМассива Из МассивНайденных Цикл
			Отбор = Новый Структура();
			Отбор.Вставить("Объект", СтрокаМассива.Ссылка);
			НайдСтрока = _ТаблицаНайдено.НайтиСтроки(Отбор);
			Если НайдСтрока.Количество() = 0 Тогда
				Строка = _ТаблицаНайдено.Добавить();
				Строка.Объект			= СтрокаМассива.Ссылка;
				Строка.Код				= СтрокаМассива.Ссылка.Код;
				Строка.Представление	= СтрокаМассива.НаименованиеПолное;
				Строка.ОтветственныйМенеджер	= СтрокаМассива.ОсновнойМенеджер;
			КонецЕсли;
			Строка = ТаблицаРасшифровкаНайдено.Добавить();
			Строка.Объект = СтрокаМассива.Ссылка;
			Строка.ПредставлениеНайденоПо = СтрЗаменить(СтрокаМассива.ИмяРеквизита, "CRM_", "") + " - " 
				+ Строка(СтрокаМассива.Реквизит);
		КонецЦикла;
		_ТаблицаНайдено.Сортировать("Объект Возр");
	КонецЕсли;
	Возврат ЕстьНайденные;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ

&НаКлиенте
Процедура ДеревоПоискаПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоПоиска.ТекущиеДанные = Неопределено Тогда
		ТекОбъект = Неопределено;
	ИначеЕсли ТекОбъект = Элементы.ДеревоПоиска.ТекущиеДанные.Объект Тогда
		Возврат;
	Иначе
		ТекОбъект = Элементы.ДеревоПоиска.ТекущиеДанные.Объект;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ДеревоПоискаПриАктивизацииСтрокиОбработчик", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоискаПриАктивизацииСтрокиОбработчик()
	ОтветственныйМенеджерКлиента					= ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	Элементы.ОтветственныйМенеджерКлиента.Видимость	= Ложь;
	ЭтоВводНового = Ложь;
	Если Элементы.ДеревоПоиска.ТекущиеДанные = Неопределено Тогда
		Элементы.ПродолжитьВводНового.Заголовок 				= НСтр("ru='Продолжить ввод нового';en='Continue typing a new one'");	
		Элементы.ПерейтиКНайденному.Доступность					= Ложь;
		Элементы.ТаблицаРасшифровкаНайдено.ОтборСтрок			= Новый ФиксированнаяСтруктура("Объект", Неопределено); 
		ЭтоВводНового = Истина;
	ИначеЕсли НЕ ЗначениеЗаполнено(Элементы.ДеревоПоиска.ТекущиеДанные.Объект) Тогда
		Элементы.ПродолжитьВводНового.Заголовок					= НСтр("ru='Продолжить ввод нового';en='Continue typing a new one'");		
		Элементы.ПерейтиКНайденному.Доступность					= Ложь;
		Элементы.ТаблицаРасшифровкаНайдено.ОтборСтрок			= Новый ФиксированнаяСтруктура("Объект", ТекОбъект); 
		ЭтоВводНового = Истина;
	ИначеЕсли НЕ Элементы.ДеревоПоиска.ТекущиеДанные.Доступен Тогда
		Если ТипЗнч(Элементы.ДеревоПоиска.ТекущиеДанные.Объект) = Тип("СправочникСсылка.Партнеры") Тогда
			Если ОткрытаИзМПО И НЕ ЕстьДанныеКЛ_МПО Тогда
				Элементы.ПродолжитьВводНового.Заголовок				= НСтр("ru='Выбрать текущего';en='Choose Customer'");
			Иначе
				Элементы.ПродолжитьВводНового.Заголовок				= НСтр("ru='Зарегистрировать новый контакт клиента';
					|en='Create New Customer Contact'");
			КонецЕсли;
			ОтветственныйМенеджерКлиента					= Элементы.ДеревоПоиска.ТекущиеДанные.ОтветственныйМенеджер;
			Элементы.ОтветственныйМенеджерКлиента.Видимость	= Истина;
		Иначе	
			Элементы.ПродолжитьВводНового.Заголовок				= НСтр("ru='Продолжить ввод нового';en='Continue typing a new one'");		
			ЭтоВводНового = Истина;
		КонецЕсли;	
		Элементы.ПерейтиКНайденному.Доступность					= Ложь;
		Элементы.ТаблицаРасшифровкаНайдено.ОтборСтрок			= Новый ФиксированнаяСтруктура("Объект", ТекОбъект); 
	Иначе	
		Если ТипЗнч(Элементы.ДеревоПоиска.ТекущиеДанные.Объект) = Тип("СправочникСсылка.Партнеры") Тогда
			Если ОткрытаИзМПО И НЕ ЕстьДанныеКЛ_МПО Тогда
				Элементы.ПродолжитьВводНового.Заголовок			= НСтр("ru='Выбрать текущего';en='Choose Customer'");
			Иначе
				Элементы.ПродолжитьВводНового.Заголовок			= НСтр("ru='Зарегистрировать новый контакт клиента';
					|en='Create New Customer Contact'");	
			КонецЕсли;
			ОтветственныйМенеджерКлиента					= Элементы.ДеревоПоиска.ТекущиеДанные.ОтветственныйМенеджер;
			Элементы.ОтветственныйМенеджерКлиента.Видимость	= Истина;
		Иначе
			Элементы.ПродолжитьВводНового.Заголовок			= НСтр("ru='Дополнить информацию о контакте';
				|en='Add information about the contact'");	
		КонецЕсли; 
		Элементы.ПерейтиКНайденному.Доступность					= Элементы.ДеревоПоиска.ТекущиеДанные.Доступен;
		Элементы.ТаблицаРасшифровкаНайдено.ОтборСтрок			= Новый ФиксированнаяСтруктура("Объект", ТекОбъект); 
	КонецЕсли;
	Если ЭтоВводНового И ЗапретитьВводНовогоКлиента Тогда
		ИзменитьПодсказкуПродолжитьВводНового(НСтр("ru = 'Необходимо обратиться к администратору базы для предоставления прав доступа к имеющемуся контакту.'"));
		Элементы.ПродолжитьВводНового.Доступность = Ложь;
	Иначе	
		ИзменитьПодсказкуПродолжитьВводНового("");
		Элементы.ПродолжитьВводНового.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИзменитьПодсказкуПродолжитьВводНового(Подсказка)
	Команда = Команды.Найти("ПродолжитьВводНового");
	Если Команда <> Неопределено Тогда
		Команда.Подсказка = Подсказка;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Элемент.ТекущиеДанные.Доступен Тогда
			ПоказатьЗначение(, Элемент.ТекущиеДанные.Объект);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПривилегированныйРежим(Истина);
	Если Параметры.Свойство("СтруктураПоиска") Тогда
		ДублиНайдены = НайтиДубли(Параметры.СтруктураОбъекта, Параметры.СтруктураПоиска);
		Если ДублиНайдены Тогда
			ВеткаКорень = ДеревоПоиска.ПолучитьЭлементы();
			ВеткаКорень.Очистить();
			НоваяСтрока					= ВеткаКорень.Добавить();
			НоваяСтрока.Представление	= НСтр("ru='Создать: Клиента / Контакт';en='Create: Customer / Contact'");
			НоваяСтрока.Объект			= Справочники.Партнеры.ПустаяСсылка();
			Для Каждого СтрокаНайденого Из _ТаблицаНайдено Цикл
				Если ТипЗнч(СтрокаНайденого.Объект) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
					// Выполняем поиск партнера-владельца контактного лица
					ВеткаВладелец	= Неопределено;
					Для Каждого СтрокаВетки Из ВеткаКорень Цикл
						Если СтрокаВетки.Объект = СтрокаНайденого.Объект.Владелец Тогда
							ВеткаВладелец	= СтрокаВетки;  							
							Прервать;
					    КонецЕсли;
					КонецЦикла;
					Если ВеткаВладелец = Неопределено Тогда
						ВеткаВладелец				= ВеткаКорень.Добавить();
						ВеткаВладелец.Объект		= СтрокаНайденого.Объект.Владелец;
						ВеткаВладелец.Код			= СтрокаНайденого.Объект.Код;
						ВеткаВладелец.Представление	= СтрокаНайденого.Объект.Владелец.Наименование;
						ВеткаВладелец.Доступен		=  Ложь;
						ВеткаВладелец.ПометкаУдаления = СтрокаНайденого.Объект.ПометкаУдаления;
					КонецЕсли;
					Строка				= ВеткаВладелец.ПолучитьЭлементы().Добавить();
				Иначе
					Строка				= ВеткаКорень.Добавить();
				КонецЕсли;	
				Строка.Объект			= СтрокаНайденого.Объект;
				Строка.Код				= СтрокаНайденого.Код;
				Строка.ОтветственныйМенеджер = СтрокаНайденого.ОтветственныйМенеджер;
				Попытка
					НаименованиеКлиента = СтрокаНайденого.Объект.Наименование;
					Строка.Доступен		=  Истина;
					Строка.Представление	= СтрокаНайденого.Представление;
				Исключение
					Строка.Доступен		=  Ложь;
					Строка.Представление	= СтрокаНайденого.Представление + НСтр("ru=' (нет доступа)';en=' (no access)'");
				КонецПопытки;
				Строка.ПометкаУдаления = СтрокаНайденого.Объект.ПометкаУдаления;
			КонецЦикла;
			
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("ПотенциальныйКлиент") Тогда
		Элементы.ПерейтиКНайденному.Заголовок	= НСтр("ru='Выбрать контакт';en='Select contact'");
	КонецЕсли;	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.Партнеры) Тогда
		Элементы.ПродолжитьВводНового.Видимость = Ложь;	
	КонецЕсли;
	
	ЗапретитьВводНовогоКлиента = НЕ РольДоступна("ПолныеПрава") И 
		Константы.CRM_ЗапретитьВводНовогоКлиентаПриНайденныхСовпадениях.Получить();
		
	Если НЕ Отказ Тогда
		Если Параметры.СтруктураОбъекта.Свойство("ЕстьДанныеКЛ_МПО") Тогда
			ОткрытаИзМПО = Истина;
			ЕстьДанныеКЛ_МПО = Параметры.СтруктураОбъекта.ЕстьДанныеКЛ_МПО;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ТипЗнч(ВладелецФормы.ВладелецФормы) = Тип("ПолеФормы") Тогда
		Элементы.ПерейтиКНайденному.Заголовок = НСтр("ru = 'Использовать найденного клиента'");
	КонецЕсли;
	Если НЕ ДублиНайдены Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПродолжитьВводНового", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
