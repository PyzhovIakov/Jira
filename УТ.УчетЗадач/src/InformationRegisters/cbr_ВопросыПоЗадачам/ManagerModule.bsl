#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область СлужебныеПроцедурыИФункции
// Создать запись в регистр сведений
// Параметры:
//  Задача - ДокументСсылка.cbr_Задача
//  Адресат - СправочникСсылка.Пользователи
//  Текст - Строка
//  ВидВопроса - ПеречислениеСсылка.cbr_ВидыВопросов.
Процедура ЗаписатьВопрос(Задача, Адресат, Текст, ВидВопроса) Экспорт
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Задача = Задача;
	МенеджерЗаписи.Адресат = Адресат;
	МенеджерЗаписи.Отправитель = Пользователи.АвторизованныйПользователь();
	МенеджерЗаписи.Дата = ТекущаяДатаСеанса();
	МенеджерЗаписи.Период = МенеджерЗаписи.Дата;
	МенеджерЗаписи.ТекстВопроса = Текст;
	МенеджерЗаписи.ВидВопроса = ВидВопроса;
	МенеджерЗаписи.Записать();
КонецПроцедуры
#КонецОбласти
#КонецЕсли