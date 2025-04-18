	
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидыБизнесаАдресВХранилище") Тогда
		ВидыБизнесаТЗ = ПолучитьИзВременногоХранилища(Параметры.ВидыБизнесаАдресВХранилище);
		ВидыБизнеса.Загрузить(ВидыБизнесаТЗ);
	КонецЕсли;
	
	ОрганизацияИмя = ?(CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM(), "ОсновнаяОрганизация", "УправленческаяОрганизация");
	ОрганизацияСсылка = Справочники.Организации[ОрганизацияИмя];
	
	Пользователь = Пользователи.АвторизованныйПользователь();
	ПользовательНеУказан = Пользователи.СсылкаНеуказанногоПользователя(Истина);
	
	Наименование = НСтр("ru='Наша фирма';en='Our firm'");
	НаименованиеПолное = НСтр("ru='Наша фирма';en='Our firm'");
	ЮрФизЛицо = ?(ЗначениеЗаполнено(ОрганизацияСсылка.ЮрФизЛицо), ОрганизацияСсылка.ЮрФизЛицо,
		 Перечисления.ЮрФизЛицо.ЮрЛицо);
	СтавкаНДСПоУмолчанию = ?(ЗначениеЗаполнено(ОрганизацияСсылка.СтавкаНДСПоУмолчанию),
		 ОрганизацияСсылка.СтавкаНДСПоУмолчанию,
		 ОрганизацияСсылка.СтавкаНДСПоУмолчанию.ПустаяСсылка());
	
	КоличествоПользователей = 1;
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("Пользователь",				Пользователь);
	КэшЗначений.Вставить("ПользовательНеУказан",		ПользовательНеУказан);
	КэшЗначений.Вставить("РазрешитьЗакрытие",			Ложь);
	КэшЗначений.Вставить("ДополнительныйПараметр",		CRM_НачалоРаботыСПрограммойВызовСервера.ЗначениеДополнительногоПараметра());
	КэшЗначений.Вставить("ЮрЛицо",						Перечисления.ЮрФизЛицо.ЮрЛицо);
	КэшЗначений.Вставить("ФизЛицо",						Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель);
	КэшЗначений.Вставить("ТекущийИндексОрганизации",	Неопределено);
	
	ПользовательСсылка	= КэшЗначений.Пользователь;
	Если Пользователь <> ПользовательНеУказан Тогда
		ПользовательИмя = ПользовательСсылка.Наименование;
	КонецЕсли;
	ПользовательEmail	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ПользовательСсылка,
		 Справочники.ВидыКонтактнойИнформации.EmailПользователя);
	ПользовательТелефон	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ПользовательСсылка,
		 Справочники.ВидыКонтактнойИнформации.ТелефонПользователя);
	
	ВариантПоставки = ?(СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации(), 
						Перечисления.CRM_ВариантыПоставки.БАЗОВАЯ,
						Перечисления.CRM_ВариантыПоставки.СТАНДАРТ);
	
	РежимСервиса = ОбщегоНазначения.РазделениеВключено();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		 "ГруппаПользовательЛокально", "Видимость",
		 Не РежимСервиса);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПользовательСервис",
		 "Видимость",
		 РежимСервиса);
	Элементы.Декорация3.Видимость = НЕ РежимСервиса;
	Элементы.ГруппаЗаголовокШаг4.Видимость = Не РежимСервиса;
	Элементы.ГруппаСистемаЛицензирования.Видимость = Не РежимСервиса;
	Элементы.Email.АвтоОтметкаНезаполненного = РежимСервиса;
	
	СсылкаПомощи = CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("quick-start");
	ЭлементыЗаголовка = Новый Массив;
	ЭлементыЗаголовка.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Не знаете с чего начать? Посмотрите обучающие видео-ролики в разделе ';
		|en='Do you know how to begin? Watch training videos in the section '")));
	ЭлементыЗаголовка.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Быстрый старт';
		|en='Quick start'"), , ЦветаСтиля.CRM_ОсновнойГолубой, ,
		 СсылкаПомощи));
	
	Элементы.Декорация3.Заголовок = Новый ФорматированнаяСтрока(ЭлементыЗаголовка);
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует И Не РежимСервиса Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		ПараметрыЦентраМониторинга = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов();
		Если (НЕ ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга
			 И  НЕ ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме) Тогда
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Истина;
		Иначе
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ КэшЗначений.РазрешитьЗакрытие Тогда
		
		ТекстПредупреждения = НСтр("ru='Заполните, пожалуйста, обязательные поля."
"Работа программы без указанных сведений затруднительна.';en='Please fill in required fields."
"Work program without this information are difficult.'");
			
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	ИНН = "";
	
	Если ЮрФизЛицо = КэшЗначений.ЮрЛицо Тогда
		
		Фамилия = "";
		Имя = "";
		Отчество = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаголовокНаименование",
			 "Заголовок",
			 Нстр("ru='Название:'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаФИО", "Видимость", Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаголовокНаименование",
			 "Заголовок",
			 Нстр("ru='ФИО:'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаФИО", "Видимость", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	НаименованиеПолное = Наименование; 
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	СтруктураНазваний = СформироватьНаименованиеИП();
	
	Наименование = СтруктураНазваний.Наименование;
	НаименованиеПолное = СтруктураНазваний.НаименованиеПолное;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	СтруктураНазваний = СформироватьНаименованиеИП();
	
	Наименование = СтруктураНазваний.Наименование;
	НаименованиеПолное = СтруктураНазваний.НаименованиеПолное;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	СтруктураНазваний = СформироватьНаименованиеИП();
	
	Наименование = СтруктураНазваний.Наименование;
	НаименованиеПолное = СтруктураНазваний.НаименованиеПолное;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	Перем Ошибки;
	
	ЮрФизЛицо = ?(СтрДлина(ИНН) = 12, КэшЗначений.ФизЛицо, КэшЗначений.ЮрЛицо);
	
	Если ЮрФизЛицо = КэшЗначений.ЮрЛицо Тогда
		
		Фамилия = "";
		Имя = "";
		Отчество = "";
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаголовокНаименование",
			 "Заголовок",
			 Нстр("ru='Название:'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаФИО", "Видимость", Ложь);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаголовокНаименование",
			 "Заголовок",
			 Нстр("ru='ФИО:'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Наименование", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаФИО", "Видимость", Истина);
		
	КонецЕсли;
	
	ДанныеГосРеестра = Новый Структура;
	ЗаполнитьРеквизитыПоИНН(ИНН, ДанныеГосРеестра, Ошибки);
	
	// Стартовое окно не должно сообщать о существующих ошибках в учетных данных.
	// Цель быстро собрать сведения, если они ошибочные - продолжить работу.
	// ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	Если ДанныеГосРеестра.Количество() > 0 Тогда
		
		Если ДанныеГосРеестра.Свойство("Наименование") 
			И НЕ ПустаяСтрока(ДанныеГосРеестра.Наименование) Тогда
			Наименование = ДанныеГосРеестра.Наименование;
		КонецЕсли;
		
		Если ДанныеГосРеестра.Свойство("КПП") Тогда
			КПП = ДанныеГосРеестра.КПП;
		КонецЕсли;
		
		НаименованиеПолное = ДанныеГосРеестра.НаименованиеПолное;
		ОГРН = ДанныеГосРеестра.ОГРН;
		
		ДанныеЮридическогоАдреса = ДанныеГосРеестра.ЮридическийАдрес;
		Если ТипЗнч(ДанныеЮридическогоАдреса) = Тип("Структура") И
			 ДанныеЮридическогоАдреса.Свойство("Представление") Тогда
			АдресЮридический = ДанныеЮридическогоАдреса.Представление;
			АдресФактический = ДанныеЮридическогоАдреса.Представление;
		КонецЕсли;
		
		Телефон = ДанныеГосРеестра.Телефон;
		
		Если Не ДанныеГосРеестра.ЭтоЮрЛицо Тогда
			Фамилия = ДанныеГосРеестра.Фамилия;
			Имя = ДанныеГосРеестра.Имя;
			Отчество = ДанныеГосРеестра.Отчество;
		Иначе
			Фамилия = "";
			Имя = "";
			Отчество = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПодтверждениеПриИзменении(Элемент)
	
	Если ПользовательПароль <> ПользовательПарольПодтверждение Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не совпадают пароли'"), ,
			 "ПользовательПарольПодтверждение");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеВидаБизнесаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
	 Ожидание,
	 СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = ПодобратьВидыБизнеса(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеВидаБизнесаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторВидаБизнеса = ВыбранноеЗначение;
	Строки = ВидыБизнеса.НайтиСтроки(Новый Структура("Идентификатор", ВыбранноеЗначение));
	Если Строки.Количество() > 0 Тогда
		ОписаниеВидаБизнеса = Строки[0].Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛоготипНажатие(Элемент)
	Если Не РежимСервиса Тогда
		ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("1crm.ru"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПользователейПриИзменении(Элемент)
	
	Если КоличествоПользователей = 0 Тогда
		КоличествоПользователей = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура EmailПриИзменении(Элемент)
	РезультатПроверки = CRM_ОбщегоНазначенияКлиентСервер.АнализАдресаЭП(СокрЛП(ПользовательEmail));
	Если РезультатПроверки.КодОшибки <> 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.Сообщение, , "ПользовательEmail");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантПоставкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НачатьРаботуСПрограммой(Команда)
	
	Перем Ошибки;
	
	ДополнительныйПараметр = "";
	Если ВРЕГ(ПользовательИмя) = КэшЗначений.ДополнительныйПараметр Тогда
		ДополнительныйПараметр = КэшЗначений.ДополнительныйПараметр;
		КэшЗначений.РазрешитьЗакрытие = Истина;
	Иначе
		РеквизитыЗаполненыКорректно(Ошибки);
		КэшЗначений.РазрешитьЗакрытие = (Ошибки = Неопределено);
		Если НЕ КэшЗначений.РазрешитьЗакрытие Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	РезультатПроверки = CRM_ОбщегоНазначенияКлиентСервер.АнализАдресаЭП(СокрЛП(ПользовательEmail));
	Если РезультатПроверки.КодОшибки <> 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.Сообщение, , "ПользовательEmail");
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("НачатьРаботу", 					Истина);
	
	ПараметрыЗакрытия.Вставить("Пользователь",					КэшЗначений.Пользователь);
	ПараметрыЗакрытия.Вставить("ПользовательEmail",				ПользовательEmail);
	ПараметрыЗакрытия.Вставить("ПользовательИмя",				ПользовательИмя);
	ПараметрыЗакрытия.Вставить("ПользовательПароль",			ПользовательПароль);
	ПараметрыЗакрытия.Вставить("ПользовательСайт",				ПользовательСайт);
	ПараметрыЗакрытия.Вставить("ПользовательТелефон",			ПользовательТелефон);
	
	ПараметрыЗакрытия.Вставить("СозданиеПользователя",			Не ЗначениеЗаполнено(КэшЗначений.Пользователь)
		Или КэшЗначений.Пользователь = КэшЗначений.ПользовательНеУказан);
	
	ПараметрыЗакрытия.Вставить("Наименование",					Наименование);
	ПараметрыЗакрытия.Вставить("НаименованиеПолное",			НаименованиеПолное);
	
	ПараметрыЗакрытия.Вставить("ИНН",							ИНН);
	ПараметрыЗакрытия.Вставить("КПП",							КПП);
	ПараметрыЗакрытия.Вставить("ОГРН",							ОГРН);
	ПараметрыЗакрытия.Вставить("СтавкаНДСПоУмолчанию",          СтавкаНДСПоУмолчанию);
	
	ПараметрыЗакрытия.Вставить("АдресФактический",				АдресФактический);
	ПараметрыЗакрытия.Вставить("АдресЮридический",				АдресЮридический);
	ПараметрыЗакрытия.Вставить("Телефон",						Телефон);
	
	ПараметрыЗакрытия.Вставить("ЭтоЮрЛицо",						ЮрФизЛицо = КэшЗначений.ЮрЛицо);
	
	ПараметрыЗакрытия.Вставить("ВидБизнесаИдентификатор",		ИдентификаторВидаБизнеса);
	ПараметрыЗакрытия.Вставить("ВидБизнесаНаименование",		ОписаниеВидаБизнеса);
	ПараметрыЗакрытия.Вставить("КоличествоПользователей",		КоличествоПользователей);
	ПараметрыЗакрытия.Вставить("РежимСервиса",					РежимСервиса);
	
	ПараметрыЗакрытия.Вставить("ВариантПоставки",				ВариантПоставки);
	ПараметрыЗакрытия.Вставить("АдресСервера",					СокрЛП(АдресСервера));
	
	ПараметрыЗакрытия.Вставить("РазрешитьОтправкуСтатистики",	РазрешитьОтправкуСтатистики);
	
	ПараметрыЗакрытия.Вставить("ДополнительныйПараметр",		ДополнительныйПараметр);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СформироватьНаименованиеИП()
	
	Наименование = СокрЛП(Фамилия);
	Если Не ПустаяСтрока(Имя) Тогда
		Наименование = Наименование + " " + Лев(СокрЛ(Имя), 1) + ".";
	КонецЕсли;
	Если Не ПустаяСтрока(Отчество) Тогда
		Наименование = Наименование + " " + Лев(СокрЛ(Отчество), 1) + ".";
	КонецЕсли;
	Наименование = Наименование + НСтр("ru=' ИП'");
	
	НаименованиеПолное = "ИП " + СокрЛП(Фамилия);
	Если Не ПустаяСтрока(Имя) Тогда
		НаименованиеПолное = НаименованиеПолное + " " + Лев(СокрЛ(Имя), 1) + ".";
	КонецЕсли;
	Если Не ПустаяСтрока(Отчество) Тогда
		НаименованиеПолное = НаименованиеПолное + " " + Лев(СокрЛ(Отчество), 1) + ".";
	КонецЕсли;
	
	Возврат Новый Структура("Наименование, НаименованиеПолное", Наименование, НаименованиеПолное);
	
КонецФункции

&НаКлиенте
Процедура РеквизитыЗаполненыКорректно(Ошибки)
	
	Если ПустаяСтрока(ПользовательИмя) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПользовательИмя",
			 НСтр("ru='Заполните имя пользователя'"),
			 "");
	КонецЕсли;
	
	Если ПустаяСтрока(ПользовательEmail) И РежимСервиса Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПользовательEmail", НСтр("ru='Укажите e-mail'"), "");
	КонецЕсли;
	
	Если ПользовательПароль <> ПользовательПарольПодтверждение Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПользовательПароль",
			 НСтр("ru='Не совпадают пароли'"),
			 "");
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		
		ТекстОшибки = НСтр("ru='Заполните название'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Наименование", ТекстОшибки, "");
		
	КонецЕсли;
	
	Если ЮрФизЛицо = КэшЗначений.ФизЛицо Тогда
		
		Если ПустаяСтрока(Фамилия) Тогда
			
			ТекстОшибки = НСтр("ru='Заполните фамилию'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Фамилия", ТекстОшибки, "");
			
		КонецЕсли;
		
		Если ПустаяСтрока(Имя) Тогда
			
			ТекстОшибки = НСтр("ru='Заполните имя'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Имя", ТекстОшибки, "");
			
		КонецЕсли;
		
		// Отчество - не является обязательным
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодобратьВидыБизнеса(Текст)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗапросТекстРазделитель =
	";
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ЗапросТекстОбъединить =
	"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|";
	
	ЗапросТекстВыборНаименование =
	"ВЫБРАТЬ
	|	ВидыБизнеса№.Наименование КАК Наименование,
	|	ВидыБизнеса№.Синонимы КАК Синонимы,
	|	ВидыБизнеса№.Идентификатор КАК Идентификатор,
	|	1,
	|	№
	|ИЗ
	|	ВидыБизнесаВрем КАК ВидыБизнеса№
	|ГДЕ
	|	ВидыБизнеса№.Наименование ПОДОБНО &Текст№";
	
	ЗапросТекстВыборСинонимы =
	"ВЫБРАТЬ
	|	ВидыБизнеса№.Наименование КАК Наименование,
	|	ВидыБизнеса№.Синонимы КАК Синонимы,
	|	ВидыБизнеса№.Идентификатор КАК Идентификатор,
	|	1,
	|	№
	|ИЗ
	|	ВидыБизнесаВрем КАК ВидыБизнеса№
	|ГДЕ
	|	ВидыБизнеса№.Синонимы ПОДОБНО &Текст№";
	
	ЗапросТекстИтог =
	"ВЫБРАТЬ
	|	Список1.Наименование КАК Наименование,
	|	Список1.Синонимы КАК Синонимы,
	|	Список1.Идентификатор КАК Идентификатор,
	|	СУММА(Список1.Релевантность) КАК Поле1,
	|	СУММА(Список1.Релевантность2) КАК Поле2
	|ИЗ
	|	Список1 КАК Список1
	|
	|СГРУППИРОВАТЬ ПО
	|	Список1.Наименование,
	|	Список1.Синонимы,
	|	Список1.Идентификатор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Поле1 УБЫВ,
	|	Поле2 УБЫВ
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыБизнеса.Наименование КАК Наименование,
	|	ВидыБизнеса.Синонимы КАК Синонимы,
	|	ВидыБизнеса.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ВидыБизнесаВрем
	|ИЗ
	|	&ВидыБизнеса КАК ВидыБизнеса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыБизнеса1.Наименование КАК Наименование,
	|	ВидыБизнеса1.Синонимы КАК Синонимы,
	|	ВидыБизнеса1.Идентификатор КАК Идентификатор,
	|	1 КАК Релевантность,
	|	0 КАК Релевантность2
	|ПОМЕСТИТЬ Список1
	|ИЗ
	|	ВидыБизнесаВрем КАК ВидыБизнеса1
	|ГДЕ
	|	ВидыБизнеса1.Наименование ПОДОБНО &Текст1
	|";
	Запрос.УстановитьПараметр("ВидыБизнеса", ВидыБизнеса.Выгрузить());
	Запрос.УстановитьПараметр("Текст1", Текст);
	
	Итератор = 2;
	Отборы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
	Для каждого ТекстОтбор Из Отборы Цикл
		
		ЧастьЗапроса = СтрЗаменить(ЗапросТекстВыборНаименование, "№", Итератор);
		Запрос.Текст = Запрос.Текст + ЗапросТекстОбъединить + ЧастьЗапроса;
		Запрос.УстановитьПараметр("Текст" + Итератор, "%" + ТекстОтбор + "%");
		
		Итератор = Итератор + 1;
		
	КонецЦикла;
	
	Отборы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
	Для каждого ТекстОтбор Из Отборы Цикл
		
		ЧастьЗапроса = СтрЗаменить(ЗапросТекстВыборСинонимы, "№", Итератор);
		Запрос.Текст = Запрос.Текст + ЗапросТекстОбъединить + ЧастьЗапроса;
		Запрос.УстановитьПараметр("Текст" + Итератор, "%" + ТекстОтбор + "%");
		
		Итератор = Итератор + 1;
		
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + ЗапросТекстРазделитель  + ЗапросТекстИтог;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый СписокЗначений;
	
	Пока Выборка.Следующий() Цикл
		
		Идентификатор = Выборка.Идентификатор;
		Представление = Выборка.Наименование;
		
		Результат.Добавить(Идентификатор, Представление);
		
	КонецЦикла;
	
	Результат.СортироватьПоПредставлению();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыПоИНН(ИНН, ДанныеГосРеестра, Ошибки)
	
	ЭтоЮрЛицо = ?(СтрДлина(ИНН) = 12, Ложь, Истина);
	
	Если ЭтоЮрЛицо Тогда
		СведенияКонтрагента = РаботаСКонтрагентами.СведенияОЮридическомЛицеПоИНН(ИНН);
		Если ЗначениеЗаполнено(СведенияКонтрагента.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , СведенияКонтрагента.ОписаниеОшибки, "");
			Возврат;
		КонецЕсли;
		
		ЗначениеРеквизитов = СведенияКонтрагента.ЕГРЮЛ;
		Если ЗначениеРеквизитов = Неопределено Тогда
			ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Не удалось найти данные для заполнения реквизитов по ИНН %1.'"), ИНН);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ОписаниеОшибки, "");
			Возврат;
		КонецЕсли;
		
	Иначе
		ЗначениеРеквизитов = РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН(ИНН);
		Если ЗначениеЗаполнено(ЗначениеРеквизитов.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ЗначениеРеквизитов.ОписаниеОшибки, "");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеГосРеестра.Вставить("ЭтоЮрЛицо", ЭтоЮрЛицо);
	ДанныеГосРеестра.Вставить("Наименование", ЗначениеРеквизитов.Наименование);
	ДанныеГосРеестра.Вставить("НаименованиеПолное", ЗначениеРеквизитов.НаименованиеСокращенное);
	ДанныеГосРеестра.Вставить("ИНН", ЗначениеРеквизитов.ИНН);
	ДанныеГосРеестра.Вставить("ОГРН", ЗначениеРеквизитов.РегистрационныйНомер);
	
	Если ЭтоЮрЛицо Тогда
		
		ДанныеГосРеестра.Вставить("КПП", ЗначениеРеквизитов.КПП);
		ДанныеГосРеестра.Вставить("КодОКВЭД", ЗначениеРеквизитов.Код);
		ДанныеГосРеестра.Вставить("ЮридическийАдрес", ЗначениеРеквизитов.ЮридическийАдрес);
		ДанныеГосРеестра.Вставить("Телефон", ЗначениеРеквизитов.Телефон);
		
	Иначе
		
		ДанныеГосРеестра.Вставить("КодОКВЭД", Неопределено);
		ДанныеГосРеестра.Вставить("ЮридическийАдрес", Неопределено);
		ДанныеГосРеестра.Вставить("Телефон", Неопределено);
		
		ДанныеГосРеестра.Вставить("Фамилия", ЗначениеРеквизитов.Фамилия);
		ДанныеГосРеестра.Вставить("Имя", ЗначениеРеквизитов.Имя);
		ДанныеГосРеестра.Вставить("Отчество", ЗначениеРеквизитов.Отчество);
		
	КонецЕсли;
	
	ДанныеГосРеестра.Вставить("ЮрФизЛицо", ?(ЭтоЮрЛицо, Перечисления.ЮрФизЛицо.ЮрЛицо, Перечисления.ЮрФизЛицо.ФизЛицо));
	
	ЗаполнитьСписокВыбораНаименования(ДанныеГосРеестра);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораНаименования(ДанныеГосРеестра)
	
	СписокВыбора = Элементы.Наименование.СписокВыбора;
	СписокВыбора.Очистить();
	
	Если Не ПустаяСтрока(ДанныеГосРеестра.НаименованиеПолное) Тогда
		СписокВыбора.Добавить(ДанныеГосРеестра.НаименованиеПолное);
	КонецЕсли;
	
	Если СписокВыбора.Количество() > 0 Тогда
		ДанныеГосРеестра.Наименование = СписокВыбора[0].Значение;
		Элементы.Наименование.КнопкаВыпадающегоСписка = Истина;
	Иначе
		ДанныеГосРеестра.Наименование = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
