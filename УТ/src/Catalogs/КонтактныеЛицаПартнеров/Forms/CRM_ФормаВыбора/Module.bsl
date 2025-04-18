
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступом");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ОграничитьВыводКлиентскойБазы(ЭтотОбъект, "Список");
	КонецЕсли;
	
	Если Параметры.Свойство("ПрограммноеОткрытие") И Параметры.ПрограммноеОткрытие Тогда
		Элементы.СписокВыбратьПрограммно.Видимость	= Истина;		
	Иначе
		Элементы.СписокВыбратьПрограммно.Видимость	= Ложь;
		Элементы.СписокВыбрать.Видимость			= Истина;
	КонецЕсли;
	Элементы.Партнер.Видимость = (Параметры.Свойство("ПодборСОтключениемФильтраВладельца") 
												И Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец", Партнер));
												
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Если НЕ Параметры.ПараметрыНового = Неопределено Тогда
			Отказ = Истина;
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("ПараметрыНового", Параметры.ПараметрыНового);
			CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
				"CRM_Статистика.Клиенты.КонтактноеЛицо.ДлительностьСценариев.ВремяОткрытияФормы", Истина);
			ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец") Тогда
			ЭлементОтбора.ПравоеЗначение = Партнер;
			ЭлементОтбора.Использование = ЗначениеЗаполнено(Партнер);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	РезультатВыбора = ПодготовитьРезультатВыбора();
	ОповеститьОВыборе(РезультатВыбора);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьРезультатВыбора()
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки = Неопределено ИЛИ ВыделенныеСтроки.Количество() <= 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивВыбора = Новый массив;
	
	Для Каждого ЭлементМассива Из ВыделенныеСтроки Цикл
		МассивВыбора.Добавить(ЭлементМассива);
	КонецЦикла;		
	
	Возврат МассивВыбора;
	
КонецФункции	

#КонецОбласти 
