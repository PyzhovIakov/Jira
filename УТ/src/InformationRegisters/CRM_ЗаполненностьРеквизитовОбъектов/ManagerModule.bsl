#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Процедура выполняет добавление записи.
//
// Параметры:
//  Объект				 - СправочникСсылка.Партнеры, СправочникСсылка.КонтактныеЛицаПартнеров	 - Объект.
//  Правило				 - СправочникСсылка.CRM_ПравилаРасчетаКачестваЗаполненияДанных	 - Правило.
//  ПроцентЗаполнения	 - Число	 - Процент заполнения.
//  ДатаРасчета			 - Дата	 - Дата расчета.
//  ТребуетсяПересчет	 - Булево	 - Требуется пересчет.
//  Комментарий			 - Строкеа	 - Комментарий.
//
Процедура ДобавитьЗапись(Объект = Неопределено, Правило = Неопределено, ПроцентЗаполнения = 0, ДатаРасчета = Неопределено, ТребуетсяПересчет = Ложь, Комментарий = "") Экспорт

	Если Не ЗначениеЗаполнено(Объект)
		И Не ЗначениеЗаполнено(Правило)	Тогда
		Возврат;
	ИначеЕсли Не ТребуетсяПересчет
		И Не ЗначениеЗаполнено(Объект) Тогда
		Возврат;	
	КонецЕсли;                      	
	
	Если ЗначениеЗаполнено(Объект) Тогда
		
		Если Не ЗначениеЗаполнено(ДатаРасчета) Тогда
			ДатаРасчета = ТекущаяДата();	
		КонецЕсли;
	
		НЗ = РегистрыСведений.CRM_ЗаполненностьРеквизитовОбъектов.СоздатьНаборЗаписей();
		НЗ.Отбор.Объект.Установить(Объект);
		
		НЗ.Прочитать();
		НЗ.Очистить();
		
		Запись = НЗ.Добавить();
		Запись.Объект = Объект;
		Запись.Правило = Правило;
		Запись.ПроцентЗаполненностиОбщий = ПроцентЗаполнения;
		Запись.ДатаРасчета = ДатаРасчета;
		Запись.ТребуетсяПересчет = ТребуетсяПересчет;
		Запись.Комментарий = Комментарий;
		
		НЗ.Записать();
		
	Иначе
		МЗ = РегистрыСведений.CRM_ЗаполненностьРеквизитовОбъектов.СоздатьМенеджерЗаписи();
		МЗ.Объект = Неопределено;
		МЗ.Правило = Правило;
		
		Если ЗначениеЗаполнено(ДатаРасчета) Тогда
			МЗ.Прочитать();
			Если МЗ.Выбран() Тогда
				Если Не ЗначениеЗаполнено(МЗ.ДатаРасчета) Тогда
					// Текущая запись приоритетнее
					Возврат;
				КонецЕсли;
			Иначе
				МЗ.Объект = Неопределено;
				МЗ.Правило = Правило;	
			КонецЕсли;
		КонецЕсли;
		
		МЗ.ДатаРасчета = ДатаРасчета;
		МЗ.ТребуетсяПересчет = Истина;
				
		МЗ.Записать();
	
	КонецЕсли; 	

КонецПроцедуры
 
// Процедура выполняет удаление записи по правилу.
//
// Параметры:
//  Правило	 - СправочникСсылка.CRM_ПравилаРасчетаКачестваЗаполненияДанных	 - Правило.
//
Процедура УдалитьЗаписьПоПравилу(Правило) Экспорт

	МЗ = РегистрыСведений.CRM_ЗаполненностьРеквизитовОбъектов.СоздатьМенеджерЗаписи();
	МЗ.Объект = Неопределено;
	МЗ.Правило = Правило;
	МЗ.Прочитать();
	
	Если МЗ.Выбран() Тогда
		МЗ.Удалить();
	КонецЕсли; 

КонецПроцедуры

// Процедура выполняет удаление всех записей по правилу.
//
// Параметры:
//  Правило	 - СправочникСсылка.CRM_ПравилаРасчетаКачестваЗаполненияДанных	 - Правило.
//
Процедура УдалитьВсеЗаписиПоПравилу(Правило) Экспорт

	НЗ = РегистрыСведений.CRM_ЗаполненностьРеквизитовОбъектов.СоздатьНаборЗаписей();
	НЗ.Отбор.Правило.Установить(Правило);
	НЗ.Очистить();
	НЗ.Записать();
	
КонецПроцедуры

// Функция возвращает объекты к расчету для массива объектов.
//
// Параметры:
//  МассивОбъектов	 - Массив	 - Массив объектов.
// 
// Возвращаемое значение:
//   - Соответствие
//
Функция ПолучитьОбъектыКРасчету_ДляМассиваОбъектов(МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Партнеры.Ссылка КАК Объект
	|ПОМЕСТИТЬ ВТ_ОбъектыРС
	|ИЗ
	|	Справочник.Партнеры КАК Партнеры
	|ГДЕ
	|	Партнеры.Ссылка В(&МассивОбъектов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактныеЛица.Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛица
	|ГДЕ
	|	КонтактныеЛица.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Выполнить();
	
	Возврат ПолучитьОбъектыКРасчету(МВТ);
		
КонецФункции

// Функция возвращает объекты к расчету по размеру пакета.
//
// Параметры:
//  РазмерПакетаКПересчету	 - Число	 - Размер пакета к пересчету.
// 
// Возвращаемое значение:
//   - Соответствие
//
Функция ПолучитьОбъектыКРасчету_ПоРазмеруПакета(РазмерПакетаКПересчету = 1000) Экспорт
	
	Запрос = Новый Запрос;
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	Запрос.Текст = СтрШаблон(
	"ВЫБРАТЬ  ПЕРВЫЕ %1
	|	CRM_ЗаполненностьРеквизитовОбъектов.Объект КАК Объект
	|ПОМЕСТИТЬ ВТ_ОбъектыРС
	|ИЗ
	|	РегистрСведений.CRM_ЗаполненностьРеквизитовОбъектов КАК CRM_ЗаполненностьРеквизитовОбъектов
	|ГДЕ
	|	НЕ CRM_ЗаполненностьРеквизитовОбъектов.Объект = НЕОПРЕДЕЛЕНО
	|	И CRM_ЗаполненностьРеквизитовОбъектов.ТребуетсяПересчет", 
	Формат(РазмерПакетаКПересчету, "ЧДЦ=0; ЧН=0; ЧГ=0"));
	
	Запрос.Выполнить();
	
	Возврат ПолучитьОбъектыКРасчету(МВТ);
	
КонецФункции

// Функция возвращает объекты к расчету по правилам.
//
// Параметры:
//  РазмерПакетаКПересчету	 - Число	 - Размер пакета к пересчету.
// 
// Возвращаемое значение:
//   - Соответствие
//
Функция ПолучитьОбъектыКРасчетуПоПравилам(РазмерПакетаКПересчету = 1000) Экспорт

	СоответствиеОбъектыКРасчету = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	  
	"ВЫБРАТЬ
	|	CRM_ЗаполненностьРеквизитовОбъектов.Правило КАК Правило,
	|	CRM_ЗаполненностьРеквизитовОбъектов.ДатаРасчета КАК ДатаРасчета
	|ИЗ
	|	РегистрСведений.CRM_ЗаполненностьРеквизитовОбъектов КАК CRM_ЗаполненностьРеквизитовОбъектов
	|ГДЕ
	|	CRM_ЗаполненностьРеквизитовОбъектов.Объект = НЕОПРЕДЕЛЕНО
	|	И CRM_ЗаполненностьРеквизитовОбъектов.ТребуетсяПересчет";	
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивОбъектов = ПолучитьОбъектыКРасчетуПоПравилу(Выборка.Правило, Выборка.ДатаРасчета, РазмерПакетаКПересчету);
			СоответствиеОбъектыКРасчету.Вставить(Выборка.Правило, МассивОбъектов);		
		КонецЦикла;
	КонецЕсли;
	
	Возврат СоответствиеОбъектыКРасчету;
	
КонецФункции

// Функция возвращает объекты к расчету по правилу.
//
// Параметры:
//  Правило					 - СправочникСсылка.CRM_ПравилаРасчетаКачестваЗаполненияДанных
//  ДатаРасчета				 - Дата	 - Дата расчета.
//  РазмерПакетаКПересчету	 - Число	 - Размер пакета к пересчету.
// 
// Возвращаемое значение:
//   - Соответствие
//
Функция ПолучитьОбъектыКРасчетуПоПравилу(Правило, ДатаРасчета, РазмерПакетаКПересчету = 1000) Экспорт

	ДанныеПравила = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Правило, "ТипОбъекта, СтатусРаботыСКлиентом");
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрШаблон(	  
	"ВЫБРАТЬ ПЕРВЫЕ %1
	|	ОбъектДляРасчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_ПравилаРасчетаКачестваЗаполненияДанных КАК ПравилоРасчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ %2 КАК ОбъектДляРасчета
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_ЗаполненностьРеквизитовОбъектов КАК CRM_ЗаполненностьРеквизитовОбъектов
	|			ПО ОбъектДляРасчета.Ссылка = CRM_ЗаполненностьРеквизитовОбъектов.Объект
	|				И (CRM_ЗаполненностьРеквизитовОбъектов.ДатаРасчета > &ДатаРасчета
	|					ИЛИ &ДатаРасчета = ДАТАВРЕМЯ(1, 1, 1))
	|		ПО (ПравилоРасчета.Ссылка = &Правило)
	|			И (ОбъектДляРасчета.%3 = ПравилоРасчета.СтатусРаботыСКлиентом)
	|				И (НЕ ОбъектДляРасчета.ПометкаУдаления)
	|ГДЕ
	|	CRM_ЗаполненностьРеквизитовОбъектов.Объект ЕСТЬ NULL",
	Формат(РазмерПакетаКПересчету, "ЧДЦ=0; ЧН=0; ЧГ=0"),
	ДанныеПравила.ТипОбъекта,
	?(ДанныеПравила.ТипОбъекта = "Справочник.Партнеры", "CRM_СтатусРаботы", "Владелец.CRM_СтатусРаботы"));	
	
	Запрос.УстановитьПараметр("Правило", Правило);
	Запрос.УстановитьПараметр("ДатаРасчета", ДатаРасчета);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
КонецФункции

// Функция возвращает данные расчета процента заполнения.
//
// Параметры:
//  СсылкаОбъектРасчета	 - СправочникСсылка.Партнеры, СправочникСсылка.КонтактныеЛицаПартнеров	 - Ссылка объекта расчета.
// 
// Возвращаемое значение:
//   - Структура, Неопределено
//
Функция ДанныеРасчетаПроцентаЗаполнения(СсылкаОбъектРасчета) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	CRM_ЗаполненностьРеквизитовОбъектов.Правило КАК Правило,
	|	CRM_ЗаполненностьРеквизитовОбъектов.Комментарий КАК Комментарий,
	|	CRM_ЗаполненностьРеквизитовОбъектов.ПроцентЗаполненностиОбщий КАК ПроцентЗаполненностиОбщий
	|ИЗ
	|	РегистрСведений.CRM_ЗаполненностьРеквизитовОбъектов КАК CRM_ЗаполненностьРеквизитовОбъектов
	|ГДЕ
	|	CRM_ЗаполненностьРеквизитовОбъектов.Объект = &ОбъектРасчета
	|	И НЕ CRM_ЗаполненностьРеквизитовОбъектов.ТребуетсяПересчет
	|	И CRM_ЗаполненностьРеквизитовОбъектов.Правило.ДатаИзменения < CRM_ЗаполненностьРеквизитовОбъектов.ДатаРасчета";
	Запрос.УстановитьПараметр("ОбъектРасчета", СсылкаОбъектРасчета);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			МассивВыполненныеУсловия = РаспарситьКомментарий(Выборка.Комментарий);
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПравилаРасчета.Ссылка КАК Правило,
			|	ПравилаРасчета.УсловиеПредставлениеДляПользователя КАК УсловиеПредставление,
			|	ПравилаРасчета.Вес КАК Вес,
			|	ПравилаРасчета.НомерСтроки В (&ВыполненныеУсловия) КАК Выполнено,
			|	ПравилаРасчета.НомерСтроки КАК НомерСтроки
			|ИЗ
			|	Справочник.CRM_ПравилаРасчетаКачестваЗаполненияДанных.Правила КАК ПравилаРасчета
			|ГДЕ
			|	ПравилаРасчета.Ссылка = &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	Выполнено УБЫВ,
			|	ПравилаРасчета.НомерСтроки";
			Запрос.УстановитьПараметр("Ссылка", Выборка.Правило);
			Запрос.УстановитьПараметр("ВыполненныеУсловия", МассивВыполненныеУсловия);
			
			ДанныеРасчета = Новый Структура("ПроцентЗаполнения, ДеталиРасчета",
				Выборка.ПроцентЗаполненностиОбщий,
				Запрос.Выполнить().Выгрузить());
				
			Возврат ДанныеРасчета;
		КонецЕсли;
	КонецЕсли; 
	
	Возврат Неопределено;

КонецФункции

// Функция возвращает массив частей комментария, разделенных по ";".
//
// Параметры:
//  Комментарий	 - Стрка	 - Комментарий.
// 
// Возвращаемое значение:
//   - Массив
//
Функция РаспарситьКомментарий(Комментарий) Экспорт
	
	МассивВыполненныеУсловия = Новый Массив;
	
	МассивКомментарий = СтрРазделить(Комментарий, ";", Ложь);
	Для каждого ТекЭлемент Из МассивКомментарий Цикл
		МассивВыполненныеУсловия.Добавить(Число(Лев(ТекЭлемент, СтрНайти(ТекЭлемент, ":") - 1)));
	КонецЦикла;
	
	Возврат МассивВыполненныеУсловия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОбъектыКРасчету(МВТ)
	
	СоответствиеОбъектыКРасчету = Новый Соответствие;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТ_ОбъектыРС.Объект КАК Объект,
	|	""Справочник.Партнеры"" КАК ТипОбъектаПравила,
	|	Партнеры.CRM_СтатусРаботы КАК СтатусРаботы
	|ПОМЕСТИТЬ ВТ_ОбъектыТипПравила
	|ИЗ
	|	ВТ_ОбъектыРС КАК ВТ_ОбъектыРС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|		ПО ВТ_ОбъектыРС.Объект = Партнеры.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ОбъектыРС.Объект,
	|	""Справочник.КонтактныеЛицаПартнеров"",
	|	КонтактныеЛица.Владелец.CRM_СтатусРаботы
	|ИЗ
	|	ВТ_ОбъектыРС КАК ВТ_ОбъектыРС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛица
	|		ПО ВТ_ОбъектыРС.Объект = КонтактныеЛица.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОбъектыТипПравила.Объект КАК Объект,
	|	ПравилаРасчета.Ссылка КАК Правило,
	|	0 КАК Приоритет
	|ПОМЕСТИТЬ ВТ_ОбъектыПравилаПриоритет
	|ИЗ
	|	ВТ_ОбъектыТипПравила КАК ВТ_ОбъектыТипПравила
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.CRM_ПравилаРасчетаКачестваЗаполненияДанных КАК ПравилаРасчета
	|		ПО ВТ_ОбъектыТипПравила.СтатусРаботы = ПравилаРасчета.СтатусРаботыСКлиентом
	|			И ВТ_ОбъектыТипПравила.ТипОбъектаПравила = ПравилаРасчета.ТипОбъекта
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОбъектыПравилаПриоритет.Объект КАК Объект,
	|	МАКСИМУМ(ВТ_ОбъектыПравилаПриоритет.Правило) КАК Правило
	|ПОМЕСТИТЬ ВТ_ОбъектыПравила
	|ИЗ
	|	ВТ_ОбъектыПравилаПриоритет КАК ВТ_ОбъектыПравилаПриоритет
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТ_ОбъектыПравилаПриоритет.Объект КАК Объект,
	|			МИНИМУМ(ВТ_ОбъектыПравилаПриоритет.Приоритет) КАК Приоритет
	|		ИЗ
	|			ВТ_ОбъектыПравилаПриоритет КАК ВТ_ОбъектыПравилаПриоритет
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВТ_ОбъектыПравилаПриоритет.Объект) КАК ВложенныйЗапрос
	|		ПО ВТ_ОбъектыПравилаПриоритет.Объект = ВложенныйЗапрос.Объект
	|			И ВТ_ОбъектыПравилаПриоритет.Приоритет = ВложенныйЗапрос.Приоритет
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ОбъектыПравилаПриоритет.Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОбъектыРС.Объект КАК Объект,
	|	ВТ_ОбъектыПравила.Правило КАК Правило
	|ИЗ
	|	ВТ_ОбъектыРС КАК ВТ_ОбъектыРС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбъектыПравила КАК ВТ_ОбъектыПравила
	|		ПО ВТ_ОбъектыРС.Объект = ВТ_ОбъектыПравила.Объект
	|ИТОГИ ПО
	|	Правило";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаПравило = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПравило.Следующий() Цикл
			МассивОбъекты = Новый Массив;
			Выборка = ВыборкаПравило.Выбрать();
			Пока Выборка.Следующий() Цикл
				МассивОбъекты.Добавить(Выборка.Объект);
			КонецЦикла; 
			
			СоответствиеОбъектыКРасчету.Вставить(ВыборкаПравило.Правило, МассивОбъекты);
		
		КонецЦикла;
	КонецЕсли; 
	
	Возврат СоответствиеОбъектыКРасчету;

КонецФункции

#Область ПереходНаНовуюВерсию

Процедура ОчиститьДанныеПриПереходеНаВерсию(Параметры) Экспорт
	Набор = СоздатьНаборЗаписей();
	Набор.Записать(Истина);
	
	Параметры.ОбработкаЗавершена = Истина;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
