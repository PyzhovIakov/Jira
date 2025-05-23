
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Пользователь = Настройки.Получить("ОтборПользователь");
	Если ЗначениеЗаполнено(Пользователь) Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(РегистрСведенийСписок,
			 "Пользователь", Пользователь,
			 Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьНапоминания" Тогда
		Элементы.РегистрСведенийСписок.Обновить();
		ПодставитьТекущуюДатуВЭлементыОтбораУсловногоОформления();
	КонецЕсли;
КонецПроцедуры   

&НаКлиенте
Процедура ОтборПользовательПриИзменении(Элемент)
	Если ОтборПользователь.Пустая() Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(РегистрСведенийСписок, "Пользователь");
	Иначе	
		CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(РегистрСведенийСписок,
			 "Пользователь", ОтборПользователь,
			 Истина);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодставитьТекущуюДатуВЭлементыОтбораУсловногоОформления();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Очистить связанные отборы
	CRM_ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(РегистрСведенийСписок, "Пользователь");
	ОтборПользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРегистрСведенийСписок

&НаКлиенте 
Процедура РегистрСведенийСписокПослеУдаления(Элемент)
	Оповестить("ОбновитьНапоминания");
КонецПроцедуры

&НаКлиенте
Процедура РегистрСведенийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
		ДанныеСтроки = Элементы.РегистрСведенийСписок.ДанныеСтроки(Элементы.РегистрСведенийСписок.ТекущаяСтрока);
		КлючКопируемогоНапоминания = CRM_НапоминанияКлиент.СформироватьКлючЗаписиПоСтроке(ДанныеСтроки); 
		СтруктураНапоминания = СкопироватьНапоминание(КлючКопируемогоНапоминания); 		
		ПараметрыФормы = Новый Структура("Ключ,КопируемоеНапоминание", СтруктураНапоминания.КлючЗаписи,
			 СтруктураНапоминания.СтруктураКопируемогоНапоминания);
		Форма = ОткрытьФорму("РегистрСведений.CRM_Напоминания.ФормаЗаписи", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция СкопироватьНапоминание(КлючКопируемогоНапоминания)	
	МенеджерКопируемогоНапоминания = РегистрыСведений.CRM_Напоминания.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерКопируемогоНапоминания, КлючКопируемогоНапоминания);	
	МенеджерКопируемогоНапоминания.Прочитать();  
	Если МенеджерКопируемогоНапоминания.Выбран() Тогда
		КлючНовогоНапоминания = РегистрыСведений.CRM_Напоминания.СоздатьКлючЗаписи(КлючКопируемогоНапоминания);  
	КонецЕсли;	
	СтруктураКопируемогоНапоминания = Новый Структура("Важность, ДатаАктуальности, ДатаНачала,
		| ДатаОповещения, Предмет, Содержание,
		| Пользователь");
	ЗаполнитьЗначенияСвойств(СтруктураКопируемогоНапоминания, МенеджерКопируемогоНапоминания);
	СтруктураНапоминания = Новый Структура(""); 	
	СтруктураНапоминания.Вставить("КлючЗаписи", КлючКопируемогоНапоминания);	
	СтруктураНапоминания.Вставить("СтруктураКопируемогоНапоминания", СтруктураКопируемогоНапоминания);
	Возврат СтруктураНапоминания;  
КонецФункции

&НаСервере
Процедура ПодставитьТекущуюДатуВЭлементыОтбора(ЭлементыОтбора, ТекДата)
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ПодставитьТекущуюДатуВЭлементыОтбора(ЭлементОтбора.Элементы, ТекДата);
		Иначе
			Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СтандартнаяДатаНачала")
				 И ЭлементОтбора.ПравоеЗначение.Вариант = ВариантСтандартнойДатыНачала.ПроизвольнаяДата Тогда
				ЭлементОтбора.ПравоеЗначение.Дата = ТекДата;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПодставитьТекущуюДатуВЭлементыОтбораУсловногоОформления()
	// BSLLS:MissingCodeTryCatchEx-off
	Попытка
		ПодставитьТекущуюДатуВЭлементыОтбора(РегистрСведенийСписок.УсловноеОформление.Элементы[0].Отбор.Элементы,
		 ТекущаяДатаСеанса());
	
	Исключение КонецПопытки;
	// BSLLS:MissingCodeTryCatchEx-on
КонецПроцедуры

#КонецОбласти 
