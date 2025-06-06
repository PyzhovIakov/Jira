////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для обработки действий пользователя
// в процессе работы с ценами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Рассчитывает сумму НДС от суммы в зависимости от включения НДС в цену.
//
// Параметры:
//  Сумма           - Число - Сумма, от которой необходимо рассчитать сумму НДС.
//  СтавкаНДС       - СправочникСсылка.СтавкиНДС - Ставка НДС.
//  ЦенаВключаетНДС - Булево - Признак включения НДС в цену.
//  НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - налогообложение документа
//
// Возвращаемое значение:
//  Число - Сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, СтавкаНДС, ЦенаВключаетНДС = Истина, НалогообложениеНДС = Неопределено) Экспорт
	
	Возврат УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(
		Сумма,
		УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтавкаНДС),
		ЦенаВключаетНДС,
		НалогообложениеНДС)
	
КонецФункции // РассчитатьСуммуНДС()

// Возвращает числовое значение ставки НДС
//
// Параметры:
//  СтавкаНДС - СправочникСсылка.СтавкиНДС - значение СтавкиНДС.
//
// Возвращаемое значение:
//  Число - Значение ставки НДС числом.
//
Функция ПолучитьСтавкуНДСЧислом(Знач СтавкаНДС) Экспорт
	
	Возврат УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтавкаНДС);
	
КонецФункции // ПолучитьСтавкуНДСЧислом()

#Область ПроцедурыИФункцииРаботыСИтогамиДокументов

// Возвращает сумму документа с учетом НДС
//
// Параметры:
//  Товары          - ТабличнаяЧасть - табличная часть документа для подсчета суммы документа.
//  ЦенаВключаетНДС - Булево - признак включения НДС в цену документа.
//
// Возвращаемое значение:
//  Число - Сумма документа с учетом НДС/.
//
Функция ПолучитьСуммуДокумента(Товары, Знач ЦенаВключаетНДС) Экспорт

	СуммаДокумента = Товары.Итог("Сумма");

	Если Не ЦенаВключаетНДС Тогда
		СуммаДокумента = СуммаДокумента + Товары.Итог("СуммаНДС");
	КонецЕсли;

	Возврат СуммаДокумента;

КонецФункции // ПолучитьСуммуДокумента()

#КонецОбласти

#Область ПроцедурыИФункцииДляВыполненияОкругления

// Округляет число по заданному порядку 
//
// Параметры:
//  Число              - Число - исходное число.
//  ТочностьОкругления - Число - Число, определяет точность округления.
//  ВариантОкругления  - ПеречислениеСсылка.ВариантыОкругления - определяет способ округления.
//
// Возвращаемое значение:
//  Число - исходное число, округленное с заданной точностью.
//
Функция ОкруглитьЦену(Число, ТочностьОкругления, ВариантОкругления) Экспорт

	Перем Результат;
		
	// вычислим количество интервалов, входящих в число
	Если ТочностьОкругления <> 0 Тогда
		КоличествоИнтервалов = Число / ТочностьОкругления;
	Иначе
		КоличествоИнтервалов = 0;
	КонецЕсли;
	
	// вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервалов);
		
	Если КоличествоИнтервалов = КоличествоЦелыхИнтервалов Тогда
		// Числа поделились нацело. Округлять не нужно.
		Результат = Число;
	Иначе
		Если ВариантОкругления = ПредопределенноеЗначение("Перечисление.ВариантыОкругления.ВсегдаВПользуПредприятия") Тогда
			// При порядке округления "0.05" 0.371 должно округлится до 0.4
			Результат = ТочностьОкругления * (КоличествоЦелыхИнтервалов + 1);
		ИначеЕсли ВариантОкругления = ПредопределенноеЗначение("Перечисление.ВариантыОкругления.ВсегдаВПользуКлиента") Тогда
			// При порядке округления "0.05" 0.371 должно округлится до 0.35
			Результат = ТочностьОкругления * (КоличествоЦелыхИнтервалов);
		Иначе
			// При порядке округления "0.05" 0.371 должно округлится до 0.35,
			// а 0.376 до 0.4.
			Результат = ТочностьОкругления * Окр(КоличествоИнтервалов, 0, РежимОкругления.Окр15как20);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ОкруглитьЦену()

// Применяет "психологическое округление" к числу
//
// Параметры:
//  Число                     - Число - число, к которому применяется округление.
//  ПсихологическоеОкругление - Число - число, значение "психологического округления".
//
// Возвращаемое значение:
//  Число - Результат применения "психологического округления" к числу.
//
Функция ПрименитьПсихологическоеОкругление(Число, ПсихологическоеОкругление) Экспорт
	
	Если Число = 0 ИЛИ ПсихологическоеОкругление = 0 Тогда
		Возврат Число;
	Иначе
		РезультатОкругления = Число - ПсихологическоеОкругление;
		Возврат ?(РезультатОкругления < Число, РезультатОкругления, Число);
	КонецЕсли;
	
КонецФункции // ПрименитьПсихологическоеОкругление()

#КонецОбласти

#Область ПроцедурыИФункцииПодменыТекстовЗапросов

// Текст запроса регистр сведений цены номенклатуры.
// 
// Параметры:
//  ИсточникТоваров - Строка - название таблицы с товарами
//  ПараметрДата - Строка - название параметра Дата
//  УсловиеВидЦены - Неопределено, Структура - условие по виду цен
//  ИспользуетсяЦенообразование25 - Неопределено, Булево - Используется ценообразование 2.5
// 
// Возвращаемое значение:
//  Строка - Текст запроса регистр сведений цены номенклатуры
Функция ТекстЗапросаРегистрСведенийЦеныНоменклатуры(ИсточникТоваров,
													ПараметрДата = "&Дата", 
													УсловиеВидЦены = Неопределено,
													ИспользуетсяЦенообразование25 = Неопределено) Экспорт
	
	Если ИспользуетсяЦенообразование25 = Неопределено Тогда
		ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;
	
	Если ИспользуетсяЦенообразование25 Тогда
		ТекстЗапроса = 
		"РегистрСведений.ЦеныНоменклатуры25.СрезПоследних(КОНЕЦПЕРИОДА(&ПараметрДата, ДЕНЬ),
		|				&УсловиеВидЦены1 И
		|				(&УсловиеВидЦены2, Номенклатура,ХарактеристикаЦО,СерияЦО,УпаковкаЦО) В (
		|					ВЫБРАТЬ
		|						&УсловиеВидЦены3,
		|						Товары.Номенклатура,
		|						Товары.ХарактеристикаЦО,
		|						Товары.СерияЦО,
		|						Товары.УпаковкаЦО
		|					ИЗ
		|						&ИсточникТоваров КАК Товары
		|					)
		|			)";
	Иначе
		ТекстЗапроса = 
		"РегистрСведений.ЦеныНоменклатуры.СрезПоследних(КОНЕЦПЕРИОДА(&ПараметрДата, ДЕНЬ),
		|				&УсловиеВидЦены1 И
		|				(&УсловиеВидЦены2, Номенклатура,Характеристика) В (
		|					ВЫБРАТЬ
		|						&УсловиеВидЦены3,
		|						Товары.Номенклатура,
		|						Товары.Характеристика
		|					ИЗ
		|						&ИсточникТоваров КАК Товары
		|					)
		|			)";
	КонецЕсли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИсточникТоваров", ИсточникТоваров);
	
	ТекстЗаменыУсловиеВидЦены1 = "ИСТИНА";
	ТекстЗаменыУсловиеВидЦены2 = "";
	ТекстЗаменыУсловиеВидЦены3 = "";
	
	Если ТипЗнч(УсловиеВидЦены) = Тип("Структура") Тогда
		Если УсловиеВидЦены.Свойство("Константа") Тогда
			ТекстЗаменыУсловиеВидЦены1 = 
				"ВидЦены В (
				|	ВЫБРАТЬ
				|		&ИмяКонстанты КАК ВидЦены
				|	ИЗ
				|		Константы КАК Константы)";
				
			ТекстЗаменыУсловиеВидЦены1 = СтрЗаменить(ТекстЗаменыУсловиеВидЦены1, "&ИмяКонстанты", "Константы." + УсловиеВидЦены.Константа);
		ИначеЕсли УсловиеВидЦены.Свойство("Параметр") Тогда
			ТекстЗаменыУсловиеВидЦены1 = 
				"ВидЦены = &ИмяПараметра";
			ТекстЗаменыУсловиеВидЦены1 = СтрЗаменить(ТекстЗаменыУсловиеВидЦены1, "&ИмяПараметра", УсловиеВидЦены.Параметр);
		ИначеЕсли УсловиеВидЦены.Свойство("ВТаблице") Тогда 
			ТекстЗаменыУсловиеВидЦены2 = "ВидЦены,";
			Если СтрНайти(УсловиеВидЦены.ВТаблице, "&") = 0 Тогда
				ТекстЗаменыУсловиеВидЦены3 = "Товары.";
			КонецЕсли;
			ТекстЗаменыУсловиеВидЦены3 = ТекстЗаменыУсловиеВидЦены3 + УсловиеВидЦены.ВТаблице + ",";
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВидЦены1", ТекстЗаменыУсловиеВидЦены1);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВидЦены2,", ТекстЗаменыУсловиеВидЦены2);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВидЦены3,", ТекстЗаменыУсловиеВидЦены3);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПараметрДата", ПараметрДата);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Текст запроса регистр сведений цены номенклатуры условие соединения.
// 
// Параметры:
//  ИсточникТоваров - Строка - название таблицы с товарами
//  ИсточникЦен - Строка - название таблицы с ценами
//  ИсточникВидовЦен - Строка, Неопределено - значение, если необходимо в соединение соединять по виду цен
//  ИспользуетсяЦенообразование25 - Неопределено, Булево - Используется ценообразование 2.5
// 
// Возвращаемое значение:
//  Строка - Текст запроса регистр сведений цены номенклатуры условие соединения
Функция ТекстЗапросаРегистрСведенийЦеныНоменклатурыУсловиеСоединения(ИсточникТоваров,
																	ИсточникЦен,
																	ИсточникВидовЦен = Неопределено,
																	ИспользуетсяЦенообразование25 = Неопределено) Экспорт
	
	Если ИспользуетсяЦенообразование25 = Неопределено Тогда
		ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;
	
	ТекстыЗапросов = Новый Массив();
	Если ИспользуетсяЦенообразование25 Тогда
		ТекстЗапроса = "
		|			&ИсточникТоваров.Номенклатура = &ИсточникЦен.Номенклатура
		|			И &ИсточникТоваров.ХарактеристикаЦО = &ИсточникЦен.ХарактеристикаЦО
		|			И &ИсточникТоваров.СерияЦО = &ИсточникЦен.СерияЦО
		|			И &ИсточникТоваров.УпаковкаЦО = &ИсточникЦен.УпаковкаЦО";
	Иначе
		ТекстЗапроса = "
		|			&ИсточникТоваров.Номенклатура = &ИсточникЦен.Номенклатура
		|			И &ИсточникТоваров.Характеристика = &ИсточникЦен.Характеристика";
	КонецЕсли;
	ТекстыЗапросов.Добавить(ТекстЗапроса);

	Если ИсточникВидовЦен <> Неопределено Тогда
		ТекстыЗапросов.Добавить(Символы.ПС + "		И ");
		ТекстыЗапросов.Добавить(ИсточникВидовЦен);
		ТекстыЗапросов.Добавить(" = &ИсточникЦен.ВидЦены");
	КонецЕсли;
		
	ТекстЗапроса = СтрСоединить(ТекстыЗапросов);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИсточникТоваров", ИсточникТоваров);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИсточникЦен", ИсточникЦен);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Текст запроса временной таблицы с дополнением для ценообразования.
// 
// Параметры:
//  Настройки - см. НастройкиДляВременнойТаблицыСДополнениемДляЦенообразования
//  ИспользуетсяЦенообразование25 - Неопределено - Используется ценообразование 2.5
// 
// Возвращаемое значение:
//  Строка - Текст запроса временной таблицы с дополнением для ценообразования
Функция ТекстЗапросаВременнойТаблицыСДополнениемДляЦенообразования(Настройки,
																	ИспользуетсяЦенообразование25 = Неопределено) Экспорт
	
	Если ИспользуетсяЦенообразование25 = Неопределено Тогда
		ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;
	
	ТекстЗапроса = "
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ПоляТаблицыТоваров
	|ПОМЕСТИТЬ 
	|	#ПриемникТоваров
	|ИЗ
	|	#ИсточникТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО ВидыНоменклатуры.Ссылка = &ИсточникВидаНоменклатуры
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИсточникТоваров", Настройки.ИсточникТоваров);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПриемникТоваров", Настройки.ПриемникТоваров);

	ПоляЗапроса = Новый Массив();
	ПоляЗапроса.Добавить(Настройки.ИсточникТоваров + "." + Настройки.ПолеНоменклатура);
	
	Если ЗначениеЗаполнено(Настройки.ПолеХарактеристика) Тогда
		ПоляЗапроса.Добавить(Настройки.ИсточникТоваров + "." + Настройки.ПолеХарактеристика);
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ПолеСерия) Тогда
		ПоляЗапроса.Добавить(Настройки.ИсточникТоваров + "." + Настройки.ПолеСерия);
	КонецЕсли;
	Если ЗначениеЗаполнено(Настройки.ПолеУпаковка) Тогда
		ПоляЗапроса.Добавить(Настройки.ИсточникТоваров + "." + Настройки.ПолеУпаковка);
	КонецЕсли;

	ПоляЗапроса.Добавить(ТекстПолейДляЦенообразования(Настройки,,ИспользуетсяЦенообразование25));
	
	Если ЗначениеЗаполнено(Настройки.СписокПрочихПолей) Тогда
		СписокПрочихПолей = СтрРазделить(Настройки.СписокПрочихПолей, ",", Ложь);
		Для Каждого Поле Из СписокПрочихПолей Цикл
			ПоляЗапроса.Добавить(Настройки.ИсточникТоваров + "." + СокрЛП(Поле));
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляТаблицыТоваров", СтрСоединить(ПоляЗапроса, "," + Символы.ПС));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИсточникВидаНоменклатуры", Настройки.ИсточникТоваров + "." + Настройки.ПолеНоменклатура + ".ВидНоменклатуры");
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Текст полей для ценообразования.
// 
// Параметры:
//  Настройки - Структура - Настройки:
// * ИсточникТоваров - Строка -
// * ПриемникТоваров - Строка -
// * ПолеНоменклатура - Строка -
// * ПолеХарактеристика - Строка -
// * ПолеСерия - Строка -
// * ПолеУпаковка - Строка -
// * СписокПрочихПолей - Строка -
// ДляПолейГруппировки  - Булево - Истина, для полоей группировки, не присваивать синонимы
//  ИспользуетсяЦенообразование25 - Неопределено - Используется ценообразование 2.5
// 
// Возвращаемое значение:
//  Строка - Текст полей для ценообразования
Функция ТекстПолейДляЦенообразования(Настройки, 
										ДляПолейГруппировки = Ложь,
										ИспользуетсяЦенообразование25 = Неопределено) Экспорт
	
	ПоляЗапроса = Новый Массив();

	Если ИспользуетсяЦенообразование25 = Неопределено Тогда
		ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;
	
	Если Не ИспользуетсяЦенообразование25 Тогда
		Возврат "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Настройки.ПолеХарактеристика) Тогда
		ТекстПоля =	"ВЫБОР
						|	КОГДА
						|		ВидыНоменклатуры.НастройкиКлючаЦенПоХарактеристике = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
						|		ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка)
						|	ИНАЧЕ ЕСТЬNULL(" + Настройки.ИсточникТоваров + "." + Настройки.ПолеХарактеристика + ".ХарактеристикаНоменклатурыДляЦенообразования, 
						|			ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка))
						|КОНЕЦ";
	Иначе
		ТекстПоля =	"ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка)";
	КонецЕсли;
	ТекстПоля = ТекстПоля + ?(ДляПолейГруппировки, ""," КАК ХарактеристикаЦО");
	ПоляЗапроса.Добавить(ТекстПоля);
	
	Если ЗначениеЗаполнено(Настройки.ПолеСерия) Тогда
		ТекстПоля =	"ВЫБОР
						|	КОГДА
						|		ВидыНоменклатуры.НастройкиКлючаЦенПоСерии = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
						|			ИЛИ "+ Настройки.ИсточникТоваров + "." + Настройки.ПолеСерия + " = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
						|		ТОГДА ЗНАЧЕНИЕ(Справочник.СерииНоменклатурыДляЦенообразования.ПустаяСсылка)
						|	ИНАЧЕ ЕСТЬNULL(" + Настройки.ИсточникТоваров + "." + Настройки.ПолеСерия + ".СерияНоменклатурыДляЦенообразования, 
						|			ЗНАЧЕНИЕ(Справочник.СерииНоменклатурыДляЦенообразования.ПустаяСсылка))
						|КОНЕЦ";
	Иначе
		ТекстПоля =	"ЗНАЧЕНИЕ(Справочник.СерииНоменклатурыДляЦенообразования.ПустаяСсылка)";
	КонецЕсли;
	ТекстПоля = ТекстПоля + ?(ДляПолейГруппировки, ""," КАК СерияЦО");
	ПоляЗапроса.Добавить(ТекстПоля);
	
	Если ЗначениеЗаполнено(Настройки.ПолеУпаковка) Тогда
		ТекстПоля =	"ВЫБОР
						|	КОГДА
						|		ВидыНоменклатуры.НастройкиКлючаЦенПоУпаковке = ЗНАЧЕНИЕ(Перечисление.ВариантОтбораДляКлючаЦен.НеИспользовать)
						|		ТОГДА ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
						|	ИНАЧЕ " + Настройки.ИсточникТоваров + "." + Настройки.ПолеУпаковка + "
						|КОНЕЦ";
	Иначе
		ТекстПоля =	"ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)";
	КонецЕсли;
	ТекстПоля = ТекстПоля + ?(ДляПолейГруппировки, ""," КАК УпаковкаЦО");
	
	ПоляЗапроса.Добавить(ТекстПоля);
	
	Возврат СтрСоединить(ПоляЗапроса, "," + Символы.ПС);
	
КонецФункции

// Настройки для временной таблицы с дополнением для ценообразования.
// 
// Возвращаемое значение:
//  Структура - Настройки для временной таблицы с дополнением для ценообразования:
// * ИсточникТоваров - Строка - Наименования таблицы истоника товаров
// * ПриемникТоваров - Строка - Наименования таблицы приемника товаров
// * ПолеНоменклатура - Строка - Наименование поля номенклатуры. Если нет необходимо присвоить путую строку
// * ПолеХарактеристика - Строка - Наименование поля характеристики. Если нет необходимо присвоить путую строку
// * ПолеСерия - Строка - Наименование поля серии. Если нет необходимо присвоить путую строку
// * ПолеУпаковка - Строка - Наименование поля упаковки. Если нет необходимо присвоить путую строку
// * СписокПрочихПолей - Строка - все остальные поля источника товаров через запятую
//
Функция НастройкиДляВременнойТаблицыСДополнениемДляЦенообразования() Экспорт
	
	Настройки = Новый Структура();
	
	Настройки.Вставить("ИсточникТоваров", "");
	Настройки.Вставить("ПриемникТоваров", "");
	Настройки.Вставить("ПолеНоменклатура", "Номенклатура");
	Настройки.Вставить("ПолеХарактеристика", "Характеристика");
	Настройки.Вставить("ПолеСерия", "Серия");
	Настройки.Вставить("ПолеУпаковка", "Упаковка");
	Настройки.Вставить("СписокПрочихПолей", "");
	
	Возврат Настройки;
	
КонецФункции

// Текст запроса регистр сведений цены номенклатуры индексирование.
// 
// Параметры:
//  ИспользуетсяЦенообразование25 - Неопределено, Булево - Используется ценообразование 2.5
// 
// Возвращаемое значение:
//  Строка - Текст запроса регистр сведений цены номенклатуры индексирование
Функция ТекстЗапросаРегистрСведенийЦеныНоменклатурыИндексирование(ИспользуетсяЦенообразование25 = Неопределено) Экспорт

	Если ИспользуетсяЦенообразование25 = Неопределено Тогда
		ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;

	Если ИспользуетсяЦенообразование25 Тогда
		ТекстЗамены = "Номенклатура,
			|	ХарактеристикаЦО,
			|	СерияЦО,
			|	УпаковкаЦО,
			|	ВидЦены";
	Иначе
		ТекстЗамены = "Номенклатура,
			|	Характеристика,
			|	ВидЦены";
	КонецЕсли;

	Возврат ТекстЗамены;

КонецФункции

#КонецОбласти

#КонецОбласти