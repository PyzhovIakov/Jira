///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Библиотека подключаемого оборудования".
// ОбщийМодуль.ИнтеграцияПодсистемБПО.
//
// Серверные процедуры и функции интеграции с БСП:
//  - Подписка на события БСП;
//  - Обработка событий БСП;
//  - Определение списка возможных подписок в БСП;
//  - Вызов методов БСП, на которые выполнена подписка.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	// БазоваяФункциональность
	Подписки.ПриДобавленииПодсистем = Истина;
	Подписки.ПриДобавленииПараметровРаботыКлиентаПриЗапуске = Истина;
	Подписки.ПриДобавленииОбработчиковУстановкиПараметровСеанса = Истина;
	
	// ВнешниеКомпоненты
	Подписки.ПриОпределенииИспользуемыхВнешнихКомпонент = Истина;
	
	// РегламентныеЗадания
	Подписки.ПриОпределенииНастроекРегламентныхЗаданий = Истина;
	
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСП.ПриОпределенииИспользуемыхВнешнихКомпонент.
//
Процедура ПриОпределенииИспользуемыхВнешнихКомпонент(Компоненты) Экспорт
	
	МенеджерОборудования.ЗаполнитьИспользуемыеВнешниеКомпоненты(Компоненты);
	
КонецПроцедуры

#Область БазоваяФункциональность

// См. ПодсистемыКонфигурацииПереопределяемый.ПриДобавленииПодсистем.
//
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБПО");
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если ОбщегоНазначенияБПО.РазделениеВключено() 
		И Не ОбщегоНазначенияБПО.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияБПО.ИспользуетсяБСП() Тогда
		Параметры.Вставить("ИменаПодсистем", ОбщегоНазначенияБПОПовтИсп.ИменаПодсистем());
		Если Параметры.Свойство("ТекущаяДатаНаКлиенте") Тогда
			ДатаСеанса = ТекущаяДатаСеанса();
			Параметры.Вставить("ПоправкаКВремениСеанса", ДатаСеанса - Параметры.ТекущаяДатаНаКлиенте);
		Иначе
			Параметры.Вставить("ПоправкаКВремениСеанса", 0);
		КонецЕсли;
	КонецЕсли;
	
	ИдентификаторОбсужденияРаспределеннойФискализации = Неопределено;
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		ИдентификаторОбсужденияРаспределеннойФискализации = МодульРаспределеннаяФискализация.ПодключениеСистемыВзаимодействия();
	КонецЕсли;
	
	ВерсияБСП = ОбщегоНазначенияБПО.ВерсияБСП();
	Параметры.Вставить("ВерсияБСП", ВерсияБСП);
	Параметры.Вставить("ИдентификаторОбсужденияРаспределеннойФискализации", ИдентификаторОбсужденияРаспределеннойФискализации);
	Параметры.Вставить("СоответствиеТиповОборудования", МенеджерОборудования.СоответствиеТиповОборудования());
	Параметры.Вставить("ДоступныеТипыОборудования", МенеджерОборудования.ДоступныеТипыОборудования(Истина));
	
	УстановитьПривилегированныйРежим(Истина);
	РабочееМесто = ПараметрыСеанса.РабочееМестоКлиента; // требуется прямое обращение к параметру сеанса
	Параметры.Вставить("MACАдресРабочегоМеста", "");
	Параметры.Вставить("ИдентификаторКлиентаРабочегоМеста", "");
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		РеквизитыРабочееМесто = ОбщегоНазначенияБПО.ЗначенияРеквизитовОбъекта(РабочееМесто, "Код, MACАдрес");
		Параметры.MACАдресРабочегоМеста = РеквизитыРабочееМесто.MACАдрес;
		Параметры.ИдентификаторКлиентаРабочегоМеста = РеквизитыРабочееМесто.Код;
	КонецЕсли;
	Параметры.Вставить("РабочееМесто", РабочееМесто);
	// ++ НеМобильноеПриложение
	Если ОбщегоНазначенияБПО.ДоступноИспользованиеРазделенныхДанных() Тогда
		Параметры.Вставить("ИспользуетсяRDP", МенеджерОборудования.ИспользуетсяПротоколRDP());
	Иначе
		Параметры.Вставить("ИспользуетсяRDP", Ложь);
	КонецЕсли;
	// -- НеМобильноеПриложение
	
#Если НЕ МобильноеПриложениеСервер Тогда   
	ИмяКомпьютера = ПолучитьТекущийСеансИнформационнойБазы().ИмяКомпьютера;  
#Иначе 
	ИмяКомпьютера = "";
#КонецЕсли
	Параметры.Вставить("ИмяКомпьютера", ИмяКомпьютера);
	ИдентификаторКлиента = МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста();
	
	ОборудованиеДляПереустановки = МенеджерОборудования.МакетыДляПереустановкиДрайверов(ИдентификаторКлиента, ИмяКомпьютера);
	Параметры.Вставить("ОборудованиеДляПереустановки", ОборудованиеДляПереустановки);
	
	Параметры.Вставить("ПараметрыЛогированияОперацийСОборудованием", Неопределено);
	Если ОбщегоНазначенияБПО.ИспользуетсяПодсистемаЛогирования() Тогда
		
		МодульЛогированиеОперацийБПО = ОбщегоНазначенияБПО.ОбщийМодуль("ЛогированиеОперацийБПО");
		ПараметрыЛогирования = МодульЛогированиеОперацийБПО.ПараметрыЛогированияОперацийСОборудованием();
		Параметры.ПараметрыЛогированияОперацийСОборудованием = ПараметрыЛогирования;
		
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("РабочееМестоКлиента", 
		"МенеджерОборудованияВызовСервера.УстановитьПараметрыСеансаПодключаемогоОборудования");
	
КонецПроцедуры                      

// Вызов этой процедуры необходимо разместить в модуле сеанса в процедуре УстановкаПараметровСеанса
// согласно документации.
//
// Параметры:
//  ИменаПараметровСеанса - Массив - устанавливаемые идентификаторы параметров сеанса
//
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса) Экспорт
	
	Если ИменаПараметровСеанса <> Неопределено Тогда
		
		Для Каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
			Если ИмяПараметра = "РабочееМестоКлиента" Тогда
				МенеджерОборудованияВызовСервера.УстановитьПараметрыСеансаПодключаемогоОборудования(ИмяПараметра, Неопределено);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызов этой процедуры необходимо выполнить после обновления БПО, если не используется БСП
Процедура ОбновлениеИнформационнойБазыБПО() Экспорт
	
	РегистрыСведений.ЗначенияЕМРЦ.ЗаполнитьЗначенияРегистраЕМРЦ();
	
	МенеджерОборудования.ОбновитьПоставляемыеДрайвера(); 
	МенеджерОборудования.ОбновитьУстановленныеДрайвера();
	
	ОбновлениеИнформационнойБазыБПО.ОбновитьШаблоныЭтикетокИЦенников();
	ОбновлениеИнформационнойБазыБПО.ОбновитьПараметрыРегистрацииОборудования();
	ОбновлениеИнформационнойБазыБПО.УстановитьСрокХраненияОпераций()
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// Вызывается из процедуры РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
// для установки доступности регламентного задания, определяет зависимость от функциональных опций.
// 
// Параметры:
//  Настройки - ТаблицаЗначений
//  ФункциональнаяОпция - ОбъектМетаданныхФункциональнаяОпция
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция = Неопределено) Экспорт
	
	// ++ НеМобильноеПриложение
	Если ОбщегоНазначенияБПО.ИспользуетсяПлатежныеСистемы() Тогда
		МодульОборудованиеПлатежныеСистемы = ОбщегоНазначенияБПО.ОбщийМодуль("ОборудованиеПлатежныеСистемы");
		МодульОборудованиеПлатежныеСистемы.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
	КонецЕсли;
	
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройства = ОбщегоНазначенияБПО.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройства");
		МодульОборудованиеЧекопечатающиеУстройства.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
		Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
			МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
			МодульМенеджерОборудованияМаркировка.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
		КонецЕсли;
	КонецЕсли;

	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
	КонецЕсли;

	Если ОбщегоНазначенияБПО.ИспользуетсяРассылкаЭлектронныхЧеков() Тогда
		МодульРассылкаЭлектронныхЧеков = ОбщегоНазначенияБПО.ОбщийМодуль("РассылкаЭлектронныхЧеков");
		МодульРассылкаЭлектронныхЧеков.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
	КонецЕсли;
	
	Если ОбщегоНазначенияБПО.ИспользуетсяПодсистемаЛогирования() Тогда
		МодульЛогированиеОперацийБПО = ОбщегоНазначенияБПО.ОбщийМодуль("ЛогированиеОперацийБПО");
		МодульЛогированиеОперацийБПО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки, ФункциональнаяОпция);
	КонецЕсли;
	// -- НеМобильноеПриложение
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗаданияТехнологияСервиса

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	// ++ НеМобильноеПриложение
	Если ОбщегоНазначенияБПО.ИспользуетсяПлатежныеСистемы() Тогда
		ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ОчисткаИсторииПлатежныхОпераций.Имя);
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ОчисткаИсторииФискальныхОпераций.Имя);
		Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
			МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
			МодульМенеджерОборудованияМаркировка.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
		КонецЕсли;
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяРассылкаЭлектронныхЧеков() Тогда
		МодульРассылкаЭлектронныхЧеков = ОбщегоНазначенияБПО.ОбщийМодуль("РассылкаЭлектронныхЧеков");
		МодульРассылкаЭлектронныхЧеков.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	КонецЕсли;
	
	Если ОбщегоНазначенияБПО.ИспользуетсяПодсистемаЛогирования() Тогда
		МодульЛогированиеОперацийБПО = ОбщегоНазначенияБПО.ОбщийМодуль("ЛогированиеОперацийБПО");
		МодульЛогированиеОперацийБПО.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	КонецЕсли;
	
	// -- НеМобильноеПриложение
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	// ++ НеМобильноеПриложение
	Если ОбщегоНазначенияБПО.ИспользуетсяПлатежныеСистемы() Тогда
		СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОчисткаИсторииПлатежныхОпераций.ИмяМетода);
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОчисткаИсторииФискальныхОпераций.ИмяМетода);
		Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
			МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
			МодульМенеджерОборудованияМаркировка.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
		КонецЕсли;
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяРассылкаЭлектронныхЧеков() Тогда
		МодульРассылкаЭлектронныхЧеков = ОбщегоНазначенияБПО.ОбщийМодуль("РассылкаЭлектронныхЧеков");
		МодульРассылкаЭлектронныхЧеков.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	КонецЕсли;
	Если ОбщегоНазначенияБПО.ИспользуетсяПодсистемаЛогирования() Тогда
		МодульЛогированиеОперацийБПО = ОбщегоНазначенияБПО.ОбщийМодуль("ЛогированиеОперацийБПО");
		МодульЛогированиеОперацийБПО.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	КонецЕсли;
	// -- НеМобильноеПриложение
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
