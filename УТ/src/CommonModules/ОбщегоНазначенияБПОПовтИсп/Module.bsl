
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает соответствие имен "функциональных" подсистем и значения Истина.
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
// 
// Возвращаемое значение:
//   Соответствие из КлючИЗначение
//
Функция ИменаПодсистем() Экспорт
	
	Имена = Новый Соответствие;
	ВставитьИменаПодчиненныхПодсистем(Имена, Метаданные);
	
	Возврат Новый ФиксированноеСоответствие(Имена);
	
КонецФункции

Функция РежимЗамещенияДоступен() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	Версия = СистемнаяИнформация.ВерсияПриложения;
	
	Если ОбщегоНазначенияБПОКлиентСервер.СравнитьВерсии(Версия, "8.3.25.1336") < 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция РежимЗамещенияУдаление() Экспорт
	
#Если Не МобильноеПриложениеСервер Тогда
	УстановитьБезопасныйРежим(Истина);
#КонецЕсли
	Возврат Вычислить("РежимЗамещения.Удаление");
	
КонецФункции


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ВставитьИменаПодчиненныхПодсистем(Имена, РодительскаяПодсистема, ИмяРодительскойПодсистемы = "")
	
	Для Каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Если ТекущаяПодсистема.ВключатьВКомандныйИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТекущейПодсистемы = ИмяРодительскойПодсистемы + ТекущаяПодсистема.Имя;
		Имена.Вставить(ИмяТекущейПодсистемы, Истина);
		
		Если ТекущаяПодсистема.Подсистемы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВставитьИменаПодчиненныхПодсистем(Имена, ТекущаяПодсистема, ИмяТекущейПодсистемы + ".");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
