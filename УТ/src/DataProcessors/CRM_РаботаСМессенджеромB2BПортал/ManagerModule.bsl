#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбязательныеМетодыПрограмногоИнтерфейса

Функция ПолучитьСообщения(УчетнаяЗапись) Экспорт
	
	МассивСообщений = Новый Массив;
	
	Возврат МассивСообщений;
	
КонецФункции

Функция ОтправитьСообщение(Сообщение, УчетнаяЗапись, IDПользователя, СписокФайлов, ДопПараметры) Экспорт
	
	//УстановитьПривилегированныйРежим(Истина);
	//
	//СообщениеСВ = СистемаВзаимодействия.СоздатьСообщение(Новый ИдентификаторОбсужденияСистемыВзаимодействия(ДопПараметры.Группа));
	//СообщениеСВ.Автор = Обсуждения.ПользовательСистемыВзаимодействия(Пользователи.ТекущийПользователь()).Идентификатор;
	//СообщениеСВ.Текст = Сообщение;
	//
	// Для каждого Вложение Из СписокФайлов Цикл
	//	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Вложение.Значение);
	//	
	//	Поток  = Новый ПотокВПамяти;
	//	Запись = Новый ЗаписьДанных(Поток);
	//	
	//	Запись.Записать(ДвоичныеДанные);
	//	СообщениеСВ.Вложения.Добавить(Поток, Вложение.Представление);
	//	Запись.Закрыть();    
	//	//Поток.Закрыть();
	//КонецЦикла;
	// Для каждого Получатель из СписокПользователейСистемыВзаимодействия Цикл
	//	СообщениеСВ.Получатели.Добавить(Получатель.Значение);
	//КонецЦикла;
	//
	//СообщениеСВ.Записать();
	//
	//Возврат Строка(СообщениеСВ.Идентификатор);
	Возврат "";
	
КонецФункции

Процедура ОжиданиеСобытий(УчетнаяЗапись) Экспорт
	Возврат;
КонецПроцедуры

Функция ПолучитьВидКИМессенджера(Контакт) Экспорт
	Возврат Неопределено;
КонецФункции

Функция ТипКИМессенджера() Экспорт
	Возврат Неопределено;
КонецФункции

Функция НачалоАдресаСтраницыПользователя() Экспорт
	Возврат "";
КонецФункции

Функция ПутьКДиалогуВБраузере(Структура) Экспорт
	Возврат "";
КонецФункции

Функция ПредставлениеКонтактнойИнформацииПользователя(ID_Пользователя) Экспорт
	Возврат "";
КонецФункции

Функция ВозможноИзменениеСообщений() Экспорт
	Возврат Истина; 
КонецФункции

Функция ИспользуютсяВложения() Экспорт
	Возврат Истина; 
КонецФункции

Функция HTMLКонтекста(УчетнаяЗапись, idПользователя, idГруппы) Экспорт
	
	Содержание = Неопределено;
	Попытка
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(Новый ИдентификаторОбсужденияСистемыВзаимодействия(idГруппы));
		Если Обсуждение <> Неопределено Тогда
			Контекст =
				CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуИзНавигационной(Обсуждение.КонтекстОбсуждения.НавигационнаяСсылка);
			Если ТипЗнч(Контекст) = Тип("ДокументСсылка.CRM_Интерес") Тогда
				Содержание = CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПолучитьСодержание(Контекст,
					 Новый ОписаниеТипов("ДокументСсылка.CRM_Интерес"));
			КонецЕсли;
		КонецЕсли;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	Возврат Содержание;
	
КонецФункции

Функция Отключиться(СтруктураПараметровДоступа) Экспорт
	Возврат Истина;
КонецФункции

Процедура ПометитьКакПрочтенные(УчетнаяЗапись, МассивСообщений) Экспорт
	
КонецПроцедуры

Функция ПользовательДоступен(УчетнаяЗапись, ДополнительныеДанные) Экспорт
	
	Возврат Новый Структура("Доступен, Описание", Ложь, "");
	
КонецФункции

Функция ПараметрыМессенджера() Экспорт
	
	ПараметрыМессенджера = CRM_РаботаСМессенджерамиСервер.СтруктураПараметровМессенджера();
	
	Возврат ПараметрыМессенджера;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
