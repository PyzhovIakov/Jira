////////////////////////////////////////////////////////////////////////////////
// Расширение подсистемы "Физические лица" для УТ, КА2, УП2 (локализация).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет, что серия документа для переданного вида документа указана правильно.
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц	- вид документа, для которого необходимо
// 																проверить правильность серии
//	Серия - Строка - серия документа
//	ТекстОшибки - Строка - текст ошибки, если серия указана неправильно.
//	БезОшибки - Булево - флаг проверки
//
Процедура СерияДокументаУказанаПравильно(ВидДокумента, Знач Серия , ТекстОшибки, БезОшибки) Экспорт
	
	// ++ Локализация
	ТипДокумента = 0;
	ТипСерииДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента);
	
	Серия = СокрЛП(Серия);
	
	Если ТипДокумента = 1 Тогда // паспорт СССР и свидетельство о рождении
		
		Поз = Найти(Серия, "-");
		Если Поз = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Серия документа должна состоять из двух частей, разделенных символом ""-"".'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
		ЧастьСерии1 = Лев(Серия, Поз - 1);
		ЧастьСерии2 = СокрЛП(Сред(Серия, Поз + 1));
		
		Поз = Найти(ЧастьСерии2, "-");
		Если Поз <> 0 Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа должно быть только две группы символов.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
		Если ПустаяСтрока(ЧастьСерии1) Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа отсутствует числовая часть.'");
			БезОшибки = Ложь;
			Возврат;
			
		ИначеЕсли  ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("IVXLC1УХЛС", ЧастьСерии1, "          ")) = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Числовая часть серии документа должна указываться символами 1 У Х Л С  или  I V X L C.'");
			БезОшибки = Ложь;
			Возврат;
			
		ИначеЕсли СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("IVXLC", ЧастьСерии1, "1УХЛС") <> СтроковыеФункцииКлиентСервер.ПреобразоватьЧислоВРимскуюНотацию(СтроковыеФункцииКлиентСервер.ПреобразоватьЧислоВАрабскуюНотацию(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("IVXLC", ЧастьСерии1, "1УХЛС"))) Тогда
			ТекстОшибки = НСтр("ru = 'Числовая часть серии документа указана некорректно.'");
			БезОшибки = Ложь;
			Возврат;
			
		ИначеЕсли СтрДлина(ЧастьСерии2) <> 2 Или Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ", ЧастьСерии2, "                                 ")) Тогда
			ТекстОшибки = НСтр("ru = 'После разделителя ""-"" в серии документа должны быть ДВЕ русские заглавные буквы.'");
			БезОшибки = Ложь;
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = 2 Тогда // серия - две буквы: военный билет, ...
		Если СтрДлина(Серия) <> 2 Или Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ", Серия, "                                 ")) Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа должны быть ДВЕ русские заглавные буквы.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = 3 Тогда // серия - две цифры: загранпаспорта
		Если СтрДлина(Серия) <> 2 Или Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("0123456789", Серия, "          ")) Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа должно быть ДВЕ цифры.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = 4 Тогда // серия - две группы цифр: новый паспорт
		Поз = Найти(Серия, " ");
		Если Поз = 0 Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа должно быть две группы цифр.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
		ПерваяЧасть = Лев(Серия, Поз-1);
		ВтораяЧасть = СокрЛП(Сред(Серия, Поз+1));
		
		Поз = Найти(ВтораяЧасть, " ");
		Если Поз <> 0 Тогда
			ТекстОшибки = НСтр("ru = 'В серии документа должно быть только две группы цифр.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
		Если СтрДлина(ПерваяЧасть) <> 2 Или Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("0123456789", ПерваяЧасть, "          ")) Тогда
			ТекстОшибки = НСтр("ru = 'Первая группа символов серии документа должна содержать две цифры.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
		Если СтрДлина(ВтораяЧасть) <> 2 Или Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("0123456789", ВтораяЧасть, "          ")) Тогда
			ТекстОшибки = НСтр("ru = 'Вторая группа символов серии документа должна содержать две цифры.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	// -- Локализация
	
КонецПроцедуры

// Проверяет, что номер документа для переданного вида документа указан правильно.
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц	- вид документа, для которого необходимо
//																проверить правильность номера
//	Номер - Строка - номер документа
//	ТекстОшибки - Строка - текст ошибки, если номер указан неправильно.
//	БезОшибки - Булево - флаг проверки
//
Процедура НомерДокументаУказанПравильно(ВидДокумента, Знач Номер, ТекстОшибки, БезОшибки) Экспорт
	
	// ++ Локализация
	Если Не ПустаяСтрока(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("0123456789", Номер, "          ")) Тогда
		ТекстОшибки = НСтр("ru = 'В номере документа присутствуют недопустимые символы.'");
		ЕстьОшибка = Истина;
		Возврат;
	КонецЕсли;
	
	ТипДокумента = 0;
	ТипНомераДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента);
	
	ДлинаНомера = СтрДлина(СокрЛП(Номер));
	
	Если ТипДокумента = 1 Тогда
		Если ДлинаНомера <> 6 Тогда
			ТекстОшибки = НСтр("ru = 'Номер документа должен состоять из 6 символов.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = 2 Тогда
		Если ДлинаНомера <> 7 Тогда
			ТекстОшибки = НСтр("ru = 'Номер документа должен состоять из 7 символов.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипДокумента = 3 Тогда
		Если (ДлинаНомера < 6 ) Или ( ДлинаНомера > 7 ) Тогда
			ТекстОшибки = НСтр("ru = 'Номер документа должен состоять из 6 или 7 символов.'");
			БезОшибки = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	// -- Локализация
	
КонецПроцедуры

// Возвращает тип серии документа удостоверяющего личность
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц
//	ТипДокумента - Число
//
Процедура ТипСерииДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента) Экспорт
	
	// ++ Локализация
	Если ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортСССР")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении") Тогда
		ТипДокумента = 1;
		
	ИначеЕсли ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.УдостоверениеОфицера")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортМинморфлота")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилет")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортМоряка")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилетОфицераЗапаса") Тогда
		ТипДокумента = 2;
		
	ИначеЕсли ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортСССР")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ДипломатическийПаспорт")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		ТипДокумента = 3;
		
	ИначеЕсли ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ") Тогда
		ТипДокумента = 4;
	КонецЕсли;
	// -- Локализация
	
КонецПроцедуры

// Возвращает тип номера документа удостоверяющего личность
//
// Параметры:
//	ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц
//	ТипДокумента - Число
//
Процедура ТипНомераДокументаУдостоверяющегоЛичность(ВидДокумента, ТипДокумента) Экспорт
	
	// ++ Локализация
	Если ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортСССР")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.УдостоверениеОфицера")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортМинморфлота")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ") Тогда
		ТипДокумента = 1;
		
	ИначеЕсли ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ДипломатическийПаспорт")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ") Тогда
		ТипДокумента = 2;
		
	ИначеЕсли ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортСССР")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилет")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортМоряка")
		Или ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилетОфицераЗапаса") Тогда
		ТипДокумента = 3;
		
	КонецЕсли;
	// -- Локализация
	
КонецПроцедуры

#КонецОбласти

