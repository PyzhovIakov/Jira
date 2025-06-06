#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции
Процедура ЗаписатьСтатусЗадачи(Задача, Статус, Период) Экспорт
	НачатьТранзакцию();
	Попытка
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = Период;
		МенеджерЗаписи.Задача = Задача;
		МенеджерЗаписи.Статус = Статус;
		МенеджерЗаписи.Записать();
		
		МенеджерЗаписи = РегистрыСведений.cbr_СобытияПоЗадачам.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Дата = ТекущаяДатаСеанса();
		МенеджерЗаписи.АвторСобытия = Пользователи.АвторизованныйПользователь();
		МенеджерЗаписи.Задача = Задача;
		МенеджерЗаписи.Событие = СтрШаблон("Установлен статус %1", Статус);
		МенеджерЗаписи.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
КонецПроцедуры
#КонецОбласти
#КонецЕсли