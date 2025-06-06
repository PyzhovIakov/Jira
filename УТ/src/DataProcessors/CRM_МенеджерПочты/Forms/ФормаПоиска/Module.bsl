
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрПоиска = "Везде";
	ЗначениеПоиска = "";
		
	Если Параметры.Свойство("УчетнаяЗапись") Тогда
		УчетнаяЗапись = Параметры.УчетнаяЗапись;
		СписокПисем.Параметры.УстановитьЗначениеПараметра("УчетнаяЗапись", УчетнаяЗапись);
		Заголовок = "Поиск писем в почте " + УчетнаяЗапись.АдресЭлектроннойПочты;
	Иначе
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось определить учетную запись почты.");
		Возврат;
	КонецЕсли; 
	
	Если Параметры.Свойство("ПапкаПочты") Тогда
		ПапкаПочты = Параметры.ПапкаПочты;
		СписокПисем.Параметры.УстановитьЗначениеПараметра("ПапкаПочты", ПапкаПочты);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыборВариантаОтбора("ПростойПоиск");
	ОтобратьСписок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПапкаПочтыПриИзменении(Элемент)
	
	СписокПисем.Параметры.УстановитьЗначениеПараметра("ПапкаПочты", ПапкаПочты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаПочтыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РазрешитьВыборКорня", Истина);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", УчетнаяЗапись));
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборПапкиЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПапкиЭлектронныхПисем.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , ,
		 ОповещениеВыбора,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрПоискаПриИзменении(Элемент)
	ОтобратьСписок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПисьма(Команда)
	ОтобратьСписок();
КонецПроцедуры

&НаКлиенте
Процедура НайтиВСписке(Команда)

    ТекСтрока = Элементы.СписокПисем.ТекущаяСтрока;
	Если ТекСтрока = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрано письмо", , "СписокПисем");
		Возврат;
	КонецЕсли;
	РезультатВыбора = ПодготовитьРезультатВыбора(ТекСтрока);
    ОповеститьОВыборе(РезультатВыбора);
		
КонецПроцедуры

&НаКлиенте
Процедура ПростойПоиск(Команда)
	ВыборВариантаОтбора(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РасширенныйПоиск(Команда)
	ВыборВариантаОтбора(Команда.Имя);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Процедура - обработчик смены варианта отбора на панели отборов
//
// Параметры:
//  Форма	 - форма списка
//  Команда	 - команда формы
Процедура ВыборВариантаОтбора(ИмяКоманды)
	
	Если ИмяКоманды = "ПростойПоиск" Тогда
		ИмяСтраницы = "ГруппаПростойПоиск";
	ИначеЕсли ИмяКоманды = "РасширенныйПоиск" Тогда
		ИмяСтраницы = "ГруппаРасширенныйПоиск";
	Иначе
		Возврат;
	КонецЕсли;
	
	СтраницаКОтображению = Элементы.Найти(ИмяСтраницы);
	Если СтраницаКОтображению = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ПанельЗначенийОтбора.Видимость
		 И Элементы.ПанельЗначенийОтбора.ТекущаяСтраница = СтраницаКОтображению Тогда
		Элементы.ПанельЗначенийОтбора.Видимость = Ложь;
		Элементы[ИмяКоманды].ЦветФона = Новый Цвет;
	Иначе
		Элементы.ПанельЗначенийОтбора.Видимость = Истина;
		Элементы.ПанельЗначенийОтбора.ТекущаяСтраница = СтраницаКОтображению;
		Элементы.ПростойПоиск.ЦветФона = Новый Цвет;
		Элементы.РасширенныйПоиск.ЦветФона = Новый Цвет;
		Для каждого ТекСтраница Из Элементы.ПанельЗначенийОтбора.ПодчиненныеЭлементы Цикл
			ТекСтраница.Видимость = ТекСтраница = СтраницаКОтображению;			
		КонецЦикла; 
		
		Элементы[ИмяКоманды].ЦветФона = Новый Цвет(255, 215, 40);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьСписок()
	
	СписокПисем.Отбор.Элементы.Очистить();
	СписокПисем.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
	
	Если ПараметрПоиска = "Адрес" Тогда 
		ГруппаАдрес = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(СписокПисем.Отбор.Элементы,
			 "Адрес",
			 ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаАдрес, "Получатель", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаАдрес, "Отправитель", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
	ИначеЕсли ПараметрПоиска = "Тема"  Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПисем, "Тема",
			 ЗначениеПоиска, ВидСравненияКомпоновкиДанных.Содержит, ,
			 ЗначениеЗаполнено(ЗначениеПоиска));
	ИначеЕсли ПараметрПоиска = "Текст письма"  Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПисем, "Текст",
			 ЗначениеПоиска, ВидСравненияКомпоновкиДанных.Содержит, ,
			 ЗначениеЗаполнено(ЗначениеПоиска));
	ИначеЕсли ПараметрПоиска = "Везде" Тогда
		ГруппаВезде = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(СписокПисем.Отбор.Элементы,
			 "ПоискВезде",
			 ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаВезде, "Получатель", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаВезде, "Отправитель", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаВезде, "Тема", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаВезде, "Текст", ЗначениеПоиска,
			 ВидСравненияКомпоновкиДанных.Содержит,
			 ЗначениеЗаполнено(ЗначениеПоиска));
	Иначе 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПисем, "Ссылка",
			 ПредопределенноеЗначение("Документ.ЭлектронноеПисьмоВходящее.ПустаяСсылка"),
			 ВидСравненияКомпоновкиДанных.Равно);	
	КонецЕсли;
	
	Элементы.СписокПисем.Обновить();

КонецПроцедуры

&НаСервере
Функция ПодготовитьРезультатВыбора(ПисьмоСсылка)

	Возврат Новый Структура("Ссылка, Папка", ПисьмоСсылка, ПапкаПочты);

КонецФункции

&НаКлиенте
Процедура ВыборПапкиЗавершение(Папка, ДополнительныеПараметры) Экспорт
	Если Папка <> Неопределено Тогда
		ПапкаПочты = Папка;
		СписокПисем.Параметры.УстановитьЗначениеПараметра("ПапкаПочты", ПапкаПочты);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
