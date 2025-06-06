
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗапросПриИзменении(Элемент)
	ЗаполнитьТаблицуПараметров();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Конструктор(Команда)
	Конструктор = Новый КонструкторЗапроса;

	Конструктор.Текст = Объект.Запрос;

	Оповещение = Новый ОписаниеОповещения("ОткрытьКонструкторЗапросаЗавершение", ЭтотОбъект);

	Конструктор.Показать(Оповещение);

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОткрытьКонструкторЗапросаЗавершение(Текст, ДополнительныеПараметры) Экспорт
	Если Не Текст = Неопределено Тогда
		Объект.Запрос = Текст;
		ЗаполнитьТаблицуПараметров();

	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПараметров()

	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = Объект.Запрос;
		Объект.Параметры.Очистить();
		Для Каждого Параметр Из Запрос.НайтиПараметры() Цикл
			Если Параметр.Имя = "ТекущаяДата" Или Параметр.Имя = "Задача" Или Параметр.Имя = "ТекущийПользователь" Тогда
				Продолжить;
			КонецЕсли;
			СтрНовая = Объект.Параметры.Добавить();
			СтрНовая.Параметр = Параметр.Имя;
			СтрНовая.Значение = Параметр.ТипЗначения.ПривестиЗначение(СтрНовая.Значение);
		КонецЦикла;
	Исключение
		ОбщегоНазначения.СообщитьПользователю("Ошибка заполнения параметров");
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти