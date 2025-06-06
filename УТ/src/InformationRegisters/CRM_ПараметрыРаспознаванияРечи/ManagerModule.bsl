///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Функция возвращает текущие параметры распознавания речи.
//
// Параметры:
//  ИмяФормы	 - Строка	 - Имя формы.
//  Пользователь - ПользовательИнформационнойБазы, Неопределено	 - Пользователь информационной базы.
// 
// Возвращаемое значение:
//   - ПараметрыРаспознаванияРечи
//
Функция ПолучитьБезопасно(ИмяФормы = "", Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Менеджер = РегистрыСведений.CRM_ПараметрыРаспознаванияРечи.СоздатьМенеджерЗаписи();
	Менеджер.ИмяФормы = ИмяФормы;
	Менеджер.Пользователь = Пользователь;
	Менеджер.Прочитать();
	
	ТекущиеПараметры = Менеджер.Данные.Получить();
	Результат = ПараметрыПоУмолчанию();
	Если ТекущиеПараметры = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Результат, ТекущиеПараметры);
	Возврат Результат;
	
КонецФункции

// Процедура выполняет сохранение параметров распознавания речи.
//
// Параметры:
//  Данные		 - ПараметрыРаспознаванияРечи	 - Параметры распознавания речи.
//  ИмяФормы	 - Строка	 - Имя формы.
//  Пользователь - ПользовательИнформационнойБазы	 - Текущий пользователь ИБ.
//
Процедура Сохранить(Данные, ИмяФормы = "", Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ТекущиеПараметры = ПолучитьБезопасно(ИмяФормы, Пользователь);
	ЗаполнитьЗначенияСвойств(ТекущиеПараметры, Данные);
	
	Менеджер = РегистрыСведений.CRM_ПараметрыРаспознаванияРечи.СоздатьМенеджерЗаписи();
	Менеджер.ИмяФормы = ИмяФормы;
	Менеджер.Пользователь = Пользователь;
	Менеджер.Данные = Новый ХранилищеЗначения(ТекущиеПараметры);
	Менеджер.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыПоУмолчанию() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВариантИспользования", CRM_РаботаСРечьюБМОСервер.ВариантИспользованияРасположенияРаботыСРечью().Авто);
	
	Результат.Вставить("КодЯзыка");
	Результат.Вставить("Акустика");
	Результат.Вставить("Грамматика");
	Результат.Вставить("Версия");
	
	Результат.Вставить("ДополнительныеГрамматики", Новый Массив);
	Результат.Вставить("ИспользоватьТолькоДополнительныеГрамматики", Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли