#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Очищает привязку пользователя к определенному узлу 1С:Документооборота.
//
// Параметры:
//   Пользователь - ОпределяемыйТип.Пользователь - пользователь.
//
Процедура ОчиститьПривязку(Пользователь) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Удалить();
	
КонецПроцедуры

// Получает узел 1С:Документооборота, к которому отнесен пользователь.
//
// Параметры:
//   Пользователь - ОпределяемыйТип.Пользователь - пользователь.
//
// Возвращаемое значение:
//   Строка - идентификатор узла.
//
Функция УзелПользователя(Пользователь) Экспорт
	
	ИдентификаторУзла = УзлыПользователей()[Пользователь];
	Если ИдентификаторУзла = Неопределено Тогда
		ИдентификаторУзла = "";
	КонецЕсли;
	
	Возврат ИдентификаторУзла;
	
КонецФункции

// Получает все соответствия пользователей узлам 1С:Документооборота, установленные вручную.
//
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//     * Ключ - ОпределяемыйТип.Пользователь - пользователь.
//     * Значение - Строка - идентификатор узла.
//
Функция УзлыПользователей() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СоответствиеПользователейУзлам1СДокументооборота.Пользователь,
		|	СоответствиеПользователейУзлам1СДокументооборота.ИдентификаторУзла
		|ИЗ
		|	РегистрСведений.СоответствиеПользователейУзлам1СДокументооборота КАК СоответствиеПользователейУзлам1СДокументооборота");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Пользователь, Выборка.ИдентификаторУзла);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает соответствие пользователя определенному узлу 1С:Документооборота.
//
// Параметры:
//   Пользователь - ОпределяемыйТип.Пользователь - пользователь.
//   ИдентификаторУзла - Строка - идентификатор узла.
//
Процедура УстановитьУзелПользователя(Пользователь, ИдентификаторУзла) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь = Пользователь;
	Запись.ИдентификаторУзла = ИдентификаторУзла;
	
	НаборЗаписей.Записать();
	
	Если Пользователи.ТекущийПользователь() = Пользователь Тогда
		ПараметрыСеанса.ИнтеграцияС1СДокументооборотУзел = ИдентификаторУзла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает соответствие группы пользователей определенному узлу 1С:Документооборота.
//
// Параметры:
//   МассивПользователей - Массив из ОпределяемыйТип.Пользователь - список пользователей.
//   ИдентификаторУзла - Строка - идентификатор узла.
//
Процедура УстановитьУзелПользователей(МассивПользователей, ИдентификаторУзла) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Для Каждого Пользователь Из МассивПользователей Цикл
			УстановитьУзелПользователя(Пользователь, ИдентификаторУзла);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли