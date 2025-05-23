////////////////////////////////////////////////////////////////////////////////
// Подсистема "Коммерческие предложения".
// ОбщийМодуль.КоммерческиеПредложения.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет полноту данных, необходимых для отправки Запроса коммерческих предложений исходящего.
//  Обязательные поля см. в макете ЗапросКоммерческихПредложений обработки ЗапросыКоммерческихПредложений.
//
// Параметры:
//  Документ - ОпределяемыйТип.ЗапросКоммерческихПредложенийПоставщиков - Ссылка на учетный документ, который необходимо проверить перед отправкой (обновлением).
// 
// Возвращаемое значение:
//  Булево - Истина - если все обязательные поля заполнены, Ложь - имеются незаполненные обязательные поля.
//           В случае наличия незаполненных обязательных полей, пользователю будет выведена соответствующая
//           информация в окне сообщений.
//
Функция ЗапросКоммерческихПредложенийПоставщиковГотовКОтправке(Знач Документ) Экспорт
	
	Отказ = Ложь;
	
	ДанныеЗапроса = КоммерческиеПредложенияСлужебный.ДанныеЗапросаКоммерческихПредложенийПоставщиков(
		Документ, Истина, Отказ);
	
	КоммерческиеПредложенияСлужебный.ВалидацияИзображенийЗапросаКоммерческихПредложенийПоставщиков(Документ, Отказ);
	
	Возврат Не Отказ И Не ДанныеЗапроса.Ошибки.Количество();
	
КонецФункции

// Возвращает состояние синхронизации учетного документа Запрос коммерческих предложений поставщиков.
//
// Параметры:
//  Документ - ОпределяемыйТип.ЗапросКоммерческихПредложенийПоставщиков - Ссылка на учетный отправляемый или обновляемый документ.
//
// Возвращаемое значение:
//  Структура - Ключи:
//              * Документ - ДокументСсылка - Соответствует входному параметру Документ.
//              * СостояниеСинхронизации - ПеречислениеСсылка.СостоянияСинхронизацииЗапросовКоммерческихПредложений -
//                                         Агрегированное состояние синхронизации прикладного документа.
//              * Детализация - Соответствие - Расширенная информация по каждому получателю, где:
//                ** Ключ - ОпределяемыйТип.КонтрагентБЭД, Строка - Ссылка на получателя документа. Если
//                          выполняется "открытая" публикация в Бизнес-сети, то значением ключа будет пустая строка.
//                ** Значение - Структура - Детализация состояния синхронизации по указанному получателю, где:
//                   *** СостояниеСинхронизации - ПеречислениеСсылка - Состояние синхронизации по получателю.
//                   *** ПредставлениеОшибки - Строка - Если ключ СостояниеСинхронизации содержит значение перечисления
//                                                      Ошибка, то содержит текстовое представление ошибки.
//
Функция СостояниеЗапросаКоммерческихПредложенийПоставщиков(Знач Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.Ссылка КАК Ссылка,
	|	ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.СостояниеСинхронизации КАК СостояниеСинхронизации,
	|	ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.ПредставлениеОшибки КАК ПредставлениеОшибки
	|ПОМЕСТИТЬ АктуальныеОснования
	|ИЗ
	|	Справочник.ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений КАК ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений
	|ГДЕ
	|	ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.ДокументВладелец = &ДокументВладелец
	|	И НЕ(ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.ДействиеСинхронизации = ЗНАЧЕНИЕ(Перечисление.ДействияСинхронизацииЗапросовКоммерческихПредложений.Удалить)
	|				И ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.СостояниеСинхронизации = ЗНАЧЕНИЕ(Перечисление.СостоянияСинхронизацииЗапросовКоммерческихПредложений.Выполнена))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	АктуальныеОснования.Ссылка КАК Основание,
	|	ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложенийПолучатели.Контрагент КАК Контрагент,
	|	АктуальныеОснования.СостояниеСинхронизации КАК СостояниеСинхронизации
	|ПОМЕСТИТЬ ДетализацияПоКонтрагентам
	|ИЗ
	|	АктуальныеОснования КАК АктуальныеОснования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложений.Получатели КАК ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложенийПолучатели
	|		ПО АктуальныеОснования.Ссылка = ОснованияЭлектронныхДокументовПоЗапросамКоммерческихПредложенийПолучатели.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктуальныеОснования.Ссылка КАК Основание,
	|	ДетализацияПоКонтрагентам.Контрагент КАК Контрагент,
	|	АктуальныеОснования.СостояниеСинхронизации КАК СостояниеСинхронизации,
	|	АктуальныеОснования.ПредставлениеОшибки КАК ПредставлениеОшибки
	|ИЗ
	|	АктуальныеОснования КАК АктуальныеОснования
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДетализацияПоКонтрагентам КАК ДетализацияПоКонтрагентам
	|		ПО АктуальныеОснования.Ссылка = ДетализацияПоКонтрагентам.Основание";
	
	Запрос.УстановитьПараметр("ДокументВладелец", Документ);
	
	Результат = Запрос.Выполнить();
	
	СостояниеДокумента =
		КоммерческиеПредложенияСлужебный.НовоеСостояниеЗапросаКоммерческихПредложенийПоставщиков(Документ);
	
	СостояниеТребуется   = Перечисления.СостоянияСинхронизацииЗапросовКоммерческихПредложений.Требуется;
	СостояниеВыполняется = Перечисления.СостоянияСинхронизацииЗапросовКоммерческихПредложений.Выполняется;
	
	ИмяМетода          = "КоммерческиеПредложенияСлужебный.ОтправитьЗапросКоммерческихПредложений";
	ЗаданиеВыполняется = КоммерческиеПредложенияСлужебный.ФоновоеЗаданиеПоДокументуВыполняется(Документ, ИмяМетода);
	
	Если Результат.Пустой() Тогда
		КоммерческиеПредложенияСлужебный.ДетализироватьСостояниеЗапросаКоммерческихПредложенийПоставщиков(СостояниеДокумента,
			"", СостояниеТребуется);
	Иначе
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СостояниеСинхронизации = ?(ЗаданиеВыполняется, СостояниеВыполняется, Выборка.СостояниеСинхронизации);
			
			Если ЗначениеЗаполнено(Выборка.Контрагент) Тогда
				КоммерческиеПредложенияСлужебный.ДетализироватьСостояниеЗапросаКоммерческихПредложенийПоставщиков(СостояниеДокумента,
					Выборка.Контрагент, СостояниеСинхронизации, Выборка.ПредставлениеОшибки);
			Иначе
				КоммерческиеПредложенияСлужебный.ДетализироватьСостояниеЗапросаКоммерческихПредложенийПоставщиков(СостояниеДокумента,
					"", СостояниеСинхронизации, Выборка.ПредставлениеОшибки);
			КонецЕсли;
			
		КонецЦикла;
		
		КоммерческиеПредложенияСлужебный.ОпределитьСостояниеЗапросаКоммерческихПредложенийПоставщиков(СостояниеДокумента);
		
	КонецЕсли;
	
	Возврат СостояниеДокумента;
	
КонецФункции

#КонецОбласти
