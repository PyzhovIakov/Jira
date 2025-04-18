
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаОбработки = ?(
		Параметры.Свойство("ДатаОбработки"),
		Параметры.ДатаОбработки,
		ТекущаяДатаСеанса());
	
	ДатаОбработки			= НачалоМинуты(ДатаОбработки);
	ДатаОбработкиРезультат	= ДатаОбработки;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоЕдиницПереносаПриИзменении(Элемент)
	
	ДатаОбработкиРезультат = ПолучитьДатаПересчета();
	
КонецПроцедуры // КоличествоПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ЕстьУчетСекунд = Элементы.КоличествоСекунд.Доступность;
	
	Если Не ЗначениеЗаполнено(КоличествоМесяцев) И Не ЗначениеЗаполнено(КоличествоМинут)
		И Не ЗначениеЗаполнено(КоличествоНедель) И Не ЗначениеЗаполнено(КоличествоДней)
		И Не ЗначениеЗаполнено(КоличествоЧасов) И (ЕстьУчетСекунд И Не ЗначениеЗаполнено(КоличествоСекунд)) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			"en = 'At least one parameter of the date transfer time is not filled in.';
			|ru = 'Не заполнено хотя бы один параметр времени переноса даты.'");
		Возврат;
	КонецЕсли;
	
	Закрыть(ПолучитьДатаПересчета());
	
КонецПроцедуры // Применить()

&НаКлиенте
Процедура Сбросить(Команда)
	
	ДатаОбработкиРезультат = ДатаОбработки;
	
КонецПроцедуры // Сбросить()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьДатаПересчета()
	
	НоваяДатаОбработки = ДатаОбработки;
	
	КоличествоСекундВМинуте	= 60;
	КоличествоСекундВЧасе	= 3600;
	КоличествоСекундВДне	= КоличествоСекундВЧасе * 24;
	КоличествоСекундВНеделе	= КоличествоСекундВДне * 7;
	
	НоваяДатаОбработки = ДобавитьМесяц(НоваяДатаОбработки, КоличествоМесяцев);
	НоваяДатаОбработки = НоваяДатаОбработки + КоличествоНедель * КоличествоСекундВНеделе;
	НоваяДатаОбработки = НоваяДатаОбработки + КоличествоДней * КоличествоСекундВДне;
	НоваяДатаОбработки = НоваяДатаОбработки + КоличествоЧасов * КоличествоСекундВЧасе;
	НоваяДатаОбработки = НоваяДатаОбработки + КоличествоМинут * КоличествоСекундВМинуте;
	НоваяДатаОбработки = НоваяДатаОбработки + КоличествоСекунд;
	
	Возврат НоваяДатаОбработки;
	
КонецФункции // ПолучитьДатаПересчета()

#КонецОбласти
