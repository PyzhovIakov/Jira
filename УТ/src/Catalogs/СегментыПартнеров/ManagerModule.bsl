#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//   Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("СпособФормирования");
	Результат.Добавить("РегламентноеЗаданиеИспользуется; РегламентноеЗаданиеАктивно");
	Результат.Добавить("ПредставлениеШаблонаСКД; Настройки");
	Результат.Добавить("Расписание; НастроитьРасписание");
	Результат.Добавить("ЗапретОтгрузки");
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ПроверятьНаВхождениеПриСозданииНового");
	НеРедактируемыеРеквизиты.Добавить("СхемаКомпоновкиДанных");
	НеРедактируемыеРеквизиты.Добавить("ХранилищеНастроекКомпоновкиДанных");
	НеРедактируемыеРеквизиты.Добавить("РегламентноеЗадание");
	НеРедактируемыеРеквизиты.Добавить("ИмяШаблонаСКД");
	НеРедактируемыеРеквизиты.Добавить("ЗапретОтгрузки");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Возвращает сегмент партнеров, которому запрещена отгрузка, если он один
//
// Возвращаемое значение:
//   СправочникСсылка.СегментыПартнеров - сегмент партнеров, которому запрещена отгрузка.
//
Функция ПолучитьСегментЗапретаОтгрузки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СегментыПартнеров.Ссылка КАК Сегмент
	|ИЗ
	|	Справочник.СегментыПартнеров КАК СегментыПартнеров
	|ГДЕ
	|	СегментыПартнеров.ЗапретОтгрузки
	|	И НЕ СегментыПартнеров.ПометкаУдаления";
		
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Сегмент;
	Иначе
		Возврат Справочники.СегментыПартнеров.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СегментыПартнеров.Ссылка,
	|	СегментыПартнеров.ИмяШаблонаСКД
	|ИЗ
	|	Справочник.СегментыПартнеров КАК СегментыПартнеров";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.ИмяШаблонаСКД) Тогда
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.СегментыПартнеров
			СправочникОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения("");
			СправочникОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения("");
			
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	ИспользоватьВзаимодействия = ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент");
	
	Для каждого Макет Из Метаданные.Справочники.СегментыПартнеров.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если НЕ ИспользоватьВзаимодействия И Макет.Имя = "ПоВзаимодействиям" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.ВыручкаИСебестоимостьПродаж.ДобавитьКомандуПродажиПоСегменту(КомандыОтчетов);
	
	Отчеты.ПересеченияСегментаПартнеров.ДобавитьКомандуОтчета(КомандыОтчетов);
	
	ВзаиморасчетыСервер.ВедомостьРасчетовСПартнерами_ДобавитьКомандуОтчета(КомандыОтчетов);
	
	КомандаОтчет = Отчеты.СоставСегмента.ДобавитьКомандуОтчета(КомандыОтчетов);
		
	КомандаОтчет = Отчеты.КонтактнаяИнформация.ДобавитьКомандуКонтактнаяИнформацияПоПартнерам(КомандыОтчетов);
	
	КомандаОтчет = Отчеты.КонтактнаяИнформация.ДобавитьКомандуКонтактнаяИнформацияКонтактныхЛиц(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
