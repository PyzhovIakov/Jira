#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Состав обязательных процедур такого модуля см. в общем модуле ОбновлениеИнформационнойБазыБСП
// (область ПрограммныйИнтерфейс).
// При этом сам модуль Библиотеки стандартных подсистем ОбновлениеИнформационнойБазыБСП
// не требуется явно добавлять в массив МодулиПодсистем.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//                             Например: "ОбновлениеИнформационнойБазыБРО" - библиотека,
//                                       "ОбновлениеИнформационнойБазыБП"  - конфигурация.
//                    
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	//++ Локализация
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБЭД");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЕГАИС");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыГИСМ");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыВЕТИС");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыИСМП");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыГосИС");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБРД");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЗЕРНО");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыСАТУРН");
	
	//++ НЕ ГОСИС


	//-- НЕ ГОСИС
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
