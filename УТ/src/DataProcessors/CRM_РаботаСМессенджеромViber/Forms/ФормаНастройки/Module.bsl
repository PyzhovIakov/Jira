
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Если ПроверитьЗаполнение() Тогда
		ПараметрыДоступа = Новый Структура;
		ПараметрыДоступа.Вставить("АдресПубликации", Объект.АдресПубликации);
		ПараметрыДоступа.Вставить("ЗапросПолученияСообщений", Объект.ЗапросПолученияСообщений);
		ПараметрыДоступа.Вставить("ЗапросОтправкиСообщений", Объект.ЗапросОтправкиСообщений);
		ПараметрыДоступа.Вставить("Порт", Объект.Порт);

		Закрыть(ПараметрыДоступа);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСправка(Команда)

	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("Viber"));

КонецПроцедуры

#КонецОбласти
