#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриДвиженииСАТУРН" Тогда
			
			ТипПараметраДокументаОснованиеАктИнвентаризации = Метаданные.ОпределяемыеТипы.ОснованиеАктИнвентаризацииСАТУРН.Тип;
			ТипПараметраДокументаОснованиеАктПрименения     = Метаданные.ОпределяемыеТипы.ОснованиеАктПримененияСАТУРН.Тип;
			ТипПараметраДокументаОснованиеИмпортПродукции   = Метаданные.ОпределяемыеТипы.ОснованиеИмпортПродукцииСАТУРН.Тип;
			ТипПараметраДокументаНакладная                  = Метаданные.ОпределяемыеТипы.ОснованиеНакладнаяСАТУРН.Тип;
			ТипПараметраДокументаПланПрименения             = Метаданные.ОпределяемыеТипы.ОснованиеПланПримененияСАТУРН.Тип;
			ТипПараметраДокументаПроизводственнаяОперация   = Метаданные.ОпределяемыеТипы.ОснованиеПроизводственнаяОперацияСАТУРН.Тип;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	АктИнвентаризацииСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.АктИнвентаризацииСАТУРН КАК АктИнвентаризацииСАТУРН
				|ГДЕ
				|	АктИнвентаризацииСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ АктИнвентаризацииСАТУРН.ДокументОснование В (&ПустыеОснованияАктИнвентаризации)
				|	
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	АктПримененияСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.АктПримененияСАТУРН КАК АктПримененияСАТУРН
				|ГДЕ
				|	АктПримененияСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ АктПримененияСАТУРН.ДокументОснование В (&ПустыеОснованияАктПрименения)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ИмпортПродукцииСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ИмпортПродукцииСАТУРН КАК ИмпортПродукцииСАТУРН
				|ГДЕ
				|	ИмпортПродукцииСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ИмпортПродукцииСАТУРН.ДокументОснование В (&ПустыеОснованияИмпортПродукции)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	НакладнаяСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.НакладнаяСАТУРН КАК НакладнаяСАТУРН
				|ГДЕ
				|	НакладнаяСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ НакладнаяСАТУРН.ДокументОснование В (&ПустыеОснованияНакладная)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ПланПримененияСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ПланПримененияСАТУРН КАК ПланПримененияСАТУРН
				|ГДЕ
				|	ПланПримененияСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ПланПримененияСАТУРН.ДокументОснование В (&ПустыеОснованияПланПрименения)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ПроизводственнаяОперацияСАТУРН.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ПроизводственнаяОперацияСАТУРН КАК ПроизводственнаяОперацияСАТУРН
				|ГДЕ
				|	ПроизводственнаяОперацияСАТУРН.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ПроизводственнаяОперацияСАТУРН.ДокументОснование В (&ПустыеОснованияПроизводственнаяОперация)
				|";
			
			Запрос.УстановитьПараметр("МассивСсылок",    Параметры.ПараметрКоманды);
			
			Запрос.УстановитьПараметр("ПустыеОснованияАктИнвентаризации",        ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаОснованиеАктИнвентаризации));
			Запрос.УстановитьПараметр("ПустыеОснованияАктПрименения",            ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаОснованиеАктПрименения));
			Запрос.УстановитьПараметр("ПустыеОснованияИмпортПродукции",          ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаОснованиеИмпортПродукции));
			Запрос.УстановитьПараметр("ПустыеОснованияНакладная",                ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаНакладная));
			Запрос.УстановитьПараметр("ПустыеОснованияПланПрименения",           ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаПланПрименения));
			Запрос.УстановитьПараметр("ПустыеОснованияПроизводственнаяОперация", ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаПроизводственнаяОперация));
			
			МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
			
			Форма.ФормаПараметры.Отбор.Вставить("ДокументОснование", МассивСсылок);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект, Форма);
	
КонецПроцедуры

//Часть запроса отвечающего за данные прикладных документов
//
//Возвращаемое значение:
//   Строка - переопределяемая часть отчета о расхождениях
//
Функция ПереопределяемаяЧасть() Экспорт
	
	Возврат ОтчетыИС.ШаблонПолученияДанныхПрикладныхДокументов(Истина);
	
КонецФункции

#КонецОбласти

#КонецЕсли