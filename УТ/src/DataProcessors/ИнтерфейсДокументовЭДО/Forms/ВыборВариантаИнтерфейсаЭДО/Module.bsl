#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВариантИнтерфейса = 1;
	ПодключитьОбработчикОжидания("АктивизироватьФорму", 0.2, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьВыборИнтерфейса(Команда)
	
	Результат = Новый Структура("ВыбранЛегкийВариантИнтерфейса", ВариантИнтерфейса = 1);
	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура АктивизироватьФорму()
	Активизировать();
КонецПроцедуры

#КонецОбласти
