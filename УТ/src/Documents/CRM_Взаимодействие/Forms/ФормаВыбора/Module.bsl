
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступом");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ОграничитьВыводКлиентскойБазы(ЭтотОбъект, "Список");
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураЗаполнения") Тогда
		СтруктураЗаполнения = Параметры.СтруктураЗаполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование И Не (СтруктураЗаполнения = Неопределено) Тогда
		
		Отказ = Истина;
		ВидВзаимодействия =
			CRM_МетодыМодулейМенеджеровДокументов.ПолучитьВидВзаимодействия(ПредопределенноеЗначение("Перечисление.CRM_ВидыСобытий.ТелефонныйЗвонок"));
		ПлановаяДатаНачала = ОбщегоНазначенияКлиент.ДатаСеанса();
		ПлановаяДатаЗавершение = ПлановаяДатаНачала + 1800;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Дата",                   ОбщегоНазначенияКлиент.ДатаСеанса());
		ДанныеЗаполнения.Вставить("ВидВзаимодействия",      ВидВзаимодействия);
		ДанныеЗаполнения.Вставить("ДокументОснование",      СтруктураЗаполнения.ДокументОснование);
		ДанныеЗаполнения.Вставить("Партнер",                СтруктураЗаполнения.Партнер);
		ДанныеЗаполнения.Вставить("КонтактноеЛицо",         СтруктураЗаполнения.КонтактноеЛицо);
		ДанныеЗаполнения.Вставить("ПлановаяДата",           ПлановаяДатаНачала);
		ДанныеЗаполнения.Вставить("ПлановаяДатаЗавершение", ПлановаяДатаЗавершение);
		ДанныеЗаполнения.Вставить("Тема",                   СтруктураЗаполнения.Тема);
		ДанныеЗаполнения.Вставить("Содержание",             СтруктураЗаполнения.Примечание);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ДанныеЗаполнения);
		ПараметрыОткрытия.Вставить("ОткрыватьФорму", Истина);
		
		ОткрытьФорму("Документ.CRM_Взаимодействие.Форма.ФормаДокумента", ПараметрыОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
