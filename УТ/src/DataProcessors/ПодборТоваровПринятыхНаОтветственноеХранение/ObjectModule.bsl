#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПодобрано");
	
	Отбор = Новый Структура("Пометка", Истина);
	ПомеченныеТовары = Товары.НайтиСтроки(Отбор);
	
	Для Каждого СтрокаТоваров Из ПомеченныеТовары Цикл
		
		Если СтрокаТоваров.КоличествоПодобрано = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Количество в накладную"" в строке номер %НомерСтроки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаТоваров.НомерСтроки);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТоваров.НомерСтроки, "КоличествоПодобрано");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Неопределено, Поле, "", Отказ);
		КонецЕсли;
		
		Если СтрокаТоваров.КоличествоОсталосьПодобрать < 0 Тогда
			ТекстСообщения = НСтр("ru = 'Количество в колонке ""Количество в накладную"" превышает значение колонки ""%КоличествоОстаток%"" в строке номер %НомерСтроки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаТоваров.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОстаток%", ?(РежимОстатков = "ВсеПринятые", НСтр("ru = 'Всего принято'"),
												?(РежимОстатков = "Выбывшие", НСтр("ru = 'Выбывшие'"),
												НСтр("ru = 'К списанию'"))));
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТоваров.НомерСтроки, "КоличествоПодобрано");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Неопределено, Поле, "", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли