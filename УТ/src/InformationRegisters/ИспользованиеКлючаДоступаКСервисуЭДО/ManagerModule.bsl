// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ИдентификаторЭДО - См. РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО.ИдентификаторЭДО
Процедура Записать(ИдентификаторЭДО) Экспорт
	НоваяЗапись = СоздатьМенеджерЗаписи();
	НоваяЗапись.ИдентификаторЭДО = ИдентификаторЭДО;
	НоваяЗапись.Записать();
КонецПроцедуры

// Параметры:
//  ИдентификаторЭДО - См. РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО.ИдентификаторЭДО
Процедура Удалить(ИдентификаторЭДО) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторЭДО);
	НаборЗаписей.Записать();
КонецПроцедуры

Процедура Очистить() Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
КонецПроцедуры

// Возвращаемое значение:
//  Булево
Функция ЕстьЗаписи() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиАвтоматическогоПолученияЭДО.ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО КАК НастройкиАвтоматическогоПолученияЭДО";
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Не РезультатЗапроса.Пустой()
КонецФункции

// Параметры:
//  ИдентификаторыЭДО - Массив из см. РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО.ИдентификаторЭДО
// 
// Возвращаемое значение:
//  Массив из см. РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО.ИдентификаторЭДО
Функция ПодключенныеИдентификаторыЭДО(ИдентификаторыЭДО = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиАвтоматическогоПолученияЭДО.ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО КАК НастройкиАвтоматическогоПолученияЭДО
		|ГДЕ
		|	&УсловиеПоИдентификаторамЭДО";
	УсловиеПоИдентификаторамЭДО = "ИСТИНА";
	Если ЗначениеЗаполнено(ИдентификаторыЭДО) Тогда
		УсловиеПоИдентификаторамЭДО = "НастройкиАвтоматическогоПолученияЭДО.ИдентификаторЭДО В (&ИдентификаторыЭДО)";
		Запрос.УстановитьПараметр("ИдентификаторыЭДО", ИдентификаторыЭДО);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоИдентификаторамЭДО", УсловиеПоИдентификаторамЭДО);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИдентификаторЭДО");
КонецФункции

// Параметры:
//  ИдентификаторЭДО - Строка
// 
// Возвращаемое значение:
//  Булево
Функция ЕстьИдентификаторЭДО(ИдентификаторЭДО) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиАвтоматическогоПолученияЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.ИспользованиеКлючаДоступаКСервисуЭДО КАК НастройкиАвтоматическогоПолученияЭДО
		|ГДЕ
		|	НастройкиАвтоматическогоПолученияЭДО.ИдентификаторЭДО =  &ИдентификаторЭДО";
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторЭДО);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Не РезультатЗапроса.Пустой();
КонецФункции

#КонецОбласти

#КонецЕсли
