#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		//ЗащищенныйОбъект = CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьЗащищеннуюОбработку();
		//ЗащищенныйОбъект.ПотокиДоставкиПочтыПриВключенииНастройки(Значение, Отказ);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.CRM_НеИспользоватьПотокиДоставкиЭлектроннойПочты.Установить(Не Значение);
	
	Если Значение Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПотокиДоставкиПочты.НомерПотока КАК НомерПотока
		|ИЗ
		|	РегистрСведений.CRM_ПотокиДоставкиПочты КАК ПотокиДоставкиПочты
		|ГДЕ
		|	ПотокиДоставкиПочты.НомерПотока > 0");
		ПотокиДляОбработки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерПотока");
		
	Иначе
		
		ПотокиДляОбработки = Новый Массив;
		Для НомерПотока = 1 По 10 Цикл
			ПотокиДляОбработки.Добавить(НомерПотока);
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого НомерПотока Из ПотокиДляОбработки Цикл
		ИмяЗадания = "CRM_ПолучениеИОтправкаЭлектронныхПисемПоток" + НомерПотока;
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания[ИмяЗадания],
			Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
