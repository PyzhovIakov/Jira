// @strict-types


#Область ПрограммныйИнтерфейс

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БЭД.

// @skip-check property-return-type
// Определяет события, на которые подписана эта библиотека.
// 
// Параметры:
//  Подписки - см. ИнтеграцияПодсистемБСПКлиент.СобытияБСП.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	Подписки.ПередПериодическойОтправкойДанныхКлиентаНаСервер = Истина;
	Подписки.ПослеПериодическогоПолученияДанныхКлиентаНаСервере = Истина;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер
//
Процедура ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере
//
Процедура ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
