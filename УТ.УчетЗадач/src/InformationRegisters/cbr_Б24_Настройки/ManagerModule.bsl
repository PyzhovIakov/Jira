Функция ПолучитьНастройкиИзРегистра(Знач ТипНастройки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	cbr_Б24_Настройки.Настройка,
		|	cbr_Б24_Настройки.Значение
		|ИЗ
		|	РегистрСведений.cbr_Б24_Настройки КАК cbr_Б24_Настройки
		|ГДЕ
		|	cbr_Б24_Настройки.ТипНастройки = &ТипНастройки";
	
	Запрос.УстановитьПараметр("ТипНастройки", ТипНастройки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	НастройкиБитрикс = Новый Структура();
	
	Пока Выборка.Следующий() Цикл
		НастройкиБитрикс.Вставить(Выборка.Настройка, Выборка.Значение);
	КонецЦикла;
	
	Возврат НастройкиБитрикс;
	
КонецФункции