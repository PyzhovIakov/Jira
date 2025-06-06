
#Область ПрограммныйИнтерфейс

// Выполняет обработку строк табличной части документа в соответствии с операциями, перечисленными в структуре действий.
//
// Параметры:
//	ТЧ - ДанныеФормыКоллекция - таблица товаров документа.
//	СтруктураДействий - Структура - структура с действиями, которые нужно произвести.
//	КэшированныеЗначения - Структура - кэшированные значения.
//
Процедура ОбработатьТЧ(ТЧ, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	ДействияЗаполнения = Новый Структура;
	ДействияОбработки = Новый Структура;
	Для Каждого Действие Из СтруктураДействий Цикл
		Если ОбработкаТабличнойЧастиСервер.ПоддерживаемыеДействияЗаполненияТЧ().Найти(Действие.Ключ) = Неопределено Тогда
			ДействияОбработки.Вставить(Действие.Ключ,Действие.Значение);
		Иначе
			ДействияЗаполнения.Вставить(Действие.Ключ,Действие.Значение);
		КонецЕсли;
		ДополнитьКэшированныеЗначения(ТЧ, Действие, КэшированныеЗначения);
	КонецЦикла;
	Если ДействияЗаполнения.Количество() > 0 Тогда
		НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(ТЧ,ДействияЗаполнения);
	КонецЕсли;
	Если ДействияОбработки.Количество() > 0 Тогда
		Для Каждого СтрТабл Из ТЧ Цикл
			Если НЕ СтрТабл.CRM_ЭтоРазделитель Тогда
				ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрТабл, ДействияОбработки, КэшированныеЗначения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьКэшированныеЗначения(ТЧ, Действие, КэшированныеЗначения)

	Если Действие.Ключ = "СкорректироватьСтавкуНДС" Тогда
		СтруктураДействия = Действие.Значение;
		ЗаполнитьТипыНоменклатурКэшированныеЗначения(ТЧ, СтруктураДействия, КэшированныеЗначения);
		ОбработкаТабличнойЧастиСервер.ЗаполнитьАктуальныеСтавкиНДСКэшированныеЗначения(
			СтруктураДействия, КэшированныеЗначения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТипыНоменклатурКэшированныеЗначения(ТЧ, СтруктураДействия, КэшированныеЗначения)
	
	Если СтруктураДействия.ВернутьМногооборотнуюТару И ТипЗнч(ТЧ) <> Тип("ДанныеФормыКоллекция") Тогда 
		
		ТипыНоменклатуры = КэшированныеЗначения.ТипыНоменклатуры;
		ТипыНоменклатуры.Очистить();
		
		СписокНоменклатуры = ТЧ.ВыгрузитьКолонку("Номенклатура");
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК НоменклатураСсылка,
		|	Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В(&СписокНоменклатуры)";
		
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТипыНоменклатуры.Вставить(Выборка.НоменклатураСсылка, Выборка.ТипНоменклатуры);	
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
