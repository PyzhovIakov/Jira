#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции
Процедура ЗаписатьСтатусЗадачи(Задача, Статус, Период) Экспорт
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = Период;
	МенеджерЗаписи.Задача = Задача;
	МенеджерЗаписи.Статус = Статус;
	МенеджерЗаписи.Записать();
КонецПроцедуры
#КонецОбласти
#КонецЕсли