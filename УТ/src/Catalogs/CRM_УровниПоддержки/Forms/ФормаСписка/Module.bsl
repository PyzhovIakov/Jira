
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УровеньПоУмолчанию = Справочники.CRM_УровниПоддержки.ПоУмолчанию;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	
	ДоступностьПеремещения = (ТекущаяСтрока <> Неопределено) И (ТекущаяСтрока <> УровеньПоУмолчанию);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПереместитьВверх",
		 "Доступность",
		 ДоступностьПеремещения);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПереместитьВниз",
		 "Доступность",
		 ДоступностьПеремещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ПереместитьЭлемент("Вверх");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ПереместитьЭлемент("Вниз");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПереместитьЭлемент(Направление)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено
		Или ТекущаяСтрока = УровеньПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	
	ПереместитьЭлементНаСервере(ТекущаяСтрока, Направление);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьЭлементНаСервере(Знач ТекущийЭлементСсылка, Знач Направление)
	
	Если ТекущийЭлементСсылка = УровеньПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСписок = Элементы.Список;
	
	НастройкиКомпоновкиДанных = ЭлементСписок.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	ГруппировкаКомпоновкиДанных = НастройкиКомпоновкиДанных.Структура[0];
	
	ПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.ДоступныеПоляВыбора.Элементы.Найти("Ссылка").Поле;
	ЕстьПолеСсылка = Ложь;
	Для Каждого ВыбранноеПолеКомпоновкиДанных Из ГруппировкаКомпоновкиДанных.Выбор.Элементы Цикл
		Если ТипЗнч(ВыбранноеПолеКомпоновкиДанных) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если ВыбранноеПолеКомпоновкиДанных.Поле = ПолеКомпоновкиДанных Тогда
			ЕстьПолеСсылка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Не ЕстьПолеСсылка Тогда
		ВыбранноеПолеКомпоновкиДанных =
			ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		ВыбранноеПолеКомпоновкиДанных.Поле = ПолеКомпоновкиДанных;
	КонецЕсли;
	
	СхемаКомпоновкиДанных = ЭлементСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	ТаблицаЗначений = ВыполнитьЗапрос(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	
	НайденнаяСтрока = ТаблицаЗначений.Найти(ТекущийЭлементСсылка, "Ссылка");
	ИндексТекущего = ТаблицаЗначений.Индекс(НайденнаяСтрока);
	ИндексСоседнего = ИндексТекущего;
	Если Направление = "Вверх" Тогда
		Если ИндексТекущего > 0 Тогда
			ИндексСоседнего = ИндексТекущего - 1;
		КонецЕсли;
	Иначе // Вниз
		Если ИндексТекущего < ТаблицаЗначений.Количество() - 1 Тогда
			ИндексСоседнего = ИндексТекущего + 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ИндексТекущего <> ИндексСоседнего Тогда
		СоседняяСтрока = ТаблицаЗначений.Получить(ИндексСоседнего);
		СоседнийЭлементСсылка = СоседняяСтрока.Ссылка;
		Если СоседнийЭлементСсылка <> УровеньПоУмолчанию Тогда
			ПоменятьЭлементыМестами(ТекущийЭлементСсылка, СоседнийЭлементСсылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьЗапрос(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных)
	
	Результат = Новый ТаблицаЗначений;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Попытка
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
			НастройкиКомпоновкиДанных, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПоменятьЭлементыМестами(ПервыйЭлементСсылка, ВторойЭлементСсылка)
	
	НачатьТранзакцию();
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ПервыйЭлементСсылка);
		ЗаблокироватьДанныеДляРедактирования(ВторойЭлементСсылка);
		
		ПервыйЭлементОбъект = ПервыйЭлементСсылка.ПолучитьОбъект();
		ВторойЭлементОбъект = ВторойЭлементСсылка.ПолучитьОбъект();
		
		ИндексПервого = ПервыйЭлементОбъект.Порядок;
		ИндексВторого = ВторойЭлементОбъект.Порядок;
		
		ПервыйЭлементОбъект.Порядок = ИндексВторого;
		ВторойЭлементОбъект.Порядок = ИндексПервого;
	
		ПервыйЭлементОбъект.Записать();
		ВторойЭлементОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
