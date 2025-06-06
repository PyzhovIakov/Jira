
////////////////////////////////////////////////////////////////////////////////
// CRM мероприятия сервер
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////
//  ПЕРИОДИЧЕСКИЕ МЕРОПРИЯТИЯ

// Функция возвращает результат запроса по событиям ряда.
//
// Параметры:
//  Ссылка						 - СправочникСсылка	 - Ряд событий.
//  СсылкаНаТекущееМероприятие	 - СправочникСсылка	 - Ссылка на текущее мероприятие.
//  ДатаНачала					 - Дата				 - Дата начала.
//  ДатаОкончания				 - Дата				 - Дата окончания.
//  ПолучатьИзмененныеВРяде		 - Булево			 - Флаг получения измененных в ряде.
//  ПолучатьНеПериодические		 - Булево			 - Флаг получения непериодических.
//  ПолучатьСПометкойНаУдаление	 - Булево			 - Флаг получения помеченных на удаление.
// 
// Возвращаемое значение:
//  РезультатЗапроса - Результат запроса по событиям ряда.
//
Функция ПолучитьРезультатЗапросаПоМероприятиямРяда(Ссылка,
	 СсылкаНаТекущееМероприятие = Неопределено, ДатаНачала = Неопределено,
		ДатаОкончания = Неопределено, ПолучатьИзмененныеВРяде = Ложь, ПолучатьНеПериодические = Ложь, ПолучатьСПометкойНаУдаление = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Мероприятие.Ссылка					КАК Мероприятие,
	|	Мероприятие.ПлановаяДата					КАК ДатаНачала,
	|	Мероприятие.ПлановаяДатаЗавершение	КАК ДатаОкончания,
	|	Мероприятие.ИзмененоВРяде			КАК ИзмененоВРяде,
	|	Мероприятие.ПометкаУдаления			КАК ПометкаУдаления
	|ИЗ
	|	Документ.CRM_Взаимодействие КАК Мероприятие
	|ГДЕ
	|	Мероприятие.РядСобытий = &РядСобытий
	|	" + ?(ПолучатьНеПериодические, "", "И Мероприятие.Периодическое") + "
	|	" + ?(ПолучатьИзмененныеВРяде, "", "И НЕ Мероприятие.ИзмененоВРяде") + "
	|	" + ?(ПолучатьСПометкойНаУдаление, "", "И НЕ Мероприятие.ПометкаУдаления") + "
	|	" + ?(СсылкаНаТекущееМероприятие = Неопределено, "", "И Мероприятие.Ссылка <> &СсылкаНаТекущееМероприятие") + "
	|	" + ?(ДатаНачала = Неопределено, "", "И Мероприятие.ПлановаяДата >= &ДатаНачала") + "
	|	" + ?(ДатаОкончания = Неопределено, "", "И Мероприятие.ПлановаяДатаЗавершение <= &ДатаОкончания") + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Мероприятие.Дата ВОЗР
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("РядСобытий", Ссылка);
	
	ПараметрыЗапроса = Запрос.НайтиПараметры();
	
	Если ПараметрыЗапроса.Найти("СсылкаНаТекущееМероприятие") <> Неопределено Тогда
		Запрос.УстановитьПараметр("СсылкаНаТекущееМероприятие", СсылкаНаТекущееМероприятие);
	КонецЕсли;
	
	Если ПараметрыЗапроса.Найти("ДатаНачала") <> Неопределено Тогда
		Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНачала));
	КонецЕсли;
	
	Если ПараметрыЗапроса.Найти("ДатаОкончания") <> Неопределено Тогда
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	КонецЕсли;
	
	Возврат Запрос.Выполнить();
	
КонецФункции // ПолучитьРезультатЗапросаПоМероприятиямРяда()

// Процедура производит групповое изменения событий ряда.
//
// Параметры:
//  МероприятиеИнициатор - ДокументСсылка - Мероприятие инициатор.
//  СпособИзмененияРяда	 - Строка	 - Вид действия над рядом событий.
//  ДатаНачала			 - Дата		 - Дата начала.
//  ДатаОкончания		 - Дата		 - Дата окончания.
//  АдресНастроек		 - Строка	 - Адрес настроек.
//
Процедура ИзменитьМероприятияРяда(МероприятиеИнициатор, Знач СпособИзмененияРяда,
	 Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено,
	 АдресНастроек) Экспорт
	
	Если СпособИзмененияРяда <> "ТолькоТекущее"
		И СпособИзмененияРяда <> "ДоКонцаРяда"
		И СпособИзмененияРяда <> "ВесьРяд"
		И СпособИзмененияРяда <> "УдалитьВсеСобытияРяда" Тогда
		ВызватьИсключение НСтр("ru='ИзменитьСобытияРяда() - недопустимое значение параметра <СпособИзмененияРяда>';en='Izmenitsobytiyaryada () - inadmissible value of parameter <СпособИзмененияРяда>'");
		Возврат;
	КонецЕсли;
	
	Если СпособИзмененияРяда = "ТолькоТекущее" Тогда
		// Сразу возврат, т.к. событие само себя исключило от ряда установив флаг ИзмененоВРяде.
		Возврат;
	КонецЕсли;
	
	РядСобытий = МероприятиеИнициатор.РядСобытий;
	
	Если НЕ ЗначениеЗаполнено(РядСобытий) Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособИзмененияРяда = "УдалитьВсеСобытияРяда" Тогда
		РезультатЗапросаПоСобытиямРяда	= ПолучитьРезультатЗапросаПоМероприятиямРяда(РядСобытий, , , , Ложь, Истина, Ложь);
		ВыборкаСобытийРяда				= РезультатЗапросаПоСобытиямРяда.Выбрать();
		
		Пока ВыборкаСобытийРяда.Следующий() Цикл
			СобытиеОбъект = ВыборкаСобытийРяда.Мероприятие.ПолучитьОбъект();
			СобытиеОбъект.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если СпособИзмененияРяда = "ВесьРяд" Тогда
		ДатаНачала		= РядСобытий.ДатаНачала;
		ДатаОкончания	= РядСобытий.ДатаОкончания;
	Иначе
		Если ДатаНачала = Неопределено Тогда
			ДатаНачала = РядСобытий.ДатаНачала;
		КонецЕсли;
		
		Если ДатаОкончания = Неопределено Тогда
			ДатаОкончания = РядСобытий.ДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ДатаНачала		= НачалоДня(ДатаНачала);
	ДатаОкончания	= НачалоДня(ДатаОкончания);
	
	Если ДатаОкончания <= ДатаНачала Или СпособИзмененияРяда = "ВесьРяд" Тогда
		РезультатЗапросаПоСобытиямРяда = ПолучитьРезультатЗапросаПоМероприятиямРяда(РядСобытий, ,
			 Мин(ДатаНачала, ДатаОкончания), , Истина,
			 Истина);
	Иначе
		РезультатЗапросаПоСобытиямРяда = ПолучитьРезультатЗапросаПоМероприятиямРяда(РядСобытий, ,
			 ДатаНачала, ДатаОкончания, Истина,
			 Истина);
	КонецЕсли;
	
	Расписание = Справочники.CRM_РядыСобытий.ПолучитьРасписание(РядСобытий);
	
	Если СпособИзмененияРяда = "ДоКонцаРяда" Тогда
		МассивДатРасписания = Справочники.CRM_РядыСобытий.ПолучитьМассивДатРасписания(Мин(ДатаНачала, ДатаОкончания),
			Макс(ДатаНачала, ДатаОкончания), РядСобытий, Расписание);
	Иначе
		МассивДатРасписания = Справочники.CRM_РядыСобытий.ПолучитьМассивДатРасписания(ДатаНачала,
			 ДатаОкончания, РядСобытий,
			 Расписание);
	КонецЕсли;
	
	ТаблицаСобытийРяда = РезультатЗапросаПоСобытиямРяда.Выгрузить();
	ТаблицаСобытийРяда.Колонки.Добавить("ДатаНачалаНачалоДня",			Новый ОписаниеТипов("Дата", , ,
		 Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаСобытийРяда.Колонки.Добавить("ПометкаСобытиеИспользовано",	Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтрокаТаблицы Из ТаблицаСобытийРяда Цикл
		СтрокаТаблицы.ДатаНачалаНачалоДня = НачалоДня(СтрокаТаблицы.ДатаНачала);
	КонецЦикла;
	
	Для Каждого ДатаВремяРасписания Из МассивДатРасписания Цикл
		ДатаПоРасписанию	= НачалоДня(ДатаВремяРасписания);
		СобытиеОбъект		= Неопределено;
		ЭтоНовыйОбъект		= Ложь;
		НайденныеСтроки = ТаблицаСобытийРяда.НайтиСтроки(Новый Структура("ДатаНачалаНачалоДня,
			|ПометкаСобытиеИспользовано", ДатаПоРасписанию,
			 Ложь));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаСобытия = НайденныеСтроки[0];
			СтрокаСобытия.ПометкаСобытиеИспользовано = Истина;
			
			Если (СтрокаСобытия.Мероприятие = МероприятиеИнициатор Или СтрокаСобытия.ИзмененоВРяде)
				 И НЕ СтрокаСобытия.ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
			
			СобытиеОбъект = СтрокаСобытия.Мероприятие.ПолучитьОбъект();
		КонецЕсли;
		
		Если СобытиеОбъект = Неопределено Тогда
			СобытиеОбъект	= Документы.CRM_Взаимодействие.СоздатьДокумент();
			ЭтоНовыйОбъект	= Истина;
		КонецЕсли;
		
		ЗаполнитьОбъектМероприятияПоМероприятию(СобытиеОбъект, МероприятиеИнициатор, ДатаПоРасписанию, ЭтоНовыйОбъект);
		СобытиеОбъект.Записать();
	КонецЦикла;
	
	ПараметрыПоиска = Новый Структура("ПометкаСобытиеИспользовано,ИзмененоВРяде,ПометкаУдаления", Ложь, Ложь, Ложь);
	НайденныеСтроки = ТаблицаСобытийРяда.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		СобытиеОбъект =  НайденнаяСтрока.Мероприятие.ПолучитьОбъект();
		СобытиеОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
КонецПроцедуры // ИзменитьСобытияРяда()

// Функция используется для перемещения мероприятий из ряда событий на выбранную дату с сохранением порядка следования событий.
//
// Параметры:
//  ОбрабатываемыеЭлементы  - Структура - Обрабатываемые элементы.
//  ВыбраннаяДата           - Дата      - Дата, на которую переносятся обрабатываемые элементы.
//  СпособИзмененияРяда     - Строка    - Способ изменения ряда "ТолькоТекущее", "ДоКонцаРяда" или "ВесьРяд".
//
// Возвращаемое значение:
//  Булево - признак успешного перенесения событий.
//
Функция ПереместитьМероприятияРяда(ОбрабатываемыеЭлементы, ВыбраннаяДата, СпособИзмененияРяда = "ДоКонцаРяда") Экспорт
	
	ИтогФильтрацииПоПереодичности = ОтделитьПереодическиеСобытия(ОбрабатываемыеЭлементы, СпособИзмененияРяда);
	
	СобытияРяда		= ИтогФильтрацииПоПереодичности.ПереодическиеЭлементыРяда;
	СобытияБезРяда	= ИтогФильтрацииПоПереодичности.НеПереодическиеЭлементыРяда;
	
	ЭлементыДляСохранения = Новый Массив;
	
	Если СобытияРяда.Количество() > 0 Тогда
		КоличествоСобытийРядов = ПолучитьСобытияРядов(СобытияРяда);
	КонецЕсли;
	
	////////////////////////////////////
	// Обрабатываем события ряда
	
	НачатьТранзакцию();
	
	Попытка
		Для Каждого ТекущееСобытие Из СобытияРяда Цикл
			ОбрабатываемыйДокументСобытия = ТекущееСобытие.Источник;
			
			Если СпособИзмененияРяда = "ТолькоТекущее" Тогда
				ДополнительныеПоляЗаписи = Новый Структура(
					"ИзмененоВРяде,Тема",
					Истина, ОбрабатываемыйДокументСобытия.Тема);
				
				ДобавитьЭлементПланировщикаДляПеремещения(
					ЭлементыДляСохранения,
					ОбрабатываемыйДокументСобытия,
					ТекущееСобытие,
					ВыбраннаяДата,
					Ложь,
					ДополнительныеПоляЗаписи);
				
				РядСобытийОбрабатываемогоДокументаСсылка = ОбрабатываемыйДокументСобытия.РядСобытий;
				
				НайденнаяСтрокаКоличества = КоличествоСобытийРядов.Найти(РядСобытийОбрабатываемогоДокументаСсылка, "РядСобытий");
				Если НайденнаяСтрокаКоличества <> Неопределено И НайденнаяСтрокаКоличества.КоличествоМероприятий = 1 Тогда
					РядСобытийОбрабатываемогоДокументаОбъект = РядСобытийОбрабатываемогоДокументаСсылка.ПолучитьОбъект();
					РядСобытийОбрабатываемогоДокументаОбъект.УстановитьПометкуУдаления(Истина);
				КонецЕсли;
			Иначе
				// Если перемещение всего ряда, тогда это перемещение осуществляется в рамках дня.
				ВыбранСпособВесьРяд = (СпособИзмененияРяда = "ВесьРяд");
				
				// Так как меняется ряд событий, то нужно поправить его даты.
				РядСобытийОбрабатываемогоДокументаСсылка = ОбрабатываемыйДокументСобытия.РядСобытий;
				РядСобытийОбрабатываемогоДокументаОбъект = РядСобытийОбрабатываемогоДокументаСсылка.ПолучитьОбъект();
				РасписаниеРядаСобытийДокумента			 = РядСобытийОбрабатываемогоДокументаОбъект.Расписание.Получить();
				
				// Будет необходимо для определения того, что событие уже перенесено.
				// И все что будет необходимо - это изменить ссылку на ряд событий.
				ДатаОбрабатываемогоУжеИзменена = ТекущееСобытие.Свойство("ДатаНачалаТекущая");
				
				НачалоДняОбрабатываемогоДокумент = ?(
					ДатаОбрабатываемогоУжеИзменена,
					НачалоДня(ТекущееСобытие.ДатаНачалаТекущая),
					НачалоДня(ОбрабатываемыйДокументСобытия.ПлановаяДата));
				
				ОдинДеньВСекундах = 24 * 3600;
				
				// Если способ - это способ "ДоКонцаРяда", тогда нужно будет корректировать ряды событий.
				// Если обрабатываемый элемент - это начало ряда, то меняем просто даты.
				// Иначе создаем новый ряд, корректируя старый.
				Если Не ВыбранСпособВесьРяд Тогда
					ОбрабатываемоеСобытиеЭтоНачалоРяда =
						(НачалоДня(РядСобытийОбрабатываемогоДокументаОбъект.ДатаНачала) = НачалоДняОбрабатываемогоДокумент);
					
					Если ОбрабатываемоеСобытиеЭтоНачалоРяда Тогда
						ОбрабатываемыйРядСобытийОбъект	= РядСобытийОбрабатываемогоДокументаОбъект;
						ОбрабатываемыйРядСобытийСсылка	= РядСобытийОбрабатываемогоДокументаОбъект.Ссылка;
						ОбрабатываемоеРасписание		= РасписаниеРядаСобытийДокумента;
					Иначе
						ОбрабатываемыйРядСобытийОбъект	= Справочники.CRM_РядыСобытий.СоздатьЭлемент();
						ОбрабатываемыйРядСобытийСсылка	= Справочники.CRM_РядыСобытий.ПолучитьСсылку();
						ОбрабатываемоеРасписание		= Новый РасписаниеРегламентногоЗадания;
						
						ОбрабатываемыйРядСобытийОбъект.УстановитьСсылкуНового(ОбрабатываемыйРядСобытийСсылка);
						
						ЗаполнитьЗначенияСвойств(ОбрабатываемоеРасписание, РасписаниеРядаСобытийДокумента);
						
						ОбрабатываемыйРядСобытийОбъект.УчитыватьГрафикРаботы = Ложь;
					КонецЕсли;
					
					ДополнительныеПоляЗаписи = Новый Структура(
						"РядСобытий,Тема",
						ОбрабатываемыйРядСобытийСсылка,
						ОбрабатываемыйДокументСобытия.Тема);
					
					Если ДатаОбрабатываемогоУжеИзменена Тогда
						ДатаНачалаОтбораСобытий = НачалоДняОбрабатываемогоДокумент + ОдинДеньВСекундах;
						
						ТекущееСобытие.Вставить("РядСобытий", ОбрабатываемыйРядСобытийСсылка);
						
						ЭлементыДляСохранения.Добавить(ТекущееСобытие);
					Иначе
						ДатаНачалаОтбораСобытий = НачалоДняОбрабатываемогоДокумент;
					КонецЕсли;
					
					ИзменяемыеСобытияРядаРезультатЗапроса = ПолучитьРезультатЗапросаПоМероприятиямРяда(
						РядСобытийОбрабатываемогоДокументаСсылка, ,
						ДатаНачалаОтбораСобытий, , , ,
						Ложь);
					
					// Вычитаем день от даты переносимого события. Это будет дата окончания ряда событий от которого открепляем.
					РядСобытийОбрабатываемогоДокументаОбъект.ДатаОкончания	= НачалоДняОбрабатываемогоДокумент - ОдинДеньВСекундах;
					
					// Делаем то же самое для расписания.
					РасписаниеРядаСобытийДокумента.ДатаКонца = РядСобытийОбрабатываемогоДокументаОбъект.ДатаОкончания;
					
					РядСобытийОбрабатываемогоДокументаОбъект.Наименование = Справочники.CRM_РядыСобытий.ПолучитьПредставлениеРасписания(
						РасписаниеРядаСобытийДокумента, , 150);
					
					РядСобытийОбрабатываемогоДокументаОбъект.Расписание = Новый ХранилищеЗначения(
						РасписаниеРядаСобытийДокумента, Новый СжатиеДанных(9));
					
					РядСобытийОбрабатываемогоДокументаОбъект.Записать();
				Иначе
					ОбрабатываемыйРядСобытийОбъект	= РядСобытийОбрабатываемогоДокументаОбъект;
					ОбрабатываемыйРядСобытийСсылка	= РядСобытийОбрабатываемогоДокументаОбъект.Ссылка;
					ОбрабатываемоеРасписание		= РасписаниеРядаСобытийДокумента;
					
					ИзменяемыеСобытияРядаРезультатЗапроса = ПолучитьРезультатЗапросаПоМероприятиямРяда(
						РядСобытийОбрабатываемогоДокументаСсылка, , , , , ,
						Ложь);
				КонецЕсли;
				
				ВыборкаИзменяемыхСобытий = ИзменяемыеСобытияРядаРезультатЗапроса.Выбрать();
				
				// Созданим копию расписания регламентного задания.
				// Будем использовать для опеределения дат размещения событий.
				// А так же определелния даты окончания ряда.
				РасписаниеРегламентногоЗадания =
					СоздатьКопиюРасписанияРегламентногоЗаданияДляСоставленияРасписания(ОбрабатываемоеРасписание);
				
				ДатаНаРазмещениеСобытия = ?(
					ДатаОбрабатываемогоУжеИзменена,
					ВыбраннаяДата + ОдинДеньВСекундах,
					ВыбраннаяДата);
				
				ПоследняяДатаРазмещения = Неопределено;
				
				// Исправляем последовательнось.
				// Устанавливаем новый ряд событий для всех последующий документов
				// и меняем их даты, тем самым перенося их.
				Пока ВыборкаИзменяемыхСобытий.Следующий() Цикл
					Если ДатаОбрабатываемогоУжеИзменена И ВыборкаИзменяемыхСобытий.Мероприятие = ОбрабатываемыйДокументСобытия Тогда
						Продолжить;
					КонецЕсли;
					
					ДатаНаРазмещениеСобытия = ПолучитьСледующуюДатуРазмещения(
						ДатаНаРазмещениеСобытия,
						ПоследняяДатаРазмещения,
						РасписаниеРегламентногоЗадания);
					
					ПоследняяДатаРазмещения = ДатаНаРазмещениеСобытия;
					
					ДобавитьЭлементПланировщикаДляПеремещения(
						ЭлементыДляСохранения,
						ВыборкаИзменяемыхСобытий.Мероприятие,
						ТекущееСобытие,
						ДатаНаРазмещениеСобытия,
						ВыбранСпособВесьРяд,
						ДополнительныеПоляЗаписи);
				КонецЦикла;
				
				// Для "ДоКонцаРяда" заполняем раннее записанный новый ряд.
				Если Не ВыбранСпособВесьРяд Тогда
					ОбрабатываемыйРядСобытийОбъект.ДатаНачала		= ВыбраннаяДата;
					ОбрабатываемыйРядСобытийОбъект.ДатаОкончания	= ДатаНаРазмещениеСобытия;
					
					ОбрабатываемоеРасписание.ДатаНачала		= ОбрабатываемыйРядСобытийОбъект.ДатаНачала;
					ОбрабатываемоеРасписание.ДатаКонца		= ОбрабатываемыйРядСобытийОбъект.ДатаОкончания;
					
					ОбрабатываемыйРядСобытийОбъект.Наименование
						= Справочники.CRM_РядыСобытий.ПолучитьПредставлениеРасписания(ОбрабатываемоеРасписание, , 150);
					ОбрабатываемыйРядСобытийОбъект.Расписание
						= Новый ХранилищеЗначения(ОбрабатываемоеРасписание, Новый СжатиеДанных(9));
					
					ОбрабатываемыйРядСобытийОбъект.Записать();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	
		////////////////////////////////////
		// Обрабатываем не переодические события
		
		Для Каждого ТекущееСобытие Из СобытияБезРяда Цикл
			ДобавитьЭлементПланировщикаДляПеремещения(
				ЭлементыДляСохранения,
				ТекущееСобытие.Источник,
				ТекущееСобытие,
				ВыбраннаяДата,
				Ложь);
		КонецЦикла;
		
		ПереносВыполненУспешно = СохранитьИзмененияВБазу(ЭлементыДляСохранения);
		
		Если Не ПереносВыполненУспешно Тогда
			ВызватьИсключение "Перенос не выполнен";
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;
	
	Возврат ПереносВыполненУспешно;
	
КонецФункции // ПереместитьМероприятияРяда()

// Функция используется для удаления мероприятий из ряда событий.
//
// Параметры:
//  ОбрабатываемыеЭлементы  - Структура - Обрабатываемые элементы.
//  СпособИзмененияРяда     - Строка    - Способ изменения ряда "ТолькоТекущее", "ДоКонцаРяда" или "ВесьРяд".
//
// Возвращаемое значение:
//  Булево - признак успешного удаления событий.
//
Функция УдалитьМероприятияРяда(ОбрабатываемыеЭлементы, СпособИзмененияРяда) Экспорт
	
	ИтогФильтрацииПоПереодичности = ОтделитьПереодическиеСобытия(ОбрабатываемыеЭлементы, СпособИзмененияРяда);
	
	СобытияРяда		= ИтогФильтрацииПоПереодичности.ПереодическиеЭлементыРяда;
	СобытияБезРяда	= ИтогФильтрацииПоПереодичности.НеПереодическиеЭлементыРяда;
	
	ЭлементыДляУдаления = Новый Массив;
	
	Если СобытияРяда.Количество() > 0 Тогда
		КоличествоСобытийРядов = ПолучитьСобытияРядов(СобытияРяда);
	КонецЕсли;
	
	////////////////////////////////////
	// Обрабатываем события ряда
	
	НачатьТранзакцию();
	
	Попытка
		Для Каждого ТекущееСобытие Из СобытияРяда Цикл
			ОбрабатываемыйДокументСобытия = ТекущееСобытие.Источник;
			
			РядСобытийОбрабатываемогоДокументаСсылка	= ОбрабатываемыйДокументСобытия.РядСобытий;
			РядСобытийОбрабатываемогоДокументаОбъект	= РядСобытийОбрабатываемогоДокументаСсылка.ПолучитьОбъект();
			РасписаниеРядаСобытийДокумента				= РядСобытийОбрабатываемогоДокументаОбъект.Расписание.Получить();
			
			КоличествоУдаленныхСобытийРяда = 0;
			
			Если СпособИзмененияРяда = "ТолькоТекущее" Тогда
				ЭлементыДляУдаления.Добавить(ТекущееСобытие);
				КоличествоУдаленныхСобытийРяда = 1;
			Иначе
				Если СпособИзмененияРяда = "ДоКонцаРяда" Тогда
					НачалоДняОбрабатываемогоДокумент			= НачалоДня(ОбрабатываемыйДокументСобытия.ПлановаяДата);
					
					РядСобытийОбрабатываемогоДокументаОбъект	= РядСобытийОбрабатываемогоДокументаСсылка.ПолучитьОбъект();
					РасписаниеРядаСобытийДокумента				= РядСобытийОбрабатываемогоДокументаОбъект.Расписание.Получить();
					
					ИзменяемыеСобытияРядаРезультатЗапроса = ПолучитьРезультатЗапросаПоМероприятиямРяда(
						РядСобытийОбрабатываемогоДокументаСсылка, ,
						НачалоДняОбрабатываемогоДокумент, , , ,
						Ложь);
					
					РядСобытийОбрабатываемогоДокументаОбъект.ДатаОкончания	= НачалоДняОбрабатываемогоДокумент - (24 * 3600);
					РасписаниеРядаСобытийДокумента.ДатаКонца				= РядСобытийОбрабатываемогоДокументаОбъект.ДатаОкончания;
					
					РядСобытийОбрабатываемогоДокументаОбъект.Наименование
						= Справочники.CRM_РядыСобытий.ПолучитьПредставлениеРасписания(РасписаниеРядаСобытийДокумента, , 150);
					
					РядСобытийОбрабатываемогоДокументаОбъект.Расписание = Новый ХранилищеЗначения(
						РасписаниеРядаСобытийДокумента, Новый СжатиеДанных(9));
					
					РядСобытийОбрабатываемогоДокументаОбъект.Записать();
				Иначе
					ИзменяемыеСобытияРядаРезультатЗапроса = ПолучитьРезультатЗапросаПоМероприятиямРяда(
						РядСобытийОбрабатываемогоДокументаСсылка, , , , , ,
						Ложь);
				КонецЕсли;
				
				УдаляемыеСобытияВыборка = ИзменяемыеСобытияРядаРезультатЗапроса.Выбрать();
				
				Пока УдаляемыеСобытияВыборка.Следующий() Цикл
					ОбрабатываемыйЭлемент = Новый Структура;
					ОбрабатываемыйЭлемент.Вставить("Источник",			УдаляемыеСобытияВыборка.Мероприятие);
					ОбрабатываемыйЭлемент.Вставить("ПометкаУдаления",	Истина);
					
					ЭлементыДляУдаления.Добавить(ОбрабатываемыйЭлемент);
					
					КоличествоУдаленныхСобытийРяда = КоличествоУдаленныхСобытийРяда + 1;
				КонецЦикла;
			КонецЕсли;
			
			НайденнаяСтрокаКоличества = КоличествоСобытийРядов.Найти(РядСобытийОбрабатываемогоДокументаСсылка, "РядСобытий");
			Если НайденнаяСтрокаКоличества <> Неопределено
				 И НайденнаяСтрокаКоличества.КоличествоМероприятий = КоличествоУдаленныхСобытийРяда Тогда
				РядСобытийОбрабатываемогоДокументаОбъект.УстановитьПометкуУдаления(Истина);
			КонецЕсли;
		КонецЦикла;
	
		////////////////////////////////////
		// Обрабатываем не переодические события
		
		Для Каждого ТекущееСобытие Из СобытияБезРяда Цикл
			ЭлементыДляУдаления.Добавить(ТекущееСобытие);
		КонецЦикла;
		
		УдалениеВыполненоУспешно = СохранитьИзмененияВБазу(ЭлементыДляУдаления);
		
		Если Не УдалениеВыполненоУспешно Тогда
			ВызватьИсключение "Перенос не выполнен";
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;
	
	Возврат УдалениеВыполненоУспешно;
	
КонецФункции // УдалитьМероприятияРяда()

// Функция используется для проверки, что события является событием ряда.
//
// Параметры:
//  ДокументВзаимодействия  - ДокументСсылка.* - Событие для проверки.
//
// Возвращаемое значение:
//  Булево - признак того, что событие является событием ряда.
//
Функция СобытиеЯвляетсяСобытиемРяда(ДокументВзаимодействия) Экспорт
	
	Возврат ТипЗнч(ДокументВзаимодействия) = Тип("ДокументСсылка.CRM_Взаимодействие")
			И ЗначениеЗаполнено(ДокументВзаимодействия.РядСобытий)
			И Не ДокументВзаимодействия.ИзмененоВРяде;
	
КонецФункции // СобытиеЯвляетсяСобытиемРяда()

// Функция используется для сохранения обработанных элементов событий в базу.
//
// Параметры:
//  ОбрабатываемыеЭлементы  - Структура - Обрабатываемые элементы для сохранения в базу.
//
// Возвращаемое значение:
//  Булево - признак успешного сохранения.
//
Функция СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Для Каждого ОбрабатываемыйЭлемент Из ОбрабатываемыеЭлементы Цикл
			ЗаписьОбъект = ОбрабатываемыйЭлемент.Источник.ПолучитьОбъект();
			
			Если ОбрабатываемыйЭлемент.Свойство("ПометкаУдаления") Тогда
				ЗаписьОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(ЗаписьОбъект) = Тип("ДокументОбъект.CRM_Взаимодействие") Тогда
				Если ОбрабатываемыйЭлемент.Свойство("ИзмененоВРяде") Тогда
					ЗаписьОбъект.ИзмененоВРяде = ОбрабатываемыйЭлемент.ИзмененоВРяде;
					ЗаписьОбъект.Периодическое = ?(
						Не ОбрабатываемыйЭлемент.ИзмененоВРяде,
						ЗаписьОбъект.Периодическое,
						Ложь
					);
				КонецЕсли;
				
				Если ОбрабатываемыйЭлемент.Свойство("РядСобытий") Тогда
					ЗаписьОбъект.РядСобытий = ОбрабатываемыйЭлемент.РядСобытий;
				КонецЕсли;
			КонецЕсли;
			
			Если ОбрабатываемыйЭлемент.Свойство("Тема") Тогда
				ЗаписьОбъект.Тема = ОбрабатываемыйЭлемент.Тема;
			КонецЕсли;
			
			ЗаписьОбъект[ОбрабатываемыйЭлемент.РеквизитНачало]		= ОбрабатываемыйЭлемент.ПериодНачало;
			ЗаписьОбъект[ОбрабатываемыйЭлемент.РеквизитОкончание]	= ОбрабатываемыйЭлемент.ПериодОкончание;
			
			ЗаписьОбъект.Записать();
		КонецЦикла;
		
		Успешно = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Успешно = Ложь;
	КонецПопытки;
	
	Возврат Успешно;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////
//  ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ СОБЫТИЙ (УСТАРЕЛИ)

// Процедура создает на командной панели формы подменю выбора вида события.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Управляемая форма.
//  ГруппаФормы			 - ГруппаФормы		 - Группа формы.
//  ПервыйЭлемент		 - ПеречислениеСсылка - Вид события по умолчанию.
//  НеСоздаватьГруппу	 - Булево - Признак необходимости создания группы.
//  ИмяКоманды			 - Строка - Имя команды.
//
Процедура СоздатьГруппуСозданияСобытия(Форма, ГруппаФормы, ПервыйЭлемент = Неопределено,
	 НеСоздаватьГруппу = Ложь,
	 ИмяКоманды = "") Экспорт
	Если НеСоздаватьГруппу Тогда
		ГруппаСоздатьСобытие = ГруппаФормы;
	Иначе	
		Для Каждого ЭлементГруппы Из ГруппаФормы.ПодчиненныеЭлементы Цикл
			Если СтрНайти(ЭлементГруппы.Имя, "СоздатьСобытие") = 1 Тогда
				Возврат;
			КонецЕсли;
		КонецЦикла;	
		ГруппаСоздатьСобытие = Форма.Элементы.Добавить(ГруппаФормы.Имя + "_СоздатьСобытие", Тип("ГруппаФормы"), ГруппаФормы);
		ГруппаСоздатьСобытие.Вид = ВидГруппыФормы.Подменю;
		ГруппаСоздатьСобытие.Заголовок = "Событие";
		ГруппаСоздатьСобытие.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
	КонецЕсли;	
	Если ЗначениеЗаполнено(ПервыйЭлемент) Тогда
		ГруппаПервогоСобытия = Форма.Элементы.Добавить(ГруппаСоздатьСобытие.Имя + "_ГруппаПервогоСобытия",
			 Тип("ГруппаФормы"), ГруппаСоздатьСобытие);
		ГруппаПервогоСобытия.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;	
	Для Каждого ЭлементПеречисления Из Перечисления.CRM_ВидыСобытий Цикл
		ИндексЗначения = Перечисления.CRM_ВидыСобытий.Индекс(ЭлементПеречисления);
		ИмяПеречисления = Метаданные.Перечисления.CRM_ВидыСобытий.ЗначенияПеречисления[ИндексЗначения].Имя;		
		Если ЭлементПеречисления = ПервыйЭлемент Тогда
			НоваяКнопка = Форма.Элементы.Добавить(ГруппаСоздатьСобытие.Имя + "_" + ИмяПеречисления,
				 Тип("КнопкаФормы"), ГруппаПервогоСобытия);
			НоваяКнопка.КнопкаПоУмолчанию = Истина;
		Иначе
			НоваяКнопка = Форма.Элементы.Добавить(ГруппаСоздатьСобытие.Имя + "_" + ИмяПеречисления,
				 Тип("КнопкаФормы"), ГруппаСоздатьСобытие);
		КонецЕсли;	
		НоваяКнопка.Заголовок = ЭлементПеречисления;
		НоваяКнопка.Картинка = CRM_ОбщегоНазначенияКлиентСервер.ПолучитьКартинкуВидаСобытия(ЭлементПеречисления);
		НоваяКоманда = Форма.Команды.Добавить(ГруппаСоздатьСобытие.Имя + "_" + ИмяПеречисления);
		Если ПустаяСтрока(ИмяКоманды) Тогда
			НоваяКоманда.Действие = "СоздатьСобытиеОбщее";
		Иначе
			НоваяКоманда.Действие = ИмяКоманды;
		КонецЕсли;	
		НоваяКнопка.ИмяКоманды = НоваяКоманда.Имя; 
	КонецЦикла;
КонецПроцедуры // СоздатьГруппуСозданияСобытия()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру с RGB составляющими цветовой категории события.
//
Функция ПолучитьRGBКатегорииПоИндексу(ИндексКатегории) Экспорт
	Попытка
		ИндексКатегорииЧисло = Число(ИндексКатегории);
	
	Исключение	Возврат Неопределено;
	КонецПопытки;
	Если ИндексКатегорииЧисло > 24 Или ИндексКатегорииЧисло < 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
	|	Категории.ЦветКрасный КАК ЦветКрасный,
	|	Категории.ЦветЗеленый КАК ЦветЗеленый,
	|	Категории.ЦветСиний КАК ЦветСиний
	|ИЗ
	|	Справочник.CRM_Категории КАК Категории
	|ГДЕ
	|	НЕ Категории.ПометкаУдаления
	|	И Категории.ЦветИндекс = &ЦветИндекс
	|");
	Запрос.УстановитьПараметр("ЦветИндекс", ИндексКатегорииЧисло);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Новый Структура("Красный,Зеленый,Синий", Выборка.ЦветКрасный, Выборка.ЦветЗеленый, Выборка.ЦветСиний);
	Иначе
		МассивКатегорий = Новый Массив();
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  255, 136, 124)); // 0
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  255, 184, 120)); // 1
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  251, 215, 91)); // 2
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  255, 250, 130)); // 3
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  122, 231, 191)); // 4
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  70, 214, 219)); // 5
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  197, 210, 169)); // 6
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  164, 189, 252)); // 7
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  219, 173, 255)); // 8
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  212, 164, 186)); // 9
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  216, 218, 229)); // 10
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  97, 111, 140)); // 11
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  225, 225, 225)); // 12
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  104, 104, 104)); // 13
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  46, 46, 46)); // 14
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  220, 33, 39)); // 15
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  206, 93, 17)); // 16
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  192, 145, 32)); // 17
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  175, 170, 0)); // 18
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  81, 183, 73)); // 19
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  53, 149, 119)); // 20
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  114, 130, 71)); // 21
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  84, 132, 237)); // 22
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  91, 61, 160)); // 23
		МассивКатегорий.Добавить(Новый Структура("Красный,Зеленый,Синий",  147, 67, 108)); // 24
		
		Возврат МассивКатегорий[ИндексКатегорииЧисло];
		
	КонецЕсли;
КонецФункции

// Процедура создает копию документа по ссылке на документ - шаблон.
//
// Параметры:
//	СобытиеОбъект		- ДокументОбъект	- Событие	
//	СобытиеШаблон		- Документссылка	- Шаблон события.
//	ДатаПоРасписанию	- Дата				- Дата по расписанию.
//	ЭтоНовыйОбъект		- Булево			- Флаг нового объекта.
//
Процедура ЗаполнитьОбъектМероприятияПоМероприятию(МероприятиеОбъект, МероприятиеШаблон,
	 ДатаПоРасписанию,
	 ЭтоНовыйОбъект)
	ЗаполнитьЗначенияСвойств(МероприятиеОбъект, МероприятиеШаблон, , "Номер");
	СобытиеМД = МероприятиеОбъект.Метаданные();
	Для Каждого ТабличнаяЧасть Из СобытиеМД.ТабличныеЧасти Цикл
		ИмяТЧ = ТабличнаяЧасть.Имя;
		МероприятиеОбъект[ИмяТЧ].Очистить();
		Для Каждого СтрокаТЧ Из МероприятиеШаблон[ИмяТЧ] Цикл
			НоваяСтрока = МероприятиеОбъект[ИмяТЧ].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		КонецЦикла;
	КонецЦикла;
	МероприятиеОбъект.Дата =  МероприятиеШаблон.Дата;
	МероприятиеОбъект.ПлановаяДата				= НачалоДня(ДатаПоРасписанию) 
		+ (МероприятиеШаблон.ПлановаяДата - НачалоДня(МероприятиеШаблон.ПлановаяДата));
	МероприятиеОбъект.ПлановаяДатаЗавершение	= НачалоДня(ДатаПоРасписанию) 
		+ (МероприятиеШаблон.ПлановаяДатаЗавершение - НачалоДня(МероприятиеШаблон.ПлановаяДатаЗавершение));
	МероприятиеОбъект.ПометкаУдаления = Ложь;
	МероприятиеОбъект.Периодическое = Истина;
	Если ЭтоНовыйОбъект Тогда
		МероприятиеОбъект.УстановитьНовыйНомер();
	КонецЕсли;
КонецПроцедуры // ЗаполнитьОбъектСобытияПоСобытию()

// Функция для добавления элемента планировщика для перемещения.
//
// Параметры:
//  ОбрабатываемыеЭлементы       - Массив         - Массив событий.
//  ИсточникСобытия              - ДокументСсылка - Ссылка на обрабатываемый в данный момент документ.
//  ЗначениеПереносимогоСобытия  - Структура      - Текущее обрабатываемое событие.
//  ВыбраннаяДата                - Дата           - На какую дату осуществляется перенос.
//  ФлагПереносаПоВремени        - Булево         - Признак переноса события в рамках дня.
//  ДополнительныеПоляЗаписи     - Структура      - Дополнительные реквизиты документя для записи.
//
Процедура ДобавитьЭлементПланировщикаДляПеремещения(
		ОбрабатываемыеЭлементы,
		ИсточникСобытия,
		ЗначениеПереносимогоСобытия,
		ВыбраннаяДата,
		ФлагПереносаПоВремени,
		ДополнительныеПоляЗаписи = Неопределено)
	
	ИсходнаяДатаНачало = ИсточникСобытия[ЗначениеПереносимогоСобытия.РеквизитНачало];
	
	КоличествоСекундНаПеремещение = НачалоДня(ВыбраннаяДата) - НачалоДня(ИсходнаяДатаНачало);
	
	ПродолжительностьПереносимогоСобытия	=
		ЗначениеПереносимогоСобытия.ПериодОкончание - ЗначениеПереносимогоСобытия.ПериодНачало;
	ОтступОтНачалаДня						=
		ЗначениеПереносимогоСобытия.ПериодНачало - НачалоДня(ЗначениеПереносимогоСобытия.ПериодНачало);
	
	Если Не ФлагПереносаПоВремени Тогда
		ПеремещениеСобытиеНаДеньНачала = НачалоДня(ИсходнаяДатаНачало) + КоличествоСекундНаПеремещение;
		
		РезультатНачало	= ПеремещениеСобытиеНаДеньНачала + ОтступОтНачалаДня;
		РезультатКонец	= ПеремещениеСобытиеНаДеньНачала + ОтступОтНачалаДня + ПродолжительностьПереносимогоСобытия;
	Иначе
		РезультатНачало	= НачалоДня(ИсходнаяДатаНачало) + ОтступОтНачалаДня;
		РезультатКонец	= НачалоДня(ИсходнаяДатаНачало) + ОтступОтНачалаДня + ПродолжительностьПереносимогоСобытия;
	КонецЕсли;
	
	ОбрабатываемыйЭлемент = Новый Структура(
		"Источник,ПериодНачало,ПериодОкончание,РеквизитНачало,РеквизитОкончание",
		ИсточникСобытия, РезультатНачало, РезультатКонец,
		ЗначениеПереносимогоСобытия.РеквизитНачало,
		ЗначениеПереносимогоСобытия.РеквизитОкончание);
	
	Если ДополнительныеПоляЗаписи <> Неопределено Тогда
		Для Каждого ТекущаяСтрокаКлючЗначение Из ДополнительныеПоляЗаписи Цикл
			ОбрабатываемыйЭлемент.Вставить(ТекущаяСтрокаКлючЗначение.Ключ, ТекущаяСтрокаКлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
	
КонецПроцедуры // ДобавитьЭлементПланировщикаДляПеремещения()

// Функция для отделения переодических событий от непереодичских.
//
// Параметры:
//  МассивСобытий        - Массив - Массив событий.
//  СпособИзмененияРяда  - Строка - Способ изменения ряда.
//
// Возвращаемое значение:
//  Структура - Содержит массив переодических событий и массив непереодических событий.
//
Функция ОтделитьПереодическиеСобытия(МассивСобытий, СпособИзмененияРяда)
	
	ПереодическиеЭлементыРяда	= Новый Массив;
	НеПереодическиеЭлементыРяда	= Новый Массив;
	ДобавленныеЭлементыРяда		= Новый Соответствие;
	
	Если СпособИзмененияРяда = "ТолькоТекущее" Или ПустаяСтрока(СпособИзмененияРяда) Тогда
		Для Каждого ТекущееСобытие Из МассивСобытий Цикл
			ДокументВзаимодействия = ТекущееСобытие.Источник;
			Если СобытиеЯвляетсяСобытиемРяда(ДокументВзаимодействия) Тогда
				ПереодическиеЭлементыРяда.Добавить(ТекущееСобытие);
			Иначе
				НеПереодическиеЭлементыРяда.Добавить(ТекущееСобытие);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ТекущееСобытие Из МассивСобытий Цикл
			ДокументВзаимодействия = ТекущееСобытие.Источник;
			
			Если СобытиеЯвляетсяСобытиемРяда(ДокументВзаимодействия) Тогда
				РядСобытияДокумента		= ДокументВзаимодействия.РядСобытий;
				РанееДобавленноеСобытие	= ДобавленныеЭлементыРяда.Получить(РядСобытияДокумента);
				
				Если РанееДобавленноеСобытие = Неопределено Тогда
					ДобавленныеЭлементыРяда.Вставить(РядСобытияДокумента, ТекущееСобытие);
				Иначе
					Если РанееДобавленноеСобытие.Источник.ПлановаяДата > ДокументВзаимодействия.ПлановаяДата Тогда
						ДобавленныеЭлементыРяда.Вставить(РядСобытияДокумента, ТекущееСобытие);
					КонецЕсли;
				КонецЕсли;
			Иначе
				НеПереодическиеЭлементыРяда.Добавить(ТекущееСобытие);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ТекущаяПараКлючЗначение Из ДобавленныеЭлементыРяда Цикл
		ПереодическиеЭлементыРяда.Добавить(ТекущаяПараКлючЗначение.Значение);
	КонецЦикла;
	
	Возврат Новый Структура(
		"ПереодическиеЭлементыРяда,НеПереодическиеЭлементыРяда",
		ПереодическиеЭлементыРяда, НеПереодическиеЭлементыРяда
	);
	
КонецФункции // ПолучитьПереодическиеМероприятияСобытий()

// Функция используется для копированя расписания регламентного задания.
//
// Параметры:
//  ДатаНачалаПоиска        - Дата                           - Дата начала поиска размещения события.
//  ПоследняяНайденнаяДата  - Дата                           - Последняя найденная дата размещения события.
//  Расписание              - РасписаниеРегламентногоЗадания - Расписание по которому производится поиска размещения.
//
// Возвращаемое значение:
//  Дата - Дата следующего размезщения события.
//
Функция ПолучитьСледующуюДатуРазмещения(ДатаНачалаПоиска, ПоследняяНайденнаяДата, Расписание)
	
	ШагДатыВСекундах = 24 * 60 * 60; // Шаг проверки - 1 день.
	
	ТекущаяДатаПроверки = КонецДня(ДатаНачалаПоиска);
	ТребуетсяВыполнение = Ложь;
	
	Пока Не ТребуетсяВыполнение Цикл
		ТребуетсяВыполнение = ?(
			ПоследняяНайденнаяДата = Неопределено,
			Расписание.ТребуетсяВыполнение(ТекущаяДатаПроверки),
			Расписание.ТребуетсяВыполнение(ТекущаяДатаПроверки, ПоследняяНайденнаяДата)
		);
		
		Если Не ТребуетсяВыполнение Тогда
			ТекущаяДатаПроверки = ТекущаяДатаПроверки + ШагДатыВСекундах;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НачалоДня(ТекущаяДатаПроверки);
	
КонецФункции // ПолучитьСледующуюДатуРазмещения()

// Функция используется для копированя расписания регламентного задания.
//
// Параметры:
//  Расписание  - РасписаниеРегламентногоЗадания - Расписание которое будем копировать.
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - Скопированное расписание регламентного задания.
//
Функция СоздатьКопиюРасписанияРегламентногоЗаданияДляСоставленияРасписания(Расписание)
	
	РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	ЗаполнитьЗначенияСвойств(РасписаниеРегламентногоЗадания, Расписание);
	
	ПустаяДата = Дата("00010101");
	
	РасписаниеРегламентногоЗадания.ВремяНачала	= ПустаяДата;
	РасписаниеРегламентногоЗадания.ВремяКонца	= ПустаяДата;
	
	РасписаниеРегламентногоЗадания.ДатаНачала	= ПустаяДата;
	РасписаниеРегламентногоЗадания.ДатаКонца	= ПустаяДата;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции // СоздатьКопиюРасписанияРегламентногоЗаданияДляСоставленияРасписания()

// Функция используется для получения количества событий по рядам событий.
//
// Параметры:
//  СобытияРяда  - Массив - Массив переодических событий.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Количество событий по рядам.
//
Функция ПолучитьСобытияРядов(СобытияРяда)
	
	МассивСобытийОбработки = Новый Массив;
	
	Для Каждого ТекущееСобытие Из СобытияРяда Цикл
		МассивСобытийОбработки.Добавить(ТекущееСобытие.Источник.РядСобытий);
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Мероприятие.Ссылка КАК Мероприятие,
	|	Мероприятие.ПлановаяДата КАК ДатаНачала,
	|	Мероприятие.ПлановаяДатаЗавершение КАК ДатаОкончания,
	|	Мероприятие.РядСобытий КАК РядСобытий
	|ПОМЕСТИТЬ втМероприятияРядовСобытий
	|ИЗ
	|	Документ.CRM_Взаимодействие КАК Мероприятие
	|ГДЕ
	|	Мероприятие.РядСобытий В (&РядыСобытий)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(втМероприятияРядовСобытий.Мероприятие) КАК КоличествоМероприятий,
	|	втМероприятияРядовСобытий.РядСобытий КАК РядСобытий
	|ИЗ
	|	втМероприятияРядовСобытий КАК втМероприятияРядовСобытий
	|
	|СГРУППИРОВАТЬ ПО
	|	втМероприятияРядовСобытий.РядСобытий";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("РядыСобытий", МассивСобытийОбработки);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // МассивСобытийОбработки()

#КонецОбласти
