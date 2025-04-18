///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = Метаданные.Обработки.CRM_ПанельАдминистрированияРаботыСРечью.Формы.НастройкаРаботыСРечью;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьТокенПоПараметрамВнешнегоПодключенияСеанса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущиеПараметры = CRM_РаботаСРечьюБМОСервер.ПолучитьПараметрыВнешнегоПодключенияСеанса();
	Если ТекущиеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Установить(ТекущиеПараметры.Токен);
	
КонецПроцедуры

Процедура УстановитьСохраненныйТокенВПараметрыВнешнегоПодключенияСеанса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущиеПараметры = CRM_РаботаСРечьюБМОСервер.ПолучитьПараметрыВнешнегоПодключенияСеанса();
	Если ТекущиеПараметры = Неопределено Тогда
		ТекущиеПараметры = CRM_РаботаСРечьюБМОСервер.НовыйПараметрыВнешнегоПодключенияРаботыСРечью("");
	КонецЕсли;
	ТекущиеПараметры.Токен = Получить();
	CRM_РаботаСРечьюБМОСервер.УстановитьПараметрыВнешнегоПодключенияСеанса(ТекущиеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли