#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбщегоНазначенияУТ.СвернутьНаборЗаписей(ЭтотОбъект, Истина);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	РежимыФормированияРасходныхОрдеровАвтоматически = Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически;
	Если РежимыФормированияРасходныхОрдеровАвтоматически Тогда
		
		Если Не ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
			ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.ВидДвижения      КАК ВидДвижения,
		|	Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
		|	Таблица.Получатель       КАК Получатель,
		|	Таблица.Период           КАК Период,
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Назначение       КАК Назначение,
		|	Таблица.Серия            КАК Серия,
		|	Таблица.Склад            КАК Склад,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Таблица.КОтгрузке
		|		ИНАЧЕ -Таблица.КОтгрузке
		|	КОНЕЦ                    КАК КОтгрузкеПередЗаписью,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -Таблица.Собирается
		|		ИНАЧЕ Таблица.Собирается
		|	КОНЕЦ                    КАК СобираетсяПередЗаписью,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -Таблица.Собрано
		|		ИНАЧЕ Таблица.Собрано
		|	КОНЕЦ                    КАК СобраноПередЗаписью,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -Таблица.КОформлению
		|		ИНАЧЕ Таблица.КОформлению
		|	КОНЕЦ                    КАК КОформлениюПередЗаписью,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА -Таблица.КСборке
		|		ИНАЧЕ Таблица.КСборке
		|	КОНЕЦ                    КАК КСборкеПередЗаписью
		|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|ГДЕ
		|	Таблица.Регистратор = &Регистратор";
		Запрос.Выполнить();
		
	КонецЕсли;
	
	Если Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ВидДвижения      КАК ВидДвижения,
	|	Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
	|	Таблица.Номенклатура     КАК Номенклатура,
	|	Таблица.Характеристика   КАК Характеристика,
	|	Таблица.Назначение       КАК Назначение,
	|	Таблица.Серия            КАК Серия,
	|	Таблица.Склад            КАК Склад,
	|	Таблица.Получатель       КАК Получатель,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВРезерве + Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.ВРезерве - Таблица.КОтгрузке
	|	КОНЕЦ                    КАК ВРезервеКОтгрузкеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.КОтгрузке
	|	КОНЕЦ                    КАК КОтгрузкеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собирается
	|		ИНАЧЕ Таблица.Собирается
	|	КОНЕЦ                    КАК СобираетсяПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собрано
	|		ИНАЧЕ Таблица.Собрано
	|	КОНЕЦ                    КАК СобраноПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РежимыФормированияРасходныхОрдеровАвтоматически = Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически;
	
	Если ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		ЗапретитьФормированиеСводнойТаблицы = Неопределено;
		ДополнительныеСвойства.Свойство("ЗапретитьКонтрольДвиженияТоварыКОтгрузкеИзменениеСводно", ЗапретитьФормированиеСводнойТаблицы);
		ЗапретитьФормированиеСводнойТаблицы = ?(ЗапретитьФормированиеСводнойТаблицы = Неопределено, Ложь, ЗапретитьФормированиеСводнойТаблицы);
		
		Запрос = Новый Запрос;
		ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
		Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ЗапретитьФормированиеСводнойТаблицы", ЗапретитьФормированиеСводнойТаблицы);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		
		// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
		// и помещается во временную таблицу.
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаИзменений.ДокументОтгрузки           КАК ДокументОтгрузки,
		|	ТаблицаИзменений.Номенклатура               КАК Номенклатура,
		|	ТаблицаИзменений.Характеристика             КАК Характеристика,
		|	ТаблицаИзменений.Назначение                 КАК Назначение,
		|	ТаблицаИзменений.Серия                      КАК Серия,
		|	ТаблицаИзменений.Склад                      КАК Склад,
		|	ТаблицаИзменений.Получатель                 КАК Получатель,
		|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение)  КАК КОтгрузкеИзменение,
		|	СУММА(ТаблицаИзменений.СобираетсяИзменение) КАК СобираетсяИзменение,
		|	СУММА(ТаблицаИзменений.СобираетсяИзменение) КАК СобраноИзменение
		|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеИзменение
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.ВидДвижения            КАК ВидДвижения,
		|		Таблица.ДокументОтгрузки       КАК ДокументОтгрузки,
		|		Таблица.Номенклатура           КАК Номенклатура,
		|		Таблица.Характеристика         КАК Характеристика,
		|		Таблица.Назначение             КАК Назначение,
		|		Таблица.Серия                  КАК Серия,
		|		Таблица.Склад                  КАК Склад,
		|		Таблица.Получатель             КАК Получатель,
		|		Таблица.КОтгрузкеПередЗаписью  КАК КОтгрузкеИзменение,
		|		Таблица.СобираетсяПередЗаписью КАК СобираетсяИзменение,
		|		Таблица.СобраноПередЗаписью    КАК СобраноИзменение
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.ВидДвижения,
		|		Таблица.ДокументОтгрузки,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		Таблица.Получатель,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.КОтгрузке
		|			ИНАЧЕ Таблица.КОтгрузке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собирается
		|			ИНАЧЕ -Таблица.Собирается
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собрано
		|			ИНАЧЕ -Таблица.Собрано
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.ВидДвижения,
		|	ТаблицаИзменений.ДокументОтгрузки,
		|	ТаблицаИзменений.Номенклатура,
		|	ТаблицаИзменений.Характеристика,
		|	ТаблицаИзменений.Назначение,
		|	ТаблицаИзменений.Серия,
		|	ТаблицаИзменений.Склад,
		|	ТаблицаИзменений.Получатель
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ТаблицаИзменений.КОтгрузкеИзменение) <> 0
		|		ИЛИ СУММА(ТаблицаИзменений.СобираетсяИзменение) <> 0
		|		ИЛИ СУММА(ТаблицаИзменений.СобраноИзменение) <> 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Номенклатура             КАК Номенклатура,
		|	Т.Характеристика           КАК Характеристика,
		|	Т.Назначение               КАК Назначение,
		|	Т.Серия                    КАК Серия,
		|	Т.Склад                    КАК Склад,
		|	Т.Получатель               КАК Получатель,
		|	СУММА(Т.УвеличениеПрихода) КАК УвеличениеПрихода
		|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеИзменениеСводно
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.ВидДвижения    КАК ВидДвижения,
		|		Таблица.Номенклатура   КАК Номенклатура,
		|		Таблица.Характеристика КАК Характеристика,
		|		Таблица.Назначение     КАК Назначение,
		|		Таблица.Серия          КАК Серия,
		|		Таблица.Склад          КАК Склад,
		|		Таблица.Получатель     КАК Получатель,
		|		-Таблица.ВРезервеКОтгрузкеПередЗаписью КАК УвеличениеПрихода
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПередЗаписью КАК Таблица
		|ГДЕ
		|	Таблица.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	И Таблица.Склад.КонтролироватьОперативныеОстатки
		|	И НЕ &ЗапретитьФормированиеСводнойТаблицы
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.ВидДвижения,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		Таблица.Получатель,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.ВРезерве + Таблица.КОтгрузке
		|			ИНАЧЕ -Таблица.ВРезерве - Таблица.КОтгрузке
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК Т
		|ГДЕ
		|	Т.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	И Т.Склад.КонтролироватьОперативныеОстатки
		|	И НЕ &ЗапретитьФормированиеСводнойТаблицы
		|
		|СГРУППИРОВАТЬ ПО
		|	Т.ВидДвижения,
		|	Т.Номенклатура,
		|	Т.Склад,
		|	Т.Получатель,
		|	Т.Характеристика,
		|	Т.Назначение,
		|	Т.Серия
		|
		|ИМЕЮЩИЕ
		|	СУММА(Т.УвеличениеПрихода) > 0";
		
		Результат = Запрос.ВыполнитьПакет();
		
		Выборка = Результат[0].Выбрать();
		ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
			"ДвиженияТоварыКОтгрузкеИзменение", Выборка.Следующий() И Выборка.Количество > 0);
		
		Выборка = Результат[1].Выбрать();
		ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
			"ДвиженияТоварыКОтгрузкеИзменениеСводно", Выборка.Следующий() И Выборка.Количество > 0);
		
	КонецЕсли;
	
	Если РежимыФормированияРасходныхОрдеровАвтоматически
		И ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		
		Запрос = Новый Запрос;
		ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
		Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ТаблицаИзменений.Склад           КАК Склад,
		|	ТаблицаИзменений.Получатель      КАК Получатель,
		|	МИНИМУМ(ТаблицаИзменений.Период) КАК Период
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.ВидДвижения             КАК ВидДвижения,
		|		Таблица.Период                  КАК Период,
		|		Таблица.Получатель              КАК Получатель,
		|		Таблица.ДокументОтгрузки        КАК ДокументОтгрузки,
		|		Таблица.Номенклатура            КАК Номенклатура,
		|		Таблица.Характеристика          КАК Характеристика,
		|		Таблица.Назначение              КАК Назначение,
		|		Таблица.Серия                   КАК Серия,
		|		Таблица.Склад                   КАК Склад,
		|		Таблица.КОтгрузкеПередЗаписью   КАК КОтгрузкеИзменение,
		|		Таблица.КОформлениюПередЗаписью КАК КОформлениюИзменение,
		|		Таблица.КСборкеПередЗаписью     КАК КСборкеИзменение,
		|		Таблица.СобираетсяПередЗаписью  КАК СобираетсяИзменение,
		|		Таблица.СобраноПередЗаписью     КАК СобраноИзменение
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.ВидДвижения,
		|		Таблица.Период,
		|		Таблица.Получатель,
		|		Таблица.ДокументОтгрузки,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.КОтгрузке
		|			ИНАЧЕ Таблица.КОтгрузке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КОформлению
		|			ИНАЧЕ -Таблица.КОформлению
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КСборке
		|			ИНАЧЕ -Таблица.КСборке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собирается
		|			ИНАЧЕ -Таблица.Собирается
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собрано
		|			ИНАЧЕ -Таблица.Собрано
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.ВидДвижения,
		|	ТаблицаИзменений.Склад,
		|	ТаблицаИзменений.Получатель
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ТаблицаИзменений.КОтгрузкеИзменение) + СУММА(ТаблицаИзменений.КСборкеИзменение) + СУММА(ТаблицаИзменений.СобираетсяИзменение) + СУММА(ТаблицаИзменений.СобраноИзменение) <> 0
		|		ИЛИ СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
		|			И &ОформлятьСначалаНакладные)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Склад,
		|	Получатель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью";
		ВыборкаСкладПолучатель = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаСкладПолучатель.Следующий() Цикл
			
			Склад = ВыборкаСкладПолучатель.Склад;
			Получатель = ВыборкаСкладПолучатель.Получатель;
			
			Если Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтгрузке(Склад, ВыборкаСкладПолучатель.Период) Тогда
				Продолжить;
			КонецЕсли;
			
			Если СкладыСервер.ТребуетсяПереоформитьРасходныеОрдера(Склад, Получатель) Тогда
				СкладыСервер.ДобавитьВОчередьФормированияРасходныхОрдеров(Склад, Получатель, Отбор.Регистратор.Значение, Ложь);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров =
		ПолучитьФункциональнуюОпцию("ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров");
		
	Если ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
			
		Если ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
			Запрос.УстановитьПараметр("ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров",
				Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить());
			Запрос.УстановитьПараметр("МерныеТипыЕдиницИзмерений",
				Справочники.УпаковкиЕдиницыИзмерения.МерныеТипыЕдиницИзмерений());
			Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТаблицаИзменений.ДокументОтгрузки            КАК ДокументОтгрузки,
			|	ТаблицаИзменений.Номенклатура                КАК Номенклатура,
			|	ТаблицаИзменений.Назначение                  КАК Назначение,
			|	ТаблицаИзменений.Характеристика              КАК Характеристика,
			|	ТаблицаИзменений.Серия                       КАК Серия,
			|	ТаблицаИзменений.Склад                       КАК Склад,
			|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение)   КАК КОтгрузкеИзменение
			|ПОМЕСТИТЬ ДвиженияЗаказыНаОтгрузкуИзменениеМерныеТовары
			|ИЗ
			|	(ВЫБРАТЬ
			|
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.ДокументОтгрузки      КАК ДокументОтгрузки,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.Номенклатура          КАК Номенклатура,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.Характеристика        КАК Характеристика,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.Назначение            КАК Назначение,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.Серия                 КАК Серия,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.Склад                 КАК Склад,
			|	ДвиженияТоварыКОтгрузкеПередЗаписью.КОтгрузкеПередЗаписью КАК КОтгрузкеИзменение
			|
			|	ИЗ ДвиженияТоварыКОтгрузкеПередЗаписью КАК ДвиженияТоварыКОтгрузкеПередЗаписью
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|	Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
			|	Таблица.Номенклатура     КАК Номенклатура,
			|	Таблица.Характеристика   КАК Характеристика,
			|	Таблица.Назначение       КАК Назначение,
			|	Таблица.Серия            КАК Серия,
			|	Таблица.Склад            КАК Склад,
			|	ВЫБОР
			|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|			ТОГДА -Таблица.КОтгрузке
			|		ИНАЧЕ Таблица.КОтгрузке
			|	КОНЕЦ                    КАК КОтгрузкеПередЗаписью
			|	
			|ИЗ
			|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
			|ГДЕ
			|	Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
			|
			|ГДЕ
			|	ТаблицаИзменений.Номенклатура.ЕдиницаИзмерения.ТипИзмеряемойВеличины В (&МерныеТипыЕдиницИзмерений)
			|
			|СГРУППИРОВАТЬ ПО
			|	ТаблицаИзменений.ДокументОтгрузки,
			|	ТаблицаИзменений.Номенклатура,
			|	ТаблицаИзменений.Назначение,
			|	ТаблицаИзменений.Характеристика,
			|	ТаблицаИзменений.Серия,
			|	ТаблицаИзменений.Склад
			|
			|ИМЕЮЩИЕ
			|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение) <> 0
			|;
			|
			|///////////////////////////////////////////////////////////////////////////////////
			|
			|	ВЫБРАТЬ
			|	ТоварыКОтгрузке.ДокументОтгрузки  КАК ДокументОтгрузки,
			|	ТоварыКОтгрузке.Номенклатура      КАК Номенклатура,
			|	ТоварыКОтгрузке.Характеристика    КАК Характеристика,
			|	ТоварыКОтгрузке.Назначение        КАК Назначение,
			|	ТоварыКОтгрузке.Серия             КАК Серия,
			|	ТоварыКОтгрузке.Склад             КАК Склад,
			|	СУММА(ТоварыКОтгрузке.КОтгрузке
			|		* (&ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров / 100)) КАК ДопустимоеОтклонение
			|ПОМЕСТИТЬ ВТДопустимыеОтклоненияЗаказыНаОтгрузку
			|ИЗ
			|	РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ДвиженияЗаказыНаОтгрузкуИзменениеМерныеТовары КАК Изменения
			|		ПО ТоварыКОтгрузке.ДокументОтгрузки  = Изменения.ДокументОтгрузки
			|			И ТоварыКОтгрузке.Номенклатура   = Изменения.Номенклатура
			|			И ТоварыКОтгрузке.Назначение     = Изменения.Назначение
			|			И ТоварыКОтгрузке.Характеристика = Изменения.Характеристика
			|			И ТоварыКОтгрузке.Серия          = Изменения.Серия
			|			И ТоварыКОтгрузке.Склад          = Изменения.Склад
			|ГДЕ
			|	ТоварыКОтгрузке.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|СГРУППИРОВАТЬ ПО
			|	ТоварыКОтгрузке.ДокументОтгрузки,
			|	ТоварыКОтгрузке.Номенклатура,
			|	ТоварыКОтгрузке.Назначение,
			|	ТоварыКОтгрузке.Характеристика,
			|	ТоварыКОтгрузке.Серия,
			|	ТоварыКОтгрузке.Склад
			|;
			|
			|/////////////////////////////////////////////////////////////////////////////////////////
			|
			|	ВЫБРАТЬ
			|	ТоварыКОтгрузке.ДокументОтгрузки  КАК ДокументОтгрузки,
			|	ТоварыКОтгрузке.Номенклатура      КАК Номенклатура,
			|	ТоварыКОтгрузке.Характеристика    КАК Характеристика,
			|	ТоварыКОтгрузке.Назначение        КАК Назначение,
			|	ТоварыКОтгрузке.Серия             КАК Серия,
			|	ТоварыКОтгрузке.Склад             КАК Склад,
			|	СУММА(ВЫБОР КОГДА ТоварыКОтгрузке.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
			|			ТоварыКОтгрузке.КОтгрузке
			|		ИНАЧЕ
			|			-ТоварыКОтгрузке.КОтгрузке
			|	КОНЕЦ)                            КАК КОтгрузкеОстаток
			|ПОМЕСТИТЬ ВТЗаказыНаОтгрузкуОстатки
			|ИЗ
			|	РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ДвиженияЗаказыНаОтгрузкуИзменениеМерныеТовары КАК Изменения
			|		ПО ТоварыКОтгрузке.ДокументОтгрузки  = Изменения.ДокументОтгрузки
			|			И ТоварыКОтгрузке.Номенклатура   = Изменения.Номенклатура
			|			И ТоварыКОтгрузке.Назначение     = Изменения.Назначение
			|			И ТоварыКОтгрузке.Характеристика = Изменения.Характеристика
			|			И ТоварыКОтгрузке.Серия          = Изменения.Серия
			|			И ТоварыКОтгрузке.Склад          = Изменения.Склад
			|СГРУППИРОВАТЬ ПО
			|	ТоварыКОтгрузке.ДокументОтгрузки,
			|	ТоварыКОтгрузке.Номенклатура,
			|	ТоварыКОтгрузке.Назначение,
			|	ТоварыКОтгрузке.Характеристика,
			|	ТоварыКОтгрузке.Серия,
			|	ТоварыКОтгрузке.Склад
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЗаказыОстатки.ДокументОтгрузки КАК ДокументОтгрузки
			|ИЗ
			|	ВТЗаказыНаОтгрузкуОстатки КАК ЗаказыОстатки
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ВТДопустимыеОтклоненияЗаказыНаОтгрузку КАК ДопустимыеОтклонения
			|		ПО
			|			ЗаказыОстатки.ДокументОтгрузки    = ДопустимыеОтклонения.ДокументОтгрузки
			|			И ЗаказыОстатки.Номенклатура      = ДопустимыеОтклонения.Номенклатура
			|			И ЗаказыОстатки.Назначение        = ДопустимыеОтклонения.Назначение
			|			И ЗаказыОстатки.Характеристика    = ДопустимыеОтклонения.Характеристика
			|			И ЗаказыОстатки.Серия             = ДопустимыеОтклонения.Серия
			|			И ЗаказыОстатки.Склад             = ДопустимыеОтклонения.Склад
			|ГДЕ
			|	ЗаказыОстатки.КОтгрузкеОстаток <= ДопустимыеОтклонения.ДопустимоеОтклонение
			|	И ЗаказыОстатки.КОтгрузкеОстаток >= -ДопустимыеОтклонения.ДопустимоеОтклонение
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ДвиженияТоварыКОтгрузкеПередЗаписью
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ДвиженияЗаказыНаОтгрузкуИзменениеМерныеТовары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ВТДопустимыеОтклоненияЗаказыНаОтгрузку
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|УНИЧТОЖИТЬ ВТЗаказыНаОтгрузкуОстатки
			|";
			
			ВыборкаЗаказ = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаЗаказ.Следующий() Цикл
				
				РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.ДобавитьЗаказВОчередь(
					ВыборкаЗаказ.ДокументОтгрузки);
				
			КонецЦикла;
			
		Иначе
			
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
			
			Запрос.Текст = "УНИЧТОЖИТЬ ДвиженияТоварыКОтгрузкеПередЗаписью";
			
			Запрос.Выполнить();
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли