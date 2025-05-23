#Область СлужебныйПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

Процедура ОтразитьДокументВУчете(ОповещениеОкончанияОтраженияВУчете, ОписаниеПакета, ОбъектыУчета, Контрагент, СпособОбработки) Экспорт
	
	Если Не ИнтеграцияЭДОКлиент.ЕстьПодсистемаОтражениеВУчетеЭДО() Тогда
		Возврат;
	КонецЕсли;
	
	ОбщийМодульОтражениеВУчетеЭДОКлиент = ИнтеграцияЭДОКлиент.ОбщийМодульОтражениеВУчетеЭДОКлиент();
	
	ДанныеДокументооборота = ОбщийМодульОтражениеВУчетеЭДОКлиент.НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете();		
	ДанныеДокументооборота.ВидДокумента = ОписаниеПакета.Содержание.ВидДокумента;
	ДанныеДокументооборота.ТипДокумента = ОписаниеПакета.Содержание.ТипДокумента;
	ДанныеДокументооборота.ДанныеОсновногоФайла = ОписаниеПакета.ДанныеОсновногоФайла;
	ДанныеДокументооборота.ДанныеДополнительногоФайла = ОписаниеПакета.ДанныеФайлаДопДанных;
	ДанныеДокументооборота.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭДО.Входящий");
	ДанныеДокументооборота.Отправитель = Контрагент;
		
	ОбщийМодульОтражениеВУчетеЭДОКлиент.ОтразитьДанныеЭлектронногоДокумента(ОповещениеОкончанияОтраженияВУчете,
		ДанныеДокументооборота, ОбъектыУчета, СпособОбработки);	
	
КонецПроцедуры

Процедура ОткрытьДокументооборот(Документооборот, ТолькоПросмотр = Ложь) Экспорт
	ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(Документооборот, ТолькоПросмотр);
КонецПроцедуры

Процедура ПодписатьОтправитьДокументыПоЭДО(ОповещениеОЗавершении, Документообороты) Экспорт
	ПараметрыВыполнения = ИнтерфейсДокументовЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
	ПараметрыВыполнения.ОбъектыДействий.Документообороты = Документообороты;
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(ПараметрыВыполнения.НаборДействий,
		ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(ПараметрыВыполнения.НаборДействий,
		ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.ПодготовитьКОтправке"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(ПараметрыВыполнения.НаборДействий,
		ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Отправить"));
	ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(ОповещениеОЗавершении, ПараметрыВыполнения);
КонецПроцедуры

Процедура ПолучитьОтпечаткиСертификатов(ОповещениеОЗавершении) Экспорт
	КриптографияБЭДКлиент.ПолучитьОтпечаткиСертификатов(ОповещениеОЗавершении);
КонецПроцедуры

#КонецОбласти

#КонецОбласти