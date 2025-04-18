#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗарегистрированныеДубли(Контакт) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ДублиКлиентовИКонтактов.Оригинал КАК Оригинал
	                      |ПОМЕСТИТЬ ВТОригинал
	                      |ИЗ
	                      |	РегистрСведений.CRM_ДублиКлиентовИКонтактов КАК CRM_ДублиКлиентовИКонтактов
	                      |ГДЕ
	                      |	CRM_ДублиКлиентовИКонтактов.Контакт = &ТекОбъект
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	CRM_ДублиКлиентовИКонтактов.Контакт КАК Контакт,
	                      |	CRM_ДублиКлиентовИКонтактов.Заменить КАК Заменить,
	                      |	CRM_ДублиКлиентовИКонтактов.Комментарий КАК Комментарий,
	                      |	CRM_ДублиКлиентовИКонтактов.Дата КАК Дата,
	                      |	CRM_ДублиКлиентовИКонтактов.Автор КАК Автор,
	                      |	ЛОЖЬ КАК ЭтоОригинал
	                      |ИЗ
	                      |	РегистрСведений.CRM_ДублиКлиентовИКонтактов КАК CRM_ДублиКлиентовИКонтактов
	                      |ГДЕ
	                      |	CRM_ДублиКлиентовИКонтактов.Оригинал = &ТекОбъект
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	CRM_ДублиКлиентовИКонтактов.Оригинал,
	                      |	ЛОЖЬ,
	                      |	CRM_ДублиКлиентовИКонтактов.Комментарий,
	                      |	CRM_ДублиКлиентовИКонтактов.Дата,
	                      |	CRM_ДублиКлиентовИКонтактов.Автор,
	                      |	ИСТИНА
	                      |ИЗ
	                      |	РегистрСведений.CRM_ДублиКлиентовИКонтактов КАК CRM_ДублиКлиентовИКонтактов
	                      |ГДЕ
	                      |	CRM_ДублиКлиентовИКонтактов.Контакт = &ТекОбъект
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	CRM_ДублиКлиентовИКонтактов.Контакт,
	                      |	CRM_ДублиКлиентовИКонтактов.Заменить,
	                      |	CRM_ДублиКлиентовИКонтактов.Комментарий,
	                      |	CRM_ДублиКлиентовИКонтактов.Дата,
	                      |	CRM_ДублиКлиентовИКонтактов.Автор,
	                      |	ЛОЖЬ
	                      |ИЗ
	                      |	ВТОригинал КАК ВТОригинал
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.CRM_ДублиКлиентовИКонтактов КАК CRM_ДублиКлиентовИКонтактов
	                      |		ПО ВТОригинал.Оригинал = CRM_ДублиКлиентовИКонтактов.Оригинал
	                      |ГДЕ
	                      |	CRM_ДублиКлиентовИКонтактов.Контакт <> &ТекОбъект");
	Запрос.УстановитьПараметр("ТекОбъект", Контакт);
	ТаблицаДублей = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаДублей;
КонецФункции

Функция МассивИсключаемыхМетаданных() Экспорт
	Исключить = Новый Массив;
	Исключить.Добавить(Метаданные.РегистрыСведений.CRM_ДублиКлиентовИКонтактов);
	Исключить.Добавить(Метаданные.РегистрыСведений.CRM_ДанныеДляПоискаКонтактов);
	Исключить.Добавить(Метаданные.РегистрыСведений.CRM_ИсторияРеквизитовОбъектов);
	Исключить.Добавить(Метаданные.РегистрыСведений.CRM_ЗаполненностьРеквизитовОбъектов);
	Возврат Исключить;
КонецФункции

#КонецОбласти

#КонецЕсли