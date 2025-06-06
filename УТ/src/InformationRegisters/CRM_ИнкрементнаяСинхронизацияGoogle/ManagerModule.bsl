#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает токен, используемый для инкрементной синхронизации, с помощью которого можно получить данные,
// изменившиеся с момента последней синхронизации
//
//
// Параметры:
//  Предмет  - СправочникСсылка.КалендариGoogle - Ссылка на календарь, для которого следует получить синхротокен.
//
// 
// Возвращаемое значение:
//  Строка - Токен синхронизации.
//  
Функция СинхроТокен(Предмет) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИнкрементнаяСинхронизация.СинхроТокен КАК СинхроТокен
	|ИЗ
	|	РегистрСведений.CRM_ИнкрементнаяСинхронизацияGoogle КАК ИнкрементнаяСинхронизация
	|ГДЕ
	|	ИнкрементнаяСинхронизация.Предмет = &Предмет");
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.СинхроТокен;
	
КонецФункции

// Записывает токен синхронизации в регистр
//
// Параметры:
//  Предмет		 - СправочникСсылка.КалендариGoogle - ссылка на календарь, для которого следует сохранить синхротокен.
//  СинхроТокен	 - Строка - токен синхронизации, полученный от Google в очередном сеансе связи.
//  
Процедура ЗаписатьСинхроТокен(Предмет, СинхроТокен) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.CRM_ИнкрементнаяСинхронизацияGoogle.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Предмет = Предмет;
	МенеджерЗаписи.СинхроТокен = СинхроТокен;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
