//@strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задает расширенные настройки отчета
//
// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ПлатежнаяДисциплинаКлиентов);
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "");
	ОписаниеВарианта.Описание = НСтр("ru= 'Как часто, на сколько дней и какие клиенты задерживают оплаты?'");
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ПлатежнаяДисциплинаКлиентов");
	ОписаниеВарианта.Описание = НСтр("ru= 'Контроль просроченной задолженности у клиентов в течении выбранного периода.
		|Как часто, на сколько дней и какие клиенты задерживают оплаты?'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
