#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаСписка" ИЛИ (ВидФормы = "ФормаОбъекта" И Параметры.Свойство("Ключ")) Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "Обработка.CRM_Мессенджер.Форма.ФормаМессенджера";
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Данные.Наименование) Тогда
		СтандартнаяОбработка = Ложь;
		Представление = Данные.Код;
	КонецЕсли;
	Представление = НСтр("ru = 'Диалог'; en = 'Dialog'") + ": " + Представление;
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Наименование");
	Поля.Добавить("Код");
	Поля.Добавить("ДатаНачала");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Создает диалог
//
// Параметры:
//  Параметры	 - Структура - Параметры создания диалога
// 
// Возвращаемое значение:
//  СправочникСсылка.CRM_Диалоги - Элемент справочника Диалоги
//
Функция СоздатьДиалог(Параметры) Экспорт
	
	Если ТипЗнч(Параметры) = Тип("СправочникСсылка.CRM_Диалоги") Тогда
		Диалог = Параметры.Скопировать();
	Иначе
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "ЭтоНомерТелефона")
				И Параметры.ЭтоНомерТелефона Тогда
			ID_Пользователя = НомерВИдентификаторWhatsApp(Параметры.ID_Пользователя);
			Группа = НомерВИдентификаторWhatsApp(Параметры.Группа);
		Иначе
			ID_Пользователя = Параметры.ID_Пользователя;
			Группа = Параметры.Группа;
		КонецЕсли;
		
		Диалог = СоздатьЭлемент();
		Диалог.ID_Пользователя = ID_Пользователя;
		Диалог.Группа = Группа;
		Диалог.ГруппаПредставление = Параметры.ГруппаПредставление;
		Диалог.Контакт = Параметры.Контакт;
		Диалог.КонтактПредставление =
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Строка(Параметры.КонтактПредставление));
		Диалог.УчетнаяЗапись = Параметры.УчетнаяЗапись;
		Диалог.ДатаНачала = ТекущаяДатаСеанса();
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "Ответственный") Тогда
			Диалог.Ответственный = Параметры.Ответственный;
		КонецЕсли;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "CRM_РольОтветственного") Тогда
			Диалог.CRM_РольОтветственного = Параметры.CRM_РольОтветственного;
		КонецЕсли;
		Если Параметры.Свойство("Служебный") Тогда
			Диалог.Служебный = Параметры.Служебный;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Диалог.Ответственный) Тогда
		Диалог.CRM_РольОтветственного = Параметры.УчетнаяЗапись.CRM_РольОтветственного;
		Справочники.CRM_ПравилаОбработкиОбращений.ПрименитьПравило(Диалог);
		Если Не ЗначениеЗаполнено(Диалог.Ответственный) Тогда
			Диалог.Ответственный = Параметры.УчетнаяЗапись.Ответственный;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Диалог.Контакт) И ЗначениеЗаполнено(Диалог.ID_Пользователя) Тогда
		CRM_КлиентыСервер.СоздатьКонтактВзаимодействия(Диалог);
	КонецЕсли;
	
	// Связыване нового диалога с интересом. Например при создании его из ленты
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "CRM_ТаблицаИнтересов") Тогда
		Диалог.ДополнительныеСвойства.Вставить("CRM_ТаблицаИнтересов", Параметры.CRM_ТаблицаИнтересов);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "Основание")
		 И ЗначениеЗаполнено(Параметры["Основание"]) Тогда
		Диалог.ДокументОснование = Параметры["Основание"];
	КонецЕсли;
	
	Диалог.Записать();
	
	Если ЗначениеЗаполнено(Диалог.Группа) 
		И ЗначениеЗаполнено(Диалог.ID_Пользователя)
		И Диалог.Группа <> Диалог.ID_Пользователя
		И ТипЗнч(Параметры) = Тип("Структура") Тогда
		Параметры.ID_Пользователя = "";
		Параметры.Контакт = Неопределено;
		Параметры.КонтактПредставление = "";
		ДиалогДляОтправкиВГруппу = ПолучитьАктивныйДиалог(Параметры);
	КонецЕсли;
	
	Возврат Диалог.Ссылка;
	
КонецФункции

// Изменяет статус диалога на "Принят в работу"
//
// Параметры:
//  Диалог	 - СправочникСсылка.CRM_Диалоги	 - Элемент справочника Диалоги
//
Процедура ПринятьДиалог(Диалог) Экспорт
	
	ДиалогОбъект = Диалог.ПолучитьОбъект();
	ДиалогОбъект.Статус = Перечисления.CRM_СтатусыДиалогов.ПринятВРаботу;
	ДиалогОбъект.ДатаПринятия = ТекущаяДатаСеанса();
	ДиалогОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
	Действие = Перечисления.CRM_ДействияСДиалогами.ПринятВРаботу;
	ДобавитьДействие(ДиалогОбъект, Действие);
	
	ДиалогОбъект.Записать(); 
	
КонецПроцедуры

// Изменяет статус диалога на "Закрыт"
//
// Параметры:
//  Диалог			 - СправочникСсылка.CRM_Диалоги	 - Элемент справочника Диалоги
//  АвтоЗавершение	 - Булево						 - Признак автоматического завершения диалога
//
Процедура ЗавершитьДиалог(Диалог, АвтоЗавершение = Ложь) Экспорт
	
	ДиалогОбъект = Диалог.ПолучитьОбъект();
	ДиалогОбъект.Статус = Перечисления.CRM_СтатусыДиалогов.Закрыт;
	ДиалогОбъект.ДатаЗавершения = ТекущаяДатаСеанса();
	
	Если АвтоЗавершение Тогда
		Действие = Перечисления.CRM_ДействияСДиалогами.ЗавершенАвтоматически;
	Иначе
		Действие = Перечисления.CRM_ДействияСДиалогами.Завершен;
	КонецЕсли;
	
	ДобавитьДействие(ДиалогОбъект, Действие);
	
	ДиалогОбъект.Записать();
	
КонецПроцедуры

// Изменяет статус диалога на "ПереданДляОзнакомления"
//
// Параметры:
//  Диалог			 - СправочникСсылка.CRM_Диалоги	 - Элемент справочника Диалоги
//
Процедура ПередатьДиалогДляОзнакомления(Диалог) Экспорт
	
	ДиалогОбъект = Диалог.ПолучитьОбъект();
	ДиалогОбъект.Статус = Перечисления.CRM_СтатусыДиалогов.ПереданДляОзнакомления;
	
	Действие = Перечисления.CRM_ДействияСДиалогами.ПереданДляОзнакомления;
	ДобавитьДействие(ДиалогОбъект, Действие);
	
	ДиалогОбъект.Записать();
	
КонецПроцедуры

// Добавляет действие с диалогом
//
// Параметры:
//  Диалог			 - СправочникСсылка.CRM_Диалоги		 - Элемент справочника Диалоги
//  Действие		 - ПеречислениеСсылка.CRM_ДействияСДиалогами - Добавляемое действие
//  Дата			 - Дата										 - Дата
//  Пользователь	 - СправочникСсылка.Пользователи			 - Пользователь
//  ОбъектДействия	 - ДокументСсылка.CRM_Интерес				 - Объект действия
//                   - ЗадачаСсылка.ЗадачаИсполнителя
//                   - БизнесПроцессСсылка.CRM_БизнесПроцесс
//                   - СправочникСсылка.Пользователи
//                   - Неопределено
//  ОписаниеДействия - Строка									 - Дополнительно описание действия
//
Процедура ДобавитьДействие(Диалог, Действие, Дата = Неопределено, Пользователь = Неопределено,
	 ОбъектДействия = Неопределено,
	 ОписаниеДействия = Неопределено) Экспорт

	Если ТипЗнч(Диалог) = Тип("СправочникСсылка.CRM_Диалоги") Тогда
		ДиалогОбъект = Диалог.ПолучитьОбъект();
	ИначеЕсли ТипЗнч(Диалог) = Тип("СправочникОбъект.CRM_Диалоги") Тогда
		ДиалогОбъект = Диалог;
	Иначе
		Возврат;
	КонецЕсли;
	
	НовДействие = ДиалогОбъект.ДействияСДиалогом.Добавить();
	НовДействие.Действие = Действие;
	НовДействие.Дата = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	НовДействие.Пользователь = ?(ЗначениеЗаполнено(Пользователь), Пользователь, Пользователи.ТекущийПользователь());
	НовДействие.ОбъектДействия = ОбъектДействия;
	НовДействие.Описание = ОписаниеДействия;

	Если ТипЗнч(Диалог) = Тип("СправочникСсылка.CRM_Диалоги") Тогда
		ДиалогОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет поиск активного диалога. Если не найден - создает новый.
//
// Параметры:
//  Параметры	 - Структура - Параметры создания диалога
// 
// Возвращаемое значение:
//  СправочникСсылка.CRM_Диалоги - Элемент справочника Диалоги
//
Функция ПолучитьАктивныйДиалог(Параметры) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	CRM_Диалоги.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_Диалоги КАК CRM_Диалоги
	|ГДЕ
	|	CRM_Диалоги.ID_Пользователя = &ID_Пользователя
	|	И CRM_Диалоги.Группа = &Группа
	|	И CRM_Диалоги.УчетнаяЗапись = &УчетнаяЗапись
	|	И CRM_Диалоги.Контакт = &Контакт
	|	И НЕ CRM_Диалоги.Статус = ЗНАЧЕНИЕ(Перечисление.CRM_СтатусыДиалогов.Закрыт)
	|	И НЕ CRM_Диалоги.Служебный");
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "ЭтоНомерТелефона")
		 И Параметры.ЭтоНомерТелефона Тогда
		Если ЗначениеЗаполнено(Параметры.ID_Пользователя) Тогда
		 	ID_Пользователя = НомерВИдентификаторWhatsApp(Параметры.ID_Пользователя);
		Иначе
			ID_Пользователя = "";
		КонецЕсли;
		Группа = НомерВИдентификаторWhatsApp(Параметры.Группа);
	Иначе
		ID_Пользователя = Параметры.ID_Пользователя;
		Группа = Параметры.Группа;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ID_Пользователя", ID_Пользователя);
	Запрос.УстановитьПараметр("Группа", Группа);
	Запрос.УстановитьПараметр("УчетнаяЗапись", Параметры.УчетнаяЗапись);
	Запрос.УстановитьПараметр("Контакт", Параметры.Контакт);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		НовыйДиалог = СоздатьДиалог(Параметры);
		Возврат НовыйДиалог.Ссылка;
	Иначе	
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

// Выполняет поиск служебного диалога. Если не найден - создает новый.
//
// Параметры:
//  Параметры	 - Структура - Параметры создания диалога
// 
// Возвращаемое значение:
//  СправочникСсылка.CRM_Диалоги - Элемент справочника Диалоги
//
Функция ПолучитьСлужебныйДиалог(Параметры) Экспорт
	
	Параметры.Вставить("Служебный", Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	CRM_Диалоги.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.CRM_Диалоги КАК CRM_Диалоги
	|ГДЕ
	|	CRM_Диалоги.ID_Пользователя = &ID_Пользователя
	|	И CRM_Диалоги.Группа = &Группа
	|	И CRM_Диалоги.УчетнаяЗапись = &УчетнаяЗапись
	|	И CRM_Диалоги.Контакт = &Контакт
	|	И CRM_Диалоги.Служебный");
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "ЭтоНомерТелефона")
		 И Параметры.ЭтоНомерТелефона Тогда
		ID_Пользователя = НомерВИдентификаторWhatsApp(Параметры.ID_Пользователя);
		Группа = НомерВИдентификаторWhatsApp(Параметры.Группа);
	Иначе
		ID_Пользователя = Параметры.ID_Пользователя;
		Группа = Параметры.Группа;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ID_Пользователя", ID_Пользователя);
	Запрос.УстановитьПараметр("Группа", Группа);
	Запрос.УстановитьПараметр("УчетнаяЗапись", Параметры.УчетнаяЗапись);
	Запрос.УстановитьПараметр("Контакт", Параметры.Контакт);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		НовыйДиалог = СоздатьДиалог(Параметры);
		Возврат НовыйДиалог.Ссылка;
	Иначе	
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

// Проверяет наличие связи диалога с интересом. Если интерес не передан, то наличие связи с любым интересом.
//
// Параметры:
//  Диалог	 - 	 - Справочники.CRM_Диалоги.Ссылка	 - диалог, для которго проверяется наличие связи
//  Интерес	 - 	 - Дкументы.CRM_Интерес.Ссылка	 - интерес, для которого проверяется наличие связи
// 
// Возвращаемое значение:
//  Булево - наличие связи диалога с интересом
//
Функция СвязанСИнтересом(Диалог, Интерес = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	CRM_ЖурналДокументов.CRM_Интерес КАК Ссылка,
	               |	CRM_ЖурналДокументов.СостояниеИнтереса КАК СостояниеИнтереса,
	               |	CRM_ЖурналДокументов.ОсновнойИнтерес КАК ОсновнойИнтерес,
	               |	CRM_ЖурналДокументов.ИнтересЯвляетсяОснованием КАК ВведенНаОсновании
	               |ИЗ
	               |	РегистрСведений.CRM_ЖурналДокументов КАК CRM_ЖурналДокументов
	               |ГДЕ
	               |	CRM_ЖурналДокументов.Объект = &Объект
	               |	%1
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ОсновнойИнтерес УБЫВ";
	
	Запрос.УстановитьПараметр("Объект", Диалог);
	Запрос.УстановитьПараметр("Интерес", Интерес);
	
	Если ЗначениеЗаполнено(Интерес) Тогда
		ТекстЗапроса = СтрШаблон(ТекстЗапроса, "И CRM_ЖурналДокументов.CRM_Интерес = &Интерес");
	Иначе	
		ТекстЗапроса = СтрШаблон(ТекстЗапроса,
			 "И НЕ CRM_ЖурналДокументов.CRM_Интерес = ЗНАЧЕНИЕ(Документ.CRM_Интерес.ПустаяСсылка)");
	КонецЕсли;
	Запрос.Текст = ТекстЗапроса;
    
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции // ()

// Функция возвращает идентификатор WhatsApp по переданному номеру
//
// Параметры:
//  Номер	 - Строка	 - Номер
// 
// Возвращаемое значение:
//   - Строка
//
Функция НомерВИдентификаторWhatsApp(Номер) Экспорт
	
	Возврат Номер + "@c.us";
	
КонецФункции // НомерВИдентификаторWhatsApp()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПереходНаНовуюВерсию

#КонецОбласти

#КонецОбласти

#КонецЕсли
