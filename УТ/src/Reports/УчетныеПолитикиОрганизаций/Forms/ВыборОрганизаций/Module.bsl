
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияОсновная = Параметры.ОрганизацияОсновная;
	ЗаполнитьОрганизации(СписокОрганизаций, Параметры.СписокВыбранныхОрганизаций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьОрганизации(Команда)
	Результат = Новый Массив();
	
	Для Каждого СтрокаТЧ Из СписокОрганизаций Цикл
		Если СтрокаТЧ.Пометка Тогда
			Результат.Добавить(СтрокаТЧ.Организация);
		КонецЕсли;
	КонецЦикла;

	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	УстановитьДляВсехПометку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	УстановитьДляВсехПометку(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДляВсехПометку(Пометка)
	
	Для Каждого СтрокаТЧ Из СписокОрганизаций Цикл
		Если НЕ СтрокаТЧ.ОсновнаяОрганизация Тогда
			СтрокаТЧ.Пометка = Пометка;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОрганизации(СписокОрганизаций, СписокВыбранныхОрганизаций)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияОсновная", ОрганизацияОсновная);
	Запрос.УстановитьПараметр("СписокВыбранныхОрганизаций", СписокВыбранныхОрганизаций);
	Запрос.Текст = "ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА Организации.Ссылка В (&СписокВыбранныхОрганизаций)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ОбособленноеПодразделение = ЛОЖЬ
	|	И Организации.Ссылка <> &ОрганизацияОсновная
	|	И Организации.Ссылка <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|УПОРЯДОЧИТЬ ПО
	|	Организация
	|АВТОУПОРЯДОЧИВАНИЕ";

	СписокОрганизаций.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

#КонецОбласти
