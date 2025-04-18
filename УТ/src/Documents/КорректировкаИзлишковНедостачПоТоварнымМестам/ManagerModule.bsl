#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("Обеспечение");
	МеханизмыДокумента.Добавить("СерийныйУчет");
	МеханизмыДокумента.Добавить("АдресныйСклад");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов - таблиц значений - данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.КорректировкаИзлишковНедостачПоТоварнымМестам") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаТоварныеМестаКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	ОтразитьРаспределениеЗапасовДвижения(Запрос, ТекстыЗапроса, Регистры);
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	ИменаРеквизитов = "Склад,Помещение,Дата";
	Возврат ИменаРеквизитов;
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//	Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
// 	см. НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.КорректировкаИзлишковНедостачПоТоварнымМестам";
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтражениеИзлишков);
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтражениеНедостач);
	ПараметрыУказанияСерий.ИспользоватьАдресноеХранение = Истина;
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Упаковка");
	ПараметрыУказанияСерий.ИмяПоляКоличество = "КоличествоУпаковок";	
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	ПараметрыУказанияСерий.ИмяПоляПомещение = "Помещение";
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	ПараметрыУказанияСерий.ТолькоСерииДляСебестоимости = Ложь;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 13
	|					ИНАЧЕ 14
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 9
	|					ИНАЧЕ 10
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
	|						ТОГДА ВЫБОР
	|								КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|									ТОГДА 5
	|								ИНАЧЕ 6
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 7
	|							ИНАЧЕ 8
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
	|				И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 3
	|					ИНАЧЕ 4
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	ТоварыДляЗапроса КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО (&Склад = Склады.Ссылка)
	|		ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|			И Товары.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статусы.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Инициализирует параметры, обслуживающие выбор назначений в формах документа.
//
//  Возвращаемое значение:
//  См. Справочники.Назначения.МакетФормыВыбораНазначений
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы);
	ШаблонНазначения.ДвиженияПоСкладскимРегистрам = "ИСТИНА";
	
	// Потребности в товарах на складе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказов", Истина, "Объект.Товары.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("Потребность").Пометка = Истина;
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Товары.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Товары.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Склад            = "Объект.Склад";
	
	Возврат МакетФормы;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Используется в механизмах обновления ИБ
//
// Параметры:
//  ИмяРегистра	 - Строка	 - имя регистра.
//
// Возвращаемое значение:
//  Соответствие -
//
Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КорректировкаИзлишковНедостачПоТоварнымМестам.Дата КАК Период,
	|	КорректировкаИзлишковНедостачПоТоварнымМестам.Склад КАК Склад,
	|	КорректировкаИзлишковНедостачПоТоварнымМестам.Помещение КАК Помещение
	|ИЗ
	|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам КАК КорректировкаИзлишковНедостачПоТоварнымМестам
	|ГДЕ
	|	КорректировкаИзлишковНедостачПоТоварнымМестам.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",      Реквизиты.Период);
	Запрос.УстановитьПараметр("Склад", Реквизиты.Склад);
	Запрос.УстановитьПараметр("Помещение", Реквизиты.Помещение);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыКОформлениюИзлишковНедостач";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение,
	|	ВтТовары.Номенклатура КАК Номенклатура,
	|	ВтТовары.Характеристика КАК Характеристика,
	|	ВтТовары.Назначение КАК Назначение,
	|	ВЫБОР
	|		КОГДА ВтТовары.СтатусУказанияСерий = 14
	|			ТОГДА ВтТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ВтТовары.Количество КАК КОформлениюАктов
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|ГДЕ
	|	ВтТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	&Период,
	|	&Склад,
	|	&Помещение,
	|	ВтТовары.Номенклатура,
	|	ВтТовары.Характеристика,
	|	ВтТовары.Назначение,
	|	ВЫБОР
	|		КОГДА ВтТовары.СтатусУказанияСерий = 14
	|			ТОГДА ВтТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ВтТовары.Количество
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|ГДЕ
	|	ВтТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура КАК Номенклатура,
	|	ТаблицаСерии.Характеристика КАК Характеристика,
	|	ТаблицаСерии.Назначение КАК Назначение,
	|	ТаблицаСерии.Серия КАК Серия,
	|	ТаблицаСерии.Количество КАК Количество,
	|	&Ссылка КАК Документ,
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	&Склад КАК Отправитель,
	|	&Помещение КАК ПомещениеОтправителя,
	|	НЕОПРЕДЕЛЕНО КАК Получатель,
	|	НЕОПРЕДЕЛЕНО КАК ПомещениеПолучателя,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтражениеИзлишков) КАК СкладскаяОперация,
	|	ЛОЖЬ КАК ЭтоСкладскоеДвижение
	|ИЗ
	|	ВтТовары КАК ТаблицаСерии
	|ГДЕ
	|	ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	И ТаблицаСерии.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура,
	|	ТаблицаСерии.Характеристика,
	|	ТаблицаСерии.Назначение,
	|	ТаблицаСерии.Серия,
	|	-ТаблицаСерии.Количество,
	|	&Ссылка,
	|	&Период,
	|	&Ссылка,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	&Склад,
	|	&Помещение,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтражениеНедостач),
	|	ЛОЖЬ
	|ИЗ
	|	ВтТовары КАК ТаблицаСерии
	|ГДЕ
	|	ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	И ТаблицаСерии.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыНаСкладах";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВтТовары.Номенклатура КАК Номенклатура,
	|	ВтТовары.Характеристика КАК Характеристика,
	|	ВтТовары.Назначение КАК Назначение,
	|	ВЫБОР
	|		КОГДА ВтТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ВтТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ВтТовары.Количество КАК ВНаличии,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|ГДЕ
	|	ВтТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВтТовары.Номенклатура,
	|	ВтТовары.Характеристика,
	|	ВтТовары.Назначение,
	|	ВЫБОР
	|		КОГДА ВтТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ВтТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВтТовары.Количество,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Период,
	|	&Склад,
	|	&Помещение
	|ИЗ
	|	ВтТовары КАК ВтТовары
	|ГДЕ
	|	ВтТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварныеМестаКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварныеМестаКОтражениюИзлишковНедостач";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 	
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.КоличествоУпаковок КАК Количество,
	|	ТаблицаТовары.Упаковка КАК ТоварноеМесто
	|ИЗ
	|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Период,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	&Склад,
	|	&Помещение,
	|	ТаблицаТовары.Назначение,
	|	ТаблицаТовары.Серия,
	|	ТаблицаТовары.КоличествоУпаковок,
	|	ТаблицаТовары.Упаковка
	|ИЗ
	|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтТовары";
			
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Назначение,
	|	Таблица.Серия,
	|	Таблица.СтатусУказанияСерий,
	|	СУММА(ТаблицаТовары.Количество) КАК Количество,
	|	ТаблицаТовары.ВидОперации
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Ссылка КАК Ссылка,
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		ТаблицаТовары.Характеристика КАК Характеристика,
	|		ТаблицаТовары.Назначение КАК Назначение,
	|		ТаблицаТовары.Серия КАК Серия,
	|		МАКСИМУМ(ТаблицаТовары.Упаковка) КАК Упаковка,
	|		ТаблицаТовары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|		ТаблицаТовары.ВидОперации КАК ВидОперации
	|	ИЗ
	|		Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка = &Ссылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаТовары.Ссылка,
	|		ТаблицаТовары.Номенклатура,
	|		ТаблицаТовары.Характеристика,
	|		ТаблицаТовары.Назначение,
	|		ТаблицаТовары.Серия,
	|		ТаблицаТовары.СтатусУказанияСерий,
	|		ТаблицаТовары.ВидОперации) КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТаблицаТовары
	|		ПО Таблица.Ссылка = ТаблицаТовары.Ссылка
	|			И Таблица.Номенклатура = ТаблицаТовары.Номенклатура
	|			И Таблица.Характеристика = ТаблицаТовары.Характеристика
	|			И Таблица.Серия = ТаблицаТовары.Серия
	|			И Таблица.Назначение = ТаблицаТовары.Назначение
	|			И Таблица.Упаковка = ТаблицаТовары.Упаковка
	|			И Таблица.ВидОперации = ТаблицаТовары.ВидОперации
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Назначение,
	|	Таблица.Серия,
	|	Таблица.СтатусУказанияСерий,
	|	ТаблицаТовары.ВидОперации";
		
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ОтразитьРаспределениеЗапасовДвижения(Запрос, ТекстыЗапроса, Регистры)
	
	ТекстЗапросаТабЧасть =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка               КАК Ссылка,
		|	ТабЧасть.Ссылка.Дата          КАК Период,
		|	ТабЧасть.Номенклатура         КАК Номенклатура,
		|	ТабЧасть.Характеристика       КАК Характеристика,
		|	ТабЧасть.Ссылка.Склад         КАК Склад,
		|	ТабЧасть.Назначение           КАК Назначение,
		|	ТабЧасть.Количество           КАК Количество,
		|	НЕОПРЕДЕЛЕНО                  КАК ЗапланированныйРасходРаспределенногоЗапаса,
		|	ЛОЖЬ                          КАК КонтрольСвободногоОстатка
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
		|		И ЕСТЬNULL(ТабЧасть.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)";
	
	РаспределениеЗапасовДвижения.РасходЗапаса(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаТабЧасть);
	
	ТекстЗапросаТабЧасть =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка               КАК Ссылка,
		|	ТабЧасть.Ссылка.Дата          КАК Период,
		|	ТабЧасть.Номенклатура         КАК Номенклатура,
		|	ТабЧасть.Характеристика       КАК Характеристика,
		|	ТабЧасть.Ссылка.Склад         КАК Склад,
		|	ТабЧасть.Назначение           КАК Назначение,
		|	ТабЧасть.Количество           КАК Количество,
		|	ЛОЖЬ                          КАК ПоГрафику,
		|	НЕОПРЕДЕЛЕНО                  КАК РаспоряжениеВГрафике
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
		|		И ЕСТЬNULL(ТабЧасть.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)";
	
	РаспределениеЗапасовДвижения.ПриходЗапаса(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаТабЧасть, Неопределено, Ложь);
	
	ТекстТоварныеМеста =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	ТабЧасть.ВидОперации КАК ВидОперации,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка
		|ПОМЕСТИТЬ ТоварныеМеста
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка В(&Ссылка)
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия,
		|	ТабЧасть.ВидОперации
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка, Номенклатура, Характеристика, Назначение, Серия, ВидОперации, Упаковка";
		
	ТекстыШаблоновВременныхТаблиц = Новый Структура();
	ТекстыШаблоновВременныхТаблиц.Вставить("ТоварныеМеста", ТекстТоварныеМеста);
	
	ТекстЗапросаТабЧасть =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Ссылка.Дата КАК Период,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Ссылка.Склад КАК Склад,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Количество КАК Количество,
		|	НЕОПРЕДЕЛЕНО КАК ЗапланированныйРасходРаспределенногоЗапаса,
		|	ЛОЖЬ КАК КонтрольСвободногоОстатка
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварныеМеста КАК ТоварныеМеста
		|		ПО ТабЧасть.Ссылка = ТоварныеМеста.Ссылка
		|		 И ТабЧасть.Номенклатура = ТоварныеМеста.Номенклатура
		|		 И ТабЧасть.Характеристика = ТоварныеМеста.Характеристика
		|		 И ТабЧасть.Назначение = ТоварныеМеста.Назначение
		|		 И ТабЧасть.Серия = ТоварныеМеста.Серия
		|		 И ТабЧасть.Упаковка = ТоварныеМеста.Упаковка
		|		 И ТабЧасть.ВидОперации = ТоварныеМеста.ВидОперации
		|ГДЕ
		|	ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)";
		
	РаспределениеЗапасовДвижения.РасходЗапаса(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаТабЧасть, ТекстыШаблоновВременныхТаблиц);
	
	ТекстЗапросаТабЧасть =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Ссылка.Дата КАК Период,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Ссылка.Склад КАК Склад,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Количество КАК Количество,
		|	ЛОЖЬ КАК ПоГрафику,
		|	НЕОПРЕДЕЛЕНО КАК РаспоряжениеВГрафике
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварныеМеста КАК ТоварныеМеста
		|		ПО ТабЧасть.Ссылка = ТоварныеМеста.Ссылка
		|		 И ТабЧасть.Номенклатура = ТоварныеМеста.Номенклатура
		|		 И ТабЧасть.Характеристика = ТоварныеМеста.Характеристика
		|		 И ТабЧасть.Назначение = ТоварныеМеста.Назначение
		|		 И ТабЧасть.Серия = ТоварныеМеста.Серия
		|		 И ТабЧасть.Упаковка = ТоварныеМеста.Упаковка
		|		 И ТабЧасть.ВидОперации = ТоварныеМеста.ВидОперации
		|ГДЕ
		|	ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)";
	
	РаспределениеЗапасовДвижения.ПриходЗапаса(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаТабЧасть,
		ТекстыШаблоновВременныхТаблиц, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
