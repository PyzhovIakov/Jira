
////////////////////////////////////////////////////////////////////////////////
// CRM режим форм закладки сервер повт исп
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает признак использования режима закладок.
//
// Возвращаемое значение:
//	Булево	- признак использования режима закладок.
//
Функция ИспользуетсяРежимЗакладок() Экспорт
	Настройки = CRM_ОбщегоНазначенияСервер.ПолучитьНастройкиКлиентскогоПриложения();
	
	Если Настройки.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		
		Возврат CRM_ОбщегоНазначенияСервер.ЕстьпанельИнтерфейса("ПанельОткрытых");
		
	Иначе
		
		Если Настройки = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат (Настройки.РежимОткрытияФормВЗакладках = Истина);
		КонецЕсли;
		
	КонецЕсли;
КонецФункции

#КонецОбласти
