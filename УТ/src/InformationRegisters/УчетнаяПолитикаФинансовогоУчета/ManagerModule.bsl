#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значения по умолчанию для ресурсов регистра.
// Имена ключей структуры должны строго соответствовать именам ресурсов регистра.
// 
// Возвращаемое значение:
// 	Структура - структура значений ресурсов регистра.
Функция ЗначенияПоУмолчанию() Экспорт
	
	СтруктураЗначений = Новый Структура;
	
	СтруктураЗначений.Вставить("МетодОценкиСтоимостиТоваров", Перечисления.МетодыОценкиСтоимостиТоваров.СредняяЗаМесяц);
	СтруктураЗначений.Вставить("УчетГотовойПродукцииПоПлановойСтоимости", Ложь);
	СтруктураЗначений.Вставить("ФормироватьРезервыПоСомнительнымДолгам", Ложь);
	СтруктураЗначений.Вставить("ПериодичностьРезервовПоСомнительнымДолгам", Перечисления.Периодичность.Месяц);
	СтруктураЗначений.Вставить("ПризнаватьРасходыПоИсследованиям", Ложь);
	СтруктураЗначений.Вставить("СтатьяРасходовПоИсследованиям", Неопределено);
	СтруктураЗначений.Вставить("АналитикаРасходовПоИсследованиям", Неопределено);
	СтруктураЗначений.Вставить("ИспользоватьВыделениеДолгосрочныхАктивовОбязательств", Ложь);
	СтруктураЗначений.Вставить("ДлительностьОперационногоЦикла", 12);
	СтруктураЗначений.Вставить("УчетАрендыПоФСБУ25_2018", Истина);
	СтруктураЗначений.Вставить("УчетДисконтированнойКредиторскойЗадолженностиПоставщикам", Ложь);
	СтруктураЗначений.Вставить("СтатьяСписанияПроцентныхРасходов", Неопределено);
	СтруктураЗначений.Вставить("АналитикаСписанияПроцентныхРасходов", Неопределено);
	СтруктураЗначений.Вставить("УчетДисконтированияРезервовПредстоящихРасходов", Ложь);
	СтруктураЗначений.Вставить("СтатьяСписанияПроцентныхРасходовДисконтированияРезервов", Неопределено);
	СтруктураЗначений.Вставить("АналитикаСписанияПроцентныхРасходовДисконтированияРезервов", Неопределено);
	СтруктураЗначений.Вставить("СрокДляПримененияДисконтирования", 0);
	СтруктураЗначений.Вставить("УчетнаяПолитикаСуществует", Ложь);
	СтруктураЗначений.Вставить("МесяцНачалаФинансовогоГода", 1);
	СтруктураЗначений.Вставить("ДетализироватьМатериальныеИПостатейныеЗатратыВСебестоимостиТоваров", Ложь);
	СтруктураЗначений.Вставить("ВосстанавливатьРезервПриСписанииЗапасовНаРасходы", Истина);
	СтруктураЗначений.Вставить("ПорядокОценкиЗадолженности", Неопределено);
	СтруктураЗначений.Вставить("СтатьяПроцентныхДоходовФинансовойАренды", Неопределено);
	СтруктураЗначений.Вставить("АналитикаПроцентныхДоходовФинансовойАренды", Неопределено);
	СтруктураЗначений.Вставить("СтатьяДоходовДляУслугФинансовойАренды", Неопределено);
	СтруктураЗначений.Вставить("АналитикаДоходовДляУслугФинансовойАренды", Неопределено);
	
	
	Возврат СтруктураЗначений
	
КонецФункции

// Возвращает представление начала финансового года
// 
// Параметры:
//  МесяцНачалаФинансовогоГода - Число - Порядковый номер месяца
// 
// Возвращаемое значение:
//  Строка - Представление месяца начала финансового года
Функция ПредставлениеНачалаФинансовогоГода(МесяцНачалаФинансовогоГода) Экспорт
	
	Если МесяцНачалаФинансовогоГода = 1 Тогда
		Возврат НСтр("ru='Январь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 2 Тогда
		Возврат НСтр("ru='Февраль'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 3 Тогда
		Возврат НСтр("ru='Март'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 4 Тогда
		Возврат НСтр("ru='Апрель'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 5 Тогда
		Возврат НСтр("ru='Май'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 6 Тогда
		Возврат НСтр("ru='Июнь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 7 Тогда
		Возврат НСтр("ru='Июль'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 8 Тогда
		Возврат НСтр("ru='Август'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 9 Тогда
		Возврат НСтр("ru='Сентябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 10 Тогда
		Возврат НСтр("ru='Октябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 11 Тогда
		Возврат НСтр("ru='Ноябрь'");
	ИначеЕсли МесяцНачалаФинансовогоГода = 12 Тогда
		Возврат НСтр("ru='Декабрь'");
	Иначе
		Возврат НСтр("ru='Неопределено'");
	КонецЕсли;
	
КонецФункции

// Возращает текст запроса по данным регистра.
// 
// Возвращаемое значение:
// 	Строка - Текст запроса.
Функция ТекстЗапросаДействующиеПараметрыНалоговУчетныхПолитик() Экспорт
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР КОГДА ТаблицаСрезПоследних.Период ЕСТЬ NULL Тогда
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК УчетнаяПолитикаСуществует,
	|	ТаблицаСрезПоследних.Период КАК Период,
	|	ГоловныеОрганизации.ОбособленноеПодразделение КАК Организация,
	|	ТаблицаСрезПоследних.МетодОценкиСтоимостиТоваров КАК МетодОценкиСтоимостиТоваров,
	|	ТаблицаСрезПоследних.ФормироватьРезервыПоСомнительнымДолгам КАК ФормироватьРезервыПоСомнительнымДолгам,
	|	ТаблицаСрезПоследних.ПериодичностьРезервовПоСомнительнымДолгам КАК ПериодичностьРезервовПоСомнительнымДолгам,
	|	ТаблицаСрезПоследних.УчетГотовойПродукцииПоПлановойСтоимости КАК УчетГотовойПродукцииПоПлановойСтоимости,
	|	ТаблицаСрезПоследних.ПризнаватьРасходыПоИсследованиям КАК ПризнаватьРасходыПоИсследованиям,
	|	ТаблицаСрезПоследних.СтатьяРасходовПоИсследованиям КАК СтатьяРасходовПоИсследованиям,
	|	ТаблицаСрезПоследних.АналитикаРасходовПоИсследованиям КАК АналитикаРасходовПоИсследованиям,
	|	ТаблицаСрезПоследних.ИспользоватьВыделениеДолгосрочныхАктивовОбязательств,
	|	ТаблицаСрезПоследних.ДлительностьОперационногоЦикла,
	|	ТаблицаСрезПоследних.ПорядокУчетаВНА КАК ПорядокУчетаВНА,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииОС КАК ПорядокНачисленияАмортизацииОС,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииНМА КАК ПорядокНачисленияАмортизацииНМА,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииАренда КАК ПорядокНачисленияАмортизацииАренда,
	|	ТаблицаСрезПоследних.ПорядокУчетаВНАРегл КАК ПорядокУчетаВНАРегл,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииОСРегл КАК ПорядокНачисленияАмортизацииОСРегл,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииНМАРегл КАК ПорядокНачисленияАмортизацииНМАРегл,
	|	ТаблицаСрезПоследних.ПорядокНачисленияАмортизацииАрендаРегл КАК ПорядокНачисленияАмортизацииАрендаРегл,
	|	ТаблицаСрезПоследних.УчетАрендыПоФСБУ25_2018 КАК УчетАрендыПоФСБУ25_2018,
	|	ТаблицаСрезПоследних.ВариантПроводокПоОбесценениюВНА КАК ВариантПроводокПоОбесценениюВНА,
	|	ТаблицаСрезПоследних.МесяцНачалаФинансовогоГода КАК МесяцНачалаФинансовогоГода,
	|	ТаблицаСрезПоследних.УчетДисконтированнойКредиторскойЗадолженностиПоставщикам КАК УчетДисконтированнойКредиторскойЗадолженностиПоставщикам,
	|	ТаблицаСрезПоследних.СтатьяСписанияПроцентныхРасходов КАК СтатьяСписанияПроцентныхРасходов,
	|	ТаблицаСрезПоследних.АналитикаСписанияПроцентныхРасходов КАК АналитикаСписанияПроцентныхРасходов,
	|	ТаблицаСрезПоследних.СтатьяСписанияПроцентныхРасходовДисконтированияРезервов КАК СтатьяСписанияПроцентныхРасходовДисконтированияРезервов,
	|	ТаблицаСрезПоследних.АналитикаСписанияПроцентныхРасходовДисконтированияРезервов КАК АналитикаСписанияПроцентныхРасходовДисконтированияРезервов,
	|	ТаблицаСрезПоследних.УчетДисконтированияРезервовПредстоящихРасходов КАК УчетДисконтированияРезервовПредстоящихРасходов,
	|	ТаблицаСрезПоследних.СрокДляПримененияДисконтирования КАК СрокДляПримененияДисконтирования,
	|	ТаблицаСрезПоследних.ДетализироватьМатериальныеИПостатейныеЗатратыВСебестоимостиТоваров,
	|	ТаблицаСрезПоследних.ВосстанавливатьРезервПриСписанииЗапасовНаРасходы,
	|	ТаблицаСрезПоследних.ПорядокОценкиЗадолженности КАК ПорядокОценкиЗадолженности,
	|	ТаблицаСрезПоследних.СтатьяПроцентныхДоходовФинансовойАренды,
	|	ТаблицаСрезПоследних.АналитикаПроцентныхДоходовФинансовойАренды,
	|	ТаблицаСрезПоследних.СтатьяДоходовДляУслугФинансовойАренды,
	|	ТаблицаСрезПоследних.АналитикаДоходовДляУслугФинансовойАренды
	|ИЗ
	|	ВтГоловныеОрганизации КАК ГоловныеОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(&Период, Организация В
	|			(ВЫБРАТЬ
	|				ГоловныеОрганизации.Организация
	|			ИЗ
	|				ВтГоловныеОрганизации КАК ГоловныеОрганизации)) КАК ТаблицаСрезПоследних
	|		ПО ГоловныеОрганизации.Организация = ТаблицаСрезПоследних.Организация
	|";
	Возврат ТекстЗапроса
	
КонецФункции

// Формирует текстовое описание установленных параметров.
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - ссылка на организацию.
// 	ДатаДействия - Дата - период действия настроек.
// 	ДействующиеНастройки - Структура - действующие параметры учетной политики.
// Возвращаемое значение:
// 	Строка - Описание действующих параметров строкой.
Функция ОписаниеДействующихПараметров(Организация, ДатаДействия = Неопределено, ДействующиеНастройки = Неопределено) Экспорт
	
	Если ДействующиеНастройки = Неопределено Тогда
		ДействующиеНастройки = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату(
			"УчетнаяПолитикаФинансовогоУчета",
			Организация,
			ДатаДействия,
			Ложь);
	КонецЕсли;
	СтрокаШаблон = "%1: %2." + Символы.ПС;
	СтрокаШаблонБулево = "%1." + Символы.ПС;
	Если НЕ ЗначениеЗаполнено(ДействующиеНастройки) Тогда
		СтрокаОписанияНастроек = НСтр("ru='Не заданы параметры.'");
		Возврат СтрокаОписанияНастроек;
	КонецЕсли;
	
	СтрокаОписанияНастроек = СтрШаблон(СтрокаШаблон, 
		НСтр("ru='Начало финансового года'"),
		ПредставлениеНачалаФинансовогоГода(ДействующиеНастройки.МесяцНачалаФинансовогоГода));
	
	СтрокаОписанияНастроек = СтрокаОписанияНастроек 
		+ СтрШаблон(СтрокаШаблон, 
			НСтр("ru='Метод оценки стоимости товаров'"),
			ДействующиеНастройки.МетодОценкиСтоимостиТоваров);
	
	Если ДействующиеНастройки.УчетГотовойПродукцииПоПлановойСтоимости Тогда
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблонБулево,
				НСтр("ru='Готовая продукция учитывается по плановой стоимости'"));
	КонецЕсли;
	
	
	Если ДействующиеНастройки.ИспользоватьВыделениеДолгосрочныхАктивовОбязательств Тогда
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблонБулево,
				НСтр("ru='Используется выделение долгосрочных активов/обязательств'"));
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблон,
				НСтр("ru='Длительность операционного цикла в месяцах'"),
				ДействующиеНастройки.ДлительностьОперационногоЦикла);

	КонецЕсли;
	
	
	Если ДействующиеНастройки.УчетДисконтированнойКредиторскойЗадолженностиПоставщикам 
		И ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблонБулево,
					НСтр("ru='Ведется учет дисконтированной кредиторской задолженности поставщикам'"));
			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблон,
					НСтр("ru='Статья списания процентных расходов дисконтирования'"),
					ДействующиеНастройки.СтатьяСписанияПроцентныхРасходов);
			
 			
			СтрокаОписанияНастроек = СтрокаОписанияНастроек
				+ СтрШаблон(СтрокаШаблон,
					НСтр("ru='Аналитика списания процентных расходов дисконтирования'"),
					ДействующиеНастройки.АналитикаСписанияПроцентныхРасходов);
			
	КонецЕсли;
	
	Если ДействующиеНастройки.ФормироватьРезервыПоСомнительнымДолгам Тогда
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблонБулево,
				НСтр("ru='Формируются резервы по сомнительным долгам'"));
		
		СтрокаОписанияНастроек = СтрокаОписанияНастроек
			+ СтрШаблон(СтрокаШаблон,
				НСтр("ru='Периодичность резервов по сомнительным долгам'"),
				ДействующиеНастройки.ПериодичностьРезервовПоСомнительнымДолгам);
		
	КонецЕсли;
	
	ОписаниеДействующихПараметровЛокализация(СтрокаОписанияНастроек, Организация, ДатаДействия, ДействующиеНастройки);
	
	Возврат СтрокаОписанияНастроек
	
КонецФункции

// Возвращает актуальные значения порядка оценки задолженности по организации на дату.
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - ссылка на организацию.
// 	Период - Дата - период действия настроек.
// 
// Возвращаемое значение:
//  ТаблицаЗначений, Неопределено - таблица оценки задолженности.
Функция ПорядокОценкиЗадолженности(Организация, Период) Экспорт
	
	ДействующиеНастройки = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату(
		"УчетнаяПолитикаФинансовогоУчета", Организация, Период, Истина);
	
	Если ДействующиеНастройки <> Неопределено
		И ДействующиеНастройки.ПорядокОценкиЗадолженности <> Неопределено Тогда
			ХранилищеПорядокОценкиЗадолженности = ДействующиеНастройки.ПорядокОценкиЗадолженности; //ХранилищеЗначения
		Возврат ХранилищеПорядокОценкиЗадолженности.Получить();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Возвращает параметры выбора статей и аналитик.
// 
// Параметры:
//  ПризнаватьРасходыПоИсследованиям - Булево.
//  УчетДисконтированнойКредиторскойЗадолженностиПоставщикам - Булево.
//  УчетРезервовПредстоящихРасходов - Булево.
//  УчетФинАренды - Булево.
//  
// Возвращаемое значение:
//  Массив из см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
Функция ПараметрыВыбораСтатейИАналитик(ПризнаватьРасходыПоИсследованиям, УчетДисконтированнойКредиторскойЗадолженностиПоставщикам,
		УчетРезервовПредстоящихРасходов, УчетФинАренды) Экспорт
	
	МассивПараметров = Новый Массив;
	
	#Область СтатьяРасходовПоИсследованиям
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Запись";
	ПараметрыВыбора.Статья      = "СтатьяРасходовПоИсследованиям";
	
	ПараметрыВыбора.ДоступностьПоОперации = ПризнаватьРасходыПоИсследованиям = Истина;
	ПараметрыВыбора.СкрыватьСтатьюНедоступнуюПоОперации = Ложь;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходовПоИсследованиям";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходовПоИсследованиям");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходовПоИсследованиям");
	
	МассивПараметров.Добавить(ПараметрыВыбора);
	#КонецОбласти
	
	#Область СтатьяСписанияПроцентныхРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Запись";
	ПараметрыВыбора.Статья      = "СтатьяСписанияПроцентныхРасходов";
	
	ПараметрыВыбора.ДоступностьПоОперации = 
		УчетДисконтированнойКредиторскойЗадолженностиПоставщикам 
		И ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов");
	ПараметрыВыбора.СкрыватьСтатьюНедоступнуюПоОперации = Ложь;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаСписанияПроцентныхРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяСписанияПроцентныхРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаСписанияПроцентныхРасходов");
	
	МассивПараметров.Добавить(ПараметрыВыбора);
	#КонецОбласти 
	
	
	Возврат МассивПараметров;
	
КонецФункции

Процедура ОписаниеДействующихПараметровЛокализация(СтрокаОписанияНастроек, Организация, ДатаДействия, ДействующиеНастройки)
	
	//++ Локализация
	
	СтрокаШаблон = "%1: %2." + Символы.ПС;
	СтрокаШаблонБулево = "%1." + Символы.ПС;


	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
