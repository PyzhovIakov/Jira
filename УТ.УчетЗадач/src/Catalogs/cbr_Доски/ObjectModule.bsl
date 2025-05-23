#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕстьNull(КОЛИЧЕСТВО(cbr_Доски.Ссылка), 0) КАК Количество
	|ИЗ
	|	Справочник.cbr_Доски КАК cbr_Доски
	|ГДЕ
	|	cbr_Доски.ДоскаПоУмолчанию";

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Если Выборка.Следующий() Тогда
		Если Выборка.Количество > 0 И ДоскаПоУмолчанию Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю("Может быть только 1 доска по умолчанию");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#КонецЕсли