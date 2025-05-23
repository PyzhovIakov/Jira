
#Область ПрограммныйИнтерфейс

#Область ПодключаемыеКоманды
// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	//++ Локализация
	
	//-- Локализация
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийМодуляОбъекта

// Обработчик события ОбработкаПроверкиЗаполнения объекта справочника Договоры
//
// Параметры:
//  Отказ - Булево - см. описание платформенного метода ОбработкаПроверкиЗаполнения
//  ПроверяемыеРеквизиты - Массив - см. описание платформенного метода ОбработкаПроверкиЗаполнения
//  МассивНепроверяемыхРеквизитов - Массив - массив путей к реквизитам, для которых не будет выполнена проверка заполнения. 
//  СправочникОбъект - СправочникОбъект.ДоговорыКредитовИДепозитов
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, СправочникОбъект) Экспорт
	//++ Локализация
		
	Перем Ошибки;
	
	КонтрагентЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СправочникОбъект.Контрагент, "ЮрФизЛицо");
	
	Если СправочникОбъект.УникальныйНомерВалютногоКонтроля <> ""
		И ИспользоватьУникальныйНомерВалютногоКонтроля(СправочникОбъект, КонтрагентЮрФизЛицо) Тогда
		ДенежныеСредстваКлиентСерверЛокализация.ПроверитьУникальныйНомерВалютногоКонтракта(
			СправочникОбъект, СправочникОбъект.УникальныйНомерВалютногоКонтроля, Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	//-- Локализация
КонецПроцедуры

// Обработчик события ОбработкаОповещения формы элемента справочника Договоры
//
// Параметры:
//  Отказ - Булево - см. описание платформенного метода ПередЗаписью
//  СправочникОбъект - СправочникОбъект.ДоговорыКредитовИДепозитов - записываемый объект
//
Процедура ПередЗаписью(Отказ, СправочникОбъект) Экспорт
	//++ Локализация
	
	Если СправочникОбъект.УникальныйНомерВалютногоКонтроля <> "" Тогда
		
		КонтрагентЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СправочникОбъект.Контрагент, "ЮрФизЛицо");
		
		Если Не ИспользоватьУникальныйНомерВалютногоКонтроля(СправочникОбъект, КонтрагентЮрФизЛицо) Тогда
			СправочникОбъект.УникальныйНомерВалютногоКонтроля = "";
		КонецЕсли;
		
	КонецЕсли;
	
	//-- Локализация	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

Процедура ПриОкончанииИзмененияРеквизита(ИмяЭлемента, Форма, ПараметрыОбработки) Экспорт
	Если ТипЗнч(ИмяЭлемента) = Тип("Массив") Тогда
		Для каждого ТекЭлемент Из ИмяЭлемента Цикл
			ПриОкончанииИзмененияРеквизита(ТекЭлемент, Форма, ПараметрыОбработки);
		КонецЦикла;
	КонецЕсли;
	//++ Локализация

	Если ИмяЭлемента = "ХарактерДоговора" Тогда
		ХарактерДоговораПриИзменении(Форма);
		УстановитьВидимостьИдентификатораВалютногоКонтракта(Форма);
	КонецЕсли;
	
	Если ИмяЭлемента = "ТипДоговора"
		Или ИмяЭлемента = "Контрагент"
		Или ИмяЭлемента = "Валюта"
		Или ИмяЭлемента = "Организация" Тогда
		УстановитьВидимостьИдентификатораВалютногоКонтракта(Форма);
	КонецЕсли; 
	
	
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Обработчик события ПриСозданииНаСервере форм элемента справочника ДоговорыКонтрагентов.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, для которой выполняется обработчик.
//  Отказ                - Булево - признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПриСозданииНаСервереФормаЭлемента(Форма, Отказ, СтандартнаяОбработка) Экспорт
	НастройкиСистемыЛокализация.УстановитьВидимостьЭлементовЛокализации(Форма);
	//++ Локализация
	//-- Локализация
КонецПроцедуры

// Обработчик события ОбработкаПроверкиЗаполненияНаСервере
// 
// Параметры:
// 	Отказ - Булево - признак отказа.
// 	ПроверяемыеРеквизиты - Массив - массив путей к проверяемым реквизитам.
// 	Форма - ФормаКлиентскогоПриложения - форма обработчика.
//
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты, Форма) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

// Вызывается при создании/чтении формы на сервере
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма обработчика
//
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	//++ Локализация

	
	УстановитьВидимостьИдентификатораВалютногоКонтракта(Форма);
	

	//-- Локализация
КонецПроцедуры

// Обработчик события ПослеЗаписиНаСервере формы элемента справочника ДоговорыКонтрагентов
//
// Параметры:
//  ТекущийОбъект   - СправочникОбъект - объект, который будет прочитан.
//  ПараметрыЗаписи - Структура - структура, содержащая параметры записи.
//  Форма           - ФормаКлиентскогоПриложения - форма, для которой выполняется обработчик.
//
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, Форма) Экспорт
	//++ Локализация
	
	//-- Локализация
КонецПроцедуры

// Обработчик события ПередЗаписьюНаСервере формы элемента справочника ДоговорыКонтрагентов
//
// Параметры:
//  Отказ           - Булево - признак отказа.
//  ТекущийОбъект   - СправочникОбъект - объект, который будет прочитан.
//  ПараметрыЗаписи - Структура - структура, содержащая параметры записи.
//  Форма           - ФормаКлиентскогоПриложения - форма, для которой выполняется обработчик.
//
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, Форма) Экспорт
	//++ Локализация

	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура ВыполнитьКомандуЛокализации(Форма, ИмяКоманды, ПараметрыОбработки) Экспорт
	
	Если ТипЗнч(ИмяКоманды) = Тип("Массив") Тогда
		Для каждого ТекЭлемент Из ИмяКоманды Цикл
			ВыполнитьКомандуЛокализации(Форма, ТекЭлемент, ПараметрыОбработки);
		КонецЦикла;
	КонецЕсли;
	//++ Локализация


	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление формы
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма обработчика
//
Процедура УстановитьУсловноеОформление(Форма) Экспорт
	УсловноеОформление = Форма.УсловноеОформление;
	Элементы =  Форма.Элементы;
КонецПроцедуры

#КонецОбласти

#Область ПрочиеСлужебныеМетоды

Процедура ДополнитьДанныеШапкиДокументаДДС(ДанныеШапки, ДоговорКредитаДепозита) Экспорт
	//++ Локализация
	
	ДанныеШапки.Вставить("ПлатежиПо275ФЗ", Ложь);

	//-- Локализация
	
КонецПроцедуры

// Дополняется настройки
// 
// Параметры:
//     Настройки - ТаблицаЗначений - таблица с колонками:
//         * Поля - Массив из Строка - Поля, для которых действует настройка.
//         * Условие - ОтборКомпоновкиДанных - Определяет действительность настройки.
//         * Свойства - Структура - Свойства полей.
//
Процедура ДополнитьНастройкиПолейФормы(Настройки) Экспорт
	//++ Локализация
		
	
	//-- Локализация
КонецПроцедуры

//++ Локализация


//-- Локализация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийЭлементовШапкиФормы_Служебные
//++ Локализация

Процедура ХарактерДоговораПриИзменении(Форма)
КонецПроцедуры

Процедура УстановитьВидимостьИдентификатораВалютногоКонтракта(Форма)

	Элементы = Форма.Элементы;
	Элементы.УникальныйНомерВалютногоКонтроля.Видимость =
		ИспользоватьУникальныйНомерВалютногоКонтроля(Форма.Объект, Форма.КонтрагентЮрФизЛицо);
	
КонецПроцедуры


Функция ИспользоватьУникальныйНомерВалютногоКонтроля(Объект, КонтрагентЮрФизЛицо)

	ХарактерыДоговоров = Новый Массив;
	ХарактерыДоговоров.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	ХарактерыДоговоров.Добавить(Перечисления.ХарактерыДоговоровФинансовыхИнструментов.ЗаймВыданный);
	
	ТипыДоговоров = Новый Массив;
	ТипыДоговоров.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.КредитВБанке);
	ТипыДоговоров.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВнешнийЗайм);
	
	Возврат ХарактерыДоговоров.Найти(Объект.ХарактерДоговора) <> Неопределено
		И ТипыДоговоров.Найти(Объект.ТипДоговора) <> Неопределено
		И ДенежныеСредстваКлиентСерверЛокализация.ПрименяетсяВалютныйКонтроль(КонтрагентЮрФизЛицо);

КонецФункции

//-- Локализация
#КонецОбласти

#КонецОбласти