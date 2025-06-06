///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОФД".
// ОбщийМодуль.ОФДПереопределяемый.
//
//  Переопределяемые серверные процедуры получения данных из ОФД:
//  - определение объектов выступающих в роли типов загружаемых документов по данным ОФД;
//  - определение используемых сценариев интеграции с ОФД, используемых прикладной логикой.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСПрикладнымРешением

// Определяет настройки использования сценариев интеграции с ОФД.
//
// Параметры:
//  Настройки - Структура - описывает использование сценариев интеграции с ОФД:
//    * ИспользоватьЗагрузкуИтоговСмены - Булево - признак использования сценария сверки смены перед ее закрытием;
//    * ИспользоватьЗагрузкуДокументов - Булево - признак использования сценария загрузки документов по данным ОФД.
//
//@skip-warning
Процедура ПриОпределенииНастроекИнтеграции(Настройки) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
