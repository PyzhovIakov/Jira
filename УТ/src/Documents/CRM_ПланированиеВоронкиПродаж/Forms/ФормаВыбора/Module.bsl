
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ЗначениеНастройки = Настройки.Получить("ПолеБыстрогоОтбора_Статус");
	Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Статус", ЗначениеНастройки, Истина);
	КонецЕсли;
	ЗначениеНастройки = Настройки.Получить("ПолеБыстрогоОтбора_Автор");
	Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Автор", ЗначениеНастройки, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ CRM_ЛицензированиеЭкспортныеМетоды.ПодсистемаCRMИспользуется() Тогда
		CRM_ЛицензированиеЭкспортныеМетоды.ВывестиУведомлениеОНедоступности(НСтр("ru = 'форму выбора планов'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьЗащищеннуюОбработку().ПриСозданииНаСервере(ЭтотОбъект,
		 Отказ,
		 СтандартнаяОбработка);
	
	ПланироватьПродажи = ПолучитьФункциональнуюОпцию("CRM_ПланироватьПродажи");
	Если ПланироватьПродажи <> Истина Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(CRM_КлиентыСервер.ТекстСообщенияОНевозможностиПланирования());
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеБыстрогоОтбораПриИзмененииОбщий(Элемент)
	
	CRM_ОбщегоНазначенияКлиентСервер.БыстрыйОтборПрименитьОтборКСписку(Список, Элемент, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
