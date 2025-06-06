
#Область ПрограммныйИнтерфейс

// Настройки магазина.
// 
// Параметры:
//  Магазин - ПланОбменаСсылка.CRM_ИнтеграцииСИнтернетМагазинами - Магазин. 
// 
// Возвращаемое значение:
//  Структура - Данные доступа.
//
Функция НастройкиМагазина(Магазин) Экспорт
	ДанныеДоступа = Магазин.ХранилищеНастроек.Получить();
	Если ДанныеДоступа = Неопределено Тогда
		ДанныеДоступа = Новый Структура;
	КонецЕсли;
	ДанныеДоступа.Вставить("Магазин", Магазин);
	ДанныеДоступа.Вставить("ТипМагазина", Магазин.ТипИнтернетМагазина);
	ДанныеДоступа.Вставить("МодульМенеджера", МодульМенеджера(Магазин.ТипИнтернетМагазина));
	Возврат ДанныеДоступа;
КонецФункции
	
// Возвращает менеджер обработки для работы с магазином.
//
// Параметры:
//	ТипМагазина - Строка - Имя магазина.
// 
// Возвращаемое значение:
//  ОбработкаМенеджер - менеджер обработки для работы с сервисом.
//
Функция МодульМенеджера(ТипМагазина) Экспорт
	ИмяОбработки = "CRM_ИнтеграцияСМагазином" + ТипМагазина;
	МД = Метаданные.Обработки.Найти(ИмяОбработки);
	Если МД <> Неопределено Тогда
		Возврат Обработки[ИмяОбработки];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Получить картинку сервиса.
//
// Параметры:
//  Магазин - ПланОбменаСсылка.CRM_ИнтеграцииСИнтернетМагазинами - Магазин. 
//	ИмяМакета	   - Строка - Имя макета.
//
// Возвращаемое значение:
//  Картинка - картинка сервиса.
//
Функция КартинкаСервиса(Магазин, ИмяМакета = "Иконка_16") Экспорт
	
	МодульМенеджера = МодульМенеджера(Магазин.ТипИнтернетМагазина);
	Если МодульМенеджера = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДанныеКартинки = МодульМенеджера.ПолучитьМакет(ИмяМакета);
	Картинка = Новый Картинка(ДанныеКартинки);
	Возврат Картинка;
	
КонецФункции

// Возвращает текст заголовка.
//
// Параметры:
//	ТипМагазина - Строка - Имя магазина.
// 
// Возвращаемое значение:
//  Строка - текст заголовка.
//
Функция ТекстЗаголовка(ТипМагазина) Экспорт
	МодульМенеджера = МодульМенеджера(ТипМагазина);
	Если МодульМенеджера = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Макет = МодульМенеджера.ПолучитьМакет("МакетФорматированнойСтроки");
	Заголовок = Макет.ПолучитьОбласть("Заголовок").ТекущаяОбласть.Текст;
	Возврат Заголовок;
КонецФункции

// Получить список сервисов
//
// Параметры:
//	РазмерИконки - Число - Размер иконки.
// 
// Возвращаемое значение:
//  СписокЗначений - Список сервисов.
//
Функция СписокИнтеграцийСМагазинами(РазмерИконки = 16) Экспорт
	СписокМессенджеров = Новый СписокЗначений;
	Для каждого Обработка Из Метаданные.Обработки Цикл
		Если СтрНайти(Обработка.Имя, "CRM_ИнтеграцияСМагазином") = 1 Тогда
			ТипМессенджера = СтрЗаменить(Обработка.Имя, "CRM_ИнтеграцияСМагазином", "");
			Если Обработка.Макеты.Найти("Иконка_" + Строка(РазмерИконки)) <> Неопределено Тогда
				МакетКартинки = Обработки[Обработка.Имя].ПолучитьМакет("Иконка_" + Строка(РазмерИконки));
				Картинка = Новый Картинка(МакетКартинки);
			Иначе
				Картинка = Неопределено;
			КонецЕсли;
			СписокМессенджеров.Добавить(ТипМессенджера, , , Картинка);
		КонецЕсли;
	КонецЦикла;
	Возврат СписокМессенджеров;
КонецФункции

// Запускает обмен с интернет-магазином.
//
// Параметры:
//	УникальныйИдентификаторЗадания - Строка - Уникальный идентификатор задания.
//	ТипМагазина					   - Строка - Имя магазина.
// 
Процедура CRM_ОбменСИнтернетМагазином(УникальныйИдентификаторЗадания = Неопределено, ТипМагазина = Неопределено) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.CRM_ОбменСИнтернетМагазином);

	Если ОбщегоНазначения.РазделениеВключено() И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	Если УникальныйИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ИнтеграцииСИнтернетМагазинами.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	ПланОбмена.CRM_ИнтеграцииСИнтернетМагазинами КАК CRM_ИнтеграцииСИнтернетМагазинами
	                      |ГДЕ
	                      |	CRM_ИнтеграцииСИнтернетМагазинами.УникальныйИдентификаторЗадания = &УникальныйИдентификаторЗадания
	                      |	И CRM_ИнтеграцииСИнтернетМагазинами.ТипИнтернетМагазина = &ТипМагазина");
	Запрос.УстановитьПараметр("УникальныйИдентификаторЗадания", УникальныйИдентификаторЗадания);
	Запрос.УстановитьПараметр("ТипМагазина", ТипМагазина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НастройкиМагазина = НастройкиМагазина(Выборка.Ссылка);
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Обмен с интернет-магазином.Начало обмена'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация, , НастройкиМагазина.Магазин);
		
		ДатаСеанса = ТекущаяДатаСеанса();
		
		НастройкиМагазина.МодульМенеджера.ВыполнитьОбмен(НастройкиМагазина);
	
		Магазин = НастройкиМагазина.Магазин.ПолучитьОбъект();
		Магазин.ДатаПоследнегоОбмена = ДатаСеанса;
		Магазин.ОбменДанными.Загрузка = Истина;
		Магазин.Записать();
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Обмен с интернет-магазином.Завершение обмена'",
			 ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация, , НастройкиМагазина.Магазин);
	КонецЕсли;

КонецПроцедуры

// Выполняет начальную регистрацию данных.
//
// Параметры:
//  Магазин - ПланОбменаСсылка.CRM_ИнтеграцииСИнтернетМагазинами - Магазин. 
// 
Процедура НачальнаяРегистрацияДанных(Магазин) Экспорт
	
	Настройки = НастройкиМагазина(Магазин);
	Настройки.МодульМенеджера.НачальнаяРегистрацияДанных(Настройки);
	
КонецПроцедуры

// Обработчик события ПриЗаписи подписки CRM_ОбменСИнтернетМагазиномПриЗаписиРегистра.
//
// Параметры:
//  Источник  - РегистрСведенийНаборЗаписей.ЦеныНоменклатуры - Источник события.
//	Отказ	  - Булево - Признак отказа.
//	Замещение - Булево - Признак замещения.
// 
Процедура CRM_ОбменСИнтернетМагазиномПриЗаписиРегистраПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("CRM_ИспользоватьИнтеграцииСИнтернетМагазинами") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ЦеныНоменклатуры") Тогда
		ТЗ = Источник.Выгрузить();
		ТЗ.Свернуть("Номенклатура");
		Для каждого Строка Из ТЗ Цикл
			РегистрацияОбъекта(Строка.Номенклатура);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗаписи подписки CRM_ОбменСИнтернетМагазиномПриЗаписиОбъекта.
//
// Параметры:
//  Источник - СправочникОбъект, ДокументОбъект - Источник события.
//	Отказ	 - Булево - Признак отказа.
// 
Процедура CRM_ОбменСИнтернетМагазиномПриЗаписиОбъектаПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("CRM_ИспользоватьИнтеграцииСИнтернетМагазинами") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.CRM_Интерес") Тогда
		Если НЕ (Источник.ДополнительныеСвойства.Свойство("ПредыдущееСостояниеИнтереса")
			И ЗначениеЗаполнено(Источник.ДополнительныеСвойства.ПредыдущееСостояниеИнтереса)
			И Источник.ДополнительныеСвойства.ПредыдущееСостояниеИнтереса <> Источник.СостояниеИнтереса) Тогда
			Возврат;
		КонецЕсли;
		Ссылка = Источник.ссылка;
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.Номенклатура") Тогда
		Если Источник.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		Ссылка = Источник.ссылка;
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.НоменклатураПрисоединенныеФайлы") Тогда
		Ссылка = Источник.ВладелецФайла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка.ВерсияДанных) Тогда
		РегистрацияОбъекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РегистрацияОбъекта(Ссылка)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ИнтеграцииСИнтернетМагазинами.Ссылка КАК Ссылка,
	                      |	CRM_ИнтеграцииСИнтернетМагазинами.ХранилищеНастроек КАК ХранилищеНастроек
	                      |ИЗ
	                      |	ПланОбмена.CRM_ИнтеграцииСИнтернетМагазинами КАК CRM_ИнтеграцииСИнтернетМагазинами
	                      |ГДЕ
	                      |	НЕ CRM_ИнтеграцииСИнтернетМагазинами.ПометкаУдаления
	                      |	И CRM_ИнтеграцииСИнтернетМагазинами.Включена");
	
	Выборка = Запрос.Выполнить().Выбрать();
	МассивМагазинов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Настройки = НастройкиМагазина(Выборка.Ссылка);
		Если Настройки.Свойство("ВыгружатьДанные") И Настройки.ВыгружатьДанные Тогда
			Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Номенклатура") 
				И НЕ Настройки.МодульМенеджера.ВыгружатьНоменклатуру(Настройки, Ссылка) Тогда
				Продолжить; 
			КонецЕсли;
			МассивМагазинов.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	ПланыОбмена.ЗарегистрироватьИзменения(МассивМагазинов, Ссылка);
	
КонецПроцедуры

#КонецОбласти
