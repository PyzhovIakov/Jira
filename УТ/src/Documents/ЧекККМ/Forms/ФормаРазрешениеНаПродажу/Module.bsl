
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Номенклатура = Параметры.Номенклатура;
	
	Если Параметры.ПозицииЧекаКЗаполнению <> Неопределено Тогда
		ПозицииЧекаКЗаполнению.Загрузить(Параметры.ПозицииЧекаКЗаполнению.Выгрузить());
	КонецЕсли;
	
	ИдентификаторСтроки = Параметры.ИдентификаторСтроки;
	ТипДокумента = Параметры.ТипДокумента;
	НомерДокумента = Параметры.НомерДокумента;
	ДатаДокумента = Параметры.ДатаДокумента;
	
	Если Не ЗначениеЗаполнено(ТипДокумента) Тогда
		ТипДокумента = Перечисления.ТипыРазрешенийНаПродажу.Рецепт;
	КонецЕсли;
	
	Элементы.УказыватьРазрешенияДляДопНоменклатуры.Видимость =
		ЗначениеЗаполнено(Номенклатура) И ПозицииЧекаКЗаполнению.Количество() > 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставленияНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("Результат", Ложь);
	ДанныеДокумента.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
	
	Закрыть(ДанныеДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ТипДокумента) Тогда
		ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыРазрешенийНаПродажу.Рецепт");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаОчистка(Элемент, СтандартнаяОбработка)
	ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыРазрешенийНаПродажу.Рецепт");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ФлагДанныеДокументаОтпускаПрепаратаЗаполнены = Истина;
	
	Если Не ЗначениеЗаполнено(ТипДокумента) Тогда
		ФлагДанныеДокументаОтпускаПрепаратаЗаполнены = Ложь;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не указан тип документа отпуска препарата'"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерДокумента) Тогда
		ФлагДанныеДокументаОтпускаПрепаратаЗаполнены = Ложь;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не указан номер документа отпуска препарата'"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ФлагДанныеДокументаОтпускаПрепаратаЗаполнены = Ложь;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не указан дата документа отпуска препарата'"));
	КонецЕсли;
	
	Если Не ФлагДанныеДокументаОтпускаПрепаратаЗаполнены Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьДанныеДокументаОтпускаПрепарата();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьДанныеДокументаОтпускаПрепарата()
	
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("Результат", Истина);
	ДанныеДокумента.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
	ДанныеДокумента.Вставить("ТипДокумента", ТипДокумента);
	ДанныеДокумента.Вставить("НомерДокумента", НомерДокумента);
	ДанныеДокумента.Вставить("ДатаДокумента", ДатаДокумента);
	
	Если Не ЗначениеЗаполнено(Номенклатура)
		Или УказыватьРазрешенияДляДопНоменклатуры Тогда
		ДанныеДокумента.Вставить("ПозицииЧекаКЗаполнению", ПозицииЧекаКЗаполнению);
	КонецЕсли;
	
	Закрыть(ДанныеДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставленияНоменклатуры()
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
	
		МассивСтрок = Новый Массив;
		
		Ссылка = ПолучитьНавигационнуюСсылку(Номенклатура);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(СокрЛП(Номенклатура), , WebЦвета.Серый, , Ссылка));
		
		НоменклатураПредставление = Новый ФорматированнаяСтрока(МассивСтрок);
		
	ИначеЕсли ПозицииЧекаКЗаполнению.Количество() = 1 Тогда
		
		МассивСтрок = Новый Массив;
		
		Ссылка = ПолучитьНавигационнуюСсылку(ПозицииЧекаКЗаполнению[0].Номенклатура);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(СокрЛП(ПозицииЧекаКЗаполнению[0].Номенклатура), , WebЦвета.Серый, , Ссылка));
		
		НоменклатураПредставление = Новый ФорматированнаяСтрока(МассивСтрок);
		
	Иначе
		
		ЧислоИПредметИсчисления = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru='%1 позиций;%1 позиция;%1 позиции;%1 позиции;%1 позиций;%1 позиции'"),
			ПозицииЧекаКЗаполнению.Количество(),
			ВидЧисловогоЗначения.Количественное,
			"ЧДЦ=0");
		
		ОписаниеДопНоменклатуры = СтрШаблон(НСтр("ru = '%1 чека'"), ЧислоИПредметИсчисления);
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ОписаниеДопНоменклатуры, , WebЦвета.Серый));
		
		НоменклатураПредставление = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура) И ПозицииЧекаКЗаполнению.Количество() > 0 Тогда
		
		ЧислоИПредметИсчисления = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru='%1 позиций;%1 позиции;%1 позициях;%1 позициях;%1 позициях;%1 позициях'"),
			ПозицииЧекаКЗаполнению.Количество(),
			ВидЧисловогоЗначения.Количественное,
			"ЧДЦ=0");
		
		ОписаниеДопНоменклатуры = СтрШаблон(
			НСтр("ru = 'Указать данное разрешение на продажу еще в %1 чека'"),
			ЧислоИПредметИсчисления);
		
		Элементы.УказыватьРазрешенияДляДопНоменклатуры.Заголовок = ОписаниеДопНоменклатуры;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти