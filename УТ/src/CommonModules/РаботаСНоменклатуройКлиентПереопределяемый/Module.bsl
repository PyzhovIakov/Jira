
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ФормаПоискНоменклатурыПоШтрихкоду

// Процедура, вызываемая из обработчика события формы ПриОткрытии формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//
Процедура ПоискНоменклатурыПоШтрихкодуПриОткрытии(Форма) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуПриОткрытии(Форма);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая из обработчика события формы ПриЗакрытии формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  ЗавершениеРаботы - Булево - признак завершения работы.
//
Процедура ПоискНоменклатурыПоШтрихкодуПриЗакрытии(Форма, ЗавершениеРаботы) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуПриЗакрытии(Форма, ЗавершениеРаботы);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая из обработчика оповещения формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  ИмяСобытия	 - Строка - имя события.
//  Параметр	 - Произвольный - параметры оповещения.
//  Источник	 - Строка - источник оповещения.
//  ШтрихКоды	 - Массив - массив строк штрихкодов. Заполняется при отработке оповещений от оборудования (Строка).
//
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ШтрихКоды) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ШтрихКоды);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая при обработке выбора формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  ВыбранноеЗначение - Произвольный - выбранное значение.
//  ИсточникВыбора - Произвольный - источник выбора.
//
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая при изменении поля Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - форма поиска номенклатуры по штрихкоду.
//  Элемент	 - ПолеФормы - изменяемое поле формы.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(Форма, Элемент) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(Форма, Элемент);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая при создании в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураСоздание(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуНоменклатураСоздание(Форма, Элемент, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая при начале выбора в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  ДанныеВыбора		 - СписокЗначений - данные выбора..
//  СтандартнаяОбработка - Булево -  признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоискНоменклатурыПоШтрихкодуНоменклатураНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура, вызываемая при изменении поля Характеристика формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - форма поиска номенклатуры по штрихкоду.
//  Элемент	 - ПолеФормы - изменяемое поле формы.
//
Процедура ПоискНоменклатурыПоШтрихкодуХарактеристикаПриИзменении(Форма, Элемент) Экспорт
	
		
КонецПроцедуры

// Процедура, вызываемая при создании в поле Характеристика формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуХарактеристикаСоздание(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Процедура, вызываемая при начале выбора в поле Характеристика формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  ДанныеВыбора		 - СписокЗначений - данные выбора..
//  СтандартнаяОбработка - Булево -  признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуХарактеристикаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеПрикладныхОбъектов

// Процедура открывает форму элемента номенклатуры в случает интерактивного заполнения.
//
// Параметры:
//  ПараметрыФормы				 - Структура		 - параметры, которые необходимо передать в форму элемента.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения	 - оповещение о закрытии формы. В обработчик должен передаваться
//                                                         параметр НоменклатураСсылка с ссылкой на элемент.
//
Процедура СоздатьНоменклатуруИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт 
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.СоздатьНоменклатуруИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Процедура открывает форму элемента вида номенклатуры в случает интерактивного заполнения.
//  Режим открытия окна должен установлен в значение Независимый.
//
// Параметры:
//  ПараметрыФормы				 - Структура		 - параметры, которые необходимо передать в форму элемента.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения	 - оповещение о закрытии.
//
Процедура СоздатьВидНоменклатурыИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.СоздатьВидНоменклатурыИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеПрикладныхФорм

// Открытие формы значения дополнительного реквизита.
//
// Параметры:
//  ПараметрыФормы - Структура - Ключи:
//                   * РеквизитСсылка - ОпределяемыйТип.ДополнительныеРеквизитыРаботаСНоменклатурой - Ссылка на дополнительный реквизит.
//                   * Наименование   - Строка - Наименование значения дополнительного реквизита по умолчанию.
//  Форма          - ФормаКлиентскогоПриложения - Форма-владелец.
//
Процедура ОткрытьФормуДополнительногоЗначения(ПараметрыФормы, Форма) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуДополнительногоЗначения(ПараметрыФормы, Форма);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы дополнительного реквизита.
//
// Параметры:
//  ПараметрыФормы	 - Структура - параметры формы.
//  Владелец			 - ФормаКлиентскогоПриложения - форма владелец.
//
Процедура ОткрытьФормуДополнительногоРеквизита(ПараметрыФормы, Владелец) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуДополнительногоРеквизита(ПараметрыФормы, Владелец);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы номенклатуры.
//
// Параметры:
//  НоменклатураСсылка	 - ОпределяемыйТип.НоменклатураРаботаСНоменклатурой - ссылка на номенклатуру.
//  Владелец			 - ФормаКлиентскогоПриложения - форма владелец.
//
Процедура ОткрытьФормуНоменклатуры(НоменклатураСсылка, Владелец) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуНоменклатуры(НоменклатураСсылка, Владелец);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы вида номенклатуры.
//
// Параметры:
//  ВидНоменклатурыСсылка - ОпределяемыйТип.ВидНоменклатурыРаботаСНоменклатурой - ссылка на вид номенклатуры.
//  Владелец			 - ФормаКлиентскогоПриложения - форма владелец.
//
Процедура ОткрытьФормуВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы списка вида номенклатуры.
//
// Параметры:
//  ВидНоменклатурыСсылка		 - ОпределяемыйТип.ВидНоменклатурыРаботаСНоменклатурой - ссылка на вид номенклатуры.
//  Владелец					 - ФормаКлиентскогоПриложения - форма владелец.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения, Неопределено	 - оповещение о закрытии.
//
Процедура ОткрытьФормуСпискаВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуСпискаВидаНоменклатуры(ВидНоменклатурыСсылка, Владелец, ОписаниеОповещенияОЗакрытии);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы выбора номенклатуры.
// Ожидаемый результат закрытия формы - массив ссылок типа ОпределяемыйТип.НоменклатураРаботаСНоменклатурой.
//
// Параметры:
//  ПараметрыФормы              - Структура                  - параметры формы.
//  Владелец                    - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения         - оповещение о закрытии формы.
//  РежимОткрытияОкнаФормы      - РежимОткрытияОкнаФормы     - варианты открытия формы клиентского приложения.
//
Процедура ОткрытьФормуВыбораНоменклатуры(ПараметрыФормы, 
	Владелец = Неопределено,
	ОписаниеОповещенияОЗакрытии = Неопределено, 
	РежимОткрытияОкнаФормы = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуВыбораНоменклатуры(ПараметрыФормы, Владелец, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открытие формы подбора номенклатуры с характеристиками.
// Ожидаемый результат закрытия формы - строка - адрес во временном хранилище,
//   либо структура с ключем АдресТоваровВХранилище - строка - адрес во временном хранилище,
//  По адресу во временном хранилище должна располагаться таблица с колонками Номенклатура, Характеристика.
//  Таблица может содержать и другие колонки, они будут проигнорированы при обработке. 
//
// Параметры:
//  Владелец                    - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения         - оповещение о закрытии формы.
//  РежимОткрытияОкнаФормы      - РежимОткрытияОкнаФормы     - варианты открытия формы клиентского приложения.
//
Процедура ОткрытьФормуПодбораНоменклатурыСХарактеристиками(Владелец = Неопределено,
	ОписаниеОповещенияОЗакрытии = Неопределено, 
	РежимОткрытияОкнаФормы = Неопределено) Экспорт
	
КонецПроцедуры

//++ Локализация

// Открытие формы элемента Номенклатуры с визуализацией проблем заполнения.
// В качестве идентификатора реквизита может использоваться строка:
//  * ключ структуры РаботаСНоменклатурой.КлючевыеРеквизитыНоменклатурыДляВыгрузки(),
//  * имя перечисления Перечисления.РеквизитыНоменклатурыДляВыгрузки
//  * псевдоним доп.реквизита 1С:Номенклатуры, см. РаботаСНоменклатуройПереопределяемый.ИнициализацияЗапросаВыборкиДанныхДляВыгрузки
//  или ссылка - ОпределяемыеТипы.ДополнительныеРеквизитыРаботаСНоменклатурой - доп.реквизит номенклатуры.
//
// Параметры:
//  НоменклатураСсылка  - ОпределяемыйТип.НоменклатураРаботаСНоменклатурой - ссылка на номенклатуру.
//  НезаполненныеДанные - Массив из Строка - содержит имена ключевых реквизитов, как они заданы в методе КлючевыеРеквизитыНоменклатурыДляВыгрузки()
//                      - Массив из Соответствие - возможные ключи описаны выше, значения - сообщения об ошибке. 
//                                                 Такой тип параметра используется для визуализации ошибок при отправке в Национальный каталог.
//  Форма               - ФормаКлиентскогоПриложения - форма из которой происходит вызов процедуры.
//  ОписаниеОповещения  - ОписаниеОповещения - оповещение о закрытии формы.
//
Процедура ПоказатьНезаполненныеДанныеНоменклатуры(НоменклатураСсылка, НезаполненныеДанные, Форма, ОписаниеОповещения) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ПоказатьНезаполненныеДанныеНоменклатуры(НоменклатураСсылка, НезаполненныеДанные, Форма, ОписаниеОповещения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

//-- Локализация

#Область УстаревшиеПроцедурыИФункции

// Устарела. Отсутствует необходимость в использовании.
// Открытие формы списка номенклатуры.
//
// Параметры:
//  НоменклатураСсылка	 - ОпределяемыйТип.НоменклатураРаботаСНоменклатурой - ссылка на номенклатуру.
//  Владелец			 - ФормаКлиентскогоПриложения - форма владелец.
//
Процедура ОткрытьФормуСпискаНоменклатуры(НоменклатураСсылка, Владелец) Экспорт
	
	//++ НЕ ГОСИС
	РаботаСНоменклатуройКлиентУТ.ОткрытьФормуСпискаНоменклатуры(НоменклатураСсылка, Владелец);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
