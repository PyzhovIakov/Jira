
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ХранилищеЗначения") И (ТипЗнч(Параметры.ХранилищеЗначения) = Тип("ХранилищеЗначения")) Тогда
		Хранилище = Параметры.ХранилищеЗначения;
		ТЗ = Хранилище.Получить();
		Объект.СоответствиеКонтактнойИнформации.Загрузить(ТЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПриОткрытии".
//
Процедура ПриОткрытии(Отказ)
	Для Каждого СтрокаСоответствия Из Объект.СоответствиеКонтактнойИнформации Цикл
		Если СтрокаСоответствия.ВидКонтакта = "К" Тогда
			СтрокаСоответствия.ВидКонтакта = "_К";
		КонецЕсли;	
	КонецЦикла;	
	Элементы.СоответствиеКИ_КЛК.ОтборСтрок	= Новый ФиксированнаяСтруктура("ВидКонтакта", "КЛК");
	Элементы.СоответствиеКИ_К.ОтборСтрок	= Новый ФиксированнаяСтруктура("ВидКонтакта", "_К");
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПередЗакрытием".
//
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Для Каждого СтрокаСоответствия Из Объект.СоответствиеКонтактнойИнформации Цикл
		Если СтрокаСоответствия.ВидКонтакта = "_К" Тогда
			СтрокаСоответствия.ВидКонтакта = "К";
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствиеКИ_КЛК

&НаКлиенте
Процедура СоответствиеКИ_КЛКВидКИ1СНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборКИ1C(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеКИ_КВидКИ1СНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборКИ1C(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеКИ_КЛКВидКИOutlookНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборКИOutlook(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеКИ_КВидКИOutlookНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборКИOutlook(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыборКИ1C(Элемент)
	ТекущаяСтраница = Элементы.ПанельНастроекСинхронизации.ТекущаяСтраница;
	ИмяТекущейСтраницы = ТекущаяСтраница.Имя;
	Если (ИмяТекущейСтраницы = "КонтактныеЛицаПартнеров") Тогда
		ТекущиеДанные =  Элементы.СоответствиеКИ_КЛК.ТекущиеДанные;
	ИначеЕсли (ИмяТекущейСтраницы = "Партнеры") Тогда
		ТекущиеДанные =  Элементы.СоответствиеКИ_К.ТекущиеДанные;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Тип) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан тип контактной информации.';
			|en='The type of contact information is not specified.'"));
		Возврат;
	КонецЕсли;
    СписокРеквизитов1С = ПолучитьСписокПредставленияКИ1C(ИмяТекущейСтраницы, ТекущиеДанные.Тип);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКИ1CЗавершение", ЭтотОбъект,
		 Новый Структура("ИмяТекущейСтраницы, ТекущиеДанные", ИмяТекущейСтраницы,
		 ТекущиеДанные));
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокРеквизитов1С, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКИ1CЗавершение(Реквизит, ДополнительныеПараметры) Экспорт
	Если НЕ (Реквизит = Неопределено) Тогда
		ДополнительныеПараметры.ТекущиеДанные.ВидКИ1С = Реквизит.Значение;
		Если (ДополнительныеПараметры.ИмяТекущейСтраницы = "КонтактныеЛицаПартнеров") Тогда
			ДополнительныеПараметры.ТекущиеДанные.ВидКонтакта = "КЛК";
		ИначеЕсли (ДополнительныеПараметры.ИмяТекущейСтраницы = "Партнеры") Тогда
			ДополнительныеПараметры.ТекущиеДанные.ВидКонтакта = "_К";											
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборКИOutlook(Элемент)
	ТекущаяСтраница = Элементы.ПанельНастроекСинхронизации.ТекущаяСтраница;
	ИмяТекущейСтраницы = ТекущаяСтраница.Имя;
	Если (ИмяТекущейСтраницы = "КонтактныеЛицаПартнеров") Тогда
		ТекущиеДанные =  Элементы.СоответствиеКИ_КЛК.ТекущиеДанные;
	ИначеЕсли (ИмяТекущейСтраницы = "Партнеры") Тогда
		ТекущиеДанные =  Элементы.СоответствиеКИ_К.ТекущиеДанные;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Тип) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан тип контактной информации.';
			|en='The type of contact information is not specified.'"));
		Возврат;
	КонецЕсли;
    СписокРеквизитовOutlook = ПолучитьСписокПредставленияКИOutlook(ИмяТекущейСтраницы, ТекущиеДанные.Тип);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКИOutlookЗавершение", ЭтотОбъект, ТекущиеДанные);
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокРеквизитовOutlook, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыборКИOutlookЗавершение(Реквизит, ТекущиеДанные) Экспорт
	Если НЕ (Реквизит = Неопределено) Тогда
		ТекущиеДанные.ВидКИOutlook 	  		 = Реквизит.Значение;
		ТекущиеДанные.ПредставлениеКИOutlook = Реквизит.Представление;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть(ВернутьСсылкуНаХранилищеТаблицыСоответствия());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСписокПредставленияКИ1C(ТекущаяСтраницаИмя, ТипКИ)
	СписокРодителей = Новый СписокЗначений;
	Если (ТекущаяСтраницаИмя = "КонтактныеЛицаПартнеров") Тогда
		СписокРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров);
	ИначеЕсли (ТекущаяСтраницаИмя = "Партнеры") Тогда
		СписокРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.СправочникПартнеры);
		СписокРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.CRM_СправочникПартнерыКомпания);
		СписокРодителей.Добавить(Справочники.ВидыКонтактнойИнформации.CRM_СправочникПартнерыЧастноеЛицо);
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Тип",				ТипКИ);
	Запрос.УстановитьПараметр("СписокРодителей",	СписокРодителей);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыКонтактнойИнформации.Ссылка КАК ВидКИ
	               |ИЗ
	               |	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	               |ГДЕ
	               |	ВидыКонтактнойИнформации.Тип = &Тип
	               |	И ВидыКонтактнойИнформации.Родитель В(&СписокРодителей)";
	СписокРеквизитов1С = Новый СписокЗначений;
	СписокРеквизитов1С.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидКИ"));
	Возврат СписокРеквизитов1С;
КонецФункции

&НаСервере
Функция ПолучитьСписокПредставленияКИOutlook(ТекущаяСтраницаИмя, ТипКИ)
	Макет = Обработки.CRM_ОбменСMSOutlook.ПолучитьМакет("ВидыКонтактнойИнформации");
	СписокРеквизитовOutlook = Новый СписокЗначений;
	Если (ТекущаяСтраницаИмя = "КонтактныеЛицаПартнеров") Тогда
		ВидКонтакта = "КЛК";
	ИначеЕсли (ТекущаяСтраницаИмя = "Партнеры") Тогда
		ВидКонтакта = "К";			
	КонецЕсли;
	Для НомСтр = 3 По Макет.ВысотаТаблицы Цикл
		Тип			           		= Макет.Область("R" + НомСтр + "C1").Текст;
		ВидКИOutlook 				= Макет.Область("R" + НомСтр + "C2").Текст; 
		ПредставлениеКИOutlook      = Макет.Область("R" + НомСтр + "C3").Текст;
		Если НЕ (ТипКИ = Перечисления.ТипыКонтактнойИнформации[Тип]) Тогда
			Продолжить;
		КонецЕсли;	
		МассивВКИ = СоответствиеКонтактнойИнформации.НайтиСтроки(Новый Структура("ВидКонтакта,
			|ВидКИOutlook", ВидКонтакта,
			 ВидКИOutlook));
		Если МассивВКИ.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;	
		СписокРеквизитовOutlook.Добавить(ВидКИOutlook, ПредставлениеКИOutlook);
	КонецЦикла;
	Возврат СписокРеквизитовOutlook;
КонецФункции

&НаСервере
Функция ВернутьСсылкуНаХранилищеТаблицыСоответствия()
	Возврат Новый ХранилищеЗначения(Объект.СоответствиеКонтактнойИнформации.Выгрузить());
КонецФункции

#КонецОбласти
