///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбслуживаниеПриСозданииНаСервере(Форма) Экспорт
	
	//++ НЕ ГОСИС
	Форма.Элементы.ГруппаОтчетыИОбработки.Видимость = НЕ ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ОбщиеНастройки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбщиеНастройкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
	//++ НЕ ГОСИС
	БазоваяВерсия = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	СоставНабораКонстантФормы = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(Форма.НаборКонстант);
	
	Форма.Элементы.ГруппаГруппыДоступаПрофилиИОграничениеНаУровнеЗаписей.Видимость 		= НЕ БазоваяВерсия;
	Форма.Элементы.ГруппаИспользоватьГруппыДоступаПартнеров.Видимость 	= НЕ БазоваяВерсия;
	Форма.Элементы.ГруппаИспользоватьГруппыДоступаНоменклатуры.Видимость 	= НЕ БазоваяВерсия;
	Форма.Элементы.ГруппаКопированиеНастроекПользователей.Видимость 		= НЕ БазоваяВерсия;
	Форма.Элементы.ГруппаОчисткаНастроекПользователей.Видимость			= БазоваяВерсия;
	Форма.Элементы.ГруппаКонтрольРаботыПользователейПраваяКолонка.Видимость = НЕ БазоваяВерсия;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	      Форма, "ИспользоватьГруппыДоступаПартнеров",
	      НСтр("ru = 'Группы доступа контрагентов'"), ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	      Форма, "ПояснениеИспользоватьГруппыДоступаПартнеров",
	      НСтр("ru = 'Деление контрагентов на группы, по которым можно назначать пользователям права на добавление (изменение), просмотр контрагентов и всех документов по этим контрагентам.'"),
	      ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	      Форма, "ОткрытьГруппыДоступаПартнеров",
	      НСтр("ru = 'Группы доступа контрагентов'"), ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	      Форма, "ПояснениеОткрытьГруппыДоступаПартнеров",
	      НСтр("ru = 'Создание групп доступа контрагентов.'"), ИспользоватьПартнеровКакКонтрагентов);
	
	ИспользоватьБюджетирование = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование");
	Форма.Элементы.ГруппаИспользоватьГруппыДоступаВидовСтатейИПоказателейБюджетов.Видимость = ИспользоватьБюджетирование;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ИспользоватьСкрытиеПерсональныхДанных", "Доступность", Ложь);
	НастройкиПрограммыЛокализация.НастройкиПользователейИПравПриСозданииНаСервере(Форма);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ИнтернетПоддержкаИСервисы обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Органайзер обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОрганайзерПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму СинхронизацияДанных обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура СинхронизацияДанныхПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму НастройкиРаботыСФайлами обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиРаботыСФайламиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ПечатныеФормыОтчетыИОбработки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

#КонецОбласти