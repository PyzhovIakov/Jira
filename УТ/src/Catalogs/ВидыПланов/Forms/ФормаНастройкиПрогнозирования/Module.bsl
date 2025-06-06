
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.РеквизитыДляЗаполнения, , "Периодичность");
	Периодичность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "Периодичность");
	ПрогнозПоНеделям = (Периодичность = Перечисления.Периодичность.Неделя);
	
	Если ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям Тогда
		ТекстВариантыПрогнозированияПоКатегориям = НСтр("ru = 'Выбранный вариант определяет, в каком виде данные прогнозов будут выводиться для анализа:
			| %1 Только по категориям   - данные выводятся по категориям.
			| %1 С разбивкой по товарам - данные выводятся по товарам.'");
		ТекстВариантыПрогнозированияПоКатегориям = СтрШаблон(ТекстВариантыПрогнозированияПоКатегориям, Символ(8226));
		Элементы.ДекорацияВариантПрогнозированияПоКатегориям.Подсказка = ТекстВариантыПрогнозированияПоКатегориям;
	КонецЕсли;
	
	ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования(Ложь);
	//++ Локализация
	ПересчитатьДатуПоследнейПродажи();
	//-- Локализация
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//++ Локализация
	Если Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДатуПродажиНаКлиенте", 1, Истина);
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПрогнозированияПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиНачалаПрогнозаПриИзменении(Элемент)
	
	ОчиститьСообщения();
	//++ Локализация
	ПроверитьСоответствиеНачалаПрогнозированияСДнемНедели(Ложь);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	//++ Локализация
	СписокРеквизитовДляРедактирования = СервисПрогнозированияПереопределяемыйКлиентСервер.РеквизитыВидаПланаДляСервисаПрогнозирования();
	ПараметрыФормыРедактирования = Новый Структура(СписокРеквизитовДляРедактирования);
	ЗаполнитьЗначенияСвойств(ПараметрыФормыРедактирования, ЭтотОбъект);
	
	Закрыть(ПараметрыФормыРедактирования);
	//-- Локализация
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ДеньНеделиНачалаПрогноза.Видимость = ПрогнозПоНеделям;
	Элементы.ГруппаНадписьУстановленыДатыЗапретаИзменений.Видимость = ЕстьЗапретИзмененияДанных;
	Элементы.ГруппаВариантПрогнозированияПоКатегориям.Видимость = ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования(ПроверятьДеньНедели = Истина)
	
	//++ Локализация
	Если ПрогнозПоНеделям
		И ПроверятьДеньНедели Тогда
		ПроверитьСоответствиеНачалаПрогнозированияСДнемНедели(Истина);
	КонецЕсли;
	//-- Локализация
	
	ДанныеДляПроверки  = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
	
	НоваяСтрока        = ДанныеДляПроверки.Добавить();
	НоваяСтрока.Дата   = НачалоДня(НачалоПрогнозирования);
	НоваяСтрока.Раздел = "Планирование";
	НоваяСтрока.Объект = Владелец;
	
	ОписаниеДанных = Новый Структура("НоваяВерсия, Данные", Ложь, "");
	
	ЕстьЗапретИзмененияДанных = Ложь;
	ОписаниеОшибки = "";
	Если ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ДанныеДляПроверки, ОписаниеДанных, ОписаниеОшибки) Тогда
		ЕстьЗапретИзмененияДанных = Истина;
	КонецЕсли;
	
КонецПроцедуры

//++ Локализация

&НаКлиенте
Процедура Подключаемый_ОбновитьДатуПродажиНаКлиенте()
	Подключаемый_ОбновитьДатуПродажиНаСервере();
	Если Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДатуПродажиНаКлиенте", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьДатуПродажиНаСервере(ВыполнениеПроверено = Ложь)
	Если ВыполнениеПроверено
		Или Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи)
			И ДлительныеОперации.ЗаданиеВыполнено(Новый УникальныйИдентификатор(ИдентификаторЗаданияОбновитьДатуПродажи)) Тогда
		ИдентификаторЗаданияОбновитьДатуПродажи = "";
		
		ПоследняяИзвестнаяПродажа = ПолучитьИзВременногоХранилища(АдресХранилищаОбновитьДатуПродажи);
		
		Элементы.ПоследняяИзвестнаяПродажаИдетВычисление.Видимость = Ложь;
		Элементы.ПоследняяИзвестнаяПродажа.Видимость = Истина;
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПересчитатьДатуПоследнейПродажи()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	РезультатРасчета = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"СервисПрогнозированияПереопределяемый.ПоследняяИзвестнаяДатаПродажи");
	
	Если РезультатРасчета.Статус = "Выполняется" Тогда
		ИдентификаторЗаданияОбновитьДатуПродажи = РезультатРасчета.ИдентификаторЗадания;
		АдресХранилищаОбновитьДатуПродажи = РезультатРасчета.АдресРезультата;
	ИначеЕсли РезультатРасчета.Статус = "Выполнено" Тогда
		АдресХранилищаОбновитьДатуПродажи = РезультатРасчета.АдресРезультата;
		Подключаемый_ОбновитьДатуПродажиНаСервере(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСоответствиеНачалаПрогнозированияСДнемНедели(ПроверкаПоДатеНачалаПрогнозирования)
	
	НомерДняНедели = СервисПрогнозирования.НомерДняНеделиНачалаПрогноза(ДеньНеделиНачалаПрогноза);
	
	Если ПроверкаПоДатеНачалаПрогнозирования Тогда
		// Проверка при создании формы и изменении даты начала прогнозирования.
		РазницаДеньНедели = ДеньНедели(НачалоПрогнозирования) - НомерДняНедели;
		Если РазницаДеньНедели <> 0 Тогда
			ДеньНеделиИсходный       = ДеньНеделиНачалаПрогноза;
			ДеньНеделиНачалаПрогноза = СервисПрогнозирования.ДеньНеделиПоНомеру(НомерДняНедели + РазницаДеньНедели);
			ТекстСообщения = НСтр("ru = 'Скорректирован день недели с ""%1"" на ""%2"" по дате начала прогнозирования %3'");
			ТекстСообщения = СтрШаблон(ТекстСообщения,
				ДеньНеделиИсходный, ДеньНеделиНачалаПрогноза, Формат(НачалоПрогнозирования, "ДЛФ=D"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"ДеньНеделиНачалаПрогноза");
		КонецЕсли;
	Иначе
		РазницаДеньНедели = (ДеньНедели(НачалоПрогнозирования) - НомерДняНедели) * -1;
		Если РазницаДеньНедели <> 0 Тогда
			НачалоПрогнозированияДоИзменения = НачалоПрогнозирования;
			НачалоПрогнозирования            = НачалоПрогнозирования + (86400 * РазницаДеньНедели);
			ТекстСообщения = НСтр("ru = 'Сдвинута дата начала прогнозирования с %1 на %2 по дню недели ""%3""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения,
				Формат(НачалоПрогнозированияДоИзменения, "ДЛФ=D"), Формат(НачалоПрогнозирования, "ДЛФ=D"), ДеньНеделиНачалаПрогноза);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"НачалоПрогнозирования");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти
