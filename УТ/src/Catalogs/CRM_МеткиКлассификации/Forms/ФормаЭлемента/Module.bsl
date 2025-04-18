
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТекущийОбъект.Предопределенный Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеВыбора = Справочники.CRM_ТипыОбращений.ПолучитьДанныеВыбора(Новый Структура);
	Для Каждого ЭлементДанных Из ДанныеВыбора Цикл
		НовыйЭлемент = Элементы.ТипОбращения.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементДанных);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
