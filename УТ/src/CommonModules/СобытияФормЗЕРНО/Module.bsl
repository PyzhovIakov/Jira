#Область ПрограммныйИнтерфейс

#Область Локализация

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции);
	ДобавитьРеквизитТекстСостояниеЗЕРНО(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	
КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	СобытияФормИС.ВстроитьСтрокуИнтеграцииВДокументОснованиеПоПараметрам(Форма, "ЗЕРНО.ДокументОснование");
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	ИмяРеквизитаФормыОбъект = Форма.ПараметрыИнтеграцииГосИС.Получить("ЗЕРНО").ИмяРеквизитаФормыОбъект;
	
	Общие = Форма.ПараметрыИнтеграцииГосИС.Получить("ИС.ДокументОснование");
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЗЕРНО.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		Если ЗначениеЗаполнено(Форма[Общие.ИмяРеквизитаФормы]) Тогда
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = Ложь;
		Иначе
			ТекстНадписи = ИнтеграцияЗЕРНОВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Форма[ИмяРеквизитаФормыОбъект].Ссылка);
			Форма[ПараметрыИнтеграции.ИмяРеквизитаФормы] = ТекстНадписи;
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = ЗначениеЗаполнено(ТекстНадписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусыОформления(Ссылка, ПараметрыИнтеграцииГосИС, РеквизитыФормыСтатусовОформления) Экспорт
	
	ПараметрыИнтеграции = ПараметрыИнтеграцииГосИС.Получить("ЗЕРНО.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		ТекстНадписи = ИнтеграцияЗЕРНОВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Ссылка);
		РеквизитыФормыСтатусовОформления.Вставить(ПараметрыИнтеграции.ИмяРеквизитаФормы, ТекстНадписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	СобытияФормЗЕРНОПереопределяемый.ПослеЗаписиНаСервере(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормЗЕРНОПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормЗЕРНОПереопределяемый.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормЗЕРНОПереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область Номенклатура

// Выполняет действия при изменении номенклатуры в шапке документа.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие.
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке.
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы.
Процедура ПриИзмененииНоменклатурыВШапке(Форма, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СтруктураЗаполнения = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьСтруктуруЗаполненияСлужебныхРеквизитовНоменклатуры();
	ЗаполнитьЗначенияСвойств(СтруктураЗаполнения, Форма);
	ЗаполнитьЗначенияСвойств(СтруктураЗаполнения, Форма.Объект, "Количество, КоличествоЗЕРНО");
	
	СобытияФормЗЕРНОПереопределяемый.ПриИзмененииНоменклатуры(
		Форма, СтруктураЗаполнения, КэшированныеЗначения, ПараметрыУказанияСерий);
	
	ЗаполнитьЗначенияСвойств(Форма, СтруктураЗаполнения);
	ЗаполнитьЗначенияСвойств(Форма.Объект, СтруктураЗаполнения, "Количество, КоличествоЗЕРНО");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ФормыСписковДокументовЗЕРНО

Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(Форма, Знач ЗначениеПрефиксы = Неопределено) Экспорт
	
//	УстановитьПривилегированныйРежим(Истина);
//	
//	Если ЗначениеПрефиксы = Неопределено Тогда
//		Префиксы = Новый Массив;
//		Префиксы.Добавить("Оформлено");
//		Префиксы.Добавить("КОформлению");
//	Иначе
//		Если ТипЗнч(ЗначениеПрефиксы) = Тип("Строка") Тогда
//			Префиксы = Новый Массив();
//			Префиксы.Добавить(ЗначениеПрефиксы);
//		Иначе
//			Префиксы = ЗначениеПрефиксы;
//		КонецЕсли;
//	КонецЕсли;
//	
//	Для Каждого Значение Из Префиксы Цикл
//		Форма.Элементы[Значение + "Организация"].СписокВыбора.Очистить();
//		Форма.Элементы[Значение + "Организации"].СписокВыбора.Очистить();
//	КонецЦикла;
//	
//	ПараметрыОтбора = Новый Структура("КлючОбъекта", "ОбщаяФорма.ФормаВыбораСпискаОрганизацийЗЕРНО");
//	
//	Выборка = ХранилищеНастроекДанныхФорм.Выбрать(ПараметрыОтбора);
//	
//	Пока Выборка.Следующий() Цикл
//		
//		Данные = Новый Массив;
//		Значение = Выборка.Настройки.Получить("ТаблицаОрганизации");
//		Если Значение <> Неопределено Тогда
//			
//			ПараметрыОтбора = Новый Структура;
//			ПараметрыОтбора.Вставить("Выбрана", Истина);
//			НайденныеСтроки = Значение.НайтиСтроки(ПараметрыОтбора);
//			
//			Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
//				Данные.Добавить(СтрокаТЧ.Организация);
//			КонецЦикла;
//			
//			Для Каждого Значение Из Префиксы Цикл
//				ЭлементОтбораОрганизация = Форма.Элементы.Найти(Значение + "Организация");
//				Если ЭлементОтбораОрганизация <> Неопределено Тогда
//					ЭлементОтбораОрганизация.СписокВыбора.Добавить(Данные, СтрСоединить(Данные, "; "));
//				КонецЕсли;
//		
//				ЭлементОтбораОрганизации = Форма.Элементы.Найти(Значение + "Организации");
//				Если ЭлементОтбораОрганизации <> Неопределено Тогда
//					ЭлементОтбораОрганизации.СписокВыбора.Добавить(Данные, СтрСоединить(Данные, "; "));
//				КонецЕсли;
//			КонецЦикла;
//			
//		КонецЕсли;
//		
//	КонецЦикла;
	
КонецПроцедуры

// Дорабатывает форму списка документов:
//   * Добавляет необходимые отборы
//   * Скрывает списки к оформлению при необходимости.
//
// Параметры:
//   Форма     - ФормаКлиентскогоПриложения - форма списка документов ЗЕРНО.
//   Настройки - Структура        - (См. ИнтеграцияИС.НастройкиФормыСпискаДокументов).
//             - Неопределено     - будут использованы значения по умолчанию описанные здесь.
//
Процедура ПриСозданииНаСервереФормыСпискаДокументов(Форма, Настройки = Неопределено) Экспорт
	
	Если Настройки = Неопределено Тогда
		Настройки = ИнтеграцияИС.НастройкиФормыСпискаДокументов();
		Настройки.ТипыКОформлению = Метаданные.ОпределяемыеТипы.ДокументыЗЕРНОПоддерживающиеСтатусыОформления;
		Настройки.ТипыКОбмену     = Метаданные.ОпределяемыеТипы.ДокументыЗЕРНО;
	КонецЕсли;
	ИнтеграцияИС.ПриСозданииНаСервереФормыСпискаДокументов(Форма, Настройки);
	
КонецПроцедуры

// Дорабатывает форму списка справочников:
//   * Добавляет необходимые отборы
//
// Параметры:
//   Форма     - ФормаКлиентскогоПриложения - форма списка документов ЗЕРНО.
//
Процедура ПриСозданииНаСервереФормыСпискаСправочников(Форма) Экспорт
	
	ИнтеграцияИС.ПриСозданииНаСервереФормыСпискаСправочников(Форма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УсловноеОформление

// Устанавливает условное оформление для поля "Количество".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление.
//  ИмяПоляКоличество - Строка - имя элемента формы "Количество".
//  ПутьКПолюНоменклатура - Строка - полный путь к реквизиту "Номенклатура".
Процедура УстановитьУсловноеОформлениеКоличестваДляПустойНоменклатуры(
	Форма,
	ИмяПоляКоличество = "ТоварыКоличество",
	ПутьКПолюНоменклатура = "Объект.Товары.Номенклатура") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляКоличество].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюНоменклатура);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "ОКПД2".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить условное оформление.
//  ИмяПоляОКПД2 - Строка - имя элемента формы "Количество".
//  ПутьКПолюПредставление - Строка - полный путь к реквизиту "ОКПД2Представление".
Процедура УстановитьУсловноеОформлениеОКПД2(
	Форма,
	ИмяПоляОКПД2 = "ТоварыОКПД2",
	ПутьКПолюПредставление = "Объект.Товары.ОКПД2Представление") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляОКПД2].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюПредставление);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных(ПутьКПолюПредставление));
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеПотребительскогоСвойства(
	Форма,
	ИмяПоляПотребительскоеСвойствоЗначение = "ПотребительскиеСвойстваЗначение",
	ПутьКПолюЗначение = "Объект.ПотребительскиеСвойства.Значение") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляПотребительскоеСвойствоЗначение].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюЗначение);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ПредставлениеДиапазона");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ПредставлениеДиапазона"));
	
	// Представление 0 для типа число
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляПотребительскоеСвойствоЗначение].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюЗначение);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ПредставлениеДиапазона");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "0");
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеПотребительскогоСвойстваДиапазон(
	Форма,
	ИмяПоляПотребительскоеСвойствоЗначение = "ПотребительскиеСвойстваЗначение") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы      = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляПотребительскоеСвойствоЗначение].Имя);
	
	ГруппаОтбораОбщая = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораОбщая.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппаОтбораПеречисление = ГруппаОтбораОбщая.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораПеречисление.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораПеречисление.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ДиапазонИспользуется");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбораПеречисление.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.Значение");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ГруппаОтбораДиапазон = ГруппаОтбораОбщая.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораДиапазон.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбораДиапазон.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ДиапазонИспользуется");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ГруппаОтбораИли = ГруппаОтбораДиапазон.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбораИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ДиапазонС");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.Значение");
	
	ГруппаОтбораДиапазонПо = ГруппаОтбораИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораДиапазонПо.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораДиапазонПо.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ДиапазонПо");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ГруппаОтбораДиапазонПо.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.ДиапазонПо");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПотребительскиеСвойства.Значение");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДоступностьКомандыВыполнитьОбмен(Форма, ИмяЭлементаКомандыФормы = "СписокВыполнитьОбмен") Экспорт
	
	Элементы = Форма.Элементы;
	ДоступностьКомандыВыполнитьОбмен = Истина;
	
	Если Форма.Организации.Количество() = 0 Тогда
		ОрганизациияДляПроверки = ОбщегоНазначенияИС.ДоступныеОрганизации();
	Иначе
		ОрганизациияДляПроверки = Форма.Организации;
	КонецЕсли;
	
	Для Каждого ЭлементСпискаЗначений Из ОрганизациияДляПроверки Цикл
		Если ИнтеграцияЗЕРНОПовтИсп.ИспользоватьАвтоматическийОбменДанными(ЭлементСпискаЗначений.Значение) Тогда
			ДоступностьКомандыВыполнитьОбмен = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Элементы[ИмяЭлементаКомандыФормы].Видимость = ДоступностьКомандыВыполнитьОбмен;
	
КонецПроцедуры

#Область Локализация

Процедура ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции)
	
	ОбщиеНастройки = СобытияФормИС.ОбщиеПараметрыИнтеграции("СобытияФормЗЕРНО");
	ПараметрыИнтеграции.Вставить("ЗЕРНО", ОбщиеНастройки);
	
КонецПроцедуры

// Встраивает реквизит - форматированную строку перехода к ЗЕРНО в прикладные формы
// 
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - форма в которую происходит встраивание
//   ПараметрыИнтеграции  - см. ПараметрыИнтеграцииЗЕРНО
//   ДобавляемыеРеквизиты - Массив           - массив реквизитов формы к добавлению

Процедура ДобавитьРеквизитТекстСостояниеЗЕРНО(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	ПараметрыИнтеграцииЗЕРНО = ПараметрыИнтеграцииЗЕРНО(Форма);
	
	Если ЗначениеЗаполнено(ПараметрыИнтеграцииЗЕРНО.ИмяРеквизитаФормы) Тогда
		ПараметрыИнтеграции.Вставить("ЗЕРНО.ДокументОснование", ПараметрыИнтеграцииЗЕРНО);
		Реквизит = Новый РеквизитФормы(
			ПараметрыИнтеграцииЗЕРНО.ИмяРеквизитаФормы,
			Новый ОписаниеТипов("ФорматированнаяСтрока"),,
			ПараметрыИнтеграцииЗЕРНО.Заголовок);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции реквизитов ЗЕРНО
//   в прикладные формы конфигурации - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - форма для которой возвращаются параметры интеграции
//
// ВозвращаемоеЗначение:
//   Структура - (См. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Функция ПараметрыИнтеграцииЗЕРНО(Форма = Неопределено)
	
	ПараметрыНадписи = СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования();
	ПараметрыНадписи.Вставить("Ключ",              "ЗаполнениеТекстаДокументаЗЕРНО");
	ПараметрыНадписи.Вставить("МодульЗаполнения",  "СобытияФормЗЕРНО");
	ПараметрыНадписи.Вставить("ИмяЭлементаФормы",  "ТекстДокументаЗЕРНО");
	ПараметрыНадписи.Вставить("ИмяРеквизитаФормы", "ТекстДокументаЗЕРНО");
	
	Если НЕ(Форма = Неопределено) Тогда
		СобытияФормЗЕРНОПереопределяемый.ПриОпределенииПараметровИнтеграцииЗЕРНО(Форма, ПараметрыНадписи);
	КонецЕсли;
	
	Возврат ПараметрыНадписи;
	
КонецФункции

#КонецОбласти

#КонецОбласти