
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	CRM_ОбщегоНазначенияСервер.СбросНастроекПоложенияОкна(ЭтотОбъект);
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	ТекущееПодразделение = ТекущийПользователь.Подразделение;
	
	Интерес = Документы.CRM_Интерес.ПустаяСсылка();
	Параметры.Свойство("Интерес", Интерес);
	ДокументИнтерес = Интерес;
	ОбновитьТаблицуНаКонтроле(Интерес);
	Заголовок = НСтр("ru='Интерес клиента ';en='Lead'") 
		+ ?(ЗначениеЗаполнено(Интерес.Партнер), Интерес.Партнер, Интерес.ПотенциальныйКлиент) + ", " 
		+ Интерес.Тема;
	
	ПользовательНайден = ТаблицаКонтроль.НайтиСтроки(Новый Структура("Пользователь", ТекущийПользователь));
	Если ПользовательНайден.Количество() = 0 Тогда
		Заголовок = НСтр("ru='Взять интерес на контроль';en='Control'");
		Элементы.ДатаВзятияНаКонтроль.Видимость = Ложь;
		Элементы.ФормаНаКонтроль.Заголовок = НСтр("ru='Взять на контроль';en='Control'");
	Иначе
		Заголовок = НСтр("ru='Снять интерес с контроля';en='Do not control'"); 
		Комментарий = ПользовательНайден[0].Комментарий;
		Элементы.Комментарий.ПодсказкаВвода = "";
		Элементы.Комментарий.ТолькоПросмотр = Истина;
		Элементы.ДатаВзятияНаКонтроль.Видимость = Истина;
		ДатаВзятияНаКонтроль = НСтр("ru='Взято на контроль';en='Taken to control'") + " " 
			+ Формат(ПользовательНайден[0].ДатаПринятияНаКонтроль,
			 "ДФ=d.MM.yyyy; ДЛФ=D");
		Элементы.ФормаНаКонтроль.Заголовок = НСтр("ru='Снять с контроля';en='Do not control'");
	КонецЕсли;
	
	БезОткрытияДокумента = Параметры.Свойство("БезОткрытияДокумента"); // форма открыта не из документа Интерес.
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура НаКонтроль(Команда)
	Если Заголовок = НСтр("ru='Взять интерес на контроль';en='Control'") Тогда
		Если БезОткрытияДокумента Тогда
			CRM_ОбщегоНазначенияСервер.CRM_ЗаписатьНовоеСостояниеНаКонтролеДляТекущегоПользователя(ДокументИнтерес,
				 ТекущийПользователь,
				 ПредопределенноеЗначение("Перечисление.CRM_СтатусыКонтроляИнтереса.НаКонтроле"),
				 Комментарий);
			Закрыть();
		Иначе	
			НоваяСтрока = ТаблицаКонтроль.Добавить();
			НоваяСтрока.Пользователь = ТекущийПользователь;
			НоваяСтрока.Подразделение = ТекущееПодразделение;
			НоваяСтрока.ДатаПринятияНаКонтроль = ОбщегоНазначенияКлиент.ДатаСеанса();
			НоваяСтрока.Комментарий = Комментарий;
			Закрыть(Новый Структура("НаКонтроле, Комментарий", Истина, Комментарий));
		КонецЕсли;
	ИначеЕсли Заголовок = НСтр("ru='Снять интерес с контроля';en='Do not control'") Тогда
		Если БезОткрытияДокумента Тогда
			Для Каждого СтрокаТЗ Из ТаблицаКонтроль Цикл
				Если СтрокаТЗ.Пользователь = ТекущийПользователь Тогда
					ТаблицаКонтроль.Удалить(ТаблицаКонтроль.Индекс(СтрокаТЗ));
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			НайтиСтроки = ТаблицаКонтроль.НайтиСтроки(Новый Структура("Пользователь", ТекущийПользователь));
			
			CRM_ОбщегоНазначенияСервер.CRM_ЗаписатьНовоеСостояниеНаКонтролеДляТекущегоПользователя(ДокументИнтерес,
				 ТекущийПользователь,
				 ПредопределенноеЗначение("Перечисление.CRM_СтатусыКонтроляИнтереса.СнятоСКонтроля"),
				 Комментарий);		
			Закрыть();
		Иначе
			Для Каждого СтрокаТЗ Из ТаблицаКонтроль Цикл
				Если СтрокаТЗ.Пользователь = ТекущийПользователь Тогда
					ТаблицаКонтроль.Удалить(ТаблицаКонтроль.Индекс(СтрокаТЗ));
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Закрыть(Новый Структура("НаКонтроле, Комментарий", Ложь, Комментарий));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаТаблицаНаКонтроль

&НаСервере
// Процедура обновляет таблицу "На контроле" из регистра сведений.
//
//  Параметры:
//    Интерес - ИнтересСсылка - Ссылка на документ интерес.
//
Процедура ОбновитьТаблицуНаКонтроле(Интерес)
	
	ТаблицаКонтроль.Очистить();
	
	Запрос = Новый запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Объект КАК Объект,
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Пользователь КАК Пользователь,
	|	CRM_ИнтересыНаКонтролеСрезПоследних.СтатусКонтроля КАК Статус,
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Подразделение КАК Подразделение,
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Комментарий КАК Комментарий,
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Период КАК ДатаПринятияНаКонтроль
	|ИЗ
	|	РегистрСведений.CRM_ИнтересыНаКонтроле.СрезПоследних(&Период, ) КАК CRM_ИнтересыНаКонтролеСрезПоследних
	|ГДЕ
	|	CRM_ИнтересыНаКонтролеСрезПоследних.Объект = &Интерес
	|	И CRM_ИнтересыНаКонтролеСрезПоследних.СтатусКонтроля = &Статус
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПринятияНаКонтроль УБЫВ";
	
	Запрос.УстановитьПараметр("Интерес", Интерес);
	Запрос.УстановитьПараметр("Период", CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса());
	Запрос.УстановитьПараметр("Статус", ПредопределенноеЗначение("Перечисление.CRM_СтатусыКонтроляИнтереса.НаКонтроле"));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Если РезультатЗапроса.Количество() > 0 Тогда
		Для Каждого Выборка Из РезультатЗапроса Цикл
			НоваяСтрока = ТаблицаКонтроль.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти
