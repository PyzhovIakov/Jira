
#Область СлужебныйПрограммныйИнтерфейс

Процедура ДозаполнитьПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы) Экспорт
	
	ВидыБизнеса = Новый ТаблицаЗначений;
	ВидыБизнеса.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Число"));
	ВидыБизнеса.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ВидыБизнеса.Колонки.Добавить("Синонимы", Новый ОписаниеТипов("Строка"));
	
	МакетКлассификаторВидовБизнеса = ПолучитьОбщийМакет("CRM_КлассификаторВидовБизнеса").ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(МакетКлассификаторВидовБизнеса);
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Наименование = ЧтениеXML.ПолучитьАтрибут("name");
			Идентификатор = ЧтениеXML.ПолучитьАтрибут("id");
			
			НоваяСтрока = ВидыБизнеса.Добавить();
			НоваяСтрока.Наименование = Наименование;
			НоваяСтрока.Идентификатор = Число(Идентификатор);
			
		ИначеЕсли ЧтениеXML.Имя = "biz" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			
			Продолжить;
			
		ИначеЕсли ЧтениеXML.Имя = "synonym" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ЧтениеXML.Прочитать();
			НоваяСтрока.Синонимы = НоваяСтрока.Синонимы + " " + ЧтениеXML.Значение;
			
		ИначеЕсли ЧтениеXML.Имя = "synonym" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыОткрытия.Вставить("ВидыБизнесаАдресВХранилище", ПоместитьВоВременноеХранилище(ВидыБизнеса));
	
КонецПроцедуры

Процедура ОбработкаЗакрытияФормыНачалаРаботы(ЗначенияРеквизитов, ПараметрыНачалаРаботы, ОбработкаЗавершена) Экспорт
	
	ПараметрыРаботыКлиента = ПараметрыНачалаРаботы.ПараметрыРаботыКлиента;
	
	ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	ОбновитьЗаписатьОрганизацию(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	ЗаписатьПараметрыЛицензирования(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	ЗаписатьПодтверждениеОтправкиСтатистики(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	ЗафиксироватьОкончаниеПервогоВходаВПрограмму(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	
	ОбработкаЗавершена = Истина;
	
КонецПроцедуры

// Добавляет необходимые параметры работы клиента при запуске.
//
// Параметры:
//	Параметры - Структура - заполняемые параметры;
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если РольДоступна("БазовыеПраваВнешнихПользователейБСП") Тогда
		ПоказатьОкноНачалоРаботыСПрограммой = Ложь;	
	Иначе
		ПоказатьОкноНачалоРаботыСПрограммой = НЕ ЗначениеЗаполнено(Константы.CRM_ДатаНачалаРаботыСПрограммой.Получить());
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			
			ПоказатьОкноНачалоРаботыСПрограммой = (ПоказатьОкноНачалоРаботыСПрограммой
				 И Пользователи.ЭтоПолноправныйПользователь());
			
		КонецЕсли;
	КонецЕсли;
	
	Параметры.Вставить("ПоказатьОкноНачалоРаботыСПрограммой", ПоказатьОкноНачалоРаботыСПрограммой);
	
КонецПроцедуры

// Регистрирует обработчики поставляемых данных
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "Константа.CRM_ДатаНачалаРаботыСПрограммой";
	Обработчик.КодОбработчика = 01;
	Обработчик.Обработчик = CRM_НачалоРаботыСПрограммойВызовСервера;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "Константа.CRM_ДатаНачалаРаботыСПрограммой" Тогда
		
		Загружать = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
	
КонецПроцедуры

// Функция возвращает значение дополнительного параметра
// параметр используется только для целей отладки
Функция ЗначениеДополнительногоПараметра() Экспорт
	
	Возврат ВРЕГ("#NotToBeSet");
	
КонецФункции // ЗначениеДополнительногоПараметра()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область CRM

// Дублируем метод из УправлениеКонтактнойИнформацией
Процедура ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаТабличнойЧасти, Источник)
	
	Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СтрокаТабличнойЧасти.Представление, Ложь);
	
	Если Результат.Количество() > 0 Тогда
		СтрокаТабличнойЧасти.АдресЭП = Результат[0].Адрес;
		
		Поз = СтрНайти(СтрокаТабличнойЧасти.АдресЭП, "@");
		Если Поз <> 0 Тогда
			СтрокаТабличнойЧасти.ДоменноеИмяСервера = Сред(СтрокаТабличнойЧасти.АдресЭП, Поз + 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	Перем ПользовательСсылка;
	
	Если Не ЗначенияРеквизитов.Свойство("Пользователь", ПользовательСсылка) Или
		 Не ЗначениеЗаполнено(ПользовательСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначенияРеквизитов.СозданиеПользователя Тогда
		
		ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
		
		ПользовательОбъект.Наименование = ЗначенияРеквизитов.ПользовательИмя;
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие",					"Записать");
		ОписаниеПользователяИБ.Вставить("Имя",						ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя",				ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("Пароль", 					ЗначенияРеквизитов.ПользовательПароль);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПарольУстановлен", 		Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора",	Истина);
		
		ДоступныеРоли = Новый Массив;
		ДоступныеРоли.Добавить(Метаданные.Роли.АдминистраторСистемы.Имя);
		ДоступныеРоли.Добавить(Метаданные.Роли.ПолныеПрава.Имя);
		ОписаниеПользователяИБ.Вставить("Роли", ДоступныеРоли);
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		ПользовательОбъект.ДополнительныеСвойства.Вставить("СозданиеАдминистратора",
			 НСтр("ru='Создание первого администратора.';
			|en='Creation of first administrator.'"));
		
		ПользовательОбъект.Служебный = Ложь;
		
	Иначе
		
		ПользовательОбъект = ПользовательСсылка.ПолучитьОбъект();
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЗначенияРеквизитов.ПользовательТелефон) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ТелефонПользователя;
		
		МассивСтрок = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0, ПользовательОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияПоПредставлению(ЗначенияРеквизитов.ПользовательТелефон,
			 ВидКИ, "");
		СтрокаКИ.Представление = ЗначенияРеквизитов.ПользовательТелефон;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЗначенияРеквизитов.ПользовательEmail) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;
		
		МассивСтрок = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0, ПользовательОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияПоПредставлению(ЗначенияРеквизитов.ПользовательEmail,
			 ВидКИ, "");
		СтрокаКИ.Представление = ЗначенияРеквизитов.ПользовательEmail;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		
		ЗаполнитьРеквизитыТабличнойЧастиДляАдресаЭлектроннойПочты(СтрокаКИ, ПользовательОбъект);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПользовательОбъект, Ложь, Истина);
	
КонецПроцедуры

Процедура ОбновитьЗаписатьОрганизацию(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	ОрганизацияОбъект = CRM_ОбщегоНазначенияСервер.ПолучитьПредопределеннуюОрганизацию().ПолучитьОбъект();
	ОрганизацияОбъект.СтавкаНДСПоУмолчанию = ЗначенияРеквизитов.СтавкаНДСПоУмолчанию;
	ОрганизацияОбъект.ЮрФизЛицо = ?(ЗначенияРеквизитов.ЭтоЮрЛицо, Перечисления.ЮрФизЛицо.ЮрЛицо,
		 Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель);
	
	ОрганизацияОбъект.Наименование				= ЗначенияРеквизитов.Наименование;
	ОрганизацияОбъект.НаименованиеСокращенное	= ЗначенияРеквизитов.Наименование;
	ОрганизацияОбъект.НаименованиеПолное		= ЗначенияРеквизитов.НаименованиеПолное;
	
	ОрганизацияОбъект.ИНН						= ЗначенияРеквизитов.ИНН;
	ОрганизацияОбъект.КПП						= ЗначенияРеквизитов.КПП;
	ОрганизацияОбъект.CRM_ОГРН					= ЗначенияРеквизитов.ОГРН;
	
	Если Не ПустаяСтрока(ЗначенияРеквизитов.АдресФактический) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
		
		МассивСтрок = ОрганизацияОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0, ОрганизацияОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияПоПредставлению(ЗначенияРеквизитов.АдресФактический,
			 ВидКИ, "");
		СтрокаКИ.Представление = ЗначенияРеквизитов.АдресФактический;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЗначенияРеквизитов.АдресЮридический) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
		
		МассивСтрок = ОрганизацияОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0, ОрганизацияОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияПоПредставлению(ЗначенияРеквизитов.АдресЮридический,
			 ВидКИ, "");
		СтрокаКИ.Представление = ЗначенияРеквизитов.АдресЮридический;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.Телефон) Тогда
		
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
		
		МассивСтрок = ОрганизацияОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", ВидКИ));
		
		СтрокаКИ = ?(МассивСтрок.Количество() = 0, ОрганизацияОбъект.КонтактнаяИнформация.Добавить(), МассивСтрок[0]);
		СтрокаКИ.Вид = ВидКИ;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияПоПредставлению(ЗначенияРеквизитов.Телефон,
			 ВидКИ, "");
		СтрокаКИ.Представление = ЗначенияРеквизитов.Телефон;
		СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
		
	КонецЕсли;
	
	Попытка
		
		ОрганизацияОбъект.Записать();
	
	Исключение
		
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации("Стартовое окно", УровеньЖурналаРегистрации.Ошибка,
			 Метаданные.Справочники.Организации, ТекстОшибки);
		
		ВызватьИсключение ОписаниеОшибки();
		
	КонецПопытки;
	
	
КонецПроцедуры

Процедура ЗаписатьПараметрыЛицензирования(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	Если ЗначенияРеквизитов.РежимСервиса Тогда
		Возврат;
	КонецЕсли;
	
	ВариантПоставки = ЗначенияРеквизитов.ВариантПоставки;
	
	ОсновнойВариантПоставки = Константы.CRM_ОсновнойВариантПоставки.СоздатьМенеджерЗначения();
	ОсновнойВариантПоставки.ОбменДанными.Загрузка = Истина;
	ОсновнойВариантПоставки.Значение = ВариантПоставки;
	ОсновнойВариантПоставки.Записать();
	
	Если Не (ВариантПоставки = Перечисления.CRM_ВариантыПоставки.СТАНДАРТ 
			Или ВариантПоставки = Перечисления.CRM_ВариантыПоставки.СТАРТ) Тогда
		Константы.CRM_ИспользоватьБизнесПроцессы.Установить(Истина);
	КонецЕсли;
	
	CRM_ЛицензированиеЭкспортныеМетоды.УстановитьВариантПоставки();
	
	Если Не ЗначениеЗаполнено(ЗначенияРеквизитов.АдресСервера) Тогда
		Возврат;
	КонецЕсли;
	
	Серия = CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьСтрокуСерииКлючейМодульCRM(0);
	
	АдресСервера = СтрЗаменить(ЗначенияРеквизитов.АдресСервера, "[", "");
	АдресСервера = СтрЗаменить(АдресСервера, "]", "");
	
	ДанныеАдресаСервера = СтрРазделить(АдресСервера, ":", Ложь);
	ДанныеЗащиты = слкМенеджерЗащитыСервер.ПолучитьМенеджерЗащиты();
	ПараметрыПодключения = ДанныеЗащиты[Серия].ПараметрыПодключения;
	
	ПараметрыПодключения.Host = ДанныеАдресаСервера[0];
	Если ДанныеАдресаСервера.Количество() > 1 Тогда
		ПараметрыПодключения.Port = ДанныеАдресаСервера[1];
	КонецЕсли;
	слкМенеджерЗащитыСервер.СохранитьНастройкиМенеджераСерииЗащиты(Серия, ПараметрыПодключения);
	
КонецПроцедуры

Процедура ЗаписатьПодтверждениеОтправкиСтатистики(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	Если ЗначенияРеквизитов.РежимСервиса Тогда
		Возврат;
	КонецЕсли;
	
	РазрешитьОтправкуСтатистики = ЗначенияРеквизитов.РазрешитьОтправкуСтатистики;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		
		ПараметрыОтправкиСтатистики = Новый Структура("ВключитьЦентрМониторинга,
			| ЦентрОбработкиИнформацииОПрограмме", Неопределено,
			 Неопределено);
		ПараметрыОтправкиСтатистики =
			МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыОтправкиСтатистики);
		
		Если (НЕ ПараметрыОтправкиСтатистики.ВключитьЦентрМониторинга
			 И ПараметрыОтправкиСтатистики.ЦентрОбработкиИнформацииОПрограмме) Тогда
			// Настроена отправка статистики стороннему разработчику, настройки не меняем.
		Иначе
			Если РазрешитьОтправкуСтатистики Тогда
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга",
					 РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме",
					 Ложь);
				РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики",
					 Истина);
				МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
			Иначе
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга",
					 РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме",
					 Ложь);
				МодульЦентрМониторингаСлужебный.УдалитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗафиксироватьОкончаниеПервогоВходаВПрограмму(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ТекущаяВерсия = ПараметрыРаботыКлиента.ВерсияДанныхОсновнойКонфигурации;
	
	Константы.CRM_ДатаНачалаРаботыСПрограммой.Установить(ТекущаяДата);
	Константы.CRM_ВерсияНачалаРаботыСПрограммой.Установить(ТекущаяВерсия);
	
	ДанныеРегистрации = Новый Структура;
	
	ДанныеРегистрации.Вставить("ДатаНачалаРаботы",			ТекущаяДата);
	ДанныеРегистрации.Вставить("ВерсияНачалаРаботы",		ТекущаяВерсия);
	
	ДанныеРегистрации.Вставить("ВидБизнесаИдентификатор",	ЗначенияРеквизитов.ВидБизнесаИдентификатор);
	ДанныеРегистрации.Вставить("ВидБизнесаНаименование",	ЗначенияРеквизитов.ВидБизнесаНаименование);
	ДанныеРегистрации.Вставить("КоличествоПользователей",	ЗначенияРеквизитов.КоличествоПользователей);
	ДанныеРегистрации.Вставить("РежимСервиса",				ЗначенияРеквизитов.РежимСервиса);
	
	ДанныеРегистрации.Вставить("ПользовательСайт",			ЗначенияРеквизитов.ПользовательСайт);
	
	ДанныеРегистрации.Вставить("ИНН",						ЗначенияРеквизитов.ИНН);
	ДанныеРегистрации.Вставить("НаименованиеПолное",		ЗначенияРеквизитов.НаименованиеПолное);
	ДанныеРегистрации.Вставить("ЮридическоеЛицо",			ЗначенияРеквизитов.ЭтоЮрЛицо);
	
	Константы.CRM_ДанныеРегистрации.Установить(Новый ХранилищеЗначения(ДанныеРегистрации));
	
КонецПроцедуры

Функция ЗаписатьНастроенныйРазделРешения(Раздел) Экспорт
	
	ЗаписьВыполнена = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Раздел) Тогда
		Возврат ЗаписьВыполнена;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Проверим наличие записи
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	CRM_НастроенныеРазделыРешения.РазделНастройки.Ссылка КАК РазделНастройкиСсылка
	               |ИЗ
	               |	РегистрСведений.CRM_НастроенныеРазделыРешения КАК CRM_НастроенныеРазделыРешения
	               |ГДЕ
	               |	CRM_НастроенныеРазделыРешения.РазделНастройки.Ссылка = &Раздел";
	
	Запрос.УстановитьПараметр("Раздел", Раздел);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Менеджер = РегистрыСведений.CRM_НастроенныеРазделыРешения.СоздатьМенеджерЗаписи();
		Менеджер.РазделНастройки = Раздел;
		Менеджер.Записать();
		ЗаписьВыполнена = Истина;
	КонецЕсли; 
	
	Если ЗаписьВыполнена Тогда
		ИмяФормы = Неопределено;
		Если Раздел = Перечисления.CRM_РазделыНастройкиРешения.Диалоги Тогда
			ИмяФормы = "Обработка.CRM_Мессенджер.Форма.ФормаМессенджера";
			Синоним = НСтр("ru='Диалоги';en='Dialogs'");
		ИначеЕсли Раздел = Перечисления.CRM_РазделыНастройкиРешения.ПочтовыйКлиент Тогда
			ИмяФормы = "Обработка.CRM_МенеджерПочты.Форма.Форма";
			Синоним = НСтр("ru='Почта';en='Mail'");
		ИначеЕсли Раздел = Перечисления.CRM_РазделыНастройкиРешения.Телефония Тогда
			ИмяФормы = "Обработка.сфпАРМ_Телефония.Форма.Форма";
			Синоним = НСтр("ru='Телефония';en='Telephony'");
		ИначеЕсли Раздел = Перечисления.CRM_РазделыНастройкиРешения.СценарииПродаж Тогда
			ИмяФормы = "Обработка.CRM_АРМ_МоиПродажи.Форма.Форма";
			Синоним = НСтр("ru='Мои продажи';en='My Sales'");
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяФормы) Тогда
			
			CRM_РабочийСтолСервер.ДобавитьФормуНаРабочийСтол(ИмяФормы, Синоним);
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗаписьВыполнена;
	
КонецФункции

#КонецОбласти

#КонецОбласти
