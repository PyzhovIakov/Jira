
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидыПриложений = ВидыПриложенийСервер.ВидыПриложенийКонфигурации();
	
	СписокВыбора = Элементы.ИмяВидаПриложения.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(ВидыПриложений.ВыгрузитьКолонку("Имя"));
	
КонецПроцедуры

#КонецОбласти
