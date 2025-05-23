#Область СлужебныйПрограммныйИнтерфейс

// См. Справочники.Организации.НаименованияНаДату
Функция НаименованияНаДату(Организация, ДатаСведений) Экспорт
	
	Возврат Справочники.Организации.НаименованияНаДату(Организация, ДатаСведений);
	
КонецФункции

// Возвращает имена реквизитов, тип которых совпадает с типом СправочникСcылка.Организации.
//
// Параметры:
//		ПолноеИмяОбъектаМетаданных - Строка - Полное имя проверяемого объекта метаданных.
//
// Возвращаемое значение:
//  Массив из Строка - Имена реквизитов.
//
Функция ИменаРеквизитовОрганизаций(ПолноеИмяОбъектаМетаданных) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Результат = Новый Массив;
	
	ТипОрганизация = Тип("СправочникСсылка.Организации");
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Если Реквизит.Тип.СодержитТип(ТипОрганизация) Тогда
			Результат.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти