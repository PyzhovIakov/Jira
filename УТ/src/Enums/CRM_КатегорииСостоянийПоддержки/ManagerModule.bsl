
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(КВыполнению);
	ДанныеВыбора.Добавить(ВРаботе);
	ДанныеВыбора.Добавить(ВОжидании);
	ДанныеВыбора.Добавить(Выполнено);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
