////////////////////////////////////////////////////////////////////////////////
// Подсистема "Менеджер сервиса криптографии".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// (См. МенеджерСервисаКриптографии.СоздатьКонтейнерИЗапросНаСертификат)
// 
// Параметры: 
//  ИдентификаторЗаявления - Строка - идентификатор поиска запроса на сертификат.
//  СодержаниеЗапроса - Строка - содержит поля OID.
//  НомерТелефона - Строка - содержит идентификатор подтвержденного телефона
//  ЭлектроннаяПочта - Строка - содержит идентификатор подтвержденной эл. почты
//  ИдентификаторАбонента - Строка -Идентификатор абонента
//  НотариусАдвокатГлаваКФХ - Булево -Нотариус адвокат глава КФХ
// 
// Возвращаемое значение: 
//  Структура:
// * КраткоеПредставлениеОшибки - Строка
// * АдресДополнительногоРезультата - Строка
// * АдресРезультата - Строка
// * ИдентификаторЗадания - Неопределено
// * Статус - Строка
// (См. ДлительныеОперации.ВыполнитьВФоне)
Функция СоздатьКонтейнерИЗапросНаСертификат(ИдентификаторЗаявления,
										СодержаниеЗапроса,
										НомерТелефона,
										ЭлектроннаяПочта,
										ИдентификаторАбонента = Неопределено,
										НотариусАдвокатГлаваКФХ = Ложь) Экспорт
	
	ПараметрыПроцедуры 	= Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаявления", 	ИдентификаторЗаявления);
	ПараметрыПроцедуры.Вставить("СодержаниеЗапроса", 		СодержаниеЗапроса);
	ПараметрыПроцедуры.Вставить("НомерТелефона", 			НомерТелефона);
	ПараметрыПроцедуры.Вставить("ЭлектроннаяПочта", 		ЭлектроннаяПочта);
	ПараметрыПроцедуры.Вставить("ИдентификаторАбонента", 	ИдентификаторАбонента);
	ПараметрыПроцедуры.Вставить("НотариусАдвокатГлаваКФХ", 	НотариусАдвокатГлаваКФХ);
		
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне("МенеджерСервисаКриптографии.СоздатьКонтейнерИЗапросНаСертификат", 
						ПараметрыПроцедуры);
	
КонецФункции	

// (См. МенеджерСервисаКриптографии.УстановитьСертификатВКонтейнерИХранилище)
// 
// Параметры: 
//  ИдентификаторЗаявления - Строка - идентификатор поиска запроса на сертификат
//  ДанныеСертификата - ДвоичныеДанные - содержит данные сертификата в кодировке PEM.
// 
// Возвращаемое значение: 
//  Структура - Установить сертификат в контейнер и хранилище:
// * АдресРезультата - Строка -
// * ИдентификаторЗадания - Неопределено -
// * Статус - Строка -
// (См. ДлительныеОперации.ВыполнитьФункцию)
Функция УстановитьСертификатВКонтейнерИХранилище(ИдентификаторЗаявления, ДанныеСертификата) Экспорт
	
	ПараметрыПроцедуры 	= Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаявления",	ИдентификаторЗаявления);
	ПараметрыПроцедуры.Вставить("ДанныеСертификата", 		ДанныеСертификата);
		
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне("МенеджерСервисаКриптографии.УстановитьСертификатВКонтейнерИХранилище", 
					ПараметрыПроцедуры);
	
КонецФункции

#КонецОбласти
