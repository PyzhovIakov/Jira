///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает "Истина", если распознавание речи поддерживается.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ПоддерживаетсяРаспознавание() Экспорт
	
	#Если МобильныйКлиент Тогда
		Возврат Ложь;
	#Иначе
		СистемнаяИнформация = Новый СистемнаяИнформация;
		Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(
			СистемнаяИнформация.ВерсияПриложения, "8.3.23.1200") >= 0;
	#КонецЕсли
	
КонецФункции

// Функция возвращает "Истина", если потоковое распознавание речи поддерживается.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ПоддерживаетсяПотоковоеРаспознавание() Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат CRM_РаботаСРечьюБМОКлиентТолько8323.ПоддерживаетсяПотоковоеРаспознавание();
	
КонецФункции

// Процедура-обработкич начала потокового распознавания.
//
// Параметры:
//  Ключ											 - Строка	 - Ключ.
//  ОбработчикРаспознавания							 - Строка	 - Обработчик распознвания.
//  ПараметрыМодели									 - ПараметрыМоделиРаспознаванияРечи	 - Параметры модели распознавания речи.
//  ИспользованиеВариантаРасположенияРаботыСРечью	 - Булево	 - Признак использования варианта расположения работы с речью.
//  ПараметрыПотоковогоРаспознавания				 - ПараметрыПотоковогоРаспознаванияРечи	 - Параметры потокового распознавания речи.
//
Процедура НачатьПотоковоеРаспознавание(
		Ключ,
		ОбработчикРаспознавания,
		ПараметрыМодели,
		ИспользованиеВариантаРасположенияРаботыСРечью,
		ПараметрыПотоковогоРаспознавания
	) Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат;
	КонецЕсли;
	
	CRM_РаботаСРечьюБМОКлиентТолько8323.НачатьПотоковоеРаспознавание(
		Ключ,
		ОбработчикРаспознавания,
		ПараметрыМодели,
		ИспользованиеВариантаРасположенияРаботыСРечью,
		ПараметрыПотоковогоРаспознавания
	);
	
КонецПроцедуры

// Процедура останавливает потоковое распознавание.
//
// Параметры:
//  Ключ	 - Строка	 - Ключ.
//
Процедура ОстановитьПотоковоеРаспознавание(Ключ) Экспорт
	
	Если Не ПоддерживаетсяРаспознавание() Тогда
		Возврат;
	КонецЕсли;
	
	CRM_РаботаСРечьюБМОКлиентТолько8323.ОстановитьПотоковоеРаспознавание(Ключ);
	
КонецПроцедуры

#Область ПроцедурыИФункции_CRM

// Процедура запускает процедуру распознавания речи.
//
// Параметры:
//  Контекст			 - Структура	 - Структура контекста распознавания речи.
//  Команда				 - КомандаФормы, Неопределено		 - Команда.
//  ОписаниеОповещения	 - ОписаниеОповещения, Неопределено	 - Оповещение-обработчик продолжения процедуры.
//
Процедура РаспознаваниеРечи(Контекст, Команда = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	Если НЕ CRM_ЛицензированиеЭкспортныеМетоды.ПодсистемаCRMИспользуется() Тогда
		CRM_ЛицензированиеЭкспортныеМетоды.ВывестиУведомлениеОНедоступности(НСтр("ru = 'Голосовой ввод'"));
		Возврат;
	КонецЕсли;
	
	Если ОписаниеОповещения = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("РаспознаваниеРечиПродолжение", CRM_РаботаСРечьюБМОКлиент, Контекст);
	КонецЕсли;
	
	CRM_ЛицензированиеКлиент.ПроверитьПодключениеОтраслевыхСервисовИОткрыть(ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик продолжения процедуры "РаспознаваниеРечи".
//
// Параметры:
//  Результат	 - Булево	 - Результат распознавания речи.
//  ДопПараметры - Произвольный	 - Дополнительные параметры.
//
Процедура РаспознаваниеРечиПродолжение(Результат, ДопПараметры) Экспорт
	
	Форма = ДопПараметры.Форма;
	МассивИменКнопокРаспознавания = ДопПараметры.МассивИменКнопокРаспознавания;
	
	СтруктураПоиска = Новый Структура("КомандаГолосовогоВвода", Форма["РаспознаваниеРечи_ТекущаяКоманда"]);
	НайденныеСтроки = Форма["РаспознаваниеРечи_ТаблицаЭлементов"].НайтиСтроки(СтруктураПоиска);
	Форма.ТекущийЭлемент = Форма.Элементы[НайденныеСтроки[0].ИмяЭлемента];
	
	Если ДопПараметры.Свойство("ИмяОперацииСтатистики") Тогда
		CRM_ЦентрМониторингаКлиентСервер.ЗаписатьОперациюБизнесСтатистики(ДопПараметры.ИмяОперацииСтатистики);
	КонецЕсли;
	
	Для Каждого ТекИмяЭлемента Из МассивИменКнопокРаспознавания Цикл
		
		ТекЭлемент             = Форма.Элементы[ТекИмяЭлемента];
		ИмяСвойстваКартинка    = "Картинка";
		ИмяСвойстваОтображение = "Видимость";
		МикрофонАктивный       = БиблиотекаКартинок.CRM_МикрофонАктивный24;
		МикрофонНеАктивный     = БиблиотекаКартинок.CRM_Микрофон24;
		
		Если Не (ТипЗнч(ТекЭлемент) = Тип("КнопкаФормы")
		     Или ТипЗнч(ТекЭлемент) = Тип("КнопкаКоманднойПанели")) Тогда
			
			ИмяСвойстваКартинка    = "КартинкаКнопкиВыбора";
			ИмяСвойстваОтображение = "КнопкаВыбора";
			МикрофонАктивный       = БиблиотекаКартинок.CRM_МикрофонАктивный16;
			МикрофонНеАктивный     = БиблиотекаКартинок.CRM_Микрофон16;
			
		КонецЕсли;
		
		Если ДопПараметры.ТекущийЭлемент = ТекЭлемент Тогда
			
			// Переключить текущий микрофон
			Если ТекЭлемент[ИмяСвойстваКартинка] = МикрофонАктивный Тогда
				ТекЭлемент[ИмяСвойстваКартинка] = МикрофонНеАктивный;
			Иначе
				ТекЭлемент[ИмяСвойстваКартинка] = МикрофонАктивный;
			КонецЕсли;
			
			Если Форма["РаспознаваниеРечи_ВыполняетсяРаспознавание"]
				И ТекЭлемент[ИмяСвойстваКартинка] = МикрофонНеАктивный Тогда
				
				ОстановитьПотоковоеРаспознавание(Форма.УникальныйИдентификатор);
			ИначеЕсли Не Форма["РаспознаваниеРечи_ВыполняетсяРаспознавание"] Тогда
				
				НачатьРаспознавание(ДопПараметры);
			КонецЕсли;
			
		Иначе
			// Отключить остальные
			ТекЭлемент[ИмяСвойстваКартинка] = МикрофонНеАктивный;
		КонецЕсли;
		
	КонецЦикла;
	
	ИзменитьОформление(Форма, МассивИменКнопокРаспознавания);
	
КонецПроцедуры

// Процедура выполняет изменение состояния формы.
//
// Параметры:
//  Форма							 - ФормаКиентскогоПриложения	 - Форма.
//  МассивИменКнопокРаспознавания	 - Массив	 - Массив имен кнопок распознавания.
//
Процедура ИзменитьСостояниеФормы(Форма, МассивИменКнопокРаспознавания) Экспорт
	
	ПоддерживаетсяРаспознаваниеРечи = Форма["РаспознаваниеРечи_РаспознаваниеДоступно"]
	                                  И ПоддерживаетсяПотоковоеРаспознавание();
	
	Для Каждого ТекИмяЭлемента Из МассивИменКнопокРаспознавания Цикл
		
		ТекЭлемент             = Форма.Элементы[ТекИмяЭлемента];
		ИмяСвойстваКартинка    = "Картинка";
		ИмяСвойстваОтображение = "Видимость";
		МикрофонНеАктивный     = БиблиотекаКартинок.CRM_Микрофон24;
		
		Если Не (ТипЗнч(ТекЭлемент) = Тип("КнопкаФормы")
			Или ТипЗнч(ТекЭлемент) = Тип("КнопкаКоманднойПанели")) Тогда
			
			ИмяСвойстваКартинка    = "КартинкаКнопкиВыбора";
			ИмяСвойстваОтображение = "КнопкаВыбора";
			МикрофонНеАктивный     = БиблиотекаКартинок.CRM_Микрофон16;
		КонецЕсли;
		
		Если Не Форма["РаспознаваниеРечи_ВыполняетсяРаспознавание"] Тогда
			ТекЭлемент[ИмяСвойстваКартинка]    = МикрофонНеАктивный;
		КонецЕсли;
		
		ТекЭлемент[ИмяСвойстваОтображение] = ПоддерживаетсяРаспознаваниеРечи;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПроцедурыИФункции_CRM

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачатьРаспознавание(Контекст)
	
	Попытка
		Форма                  = Контекст.Форма;
		ТекущиеПараметры       = Форма["РаспознаваниеРечи_ПараметрыРаспознавания"];
		ПараметрыМодели        = CRM_ПараметрыРаспознаванияРечиКлиент.ПараметрыМодели(ТекущиеПараметры);
		ВариантИспользования   = CRM_ПараметрыРаспознаванияРечиКлиент.ВариантИспользования(ТекущиеПараметры);
		
		ПараметрыРаспознавания = CRM_ПараметрыРаспознаванияРечиКлиент.ПараметрыПотоковогоРаспознаванияРечи(ТекущиеПараметры,
			Новый ОписаниеОповещения("ПриОстановкеАудиозаписи", CRM_РаботаСРечьюБМОКлиент, Контекст));
		
		Оповещение = Новый ОписаниеОповещения("ПриПолученииРезультатаРаспознавания", Форма, Контекст,
		             "ПриОбработкеОшибкиРаспознавания", CRM_РаботаСРечьюБМОКлиент);
		
		НачатьПотоковоеРаспознавание(
			Форма.УникальныйИдентификатор,
			Оповещение,
			ПараметрыМодели,
			ВариантИспользования,
			ПараметрыРаспознавания);
		
		Форма["РаспознаваниеРечи_ВыполняетсяРаспознавание"] = Истина;
		Форма["РаспознаваниеРечи_ВремяНачалаРаспознавания"] = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
	Исключение
		ПриОбработкеОшибкиРаспознавания(ИнформацияОбОшибке(), Истина, Контекст);
	КонецПопытки;
	
	ИзменитьСостояниеФормы(Форма, Контекст.МассивИменКнопокРаспознавания);
	
КонецПроцедуры

Процедура ПриОстановкеАудиозаписи(РезультатАудиозаписи, Контекст) Экспорт
	
	Форма = Контекст.Форма;
	
	Форма["РаспознаваниеРечи_ВыполняетсяРаспознавание"] = Ложь;
	Форма["РаспознаваниеРечи_РаспознаваниеФразыЗавершено"] = Истина;
	ИзменитьСостояниеФормы(Форма, Контекст.МассивИменКнопокРаспознавания);
	ИзменитьОформление(Форма, Контекст.МассивИменКнопокРаспознавания);
	
	ВремяКонца = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ТекущиеПараметры = Форма["РаспознаваниеРечи_ПараметрыРаспознавания"];
	ПараметрыМодели = CRM_ПараметрыРаспознаванияРечиКлиент.ПараметрыМодели(ТекущиеПараметры);
	ВариантИспользования = CRM_ПараметрыРаспознаванияРечиКлиент.ВариантИспользования(ТекущиеПараметры);
	
	CRM_РаботаСРечьюЖурналированиеКлиент.ДобавитьАудио(
		Форма.УникальныйИдентификатор,
		РезультатАудиозаписи,
		ПараметрыМодели,
		ВариантИспользования,
		Форма["РаспознаваниеРечи_ВремяНачалаРаспознавания"],
		ВремяКонца);
	
	Если Форма["РаспознаваниеРечи_ПерезапускРаспознавания"] Тогда
		НачатьРаспознавание(Контекст);
		Форма["РаспознаваниеРечи_ПерезапускРаспознавания"] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОбработкеОшибкиРаспознавания(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Форма = Контекст.Форма;
	
	CRM_РаботаСРечьюЖурналированиеКлиент.ДобавитьИсключение(Форма.УникальныйИдентификатор, ИнформацияОбОшибке);
	
	ОбработкаОшибок.ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
	Форма["РаспознаваниеРечи_РаспознаваниеФразыЗавершено"] = Истина;
	ИзменитьСостояниеФормы(Форма, Контекст.МассивИменКнопокРаспознавания);
	
КонецПроцедуры

Процедура ИзменитьОформление(Форма, МассивКомандыРаспознавания)
	
	Элементы             = Форма.Элементы;
	ГолосовойВводВключен = Ложь;
	
	Для Каждого ТекИмяЭлемента Из МассивКомандыРаспознавания Цикл
		ТекЭлемент = Элементы[ТекИмяЭлемента];
		Если ТипЗнч(ТекЭлемент) = Тип("КнопкаФормы")
		 Или ТипЗнч(ТекЭлемент) = Тип("КнопкаКоманднойПанели") Тогда
			
			ГолосовойВводВключен = (ТекЭлемент.Картинка = БиблиотекаКартинок.CRM_МикрофонАктивный24);
		Иначе
			ГолосовойВводВключен = (ТекЭлемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.CRM_МикрофонАктивный16);
		КонецЕсли;
		
		Если ГолосовойВводВключен Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ЦветРамкиГолосовойВвод = CRM_РаботаСРечьюБМОВызовСервера.ПолучитьЦветРамкиДоступногоЭлемента();
	ПодсказкаГолосовойВвод = "Слушаю...";
	
	Для Каждого ТекСтрока Из Форма["РаспознаваниеРечи_ТаблицаЭлементов"] Цикл
		
		ЭтоЭлементТекКоманды = (ТекСтрока.КомандаГолосовогоВвода = Форма["РаспознаваниеРечи_ТекущаяКоманда"]);
		ТекЦветРамки = ?(ЭтоЭлементТекКоманды И ГолосовойВводВключен, ЦветРамкиГолосовойВвод, ТекСтрока.ЦветРамки);
		ТекПодсказкаВвода = ?(ЭтоЭлементТекКоманды И ГолосовойВводВключен, ПодсказкаГолосовойВвод, ТекСтрока.ПодсказкаВвода);
		
		Элементы[ТекСтрока.ИмяЭлемента].ЦветРамки = ТекЦветРамки;
		Если Элементы[ТекСтрока.ИмяЭлемента].Вид = ВидПоляФормы.ПолеВвода Тогда
			Элементы[ТекСтрока.ИмяЭлемента].ПодсказкаВвода = ТекПодсказкаВвода;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
