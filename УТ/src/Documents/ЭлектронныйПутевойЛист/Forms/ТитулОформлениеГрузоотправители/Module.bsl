&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ФормаБезОбработки") = Ложь И ЭтотОбъект.ЗапретитьИзменение = Ложь Тогда
		Элементы.СсылкаГрузоотправитель.ОграничениеТипа = Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип;
	КонецЕсли;
	
	Элементы.ТитулОформлениеГрузоотправители.Шапка = Элементы.ТитулОформлениеГрузоотправители.ПодчиненныеЭлементы.Количество() > 1;
	
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
Процедура ТитулОформлениеГрузоотправителиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СсылкаГрузоотправительПриИзменении(Элемент)

	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект, Элементы.ТитулОформлениеГрузоотправители.ТекущиеДанные, "ТитулОформление");
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулОформлениеГрузоотправителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры