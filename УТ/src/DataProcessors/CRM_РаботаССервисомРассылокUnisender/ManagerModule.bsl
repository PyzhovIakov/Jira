#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбязательныеМетодыПрограмногоИнтерфейса

// Отправить письмо.
//
// Параметры:
//  ПараметрыПисьма	 - Структура - Параметры письма. 
//  api_key			 - Строка - Ключ API.
//  СписокРассылки	 - Строка - Список рассылки. 
//  Отправитель		 - Строка - Отправитель. 
//  EmailОтправителя - Строка - Email отправителя.  
//  ИдРассылки		 - Строка - ИД рассылки.
//  ТекстОтвета		 - Строка - Текст ответа. 
// 
// Возвращаемое значение:
//  Структура - Структура ответа. 
//
Функция ВыполнитьОтправкуПисьма(Объект, ПараметрыПисьма, НастройкиСервиса, ТекстОтвета) Экспорт
	СтруктураОтвета = Новый Структура;
	Ошибка = "";
	
	api_key = НастройкиСервиса.КлючДоступа;
	СписокРассылки = НастройкиСервиса.СписокДляРассылок;
	Отправитель = Объект.УчетнаяЗапись.ИмяПользователя;
	EmailОтправителя = Объект.УчетнаяЗапись.АдресЭлектроннойПочты;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/sendEmail?format=json";
		ТелоПисьма = ПараметрыПисьма.Тело;
		
		attachments = "";
		
		НомерВложения = 0;
		Для Каждого СтрокаТаблицы Из ПараметрыПисьма.Вложения Цикл 
			НомерВложения = НомерВложения + 1;
			ИмяВложения = СтрЗаменить(СтрокаТаблицы.Представление, "_", "");
			ИмяВременногоФайла = КаталогВременныхФайлов() + ИмяВложения;
			Если ТипЗнч(СтрокаТаблицы.АдресВоВременномХранилище) = Тип("ДвоичныеДанные") Тогда
				СтрокаТаблицы.АдресВоВременномХранилище.Записать(ИмяВременногоФайла);
			ИначеЕсли ТипЗнч(СтрокаТаблицы.АдресВоВременномХранилище) = Тип("Структура") Тогда
				СтрокаТаблицы.Значение.ДвоичныеДанные.Записать(ИмяВременногоФайла);
			КонецЕсли;
			Текст = Новый ТекстовыйДокумент();
			Текст.Прочитать(ИмяВременногоФайла, "ISO-8859-1", Символы.ПС);
			Стр = Текст.ПолучитьТекст();
			attachments = attachments + "&attachments[" + ИмяВложения + "]=" + КодироватьСтроку(Стр,
				 СпособКодированияСтроки.КодировкаURL, "ISO-8859-1");
			Если СтрокаТаблицы.Свойство("Идентификатор") И СтрНайти(ТелоПисьма, "src=""cid:" 
				+ СтрокаТаблицы.Идентификатор) > 0 Тогда
				ТелоПисьма = СтрЗаменить(ТелоПисьма, "src=""cid:" + СтрокаТаблицы.Идентификатор, "src=""" + ИмяВложения);
			КонецЕсли;
		КонецЦикла;
		
		ТелоПисьма = КодироватьСтроку(ТелоПисьма, СпособКодированияСтроки.КодировкаURL);

		АдресЭлектроннойПочты = "";
		Для Каждого СтрокаТаблицы Из ПараметрыПисьма.Кому Цикл 
			Если ЗначениеЗаполнено(СтрокаТаблицы.Представление) Тогда
				АдресЭлектроннойПочты = "&email=" + КодироватьСтроку(СтрокаТаблицы.Представление + " ",
					 СпособКодированияСтроки.КодировкаURL) + "<" + СтрокаТаблицы.Адрес 
					+ ">" ;
			Иначе
				АдресЭлектроннойПочты = "&email=" + СтрокаТаблицы.Адрес;
			КонецЕсли;
		КонецЦикла;
		
		СтрокаЗапроса = "&api_key=" + api_key
						+ "&platform=1c_crm_rarus"
						+ "&track_read=1"
						+ "&lang=ru"
						+ "&ref_key=" + ПараметрыПисьма.GUID
						+ "&track_links=1"
						+ АдресЭлектроннойПочты
						+ "&sender_name=" + ?(ЗначениеЗаполнено(Отправитель), Отправитель, EmailОтправителя)
						+ "&sender_email=" + EmailОтправителя
						+ "&list_id=" + СписокРассылки
						+ "&subject=" + КодироватьСтроку(ПараметрыПисьма.Тема, СпособКодированияСтроки.КодировкаURL)
						+ "&body=" + ТелоПисьма
						+ attachments
						;
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	Если СтруктураОтвета.Свойство("result", Значение)
		И Значение.Свойство("email_id") Тогда
		Возврат СтрЗаменить(Строка(Значение.email_id), Символы.НПП, "");
	ИначеЕсли СтруктураОтвета.Свойство("error") Тогда
		ТекстОтвета = СтруктураОтвета.error;
	ИначеЕсли СтруктураОтвета.Свойство("warnings", Значение) Тогда
		Для каждого Предупреждение Из Значение Цикл
			ТекстОтвета = ТекстОтвета + ?(ЗначениеЗаполнено(ТекстОтвета), Символы.ПС, "") + Предупреждение.warning;
		КонецЦикла;
		Если СтрНайти(ТекстОтвета, "SZ150219-06") > 0 Тогда
			МассивАдресов = Новый Массив;
			Для Каждого СтрокаТаблицы Из ПараметрыПисьма.Кому Цикл 
				МассивАдресов.Добавить(СтрокаТаблицы.Адрес);
			КонецЦикла;
			СоответствиеАдресов =
				CRM_ИнтеграцияССервисамиРассылок.НайтиАдресаЭлектроннойПочтыВКонтактнойИнформации(МассивАдресов);
			Для каждого ОбъектКИ Из СоответствиеАдресов Цикл
				Если ЗначениеЗаполнено(ОбъектКИ.Ключ) Тогда
					Объект = ОбъектКИ.Ключ.ПолучитьОбъект();
					Объект.CRM_ОтписалсяОтEmailРассылок = Истина;
					Объект.Записать();
				КонецЕсли;
			КонецЦикла;
			Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.ПолучательОтписалсяОтРассылки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Массив шаблонов uni sender
// 
// Возвращаемое значение:
//  Структура - Структура ответа. 
//
Функция МассивШаблоновСервиса(НастройкиСервиса) Экспорт
	
	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураОтвета = Новый Структура;
	
	api_key = НастройкиСервиса.КлючДоступа;
	
	Ресурс = "/listTemplates?format=json";
	
	СтрокаЗапроса = "&platform=1c_crm_rarus&api_key=" + api_key + "&limit=100&offset=0";
	
	ЕстьШаблоны = Истина;
	МассивШаблонов = Новый Массив;
	
	offset = 0;
	Пока ЕстьШаблоны = Истина Цикл
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
		Значение = "";
		Если СтруктураОтвета.Свойство("error", Значение) Тогда
			Возврат МассивШаблонов;
		ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
			result = СтруктураОтвета.result;
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивШаблонов, СтруктураОтвета.result);
			Если result.Количество() < 100 Тогда
				ЕстьШаблоны = Ложь;
			Иначе	
				offset = offset + 100;
				СтрокаЗапроса = Лев(СтрокаЗапроса, СтрНайти(СтрокаЗапроса, "&offset=") + 7) 
					+ СтрЗаменить(Строка(offset), Символы.НПП,
					 "");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивШаблонов;
	
КонецФункции

// Шаблон uni sender
//
// Параметры:
//  Шаблон	 - Строка - ИД шаблона. 
// 
// Возвращаемое значение:
//  Структура - Структура ответа.
//
Функция ШаблонСервиса(НастройкиСервиса, Шаблон) Экспорт
	
	СтруктураОтвета = Новый Структура;
	
	Ошибка = "";

	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат Новый Структура("ТекстПисьма, Тема", "", "");
	КонецЕсли;
	
	api_key = НастройкиСервиса.КлючДоступа;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/getTemplate?format=json";
		
		СтрокаЗапроса = "&api_key=" + api_key
		            	+ "&platform=1c_crm_rarus"
						+ "&template_id=" + СтрЗаменить(Шаблон, Символы.НПП, "")
						+ "&format=html";
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	Если СтруктураОтвета.Свойство("error", Значение) Тогда
		ТекстПисьма = "";
		Тема = "";
	ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
		Текст = СтрЗаменить(СтруктураОтвета.result.body, "src=""/ru/user_file",
			 "src=""https://cp.unisender.com/ru/user_file");
		ТекстПисьма = СтрЗаменить(Текст, "img src=""/v5/img", "img src=""https://cp.unisender.com/v5/img");
		Тема = СтруктураОтвета.result.subject;
	КонецЕсли;
	Возврат Новый Структура("ТекстПисьма, Тема", ТекстПисьма, Тема);
	
КонецФункции

// Функция - проверить адрес учетной записи
//
// Параметры:
//  email	 - Строка - Строка с email адресом.
// 
// Возвращаемое значение:
//  Булево - Существование адреса. 
//
Функция ПроверитьАдресУчетнойЗаписи(НастройкиСервиса, email) Экспорт
	
	СтруктураОтвета = Новый Структура;
	
	Ошибка = "";
	
	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат Истина;
	КонецЕсли;

	api_key = НастройкиСервиса.КлючДоступа;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/validateSender?format=json";
		
		СтрокаЗапроса = "&api_key=" + api_key
		            	+ "&platform=1c_crm_rarus"
						+ "&email=" + email;
						
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	Если СтруктураОтвета.Свойство("error", Значение) Тогда
		Если СтрНайти(Значение, "SZ151110-01") > 0 Тогда
			Возврат Истина;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Значение);
		Возврат Ложь;
	ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
		// АПК:1223-выкл отключаем проверку на использование местоимений "Вы", "Вас" и пр.
		Если Значение.Message = "Confirmation letter was sent" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выбранная учетная запись не была подтверждена в UniSender. Вам отправлено письмо для подтверждения.';
				|en='The selected account was not confirmed in UniSender. A confirmation email has been sent to you.'"));
		ИначеЕсли Значение.Message = "Confirmation letter was sent again" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выбранная учетная запись не была подтверждена в UniSender. Вам ранее было отправлено письмо для подтверждения.';
				|en='The selected account was not confirmed in UniSender. You have previously been sent a confirmation email.'"));
		КонецЕсли;
		// АПК:1223-вкл
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

Функция ПодписатьАдресНаРассылки(НастройкиСервиса, email) Экспорт
	
	СтруктураОтвета = Новый Структура;
	
	Ошибка = "";
	
	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат Истина;
	КонецЕсли;
	
	api_key = НастройкиСервиса.КлючДоступа;
	СписокРассылки = НастройкиСервиса.СписокДляРассылок;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/subscribe?format=json";
		
		СтрокаЗапроса = "&api_key=" + api_key
		            	+ "&platform=1c_crm_rarus"
						+ "&list_ids=" + СписокРассылки
						// +"&double_optin=1"
		                + "&fields[email]=" + email;
						
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	Если СтруктураОтвета.Свойство("error", Значение) Тогда
		Если СтрНайти(Значение, "YK171228-01") > 0 Тогда
			Возврат Истина;
		КонецЕсли;
		Если СтрНайти(Значение, "SZ141008-01") > 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не настроено письмо подтверждения подписки для указанного списка контактов. Настройте в личном кабинете UniSender.';
				|en='A subscription confirmation email is not configured for the specified contact list. Set up in the personal account of UniSender.'"));
		КонецЕсли;
		Возврат Ложь;
	ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ОтписатьАдресОтРассылки(НастройкиСервиса, email) Экспорт
	
	СтруктураОтвета = Новый Структура;
	
	Ошибка = "";
	
	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат Истина;
	КонецЕсли;
	
	api_key = НастройкиСервиса.КлючДоступа;
	СписокРассылки = НастройкиСервиса.СписокДляРассылок;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/unsubscribe?format=json";
		
		СтрокаЗапроса = "&api_key=" + api_key
		            	+ "&platform=1c_crm_rarus"
						+ "&list_ids=" + СписокРассылки
						+ "&contact_type=email"
		                + "&contact=" + email;
						
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	Если СтруктураОтвета.Свойство("error", Значение) Тогда
		Если СтрНайти(Значение, "YE131008-13") > 0 ИЛИ СтрНайти(Значение, "DV180226-01")
			 ИЛИ СтрНайти(Значение,
			 "DV20181205-01") > 0 Тогда
			Возврат Истина;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = ''") + Значение);
		Возврат Ложь;
	ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Процедура ОбновитьСтатусыEmailРассылок(НастройкиСервиса, ТаблицаПисем) Экспорт
	
	Если НЕ НастройкиСервиса.Свойство("КлючДоступа") ИЛИ НЕ ЗначениеЗаполнено(НастройкиСервиса["КлючДоступа"]) Тогда
		Возврат;
	КонецЕсли;
	
	Количество = ТаблицаПисем.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокПисемСтрокой = ТаблицаПисем[0].ИдентификаторСообщения;

	Для Ном = 1 По Количество - 1 Цикл
		СписокПисемСтрокой = СписокПисемСтрокой + "," + ТаблицаПисем[Ном].ИдентификаторСообщения;
	КонецЦикла;
	
	СтруктураОтвета = Новый Структура;
	
	api_key = НастройкиСервиса.КлючДоступа;
	
	Ресурс = "/checkEmail?format=json";
	СтрокаЗапроса = "&api_key=" + api_key
		            + "&platform=1c_crm_rarus"
					+ "&email_id=" + СписокПисемСтрокой
					;
	СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс), Истина);
	
	Статусы = Неопределено;
	Результат = СтруктураОтвета.Получить("result");
	Если Результат <> Неопределено Тогда
		Статусы = Результат.Получить("statuses");
		Если Статусы <> Неопределено Тогда
			Для Каждого Статус Из Статусы Цикл
				СтатусID = СтрЗаменить(Строка(Статус.Получить("id")), Символы.НПП, "");
				СтатусStatus = Статус.Получить("status");
				НайденаяСтрока = ТаблицаПисем.Найти(СтатусID, "ИдентификаторСообщения");
				Если НайденаяСтрока <> Неопределено Тогда 
					ЗаписьРегистра = РегистрыСведений.CRM_СтатусыПисемEmailРассылки.СоздатьМенеджерЗаписи();
					ЗаписьРегистра.Письмо = НайденаяСтрока.Письмо;
					ЗаписьРегистра.Статус = СоответствиеСтатусаUniSender(СтатусStatus);
					ЗаписьРегистра.СтатусСтрокой = СтатусStatus;
					ЗаписьРегистра.Записать();
					Если ЗаписьРегистра.Статус = Перечисления.CRM_СтатусыПисемEmailРассылки.ПолучательОтписалсяОтРассылки Тогда
						МассивАдресов = Новый Массив;
						Для каждого Получатель Из НайденаяСтрока.Письмо.ПолучателиПисьма Цикл
							МассивАдресов.Добавить(Получатель.Адрес);
						КонецЦикла;
						СоответствиеАдресов =
							CRM_ИнтеграцияССервисамиРассылок.НайтиАдресаЭлектроннойПочтыВКонтактнойИнформации(МассивАдресов);
						Для каждого ОбъектКИ Из СоответствиеАдресов Цикл
							Если ЗначениеЗаполнено(ОбъектКИ.Ключ) Тогда
								Объект = ОбъектКИ.Ключ.ПолучитьОбъект();
								Объект.CRM_ОтписалсяОтEmailРассылок = Истина;
								Объект.Записать();
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ИспользуетсяОбновлениеСтатусов() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

// Функция - Списки контактов uni sender
//
// Параметры:
//  api_key	 - Строка - Ключ API. 
// 
// Возвращаемое значение:
//  СписокЗначений - Список контактов.
//
Функция СпискиКонтактовUniSender(api_key) Экспорт
	
	СтруктураОтвета = Новый Структура;
	
	Ошибка = "";
	
	Если ПустаяСтрока(api_key) Тогда
		Если Не ПустаяСтрока(Ошибка) Тогда
			Ошибка = Ошибка + Символы.ПС;
		КонецЕсли;
		Ошибка = Ошибка + "Не заполнен api_key";
	КонецЕсли;
	
	Если ПустаяСтрока(Ошибка) Тогда 
		Ресурс = "/getLists?format=json";
		СтрокаЗапроса = "&platform=1c_crm_rarus&api_key=" + api_key;
		СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	Иначе 
		СтруктураОтвета.Вставить("error", Ошибка);
	КонецЕсли;
	
	Значение = "";
	СпискиКонтактов = Новый СписокЗначений;
	Если СтруктураОтвета.Свойство("error", Значение) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Ошибка получения данных с UniSender';en='Error getting data from UniSender'") 
			+ ": " 
			+ Значение);
		Возврат СпискиКонтактов;
	ИначеЕсли СтруктураОтвета.Свойство("result", Значение) Тогда
		Для Каждого Список Из СтруктураОтвета.result Цикл
			СпискиКонтактов.Добавить(СтрЗаменить(Строка(Список.id), Символы.НПП, ""), Список.title);
		КонецЦикла;
		Возврат СпискиКонтактов;
	КонецЕсли;

КонецФункции

// Выгрузить автотекст в uni sender
//
// Параметры:
//  Ссылка	 - СправочникСсылка.CRM_ШаблоныАвтотекста - Ссылка на шаблон.
// 
// Возвращаемое значение:
//  Неопределено - Нет. 
//
Процедура ВыгрузитьАвтотекстВUniSender(api_key, Ссылка = Неопределено) Экспорт
	
	Ресурс = "/getFields?format=json";
	СтрокаЗапроса = "&api_key=" + api_key
		            + "&platform=1c_crm_rarus"
					;
	СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
	СписокПолей = Новый СписокЗначений;
	Если СтруктураОтвета.Свойство("result") Тогда
		Для каждого Поле Из СтруктураОтвета.result Цикл
			СписокПолей.Добавить(Поле.name, Поле.id);
		КонецЦикла;
	КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_ШаблоныАвтотекста.ПредставлениеШаблона КАК ПредставлениеШаблона,
	                      |	CRM_ШаблоныАвтотекста.ПредставлениеLAT КАК ПредставлениеLAT,
	                      |	CRM_ШаблоныАвтотекста.Наименование КАК Наименование,
	                      |	CRM_ШаблоныАвтотекста.Ссылка КАК Ссылка,
	                      |	CRM_ШаблоныАвтотекста.ПометкаУдаления КАК ПометкаУдаления
	                      |ИЗ
	                      |	Справочник.CRM_ШаблоныАвтотекста КАК CRM_ШаблоныАвтотекста
	                      |ГДЕ
	                      |	CRM_ШаблоныАвтотекста.Родитель = &Родитель
	                      |	И CRM_ШаблоныАвтотекста.Ссылка = &Ссылка
	                      |	И НЕ CRM_ШаблоныАвтотекста.ЭтоГруппа
	                      |	И НЕ CRM_ШаблоныАвтотекста.ПометкаУдаления
	                      |	И CRM_ШаблоныАвтотекста.ПредставлениеШаблона <> """"
	                      |	И CRM_ШаблоныАвтотекста.ПредставлениеLAT <> """"");
						  
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И CRM_ШаблоныАвтотекста.Ссылка = &Ссылка", "");
	КонецЕсли;
						  
	Запрос.УстановитьПараметр("Родитель", Справочники.CRM_ШаблоныАвтотекста.АвтотекстЭлектронногоПисьма);
	Выборка = Запрос.Выполнить().Выбрать();
	Ресурс = "/createField?format=json";
	РесурсУдаление = "/deleteField?format=json";
	Пока Выборка.Следующий() Цикл
		ЭлементСписка = СписокПолей.НайтиПоЗначению(Выборка.ПредставлениеLAT);
		Если ЭлементСписка = Неопределено Тогда
			СтрокаЗапроса = "&api_key=" + api_key
				            + "&platform=1c_crm_rarus"
				            + "&name=" + Выборка.ПредставлениеLAT
				            + "&public_name=" + Выборка.Наименование + " (CRM)"
				            + "&type=string"
							;
			СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, Ресурс));
			Если СтруктураОтвета.Свойство("result") Тогда
				
			Иначе
				
			КонецЕсли;
		ИначеЕсли Выборка.ПометкаУдаления Тогда	
			СтрокаЗапроса = "&api_key=" + api_key
				            + "&platform=1c_crm_rarus"
				            + "&id =" + ЭлементСписка.Представление;
			СтруктураОтвета = ПолучитьЗначениеИзОтветаJSON(ВыполнитьЗапрос(СтрокаЗапроса, РесурсУдаление));
			Если СтруктураОтвета.Свойство("result") Тогда
				
			Иначе
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыполнитьЗапрос(СтрокаЗапроса, Ресурс) 
	
	Сервер = "api.unisender.com/ru/api";
	
	Прокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		Прокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси("https");
	КонецЕсли;
	
	HTTP =  Новый HTTPСоединение(Сервер, , , , Прокси, 20, Новый ЗащищенноеСоединениеOpenSSL);
	
	ЗаголовокHTTP = Новый Соответствие();
    ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded");
    ЗаголовокHTTP.Вставить("Accept-Language", "ru");
    ЗаголовокHTTP.Вставить("Accept-Charset", "utf-8");
    ЗаголовокHTTP.Вставить("Content-Language", "ru");
    ЗаголовокHTTP.Вставить("Content-Charset", "utf-8");
	HTTPЗапрос		= Новый HTTPЗапрос(Ресурс, ЗаголовокHTTP);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаЗапроса, "UTF-8", ИспользованиеByteOrderMark.НеИспользовать);
	
	ФайлРезультата = ПолучитьИмяВременногоФайла();
	HTTP.ОтправитьДляОбработки(HTTPЗапрос, ФайлРезультата);
	
	Возврат ФайлРезультата;
	
КонецФункции

Функция ПолучитьЗначениеИзОтветаJSON(ФайлРезультата, ПрочитатьВСоответствие = Ложь) Экспорт 
	ЧтениеJSON = Новый ЧтениеJSON;
	// ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	ЧтениеJSON.ОткрытьФайл(ФайлРезультата);
	Значение = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
	ЧтениеJSON.Закрыть();
    УдалитьФайлы(ФайлРезультата);
	Возврат Значение
КонецФункции

Функция СоответствиеСтатусаUniSender(СтатусСтрокой)
	Если СтатусСтрокой = "not_sent" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.Отправляется;
	ИначеЕсли СтатусСтрокой = "ok_read" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.Прочитано;
	ИначеЕсли СтатусСтрокой = "ok_delivered" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.Доставлено;
	ИначеЕсли СтатусСтрокой = "ok_sent" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.Отправлено;
	ИначеЕсли СтатусСтрокой = "ok_link_visited" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.ПереходПоСсылке;
	ИначеЕсли СтатусСтрокой = "err_unsubscribed" ИЛИ СтатусСтрокой = "ok_unsubscribed" Тогда
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.ПолучательОтписалсяОтРассылки;
	Иначе
		Возврат Перечисления.CRM_СтатусыПисемEmailРассылки.НеДоставлено;
	КонецЕсли;
КонецФункции

#КонецОбласти


#КонецЕсли
