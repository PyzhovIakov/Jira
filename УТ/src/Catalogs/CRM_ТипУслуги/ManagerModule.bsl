#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Функция - Массив типов услуг
// 
// Возвращаемое значение:
//  Массив - массив ссылок справочника CRM_ТипУслуги
//
Функция МассивТиповУслуг() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ТипУслуги.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_ТипУслуги КАК CRM_ТипУслуги");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

#КонецЕсли