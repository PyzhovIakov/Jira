
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиКлассификации = CRM_МоделиМашинногоОбученияКлиентСервер.НастройкиКлассификацииОбращений();
	ЗаполнитьЗначенияСвойств(НастройкиКлассификации, Параметры);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиКлассификации);
	
	РежимыРаботы = CRM_МоделиМашинногоОбученияКлиентСервер.РежимыРаботыПомощникаКлассификацииОбращений();
	СписокВыбора = Элементы.КлассификацияОбращенийРежимРаботы.СписокВыбора;
	Для Каждого КлючИЗначение Из РежимыРаботы Цикл
		НовыйЭлемент = СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлассификацияОбращенийРежимРаботыОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура МеткиКлассификацииПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.МеткиКлассификацииУстановитьПометкуУдаления.Доступность = Не ТекущиеДанные.Предопределенный;
	Элементы.МеткиКлассификацииНазначитьОсновной.Доступность = (Не ТекущиеДанные.Основная)
		И ЗначениеЗаполнено(ТекущиеДанные.ТипОбращения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьНастройки(Команда)
	
	НастройкиКлассификации = CRM_МоделиМашинногоОбученияКлиентСервер.НастройкиКлассификацииОбращений();
	ЗаполнитьЗначенияСвойств(НастройкиКлассификации, ЭтотОбъект);
	Закрыть(НастройкиКлассификации);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОсновной(Команда)
	
	ТекущиеДанные = Элементы.МеткиКлассификации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НазначитьМеткуОсновной(ТекущиеДанные.Ссылка, ТекущиеДанные.ТипОбращения);
	
	Элементы.МеткиКлассификации.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура НазначитьМеткуОсновной(МеткаСсылка, ТипОбращения)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МеткиКлассификации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_МеткиКлассификации КАК МеткиКлассификации
	|ГДЕ
	|	МеткиКлассификации.Ссылка <> &Ссылка
	|	И МеткиКлассификации.ТипОбращения = &ТипОбращения
	|	И МеткиКлассификации.Основная");
	
	Запрос.Параметры.Вставить("Ссылка", МеткаСсылка);
	Запрос.Параметры.Вставить("ТипОбращения", ТипОбращения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МеткаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		МеткаОбъект.Основная = Ложь;
		МеткаОбъект.Записать();
	КонецЦикла;
	
	МеткаОбъект = МеткаСсылка.ПолучитьОбъект();
	МеткаОбъект.Основная = Истина;
	МеткаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти