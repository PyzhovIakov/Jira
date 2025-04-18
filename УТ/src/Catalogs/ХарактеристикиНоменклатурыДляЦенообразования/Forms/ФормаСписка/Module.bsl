#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	РежимОтладки = ОбщегоНазначенияУТ.РежимОтладки();
	Элементы.Список.ТолькоПросмотр = Не РежимОтладки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Ключи = Строки.ПолучитьКлючи();
	СтрокаСписка = Строки.Получить(Ключи[0]);
	Если Не СтрокаСписка.Данные.Свойство("НетСсылкиНаЭлемент") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХарактеристикиНоменклатуры.ХарактеристикаНоменклатурыДляЦенообразования Как Ссылка,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ХарактеристикиНоменклатуры.Ссылка ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ) КАК НетСсылкиНаЭлемент
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|ГДЕ
		|	ХарактеристикиНоменклатуры.ХарактеристикаНоменклатурыДляЦенообразования В (&Ссылки)
		|СГРУППИРОВАТЬ ПО
		|	ХарактеристикиНоменклатуры.ХарактеристикаНоменклатурыДляЦенообразования";
		
	Ссылки = Новый Массив;
	Для Каждого Ключ Из Ключи Цикл // СправочникСсылка.ХарактеристикиНоменклатурыДляЦенообразования
		Ссылки.Добавить(Ключ);
	КонецЦикла;
		
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	ДанныеПоХарактеристикам = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Строки Цикл
		Строка = Строки[Строка.Ключ];
		НайденнаяСтрока = ДанныеПоХарактеристикам.Найти(Строка.Данные["Ссылка"], "Ссылка");
		Если НайденнаяСтрока <> Неопределено Тогда
			Строка.Данные["НетСсылкиНаЭлемент"] = НайденнаяСтрока.НетСсылкиНаЭлемент;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти
