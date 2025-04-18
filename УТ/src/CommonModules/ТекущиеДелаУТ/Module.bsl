
#Область ПрограммныйИнтерфейс

// Заполняет список обработчиков текущих дел.
//
// Параметры:
//  Обработчики - Массив - массив ссылок на модули менеджеров или общие модули, в которых
//                         определена процедура ПриЗаполненииСпискаТекущихДел.
//
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	
	Обработчики.Добавить(Справочники.СделкиСКлиентами);
	
	Обработчики.Добавить(Справочники.СоглашенияСКлиентами);
	
	// СоглашенияСПоставщиками (2ч)
	Обработчики.Добавить(Справочники.СоглашенияСПоставщиками);
	
	// ДоговорыСКлиентами (2ч)
	// ДоговорыСПоставщиками (2ч)
	Обработчики.Добавить(Справочники.ДоговорыКонтрагентов);

	// ЗаказыКлиентов (4ч)
	Обработчики.Добавить(Документы.ЗаказКлиента);
	
	// ЗаявкиНаВозвратТоваровОтКлиентов (4ч)
	Обработчики.Добавить(Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	
	// РаспоряженияНаПоступление (1т)
	Обработчики.Добавить(Обработки.УправлениеПоступлением);
	
	// РаспоряженияНаОтгрузку (1т)
	Обработчики.Добавить(Обработки.УправлениеОтгрузкой);
	
	// ЗаказыПоставщикам (4ч)
	Обработчики.Добавить(Документы.ЗаказПоставщику);
	
	// ЗаявкиНаОплату (2ч)
	Обработчики.Добавить(Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	
	// ЗаданияТорговымПредставителям (3ч)
	Обработчики.Добавить(Документы.ЗаданиеТорговомуПредставителю);
	
	// ДоверенностиНаПолучениеТоваров (4ч)
	Обработчики.Добавить(Документы.ДоверенностьВыданная);
	

	// ПеремещенияТоваров (2ч)
	Обработчики.Добавить(Документы.ПеремещениеТоваров);
	
	// ОформлениеСкладскихАктов (1ч)
	Обработчики.Добавить(Обработки.ЖурналСкладскихАктов);
	
	// ОтчетыКомиссионеров (1ч)
	Обработчики.Добавить(Обработки.ЖурналДокументовОтчетыКомиссионеров);
	
	// ОтчетыКомитентам (1ч)
	Обработчики.Добавить(Обработки.ЖурналДокументовОтчетыКомитентам);
	
	// ВнутренниеПотребления (3ч)
	Обработчики.Добавить(Документы.ВнутреннееПотребление);
	
	// ДокументыСборкиРазборки (3ч)
	Обработчики.Добавить(Документы.СборкаТоваров);
	
	// ДокументыПоступленияТоваровИУслуг (1ч)
	Обработчики.Добавить(Документы.ПриобретениеТоваровУслуг);
	
	// ДокументыРеализацииТоваровИУслуг (4ч)
	Обработчики.Добавить(Документы.РеализацияТоваровУслуг);
	
	// ПланыЗакупок (1ч)
	Обработчики.Добавить(Документы.ПланЗакупок);
	
	// ПланыОстатков (1ч)
	Обработчики.Добавить(Документы.ПланОстатков);
	
	// ПланыПродаж (1ч)
	Обработчики.Добавить(Документы.ПланПродаж);
	
	// ПланыВнутреннихПотреблений (1ч)
	Обработчики.Добавить(Документы.ПланВнутреннихПотреблений);
	
	Обработчики.Добавить(Документы.ПланПродажПоКатегориям);
	
	// ПланыСборкиРазборки (1ч)
	Обработчики.Добавить(Документы.ПланСборкиРазборки);
	

	
	
	// ДокументыПередачиТоваровХранителю (4ч)
	Обработчики.Добавить(Документы.ПередачаТоваровХранителю);
	
	
	// ДокументыПоступленияТоваров (1ч)
	Обработчики.Добавить(Документы.ПоступлениеТоваровНаСклад);

	// КоммерческиеПредложенияДокументы (2ч)
	Обработчики.Добавить(Документы.КоммерческоеПредложениеКлиенту);
	
КонецПроцедуры

#КонецОбласти
