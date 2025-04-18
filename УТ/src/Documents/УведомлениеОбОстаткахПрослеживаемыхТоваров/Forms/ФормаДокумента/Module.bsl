#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ.

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ЭтоУправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	Элементы.ГруппаПанельОтправки.Видимость = НЕ ЭтоУправлениеТорговлей;
	Элементы.Отправка.Видимость = НЕ ЭтоУправлениеТорговлей;
	Элементы.ПрослеживаемыеТоварыВСоставе.Видимость = НЕ ЭтоУправлениеТорговлей;
	Элементы.СтраницаОсновныеСредства.Видимость = НЕ ЭтоУправлениеТорговлей;
	Элементы.ГруппаТМЦВЭксплуатации.Видимость = НЕ ЭтоУправлениеТорговлей;
	
	УстановитьДоступностьКомандБуфераОбмена();
	
	УстановитьТекстПервичногоУведомления();

	Если Параметры.Свойство("ПервичныйДокумент") Тогда
		ЗаполнитьДанныеПервичногоДокумента(Параметры);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПринудительноЗакрытьФорму = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаВыбора" Тогда
		Объект.ДокументУведомлениеОбОстатках = ВыбранноеЗначение;	 
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаПараметровУведомлений" Тогда 
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение,,"Продавцы");
		
		Объект.Продавцы.Очистить();
		
		Для каждого ТекущаяСтрока Из ВыбранноеЗначение.Продавцы Цикл
			
			НоваяСтрока = Объект.Продавцы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
			
		КонецЦикла;
	
	КонецЕсли;
	
	
	ЭтотОбъект.Модифицированность = Истина;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
		Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПрослеживаемостьБРУ.СохранитьСтатусОтправки(ЭтотОбъект);
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_ОприходованиеПрослеживаемыхТоваров", ПараметрыЗаписи, Объект.Ссылка);
	
	СобытияФормКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СобытияФормКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект,
													НавигационнаяСсылкаФорматированнойСтроки,
													СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РНПТПриИзменении(Элемент)

	Для Каждого Строка Из Объект.ВидыЗапасов Цикл
		Строка.РНПТ = Неопределено;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	КодТНВЭДПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КодТНВЭДПриИзмененииНаСервере()
	ПриИзмененииДанныхУведомления();
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	ПриИзмененииДанныхУведомления();
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДанныхУведомления()
	
	Объект.ВидыЗапасов.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" не заполнено'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "Объект.Организация", "", Отказ);
	КонецЕсли;
	
	Если Не Отказ
		И Объект.ВидыЗапасов.Количество() > 0 Тогда
		
		ОписаниеОповещения	= Новый ОписаниеОповещения("ЗаполнитьПоОстаткамЗавершение", ЭтотОбъект);
		ТекстВопроса		=  НСтр("ru = 'Табличная часть будет очищена и заполнена прослеживаемыми импортными товарами, которые нужно оприходовать по РНПТ. Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Возврат;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		ЗаполнитьПоОстаткамСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если Поле.Имя = "ТоварыНомерГТД" Тогда
		ПоказатьЗначение(,ТекущаяСтрока.НомерГТД);
	ИначеЕсли Поле.Имя = "ТоварыАналитикаУчетаНоменклатуры" Тогда
		Номенклатура = ИнтеграцияИСВызовСервера.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.АналитикаУчетаНоменклатуры,"Номенклатура");
		ПоказатьЗначение(,Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоОстаткамСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	ТекущаяСтрока.КоличествоПоРНПТ = ТекущаяСтрока.Количество;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомандаВыгрузитьУведомлениеВXML(Команда)
	
	ВыгрузитьУведомлениеОбОстатках();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура ПодборТМЦ(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПараметрыФормы.Вставить("Подразделение", ТекущаяСтрока.Подразделение);
	КонецЕсли;
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ЗаполнитьПодчиненныеСвойстваПоСтатистике("Организация");
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
		
КонецПроцедуры

#КонецОбласти

#Область РаботаСБуферомОбмена

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	МассивЭлементов.Добавить("ТоварыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
																	МассивЭлементов,
																	"Доступность",
																	РаботаСТабличнымиЧастями.ЕстьСтрокиВБуфереОбмена());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	МассивЭлементов.Добавить("ТоварыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение)
	
	ЗапасыСервер.ОбработатьВводВидовЗапасовВручную(ВыбранноеЗначение, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьВидимостьКорректировкаУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеСвойстваПоСтатистике(ИмяРеквизитаРодителя)
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьПодчиненныеРеквизитыОбъекта(Объект, ИмяРеквизитаРодителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ПересчитатьРеквизитыУведомления();

КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваПриИзменении(Элемент)

	ПересчитатьРеквизитыУведомления();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьРеквизитыУведомления()
	
	Если Объект.ВидыЗапасов.Количество()> 0 Тогда
		
		ТаблицаКоличестваТоваров = Объект.ВидыЗапасов.Выгрузить(, "Количество, КоличествоПоРНПТ");
		ТаблицаКоличестваТоваров.Свернуть(, "Количество, КоличествоПоРНПТ");
		СтрокаТаблицыЗначений = ТаблицаКоличестваТоваров[0];
		Объект.Количество = СтрокаТаблицыЗначений.Количество;
		Объект.КоличествоПрослеживаемости = СтрокаТаблицыЗначений.КоличествоПоРНПТ;
		
	ИначеЕсли Объект.ОсновныеСредства.Количество()> 0 Тогда
		
		Объект.Количество = Объект.ОсновныеСредства.Количество();
		Объект.КоличествоПрослеживаемости = Объект.ОсновныеСредства.Итог("КоличествоПоРНПТ");
		
	ИначеЕсли Объект.ТМЦВЭксплуатации.Количество()> 0 Тогда
		
		ТаблицаКоличестваТМЦВЭксплуатации = Объект.ТМЦВЭксплуатации.Выгрузить(, "Количество, КоличествоПоРНПТ");
		ТаблицаКоличестваТМЦВЭксплуатации.Свернуть(, "Количество, КоличествоПоРНПТ");
		СтрокаТаблицыЗначений = ТаблицаКоличестваТМЦВЭксплуатации[0];
		Объект.Количество = СтрокаТаблицыЗначений.Количество;
		Объект.КоличествоПрослеживаемости = СтрокаТаблицыЗначений.КоличествоПоРНПТ;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТоварыКОформлению.ВидЗапасов					КАК ВидЗапасов,
	|	ТоварыКОформлению.НомерГТД						КАК НомерГТД,
	|	СУММА(ТоварыКОформлению.Количество)				КАК Количество
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.ВидЗапасов					КАК ВидЗапасов,
	|		ТоварыОрганизаций.НомерГТД						КАК НомерГТД,
	|		ТоварыОрганизаций.КоличествоОстаток				КАК Количество
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(&Период,
	|				Организация = &Организация) КАК ТоварыОрганизаций
	|	
	|	ГДЕ
	|		ТоварыОрганизаций.КоличествоОстаток > 0
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД, НЕОПРЕДЕЛЕНО) = &КодТНВЭД
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = &ЕдиницаИзмерения
	|		И НЕ ЕСТЬNULL(ТоварыОрганизаций.НомерГТД.ТипНомераГТД, ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.ПустаяСсылка)) В
	|				(ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТ),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|		РезервыТоваровОрганизаций.ВидЗапасов					КАК ВидЗапасов,
	|		РезервыТоваровОрганизаций.НомерГТД						КАК НомерГТД,
	|		РезервыТоваровОрганизаций.КоличествоОстаток				КАК Количество
	|	ИЗ
	|		РегистрНакопления.РезервыТоваровОрганизаций.Остатки(,
	|				Организация = &Организация) КАК РезервыТоваровОрганизаций
	|	
	|	ГДЕ
	|		РезервыТоваровОрганизаций.КоличествоОстаток > 0
	|		И ЕСТЬNULL(РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД, НЕОПРЕДЕЛЕНО) = &КодТНВЭД
	|		И ЕСТЬNULL(РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = &ЕдиницаИзмерения
	|		И НЕ ЕСТЬNULL(РезервыТоваровОрганизаций.НомерГТД.ТипНомераГТД, ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.ПустаяСсылка)) В
	|				(ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТ),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыОрганизаций.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизаций.ВидЗапасов					КАК ВидЗапасов,
	|		ТоварыОрганизаций.НомерГТД						КАК НомерГТД,
	|		ВЫБОР
	|			КОГДА ТоварыОрганизаций.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ТоварыОрганизаций.Количество
	|			ИНАЧЕ ТоварыОрганизаций.Количество
	|		КОНЕЦ											КАК Количество
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|	
	|	ГДЕ
	|		ТоварыОрганизаций.Активность
	|		И ТоварыОрганизаций.Регистратор = &Регистратор
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД.ПрослеживаемыйТовар, ЛОЖЬ)
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.КодТНВЭД, НЕОПРЕДЕЛЕНО) = &КодТНВЭД
	|		И ЕСТЬNULL(ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = &ЕдиницаИзмерения
	|	
	|	) КАК ТоварыКОформлению
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры,
	|	ТоварыКОформлению.ВидЗапасов,
	|	ТоварыКОформлению.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыКОформлению.Количество) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура							КАК Номенклатура,
	|	Аналитика.Характеристика						КАК Характеристика,
	|	Аналитика.Назначение							КАК Назначение,
	|	Аналитика.Серия									КАК Серия,
	|	ТоварыКОформлению.НомерГТД						КАК НомерГТД,
	|	ВЫБОР
	|		КОГДА ТоварыКОформлению.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ											КАК НомерГТДОтсутствует,
	|	Аналитика.ТипМестаХранения						КАК ТипМестаХранения,
	|	Аналитика.СкладскаяТерритория					КАК Склад,
	|	Аналитика.Подразделение							КАК Подразделение,
	|	Аналитика.Договор								КАК Договор,
	|	Аналитика.Партнер								КАК Хранитель,
	|	Аналитика.Контрагент							КАК Контрагент,
	|	ТоварыКОформлению.ВидЗапасов					КАК ВидЗапасов,
	|	ТоварыКОформлению.Количество					КАК Количество,
	|	ТоварыКОформлению.Количество					КАК КоличествоПоРНПТ
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТоварыКОформлению.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|	
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товары
	|		ПО Аналитика.Номенклатура = Товары.Ссылка
	|
	|ГДЕ
	|	ЕСТЬNULL(Товары.ПрослеживаемыйТовар, ЛОЖЬ) = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Аналитика.МестоХранения.Представление,
	|	Товары.Представление,
	|	Аналитика.Характеристика.Представление,
	|	Аналитика.Назначение.Представление,
	|	Аналитика.Серия.Представление,
	|	ТоварыКОформлению.НомерГТД.Представление";
	
	Запрос.УстановитьПараметр("Организация",	Объект.Организация);
	Запрос.УстановитьПараметр("Регистратор",	Объект.Ссылка);
	Запрос.УстановитьПараметр("КодТНВЭД",	Объект.КодТНВЭД);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения",	Объект.ЕдиницаИзмерения);
	Запрос.УстановитьПараметр("Период", НачалоМесяца(Константы.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров.Получить()));
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Объект.ВидыЗапасов.Загрузить(РезультатЗапроса.Выгрузить());

	ПересчитатьРеквизитыУведомления();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПервичногоУведомления()
	
	Если ЗначениеЗаполнено(Объект.ДокументУведомлениеОбОстатках) Тогда
		СтрокаПервичноеУведомление =  Объект.ДокументУведомлениеОбОстатках;
	Иначе
		СтрокаПервичноеУведомление = НСтр("ru = '<Отсутствует>'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПервичногоДокумента(Параметры)
	
	Объект.ДатаПервичногоДокумента			= Параметры.ДатаПервичногоДокумента;
	Объект.НомерПервичногоДокумента			= Параметры.НомерПервичногоДокумента;
	Объект.НаименованиеПервичногоДокумента	= Параметры.НаименованиеПервичногоДокумента;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументУведомлениеОбОстаткахНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
		
	ОткрытьФорму(
		"Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаВыбора"
		,,,,,, Новый ОписаниеОповещения("ДокументУведомлениеОбОстаткахНажатиеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ДокументУведомлениеОбОстаткахНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ДокументУведомлениеОбОстатках = Результат;
	КонецЕсли;
	УстановитьТекстПервичногоУведомления();

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПараметрыНажатие(Элемент)
	
	Форма = ЭтотОбъект;
	
	Если НЕ Форма.ТолькоПросмотр Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТолькоПросмотр",          Форма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ИННДоРеорганизации",      Объект.ИННДоРеорганизации);
	ПараметрыФормы.Вставить("КППДоРеорганизации",      Объект.КППДоРеорганизации);
	ПараметрыФормы.Вставить("ФормаОткрытаИзКорректировочногоУведомления",  Объект.КорректировочноеУведомление);
	ПараметрыФормы.Вставить("ПризнакУведомления",      Объект.ПризнакУведомления);
	ПараметрыФормы.Вставить("КодФормыРеорганизации",   Объект.КодФормыРеорганизации);
	ПараметрыФормы.Вставить("НаименованиеПервичногоДокумента", Объект.НаименованиеПервичногоДокумента);
	ПараметрыФормы.Вставить("ДатаПервичногоДокумента", Объект.ДатаПервичногоДокумента);
	ПараметрыФормы.Вставить("НомерПервичногоДокумента", Объект.НомерПервичногоДокумента);
	ПараметрыФормы.Вставить("КодТНВЭД", Объект.КодТНВЭД);
	ПараметрыФормы.Вставить("КодОКПД2", Объект.КодОКПД2);
	ПараметрыФормы.Вставить("ЕдиницаИзмерения", Объект.ЕдиницаИзмерения);
	ПараметрыФормы.Вставить("ЕдиницаПрослеживаемости", Объект.ЕдиницаПрослеживаемости);
	ПараметрыФормы.Вставить("Количество", Объект.Количество);
	ПараметрыФормы.Вставить("КоличествоПрослеживаемости", Объект.КоличествоПрослеживаемости);
	ПараметрыФормы.Вставить("Сумма", Объект.Сумма);
	ПараметрыФормы.Вставить("ДатаДокумента", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	
	ПараметрыФормы.Вставить("Продавцы", Объект.Продавцы);
	ПараметрыФормы.Вставить("ВидыЗапасов", Объект.ВидыЗапасов);
	
	ОткрытьФорму(
		"Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаПараметровУведомлений",
		ПараметрыФормы, 
		Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура КорректировочноеУведомлениеПриИзменении(Элемент)
	
	УстановитьВидимостьКорректировкаУведомления();

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКорректировкаУведомления()
		
	Элементы.Корректировка.Видимость 		= Объект.КорректировочноеУведомление;
	Элементы.ДанныеКорректировки.Видимость	= Объект.КорректировочноеУведомление;
	Элементы.ГруппаТовары.Видимость			= НЕ Объект.КорректировочноеУведомление;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьУведомлениеОбОстатках()
	
	ПрослеживаемостьКлиент.ВыгрузитьУведомлениеПоПрослеживаемости(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура ПрослеживаемыеТоварыВСоставеПриИзменении(Элемент)

КонецПроцедуры


&НаКлиенте
Процедура СформироватьВедомость(Команда)
	
	Отбор = Новый Структура;
    Отбор.Вставить("Организация", Объект.Организация);  
	ПериодОтчета = Новый СтандартныйПериод();
	ПериодОтчета.ДатаНачала = НачалоДня(Объект.Дата);
	ПериодОтчета.ДатаОкончания = КонецДня(Объект.Дата);
 	Отбор.Вставить("Период", ПериодОтчета);	
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии, КлючВарианта", Отбор, Истина, "Основной");	
	УчетПрослеживаемыхТоваровКлиентЛокализация.СформироватьВедомость(ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
