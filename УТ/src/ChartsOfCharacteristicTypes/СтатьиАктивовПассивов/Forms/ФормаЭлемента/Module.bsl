
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") И Параметры.ЗначенияЗаполнения.Свойство("АктивПассив") Тогда
			Объект.АктивПассив = Параметры.ЗначенияЗаполнения.АктивПассив;
		Иначе
			Объект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
		КонецЕсли;
		ПриЧтенииСозданииНаСервере();
	ИначеЕсли ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЭтоСтатьяУправленческогоБаланса(Объект) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Объект.Наименование + " (" + НСтр("ru = 'Статья управленческого баланса'") + ")";
	КонецЕсли;
	
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МассивТипов = Новый Массив();
	Для Каждого ЭлементСписка Из Аналитика Цикл
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивТипов, ЭлементСписка.Значение.Типы(), Истина);
	КонецЦикла;
	Если МассивТипов.Количество() > 0 Тогда
		ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
	
	Если АктивПассив = "Актив" Тогда
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
	ИначеЕсли АктивПассив = "АктивПассив" Тогда
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.АктивПассив;
	Иначе
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Пассив;
	КонецЕсли;
	
	Если ЭтоПользовательскаяСтатья Тогда
		Если АктивПассив = "Актив" Тогда
			ТекущийОбъект.Вид = Перечисления.ВидыСтатейАктивовПассивов.Актив;
		ИначеЕсли АктивПассив = "АктивПассив" Тогда
			ТекущийОбъект.Вид = Перечисления.ВидыСтатейАктивовПассивов.АктивПассив;
		Иначе
			ТекущийОбъект.Вид = Перечисления.ВидыСтатейАктивовПассивов.Пассив;
		КонецЕсли;
		
		Если ПустаяСтрока(ТекущийОбъект.ИсточникДанных) Тогда
			ТекущийОбъект.ИсточникДанных = Метаданные.РегистрыНакопления.ДвиженияПоПрочимАктивамПассивам.Имя;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийОбъект.СчетаУчетаВНастройкахПроводок = Булево(СчетаУчетаВНастройкахПроводок);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Аналитика.Количество() > 1 Тогда
		Если ЭтоПользовательскаяСтатья Тогда
			ТекстСообщения = НСтр("ru = 'Необходимо указать только один тип аналитики'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Аналитика",, Отказ); 
		Иначе
			ТипБезАналитики = Тип("ПеречислениеСсылка.СтатьиБезАналитики");
			НаименованиеТипаБезАналитики = "";
			
			Для Каждого ЭлементСписка Из Аналитика Цикл
				Если ЭлементСписка.Значение.СодержитТип(ТипБезАналитики) Тогда
					НаименованиеТипаБезАналитики = Метаданные.НайтиПоТипу(ТипБезАналитики).Синоним;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НЕ ПустаяСтрока(НаименованиеТипаБезАналитики) Тогда
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Аналитика ""%1"" не может использоваться совместно с другими типами аналитики'"),
					НаименованиеТипаБезАналитики);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Аналитика",, Отказ); 
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Аналитика.Количество() = 0 Тогда
		Если ЭтоПользовательскаяСтатья Тогда
			ПроверяемыеРеквизиты.Добавить("Аналитика");
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АктивПассивПриИзменении(Элемент)
	УправлениеВидимостьюЭлементовФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаПриИзменении(Элемент)
	
	Если ЭтоПользовательскаяСтатья Тогда
		Пока Аналитика.Количество() > 1 Цикл
			Аналитика.Удалить(0);
		КонецЦикла;
	КонецЕсли;
	
	УправлениеВидимостьюЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьОборотПриИзменении(Элемент)

	УправлениеВидимостьюЭлементовФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УказаниеСчетовУчетаВНастройкахПриИзменении(Элемент)
	УказаниеСчетовУчетаВНастройкахПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура УказаниеСчетовУчетаВНастройкахПриИзмененииНаСервере()
	
	ОпределитьДоступностьНастройкиСчетовУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивов(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
		|Переход к значениям прочих активов и пассивов возможен только после записи данных.
		|Данные будут записаны.'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗначенияПрочихАктивовПассивовЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	ЗначенияПрочихАктивовПассивовФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Записать() Тогда
		Возврат;
	КонецЕсли;

	ЗначенияПрочихАктивовПассивовФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовФрагмент()

	СтруктураОтбора = Новый Структура("Владелец", Объект.Ссылка);
	ПараметрыФормы = Новый структура("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.ПрочиеАктивыПассивы.ФормаСписка", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаУчета(Команда)
	
	Возврат; // не пустой обработчик
	
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьЗначенияРеквизитовФормы();
	ЗаполнитьСписокВыбораТиповЗначенийАналитики();
	ОпределитьДоступностьНастройкиСчетовУчета();
	УправлениеВидимостьюЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостьюЭлементовФормы(Форма)
	
	Форма.Элементы.ЗначенияПрочихАктивовПассивов.Видимость = 
		Форма.Аналитика.Количество() = 1
		И Форма.Аналитика[0].Значение.СодержитТип(Тип("СправочникСсылка.ПрочиеАктивыПассивы"));
	
	Форма.Элементы.СчетаУчетаВНастройкахПроводок.Видимость = Форма.ЭтоПользовательскаяСтатья;
	
	// Установить подсказки ввода
	Если Форма.АктивПассив = "Пассив" Тогда
		Форма.Элементы.ПредставлениеДебетаСтатьи.ПодсказкаВвода = НСтр("ru = 'Уменьшение'");
		Форма.Элементы.ПредставлениеКредитаСтатьи.ПодсказкаВвода = НСтр("ru = 'Увеличение'");
	Иначе
		Форма.Элементы.ПредставлениеДебетаСтатьи.ПодсказкаВвода = НСтр("ru = 'Увеличение'");
		Форма.Элементы.ПредставлениеКредитаСтатьи.ПодсказкаВвода = НСтр("ru = 'Уменьшение'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьНастройкиСчетовУчета()
	
	ВидимостьНастройкиСчетовУчета = Ложь;
	ДоступнаНастройкаСчетовРеглУчета = Ложь;
	ДоступнаНастройкаСчетовМеждународногоУчета = Ложь;
	
	
	Если НЕ ВидимостьНастройкиСчетовУчета Тогда
		Элементы.НастроитьСчетаУчета.Видимость = Ложь;
	ИначеЕсли НЕ (ДоступнаНастройкаСчетовРеглУчета ИЛИ ДоступнаНастройкаСчетовМеждународногоУчета) Тогда
		Элементы.НастроитьСчетаУчета.Видимость = Истина;
		Элементы.НастроитьСчетаУчета.Доступность = Ложь;
		Элементы.НастроитьСчетаУчета.Заголовок = НСтр("ru = 'Настройка счетов учета статьи в документах не требуется'");
	ИначеЕсли ДоступнаНастройкаСчетовРеглУчета И НЕ ДоступнаНастройкаСчетовМеждународногоУчета Тогда
		Элементы.НастроитьСчетаУчета.Видимость = Истина;
		Элементы.НастроитьСчетаУчета.Доступность = Истина;
		Элементы.НастроитьСчетаУчета.Заголовок = НСтр("ru = 'Настройка счета регл. учета статьи в документах по умолчанию'");
	Иначе
		Элементы.НастроитьСчетаУчета.Видимость = Истина;
		Элементы.НастроитьСчетаУчета.Доступность = Истина;
		Элементы.НастроитьСчетаУчета.Заголовок = НСтр("ru = 'Настройка счетов учета статьи в документах по умолчанию'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьСписокВыбораТиповЗначенийАналитики()
	
	Аналитика.Очистить();
	
	СписокВыбора = Элементы.Аналитика.СписокВыбора;
	СписокВыбора.Очистить();
	
	Для каждого Тип Из Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
			ЭлементСписка = СписокВыбора.Добавить(
				Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип)),
				ОбъектМетаданных.Представление());
			Если Объект.ТипЗначения.СодержитТип(Тип) Тогда
				ЭлементСписка.Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокВыбора.СортироватьПоПредставлению();
	
	ТипыВКонце = Новый Массив;
	ТипыВКонце.Добавить(Тип("СправочникСсылка.ПрочиеАктивыПассивы"));
	ТипыВКонце.Добавить(Тип("ПеречислениеСсылка.СтатьиБезАналитики"));
	
	Для каждого Тип Из ТипыВКонце Цикл
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип)));
		ИндесЭлемента = СписокВыбора.Индекс(ЭлементСписка);
		СписокВыбора.Сдвинуть(ЭлементСписка, СписокВыбора.Количество() - ИндесЭлемента - 1);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СписокВыбора.ЗаполнитьПометки(Ложь);
		ПоследнийЭлемент = СписокВыбора[СписокВыбора.Количество() - 1];
		ПоследнийЭлемент.Пометка = Истина;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		Если ЭлементСписка.Пометка Тогда
			ЗаполнитьЗначенияСвойств(Аналитика.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияРеквизитовФормы()
	
	Если Объект.АктивПассив = ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.Актив") Тогда
		АктивПассив = "Актив";
	ИначеЕсли Объект.АктивПассив = ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.АктивПассив") Тогда
		АктивПассив = "АктивПассив";
	Иначе
		АктивПассив = "Пассив";
	КонецЕсли;
	
	СчетаУчетаВНастройкахПроводок = Число(Объект.СчетаУчетаВНастройкахПроводок);
	
	ЭтоПользовательскаяСтатья = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЭтоПользовательскаяСтатья(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПолноеИмяФормы = "ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.РазблокированиеРеквизитов";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЭтоПользовательскаяСтатья", ЭтоПользовательскаяСтатья);
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

#КонецОбласти

#КонецОбласти
