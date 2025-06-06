
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОписаниеИсточника

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрНакопления - Метаданные регистра накопления
//  РегистрацияКОтражению - Булево - Признак получения параметров для регистрации к отражению в учете
//
// Возвращаемое значение:
// 	см. ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеРегистра = Неопределено, РегистрацияКОтражению = Ложь) Экспорт
	
	ПараметрыОтражения = ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете(РегистрацияКОтражению);
	ПараметрыОтражения.ПутьКДаннымОрганизация = "АналитикаУчетаПоПартнерам.Организация";
	ПараметрыОтражения.ПутьКДаннымРегистратор = "ДокументРегистратор";
	
	Если РегистрацияКОтражению Тогда
		Возврат ПараметрыОтражения;
	КонецЕсли;
	
	ПараметрыОтражения.ВыделениеДолгосрочныхАктивовОбязательств = Истина;
	ПараметрыОтражения.ПутьКДаннымОбъектНастройки = "ОбъектРасчетов.ГруппаФинансовогоУчета";
	ПараметрыОтражения.ПутьКДаннымНаправлениеДеятельности = "АналитикаУчетаПоПартнерам.НаправлениеДеятельности";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "ОбъектРасчетов.Подразделение";
	ПараметрыОтражения.ПутьКДаннымДатаПогашения = "ДатаПлановогоПогашения";
	ПараметрыОтражения.ПутьКДаннымВалюта = "Валюта";
	ПараметрыОтражения.РесурсыУпр.Добавить("ПредоплатаУпр");
	ПараметрыОтражения.РесурсыУпр.Добавить("ДолгУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("ПредоплатаРегл");
	ПараметрыОтражения.РесурсыРегл.Добавить("ДолгРегл");
	ПараметрыОтражения.РесурсыВал.Добавить("Предоплата");
	ПараметрыОтражения.РесурсыВал.Добавить("Долг");
	
	
	ПараметрыОтражения.УсловиеДебет = СтрЗаменить(
		"ВЫБОР
		|		КОГДА ПсевдонимИсточникаДанных.Долг <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ДолгУпр <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ДолгРегл <> 0
		|			ТОГДА ПсевдонимИсточникаДанных.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|		КОГДА ПсевдонимИсточникаДанных.Предоплата <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ПредоплатаУпр <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ПредоплатаРегл <> 0
		|			ТОГДА ПсевдонимИсточникаДанных.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ",
		"ПсевдонимИсточникаДанных",
		ПараметрыОтражения.ПсевдонимИсточникаДанных);
	
	ПараметрыОтражения.УсловиеКредит = СтрЗаменить(
		"ВЫБОР
		|		КОГДА ПсевдонимИсточникаДанных.Долг <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ДолгУпр <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ДолгРегл <> 0
		|			ТОГДА ПсевдонимИсточникаДанных.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		КОГДА ПсевдонимИсточникаДанных.Предоплата <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ПредоплатаУпр <> 0
		|		  ИЛИ ПсевдонимИсточникаДанных.ПредоплатаРегл <> 0
		|			ТОГДА ПсевдонимИсточникаДанных.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ",
		"ПсевдонимИсточникаДанных",
		ПараметрыОтражения.ПсевдонимИсточникаДанных);
	
	Если МетаданныеРегистра = Неопределено Тогда
		МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	КонецЕсли;
	
	ФинансовыйУчетПоДаннымБалансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);

	Возврат ПараметрыОтражения;
	
КонецФункции



#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
	|	ПО АналитикаУчетаПоПартнерам.КлючАналитики = ЭтотСписок.АналитикаУчетаПоПартнерам
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиПартнеры
	|	ПО ВнешниеПользователиПартнеры.ОбъектАвторизации = АналитикаУчетаПоПартнерам.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВнешниеПользователиПартнеры.Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.21.73";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1d86b925-d170-44ae-9550-190d1f7da828");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	Обработчик.Комментарий = СтрШаблон(НСтр("ru = 'Перезаполняет хозяйственную операцию для документа ""Взаимозачет задолженности"" с видом операции ""Перенос долга"",""Перенос аванса"".
			|Заполняет реквизит %1'"),
		Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.Реквизиты.ТипЗаписиВзаиморасчетов.Представление());
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Процедура регистрации данных для обработчика обновления ОбработатьДанныеДляПереходаНаВерсию.
// 
// Параметры:
//  Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра	= "РегистрНакопления.РасчетыСКлиентамиПоСрокам";

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();

	Запрос = Новый Запрос;
	Запрос.Текст = "
	// Взаимозачеты задолженности
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыСКлиентамиПоСрокам.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК РасчетыСКлиентамиПоСрокам
	|ГДЕ
	|	РасчетыСКлиентамиПоСрокам.ДокументРегистратор ССЫЛКА Документ.ВзаимозачетЗадолженности
	|		И ВЫРАЗИТЬ(РасчетыСКлиентамиПоСрокам.ДокументРегистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации В (&ВидыОпераций)
	|		И РасчетыСКлиентамиПоСрокам.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВзаимозачетЗадолженности)
	|
	// Типы записей взаиморасчетов
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыСКлиентамиПоСрокам.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК РасчетыСКлиентамиПоСрокам
	|ГДЕ
	|	РасчетыСКлиентамиПоСрокам.ТипЗаписиВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейВзаиморасчетов.ПустаяСсылка)
	|";
	Запрос.УстановитьПараметр("ВидыОпераций", РегистрыНакопления.РасчетыСКлиентами.ВидыОпераций());

	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);

КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	МетаданныеРегистра = Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам;
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;

	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);

	Если ОбновляемыеДанные.Количество() > 0 Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.ДокументРегистратор КАК Взаимозачет
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|	И ВЫРАЗИТЬ(Движения.ДокументРегистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации В (&ВидыОперацийПоДолгу)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.ДокументРегистратор КАК Взаимозачет
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|	И ВЫРАЗИТЬ(Движения.ДокументРегистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации В (&ВидыОперацийПоАвансу)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|;
		|
		// Документы основания Сторно
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Движения.ДокументРегистратор КАК ДокументРегистратор,
		|	ДанныеСторно.СторнируемыйДокумент КАК СторнируемыйДокумент
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Движения
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Сторно КАК ДанныеСторно
		|		ПО Движения.ДокументРегистратор = ДанныеСторно.Ссылка
		|ГДЕ
		|	Движения.Регистратор В (&Регистраторы)
		|";
		Запрос.УстановитьПараметр("Регистраторы", ОбновляемыеДанные.ВыгрузитьКолонку("Регистратор"));
		Запрос.УстановитьПараметр("ВидыОперацийПоДолгу", РегистрыНакопления.РасчетыСКлиентами.ВидыОперацийПоДолгу());
		Запрос.УстановитьПараметр("ВидыОперацийПоАвансу", РегистрыНакопления.РасчетыСКлиентами.ВидыОперацийПоАвансу());
		Результаты = Запрос.ВыполнитьПакет();

		ПроблемныйРегистратор = Неопределено;
		ДанныеЗаменыОперации = РегистрыНакопления.РасчетыСКлиентами.ДанныеЗаменыОперации();
		
		НачатьТранзакцию();

		Попытка

			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.ИсточникДанных = ОбновляемыеДанные;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Регистратор", "Регистратор");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			ВзаимозачетПереносДолга = Результаты[0].Выгрузить().ВыгрузитьКолонку("Взаимозачет");
			ВзаимозачетПереносАванса = Результаты[1].Выгрузить().ВыгрузитьКолонку("Взаимозачет");
			ВыборкаПоРегистратору = Результаты[2].Выбрать();
			СторнируемыеДокументы = Результаты[3].Выгрузить();
			СторнируемыеДокументы.Индексы.Добавить("ДокументРегистратор");
			Пока ВыборкаПоРегистратору.Следующий() Цикл

				ПроблемныйРегистратор = ВыборкаПоРегистратору.Регистратор;

				Набор = РегистрыНакопления.РасчетыСКлиентамиПоСрокам.СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(ВыборкаПоРегистратору.Регистратор);
				Набор.Прочитать();

				Для Каждого Запись Из Набор Цикл
					
					#Область ЗаменаОперацииВзаимозачетЗадолженности
					Если Запись.ХозяйственнаяОперация = ДанныеЗаменыОперации.ОперацияВзаимозачет
						ИЛИ Запись.НастройкаХозяйственнойОперации = ДанныеЗаменыОперации.НастройкаВзаимозачет Тогда
						Если ВзаимозачетПереносДолга.Найти(Запись.ДокументРегистратор) <> Неопределено Тогда
							Запись.ХозяйственнаяОперация = ДанныеЗаменыОперации.ОперацияПереносДолга;
							Запись.НастройкаХозяйственнойОперации = ДанныеЗаменыОперации.НастройкаПереносДолга;
						ИначеЕсли ВзаимозачетПереносАванса.Найти(Запись.ДокументРегистратор) <> Неопределено Тогда
							Запись.ХозяйственнаяОперация = ДанныеЗаменыОперации.ОперацияПереносАванса;
							Запись.НастройкаХозяйственнойОперации = ДанныеЗаменыОперации.НастройкаПереносАванса;
						КонецЕсли;
					КонецЕсли;
					#КонецОбласти
					
					#Область ЗаполнениеТиповЗаписейВзаиморасчетов
					Если Не ЗначениеЗаполнено(Запись.ТипЗаписиВзаиморасчетов) Тогда
						ТипРегистратора = ТипЗнч(Запись.ДокументРегистратор);
						Если ТипРегистратора = Тип("ДокументСсылка.Сторно") Тогда 
							СтрокаСторнируемогоДокумента = СторнируемыеДокументы.Найти(Запись.ДокументРегистратор, "ДокументРегистратор");
							Если СтрокаСторнируемогоДокумента <> Неопределено Тогда
								ТипРегистратора = ТипЗнч(СтрокаСторнируемогоДокумента.СторнируемыйДокумент);
							КонецЕсли;
						КонецЕсли;
						ОперативныеВзаиморасчетыСервер.ЗаполнитьТипЗаписиВзаиморасчетов(Запись, ТипРегистратора);
					КонецЕсли;
					#КонецОбласти
					
				КонецЦикла;

				ИзменилисьИтоги = Ложь;
				Если Набор.Количество() > 0 Тогда
						ИзменилисьИтоги = РегистрыНакопления.РасчетыСКлиентами.ЕстьИзмененияИтоговНабора(Набор);
				КонецЕсли;
				Если Набор.Модифицированность() И НЕ ИзменилисьИтоги Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
				КонецЕсли;

			КонецЦикла;

			ЗафиксироватьТранзакцию();

		Исключение

			ОтменитьТранзакцию();
			Если ЗначениеЗаполнено(ПроблемныйРегистратор) Тогда
				ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ПроблемныйРегистратор);
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
				ОбновлениеИнформационнойБазы.ЗарегистрироватьПроблемуСДанными(
					ПроблемныйРегистратор,
					РегистрыНакопления.РасчетыСКлиентами.ТекстСообщенияОбОшибке(ИнформацияОбОшибке(), ПроблемныйРегистратор));
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось выполнить обработку данных регистра накопления ""Расчеты с клиентами по срокам"", при обновлении по причине: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеРегистра,
				ТекстСообщения);
			КонецЕсли;

		КонецПопытки;

	КонецЕсли;

	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	Если Параметры.ОбработкаЗавершена
		И ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщиками.ПолноеИмя())
		И ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, Метаданные.РегистрыНакопления.РасчетыСКлиентами.ПолноеИмя())
		И ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.ПолноеИмя()) Тогда
		Константы.УдалитьТипыЗаписейВзаиморасчетовЗаполнены.Установить(Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли