&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ФормаБезОбработки") = Ложь И ЭтотОбъект.ЗапретитьИзменение = Ложь Тогда
		Элементы.СсылкаДОПОГ.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КлассификаторДОПОГЭПД");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

&НаКлиенте
Процедура СсылкаДОПОГПриИзменении(Элемент)


	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект);
	
КонецПроцедуры