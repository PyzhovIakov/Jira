#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Период						 КАК Период,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Поставщик                    КАК Поставщик,
	|	Таблица.ДокументПоступления          КАК ДокументПоступления,
	|	Таблица.АналитикаУчетаНоменклатуры   КАК АналитикаУчетаНоменклатуры,
	|	Таблица.ВидЗапасов                   КАК ВидЗапасов,
	|	Таблица.ТипДокументаИмпорта          КАК ТипДокументаИмпорта,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.Сумма
	|		ИНАЧЕ
	|			-Таблица.Сумма
	|	КОНЕЦ                                КАК СуммаПередЗаписью,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.Количество
	|		ИНАЧЕ
	|			-Таблица.Количество
	|	КОНЕЦ                                КАК КоличествоПередЗаписью,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КоличествоПоРНПТ
	|		ИНАЧЕ
	|			-Таблица.КоличествоПоРНПТ
	|	КОНЕЦ                                КАК КоличествоПоРНПТПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыКОформлениюДокументовИмпортаПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюДокументовИмпорта КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Период		                 КАК Период,
	|	ТаблицаИзменений.Организация                 КАК Организация,
	|	ТаблицаИзменений.Поставщик                   КАК Поставщик,
	|	ТаблицаИзменений.ДокументПоступления         КАК ДокументПоступления,
	|	ТаблицаИзменений.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаИзменений.ВидЗапасов                  КАК ВидЗапасов,
	|	ТаблицаИзменений.ТипДокументаИмпорта         КАК ТипДокументаИмпорта,
	|	СУММА(ТаблицаИзменений.СуммаИзменение)  	 КАК СуммаИзменение,
	|	СУММА(ТаблицаИзменений.КоличествоИзменение)  КАК КоличествоИзменение,
	|	СУММА(ТаблицаИзменений.КоличествоПоРНПТИзменение) КАК КоличествоПоРНПТИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыКОформлениюДокументовИмпортаИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(Таблица.ДокументПоступления) = ТИП(Документ.ПриобретениеТоваровУслуг) 
	|				ТОГДА ДАТАВРЕМЯ(1,1,1)
	|			ИНАЧЕ
	|				ДАТАВРЕМЯ(1,1,1)
	|		КОНЕЦ 								КАК Период,
	|		Таблица.Организация                 КАК Организация,
	|		Таблица.Поставщик                   КАК Поставщик,
	|		Таблица.ДокументПоступления         КАК ДокументПоступления,
	|		Таблица.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		Таблица.ВидЗапасов                  КАК ВидЗапасов,
	|		Таблица.ТипДокументаИмпорта 		КАК ТипДокументаИмпорта,
	|		Таблица.СуммаПередЗаписью           КАК СуммаИзменение,
	|		Таблица.КоличествоПередЗаписью      КАК КоличествоИзменение,
	|		Таблица.КоличествоПоРНПТПередЗаписью КАК КоличествоПоРНПТИзменение
	|	ИЗ
	|		ДвиженияТоварыКОформлениюДокументовИмпортаПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВЫБОР 
	|			КОГДА ТИПЗНАЧЕНИЯ(Таблица.ДокументПоступления) = ТИП(Документ.ПриобретениеТоваровУслуг) 
	|				ТОГДА ДАТАВРЕМЯ(1,1,1)
	|			ИНАЧЕ
	|				ДАТАВРЕМЯ(1,1,1)
	|		КОНЕЦ								КАК Период,
	|		Таблица.Организация                 КАК Организация,
	|		Таблица.Поставщик                   КАК Поставщик,
	|		Таблица.ДокументПоступления         КАК ДокументПоступления,
	|		Таблица.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		Таблица.ВидЗапасов                  КАК ВидЗапасов,
	|		Таблица.ТипДокументаИмпорта			КАК ТипДокументаИмпорта,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.Сумма
	|			ИНАЧЕ
	|				Таблица.Сумма
	|		КОНЕЦ                               КАК СуммаИзменение,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|				-Таблица.Количество
	|			ИНАЧЕ
	|				Таблица.Количество
	|		КОНЕЦ                               КАК КоличествоИзменение,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КоличествоПоРНПТ
	|			ИНАЧЕ Таблица.КоличествоПоРНПТ
	|		КОНЕЦ								КАК КоличествоПоРНПТИзменение
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюДокументовИмпорта КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Период,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Поставщик,
	|	ТаблицаИзменений.ДокументПоступления,
	|	ТаблицаИзменений.АналитикаУчетаНоменклатуры,
	|	ТаблицаИзменений.ВидЗапасов,
	|	ТаблицаИзменений.ТипДокументаИмпорта
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаИзменений.КоличествоИзменение) > 0
	|		ИЛИ СУММА(ТаблицаИзменений.КоличествоПоРНПТИзменение) > 0
	|	)
	|;
	|УНИЧТОЖИТЬ ДвиженияТоварыКОформлениюДокументовИмпортаПередЗаписью
	|";
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	РезультатЗапроса = МассивРезультатовЗапроса[0]; // РезультатЗапроса
	Выборка = РезультатЗапроса.Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияТоварыКОформлениюДокументовИмпортаИзменение", Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
