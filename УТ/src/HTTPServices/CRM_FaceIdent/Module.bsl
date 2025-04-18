
#Область СлужебныеПроцедурыИФункции

Функция  ДобавитьНовуюПерсону(descriptor_id, УчетнаяЗаписьСервиса)
	СтрокаЗапроса = Новый ЗаписьJSON;
	СтрокаЗапроса.УстановитьСтроку();
	СтрокаЗапроса.ЗаписатьНачалоОбъекта();
	
	СтрокаЗапроса.ЗаписатьИмяСвойства("user_data");
	СтрокаЗапроса.ЗаписатьЗначение(descriptor_id);
	
	СтрокаЗапроса.ЗаписатьКонецОбъекта();
	ЗаголовокHTTP = Новый Соответствие;
	ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
	ЗаголовокHTTP.Вставить("Content-Type", "application/json");
	
	Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
		УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
	HTTPЗапрос = Новый HTTPЗапрос("/1/storage/persons");
	HTTPЗапрос.Заголовки = ЗаголовокHTTP;
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаЗапроса.Закрыть());
	Ответ = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
	person_id = "";
	Если СтруктураОтвета.Свойство("error_code") Тогда
		ВызватьИсключение СтруктураОтвета.detail;
	Иначе
		person_id = СтруктураОтвета.person_id;
	КонецЕсли;
	Возврат person_id;
КонецФункции	

Процедура ДобавитьДескрипторКПерсоне(person_id, descriptor_id, УчетнаяЗаписьСервиса)
	ЗаголовокHTTP = Новый Соответствие;
	ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
	Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
		УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
	HTTPЗапрос = Новый HTTPЗапрос("/1/storage/persons/" + person_id 
		+ "/linked_descriptors?descriptor_id=" + descriptor_id 
		+ "&do=attach");
	HTTPЗапрос.Заголовки = ЗаголовокHTTP;
	
	Ответ = Соединение.Изменить(HTTPЗапрос);
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	Если ТекстОтвета <> "" Тогда
		СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
		Если СтруктураОтвета.Свойство("error_code") Тогда
			ВызватьИсключение СтруктураОтвета.detail;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

Процедура ДобавитьПерсонуВСписок(person_id, list_id, УчетнаяЗаписьСервиса)
	ЗаголовокHTTP = Новый Соответствие;
	ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
	Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
		УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
	HTTPЗапрос = Новый HTTPЗапрос("/1/storage/persons/" + person_id + "/linked_lists?list_id=" + list_id + "&do=attach");
	HTTPЗапрос.Заголовки = ЗаголовокHTTP;
	
	Ответ = Соединение.Изменить(HTTPЗапрос);
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	Если ТекстОтвета <> "" Тогда
		СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
		Если СтруктураОтвета.Свойство("error_code") Тогда
			ВызватьИсключение СтруктураОтвета.detail;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьФотографию(person_id, ФотоЛица, Камера, Помещение, ТекущееМероприятие)
	ПотенциальныйКлиент = Справочники.CRM_ПотенциальныеКлиенты.НайтиПоРеквизиту("Идентификатор", person_id);
	Если ПотенциальныйКлиент.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ CRM_ЖурналПосещений.Клиент) КАК Клиент
		|ИЗ
		|	РегистрСведений.CRM_ЖурналПосещений КАК CRM_ЖурналПосещений
		|ГДЕ
		|	CRM_ЖурналПосещений.Камера = &Камера
		|	И CRM_ЖурналПосещений.Помещение = &Помещение
		|	И CRM_ЖурналПосещений.Мероприятие = &Мероприятие";
		Запрос.УстановитьПараметр("Камера", Камера);
		Запрос.УстановитьПараметр("Помещение", Помещение);
		Запрос.УстановитьПараметр("Мероприятие", ТекущееМероприятие);
		Выборка = Запрос.Выполнить().Выбрать();
		ОбъектКлиент = Справочники.CRM_ПотенциальныеКлиенты.СоздатьЭлемент();
		Если Выборка.Следующий() Тогда
			ОбъектКлиент.Наименование = "Посетитель №" + Формат(Выборка.Клиент + 1, "ЧГ=");
		Иначе
			ОбъектКлиент.Наименование = "Посетитель №1";
		КонецЕсли;	
		ОбъектКлиент.Идентификатор = person_id;
		ОбъектКлиент.Фотография = Новый ХранилищеЗначения(ФотоЛица);
		ОбъектКлиент.Записать();
	ИначеЕсли НЕ ПотенциальныйКлиент.НеОбновлятьФото И Константы.CRM_ОбновлятьФото.Получить() Тогда
		ОбъектКлиент = ПотенциальныйКлиент.ПолучитьОбъект();	
		ОбъектКлиент.Фотография = Новый ХранилищеЗначения(ФотоЛица);
		ОбъектКлиент.Записать();
	КонецЕсли;	
КонецПроцедуры

Процедура ДобавитьЗаписьВЖурналПосещений(person_id, Камера, Помещение, Мероприятие)
	
	ПотенциальныйКлиент = Справочники.CRM_ПотенциальныеКлиенты.НайтиПоРеквизиту("Идентификатор", person_id);
	Если НЕ ПотенциальныйКлиент.Пустая() Тогда
		ДатаСобытия = ТекущаяДатаСеанса();
		ЗаписьЖурнала = РегистрыСведений.CRM_ЖурналПосещений.СоздатьМенеджерЗаписи();
		ЗаписьЖурнала.Период = ДатаСобытия;
		ЗаписьЖурнала.Клиент = ПотенциальныйКлиент; 
		ЗаписьЖурнала.ДатаПосещенияСтр = Формат(ДатаСобытия, "ДФ=dd_MM_yyyy_HH_mm");
		ЗаписьЖурнала.ДатаПосещения = ДатаСобытия;
		ЗаписьЖурнала.Камера = Камера;
		ЗаписьЖурнала.Помещение = Помещение;
		ЗаписьЖурнала.Мероприятие = Мероприятие;
		ЗаписьЖурнала.Записать(Истина);
		
		//ЗаписьЖурнала = РегистрыСведений.CRM_СписокПосетителей.СоздатьМенеджерЗаписи();
		//ЗаписьЖурнала.Период = ДатаСобытия;
		//ЗаписьЖурнала.Клиент = ПотенциальныйКлиент; 
		//ЗаписьЖурнала.ДатаПосещения = ДатаСобытия;
		//ЗаписьЖурнала.Камера = Камера;
		//ЗаписьЖурнала.Помещение = Помещение;
		//ЗаписьЖурнала.Мероприятие = Мероприятие;
		//ЗаписьЖурнала.Записать(Истина);

	КонецЕсли;	
КонецПроцедуры

Функция FaceIdentGetFoto(Запрос)
	//Ответ = Новый HTTPСервисОтвет(200);
	//Ответ.УстановитьТелоИзСтроки(Строка(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()));
	//Возврат Ответ;
	ЗапросНастроек = Новый Запрос;
	ЗапросНастроек.Текст = "ВЫБРАТЬ
	|	АктивныеСеансыВидеофиксацииСрезПоследних.СервисИдентификации КАК СервисИдентификации,
	|	АктивныеСеансыВидеофиксацииСрезПоследних.АктивноеМероприятие КАК АктивноеМероприятие
	|ИЗ
	|	РегистрСведений.CRM_АктивныеСеансыВидеофиксации.СрезПоследних КАК АктивныеСеансыВидеофиксацииСрезПоследних
	|ГДЕ
	|	АктивныеСеансыВидеофиксацииСрезПоследних.СеансЗапущен";
	Выборка = ЗапросНастроек.Выполнить().Выбрать();
	УчетнаяЗаписьСервиса = Неопределено;
	ТекущееМероприятие = Неопределено;
	Если Выборка.Следующий() Тогда
		УчетнаяЗаписьСервиса = ?(Выборка.СервисИдентификации.Пустая(), Неопределено, Выборка.СервисИдентификации);	
		ТекущееМероприятие = ?(Выборка.АктивноеМероприятие.Пустая(), Неопределено, Выборка.АктивноеМероприятие);	
	КонецЕсли;
	Если УчетнаяЗаписьСервиса = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(455, "Учетная запись сервиса распознанавания лиц не найдена");
		Возврат Ответ;
	КонецЕсли;	
	Если ТекущееМероприятие = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(456, "Активное мероприятие не найдено");
		Возврат Ответ;
	КонецЕсли;
	ИмяМетода = Запрос.ПараметрыURL["ИмяМетода"];
	ИДКамеры = Запрос.ПараметрыЗапроса["camera_id"];
	
	Камера = Справочники.CRM_Камеры.НайтиПоРеквизиту("Идентификатор", ИДКамеры);
	Если Камера.Пустая() Тогда
		Ответ = Новый HTTPСервисОтвет(457, "Камера не найдена в справочнике");
		Возврат Ответ;
	КонецЕсли;	
	СтрокаНастроек = ТекущееМероприятие.CRM_КамерыВидеофиксации.Найти(Камера, "Камера");
	Если СтрокаНастроек = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(458, "Камера не найдена в настройках мероприятия");
		Возврат Ответ;
	КонецЕсли;	
	Помещение = СтрокаНастроек.Помещение;
	Если ИмяМетода = "PostFoto" Тогда
		
		ФотоЛица = Запрос.ПолучитьТелоКакДвоичныеДанные(); // двоичные данные картинки
		
		// проверим есть ли списки персон
		ЗаголовокHTTP = Новый Соответствие;
		ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
		
		Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
			УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
		HTTPЗапрос = Новый HTTPЗапрос("/1/storage/lists");
		HTTPЗапрос.Заголовки = ЗаголовокHTTP;
		Ответ = Соединение.Получить(HTTPЗапрос);
		ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
		СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
		list_id = "";
		Если СтруктураОтвета.Свойство("error_code") Тогда
			Ответ = Новый HTTPСервисОтвет(459, СтруктураОтвета.detail);
			Возврат Ответ;
		Иначе
			Если СтруктураОтвета.lists.person_lists.Количество() = 0 Тогда
				// если нет - добавим
				СтрокаЗапроса = Новый ЗаписьJSON;
				СтрокаЗапроса.УстановитьСтроку();
				СтрокаЗапроса.ЗаписатьНачалоОбъекта();
				
				СтрокаЗапроса.ЗаписатьИмяСвойства("list_data");
				СтрокаЗапроса.ЗаписатьЗначение("Список персон");
				
				СтрокаЗапроса.ЗаписатьКонецОбъекта();
				ЗаголовокHTTP = Новый Соответствие;
				ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
				ЗаголовокHTTP.Вставить("Content-Type", "application/json");
				
				Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
					УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
				HTTPЗапрос = Новый HTTPЗапрос("/1/storage/lists");
				HTTPЗапрос.Заголовки = ЗаголовокHTTP;
				HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаЗапроса.Закрыть());
				Ответ = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
				ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
				СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
				Если СтруктураОтвета.Свойство("error_code") Тогда
					Ответ = Новый HTTPСервисОтвет(459, СтруктураОтвета.detail);
					Возврат Ответ;
				Иначе
					list_id = СтруктураОтвета.list_id;
				КонецЕсли;
			Иначе
				list_id = СтруктураОтвета.lists.person_lists[0].id;
			КонецЕсли;	
		КонецЕсли;
		// проверим есть эта персона
		ЗаголовокHTTP = Новый Соответствие;
		ЗаголовокHTTP.Вставить("X-Auth-Token", УчетнаяЗаписьСервиса.Токен);
		ЗаголовокHTTP.Вставить("Content-Type", "image/jpeg");
		Соединение = Новый HTTPСоединение(УчетнаяЗаписьСервиса.АдресСервиса, ,
			УчетнаяЗаписьСервиса.ИмяПользователя, УчетнаяЗаписьСервиса.Пароль, , 30, Новый ЗащищенноеСоединениеOpenSSL);
		HTTPЗапрос = Новый HTTPЗапрос("/1/matching/search?list_id=" + list_id + "&limit=1");
		HTTPЗапрос.Заголовки = ЗаголовокHTTP;
		HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(ФотоЛица);
		Ответ = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
		Если ТекстОтвета <> "" Тогда
			СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(ТекстОтвета);
			Если СтруктураОтвета.Свойство("error_code") Тогда
				Ответ = Новый HTTPСервисОтвет(459, СтруктураОтвета.detail);
				Возврат Ответ;
			Иначе
				Если СтруктураОтвета.candidates.Количество() = 0 Тогда
					// если нет - добавим персону
					descriptor_id = СтруктураОтвета.face.id;
					person_id = ДобавитьНовуюПерсону(descriptor_id, УчетнаяЗаписьСервиса);
					// прикрепим к ней дескриптор
					ДобавитьДескрипторКПерсоне(person_id, descriptor_id, УчетнаяЗаписьСервиса);
					// добавим в список
					ДобавитьПерсонуВСписок(person_id, list_id, УчетнаяЗаписьСервиса);
					// добавим потенциального клиента
					ОбновитьФотографию(person_id, ФотоЛица, Камера, Помещение, ТекущееМероприятие);
					// добавим запись в журнал посещений
					ДобавитьЗаписьВЖурналПосещений(person_id, Камера, Помещение, ТекущееМероприятие);
				Иначе
					Если СтруктураОтвета.candidates[0].similarity < 0.98 Тогда // не нашли
						// если нет - добавим персону
						descriptor_id = СтруктураОтвета.face.id;
						person_id = ДобавитьНовуюПерсону(descriptor_id, УчетнаяЗаписьСервиса);
						// прикрепим к ней дескриптор
						ДобавитьДескрипторКПерсоне(person_id, descriptor_id, УчетнаяЗаписьСервиса);
						// добавим в список
						ДобавитьПерсонуВСписок(person_id, list_id, УчетнаяЗаписьСервиса);
						// добавим потенциального клиента
						ОбновитьФотографию(person_id, ФотоЛица, Камера, Помещение, ТекущееМероприятие);
						// добавим запись в журнал посещений
						ДобавитьЗаписьВЖурналПосещений(person_id, Камера, Помещение, ТекущееМероприятие);
					Иначе // нашли	
						person_id = СтруктураОтвета.candidates[0].person_id;
						descriptor_id = СтруктураОтвета.face.id;
						// прикрепим еще один дескриптор
						ДобавитьДескрипторКПерсоне(person_id, descriptor_id, УчетнаяЗаписьСервиса);
						// обновим фото, если нужно
						ОбновитьФотографию(person_id, ФотоЛица, Камера, Помещение, ТекущееМероприятие);
						// добавим запись в журнал посещений
						ДобавитьЗаписьВЖурналПосещений(person_id, Камера, Помещение, ТекущееМероприятие);
							
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

#КонецОбласти 
