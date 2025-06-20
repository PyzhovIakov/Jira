#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Задача = Параметры.Задача;
	
	УчетВремениПараметр = Неопределено;
	Если Параметры.Свойство("УчетВремени", УчетВремениПараметр) Тогда
		УчетВремени = УчетВремениПараметр;
	КонецЕсли; 
	КонтрольВремениПараметр = Неопределено;
	Если Параметры.Свойство("КонтрольВремени", КонтрольВремениПараметр) Тогда
		КонтрольВремени = КонтрольВремениПараметр;
	КонецЕсли;
	
	Если УчетВремени Тогда
		ВвыводЧасов();	
	КонецЕсли;
	
	ВидимостьЭлементовЧасов();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОтменаЗакрытия(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	Если НЕ ЗначениеЗаполнено(Причина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не заполнена причина закрытия");
		Возврат;
	КонецЕсли;
	
	Если НЕ СобытияЗавершены Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("По задаче не введено событий, либо не все события завершены");
		Возврат;
	КонецЕсли;

	Если НЕ НеСогласовано Тогда
		Если КонтрольВремени Тогда
			Если СписанныеЧасы < СогласованныеЧасы Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Списаны не все согласованные часы");
				Возврат;
			ИначеЕсли СогласованныеЧасы = 0 И ТипОценки <> ПредопределенноеЗначение(
				"Перечисление.cbr_ТипОценкиЧасов.ПоФакту") Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не согласованы часы");
				Возврат;
			ИначеЕсли СписанныеЧасы = 0 И ТипОценки = ПредопределенноеЗначение("Перечисление.cbr_ТипОценкиЧасов.ПоФакту") Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Отсутствуют списанные часы");
				Возврат;
			КонецЕсли;
		ИначеЕсли УчетВремени Тогда
			Если СписанныеЧасы = 0  Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю("Отсутствуют списанные часы");
				Возврат;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
	ЗаписатьЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаписатьЗакрытьНаСервере()

	Док = Задача.ПолучитьОбъект();
	Док.ПричинаЗакрытия = Причина;
	Док.Записать(РежимЗаписиДокумента.Проведение);

	Подписка = ПредопределенноеЗначение(
		"Перечисление.cbr_ПодпискаДляТриггера.КнопкаЗакрытияЗадачи");
	cbr_ОбработкаТриггеровВызовСервера.ВызовТриггера(Подписка, Задача);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	cbr_Задача.Дата,
	|	cbr_Задача.Наименование,
	|	cbr_Задача.ВидЗадачи,
	|	cbr_Задача.Постановщик,
	|	cbr_Задача.ГлавныйМенеджер,
	|	cbr_Задача.ТребуетКонтроляПоЗавершению,
	|	cbr_Задача.КонтактноеЛицо
	|ИЗ
	|	Документ.cbr_Задача КАК cbr_Задача
	|ГДЕ
	|	cbr_Задача.Ссылка = &Задача";

	Запрос.УстановитьПараметр("Задача", Задача);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Если Выборка.Следующий() Тогда
		Если Выборка.ТребуетКонтроляПоЗавершению Тогда
			ПодчиненнаяЗадача = Документы.cbr_Задача.СоздатьДокумент();
			ПодчиненнаяЗадача.Дата = ТекущаяДатаСеанса();
			ПодчиненнаяЗадача.Наименование = "Поверка задачи " + Выборка.Наименование + " от " + Формат(Выборка.Дата,
				"ДФ=dd.MM.yyyy");
			ПодчиненнаяЗадача.ВидЗадачи = Выборка.ВидЗадачи;
			ПодчиненнаяЗадача.Постановщик = Выборка.Постановщик;
			ПодчиненнаяЗадача.ГлавнаяЗадача = Задача;
			ПодчиненнаяЗадача.Автор = Пользователи.АвторизованныйПользователь();			
			ДокФормат = Новый ФорматированныйДокумент();
			ПодчиненнаяЗадача.ОписаниеЗадачи = Новый ХранилищеЗначения(ДокФормат);
			Если ТипЗнч(Выборка.Постановщик) = Тип("СправочникСсылка.Партнеры") Тогда
				Исполнитель = Выборка.ГлавныйМенеджер;
				ПодчиненнаяЗадача.ГлавныйМенеджер = Выборка.ГлавныйМенеджер;
				ПодчиненнаяЗадача.КонтактноеЛицо = Выборка.КонтактноеЛицо;
			Иначе
				Исполнитель = Выборка.Постановщик;
			КонецЕсли;
			ПодчиненнаяЗадача.Приоритет = ПредопределенноеЗначение("Перечисление.cbr_ПриоритетыЗадач.Обычный");
			ПодчиненнаяЗадача.Записать(РежимЗаписиДокумента.Проведение);
			cbr_ДвиженияПоРегистрам.ДвижениеИсполнителиЗадач(ПодчиненнаяЗадача.Ссылка, Исполнитель, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВвыводЧасов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(cbr_ЧасыТрудозатрат.Часы, 0)) КАК Часы,
	|	cbr_ТрудозатратыПоЗадаче.Основание КАК Основание
	|ПОМЕСТИТЬ вт_ЧасыПоЗадаче
	|ИЗ
	|	Документ.cbr_ТрудозатратыПоЗадаче КАК cbr_ТрудозатратыПоЗадаче
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.cbr_ЧасыТрудозатрат КАК cbr_ЧасыТрудозатрат
	|		ПО cbr_ЧасыТрудозатрат.Регистратор = cbr_ТрудозатратыПоЗадаче.Ссылка
	|ГДЕ
	|	cbr_ТрудозатратыПоЗадаче.Основание = &Задача
	|	И cbr_ТрудозатратыПоЗадаче.Исполнитель = &ТекущийПользователь
	|СГРУППИРОВАТЬ ПО
	|	cbr_ТрудозатратыПоЗадаче.Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(вт_ЧасыПоЗадаче.Часы, 0) КАК Часы,
	|	cbr_ОценкаЧасовСрезПоследних.До КАК До,
	|	cbr_ОценкаЧасовСрезПоследних.ТипОценки КАК ТипОценки,
	|	cbr_ОценкаЧасовСрезПоследних.От КАК От,
	|	СУММА(ВЫБОР
	|		КОГДА cbr_Календарь.Предмет = &Задача
	|		И cbr_Календарь.Сотрудник = &ТекущийПользователь
	|		И НЕ cbr_Календарь.ПометкаУдаления
	|		И cbr_Календарь.Состояние = ЗНАЧЕНИЕ(Перечисление.cbr_СостояниеЗаписиРабочегоКалендаря.Завершена)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ) КАК КоличествоЗавершенныхЗаписейКалендаря,
	|	СУММА(ВЫБОР
	|		КОГДА cbr_Календарь.Предмет = &Задача
	|		И cbr_Календарь.Сотрудник = &ТекущийПользователь
	|		И НЕ cbr_Календарь.ПометкаУдаления
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ) КАК КоличествоЗаписейКалендаря,
	|	ЕСТЬNULL(ВЫБОР
	|		КОГДА cbr_ОценкаЧасовСрезПоследних.Согласовант = &ТекущийПользователь
	|			ТОГДА cbr_ОценкаЧасовСрезПоследних.Согласовано
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ, ЛОЖЬ) КАК Согласовано
	|ИЗ
	|	РегистрСведений.cbr_ОценкаЧасов.СрезПоследних(, Задача = &Задача) КАК cbr_ОценкаЧасовСрезПоследних
	|		ПОЛНОЕ СОЕДИНЕНИЕ вт_ЧасыПоЗадаче КАК вт_ЧасыПоЗадаче
	|		ПО вт_ЧасыПоЗадаче.Основание = cbr_ОценкаЧасовСрезПоследних.Задача
	|		И cbr_ОценкаЧасовСрезПоследних.Согласовано
	|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.cbr_Календарь КАК cbr_Календарь
	|		ПО cbr_Календарь.Предмет = cbr_ОценкаЧасовСрезПоследних.Задача
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(вт_ЧасыПоЗадаче.Часы, 0),
	|	cbr_ОценкаЧасовСрезПоследних.До,
	|	cbr_ОценкаЧасовСрезПоследних.ТипОценки,
	|	cbr_ОценкаЧасовСрезПоследних.От,
	|	ЕСТЬNULL(ВЫБОР
	|		КОГДА cbr_ОценкаЧасовСрезПоследних.Согласовант = &ТекущийПользователь
	|			ТОГДА cbr_ОценкаЧасовСрезПоследних.Согласовано
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ, ЛОЖЬ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	До УБЫВ";

	Запрос.УстановитьПараметр("Задача", Задача);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.АвторизованныйПользователь());

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СогласованныеЧасыСтрока = "0";
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СписанныеЧасы = ВыборкаДетальныеЗаписи.Часы;
		Если КонтрольВремени Тогда
			Если ВыборкаДетальныеЗаписи.КоличествоЗавершенныхЗаписейКалендаря
				= ВыборкаДетальныеЗаписи.КоличествоЗаписейКалендаря
				И ВыборкаДетальныеЗаписи.КоличествоЗавершенныхЗаписейКалендаря > 0 Тогда
				СобытияЗавершены = Истина;
			КонецЕсли;
			
			Если Не ВыборкаДетальныеЗаписи.Согласовано Тогда
				НеСогласовано = Истина;
			КонецЕсли;
			
			ТипОценки = ВыборкаДетальныеЗаписи.ТипОценки;
			Если ВыборкаДетальныеЗаписи.ТипОценки = ПредопределенноеЗначение("Перечисление.cbr_ТипОценкиЧасов.Точная") И ВыборкаДетальныеЗаписи.Согласовано Тогда
				СогласованныеЧасы = ВыборкаДетальныеЗаписи.До;
				СогласованныеЧасыСтрока = ВыборкаДетальныеЗаписи.До;
			ИначеЕсли ВыборкаДетальныеЗаписи.ТипОценки = ПредопределенноеЗначение(
				"Перечисление.cbr_ТипОценкиЧасов.Рамочная") И ВыборкаДетальныеЗаписи.Согласовано Тогда
				СогласованныеЧасы = ВыборкаДетальныеЗаписи.От;
				СогласованныеЧасыСтрока = "от " + ВыборкаДетальныеЗаписи.От + " до " + ВыборкаДетальныеЗаписи.До;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидимостьЭлементовЧасов()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СогласованныеЧасыСтрока", "Видимость", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписанныеЧасы", "Видимость", Ложь);	
	
	Если КонтрольВремени Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СогласованныеЧасыСтрока", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписанныеЧасы", "Видимость", Истина);	
	ИначеЕсли УчетВремени Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписанныеЧасы", "Видимость", Истина);		
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти