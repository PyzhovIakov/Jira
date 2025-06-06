
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЕстьЗаписи	= Параметры.ЕстьЗаписи;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Завершена", Истина));
	ОткрытьФорму("Документ.CRM_РассылкаЭлектронныхПисем.ФормаВыбора", ПараметрыФормы,
		 Элементы.Рассылка, , , , ,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Рассылка",						Рассылка);
	СтруктураВозврата.Вставить("Статусы",						СписокСтатусов);
	СтруктураВозврата.Вставить("НеЗаполнятьСПустымиТелефонами",	НеЗаполнятьСПустымиТелефонами);
	СтруктураВозврата.Вставить("ОчищатьТЧ",						Ложь);
	Если ЕстьЗаписи Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект, СтруктураВозврата);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Табличная часть уже содержит записи. 
                                                 |Очистить табличную часть?'; en = 'Tabular section already contains records. 
                                                 |Clear tabular section?'"), РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьЗавершение(Неопределено, СтруктураВозврата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(Ответ, СтруктураВозврата) Экспорт
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СтруктураВозврата.ОчищатьТЧ = Истина;
	КонецЕсли;
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокСтатусовПриИзменении(Элемент)
	ЕстьВыбранные = Ложь;
	Для каждого ЭлементСписка Из СписокСтатусов Цикл
		Если ЭлементСписка.Пометка Тогда
			ЕстьВыбранные = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Элементы.ФормаЗаполнить.Доступность = ЕстьВыбранные;
КонецПроцедуры

&НаКлиенте
Процедура РассылкаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Рассылка) Тогда
		СписокСтатусов.ЗагрузитьЗначения(ПолучитьСтатусыПисемРассылки(Рассылка));
	Иначе
		СписокСтатусов.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтатусыПисемРассылки(Рассылка)
	Возврат Документы.CRM_РассылкаЭлектронныхПисем.ПолучитьСтатусыПисемРассылки(Рассылка).ВыгрузитьЗначения();
КонецФункции

#КонецОбласти
