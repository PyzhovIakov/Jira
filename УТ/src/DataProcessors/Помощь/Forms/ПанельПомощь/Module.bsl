
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоискНаИТСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
		Ссылка = "https://its.1c.ru/db/erpdoc";
	ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда 
		Ссылка = "https://its.1c.ru/db/kadoc";
	Иначе
		Ссылка = "https://its.1c.ru/db/utdoc";
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорумБУХНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://buh.ru/forum/");
	
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗаконодательстваНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://v8.1c.ru/lawmonitor/");
	
КонецПроцедуры

&НаКлиенте
Процедура ЛекторийНажатие(Элемент)
	
	 ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru/lector?utm_source=bp30&utm_medium=prog&utm_content=PoleznayaInformatsiyaGlavnoe");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидеоурокиНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://v8.1c.ru/metod/courses/1s-erp-upravlenie-predpriyatiem/");
	
КонецПроцедуры

&НаКлиенте
Процедура ЦентрИдейНажатие(Элемент)
	
	ИнформационныйЦентрКлиент.ОткрытьЦентрИдей();
	
КонецПроцедуры

&НаКлиенте
Процедура ФорумФрешНажатие(Элемент)
	
	ИнформационныйЦентрКлиент.ОткрытьОбсужденияНаФоруме();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбратитьсяВСлужбуПоддержкиНажатие(Элемент)
	
	Если ИспользуетсяРазделениеДанных Тогда
		ИнформационныйЦентрКлиент.ОткрытьОбращенияВСлужбуПоддержки();
	Иначе
		ИнтернетПоддержкаПользователейУПКлиент.ОтправитьСообщениеСПомощьюВебСтраницыИТС();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаписатьВЧатНажатие(Элемент)
	
	ИнтеграцияСКоннектКлиент.СвязатьсяСоСпециалистом();
	
КонецПроцедуры

&НаКлиенте
Процедура БагбоардНажатие(Элемент)
	
	Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
		Ссылка = "erp2";
	ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда
		Ссылка = "ara20";
	Иначе
		Ссылка = "trade11";
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://bugboard.v8.1c.ru/project/" + Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НовостиНажатие(Элемент)
	
	ОткрытьФорму("Справочник.Новости.Форма.ФормаПросмотраНовостей",,, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеБизнесПроцессовНажатие(Элемент)
	ОткрытьФорму("Справочник.ДемонстрационныеСценарии.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура НовоеВПрограммеНажатие(Элемент)
	Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
		Ссылка = "https://its.1c.ru/db/updinfo#content:217:hdoc";
	ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда 
		Ссылка = "https://its.1c.ru/db/updinfo#content:392:hdoc";
	Иначе
		Ссылка = "https://its.1c.ru/db/updinfo#content:284:hdoc";
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходНаИсточникПоискаНажатие(Элемент)
	Если МеханизмПоиска = "Яндекс" Тогда         
		Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
			Ссылка = "https://ya.ru/search/?text=Методическая+документация+1C+%3AERP";
		ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда 
			Ссылка = "https://ya.ru/search/?text=Методическая+документация+Комплексная+Автоматизация";
		Иначе
			Ссылка = "https://ya.ru/search/?text=Методическая+документация+Управление+Торговлей";
		КонецЕсли;
	Иначе 
		Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
			Ссылка = "https://its.1c.ru/db/erpdoc";
		ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда 
			Ссылка = "https://its.1c.ru/db/kadoc";
		Иначе
			Ссылка = "https://its.1c.ru/db/utdoc";
		КонецЕсли;
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВыборИсточникаПоискаНажатие(Элемент)
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("ИТС", НСтр("ru = '1С:ИТС'"));
	СписокВыбора.Добавить("Яндекс", НСтр("ru = 'Яндекс'"));
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ОбработкаВыбораИсточникаПоиска", ЭтотОбъект), СписокВыбора, Элемент, 0);
КонецПроцедуры

&НаКлиенте
Процедура ПолезныеСсылкиНажатие(Элемент)
	Если ИмяКонфигурации = "УправлениеПредприятием" Тогда
		Ссылка = "https://its.1c.ru/bmk/erp_usefullinks";
	ИначеЕсли ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда 
		Ссылка = "https://its.1c.ru/bmk/ka_usefullinks";
	Иначе
		Ссылка = "https://its.1c.ru/bmk/ut_usefullinks";
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиНаИТС(Команда)
	
	ПоискОтветаНаВопрос();
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ИспользуетсяРазделениеДанных = РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных()
		И РаботаВМоделиСервиса.РазделениеВключено();
	ЭтоWindowsКлиент = ОбщегоНазначения.ЭтоWindowsКлиент();
	ПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	ИспользуютсяДемонстрационныеСценарии = ПолучитьФункциональнуюОпцию("ИспользоватьДемонстрационныеСценарии");
	ИспользоватьКоннект = ПолучитьФункциональнуюОпцию("ИнтеграцияСКоннект");  
	
	РазрешенаРаботаСНовостями = ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостями");
	ИмяКонфигурации = Метаданные.Имя;
	
	Если ИмяКонфигурации = "КомплекснаяАвтоматизация" Тогда
		Элементы.ПолезныеСсылки.Подсказка = НСтр("ru = 'Открыть важные ссылки для работы с 1С:Комплексная автоматизация'"); 
	ИначеЕсли ИмяКонфигурации = "УправлениеТорговлей" Тогда
		Элементы.ПолезныеСсылки.Подсказка = НСтр("ru = 'Открыть важные ссылки для работы с 1С:Управление торговлей'"); 
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ЦентрИдей.Видимость                    = Форма.ИспользуетсяРазделениеДанных;
	Элементы.ФорумФреш.Видимость                    = Форма.ИспользуетсяРазделениеДанных;
	Элементы.НаписатьВЧат.Видимость                 = Форма.ЭтоWindowsКлиент;
	Элементы.ОписаниеБизнесПроцессов.Видимость		= Форма.ИспользуютсяДемонстрационныеСценарии;
	Элементы.Новости.Видимость						= Форма.РазрешенаРаботаСНовостями;
	Элементы.НаписатьВЧат.Видимость					= Форма.ИспользоватьКоннект; 
КонецПроцедуры

&НаКлиенте
Процедура ПоискОтветаНаВопрос()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработкаОжиданияПоискаОтветаНаВопрос", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаОжиданияПоискаОтветаНаВопрос()
	
	Если ПустаяСтрока(СтрокаПоискаНаИТС) Тогда
		Возврат;
	КонецЕсли;
	
	Если МеханизмПоиска = "ИТС" Тогда 
		СсылкаПоискаИнформации = "http://its.1c.ru/db/alldb#search:";
		Ссылка = СсылкаПоискаИнформации + СтрокаПоискаНаИТС;
	Иначе
		СсылкаПоискаИнформации = "https://ya.ru/search/?text=";
		Ссылка = СсылкаПоискаИнформации + СтрЗаменить(СтрокаПоискаНаИТС, " ", "+");
	КонецЕсли;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораИсточникаПоиска(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	Если ВыбранноеЗначение = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	МеханизмПоиска = ВыбранноеЗначение.Значение;
	Если МеханизмПоиска = "ИТС" Тогда         
		ЗаголовокСсылки = "документации на 1С:ИТС";
	Иначе 
		ЗаголовокСсылки = "поисковой системе Яндекс";
	КонецЕсли;
	
	Элементы.ПереходНаИсточникПоиска.Заголовок = ЗаголовокСсылки;
КонецПроцедуры

#КонецОбласти

