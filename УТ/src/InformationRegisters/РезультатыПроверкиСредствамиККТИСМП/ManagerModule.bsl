#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеРезультатовПроверкиДляПроверкиИПодбора(СсылкаНаДокумент, ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие();
	
	ТекстЗапросаПлатежныхДокументов = Неопределено;
	ИнтеграцияИСМППереопределяемый.ПриОпределенииТекстаЗапросаПлатежныхДокументовПоДокументуПродажиИлиВозврата(
		СсылкаНаДокумент,
		ТекстЗапросаПлатежныхДокументов);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	&СсылкаНаДокумент КАК СсылкаНаДокумент
		|ПОМЕСТИТЬ СсылкиНаДокументы
		|
		|"
		+ ?(ЗначениеЗаполнено(ТекстЗапросаПлатежныхДокументов),
		"ОБЪЕДИНИТЬ ВСЕ
		|
		|" + ТекстЗапросаПлатежныхДокументов, "") +
		"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РезультатыПроверкиСредствамиККТИСМП.Документ,
		|	РезультатыПроверкиСредствамиККТИСМП.ШтрихкодУпаковки,
		|	РезультатыПроверкиСредствамиККТИСМП.ВидУпаковки,
		|	РезультатыПроверкиСредствамиККТИСМП.КодРезультатаПроверки,
		|	РезультатыПроверкиСредствамиККТИСМП.КодМаркировкиПроверен,
		|	РезультатыПроверкиСредствамиККТИСМП.КодОбработкиЗапроса,
		|	РезультатыПроверкиСредствамиККТИСМП.ПредставлениеРезультатаПроверки,
		|	РезультатыПроверкиСредствамиККТИСМП.РезультатПроверки,
		|	РезультатыПроверкиСредствамиККТИСМП.РезультаПроверкиОИСМ,
		|	РезультатыПроверкиСредствамиККТИСМП.СтатусТовара,
		|	РезультатыПроверкиСредствамиККТИСМП.ТребуетсяПолныйКодМаркировки
		|ИЗ
		|	РегистрСведений.РезультатыПроверкиСредствамиККТИСМП КАК РезультатыПроверкиСредствамиККТИСМП
		|ГДЕ
		|	РезультатыПроверкиСредствамиККТИСМП.Документ В
		|		(ВЫБРАТЬ
		|			СсылкиНаДокументы.СсылкаНаДокумент
		|		ИЗ
		|			СсылкиНаДокументы КАК СсылкиНаДокументы)
		|	И РезультатыПроверкиСредствамиККТИСМП.ВидПродукции = &ВидПродукции";
	
	Запрос.УстановитьПараметр("ВидПродукции",     ВидПродукции);
	Запрос.УстановитьПараметр("СсылкаНаДокумент", СсылкаНаДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	КешЗначенийШтрихкода   = Новый Соответствие();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ДанныеПроверки = ШтрихкодированиеОбщегоНазначенияИСМПКлиентСервер.ДанныеПредставленияРезультатовПроверкиСредствамиККТ(
			ВыборкаДетальныеЗаписи, Ложь, Ложь);
		
		Если Не ДанныеПроверки.ЕстьОшибки Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеШтрихкода = СокрЛП(ВыборкаДетальныеЗаписи.ШтрихкодУпаковки);
		ДанныеВКеше       = КешЗначенийШтрихкода[ЗначениеШтрихкода];
		Если ДанныеВКеше <> Неопределено Тогда
			МоментВремени      = ВыборкаДетальныеЗаписи.Документ.МоментВремени();
			МоментВремениВКеше = ДанныеВКеше.МоментВремени();
			СравнениеЗначений = Новый СравнениеЗначений();
			Если СравнениеЗначений.Сравнить(МоментВремени, МоментВремениВКеше) < 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ВозвращаемоеЗначение.Вставить(ЗначениеШтрихкода, ДанныеПроверки);
		КешЗначенийШтрихкода.Вставить(ЗначениеШтрихкода, ВыборкаДетальныеЗаписи.Документ);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли