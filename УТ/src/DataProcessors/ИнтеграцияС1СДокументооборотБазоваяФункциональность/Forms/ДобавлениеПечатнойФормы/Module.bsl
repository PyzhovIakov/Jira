#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбъектИС", ОбъектИС);
	Параметры.Свойство("ИдентификаторОбъектаДО", ИдентификаторОбъектаДО);
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("РольФайлаID", РольФайлаID);
	
	ТипОбъектаИС = ОбъектИС.Метаданные().ПолноеИмя();
	ТипПечатнойФормы = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот",
		"ТипПечатнойФормы" + ТипОбъектаИС,
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ТипФайлаСохраняемойПечатнойФормыПоУмолчанию());
	
	// Захват и редактирование файлов.
	Элементы.ДобавитьИРедактировать.Видимость =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.4.9.1");
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьТаблицуМенеджеровПечатиОбъекта(
		ТипОбъектаИС,
		ПечатныеФормы);
	
	Если ПечатныеФормы.Количество() = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатныеФормыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьПечатнуюФорму(
		Элементы.ПечатныеФормы.ТекущиеДанные.ИмяКоманды,
		Элементы.ПечатныеФормы.ТекущиеДанные.ПредставлениеКоманды,
		Элементы.ПечатныеФормы.ТекущиеДанные.ДополнительныеПараметры,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	ТекущиеДанные = Элементы.ПечатныеФормы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДобавитьПечатнуюФорму(
			ТекущиеДанные.ИмяКоманды,
			ТекущиеДанные.ПредставлениеКоманды,
			ТекущиеДанные.ДополнительныеПараметры,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИРедактировать(Команда)
	
	ТекущиеДанные = Элементы.ПечатныеФормы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДобавитьПечатнуюФорму(
			ТекущиеДанные.ИмяКоманды,
			ТекущиеДанные.ПредставлениеКоманды,
			ТекущиеДанные.ДополнительныеПараметры,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьПечатнуюФорму(ИмяКоманды, ПредставлениеКоманды, ДополнительныеПараметры, НаЧтение)
	
	ОбъектДО = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		ИдентификаторОбъектаДО,
		ТипОбъектаДО);
	
	СозданныеФайлы =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПрисоединитьПечатнуюФормуОбъектаКДокументу(
			ОбъектИС,
			ОбъектДО,
			ИмяКоманды,
			ДополнительныеПараметры,
			ТипПечатнойФормы,
			РольФайлаID,
			ПредставлениеКоманды);
	Для Каждого СозданныйФайл Из СозданныеФайлы Цикл
		ТекущийФайл = СозданныйФайл.ТекущийФайл; // См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Создан файл ""%1""'"), ТекущийФайл.Наименование);
		ДействиеНадФайлом = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДействиеНадФайлом();
		ДействиеНадФайлом.СозданиеФайла = Истина;
		ДействиеНадФайлом.ИнформироватьФормуФайла = Истина;
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ИнформироватьОбИзмененииФайла(
			ДействиеНадФайлом,
			ТекущийФайл.Наименование,
			ТекущийФайл.ID,
			ИдентификаторОбъектаДО,
			ТекстСообщения,,
			УникальныйИдентификатор);
	КонецЦикла;
	Если ТипЗнч(ТекущийФайл) = Тип("Структура") Тогда
		ДействиеНадФайлом = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДействиеНадФайлом();
		ДействиеНадФайлом.СозданиеФайла = Истина;
		ДействиеНадФайлом.ИнформироватьФормуСпискаФайлов = Истина;
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ИнформироватьОбИзмененииФайла(
			ДействиеНадФайлом,
			ТекущийФайл.Наименование,
			ТекущийФайл.ID,
			ИдентификаторОбъектаДО,,,
			УникальныйИдентификатор);
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ИнтеграцияС1СДокументооборот",
		"ТипПечатнойФормы" + ТипОбъектаИС,
		ТипПечатнойФормы);
	
	Если Не НаЧтение Тогда
		Для Каждого СозданныйФайл Из СозданныеФайлы Цикл
			ТекущийФайл = СозданныйФайл.ТекущийФайл; // См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеФайла
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(
				ТекущийФайл.ID,
				ТекущийФайл.Наименование,
				ТекущийФайл.Расширение,
				УникальныйИдентификатор,
				НаЧтение,,
				ИдентификаторОбъектаДО);
		КонецЦикла;
	КонецЕсли;
	
	Закрыть(СозданныеФайлы);
	
КонецПроцедуры

#КонецОбласти