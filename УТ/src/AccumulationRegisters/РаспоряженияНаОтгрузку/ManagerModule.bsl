#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора		 - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//  ОтборПоИзмерениям	 - Структура - ключ структуры определяет имя измерения, по которому будет накладываться отбор,
//  									а значение структуры - искомое значение.
//  ИсключитьЗаказ		 - Булево - Признак исключающий заказ из списка оформленных накладных.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора, ОтборПоИзмерениям = Неопределено, ИсключитьЗаказ = Ложь) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|//////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрРаспоряжения.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрРаспоряжения.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрРаспоряжения.Склад)          КАК Склад,
		|	МАКСИМУМ(РегистрРаспоряжения.Серия)          КАК Серия,
		|
		|	СУММА(ВЫБОР КОГДА РегистрРаспоряжения.ВидДвиженияРегистра = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияНакопления.Расход) ТОГДА
		
		
		|				-РегистрРаспоряжения.КОформлению
		
		
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК Количество,
		|	СУММА(ВЫБОР КОГДА РегистрРаспоряжения.ВидДвиженияРегистра = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияНакопления.Приход) ТОГДА
		
		
		|				РегистрРаспоряжения.КОформлению
		
		
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоПриход,
		|	СУММА(ВЫБОР КОГДА РегистрРаспоряжения.ВидДвиженияРегистра = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияНакопления.Расход)
		|			И -РегистрРаспоряжения.КОформлению > 0 И НЕ Расхождения.Ссылка ЕСТЬ NULL ТОГДА
		|				РегистрРаспоряжения.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоКорректировка
		|ИЗ
		|	ВтОтбор КАК Отбор
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РаспоряженияНаОтгрузку КАК РегистрРаспоряжения
		|		ПО РегистрРаспоряжения.Распоряжение = Отбор.Ссылка
		|		 И РегистрРаспоряжения.КодСтроки = Отбор.КодСтроки
		|		 И РегистрРаспоряжения.ВидДвиженияРегистра = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияНакопления.Расход)
		|		 И (РегистрРаспоряжения.КОформлению <> 0
		
		
		|			ИЛИ ЛОЖЬ)
		|		 И РегистрРаспоряжения.Активность
		|		 И &Отбор1
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаРеализации.Расхождения КАК Расхождения
		|		ПО Расхождения.Ссылка = РегистрРаспоряжения.Регистратор
		|		 И Расхождения.ЗаказКлиента = РегистрРаспоряжения.Распоряжение
		|		 И Расхождения.КодСтроки = РегистрРаспоряжения.КодСтроки
		|		 И Расхождения.ВариантОтражения
		|			= ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокРеализаций.УменьшитьРеализациюУчестьПриИнвентаризации)
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Отбор = Новый Массив;
	Если ИсключитьЗаказ Тогда
		Отбор.Добавить("РегистрРаспоряжения.Распоряжение <> РегистрРаспоряжения.Регистратор");
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
			Отбор.Добавить("РегистрРаспоряжения." + КлючЗначение.Ключ + " В(&" + КлючЗначение.Ключ + ")");
		КонецЦикла;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отбор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &Отбор1", "И " + СтрСоединить(Отбор, " И "));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &Отбор1", "");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");

	Возврат Таблица;

КонецФункции

#КонецОбласти


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт 

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Распоряжение.Организация)
	|	И ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(Распоряжение.Партнер)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиПартнеры
	|	ПО ВнешниеПользователиПартнеры.ОбъектАвторизации = ЭтотСписок.Распоряжение.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВнешниеПользователиПартнеры.Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Текст запроса получает остаток по ресурсам КОформлению и Заказано
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор.
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Ресурсы				 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//   - Строка - 
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", ОтборПоИзмерениям = Неопределено, Ресурсы = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Набор.Распоряжение          КАК Распоряжение,
	|	Набор.Номенклатура          КАК Номенклатура,
	|	Набор.Характеристика        КАК Характеристика,
	|	Набор.КодСтроки             КАК КодСтроки,
	|	Набор.Серия                 КАК Серия,
	|	Набор.Склад                 КАК Склад,
	|	СУММА(Набор.Заказано)       КАК Заказано,
	|	СУММА(Набор.КОформлению)    КАК КОформлению,
	|	СУММА(Набор.КПередаче)      КАК КПередаче
	|ПОМЕСТИТЬ ИмяТаблицы
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Склад                 КАК Склад,
	|		Таблица.ЗаказаноОборот        КАК Заказано,
	|		Таблица.КОформлениюОборот     КАК КОформлению,
	|		Таблица.КПередачеОборот       КАК КПередаче
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку.Обороты(,,, &ОтборПоИзмерениям) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.Распоряжение          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Склад                 КАК Склад,
	|		-Таблица.Заказано              КАК Заказано,
	|		-Таблица.КОформлению           КАК КОформлению,
	|		-Таблица.КПередаче             КАК КПередаче
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор = &Регистратор
	|		И ВидДвиженияРегистра = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияНакопления.Расход)
	|		И &ОтборПоИзмерениям
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	Набор.Распоряжение,
	|	Набор.Номенклатура,
	|	Набор.Характеристика,
	|	Набор.КодСтроки,
	|	Набор.Серия,
	|	Набор.Склад
	|
	|,&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	КодСтроки";
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "");
	КонецЕсли;
	
	ТекстОтбораПоИзмерениям = ОбщегоНазначенияУТ.ТекстОтбораПоКоллекцииОтборов(ОтборПоИзмерениям);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоИзмерениям", ТекстОтбораПоИзмерениям);
	
	Если Не ПустаяСтрока(Ресурсы) Тогда
		
		Если СтрНайти(Ресурсы, "КОформлению") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "КОформлению", "СУММА(Набор.КОформлению)");
		КонецЕсли;
		Если СтрНайти(Ресурсы, "Заказано") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "Заказано", "СУММА(Набор.Заказано)");
		КонецЕсли;
		
		Если СтрНайти(Ресурсы, "КПередаче") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "КПередаче", "СУММА(Набор.КПередаче)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Ресурсы);
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции  

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РаспоряженияНаОтгрузку.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.18.9";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("417c4cfa-4a72-4d6c-8470-db93bd907396");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РаспоряженияНаОтгрузку.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет регистр накопления ""Распоряжения на отгрузку"" на основании регистра ""Заказы клиентов"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.УдалитьЗаказыКлиентов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РаспоряженияНаОтгрузку.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.РаспоряженияНаОтгрузку";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказыКлиентов.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.УдалитьЗаказыКлиентов КАК ЗаказыКлиентов
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РаспоряженияНаОтгрузку КАК РаспоряженияНаОтгрузку
	|	ПО ЗаказыКлиентов.Регистратор = РаспоряженияНаОтгрузку.Регистратор
	|ГДЕ
	|	РаспоряженияНаОтгрузку.Регистратор Есть NULL";
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = Метаданные.РегистрыНакопления.РаспоряженияНаОтгрузку.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущиеДанные Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.РаспоряженияНаОтгрузку.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ТекущиеДанные.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			НаборЗаписейЗаказы = РегистрыНакопления.УдалитьЗаказыКлиентов.СоздатьНаборЗаписей();
			НаборЗаписейЗаказы.Отбор.Регистратор.Установить(ТекущиеДанные.Регистратор);
			НаборЗаписейЗаказы.Прочитать();
			
			НаборЗаписей = РегистрыНакопления.РаспоряженияНаОтгрузку.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущиеДанные.Регистратор);
			
			Для каждого ЗаписьЗаказы Из НаборЗаписейЗаказы Цикл
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, ЗаписьЗаказы);
				Запись.Распоряжение = ЗаписьЗаказы.ЗаказКлиента;
				Если ЗаписьЗаказы.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
					Запись.ВидДвиженияРегистра = Перечисления.ВидыДвиженияНакопления.Приход;
				Иначе
					Запись.ВидДвиженияРегистра = Перечисления.ВидыДвиженияНакопления.Расход;
					Запись.Заказано = -ЗаписьЗаказы.Заказано;
					Запись.КОформлению = -ЗаписьЗаказы.КОформлению;
					Запись.КПередаче = -ЗаписьЗаказы.КПередаче;
					Запись.Сумма = -ЗаписьЗаказы.Сумма;
				КонецЕсли;
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ТекущиеДанные.Регистратор);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
