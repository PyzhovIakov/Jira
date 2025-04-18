
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсточникДействия = Параметры.Источник;
	
	СкидкиНаценкиСервер.ПриСозданииНаСервереИсточниковДействияСкидок(ЭтотОбъект, ИсточникДействия, Ложь);
	
	Элементы.УстановитьСтатусДействует.Видимость = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДействиеСкидокНаценок);
	Элементы.УстановитьСтатусНеДействует.Видимость = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДействиеСкидокНаценок);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

// Параметры:
// 	ИмяСобытия - Строка - Имя события
// 	Параметр - Структура - со свойствами:
// 		* Источник - Массив из СправочникСсылка.СкидкиНаценки - 
// 		* СкидкаНаценка - Массив из СправочникСсылка.УсловияПредоставленияСкидокНаценок -
// 	Источник - ФормаКлиентскогоПриложения - Источник события
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДействиеСкидокНаценок" И Параметр.Источник.Найти(ИсточникДействия) <> Неопределено Тогда
		ОбновитьДеревоСкидок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантОтображенияСкидокПриИзменении(Элемент)
	
	ОбновитьДеревоСкидок();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДействииСкидокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "НастроитьСкидки" Тогда
			
			ОткрытьФорму("Справочник.СкидкиНаценки.ФормаСписка", ,ЭтотОбъект);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСрезаПриИзменении(Элемент)
	
	ОбновитьДеревоСкидок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиСкидкиНаценки

&НаКлиенте
Процедура СкидкиНаценкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элементы.СкидкиНаценки.ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(Неопределено, Элементы.СкидкиНаценки.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_СписокПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПередРазворачиванием(Элемент, Строка, Отказ)
	
	СкидкиНаценкиКлиент.СохранитьПризнакРазвернутостиУзлаДереваВСписке(Строка, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПередСворачиванием(Элемент, Строка, Отказ)
	
	СкидкиНаценкиКлиент.СохранитьПризнакРазвернутостиУзлаДереваВСписке(Строка, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева, Ложь);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсторияДействияСкидкиНаценки(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуИсторииИзмененияСтатуса(ЭтотОбъект, ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"), 
		ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.НеДействует"),
		ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
		
	СкидкиНаценкиСервер.УстановитьУсловноеОформлениеФормыИсточникаДействияСкидок(УсловноеОформление, Элементы);

КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоСкидкиНаценки()
	
	СкидкиНаценкиСервер.ПостроитьДеревоСкидкиНаценкиВФорме(ЭтотОбъект, ИсточникДействия);
	ОбновитьИспользованиеСкидокНаценок(АктивизированнаяСкидкаНаценка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПриАктивизацииСтроки()
	
	ТекущиеДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	СкидкаНаценка = ?(ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа, Неопределено, ТекущиеДанные.Ссылка);
	
	Если СкидкаНаценка <> АктивизированнаяСкидкаНаценка Тогда
		ОбновитьИспользованиеСкидокНаценок(СкидкаНаценка);
		АктивизированнаяСкидкаНаценка = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИспользованиеСкидокНаценок(СкидкаНаценка)
	
	ИспользованиеСкидкиНаценки = СкидкиНаценкиСервер.ИспользованиеСкидкиНаценки(СкидкаНаценка, ДатаСреза);
	СкидкиНаценкиСервер.СформироватьИнформационнуюНадписьИспользованиеСкидокНаценок(ИнформацияОДействииСкидок,
	                                                                                ИспользованиеСкидкиНаценки,
	                                                                                "НастроитьСкидки");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСкидок()
	
	ПостроитьДеревоСкидкиНаценки();
	СкидкиНаценкиКлиент.РазвернутьДеревоСкидокРекурсивно(СкидкиНаценки, Элементы.СкидкиНаценки, РазвернутыеУзлыДерева);
	СкидкиНаценкиКлиент.ПозиционироватьсяНаЗначениеВДереве(АктивизированнаяСкидкаНаценка, СкидкиНаценки, Элементы.СкидкиНаценки, "Ссылка");
	
КонецПроцедуры


#КонецОбласти

