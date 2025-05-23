////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры работы со статьями расходов
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Управление элементами формы
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма плана видов характеристик
//
Процедура УправлениеЭлементамиФормы(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	// Закладка "Основное".
	
	// Общие настройки или полные возможности
	Элементы.ГруппаПростыеВозможности.Видимость = НЕ Форма.ПолныеВозможности;
	Элементы.ГруппаПолныеВозможности.Видимость = Форма.ПолныеВозможности;
	
	// Настройки отборов и параметров создания новых правил
	НазначениеПравилаУпр = Форма.НазначениеПравилаУпр;
	НазначениеПравилаРегл = Форма.НазначениеПравилаРегл;
	НазначениеПравилаНУ = Форма.НазначениеПравилаНУ;

	Форма.НазначениеПравилаУпр = Справочники.ПравилаРаспределенияРасходов.ПолучитьНазначениеПравилаПоВариантуРаспределения(Объект.ВариантРаспределенияРасходовУпр);
	Форма.НазначениеПравилаРегл = Справочники.ПравилаРаспределенияРасходов.ПолучитьНазначениеПравилаПоВариантуРаспределения(Объект.ВариантРаспределенияРасходовРегл);
	Форма.НазначениеПравилаНУ = Справочники.ПравилаРаспределенияРасходов.ПолучитьНазначениеПравилаПоВариантуРаспределения(Объект.ВариантРаспределенияРасходовНУ);
	
	Если ЗначениеЗаполнено(НазначениеПравилаУпр) И НазначениеПравилаУпр <> Форма.НазначениеПравилаУпр Тогда
		Объект.ПравилоРаспределенияРасходовУпр = Справочники.ПравилаРаспределенияРасходов.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НазначениеПравилаРегл) И НазначениеПравилаРегл <> Форма.НазначениеПравилаРегл Тогда
		Объект.ПравилоРаспределенияРасходовРегл = Справочники.ПравилаРаспределенияРасходов.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НазначениеПравилаНУ) И НазначениеПравилаНУ <> Форма.НазначениеПравилаНУ Тогда
		Объект.ПравилоРаспределенияРасходовНУ = Справочники.ПравилаРаспределенияРасходов.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ Форма.ПолныеВозможности Тогда
		// Правила на себестоимость товаров
		Элементы.ПравилоРаспределенияНаСебестоимостьОбщ.Видимость =	Ложь;
		// Правила на себестоимость продаж
		Элементы.ПравилоРаспределенияНаСебестоимостьПродажОбщ.Видимость = (Объект.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж);

		// Правила на себестоимость производства
		Элементы.БазаРаспределенияПоПартиямОбщ.Видимость = Ложь 
		;

		// Прочие правила
		Элементы.ПравилоРаспределенияРасходовОбщ.Видимость = 
			Перечисления.ВариантыРаспределенияРасходов.ВариантИспользуетПравилоРаспределения(Объект.ВариантРаспределенияРасходовУпр);

		// Надписи
		Элементы.НадписьНеТребуетРаспределенияОбщ.Видимость = 
			НЕ Объект.ВариантРаспределенияРасходовУпр.Пустая() 
			И Перечисления.ВариантыРаспределенияРасходов.ВариантБезРаспределения(Объект.ВариантРаспределенияРасходовУпр);
	Иначе
		// Правила на себестоимость товаров
		Элементы.ПравилоРаспределенияНаСебестоимостьУпрПолные.Видимость = Ложь;
		Элементы.ПравилоРаспределенияНаСебестоимостьРеглПолные.Видимость = Ложь;
		// Правила на себестоимость продаж
		Элементы.ПравилоРаспределенияНаСебестоимостьПродажУпрПолные.Видимость = 
			(Объект.ВариантРаспределенияРасходовУпр  = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж);
		Элементы.ПравилоРаспределенияНаСебестоимостьПродажРеглПолные.Видимость = 
			(Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж);

		// Правила на себестоимость производства
		Элементы.БазаРаспределенияПоПартиямУпрПолные.Видимость = Ложь
		;
		Элементы.БазаРаспределенияПоПартиямРеглПолные.Видимость = Ложь
		;

		// Прочие правила
		Элементы.ПравилоРаспределенияРасходовУпрПолные.Видимость = 
			Перечисления.ВариантыРаспределенияРасходов.ВариантИспользуетПравилоРаспределения(Объект.ВариантРаспределенияРасходовУпр);
		Элементы.ПравилоРаспределенияРасходовРеглПолные.Видимость = 
			Перечисления.ВариантыРаспределенияРасходов.ВариантИспользуетПравилоРаспределения(Объект.ВариантРаспределенияРасходовРегл);
		// Надписи
		Элементы.НадписьНеТребуетРаспределенияУпр.Видимость = 
			НЕ Объект.ВариантРаспределенияРасходовУпр.Пустая() 
			И Перечисления.ВариантыРаспределенияРасходов.ВариантБезРаспределения(Объект.ВариантРаспределенияРасходовУпр);
		Элементы.НадписьНеТребуетРаспределенияРегл.Видимость = 
			НЕ Объект.ВариантРаспределенияРасходовРегл.Пустая() 
			И Перечисления.ВариантыРаспределенияРасходов.ВариантБезРаспределения(Объект.ВариантРаспределенияРасходовРегл);
		Элементы.НадписьПравилоРаспределенияРеглКакУпр.Видимость = 
			НЕ Объект.ВариантРаспределенияРасходовРегл.Пустая() 
			И НЕ Перечисления.ВариантыРаспределенияРасходов.ВариантИспользуетПравилоРаспределения(Объект.ВариантРаспределенияРасходовРегл) 
			И НЕ Перечисления.ВариантыРаспределенияРасходов.ВариантБезРаспределения(Объект.ВариантРаспределенияРасходовРегл) 
			И (Объект.ВариантРаспределенияРасходовУпр = Объект.ВариантРаспределенияРасходовРегл)
			И НЕ (Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПродаж);
		
	КонецЕсли;
	
	// Аналитика.
	Элементы.ГруппаВидАналитики.Видимость = ИСТИНА 
	;
	
	Элементы.ГруппаПравилоРаспределенияНаПроизводство.Видимость = Ложь 
		ИЛИ РасчетСебестоимостиЛокализация.ПолучитьФункциональнуюОпциюУчетПоНДД() И Объект.ПризнаютсяВРасходахНДД;
		
	Элементы.КонтролироватьЗаполнениеАналитики.Доступность = НЕ 
		(Объект.ТипРасходов = Перечисления.ТипыРасходов.ФормированиеСтоимостиВНА
			ИЛИ Объект.ТипРасходов = Перечисления.ТипыРасходов.ВозникновениеЗатратНаОбъектах
			ИЛИ Объект.ТипРасходов = Перечисления.ТипыРасходов.ПроизводствоПродукции);
	
	// Раздельный учет НДС
	ВидЦенностиВНА = (Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.НМА) Или (Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОС);
	
	ИспользоватьРаздельныйУчетВНАПоНалогообложению = Ложь;
	ВариантРаздельногоУчетаНДСНаНаправленияДеятельностиВидимость =
		НЕ (ВидЦенностиВНА И ИспользоватьРаздельныйУчетВНАПоНалогообложению)
			И (Объект.ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров);
	
	ВариантРаздельногоУчетаНДСПредупреждениеВидимость = Ложь;
	
	Если Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПроизводства
			ИЛИ Объект.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты
 	Тогда
		ВариантРаздельногоУчетаНДСПредупреждениеВидимость = 
			Объект.ВариантРаздельногоУчетаНДС <> Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента;
 		ВариантРаздельногоУчетаНДСНаНаправленияДеятельностиВидимость = ВариантРаздельногоУчетаНДСПредупреждениеВидимость;
	КонецЕсли;
	
	Элементы.ВариантРаздельногоУчетаНДСПредупреждение.Видимость = ВариантРаздельногоУчетаНДСПредупреждениеВидимость;
	Элементы.ВариантРаздельногоУчетаНДСНаНаправленияДеятельности.Видимость = ВариантРаздельногоУчетаНДСНаНаправленияДеятельностиВидимость;
		
	Элементы.ГруппаПолныеНастройкиРегл.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходовРегл");
	
	Элементы.ВариантРаздельногоУчетаНДС_ОС.Видимость =
		ИспользоватьРаздельныйУчетВНАПоНалогообложению 
			И (Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.ОС
				Или Объект.ВидЦенностиНДС = Перечисления.ВидыЦенностей.НМА);
	
	//++ Локализация

	СтатьиРасходовЛокализация.УправлениеЭлементамиФормы(Форма);

	//-- Локализация
	
	// Закладка "Ограничение использования".	
		
	Элементы.ДоступныеХозяйственныеОперации.Доступность = (Объект.ОграничитьИспользование И Не Форма.ТолькоПросмотр);
	
	Элементы.ИнформацияНаПрочиеАктивыТекст.Заголовок = 
		НСтр("ru = 'Данный вариант распределения устарел, вместо статей с таким вариантом распределения в документах следует использовать статьи активов/пассивов.'");
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		Элементы.ИнформацияНаПрочиеАктивыТекст.Заголовок = Элементы.ИнформацияНаПрочиеАктивыТекст.Заголовок 
			+ " " 
			+ НСтр("ru = 'Для использования статей активов/пассивов включите опцию ""Учитывать прочие активы и пассивы"" (раздел Администрирование - Финансовый результат).'")
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти