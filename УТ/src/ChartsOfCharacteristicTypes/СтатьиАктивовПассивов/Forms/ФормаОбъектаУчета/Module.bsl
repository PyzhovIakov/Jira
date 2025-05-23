
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	УстановитьУсловноеОформление();
	
	// Подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ИнициализироватьЗначенияРеквизитовФормы();
	
	УправлениеВидимостьюЭлементовФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПолноеИмяФормы = "ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.РазблокированиеРеквизитов";
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЭтоОбъектФинансовогоУчета", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкна);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъектыНастройки(Команда)
	
	ПолноеИмяФормы = Объект.ИсточникОбъектовНастройки + "." + "ФормаСписка";
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ФиксированныеНастройки", КомпоновщикНастроекОбъектовНастройки.Настройки);
	
	ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъектыДетальныхНастроек(Команда)
	
	ПолноеИмяФормы = Объект.ИсточникДетальныхНастроек + "." + "ФормаСписка";
	
	ОткрытьФорму(ПолноеИмяФормы,, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиИспользованияОтборПредставление.Имя);
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомпоновщикНастроекИспользования.Настройки.Отбор.ЛевоеЗначение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомпоновщикНастроекИспользования.Настройки.Отбор.ВидСравнения");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомпоновщикНастроекИспользования.Настройки.Отбор.ТипГруппы");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Функциональные опции'"));
	
	//
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьЗначенияРеквизитовФормы()
	
	ХранилищаЗначений = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Ссылка,
		"ОтборДанных,ОтборОбъектовНастройки,СвязиФункциональныхОпций");
	
	Если ЗначениеЗаполнено(Объект.ИсточникДанных) Тогда
		МетаданныеИсточника = Метаданные.РегистрыНакопления[Объект.ИсточникДанных];
		ПредставлениеИсточникаДанных = МетаданныеИсточника.Синоним;
		ПараметрыОтраженияДвиженийИсточника = РегистрыНакопления[Объект.ИсточникДанных].ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеИсточника);
		
		ПланыВидовХарактеристик.СтатьиАктивовПассивов.ИнициализироватьКомпоновщикНастроекИсточникомДанных(
			КомпоновщикНастроекИсточникаДанных, Объект.ИсточникДанных,
			ПараметрыОтраженияДвиженийИсточника, УникальныйИдентификатор);
		
		НастройкиОтбораДанных = ХранилищаЗначений.ОтборДанных.Получить();
		Если ТипЗнч(НастройкиОтбораДанных) = Тип("НастройкиКомпоновкиДанных") Тогда
			КомпоновщикНастроекИсточникаДанных.ЗагрузитьНастройки(НастройкиОтбораДанных);
		КонецЕсли;
		
		Элементы.ГруппаОтборДанных.Заголовок = ПредставлениеОтбора(КомпоновщикНастроекИсточникаДанных);
		
		ЗаполнитьТаблицуРесурсов("РесурсыУпр", ПараметрыОтраженияДвиженийИсточника, МетаданныеИсточника);
		ЗаполнитьТаблицуРесурсов("РесурсыРегл", ПараметрыОтраженияДвиженийИсточника, МетаданныеИсточника);
		ЗаполнитьТаблицуРесурсов("РесурсыВал", ПараметрыОтраженияДвиженийИсточника, МетаданныеИсточника);
		ЗаполнитьТаблицуРесурсов("РесурсыКоличество", ПараметрыОтраженияДвиженийИсточника, МетаданныеИсточника);
		
		ВалютныйУчет = ОпределитьИспользованиеУчета("РесурсыВал");
		КоличественныйУчет = ОпределитьИспользованиеУчета("РесурсыКоличество");
		
		Элементы.ГруппаРесурсыУпр.Заголовок = ПредставлениеРесурсов("РесурсыУпр");
		Элементы.ГруппаРесурсыРегл.Заголовок = ПредставлениеРесурсов("РесурсыРегл");
		
		Если ВалютныйУчет Тогда
			Элементы.ГруппаРесурсыВал.Заголовок = ПредставлениеРесурсов("РесурсыВал");
		КонецЕсли;
		
		Если КоличественныйУчет Тогда
			Элементы.ГруппаРесурсыКоличество.Заголовок = ПредставлениеРесурсов("РесурсыКоличество");
		КонецЕсли;
		
		
	Иначе
		ПредставлениеИсточникаДанных = НСтр("ru = 'Статья использует данные корреспондирующих статей'");
	КонецЕсли;
	
	Если Объект.ФункциональныеОпции.Количество() > 0 Тогда
		ПланыВидовХарактеристик.СтатьиАктивовПассивов.ИнициализироватьКомпоновщикНастроекФункциональнымиОпциями(
			КомпоновщикНастроекИспользования, Объект.ФункциональныеОпции, УникальныйИдентификатор);
		
		НастройкиИспользования = ХранилищаЗначений.СвязиФункциональныхОпций.Получить();
		Если ТипЗнч(НастройкиИспользования) = Тип("НастройкиКомпоновкиДанных") Тогда
			КомпоновщикНастроекИспользования.ЗагрузитьНастройки(НастройкиИспользования);
		КонецЕсли;
		
		СтатьяИспользуется = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ИспользованиеСтатьиПоФункциональнымОпциям(
			Объект, КомпоновщикНастроекИспользования);
		
		Если СтатьяИспользуется Тогда
			ПредставлениеОграниченияИспользования = НСтр("ru = 'Статья используется согласно настроек учета'");
		Иначе
			ПредставлениеОграниченияИспользования = НСтр("ru = 'Статья не используется согласно настроек учета'");
		КонецЕсли;
	Иначе
		ПредставлениеОграниченияИспользования = НСтр("ru = 'Статья используется всегда'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИсточникОбъектовНастройки) Тогда
		МетаданныеОбъектаНастройки = Метаданные.НайтиПоПолномуИмени(Объект.ИсточникОбъектовНастройки);
		ПредставлениеОбъектовНастройки = МетаданныеОбъектаНастройки.Синоним;
		
		ПланыВидовХарактеристик.СтатьиАктивовПассивов.ИнициализироватьКомпоновщикНастроекОбъектомНастройки(
			КомпоновщикНастроекОбъектовНастройки, Объект.ИсточникОбъектовНастройки,
			МетаданныеОбъектаНастройки, УникальныйИдентификатор);
		
		НастройкиОтбораОбъектовНастройки = ХранилищаЗначений.ОтборОбъектовНастройки.Получить();
		Если ТипЗнч(НастройкиОтбораОбъектовНастройки) = Тип("НастройкиКомпоновкиДанных") Тогда
			КомпоновщикНастроекОбъектовНастройки.ЗагрузитьНастройки(НастройкиОтбораОбъектовНастройки);
		КонецЕсли;
		
		Элементы.ГруппаОтборОбъектовНастройки.Заголовок = ПредставлениеОтбора(КомпоновщикНастроекОбъектовНастройки);
	Иначе
		ПредставлениеОбъектовНастройки = НСтр("ru = 'Настройка отражения данных выполняется для статьи в целом'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИсточникДетальныхНастроек) Тогда
		МетаданныеДетальныхНастроек = Метаданные.НайтиПоПолномуИмени(Объект.ИсточникДетальныхНастроек);
		ПредставлениеДетальныхНастроек = МетаданныеДетальныхНастроек.Синоним;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюЭлементовФормы()
	
	Если ЗначениеЗаполнено(Объект.Описание) Тогда
		Элементы.Описание.Видимость = Истина;
	Иначе
		Элементы.Описание.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СтраницаРазрезыНастройки.Видимость = Ложь;
	Элементы.СтраницаЗаполнениеСубконто.Видимость = Ложь;
	
	
	Если ЗначениеЗаполнено(Объект.ИсточникДанных) Тогда
		Элементы.ПредставлениеИсточникаДанных.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.ПредставлениеИсточникаДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		
		Элементы.ГруппаДоступныеПоляИсточникаДанных.Видимость = Истина;
		Элементы.ГруппаОтборДанных.Видимость = Истина;
		Элементы.ГруппаСоставРесурсов.Видимость = Истина;
		
		
		ЕстьРесурсыУправленческогоУчета = ОпределитьИспользованиеУчета("РесурсыУпр");
		Элементы.ГруппаРесурсыУпр.Видимость = ЕстьРесурсыУправленческогоУчета;
		Элементы.НадписьРесурсыУпрОтсутствуют.Видимость = НЕ ЕстьРесурсыУправленческогоУчета;
		
		ЕстьРесурсыРегламентированногоУчета = ОпределитьИспользованиеУчета("РесурсыРегл");
		Элементы.ГруппаРесурсыРегл.Видимость = ЕстьРесурсыРегламентированногоУчета;
		Элементы.НадписьРесурсыРеглОтсутствуют.Видимость = НЕ ЕстьРесурсыРегламентированногоУчета;
		
		Элементы.НадписьРесурсыВал.Видимость = ВалютныйУчет;
		Элементы.ГруппаРесурсыВал.Видимость = ВалютныйУчет;
		
		Элементы.НадписьРесурсыКоличество.Видимость = КоличественныйУчет;
		Элементы.ГруппаРесурсыКоличество.Видимость = КоличественныйУчет;
	Иначе
		Элементы.ПредставлениеИсточникаДанных.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.ПредставлениеИсточникаДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		
		Элементы.ГруппаДоступныеПоляИсточникаДанных.Видимость = Ложь;
		Элементы.ГруппаОтборДанных.Видимость = Ложь;
		Элементы.ГруппаСоставРесурсов.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ФункциональныеОпции.Количество() > 0 Тогда
		Элементы.НастройкиИспользованияОтбор.Видимость = Истина;
		Элементы.НастройкиИспользованияОтборВидСравнения.Видимость = Ложь;
		Элементы.НастройкиИспользованияОтборИспользование.Видимость = Ложь;
	Иначе
		Элементы.НастройкиИспользованияОтбор.Видимость = Ложь;
	КонецЕсли;
	
	Если Элементы.СтраницаРазрезыНастройки.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.ИсточникОбъектовНастройки) Тогда
			Элементы.ПредставлениеОбъектовНастройки.Вид = ВидПоляФормы.ПолеВвода;
			Элементы.ПредставлениеОбъектовНастройки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
			Элементы.ПредставлениеОбъектовНастройки.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			Элементы.ОткрытьОбъектыНастройки.Видимость = Истина;
			Элементы.ГруппаОтборОбъектовНастройки.Видимость = Истина;
		Иначе
			Элементы.ПредставлениеОбъектовНастройки.Вид = ВидПоляФормы.ПолеНадписи;
			Элементы.ПредставлениеОбъектовНастройки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			Элементы.ПредставлениеОбъектовНастройки.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
			Элементы.ПредставлениеОбъектовНастройки.АвтоМаксимальнаяШирина = Ложь;
			Элементы.ОткрытьОбъектыНастройки.Видимость = Ложь;
			Элементы.ГруппаОтборОбъектовНастройки.Видимость = Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ИсточникДетальныхНастроек) Тогда
			Элементы.ГруппаДетальныеНастройки.Видимость = Истина;
		Иначе
			Элементы.ГруппаДетальныеНастройки.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницаЗаполнениеСубконто.Видимость Тогда
		Если Объект.ПутиКДаннымСубконто.Количество() > 0 Тогда
			Элементы.ПутиКДаннымСубконто.Видимость = Истина;
			Элементы.ПредставлениеЗаполненияСубконто.Видимость = Ложь;
		Иначе
			Элементы.ПутиКДаннымСубконто.Видимость = Ложь;
			Элементы.ПредставлениеЗаполненияСубконто.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРесурсов(ИмяКоллекцииРесурсов, ПараметрыОтраженияДвиженийИсточника, МетаданныеИсточника)
	
	РесурсыИсточника = МетаданныеИсточника.Ресурсы;
	РеквизитыИсточника = МетаданныеИсточника.Реквизиты;
	
	ТаблицаРесурсов = ЭтотОбъект[ИмяКоллекцииРесурсов]; // ДанныеФормыКоллекция
	СоставРесурсовПереопределен = Ложь;
	
	Для Каждого СтрокаРесурса Из Объект[ИмяКоллекцииРесурсов] Цикл
		СоставРесурсовПереопределен = Истина;
		Если СтрокаРесурса.Коэффициент <> 0 Тогда
			Ресурс = РесурсыИсточника.Найти(СтрокаРесурса.ИмяРесурса);
			Если Ресурс = Неопределено Тогда
				Ресурс = РеквизитыИсточника.Найти(СтрокаРесурса.ИмяРесурса);
			КонецЕсли;
			Если Ресурс <> Неопределено Тогда
				НоваяСтрока = ТаблицаРесурсов.Добавить();
				НоваяСтрока.ПредставлениеРесурса = Ресурс.Синоним;
				НоваяСтрока.Коэффициент = СтрокаРесурса.Коэффициент;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СоставРесурсовПереопределен Тогда
		Для Каждого ИмяРесурса Из ПараметрыОтраженияДвиженийИсточника[ИмяКоллекцииРесурсов] Цикл
			Ресурс = РесурсыИсточника.Найти(ИмяРесурса);
			Если Ресурс = Неопределено Тогда
				Ресурс = РеквизитыИсточника.Найти(ИмяРесурса);
			КонецЕсли;
			Если Ресурс <> Неопределено Тогда
				НоваяСтрока = ТаблицаРесурсов.Добавить();
				НоваяСтрока.ПредставлениеРесурса = Ресурс.Синоним;
				НоваяСтрока.Коэффициент = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОпределитьИспользованиеУчета(ИмяКоллекцииРесурсов)
	
	ТаблицаРесурсов = ЭтотОбъект[ИмяКоллекцииРесурсов]; // ДанныеФормыКоллекция
	
	Возврат ТаблицаРесурсов.Количество() > 0;
	
КонецФункции

&НаСервере
Функция ПредставлениеОтбора(КомпоновщикНастроек)
	
	ПредставлениеОтбора = Строка(КомпоновщикНастроек.Настройки.Отбор);
	
	Если ПустаяСтрока(ПредставлениеОтбора) Тогда
		ПредставлениеОтбора = НСтр("ru = 'Без дополнительного отбора'");
	КонецЕсли;
	
	Возврат ПредставлениеОтбора;
	
КонецФункции

&НаСервере
Функция ПредставлениеРесурсов(ИмяКоллекцииРесурсов)
	
	ТаблицаРесурсов = ЭтотОбъект[ИмяКоллекцииРесурсов]; // ДанныеФормыКоллекция
	КоличествоРесурсов = ТаблицаРесурсов.Количество();
	
	ПредставлениеРесурсов = "";
	РесурсовВПредставлении = 3;
	ИндексРесурса = 0;
	
	Пока ИндексРесурса < РесурсовВПредставлении И ИндексРесурса < КоличествоРесурсов Цикл
		СтрокаРесурса = ТаблицаРесурсов[ИндексРесурса];
		
		Разделитель = ?(ПредставлениеРесурсов = "", "", ", ");
		Разделитель = Разделитель + ?(СтрокаРесурса.Коэффициент < 0, "- ", "");
		
		ПредставлениеРесурсов = ПредставлениеРесурсов + Разделитель + СтрокаРесурса.ПредставлениеРесурса;
		ИндексРесурса = ИндексРесурса + 1;
	КонецЦикла;
	
	Если КоличествоРесурсов > ИндексРесурса Тогда
		Разделитель = НСтр("ru = 'и еще'");
		Разделитель = " " + Разделитель + " ";
		ПредставлениеРесурсов = ПредставлениеРесурсов + Разделитель + Строка(КоличествоРесурсов - ИндексРесурса);
	КонецЕсли;
	
	Возврат ПредставлениеРесурсов;
	
КонецФункции

#КонецОбласти