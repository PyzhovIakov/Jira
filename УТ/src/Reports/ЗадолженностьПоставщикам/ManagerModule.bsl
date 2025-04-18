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
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ЗадолженностьПоставщикам);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "");
	ОписаниеВарианта.Описание = НСтр("ru= 'Текущее состояние расчетов с поставщиками.
		|Какой долг поставщику сейчас? На какую сумму планируется поступление?
		|На какую сумма ожидается оплата поставщику?'");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикам");
	ОписаниеВарианта.Описание = НСтр("ru= 'Текущее состояние расчетов с поставщиками.
		|Какой долг поставщику сейчас? На какую сумму планируется поступление?
		|На какую сумма ожидается оплата поставщику?'");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеБазоваяВерсия");
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамБазовая");
	ОписаниеВарианта.Описание = НСтр("ru= 'Текущее состояние расчетов с поставщиками.
		|Какой долг поставщику сейчас? На какую сумму планируется поступление?
		|На какую сумма ожидается оплата поставщику?'");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("БазоваяВерсия");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамПоОбъектуРасчетовКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамПоОбъектуРасчетовКонтекстБазовая");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикуКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикуКонтекстБазовая");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамКонтекстБазовая");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ЗадолженностьПоставщикамМобильныйКлиент");
	ОписаниеВарианта.Описание = НСтр("ru= 'Текущее состояние расчетов с поставщиками.
		|Какой долг поставщику сейчас? На какую сумму планируется поступление?
		|На какую сумма ожидается оплата поставщику?'");
	ОписаниеВарианта.Наименование = НСтр("ru='Задолженность поставщикам (моб.)'");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	ОписаниеВарианта.Назначение = Перечисления.НазначенияВариантовОтчетов.ДляСмартфонов;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
