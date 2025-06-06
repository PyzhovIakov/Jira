
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗначениеОтбора;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокРаспоряжений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Новый Структура("ЗаказКлиента, ПорядокРасчетов", 
			                Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка,
			                Элементы.СписокРаспоряжений.ТекущиеДанные.ПорядокРасчетов));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.СписокРаспоряжений) Тогда
		Закрыть(
			Новый Структура("ЗаказКлиента, ПорядокРасчетов", 
			                Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка,
			                Элементы.СписокРаспоряжений.ТекущиеДанные.ПорядокРасчетов));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЗаказы.ЗаказКлиента КАК ЗаказКлиента,
	|	СУММА(ТаблицаЗаказы.КОформлению) КАК КОформлению
	|ПОМЕСТИТЬ ТаблицаЗаказы1
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫРАЗИТЬ(РаспоряженияОбороты.Распоряжение КАК Документ.ЗаказКлиента) КАК ЗаказКлиента,
	|		РаспоряженияОбороты.КОформлениюОборот КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку.Обороты(,,, Распоряжение ССЫЛКА Документ.ЗаказКлиента
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Организация = &Организация
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Валюта = &Валюта
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Контрагент = &Контрагент
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Договор = &Договор
	|		И ВЫБОР
	|			КОГДА ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).НалогообложениеНДС В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров))
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт)
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).НалогообложениеНДС
	|		КОНЕЦ = &НалогообложениеНДС
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Партнер = &Партнер
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Соглашение = &Соглашение
	|		КОНЕЦ
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).ЦенаВключаетНДС = &ЦенаВключаетНДС
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).Сделка = &Сделка
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|		И Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаказКлиента).НаправлениеДеятельности = &НаправлениеДеятельности
	|		КОНЕЦ
	|		И (Склад = &Склад
	|		ИЛИ Склад В ИЕРАРХИИ (&Склад)
	|		ИЛИ Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК РаспоряженияОбороты
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ЗаказКлиента.Ссылка,
	|		ЗаказКлиентаТовары.Количество
	|	ИЗ
	|		Документ.ЗаказКлиента КАК ЗаказКлиента
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|			ПО ЗаказКлиента.Ссылка = ЗаказКлиентаТовары.Ссылка
	|	ГДЕ
	|		ЗаказКлиента.Организация = &Организация
	|		И ЗаказКлиента.Валюта = &Валюта
	|		И ЗаказКлиента.Контрагент = &Контрагент
	|		И ЗаказКлиента.Договор = &Договор
	|		И ВЫБОР
	|			КОГДА ЗаказКлиента.НалогообложениеНДС В (ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров))
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт)
	|			ИНАЧЕ ЗаказКлиента.НалогообложениеНДС
	|		КОНЕЦ = &НалогообложениеНДС
	|		И ЗаказКлиента.Партнер = &Партнер
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|		КОНЕЦ
	|		И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|		И ЗаказКлиента.Сделка = &Сделка
	|		И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|		И ЗаказКлиента.ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|		И ЗаказКлиентаТовары.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|		И (ЗаказКлиента.Склад = &Склад
	|		ИЛИ ЗаказКлиента.Склад В ИЕРАРХИИ (&Склад)
	|		ИЛИ ЗаказКлиента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|		КОНЕЦ
	|		И НЕ ЗаказКлиентаТовары.Отменено
	|		И ЗаказКлиента.ЭтоЗаказКакСчет
	|		И НЕ ЗаказКлиента.ПометкаУдаления
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ВЫРАЗИТЬ(РаспоряженияДвижения.Распоряжение КАК Документ.ЗаказКлиента),
	|		-РаспоряженияДвижения.КОформлению
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку КАК РаспоряженияДвижения
	|	ГДЕ
	|		РаспоряженияДвижения.Регистратор = &Регистратор
	|		И РаспоряженияДвижения.Активность
	|		И РаспоряженияДвижения.Распоряжение ССЫЛКА Документ.ЗаказКлиента) КАК ТаблицаЗаказы
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗаказы.ЗаказКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаказы.ЗаказКлиента КАК ЗаказКлиента,
	|	СУММА(ТаблицаЗаказы.КОформлению) КАК КОформлению
	|ПОМЕСТИТЬ ТаблицаЗаказы2
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫРАЗИТЬ(РаспоряженияОбороты.Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента) КАК ЗаказКлиента,
	|		РаспоряженияОбороты.КОформлениюОборот КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку.Обороты(,,, Распоряжение ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация = &Организация
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Валюта = &Валюта
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Контрагент = &Контрагент
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Договор = &Договор
	|		И ВЫБОР
	|			КОГДА ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).НалогообложениеНДС В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров))
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт)
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).НалогообложениеНДС
	|		КОНЕЦ = &НалогообложениеНДС
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Партнер = &Партнер
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Соглашение = &Соглашение
	|		КОНЕЦ
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).ЦенаВключаетНДС = &ЦенаВключаетНДС
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Сделка = &Сделка
	|		И ВЫРАЗИТЬ(Распоряжение КАК
	|			Документ.ЗаявкаНаВозвратТоваровОтКлиента).ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|		И ВЫРАЗИТЬ(Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).ТребуетсяЗалогЗаТару = &ТребуетсяЗалогЗаТару
	|		И Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫРАЗИТЬ(Распоряжение КАК
	|				Документ.ЗаявкаНаВозвратТоваровОтКлиента).НаправлениеДеятельности = &НаправлениеДеятельности
	|		КОНЕЦ
	|		И (Склад = &Склад
	|		ИЛИ Склад В ИЕРАРХИИ (&Склад)
	|		ИЛИ Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК РаспоряженияОбороты
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ЗаказКлиента.Ссылка,
	|		ЗаказКлиентаТовары.Количество
	|	ИЗ
	|		Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК ЗаказКлиентаТовары
	|			ПО ЗаказКлиента.Ссылка = ЗаказКлиентаТовары.Ссылка
	|	ГДЕ
	|		ЗаказКлиента.Организация = &Организация
	|		И ЗаказКлиента.Валюта = &Валюта
	|		И ЗаказКлиента.Контрагент = &Контрагент
	|		И ЗаказКлиента.Договор = &Договор
	|		И ВЫБОР
	|			КОГДА ЗаказКлиента.НалогообложениеНДС В (ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров))
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт)
	|			ИНАЧЕ ЗаказКлиента.НалогообложениеНДС
	|		КОНЕЦ = &НалогообложениеНДС
	|		И ЗаказКлиента.Партнер = &Партнер
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗаказКлиента.Соглашение = &Соглашение
	|		КОНЕЦ
	|		И ЗаказКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|		И ЗаказКлиента.Сделка = &Сделка
	|		И ЗаказКлиента.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|		И ЗаказКлиентаТовары.Номенклатура.ВариантОформленияПродажи = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг)
	|		И (ЗаказКлиента.Склад = &Склад
	|		ИЛИ ЗаказКлиента.Склад В ИЕРАРХИИ (&Склад)
	|		ИЛИ ЗаказКлиента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|		И ВЫБОР
	|			КОГДА НЕ &ИспользоватьНаправленияДеятельности
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗаказКлиента.НаправлениеДеятельности = &НаправлениеДеятельности
	|		КОНЕЦ
	|		И НЕ ЗаказКлиентаТовары.Отменено
	|		И ЗаказКлиента.ЭтоЗаказКакСчет
	|		И НЕ ЗаказКлиента.ПометкаУдаления
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ВЫРАЗИТЬ(РаспоряженияДвижения.Распоряжение КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента),
	|		-РаспоряженияДвижения.КОформлению
	|	ИЗ
	|		РегистрНакопления.РаспоряженияНаОтгрузку КАК РаспоряженияДвижения
	|	ГДЕ
	|		РаспоряженияДвижения.Регистратор = &Регистратор
	|		И РаспоряженияДвижения.Активность
	|		И РаспоряженияДвижения.Распоряжение ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента) КАК ТаблицаЗаказы
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗаказы.ЗаказКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Заказы.Ссылка КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(Заказы.Ссылка) КАК ТипРаспоряжения,
	|	Заказы.Дата КАК Дата,
	|	Заказы.Номер КАК Номер,
	|	Заказы.Партнер КАК Партнер,
	|	Заказы.Контрагент КАК Контрагент,
	|	Заказы.Договор КАК Договор,
	|	Заказы.Соглашение КАК Соглашение,
	|	Заказы.Организация КАК Организация,
	|	Заказы.Склад КАК Склад,
	|	Заказы.Валюта КАК Валюта,
	|	Заказы.Менеджер КАК Менеджер,
	|	Заказы.Статус КАК Статус,
	|	Заказы.СуммаДокумента КАК СуммаДокумента,
	|	Заказы.Приоритет КАК Приоритет,
	|	Заказы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Заказы.НалогообложениеНДС КАК НалогообложениеНДС,
	|	Заказы.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	Заказы.ПорядокРасчетов КАК ПорядокРасчетов,
	|	Заказы.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА Заказы.Приоритет В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				Приоритеты.Ссылка КАК Приоритет
	|			ИЗ
	|				Справочник.Приоритеты КАК Приоритеты
	|
	|			УПОРЯДОЧИТЬ ПО
	|				Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заказы.Приоритет В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				Приоритеты.Ссылка КАК Приоритет
	|			ИЗ
	|				Справочник.Приоритеты КАК Приоритеты
	|
	|			УПОРЯДОЧИТЬ ПО
	|				Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КартинкаПриоритета
	|ИЗ
	|	Документ.ЗаказКлиента КАК Заказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗаказы1 КАК ТаблицаЗаказы1
	|		ПО Заказы.Ссылка = ТаблицаЗаказы1.ЗаказКлиента
	|ГДЕ
	|	ТаблицаЗаказы1.КОформлению > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Заявки.Ссылка,
	|	ТИПЗНАЧЕНИЯ(Заявки.Ссылка),
	|	Заявки.Дата,
	|	Заявки.Номер,
	|	Заявки.Партнер,
	|	Заявки.Контрагент,
	|	Заявки.Договор,
	|	Заявки.Соглашение,
	|	Заявки.Организация,
	|	Заявки.Склад,
	|	Заявки.Валюта,
	|	Заявки.Менеджер,
	|	Заявки.Статус,
	|	Заявки.СуммаДокумента,
	|	Заявки.Приоритет,
	|	Заявки.ХозяйственнаяОперация,
	|	Заявки.НалогообложениеНДС,
	|	Заявки.ЦенаВключаетНДС,
	|	Заявки.ПорядокРасчетов,
	|	Заявки.Комментарий,
	|	ВЫБОР
	|		КОГДА Заявки.Приоритет В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				Приоритеты.Ссылка КАК Приоритет
	|			ИЗ
	|				Справочник.Приоритеты КАК Приоритеты
	|
	|			УПОРЯДОЧИТЬ ПО
	|				Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заявки.Приоритет В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				Приоритеты.Ссылка КАК Приоритет
	|			ИЗ
	|				Справочник.Приоритеты КАК Приоритеты
	|
	|			УПОРЯДОЧИТЬ ПО
	|				Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК Заявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗаказы2 КАК ТаблицаЗаказы2
	|		ПО Заявки.Ссылка = ТаблицаЗаказы2.ЗаказКлиента
	|ГДЕ
	|	ТаблицаЗаказы2.КОформлению > 0";
	
	Запрос.УстановитьПараметр("Организация",				Параметры.Отбор.Организация);
	Запрос.УстановитьПараметр("Контрагент",					Параметры.Отбор.Контрагент);
	Запрос.УстановитьПараметр("Валюта",						Параметры.Отбор.Валюта);
	Запрос.УстановитьПараметр("Партнер",					Параметры.Отбор.Партнер);
	Запрос.УстановитьПараметр("НалогообложениеНДС",			Параметры.Отбор.НалогообложениеНДС);
	Запрос.УстановитьПараметр("Соглашение",					Параметры.Отбор.Соглашение);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС",			Параметры.Отбор.ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("Сделка",						Параметры.Отбор.Сделка);
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару",	Параметры.Отбор.ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару",		Параметры.Отбор.ТребуетсяЗалогЗаТару);
	Запрос.УстановитьПараметр("Договор",					Параметры.Отбор.Договор);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",	Параметры.Отбор.НаправлениеДеятельности);
		
	Запрос.УстановитьПараметр("Регистратор", Параметры.Регистратор);
	Запрос.УстановитьПараметр("Склад", Параметры.Склад);
	
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", 
								ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	Запрос.УстановитьПараметр("ИспользоватьНаправленияДеятельности", 
								ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности"));
	
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.ХозяйственнаяОперация) Тогда
			
			СписокОпераций = Документы.РеализацияТоваровУслуг.ДопустимыеОперацииДокументовОснований(Параметры.Отбор.ХозяйственнаяОперация);
			
			Условие = "	И ";
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", СписокОпераций);
			
		Иначе
			
			СписокОпераций = Новый СписокЗначений;
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера);
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя);
			
			Условие = "	И НЕ ";
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", СписокОпераций);
			
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
									"//УсловиеХозяйственнойОперацииЗаказы",
									Условие + "Заказы.ХозяйственнаяОперация В (&СписокХозяйственныхОпераций)");
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
									"//УсловиеХозяйственнойОперацииЗаявки",
									Условие + "Заявки.ХозяйственнаяОперация В (&СписокХозяйственныхОпераций)");
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	СписокРаспоряжений.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

