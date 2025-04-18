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
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.КонтрольНомеровГТДТоваров);
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "");
	ОписаниеВарианта.Описание = НСтр("ru= 'Контроль корректности учета операций с импортными товарами с указанием номера ГТД и страны происхождения.'");
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "КонтрольНомеровГТДТоваров");
	ОписаниеВарианта.Описание = НСтр("ru= 'Контроль корректности учета операций с импортными товарами с указанием номера ГТД и страны происхождения.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеБазоваяВерсия");
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "КонтрольНомеровГТДТоваровБазовая");
	ОписаниеВарианта.Описание = НСтр("ru= 'Контроль корректности учета операций с импортными товарами с указанием номера ГТД и страны происхождения.'");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("БазоваяВерсия");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
