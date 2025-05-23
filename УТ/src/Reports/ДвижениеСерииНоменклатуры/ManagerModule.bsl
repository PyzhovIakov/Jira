//@strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задает расширенные настройки отчета
//
// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   ИспользоватьПроизводство - Булево.
//
Процедура НастроитьВариантыОтчета(Настройки, ИспользоватьПроизводство) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДвижениеСерииНоменклатуры);
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьСерииНоменклатуры");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	ОписаниеВарианта.Описание = ?(ИспользоватьПроизводство,
									НСтр("ru= 'Детальный анализ движения серии номенклатуры на складах и в производстве.'"),
									НСтр("ru= 'Детальный анализ движения серии номенклатуры на складах.'"));
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ДвижениеСерииНоменклатуры");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьСерииНоменклатуры");
	ОписаниеВарианта.Описание = ?(ИспользоватьПроизводство,
									НСтр("ru= 'Детальный анализ движения серии номенклатуры на складах и в производстве.'"),
									НСтр("ru= 'Детальный анализ движения серии номенклатуры на складах.'"));
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ДвижениеСерииНоменклатурыКонтекст");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
