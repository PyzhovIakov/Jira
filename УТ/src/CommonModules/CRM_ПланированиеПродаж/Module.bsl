
#Область ПрограммныйИнтерфейс

// Возвращает массив основных аналитик планирования продаж
// 
// Возвращаемое значение:
//   - Массив
//
Функция ОсновныеАналитикиПланирования() Экспорт
	
	ОсновныеАналитики = Новый Массив;
	ОсновныеАналитики.Добавить(ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Подразделение);
	ОсновныеАналитики.Добавить(ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Менеджеры);
	ОсновныеАналитики.Добавить(ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры);
	ОсновныеАналитики.Добавить(ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Номенклатура);
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ОсновныеАналитики.Добавить(ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования["Склады"]);
	КонецЕсли;
	Возврат ОсновныеАналитики;
	
КонецФункции

// Возвращает дополнительные типы аналитики схемы планирования
//
// Параметры:
//  ПланСхема	 - СправочникСсылка.CRM_СхемаПланаПродаж,
//                 СправочникСсылка.CRM_ПланПродаж	 - план продаж или схема плана продаж.
// 
// Возвращаемое значение:
//   - Массив
//
Функция ДополнительныеАналитикиСхемы(ПланСхема) Экспорт

	Если ТипЗнч(ПланСхема) = Тип("СправочникСсылка.CRM_СхемаПланаПродаж") Тогда
		Схема = ПланСхема;
	Иначе
		Схема = ПланСхема.СхемаПланаПродаж;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СхемаПланаПродажЭлементыСхемы.Разрез КАК Разрез,
	                      |	CRM_СхемаПланаПродажЭлементыСхемы.Ссылка.Наименование КАК Наименование,
	                      |	CRM_СхемаПланаПродажЭлементыСхемы.Ссылка.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	                      |ИЗ
	                      |	Справочник.CRM_СхемаПланаПродаж.ЭлементыСхемы КАК CRM_СхемаПланаПродажЭлементыСхемы
	                      |ГДЕ
	                      |	CRM_СхемаПланаПродажЭлементыСхемы.Ссылка = &Схема
	                      |	И НЕ CRM_СхемаПланаПродажЭлементыСхемы.Разрез В (&ОсновныеАналитики)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	CRM_СхемаПланаПродажЭлементыСхемы.НомерСтроки");

	Запрос.УстановитьПараметр("Схема", Схема);
	Запрос.УстановитьПараметр("ОсновныеАналитики", ОсновныеАналитикиПланирования());
	
	Результат = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОписаниеАналитики = Новый Структура;
		ОписаниеАналитики.Вставить("Имя", Выборка.ИмяПредопределенныхДанных);
		ОписаниеАналитики.Вставить("ТипАналитики", Выборка.Разрез);
		ОписаниеАналитики.Вставить("Заголовок", Выборка.Наименование);
		ОписаниеАналитики.Вставить("ПутьКРеквизиту", ПутьКРеквизитуАналитики(Выборка.Разрез));
		Результат.Добавить(ОписаниеАналитики);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сравнивает периодичности и возвращает признак детальности одной периодичности по отношению к другой.
//
// Параметры:
//  ПериодичностьА	 - ПеречислениеСсылка.Периодичность	 - первая периодичность
//  ПериодичностьБ	 - ПеречислениеСсылка.Периодичность	 - вторая периодичность
// 
// Возвращаемое значение:
//  Булево - Истина, если первая периодичность детальнее второй.
//
Функция ПериодичностьАДетальнееБ(ПериодичностьА, ПериодичностьБ) Экспорт
	
	МассивПериодичностей = МассивПериодичностей();
	
	ИндексПериодичностиА = МассивПериодичностей.Найти(ПериодичностьА);
	ИндексПериодичностиБ = МассивПериодичностей.Найти(ПериодичностьБ);
	
	Возврат ИндексПериодичностиА < ИндексПериодичностиБ;
	
КонецФункции

// Возвращает массив всех периодичностей.
// 
// Возвращаемое значение:
//  Массив - Массив периодичностей.
//
Функция МассивПериодичностей() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить(Перечисления.Периодичность.День);
	Результат.Добавить(Перечисления.Периодичность.Неделя);
	Результат.Добавить(Перечисления.Периодичность.Месяц);
	Результат.Добавить(Перечисления.Периодичность.Квартал);
	Результат.Добавить(Перечисления.Периодичность.Полугодие);
	Результат.Добавить(Перечисления.Периодичность.Год);
	
	Возврат Результат;
	
КонецФункции

// Возвращает путь к реквизиту соответствующему аналитике.
//
// Параметры:
//  ТипАналитики - ПланВидовХарактеристикСсылка.CRM_ТипыАналитикПланирования	 - Тип аналитики.
// 
// Возвращаемое значение:
//  Строка - Путь к реквизиту.
//
Функция ПутьКРеквизитуАналитики(ТипАналитики) Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Если ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры_ОсновнаяОтрасль Тогда
			ПутьКРеквизиту = "Партнер.CRM_ОсновнаяОтрасль";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры_СегментРынка Тогда
			ПутьКРеквизиту = "Партнер.CRM_СегментРынка";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры Тогда
			ПутьКРеквизиту = "Партнер";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Менеджеры Тогда
			ПутьКРеквизиту = "Менеджер";
		ИначеЕсли СтрНачинаетсяС(ТипАналитики.ИмяПредопределенныхДанных, "Партнеры_") Тогда
			ПутьКРеквизиту = СтрЗаменить(ТипАналитики.ИмяПредопределенныхДанных, "Партнеры_", "Партнер.");
		Иначе
			ПутьКРеквизиту = СтрЗаменить(ТипАналитики.ИмяПредопределенныхДанных, "_", ".");
		КонецЕсли;
	Иначе
		Если ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры_ОсновнаяОтрасль Тогда
			ПутьКРеквизиту = "АналитикаУчетаПоПартнерам.Партнер.CRM_ОсновнаяОтрасль";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры_СегментРынка Тогда
			ПутьКРеквизиту = "АналитикаУчетаПоПартнерам.Партнер.CRM_СегментРынка";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Партнеры Тогда
			ПутьКРеквизиту = "АналитикаУчетаПоПартнерам.Партнер";
		ИначеЕсли ТипАналитики = ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Менеджеры Тогда
			ПутьКРеквизиту = "Менеджер";
		ИначеЕсли СтрНачинаетсяС(ТипАналитики.ИмяПредопределенныхДанных, "Партнеры_") Тогда
			ПутьКРеквизиту = СтрЗаменить(ТипАналитики.ИмяПредопределенныхДанных, "Партнеры_", "АналитикаУчетаПоПартнерам.Партнер.");
		ИначеЕсли СтрНачинаетсяС(ТипАналитики.ИмяПредопределенныхДанных, "Номенклатура_") Тогда
			ПутьКРеквизиту = СтрЗаменить(ТипАналитики.ИмяПредопределенныхДанных, "Номенклатура_", "АналитикаУчетаНоменклатуры.Номенклатура.");
		Иначе
			ПутьКРеквизиту = СтрЗаменить(ТипАналитики.ИмяПредопределенныхДанных, "_", ".");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПутьКРеквизиту;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

Процедура РегистрацияДанныхКОбновлениюМетаданных(Параметры) Экспорт
	// BSLLS:LogicalOrInTheWhereSectionOfQuery-off
	// В дополнительном условии оператор ИЛИ можно использовать без ограничений.
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АналитикаУчетаПланаПродаж.Ссылка КАК Ссылка
		|ИЗ
		|Справочник.CRM_КлючиАналитикиПланаПродаж КАК АналитикаУчетаПланаПродаж
		|ГДЕ
		|	АналитикаУчетаПланаПродаж.Аналитика1 = НЕОПРЕДЕЛЕНО
		|	И АналитикаУчетаПланаПродаж.Аналитика2 = НЕОПРЕДЕЛЕНО
		|	И АналитикаУчетаПланаПродаж.Аналитика3 = НЕОПРЕДЕЛЕНО
		|	И (АналитикаУчетаПланаПродаж.УдалитьНаправлениеДеятельности <> 
		|		ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		ИЛИ АналитикаУчетаПланаПродаж.УдалитьГруппаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))");
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АналитикаУчетаПланаПродаж.Ссылка КАК Ссылка
		|ИЗ
		|Справочник.CRM_КлючиАналитикиПланаПродаж КАК АналитикаУчетаПланаПродаж
		|ГДЕ
		|	АналитикаУчетаПланаПродаж.Аналитика1 = НЕОПРЕДЕЛЕНО
		|	И АналитикаУчетаПланаПродаж.Аналитика2 = НЕОПРЕДЕЛЕНО
		|	И АналитикаУчетаПланаПродаж.Аналитика3 = НЕОПРЕДЕЛЕНО
		|	И (АналитикаУчетаПланаПродаж.УдалитьНаправлениеДеятельности <> 
		|		ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
		|		ИЛИ АналитикаУчетаПланаПродаж.УдалитьГруппаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|		ИЛИ АналитикаУчетаПланаПродаж.УдалитьТоварнаяКатегория <> ЗНАЧЕНИЕ(Справочник.ТоварныеКатегории.ПустаяСсылка)
		|		ИЛИ АналитикаУчетаПланаПродаж.УдалитьВидНоменклатуры <> ЗНАЧЕНИЕ(Справочник.ВидыНоменклатуры.ПустаяСсылка))");
	КонецЕсли;	
	// BSLLS:LogicalOrInTheWhereSectionOfQuery-on
	
	МассивСсылок = CRM_ОбщегоНазначенияСервер.ВыполнитьЗапрос(Запрос).Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбновлениеСтруктурыМетаданныхПланирования(Параметры) Экспорт
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	ИзмеренияОтбораСтр = "Подразделение,Менеджер,Партнер,Номенклатура,Склад,УдалитьНаправлениеДеятельности,"
	+ "УдалитьТоварнаяКатегория,УдалитьГруппаНоменклатуры,УдалитьВидНоменклатуры";
	ИзмеренияОтбора = СтрРазделить(ИзмеренияОтбораСтр, ",");
	
	ИзмеренияЗаписиСтр = "Подразделение,Менеджер,Партнер,Номенклатура,Склад,Аналитика1,Аналитика2,Аналитика3";
	ИзмеренияЗаписи = СтрРазделить(ИзмеренияЗаписиСтр, ",");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь,
	"Справочник.CRM_КлючиАналитикиПланаПродаж", МенеджерВременныхТаблиц);
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	ОсновныеАналитики = CRM_ПланированиеПродаж.ОсновныеАналитикиПланирования();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ СсылкиДляОбработки
	|ИЗ
	|	&ВТДокументыДляОбработки КАК СсылкиДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СсылкиДляОбработки.Ссылка КАК КлючАналитики,
	|	CRM_ПланПродаж.ПланПродаж.СхемаПланаПродаж КАК СхемаПланаПродаж,
	|	CRM_СхемаПланаПродажЭлементыСхемы.Разрез КАК Разрез,
	|	CRM_СхемаПланаПродажЭлементыСхемы.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	СсылкиДляОбработки КАК СсылкиДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRM_ПланПродаж КАК CRM_ПланПродаж
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.CRM_СхемаПланаПродаж.ЭлементыСхемы КАК CRM_СхемаПланаПродажЭлементыСхемы
	|			ПО CRM_ПланПродаж.ПланПродаж.СхемаПланаПродаж = CRM_СхемаПланаПродажЭлементыСхемы.Ссылка
	|			И НЕ CRM_СхемаПланаПродажЭлементыСхемы.Разрез В (&ОсновныеАналитики)
	|		ПО (CRM_ПланПродаж.АналитикаУчетаПланаПродаж = СсылкиДляОбработки.Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	CRM_СхемаПланаПродажЭлементыСхемы.НомерСтроки
	|ИТОГИ ПО
	|	КлючАналитики,
	|	СхемаПланаПродаж";
	
	Запрос.УстановитьПараметр("ОсновныеАналитики", ОсновныеАналитики);
	
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВТДокументыДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ВыборкаКлючи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаКлючи.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			ВыборкаСхемы = ВыборкаКлючи.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ПерваяСхема = Истина;
			Ключ = ВыборкаКлючи.КлючАналитики.ПолучитьОбъект();
			Пока ВыборкаСхемы.Следующий() Цикл
				Если ПерваяСхема Тогда
					ПерваяСхема = Ложь;
					НаборЗ = РегистрыСведений.CRM_АналитикаУчетаПланаПродаж.СоздатьНаборЗаписей();
					Для Каждого Измерение Из ИзмеренияОтбора Цикл
						НаборЗ.Отбор[Измерение].Установить(Ключ[Измерение]);
					КонецЦикла;
					НаборЗ.Прочитать();
					
					Если Не ЗначениеЗаполнено(ВыборкаСхемы.СхемаПланаПродаж) Тогда
						НаборЗ.Очистить();
						ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗ);
						ОбновлениеИнформационнойБазы.УдалитьДанные(Ключ);
						
						Продолжить;
					КонецЕсли;
					
					ВыборкаДопАналитик = ВыборкаСхемы.Выбрать();
					НомерАналитики = 1;
					Пока ВыборкаДопАналитик.Следующий() Цикл
						Если ВыборкаДопАналитик.Разрез = 
							ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Номенклатура_НаправлениеДеятельности Тогда
							Ключ["Аналитика" + Строка(НомерАналитики)] = Ключ.УдалитьНаправлениеДеятельности;
							Ключ.УдалитьНаправлениеДеятельности = Неопределено;
							НомерАналитики = НомерАналитики + 1;
						КонецЕсли;
						Если ВыборкаДопАналитик.Разрез = 
							ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Номенклатура_Родитель Тогда
							Ключ["Аналитика" + Строка(НомерАналитики)] = Ключ.УдалитьГруппаНоменклатуры;
							НомерАналитики = НомерАналитики + 1;
						КонецЕсли;
						Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
							Если ВыборкаДопАналитик.Разрез = 
								ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования["Номенклатура_ТоварнаяКатегория"] Тогда
								Ключ["Аналитика" + Строка(НомерАналитики)] = Ключ["УдалитьТоварнаяКатегория"];
								НомерАналитики = НомерАналитики + 1;
							КонецЕсли;
							Если ВыборкаДопАналитик.Разрез = 
								ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования["Номенклатура_ВидНоменклатуры"] Тогда
								Ключ["Аналитика" + Строка(НомерАналитики)] = Ключ["УдалитьВидНоменклатуры"];
								НомерАналитики = НомерАналитики + 1;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Ключ);
					
					Если НаборЗ.Выбран() И НаборЗ.Количество() > 0 Тогда
						НаборЗ.Очистить();
						ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗ);
						
						НаборЗ = РегистрыСведений.CRM_АналитикаУчетаПланаПродаж.СоздатьНаборЗаписей();
						Для Каждого Измерение Из ИзмеренияЗаписи Цикл
							НаборЗ.Отбор[Измерение].Установить(Ключ[Измерение]);
						КонецЦикла;
						Запись = НаборЗ.Добавить();
						Для Каждого Измерение Из ИзмеренияЗаписи Цикл
							Запись[Измерение] = Ключ[Измерение];
						КонецЦикла;
						Запись.КлючАналитики = Ключ.Ссылка;
						
						ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗ);
					КонецЕсли;
					
				Иначе
					
					СтруктураКлюча = Новый Структура(ИзмеренияЗаписиСтр);
					ЗаполнитьЗначенияСвойств(СтруктураКлюча, ВыборкаКлючи.КлючАналитики);
					
					ВыборкаДопАналитик = ВыборкаСхемы.Выбрать();
					НомерАналитики = 1;
					Пока ВыборкаДопАналитик.Следующий() Цикл
						Если ВыборкаДопАналитик.Разрез = 
							ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Номенклатура_НаправлениеДеятельности Тогда
							СтруктураКлюча["Аналитика" + Строка(НомерАналитики)] = Ключ.УдалитьНаправлениеДеятельности;
							НомерАналитики = НомерАналитики + 1;
						КонецЕсли;
						Если ВыборкаДопАналитик.Разрез = 
							ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования.Номенклатура_Родитель Тогда
							СтруктураКлюча["Аналитика" + Строка(НомерАналитики)] = Ключ.УдалитьГруппаНоменклатуры;
							НомерАналитики = НомерАналитики + 1;
						КонецЕсли;
						Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
							Если ВыборкаДопАналитик.Разрез = 
								ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования["Номенклатура_ТоварнаяКатегория"] Тогда
								СтруктураКлюча["Аналитика" + Строка(НомерАналитики)] = Ключ["УдалитьТоварнаяКатегория"];
								НомерАналитики = НомерАналитики + 1;
							КонецЕсли;
							Если ВыборкаДопАналитик.Разрез = 
								ПланыВидовХарактеристик.CRM_ТипыАналитикПланирования["Номенклатура_ВидНоменклатуры"] Тогда
								СтруктураКлюча["Аналитика" + Строка(НомерАналитики)] = Ключ["УдалитьВидНоменклатуры"];
								НомерАналитики = НомерАналитики + 1;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					КлючСсылка = РегистрыСведений.CRM_АналитикаУчетаПланаПродаж.ЗначениеКлючаАналитики(СтруктураКлюча);
					Если КлючСсылка <> ВыборкаКлючи.КлючАналитики Тогда
						Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
						|	CRM_ПланПродаж.ПланПродаж КАК ПланПродаж,
						|	CRM_ПланПродаж.АналитикаУчетаПланаПродаж КАК КлючАналитики
						|ИЗ
						|	РегистрСведений.CRM_ПланПродаж КАК CRM_ПланПродаж
						|ГДЕ
						|	CRM_ПланПродаж.ПланПродаж.СхемаПланаПродаж = &СхемаПланаПродаж
						|	И CRM_ПланПродаж.АналитикаУчетаПланаПродаж = &АналитикаУчетаПланаПродаж");
						Запрос.УстановитьПараметр("СхемаПланаПродаж", ВыборкаСхемы.СхемаПланаПродаж);
						Запрос.УстановитьПараметр("АналитикаУчетаПланаПродаж", ВыборкаСхемы.КлючАналитики);
						Выборка = Запрос.Выполнить().Выбрать();
						Пока Выборка.Следующий() Цикл
							НаборЗаписей = РегистрыСведений.CRM_ПланПродаж.СоздатьНаборЗаписей();
							НаборЗаписей.Отбор.ПланПродаж.Установить(Выборка.ПланПродаж);
							НаборЗаписей.Отбор.АналитикаУчетаПланаПродаж.Установить(Выборка.КлючАналитики);
							НаборЗаписей.Прочитать();
							
							ТЗ_Записей = НаборЗаписей.Выгрузить();
							НаборЗаписей.Очистить();
							НаборЗаписей.Записать();
							
							Для Каждого Запись Из ТЗ_Записей Цикл
								Запись.АналитикаУчетаПланаПродаж = КлючСсылка;
							КонецЦикла;
							НаборЗаписей.Отбор.ПланПродаж.Установить(Выборка.ПланПродаж);
							НаборЗаписей.Отбор.АналитикаУчетаПланаПродаж.Установить(КлючСсылка);
							НаборЗаписей.Загрузить(ТЗ_Записей);
							
							ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обновить структуру ключа аналитики продаж: %1 по причине:
			|%2'"), 
			Выборка.Ссылка, ТекстОшибки);
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			, Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
	"Справочник.CRM_КлючиАналитикиПланаПродаж");
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
