#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает параметры идентификации клиента
// 
// Возвращаемое значение:
//  Структура - структура с параметрами из макета client_secret_json (в зависимости от вида клиента)
//
Функция ИдентификацияПриложения() Экспорт
	
	Перем Результат;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификацияКлиента = Константы.CRM_ИдентификацияПриложенияGoogle.Получить();
	Если Не ЗначениеЗаполнено(ИдентификацияКлиента) Тогда
		ИдентификацияКлиента = ПолучитьМакет("client_secret_json").ПолучитьТекст();
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ИдентификацияКлиента);
	
	РезультатЧтенияJSON = ПрочитатьJSON(ЧтениеJSON);
	
	Для Каждого ВидИдентификации Из CRM_ОбменСGoogleКлиентСервер.ВидыИдентификацииПриложения() Цикл
		
		Если Не РезультатЧтенияJSON.Свойство(ВидИдентификации, Результат) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить("ВидИдентификации", ВидИдентификации);
		Возврат Результат;
		
	КонецЦикла;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru='Некорректный формат идентификации клиента Google: ожидается один из ключей: %1';
		|en='Incorrect format of client Google identification: one of this keys expect: %1'"),
	СтрСоединить(CRM_ОбменСGoogleКлиентСервер.ВидыИдентификацииПриложения(), ", "));
	
КонецФункции

// Возвращает данные, записанные в регистре сведений СеансовыеДанныеGoogle
//
// Параметры:
//  Пользователь 	- СправочникСсылка.Пользователи - пользователь, для которого требуется доступ
//  ОбластьДоступа 	- ПеречислениеСсылка.ОбластиДоступаGoogle - область доступа, к которой требуется доступ
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - указывается для области доступа "Почта"
//
// Возвращаемое значение:
//  Структура - ключи соответствуют ресурсам регистра СеансовыеДанныеGoogle
//   * access_token 	- Строка - токен доступа
//   * token_type 		- Строка - тип токена
//   * refresh_token 	- Строка - токен обновления
//
Функция СеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СеансовыеДанныеGoogle.access_token КАК access_token,
	|	СеансовыеДанныеGoogle.token_type КАК token_type,
	|	СеансовыеДанныеGoogle.refresh_token КАК refresh_token
	|ИЗ
	|	РегистрСведений.CRM_СеансовыеДанныеGoogle КАК СеансовыеДанныеGoogle
	|ГДЕ
	|	СеансовыеДанныеGoogle.Пользователь = &Пользователь
	|	И СеансовыеДанныеGoogle.ОбластьДоступа = &ОбластьДоступа");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ОбластьДоступа", ОбластьДоступа);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Для Каждого Поле Из РезультатЗапроса.Колонки Цикл
			Результат.Вставить(Поле.Имя, Выборка[Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполняет чтение сеансовых данных из регистра и,
// в случае необходимости, обновление данных из Google
//
// Параметры:
//  Данные			- Структура - Сеансовые данные, ключи соответствуют ресурсам регистра СеансовыеДанныеGoogle.
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - указывается для области доступа "Почта".
// 
Процедура ПрочитатьИОбновитьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа,
	 УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Данные = СеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
	
	Если CRM_ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТокенДоступаДействителен(
		Данные.access_token) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
	
	Данные = СеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
	
	Если CRM_ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(Данные) Тогда
		Возврат;
	КонецЕсли;

	Если ТокенДоступаДействителен(
		Данные.access_token) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	
КонецПроцедуры

// Выполняет запись данных в регистр в случае если они прошли проверку Google
//
// Параметры:
//  Данные 	 		- Структура - сеансовые данные,  ключи соответствуют ресурсам регистра СеансовыеДанныеGoogle.
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - указывается для области доступа "Почта".
// 
Процедура ПроверитьИЗаписатьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа,
	 УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	Если CRM_ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТокенДоступаДействителен(
		Данные.access_token) Тогда
		ЗаписатьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
		//РегистрыСведений.ЗаданияОбменаСGoogle.ВключитьПоОбластиДоступа(ОбластьДоступа);
	Иначе
		ОбновитьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
		Данные = СеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет токен доступа в Google с использованем значения "refresh_token"
// и записывает полученные данные в регистр сведений
//
// Параметры:
//  Данные 			- Структура - Структура, содержащая токен для обновления в поле "refresh_token".
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Указывается для области доступа "Почта".
//
Процедура ОбновитьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа,
	 УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	Если Не Данные.Свойство("refresh_token") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Данные.refresh_token) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификацияПриложения = ИдентификацияПриложения();
	
	АдресДляПолученияТокенаДоступа = ОбщегоНазначенияКлиентСервер.СтруктураURI(
	ИдентификацияПриложения.token_uri);
	
	ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(АдресДляПолученияТокенаДоступа.Схема);
	
	HTTPСоединение = Новый HTTPСоединение(
		АдресДляПолученияТокенаДоступа.Хост,
		АдресДляПолученияТокенаДоступа.Порт, , ,
		ИнтернетПрокси, 20,
		Новый ЗащищенноеСоединениеOpenSSL);
	
	ЗапросHTTP = Новый HTTPЗапрос;
	ЗапросHTTP.АдресРесурса = АдресДляПолученияТокенаДоступа.ПутьНаСервере;
	ЗапросHTTP.Заголовки["Content-Type"] = "application/x-www-form-urlencoded";
	ЗапросHTTP.УстановитьТелоИзСтроки(
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	"grant_type=refresh_token&client_id=%1&client_secret=%2&refresh_token=%3",
	ИдентификацияПриложения.client_id,
	ИдентификацияПриложения.client_secret,
	Данные.refresh_token));
	
	ОтветHTTP = HTTPСоединение.ОтправитьДляОбработки(ЗапросHTTP);
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
	РезультатЧтенияJSON = ПрочитатьJSON(ЧтениеJSON);
	
	Если Не РезультатЧтенияJSON.Свойство("access_token") Тогда
		УдалитьСеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
		Возврат;
	КонецЕсли;
	
	Если Не РезультатЧтенияJSON.Свойство("refresh_token") Тогда
		РезультатЧтенияJSON.Вставить("refresh_token", Данные.refresh_token);
	КонецЕсли;
	
	ЗаписатьСеансовыеДанные(РезультатЧтенияJSON, Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты);
	
КонецПроцедуры

// Записывает данные сеанса OAuth в регистр сведений СеансовыеДанныеGoogle
//
// Параметры:
//  Данные 			- Структура - сеансовые данные, ключи соответствуют ресурсам регистра СеансовыеДанныеGoogle.
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - указывается для области 
//
Процедура ЗаписатьСеансовыеДанные(Данные, Пользователь, ОбластьДоступа,
	 УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	Если CRM_ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.CRM_СеансовыеДанныеGoogle");
		ЭлементБлокировки.УстановитьЗначение("Пользователь", Пользователь);
		БлокировкаДанных.Заблокировать();
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Данные);
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.ОбластьДоступа = ОбластьДоступа;
		МенеджерЗаписи.УчетнаяЗаписьЭлектроннойПочты = УчетнаяЗаписьЭлектроннойПочты;
		МенеджерЗаписи.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удаляет сеансовые данные в регистре сведений СеансовыеДанныеGoogle
//
// Параметры:
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - указывается для области 
//
Процедура УдалитьСеансовыеДанные(Пользователь, ОбластьДоступа, УчетнаяЗаписьЭлектроннойПочты = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.CRM_СеансовыеДанныеGoogle");
		ЭлементБлокировки.УстановитьЗначение("Пользователь", Пользователь);
		БлокировкаДанных.Заблокировать();
		
		МенеджерЗаписи = СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.ОбластьДоступа = ОбластьДоступа;
		МенеджерЗаписи.УчетнаяЗаписьЭлектроннойПочты = УчетнаяЗаписьЭлектроннойПочты;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Проверяет токен доступа на сервере Google
//
// Параметры:
//  ТокенДоступа - Строка - токен доступа, полученный в процессе авторизации OAuth2
// 
// Возвращаемое значение:
//  Булево - признак действетельности токена доступа
//
Функция ТокенДоступаДействителен(ТокенДоступа) Экспорт
	
	Если Не ЗначениеЗаполнено(ТокенДоступа) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	АдресДляПолученияТокенаДоступа = ОбщегоНазначенияКлиентСервер.СтруктураURI(
	"https://www.googleapis.com/oauth2/v1/tokeninfo");
	
	ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(АдресДляПолученияТокенаДоступа.Схема);
	
	HTTPСоединение = Новый HTTPСоединение(
		АдресДляПолученияТокенаДоступа.Хост,
		АдресДляПолученияТокенаДоступа.Порт, , ,
		ИнтернетПрокси, 20,
		Новый ЗащищенноеСоединениеOpenSSL);
	
	ЗапросHTTP = Новый HTTPЗапрос;
	ЗапросHTTP.АдресРесурса = АдресДляПолученияТокенаДоступа.ПутьНаСервере;
	ЗапросHTTP.Заголовки["Content-Type"] = "application/x-www-form-urlencoded";
	ЗапросHTTP.УстановитьТелоИзСтроки(
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("access_token=%1", ТокенДоступа));
	
	ОтветHTTP = HTTPСоединение.ОтправитьДляОбработки(ЗапросHTTP);
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветHTTP.ПолучитьТелоКакСтроку());
	РезультатЧтенияJSON = ПрочитатьJSON(ЧтениеJSON);
	
	Если РезультатЧтенияJSON.Свойство("expires_in") И РезультатЧтенияJSON.expires_in < 300 Тогда
		// Если токену доступа осталось жить меньше пяти минут, принудительно обновляем
		Возврат Ложь;
	КонецЕсли;
	
	Если Не РезультатЧтенияJSON.Свойство("issued_to") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Ключевая проверка: идентификаторы для действительного токена должны совпадать
	
	Возврат РезультатЧтенияJSON.issued_to = ИдентификацияПриложения().client_id;
	
КонецФункции

// Отключает указанную область доступа для указанного пользователя
//
// Параметры:
//  Пользователь	- СправочникСсылка.Пользователи - Пользователь.
//  ОбластьДоступа	- ПеречислениеСсылка.ОбластиДоступаGoogle - Область доступа.
//  Отключить		 - Булево - Истина - область отключена, Ложь - включена.
//
Процедура ОтключитьОбластьДоступа(Пользователь, ОбластьДоступа, Отключить) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.ОбластьДоступа = ОбластьДоступа;
	МенеджерЗаписи.disabled = Отключить;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Функция возвращает массив областей доступа,
// для которых указанный пользователь отключил использование
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
// 
// Возвращаемое значение:
//  Массив - массив значений типа ПеречислениеСсылка.ОбластиДоступаGoogle
//
Функция ОтключенныеОбластиДоступа(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СеансовыеДанныеGoogle.ОбластьДоступа КАК ОбластьДоступа
	|ИЗ
	|	РегистрСведений.CRM_СеансовыеДанныеGoogle КАК СеансовыеДанныеGoogle
	|ГДЕ
	|	СеансовыеДанныеGoogle.disabled
	|	И СеансовыеДанныеGoogle.Пользователь = &Пользователь");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции

#КонецОбласти

#КонецЕсли
