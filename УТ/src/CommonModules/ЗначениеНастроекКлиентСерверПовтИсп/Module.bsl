
#Область ПрограммныйИнтерфейс

// Возвращает значение основной страны учета
// 
// Возвращаемое значение:
// 	СправочникСсылка.СтраныМира - 
Функция ОсновнаяСтрана() Экспорт
	
	Возврат ЗначениеНастроекВызовСервера.ОсновнаяСтрана();
	
КонецФункции

// Возвращает страну регистрации организации. Если передана организация, то возвращает страну регистрации организации.
// Если организация не передана, то основную страну.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - Валюта, которую нужно заполнить.
//
// Возвращаемое значение:
//   СправочникСсылка.Валюты - валюта по умолчанию.
//
Функция СтранаРегистрацииОрганизации(Знач Организация = Неопределено) Экспорт
	
	Возврат ЗначениеНастроекВызовСервера.СтранаРегистрацииОрганизации(Организация);
	
КонецФункции

// Возвращает валюту регламентированного учета, определенную для организации.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - Организация, для которой надо получить валюту регламентированного учета.
//
// Возвращаемое значение:
//   СправочникСсылка.Валюты - 
//
Функция ВалютаРегламентированногоУчетаОрганизации(Знач Организация) Экспорт
	
	Возврат ЗначениеНастроекВызовСервера.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
КонецФункции

#КонецОбласти
