#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// ERP Начало
	//++ Локализация


	//-- Локализация
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	// ERP конец
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Представление = РегистрыСведений.ДокументыФизическихЛиц.ПредставлениеЗаписи(Запись);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// ERP Начало
	//++ Локализация


	//-- Локализация
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	// ERP Конец
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДокументов",	Выгрузить(, "Физлицо, Период, ЯвляетсяДокументомУдостоверяющимЛичность"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокументов.Физлицо КАК Физлицо,
	|	ТаблицаДокументов.Период КАК Период
	|ПОМЕСТИТЬ ВТ_Документы
	|ИЗ
	|	&ТаблицаДокументов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.ЯвляетсяДокументомУдостоверяющимЛичность
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Документы КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыФизическихЛиц.Физлицо,
	|	ДокументыФизическихЛиц.Период
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) > 1";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстСообщения = НСтр("ru = 'На %1 у физлица %2 уже введен документ, удостоверяющий личность.'");
	
	Пока Выборка.Следующий() Цикл
		Отказ = Истина;
		
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Выборка.Период, "ДЛФ=D"), Выборка.Физлицо));
	КонецЦикла;
	
	//++ Локализация


	//-- Локализация
	
	// +CRM_Модуль
	CRM_Модуль_ОбщегоНазначенияСервер.ПроверкаПриЗаписиДокументовФизическихЛиц(ЭтотОбъект);
	// -CRM_Модуль
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	//++ Локализация
	Для Каждого Запись Из ЭтотОбъект Цикл
		СтруктураЗаписи = Новый Структура("Период, Физлицо, ВидДокумента");
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
		
		КлючЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьКлючЗаписи(СтруктураЗаписи);
		
		Если Не ПустаяСтрока(Запись.Серия) Тогда
			ТекстОшибки = "";
			Отказ = Не ДокументыФизическихЛицКлиентСервер.СерияДокументаУказанаПравильно(Запись.ВидДокумента, Запись.Серия, ТекстОшибки) Или Отказ;
			Если Не ПустаяСтрока(ТекстОшибки) Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.Серия");
			КонецЕсли;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Запись.Номер) Тогда
			ТекстОшибки = "";
			Отказ = Не ДокументыФизическихЛицКлиентСервер.НомерДокументаУказанПравильно(Запись.ВидДокумента, Запись.Номер, ТекстОшибки) Или Отказ;
			Если Не ПустаяСтрока(ТекстОшибки) Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.Номер");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли