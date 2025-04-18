
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПлана = Параметры.ВидПлана;
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Выбрать автоматически'");
	НоваяСтрока.ИмяВСервисе = "auto";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Модель 1с'");
	НоваяСтрока.ИмяВСервисе = "1C_model";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Наивная модель (последнее известное значение продаж)'");
	НоваяСтрока.ИмяВСервисе = "naive";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Наивная недельная (значение за аналогичный день предыдущей недели)'");
	НоваяСтрока.ИмяВСервисе = "week_ago";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Наивная годовая (значение за аналогичный день предыдущего года)'");
	НоваяСтрока.ИмяВСервисе = "season_last";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Экспоненциальное сглаживание'");
	НоваяСтрока.ИмяВСервисе = "exp_smoothing";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Экспоненциальное сглаживание на логарифмированных данных'");
	НоваяСтрока.ИмяВСервисе = "exp_smoothing_log";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Скользящее среднее'");
	НоваяСтрока.ИмяВСервисе = "rolling_mean3";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Скользящее среднее на логарифмированных данных'");
	НоваяСтрока.ИмяВСервисе = "rolling_mean3_log";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Сезонная модель'");
	НоваяСтрока.ИмяВСервисе = "season_mean";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Модель Тригга-Лича'");
	НоваяСтрока.ИмяВСервисе = "TL_model";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'Экспоненциальное сглаживание с учетом тренда и сезонности'");
	НоваяСтрока.ИмяВСервисе = "ESTS_model";
	
	НоваяСтрока = МоделиПрогнозирования.Добавить();
	НоваяСтрока.Имя = НСтр("ru = 'RNN (рекуррентные нейронные сети)'");
	НоваяСтрока.ИмяВСервисе = "rnn_model";
	
	Попытка
		СтруктураОтвета = СервисПрогнозирования.ПолучитьКачествоМоделей(ВидПлана);
		
		Если ТипЗнч(СтруктураОтвета.ДесериализованноеЗначение) <> Тип("Массив") Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ИсключенныйОбъект Из СтруктураОтвета.ДесериализованноеЗначение Цикл
			СтрокиМодели = МоделиПрогнозирования.НайтиСтроки(Новый Структура("ИмяВСервисе", ИсключенныйОбъект["model"]));
			Если СтрокиМодели.Количество() > 0 Тогда
				СтрокаМодели = СтрокиМодели[0];
				СтрокаМодели.КачествоMAE = Число(ИсключенныйОбъект["MAE"]);
				СтрокаМодели.КачествоMAPE = Число(ИсключенныйОбъект["MAPE"]);
				СтрокаМодели.КачествоPMAPE = Число(ИсключенныйОбъект["PMAPE"]);
				СтрокаМодели.КачествоRMSE = Число(ИсключенныйОбъект["RMSE"]);
				СтрокаМодели.КачествоSMAPE = Число(ИсключенныйОбъект["SMAPE"]);
				Если СтрокаМодели.КачествоMAPE > 1 Или СтрокаМодели.КачествоMAPE < -1 Тогда
					СтрокаМодели.КачествоТочность = 0;
				Иначе
					СтрокаМодели.КачествоТочность = (1 - СтрокаМодели.КачествоMAPE) * 100;
					СтрокаМодели.КачествоТочность1 = (1 - СтрокаМодели.КачествоPMAPE) * 100;
					СтрокаМодели.КачествоТочность2 = (1 - СтрокаМодели.КачествоSMAPE) * 100;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Исключение
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			СервисПрогнозированияПереопределяемый.ТекстСобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Неопределено, 
			Неопределено, 
			ПредставлениеОшибки);
	КонецПопытки;
	
	ШаблонСтроки = НСтр("ru = 'Выберите модель прогнозирования для загрузки результата расчета по виду плана: %1.'");
	ТекстТребуетсяВыбратьМодель = СтроковыеФункции.ФорматированнаяСтрока(ШаблонСтроки, ВидПлана);
	Элементы.ДекорацияПодсказка.Заголовок = ТекстТребуетсяВыбратьМодель;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МоделиПрогнозированияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Выбрать(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущаяСтрока = Элементы.МоделиПрогнозирования.ТекущиеДанные;
	
	ВыбранноеЗначение = "auto";
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыбранноеЗначение = ТекущаяСтрока.ИмяВСервисе;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура();
	ПараметрыОповещения.Вставить("ИмяВСервисе", ВыбранноеЗначение);
	
	Оповестить("ВыборМоделиПрогнозирования", ПараметрыОповещения, ВладелецФормы);
	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

