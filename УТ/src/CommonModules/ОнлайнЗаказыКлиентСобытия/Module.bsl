///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОнлайнЗаказы".
// ОбщийМодуль.ОнлайнЗаказыКлиентСобытия.
//
// Клиентские процедуры обработки событий подсистемы Онлайн-заказы:
//  - выбор настройки подключения.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаСобытий

// Определяет поведение системы при выборе настройки подключения.
//
// Параметры:
//  Владелец - ФормаКлиентскогоПриложения - форма владелец.
//  СпособОплаты - Перечисление.СпособыОплатыОнлайнЗаказов - способ оплаты по настройке подключения.
//
Процедура ПриВыбореНастройкиПодключения(Владелец, Оповещение, СпособОплаты) Экспорт
	
	Если СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыОнлайнЗаказов.СБПc2b")
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП") Тогда
		
		МодульСистемаБыстрыхПлатежейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СистемаБыстрыхПлатежейКлиент");
		МодульСистемаБыстрыхПлатежейКлиент.ВыбратьНастройку(
			Владелец,
			Оповещение,
			"c2b");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти