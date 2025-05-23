
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьДанныеТаблиц();
	
	Если ТаблицаОстатки.Количество() > 0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОстатки;
	ИначеЕсли ТаблицаПересортица.Количество() > 0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПересортица;
	ИначеЕсли ТаблицаВозвраты.Количество() > 0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВозвраты;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКодТНВЭДПриИзменении(Элемент)
	
	ОбновитьДанныеТаблиц(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМестоХраненияПриИзменении(Элемент)
	
	ОбновитьДанныеТаблиц(Ложь);
	
КонецПроцедуры


&НаКлиенте
Процедура ГиперссылкаОтправитьНажатие(Элемент)
	
	ОткрытьФормуУведомлений("ОжидаютОтправки");
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОжидатьНажатие(Элемент)
	
	ОткрытьФормуУведомлений("ОжидаютПолучения");
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаАрхивНажатие(Элемент)
	
	ОткрытьФормуУведомлений("Завершены");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДанныеФормы(Команда)
	
	ОбновитьДанныеТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеСоздатьУведомление(Команда)
	
	ДействиеСоздатьУведомлениеОбщая(Ложь);
		
КонецПроцедуры

&НаКлиенте
Процедура ДействиеСоздатьИОтправитьУведомление(Команда)
	
	ДействиеСоздатьУведомлениеОбщая(Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокУведомлений(Команда)
	
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеТаблицФормы

&НаСервере
Функция СформироватьПараметрыОтбораТаблиц()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Организация",   ОтборОрганизация);
	ПараметрыОтбора.Вставить("МестоХранения", ОтборМестоХранения);
	ПараметрыОтбора.Вставить("КодТНВЭД", 	  ОтборКодТНВЭД);
	
	Возврат ПараметрыОтбора;
	
КонецФункции
	
&НаСервере
Процедура ОбновитьДанныеТаблиц(ОбновлятьГиперссылки = Истина)
	
	ПараметрыОтбора = СформироватьПараметрыОтбораТаблиц();
	ЗагрузитьДанныеТаблиц(ПараметрыОтбора);
	
	Если ОбновлятьГиперссылки Тогда
		ОбновитьЗаголовкиГиперссылокНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеТаблиц(ПараметрыОтбора = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПодготовитьДанныеДляФормированияУведомлений(Запрос, ПараметрыОтбора);
	ДанныеТаблиц = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПолучитьДанныеДляФормированияУведомлений(Запрос);
	
	ТаблицаОстатки.Загрузить(ДанныеТаблиц.ТаблицаОстатки);
	ТаблицаПересортица.Загрузить(ДанныеТаблиц.ТаблицаПересортица);
	ТаблицаВозвраты.Загрузить(ДанныеТаблиц.ТаблицаВозвраты);
	
	Элементы.ГруппаОстатки.Заголовок 	 = НСтр("ru='По остаткам'") + " (" + СокрЛП(ТаблицаОстатки.Количество()) + ")";
	Элементы.ГруппаПересортица.Заголовок = НСтр("ru='По исправлению остатков'") + " (" + СокрЛП(ТаблицаПересортица.Количество()) + ")";
	Элементы.ГруппаВозвраты.Заголовок 	 = НСтр("ru='По возвратам и прочим поступлениям'") + " (" + СокрЛП(ТаблицаВозвраты.Количество()) + ")";
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеУведомлений

&НаСервере
Функция ПолучитьДанныеДляФормированияУведомленияОстатки(ДополнительныеПараметры)
	
	ПараметрыОтбора = СформироватьПараметрыОтбораТаблиц();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПодготовитьДанныеДляФормированияУведомлений(Запрос, ПараметрыОтбора);
	
	Если ДополнительныеПараметры.Свойство("ЗаполнениеПоОстаткам") Тогда
		
		ТекущаяТаблица = ТаблицаОстатки;
		ТекущаяТаблицаФормы = Элементы.ТаблицаОстатки;
		
	ИначеЕсли ДополнительныеПараметры.Свойство("ЗаполнениеПоВозвратам") Тогда
		
		ТекущаяТаблица = ТаблицаВозвраты;
		ТекущаяТаблицаФормы = Элементы.ТаблицаВозвраты;
		
	Иначе
		
		ТекущаяТаблица = ТаблицаПересортица;
		ТекущаяТаблицаФормы = Элементы.ТаблицаПересортица;
		
	КонецЕсли;
	
	ТаблицаОтбора = ТекущаяТаблица.Выгрузить(Новый Массив);
	
	Для Каждого НомерСтроки Из ТекущаяТаблицаФормы.ВыделенныеСтроки Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаОтбора.Добавить(), ТекущаяТаблица.НайтиПоИдентификатору(НомерСтроки));
	КонецЦикла;
	
	Если ТаблицаОтбора.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Если ДополнительныеПараметры.Свойство("ЗаполнениеПоПересорту") Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Организация КАК Организация,
		|	Т.РНПТ КАК РНПТ,
		|	Т.ПервичноеУведомление КАК ДокументУведомлениеОбОстатках
		|ПОМЕСТИТЬ ВТТаблицаОтбора
		|ИЗ
		|	&ТаблицаОтбора КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Организация КАК Организация,
		|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры,
		|	Т.КодТНВЭД КАК КодТНВЭД,
		|	НЕОПРЕДЕЛЕНО КАК КодОКПД2,
		|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО КАК Характеристика,
		|	НЕОПРЕДЕЛЕНО КАК Назначение,
		|	НЕОПРЕДЕЛЕНО КАК Серия,
		|	НЕОПРЕДЕЛЕНО КАК ТипМестаХранения,
		|	НЕОПРЕДЕЛЕНО КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК Подразделение,
		|	НЕОПРЕДЕЛЕНО КАК Договор,
		|	НЕОПРЕДЕЛЕНО КАК Хранитель,
		|	НЕОПРЕДЕЛЕНО КАК Контрагент,
		|	Т.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Т.КодТНВЭД.ЕдиницаИзмерения КАК ЕдиницаПрослеживаемости,
		|	НЕОПРЕДЕЛЕНО КАК ВидЗапасов,
		|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
		|	Т.ДокументУведомлениеОбОстатках,
		|	Т.НомерКорректировки,
		|	Т.РНПТ КАК РНПТ,
		|	Т.КоличествоПересорт КАК Количество
		|ПОМЕСТИТЬ ВТДанныеДляЗаполненияРасширенные
		|ИЗ
		|	ТаблицаИсходныхДанных КАК Т
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаОтбора КАК Отбор
		|		ПО Т.Организация = Отбор.Организация
		|			И Т.РНПТ = Отбор.РНПТ
		|			И Т.ДокументУведомлениеОбОстатках = Отбор.ДокументУведомлениеОбОстатках
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	КодТНВЭД
		|";
		
	ИначеЕсли ДополнительныеПараметры.Свойство("ЗаполнениеПоОстаткам")
	 ИЛИ ДополнительныеПараметры.Свойство("ЗаполнениеПоВозвратам") Тогда
	 
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Организация КАК Организация,
		|	Т.КодТНВЭД КАК КодТНВЭД,
		|	Т.МестоХранения КАК МестоХранения
		|ПОМЕСТИТЬ ВТТаблицаОтбора
		|ИЗ
		|	&ТаблицаОтбора КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Организация КАК Организация,
		|	ВЫРАЗИТЬ(Т.АналитикаУчетаНоменклатуры КАК Справочник.КлючиАналитикиУчетаНоменклатуры) КАК АналитикаУчетаНоменклатуры,
		|	Т.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД КАК КодТНВЭД,
		|	Т.АналитикаУчетаНоменклатуры.Номенклатура.КодОКПД2 КАК КодОКПД2,
		|	ВЫРАЗИТЬ(Т.АналитикаУчетаНоменклатуры КАК Справочник.КлючиАналитикиУчетаНоменклатуры).Номенклатура КАК Номенклатура,
		|	Т.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	Т.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	Т.АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	Т.АналитикаУчетаНоменклатуры.ТипМестаХранения КАК ТипМестаХранения,
		|	Т.АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
		|	Т.АналитикаУчетаНоменклатуры.Подразделение КАК Подразделение,
		|	Т.АналитикаУчетаНоменклатуры.Договор КАК Договор,
		|	Т.АналитикаУчетаНоменклатуры.Партнер КАК Хранитель,
		|	Т.АналитикаУчетаНоменклатуры.Контрагент КАК Контрагент,
		|	Т.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Т.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмеренияТНВЭД КАК ЕдиницаПрослеживаемости,
		|	Т.ВидЗапасов КАК ВидЗапасов,
		|	Т.НомерГТД КАК НомерГТД,
		|	ЗНАЧЕНИЕ(Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПустаяСсылка) КАК ДокументУведомлениеОбОстатках,
		|	0 КАК НомерКорректировки,
		|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК РНПТ,
		|	Т.Количество КАК Количество
		|ПОМЕСТИТЬ ВТДанныеДляЗаполненияРасширенные
		|ИЗ
		|	ТаблицаИсходныхДанных КАК Т
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаОтбора КАК Отбор
		|		ПО Т.Организация = Отбор.Организация
		|			И Т.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД = Отбор.КодТНВЭД
		|			И (Т.АналитикаУчетаНоменклатуры.МестоХранения = Отбор.МестоХранения
		|				ИЛИ &ЗаполнениеПоВозвратам)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	КодТНВЭД
		|";
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +
	";
	|
	|////////////////////////////////////////////////////////////////////////////////
	|" + "
	|ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	Т.КодТНВЭД КАК КодТНВЭД,
	|	Т.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Т.ЕдиницаПрослеживаемости КАК ЕдиницаПрослеживаемости,
	|	Т.ДокументУведомлениеОбОстатках,
	|	Т.НомерКорректировки,
	|	Т.РНПТ КАК РНПТ,
	|	АВТОНОМЕРЗАПИСИ() КАК НомерГруппы
	|ПОМЕСТИТЬ ВТПоляГруппировкиПредварительная
	|ИЗ
	|	ВТДанныеДляЗаполненияРасширенные КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	Т.КодТНВЭД КАК КодТНВЭД,
	|	Т.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Т.ЕдиницаПрослеживаемости КАК ЕдиницаПрослеживаемости,
	|	Т.ДокументУведомлениеОбОстатках,
	|	Т.НомерКорректировки,
	|	Т.РНПТ КАК РНПТ,
	|	МИНИМУМ(Т.НомерГруппы) КАК НомерГруппы
	|ПОМЕСТИТЬ ВТПоляГруппировки
	|ИЗ
	|	ВТПоляГруппировкиПредварительная КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Организация,
	|	Т.КодТНВЭД,
	|	Т.ЕдиницаИзмерения,
	|	Т.ЕдиницаПрослеживаемости,
	|	Т.ДокументУведомлениеОбОстатках,
	|	Т.НомерКорректировки,
	|	Т.РНПТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.АналитикаУчетаНоменклатуры,
	|	Т.Серия,
	|	Т.Номенклатура,
	|	Т.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|	Т.Номенклатура.ВидНоменклатуры.ПолитикаУчетаСерий КАК ПолитикаУчетаСерий,
	|	Т.Склад,
	|	Т.Подразделение,
	|	Т.ТипМестаХранения
	|ПОМЕСТИТЬ ВТДанныеДляСтатусовСерий
	|ИЗ
	|	ВТДанныеДляЗаполненияРасширенные КАК Т
	|ГДЕ
	|	НЕ &КорректировочноеУведомление
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.АналитикаУчетаНоменклатуры,
	|	Т.Серия,
	|	ВЫБОР
	|		КОГДА Т.ТипМестаХранения <> ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
	|		ТОГДА ВЫБОР
	|			КОГДА ПолитикиУчетаСерийПоСкладам.ПолитикаУчетаСерий ЕСТЬ NULL
	|					И ПолитикиУчетаСерийПоПодразделениям.ПолитикаУчетаСерий ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ПолитикиУчетаСерийПоСкладам.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|							ИЛИ ПолитикиУчетаСерийПоПодразделениям.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|						ТОГДА ВЫБОР
	|								КОГДА Т.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|									ТОГДА 14
	|								ИНАЧЕ 13
	|							КОНЕЦ
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|			КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|			КОГДА Т.ПолитикаУчетаСерий ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ ВЫБОР
	|					КОГДА Т.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|						ТОГДА
	|							ВЫБОР
	|								КОГДА Т.ПолитикаУчетаСерий.УчетСерийВПереданныхНаХранениеТоварах
	|										ИЛИ Т.ПолитикаУчетаСерий.УчетТоваровВПутиОтПоставщикаПоСериям
	|										ИЛИ Т.ПолитикаУчетаСерий.УчетСерийВНеотфактурованныхПоставкахТоваров
	|									ТОГДА ВЫБОР
	|											КОГДА Т.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|												ТОГДА 18
	|											ИНАЧЕ 17
	|										КОНЕЦ
	|									ИНАЧЕ 0
	|							КОНЕЦ
	|						ИНАЧЕ 0
	|				КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ВТСтатусыУказанияСерий
	|ИЗ
	|	ВТДанныеДляСтатусовСерий КАК Т
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерийПоСкладам
	|		ПО ПолитикиУчетаСерийПоСкладам.Склад = Т.Склад
	|		И Т.ВидНоменклатуры = ПолитикиУчетаСерийПоСкладам.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерийПоПодразделениям
	|		ПО ПолитикиУчетаСерийПоПодразделениям.Склад = Т.Подразделение
	|		И Т.ВидНоменклатуры = ПолитикиУчетаСерийПоПодразделениям.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТПоляГруппировки.НомерГруппы КАК НомерГруппы,
	|	Т.Организация КАК Организация,
	|	Т.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Т.КодТНВЭД КАК КодТНВЭД,
	|	ВЫБОР КОГДА МАКСИМУМ(Т.КодОКПД2) = МИНИМУМ(Т.КодОКПД2)
	|		ТОГДА МАКСИМУМ(Т.КодОКПД2)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.КлассификаторОКПД2.ПустаяСсылка)
	|	КОНЕЦ КАК КодОКПД2,
	|	Т.Номенклатура КАК Номенклатура,
	|	Т.Характеристика КАК Характеристика,
	|	Т.Назначение КАК Назначение,
	|	Т.Серия КАК Серия,
	|	Т.ТипМестаХранения КАК ТипМестаХранения,
	|	Т.Склад КАК Склад,
	|	Т.Подразделение КАК Подразделение,
	|	Т.Договор КАК Договор,
	|	Т.Хранитель КАК Хранитель,
	|	Т.Контрагент КАК Контрагент,
	|	Т.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Т.ЕдиницаПрослеживаемости КАК ЕдиницаПрослеживаемости,
	|	Т.ВидЗапасов КАК ВидЗапасов,
	|	Т.НомерГТД КАК НомерГТД,
	|	ЕСТЬNULL(СтатусыУказанияСерий.СтатусУказанияСерий, 0) КАК СтатусУказанияСерий,
	|	Т.ДокументУведомлениеОбОстатках,
	|	ВЫБОР КОГДА &КорректировочноеУведомление
	|		ТОГДА Т.НомерКорректировки + 1
	|		ИНАЧЕ Т.НомерКорректировки
	|	КОНЕЦ КАК НомерКорректировки,
	|	Т.РНПТ КАК РНПТ,
	|	&ЗаполнениеПоВозвратам КАК ОформленНаОснованииВозвратаТоваров,
	|	&КорректировочноеУведомление КАК КорректировочноеУведомление,
	|	СУММА(Т.Количество) КАК Количество,
	|	СУММА(ВЫБОР КОГДА Т.ЕдиницаИзмерения = Т.ЕдиницаПрослеживаемости
	|			ТОГДА Т.Количество
	|			ИНАЧЕ 0
	|		  КОНЕЦ) КАК КоличествоПоРНПТ
	|ИЗ
	|	ВТДанныеДляЗаполненияРасширенные КАК Т
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоляГруппировки КАК ВТПоляГруппировки
	|		ПО Т.Организация = ВТПоляГруппировки.Организация
	|		И Т.КодТНВЭД = ВТПоляГруппировки.КодТНВЭД
	|		И Т.ЕдиницаИзмерения = ВТПоляГруппировки.ЕдиницаИзмерения
	|		И Т.ЕдиницаПрослеживаемости = ВТПоляГруппировки.ЕдиницаПрослеживаемости
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТСтатусыУказанияСерий КАК СтатусыУказанияСерий
	|		ПО Т.АналитикаУчетаНоменклатуры = СтатусыУказанияСерий.АналитикаУчетаНоменклатуры
	|		И Т.Серия = СтатусыУказанияСерий.Серия
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТПоляГруппировки.НомерГруппы,
	|	Т.Организация,
	|	Т.АналитикаУчетаНоменклатуры,
	|	Т.КодТНВЭД,
	|	Т.Номенклатура,
	|	Т.Характеристика,
	|	Т.Назначение,
	|	Т.Серия,
	|	Т.ТипМестаХранения,
	|	Т.Склад,
	|	Т.Подразделение,
	|	Т.Договор,
	|	Т.Хранитель,
	|	Т.Контрагент,
	|	Т.ЕдиницаИзмерения,
	|	Т.ЕдиницаПрослеживаемости,
	|	Т.ВидЗапасов,
	|	Т.НомерГТД,
	|	ЕСТЬNULL(СтатусыУказанияСерий.СтатусУказанияСерий, 0),
	|	Т.ДокументУведомлениеОбОстатках,
	|	ВЫБОР КОГДА &КорректировочноеУведомление
	|		ТОГДА Т.НомерКорректировки + 1
	|		ИНАЧЕ Т.НомерКорректировки
	|	КОНЕЦ,
	|	Т.РНПТ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерГруппы,
	|	АналитикаУчетаНоменклатуры";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"ТаблицаИсходныхДанных",
		?(ДополнительныеПараметры.Свойство("ЗаполнениеПоОстаткам"), "ВТОстатки",
			?(ДополнительныеПараметры.Свойство("ЗаполнениеПоВозвратам"), "ВТВозвраты", "ВТПересорт")));
		
 	Запрос.УстановитьПараметр("ЗаполнениеПоВозвратам", ДополнительныеПараметры.Свойство("ЗаполнениеПоВозвратам"));
 	Запрос.УстановитьПараметр("КорректировочноеУведомление", ДополнительныеПараметры.Свойство("ЗаполнениеПоПересорту"));
	
	ТаблицаДанные = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаДанные;
	
КонецФункции

&НаСервере
Процедура СформироватьДокументыУведомлений(РеквизитыПервичногоДокумента, ДополнительныеПараметры)
	
	ТаблицаДанные = ПолучитьДанныеДляФормированияУведомленияОстатки(ДополнительныеПараметры);
	
	Если НЕ ЗначениеЗаполнено(ТаблицаДанные) Тогда
		Возврат;
	КонецЕсли;
	
	// Создание документов
	ПараметрыЗаполнения = Новый Структура;
	
	Для Каждого МетаРеквизит Из Метаданные.Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.Реквизиты Цикл
		ПараметрыЗаполнения.Вставить(МетаРеквизит.Имя);
	КонецЦикла;
	
	ПараметрыЗаполнения.ДатаСоздания = ТекущаяДатаСеанса();
	ПараметрыЗаполнения.Ответственный = Пользователи.ТекущийПользователь();
	ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров = НачалоМесяца(Константы.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров.Получить())-1;
	
	НомерГруппы = Неопределено;
	ТекущийДокумент = Неопределено;
	СформированныеДокументы = Новый Массив;
	
	Для Каждого СтрокаДанных Из ТаблицаДанные Цикл
		
		Если НомерГруппы <> СтрокаДанных.НомерГруппы Тогда
			
			Если ТекущийДокумент <> Неопределено Тогда
				
				ЗаполнитьСуммуУведомления(ТекущийДокумент);
				
				ТекущийДокумент.Записать(РежимЗаписиДокумента.Проведение);
				СформированныеДокументы.Добавить(ТекущийДокумент.Ссылка);
				
			КонецЕсли;
			
			НомерГруппы = СтрокаДанных.НомерГруппы;
			
			ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, СтрокаДанных);
			ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, РеквизитыПервичногоДокумента);
			
			ТекущийДокумент = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.СоздатьДокумент();
			ТекущийДокумент.Дата = ?(СтрокаДанных.ОформленНаОснованииВозвратаТоваров, ТекущаяДатаСеанса(), Мин(ТекущаяДатаСеанса(), ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров));
			ТекущийДокумент.Заполнить(ПараметрыЗаполнения);
			
			ТекущийДокумент.Количество = 0;
			ТекущийДокумент.КоличествоПрослеживаемости = 0;
			
			Если ЗначениеЗаполнено(ТекущийДокумент.НаименованиеПервичногоДокумента) Тогда
				ТекущийДокумент.Комментарий = ТекущийДокумент.НаименованиеПервичногоДокумента
					+ " №" + ТекущийДокумент.НомерПервичногоДокумента
					+ " " + НСтр("ru='от'") + " " + Формат(ТекущийДокумент.ДатаПервичногоДокумента, "ДЛФ=D");
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ТекущийДокумент.КорректировочноеУведомление Тогда
			
			СтрокаВидыЗапасов = ТекущийДокумент.ВидыЗапасов.Добавить();
			
			ЗаполнитьЗначенияСвойств(СтрокаВидыЗапасов, СтрокаДанных);
			
			ТекущийДокумент.Количество = ТекущийДокумент.Количество + СтрокаВидыЗапасов.Количество;
			ТекущийДокумент.КоличествоПрослеживаемости = ТекущийДокумент.КоличествоПрослеживаемости + СтрокаВидыЗапасов.КоличествоПоРНПТ;
			
		Иначе
			
			ТекущийДокумент.Количество = ТекущийДокумент.Количество + СтрокаДанных.Количество;
			ТекущийДокумент.КоличествоПрослеживаемости = ТекущийДокумент.КоличествоПрослеживаемости + СтрокаДанных.КоличествоПоРНПТ;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийДокумент <> Неопределено Тогда
		
		ЗаполнитьСуммуУведомления(ТекущийДокумент);
		
		ТекущийДокумент.Записать(РежимЗаписиДокумента.Проведение);
		СформированныеДокументы.Добавить(ТекущийДокумент.Ссылка);
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.СразуОтправить Тогда
		ОтправитьСформированныеДокументы(СформированныеДокументы);
	КонецЕсли;
	
	ОбновитьДанныеТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммуУведомления(ТекущийДокумент)
	
	Если ТекущийДокумент.КорректировочноеУведомление Тогда
		
		ТекущийДокумент.Сумма = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПолучитьСуммуПоКорректировочномуУведомлению(
			ТекущийДокумент.Количество,
			ТекущийДокумент.ДокументУведомлениеОбОстатках);
		
	Иначе
		
		ТаблицаВидыЗапасов = ТекущийДокумент.ВидыЗапасов.Выгрузить(, "АналитикаУчетаНоменклатуры, ВидЗапасов, Количество");
		ТекущийДокумент.Сумма = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПолучитьСуммуПоУведомлению(
			ТаблицаВидыЗапасов,
			ТекущийДокумент.Дата,
			ТекущийДокумент.Организация);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияФормы

&НаКлиенте
Процедура ДействиеСоздатьУведомлениеОбщая(СразуОтправить)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОстатки Тогда
		
		ТекущаяТаблица = Элементы.ТаблицаОстатки;
		ПараметрыОткрытия = Новый Структура("ЗаполнениеПоОстаткам, СразуОтправить", Истина, СразуОтправить);
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВозвраты Тогда
		
		ТекущаяТаблица = Элементы.ТаблицаВозвраты;
		ПараметрыОткрытия = Новый Структура("ЗаполнениеПоВозвратам, СразуОтправить", Истина, СразуОтправить);
		
	Иначе
		
		ТекущаяТаблица = Элементы.ТаблицаПересортица;
		ПараметрыОткрытия = Новый Структура("ЗаполнениеПоПересорту, СразуОтправить", Истина, СразуОтправить);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущаяТаблица.ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОткрытия.Свойство("ЗаполнениеПоПересорту") Тогда
		
		ДействиеСоздатьУведомлениеЗавершение(Новый Структура, ПараметрыОткрытия);
		
	Иначе
		
		Обработчик = Новый ОписаниеОповещения("ДействиеСоздатьУведомлениеЗавершение", ЭтотОбъект, ПараметрыОткрытия);
		
		ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДанныеПервичногоДокумента",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Обработчик,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДействиеСоздатьУведомлениеЗавершение(РеквизитыПервичногоДокумента, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РеквизитыПервичногоДокумента)
	 И НЕ ДополнительныеПараметры.Свойство("ЗаполнениеПоПересорту") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьДокументыУведомлений(РеквизитыПервичногоДокумента, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбменСКО

&НаКлиенте
Процедура ОткрытьФормуУведомлений(Состояние)
	
	ТипУведомления = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров");
	
	ПараметрыФормы = Новый Структура;
	ИмяФормыУведомлений = "";
	
	ИмяФормыУведомлений = "ЖурналДокументов.ПрослеживаемостьУведомления.ФормаСписка";
	ПараметрыФормы.Вставить("ТипУведомления", ТипУведомления);
	ПараметрыФормы.Вставить("Состояние", Состояние);
	
	ОткрытьФорму(
		ИмяФормыУведомлений,
		ПараметрыФормы,
		,,,,,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовкиГиперссылок(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьЗаголовкиГиперссылокНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиГиперссылокНаСервере()
	
	МассивОрганизаций = ?(ЗначениеЗаполнено(ОтборОрганизация), ОбщегоНазначенияУТКлиентСервер.Массив(ОтборОрганизация), Неопределено);
	ТипыУведомлений = Новый Массив;
	ТипыУведомлений.Добавить(Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров"));
	
	КоличестваУведомленийКОформлению =
		ЖурналыДокументов.ПрослеживаемостьУведомления.СтатистикаОтправкиУведомлений(ТипыУведомлений, МассивОрганизаций);
	
	ШаблонЗаголовокЭлементаОтправить = НСтр("ru = 'Отправить %1'");
	ШаблонЗаголовокЭлементаОжидать = НСтр("ru = 'Ожидать получения РНПТ %1'");
	ШаблонЗаголовокЭлементаАрхив = НСтр("ru = 'Архив %1'");
	
	Для Каждого КлючЗначение Из КоличестваУведомленийКОформлению Цикл
		
		КоличествоКОформлениюОтправить = КлючЗначение.Значение.ОжидаютОтправки;
		КоличествоКОформлениюОжидать = КлючЗначение.Значение.ОжидаютПолучения;
		КоличествоКОформлениюАрхив = КлючЗначение.Значение.Завершены;
	
		ЗаголовокЭлементаОтправить =
			СтрШаблон(
				ШаблонЗаголовокЭлементаОтправить,
				?(ЗначениеЗаполнено(КоличествоКОформлениюОтправить), "(" + Строка(КоличествоКОформлениюОтправить) + ")", ""));
		
		ЗаголовокЭлементаОжидать =
			СтрШаблон(
				ШаблонЗаголовокЭлементаОжидать,
				?(ЗначениеЗаполнено(КоличествоКОформлениюОжидать), "(" + Строка(КоличествоКОформлениюОжидать) + ")", ""));
		
		ЗаголовокЭлементаАрхив =
			СтрШаблон(
				ШаблонЗаголовокЭлементаАрхив,
				?(ЗначениеЗаполнено(КоличествоКОформлениюАрхив), "(" + Строка(КоличествоКОформлениюАрхив) + ")", ""));
		
		Элементы.ГиперссылкаОтправить.Заголовок = СокрЛП(ЗаголовокЭлементаОтправить);
		Элементы.ГиперссылкаОжидать.Заголовок 	= СокрЛП(ЗаголовокЭлементаОжидать);
		Элементы.ГиперссылкаАрхив.Заголовок 	= СокрЛП(ЗаголовокЭлементаАрхив);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьСформированныеДокументы(СформированныеДокументы)
	
	// ТоДо добавить код отправки сформированных документов; также при создании формы возможно нужен код, который проверит, возможна ли в принципе отправка (настроен ли обмен)
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
