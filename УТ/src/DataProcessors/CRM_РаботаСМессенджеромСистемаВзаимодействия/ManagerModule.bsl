#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбязательныеМетодыПрограмногоИнтерфейса

Функция ПолучитьСообщения(УчетнаяЗапись) Экспорт
	
	СтруктураПараметровДоступа = CRM_РаботаСМессенджерамиСерверПовтИсп.СтруктураПараметровДоступа(УчетнаяЗапись);
	Если СтруктураПараметровДоступа = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивСообщений = Новый Массив;
	
	ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия();
	ОтборОбсуждений.Отображаемое = Истина;
	ОтборОбсуждений.КонтекстноеОбсуждение = Истина;
	ОтборОбсуждений.НаправлениеСортировки = НаправлениеСортировки.Возр;
	ДатаОтбора = ДатаПоследнегоПолучения(УчетнаяЗапись);
	Если ЗначениеЗаполнено(ДатаОтбора) Тогда
		ОтборОбсуждений.ДатаНачала = ДатаОтбора;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	                      |	МАКСИМУМ(CRM_СообщениеМессенджера.Ссылка) КАК Ссылка,
	                      |	CRM_СообщениеМессенджера.Группа КАК Группа
	                      |ИЗ
	                      |	Документ.CRM_СообщениеМессенджера КАК CRM_СообщениеМессенджера
	                      |ГДЕ
	                      |	CRM_СообщениеМессенджера.УчетнаяЗапись = &УчетнаяЗапись
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	CRM_СообщениеМессенджера.Группа";
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	ВыборкаОбсуждения = Запрос.Выполнить().Выбрать();
	
	МассивОбсуждений = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
    Пока МассивОбсуждений.Количество() > 0 Цикл
		Для каждого Обсуждение Из МассивОбсуждений Цикл
			Контекст =
				CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуИзНавигационной(Обсуждение.КонтекстОбсуждения.НавигационнаяСсылка);
			Если Контекст = Неопределено Тогда
				Сообщение = Неопределено;
				Продолжить;
			КонецЕсли;
			Если СтруктураПараметровДоступа.СписокОбъектов.НайтиПоЗначению(
					ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Контекст))) = Неопределено Тогда
				Продолжить;	
			КонецЕсли;
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Ответственный") Тогда
				Ответственный = Контекст["Ответственный"];
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ОсновнойМенеджер") Тогда
				Ответственный = Контекст["ОсновнойМенеджер"];
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Менеджер") Тогда
				Ответственный = Контекст["Менеджер"];
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Владелец")
					И ТипЗнч(Контекст["Владелец"]) = Тип("СправочникСсылка.Партнеры") Тогда
				Ответственный = Контекст["Владелец"]["ОсновнойМенеджер"];
			Иначе
				Продолжить;
			КонецЕсли;
				
			ОтборСообщений = Новый ОтборСообщенийСистемыВзаимодействия();
			ОтборСообщений.Обсуждение = Обсуждение.Идентификатор;
			ВыборкаОбсуждения.Сбросить();
			Если ВыборкаОбсуждения.НайтиСледующий(Новый Структура("Группа", Строка(Обсуждение.Идентификатор))) Тогда
				ОтборСообщений.После = Новый ИдентификаторСообщенияСистемыВзаимодействия(ВыборкаОбсуждения.Ссылка.ID_Сообщения);
			КонецЕсли;
			Сообщения = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
			
			Пока Сообщения.Количество() > 0 Цикл
				
				Для каждого Сообщение Из Сообщения Цикл
					
					Автор = Обсуждения.ПользовательИнформационнойБазы(Сообщение.Автор);
					НовСообщение = CRM_РаботаСМессенджерамиСервер.СтруктураСообщенияМесенджера();
					НовСообщение.Дата = Сообщение.Дата;
					НовСообщение.ID_Сообщения = Строка(Сообщение.Идентификатор);
					НовСообщение.ТекстСообщения = Сообщение.Текст;
					Если Ответственный = Автор Тогда
						НовСообщение.ВидСообщения = "Исходящее";
					Иначе
						НовСообщение.ВидСообщения = "Входящее";
					КонецЕсли;
					Если ЗначениеЗаполнено(Ответственный) Тогда
						Если ТипЗнч(Ответственный) = Тип("СправочникСсылка.Пользователи") Тогда
							НовСообщение.Вставить("Ответственный", Ответственный);
						Иначе
							НовСообщение.Вставить("CRM_РольОтветственного", Ответственный);
						КонецЕсли; 
					КонецЕсли;
					Если Сообщение.Получатели.Количество() > 0 Тогда
						ПользователиОбсуждения = Обсуждения.ПользователиИнформационнойБазы(Сообщение.Получатели);
						МассивПользователей = Новый Массив;
						Для каждого ПользовательОбсуждения Из ПользователиОбсуждения Цикл
							МассивПользователей.Добавить(Строка(ПользовательОбсуждения.Значение));
						КонецЦикла;
						НовСообщение.Вставить("ПолучателиПредставление", СтрСоединить(МассивПользователей, ";"));
					КонецЕсли;
					НовСообщение.ID_Пользователя = Строка(Сообщение.Автор);
					НовСообщение.Контакт = Автор;
					НовСообщение.КонтактПредставление = Строка(Автор);
					НовСообщение.Группа = Строка(Сообщение.Обсуждение);
					НовСообщение.ГруппаПредставление = Обсуждение.Заголовок;
					Если ЗначениеЗаполнено(Обсуждение.КонтекстОбсуждения) Тогда
						Попытка
							Контекст =
								CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуИзНавигационной(Обсуждение.КонтекстОбсуждения.НавигационнаяСсылка);
							НовСообщение.Основание = Контекст;
						Исключение
							НовСообщение.Основание = Неопределено;
						КонецПопытки;
					КонецЕсли;
					
					Для каждого Вложение Из Сообщение.Вложения Цикл
						Если Вложение.СодержимоеУдалено Тогда
							Продолжить;
						КонецЕсли;
						
						Поток = Вложение.ОткрытьПотокДляЧтения();
						ЧтениеДанных = Новый ЧтениеДанных(Поток);

						РезультатЧтения = ЧтениеДанных.Прочитать();
						ДвоичныеДанные = РезультатЧтения.ПолучитьДвоичныеДанные();
						
						АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
						ПараметрыФайла = Новый Структура;
						ПараметрыФайла.Вставить("ВладелецФайлов", Неопределено);
						ПараметрыФайла.Вставить("Автор", Неопределено);
						ПараметрыФайла.Вставить("ИмяБезРасширения", Лев(Вложение.Наименование, СтрНайти(Вложение.Наименование, ".") - 1));
						ПараметрыФайла.Вставить("РасширениеБезТочки", Сред(Вложение.Наименование,
							 СтрНайти(Вложение.Наименование, ".") 
							+ 1));
						ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
						ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
						ПараметрыФайла.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
						НовСообщение.Вложения.Добавить(ПараметрыФайла);
					КонецЦикла;
						
					МассивСообщений.Добавить(НовСообщение);
				КонецЦикла;
				Если Сообщения.Количество() = 200 Тогда
					ОтборСообщений.После = Сообщение.Идентификатор;
					Сообщения = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
				Иначе
					Сообщения = Новый Массив;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		Если МассивОбсуждений.Количество() = 200 Тогда
			Если Сообщение <> Неопределено Тогда
				ОтборОбсуждений.ДатаНачала = Сообщение.Дата;
			Иначе
				ОтборСообщений = Новый ОтборСообщенийСистемыВзаимодействия();
				ОтборСообщений.Обсуждение = Обсуждение.Идентификатор;
				ОтборСообщений.Количество = 1;
				ОтборСообщений.НаправлениеСортировки = НаправлениеСортировки.Убыв;
				Сообщения = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
				Если Сообщения.Количество() > 0 Тогда
					ОтборОбсуждений.ДатаНачала = Сообщения[0].Дата;
				КонецЕсли;
			КонецЕсли;
			МассивОбсуждений = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
		Иначе
			МассивОбсуждений = Новый Массив;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивСообщений;
	
КонецФункции

Функция ОтправитьСообщение(Сообщение, УчетнаяЗапись, IDПользователя, СписокФайлов,
	 СписокПользователейСистемыВзаимодействия,
	 ДопПараметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеСВ =
		СистемаВзаимодействия.СоздатьСообщение(Новый ИдентификаторОбсужденияСистемыВзаимодействия(ДопПараметры.Группа));
	СообщениеСВ.Автор = Обсуждения.ПользовательСистемыВзаимодействия(Пользователи.ТекущийПользователь()).Идентификатор;
	СообщениеСВ.Текст = Сообщение;
	
	Для каждого Вложение Из СписокФайлов Цикл
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Вложение.Значение);
		
		Поток  = Новый ПотокВПамяти;
		Запись = Новый ЗаписьДанных(Поток);
		
		Запись.Записать(ДвоичныеДанные);
		СообщениеСВ.Вложения.Добавить(Поток, Вложение.Представление);
		Запись.Закрыть();    
		//Поток.Закрыть();
	КонецЦикла;
	Для каждого Получатель Из СписокПользователейСистемыВзаимодействия Цикл
		СообщениеСВ.Получатели.Добавить(Получатель.Значение);
	КонецЦикла;
	
	СообщениеСВ.Записать();
	
	Возврат Строка(СообщениеСВ.Идентификатор);
	
КонецФункции

Процедура ОжиданиеСобытий(УчетнаяЗапись) Экспорт
	
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
	Возврат ПолучитьНавигационнуюСсылку(Новый ИдентификаторОбсужденияСистемыВзаимодействия(Структура.Группа));
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
	
	Попытка
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(Новый ИдентификаторОбсужденияСистемыВзаимодействия(idГруппы));
		Если Обсуждение <> Неопределено Тогда
			Контекст =
				CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуИзНавигационной(Обсуждение.КонтекстОбсуждения.НавигационнаяСсылка);
			Если ТипЗнч(Контекст) = Тип("ДокументСсылка.CRM_Интерес") Тогда
				Содержание = CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияПолучитьСодержание(Контекст,
					 Новый ОписаниеТипов("ДокументСсылка.CRM_Интерес"));
				Возврат Содержание;
			КонецЕсли;
		КонецЕсли;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	Возврат Неопределено;
	
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

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеМетоды

Функция ДатаПоследнегоПолучения(УчетнаяЗапись)

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ДатыПолученияСообщенийМессенджеров.ДатаПолучения КАК ДатаПолучения
	                      |ИЗ
	                      |	РегистрСведений.CRM_ДатыПолученияСообщенийМессенджеров КАК CRM_ДатыПолученияСообщенийМессенджеров
	                      |ГДЕ
	                      |	CRM_ДатыПолученияСообщенийМессенджеров.УчетнаяЗапись = &УчетнаяЗапись");

	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	ВыборкаДаты = Запрос.Выполнить().Выбрать();
	Если ВыборкаДаты.Следующий() И ЗначениеЗаполнено(ВыборкаДаты.ДатаПолучения) Тогда
		Возврат ВыборкаДаты.ДатаПолучения;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	МАКСИМУМ(CRM_СообщениеМессенджера.Дата) КАК Дата
	                      |ИЗ
	                      |	Документ.CRM_СообщениеМессенджера КАК CRM_СообщениеМессенджера
	                      |ГДЕ
	                      |	CRM_СообщениеМессенджера.УчетнаяЗапись = &УчетнаяЗапись");
	
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	ВыборкаДаты = Запрос.Выполнить().Выбрать();
	Если ВыборкаДаты.Следующий() И ЗначениеЗаполнено(ВыборкаДаты.Дата) Тогда
		Возврат ВыборкаДаты.Дата;
	КонецЕсли;
	
	Возврат Дата(1, 1, 1);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
