///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЗаписатьПечатныеФормыЗаказа(ДокументЗаказа, ПечатныеФормы) Экспорт
	
	НаборЗаписей = РегистрыСведений.ПечатныеФормыОнлайнЗаказов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументЗаказа.Установить(ДокументЗаказа);
	
	Для Каждого ПечатнаяФорма Из ПечатныеФормы Цикл
		
		Запись = НаборЗаписей.Добавить();
		Запись.ДокументЗаказа             = ДокументЗаказа;
		Запись.ИдентификаторПечатнойФормы = ПечатнаяФорма.Идентификатор;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецФункции

Функция ИдентификаторыПечатныхФормЗаказа(ДокументЗаказа) Экспорт
	
	ИдентификаторыПечатныхФорм = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПечатныеФормыОнлайнЗаказов.ИдентификаторПечатнойФормы КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ПечатныеФормыОнлайнЗаказов КАК ПечатныеФормыОнлайнЗаказов
	|ГДЕ
	|	ПечатныеФормыОнлайнЗаказов.ДокументЗаказа = &ДокументЗаказа";
	
	Запрос.УстановитьПараметр("ДокументЗаказа", ДокументЗаказа);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ИдентификаторыПечатныхФорм.Добавить(Выборка.Идентификатор);
		
	КонецЦикла;
	
	Возврат ИдентификаторыПечатныхФорм;
	
КонецФункции

#КонецОбласти

#КонецЕсли
