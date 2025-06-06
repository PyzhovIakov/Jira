///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП".
// ОбщийМодуль.СистемаБыстрыхПлатежейПереопределяемый.
//
// Переопределяемые серверные процедуры работы с Системой быстрых платежей:
//  - работа с настройками оплат в прикладной конфигурации;
//  - управление настройками шаблонов сообщений.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область НастройкиПодключения

// Определяет прикладные настройки работы с Системой быстрых платежей.
//
// Параметры:
//  Настройки - Структура - настройки работы с Системой быстрых платежей:
//    * c2b - Структура, Неопределено - настройки выполнения операций c2b:
//      ** ОбъектМетаданных - Метаданные.РегистрыСведений - объект метаданных регистр сведений,
//        в котором хранятся настройки выполнения оплат. Регистр определяет связь торговой точки
//        Системы быстрых платежей и аналитики ведения учета в программах 1С. На основании данных
//        регистра должен выполняется поиск настройки подключения при выполнении
//        оплат и возвратов;
//      ** ИсключаемыеПоля - Массив Из Строка - наименования измерений, ресурсов или реквизитов, которые
//        необходимо скрыть на форме настройки подключения.
//      ** ИспользоватьЧастичныеОплаты - Булево - признак использования функциональности частичных оплат.
//      ** ИспользоватьНастройкуКассовыхСсылок - Булево - признак использования функциональности
//           добавления кассовых ссылок в мастере настройки подключения к СБП.
//      ** ШаблоныНазначений - ТаблицаЗначений - настройки заполнения шаблонов платежей:
//        *** ОбъектМетаданных - Строка - имя объекта метаданных операции.
//        *** Идентификатор - Строка - идентификатор шаблона.
//        *** Наименование - Строка - наименование шаблона для пользователя.
//        *** Параметры - Структура - параметры заполнения шаблона:
//          **** Наименование - Строка - наименование параметра для пользователя.
//          **** Идентификатор - Строка - идентификатор параметра для заполнения.
//            Идентификатор должен быть уникальный для каждого параметра и для всех шаблонов.
//    * b2b - Структура, Неопределено - настройки выполнения операций b2b:
//      ** ОбъектМетаданных - Метаданные.РегистрыСведений - объект метаданных регистр сведений,
//        в котором хранятся настройки выполнения оплат. Регистр определяет связь торговой точки
//        Системы быстрых платежей и аналитики ведения учета в программах 1С. На основании данных
//        регистра должен выполняется поиск настройки подключения при выполнении
//        оплат;
//      ** ИсключаемыеПоля - Массив Из Строка - наименования измерений, ресурсов или реквизитов, которые
//        необходимо скрыть на форме настройки подключения.
//      ** ИспользоватьЧастичныеОплаты - Булево - признак использования функциональности частичных оплат.
//      ** ШаблоныНазначений - ТаблицаЗначений - настройки заполнения шаблонов платежей:
//        *** ОбъектМетаданных - Строка - имя объекта метаданных операции.
//        *** Идентификатор - Строка - идентификатор шаблона.
//        *** Наименование - Строка - наименование шаблона для пользователя.
//        *** Параметры - Структура - параметры заполнения шаблона:
//          **** Наименование - Строка - наименование параметра для пользователя.
//          **** Идентификатор - Строка - идентификатор параметра для заполнения.
//            Идентификатор должен быть уникальный для каждого параметра и для всех шаблонов.
//
//@skip-warning
Процедура ПриОпределенииНастроекПодключения(Настройки) Экспорт
	
	//++ Локализация
	
	// c2b
	ОбъектМетаданных = Метаданные.РегистрыСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ;
	Настройки.c2b.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	
	ИсключаемыеПоля  = Новый Массив;
	Настройки.c2b.Вставить("ИсключаемыеПоля",  ИсключаемыеПоля);
	
	// b2b
	ОбъектМетаданных = Метаданные.РегистрыСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ;
	Настройки.b2b.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	
	ИсключаемыеПоля  = Новый Массив;
	ИсключаемыеПоля.Добавить("Магазин");
	
	Настройки.b2b.Вставить("ИсключаемыеПоля",  ИсключаемыеПоля);
	
	//-- Локализация
	
КонецПроцедуры

// Определяет алгоритм записи настроек оплат в регистр сведений указанный в методе
// СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения.
//
// Параметры:
//  ПараметрыОплаты - Структура - настройки выполнения оплат:
//    * b2b - Соответствие, Неопределено - содержит данные для записи настроек в регистр сведений.
//       Структура параметра соответствует структуре регистра, которая определена
//       в метаданных за исключением полей указанных в настройках в свойстве ИсключаемыеПоля
//       процедуры СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения
//       (см. Настройки.c2b.ОбъектМетаданных).
//    * c2b - Соответствие, Неопределено - содержит данные для записи настроек в регистр сведений.
//       Структура параметра соответствует структуре регистра, которая определена
//       в метаданных за исключением полей указанных в настройках в свойстве ИсключаемыеПоля
//       процедуры СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения
//       (см. Настройки.c2b.ОбъектМетаданных).
//  Отказ - Булево - следует устанавливать значение Истина, если в процессе записи возникли ошибки;
//  СообщениеОбОшибке - Строка - сообщение для пользователя. Отображается в случае, если в параметр
//    Отказ установлено значение Истина.
//
Процедура ПриЗаписиНастроекПодключения(
		ПараметрыОплаты,
		Отказ,
		СообщениеОбОшибке) Экспорт
	
	//++ Локализация
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		Договор    = ПараметрыОплаты.c2b.Получить("Договор");
		Магазин    = ПараметрыОплаты.c2b.Получить("Магазин");
		Интеграция = ПараметрыОплаты.c2b.Получить("Интеграция");
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ");
		ЭлементБлокировки.УстановитьЗначение("Договор", Договор);
		
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Если ЗначениеЗаполнено(Интеграция) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Договор КАК Договор,
			|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Магазин КАК Магазин
			|ИЗ
			|	РегистрСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ КАК НастройкиИнтеграцииСПлатежнымиСистемамиУТ
			|ГДЕ
			|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Интеграция = &Интеграция";
			Запрос.УстановитьПараметр("Интеграция", Интеграция);
			
			ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Набор = РегистрыСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ.СоздатьНаборЗаписей();
				Набор.Отбор.Договор.Установить(ВыборкаДетальныеЗаписи.Договор);
				Набор.Отбор.Магазин.Установить(ВыборкаДетальныеЗаписи.Магазин);
				Набор.Записать();
			КонецЦикла;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ КАК НастройкиИнтеграцииСПлатежнымиСистемамиУТ
		|ГДЕ
		|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Договор = &Договор
		|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Магазин В (&Магазины)
		|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Интеграция <> &Интеграция
		|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Интеграция.Используется";
		Запрос.УстановитьПараметр("Договор",    Договор);
		Запрос.УстановитьПараметр("Магазины",   РозничныеПродажи.СкладВИерархии(Магазин));
		Запрос.УстановитьПараметр("Интеграция", Интеграция);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Если ЗначениеЗаполнено(Магазин) Тогда
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для договора подключения ""%1"" и магазина ""%2"" существует настройка подключения.'"),
					Договор, Магазин);
			Иначе
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для договора подключения ""%1"" без указания магазина существует настройка подключения.'"),
					Договор);
			КонецЕсли;
			
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
		
		Запись = РегистрыСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ.СоздатьМенеджерЗаписи();
		Запись.Интеграция       = Интеграция;
		Запись.Договор          = Договор;
		Запись.Магазин          = Магазин;
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СистемаБыстрыхПлатежейПереопределяемый.ПриЗаписиНастроекПодключения'"
				, ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Отказ = Истина;
		СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	ОбновитьПовторноИспользуемыеЗначения();
	//-- Локализация
	
КонецПроцедуры

// Позволяет настроить элементы настройки приема оплат на формах подключения
// к Системе быстрых платежей.
//
// Параметры:
//  НастройкиФормы - Структура - содержит элементы формы и текущие значения реквизитов:
//    * ОбщиеЭлементы - Структура - общие настройки формы подключения к Системой быстрых платежей:
//      ** Наименование - Элемент - элемент формы, в котором заполняется наименование;
//      ** ДекорацияДополнительнаяИнформация - Элемент - элемент формы, в котором заполняется наименование;
//    * c2b - Структура, Неопределено - настройки элементов и значения настроек для переводов c2b:
//      ** ЭлементыНастроекОплаты - Структура - элементы формы настройки оплаты. Структура параметра
//        соответствует структуре регистра, который определяется в методе
//        СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//        полей указанных в настройках в свойстве ИсключаемыеПоля.
//      ** ЗначенияНастроекОплаты - Структура - текущее значение реквизитов настроек. Структура параметра
//        соответствует структуре регистра, который определяется в методе
//        СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//        полей указанных в настройках в свойстве ИсключаемыеПоля;
//    * b2b - Структура, Неопределено - настройки элементов и значения настроек для переводов b2b:
//      ** ЭлементыНастроекОплаты - Структура - элементы формы настройки оплаты. Структура параметра
//        соответствует структуре регистра, который определяется в методе
//        СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//        полей указанных в настройках в свойстве ИсключаемыеПоля.
//      ** ЗначенияНастроекОплаты - Структура - текущее значение реквизитов настроек. Структура параметра
//        соответствует структуре регистра, который определяется в методе
//        СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//        полей указанных в настройках в свойстве ИсключаемыеПоля;
//    * НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей, Неопределено - передается
//     ссылка на настройку подключения, в случае создания новой настройки передается Неопределено;
//    * ИдентификаторУчастника - Строка - идентификатор участника СБП для которого выполняется настройка;
//  ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры настройки подключения с
//    Системой быстрых платежей, которые передаются в методе СистемаБыстрыхПлатежейКлиент.ПодключитьСистемуБыстрыхПлатежей.
//
//@skip-warning
Процедура ПриНастройкеЭлементовФормыПодключения(
		НастройкиФормы,
		ДополнительныеПараметры) Экспорт
	
	//++ Локализация
	
	// Договор
	ЭлементФормыДоговор = НастройкиФормы.c2b.ЭлементыНастроекОплаты.Договор;
	
	ПараметрыВыбора       = Новый Массив;
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.СпособПроведенияПлатежа", Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей);
	ПараметрыВыбора.Добавить(НовыйПараметр);
	
	ЭлементФормыДоговор.ПараметрыВыбора       = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	// Магазин
	ЭлементФормыМагазин = НастройкиФормы.c2b.ЭлементыНастроекОплаты.Магазин;
	ЭлементФормыМагазин.ВыборГруппИЭлементов = ГруппыИЭлементы.ГруппыИЭлементы;
	
	// Подсказка в поле Магазин
	ЭлементФормыМагазин.ПодсказкаВвода = "<Все магазины, если не реквизит не заполнен>";
	
	//-- Локализация
	
КонецПроцедуры

// Позволяет предзаполнить настройки приема платежей на формах подключения
// к Системе быстрых платежей.
//
// Параметры:
//  Настройки - Структура - содержит элементы формы и текущие значения реквизитов:
//    * ОбщиеНастройки - Структура - общие настройки формы подключения к Системой быстрых платежей:
//      ** Наименование - Строка - значение заполнения поля наименование;
//    * НастройкиОплаты - Структура - значение заполнения реквизитов настройки приема оплат.
//        ** c2b - Структура, Неопределено - значение заполнения реквизитов настройки приема оплат. Структура параметра
//           соответствует структуре регистра, который определяется в методе
//           СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//           полей указанных в настройках в свойстве ИсключаемыеПоля;
//        ** b2b - Структура, Неопределено - значение заполнения реквизитов настройки приема оплат. Структура параметра
//           соответствует структуре регистра, который определяется в методе
//           СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения, за исключением
//           полей указанных в настройках в свойстве ИсключаемыеПоля;
//    * НастройкиУчастникаСБП - Структура - содержит настройки участника СБП:
//      ** Наименование - Строка - наименование участника СБП;
//      ** ИНН - Строка - ИНН участника СБП;
//      ** ПлатежныйАгрегатор - Булево - признак того что участник СБП является платежным агрегатором;
//      ** БИК - Массив из Строка - содержит перечень БИК участника СБП;
//      ** ИдентификаторУчастника - Строка - идентификатор участника СБП для которого выполняется настройка;
//    * ДополнительныеНастройки - Структура - содержит дополнительные настройки участника СБП:
//      ** b2b - Структура - дополнительные настройки для приема оплат от юридических лиц:
//        *** ВидПоступления - Строка, Неопределено - определяет вид зачисления денежных средств на расчетный счет продавца.
//               Возможные значения:
//                 - ACQUIRING - зачисление по схеме эквайринга;
//                 - PAYMENT_FROM_THE_BUYER - перевод от юридического лица;
//                 - Неопределено - вид поступления не определен.
//  ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры настройки подключения с
//    Системой быстрых платежей, которые передаются в методе СистемаБыстрыхПлатежейКлиент.ПодключитьСистемуБыстрыхПлатежей.
//
//@skip-warning
Процедура ПриЗаполненииФормыНастройкиПодключения(
		Настройки,
		ДополнительныеПараметры) Экспорт
	
	//++ Локализация
	Если ДополнительныеПараметры <> Неопределено Тогда
		Автонаименование = СтрШаблон(НСтр("ru = '%1'"), ДополнительныеПараметры);
		ЗаполнитьЗначенияСвойств(Настройки.ОбщиеНастройки,  Новый Структура("Наименование", Автонаименование));
		ЗаполнитьЗначенияСвойств(Настройки.НастройкиОплаты.c2b,  Новый Структура("Договор", ДополнительныеПараметры));
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Возвращает признак использования шаблонов сообщений для работы с СБП.
//
// Параметры:
//  Используется - Булево - признак использования шаблонов сообщений.
//
//@skip-warning
Процедура ПриПроверкеИспользованияШаблоновСообщений(Используется) Экспорт
	
	//++ Локализация
	РозничныеПродажиЛокализация.ПриПроверкеИспользованияШаблоновСообщенийСБП(Используется);
	//-- Локализация
	
КонецПроцедуры

// Описывает предопределенные шаблоны писем по типу,
// с помощью которых можно будет выставлять счета для оплаты через СБП.
// Эти шаблоны будут доступны для создания из основной формы настроек и использоваться
// в форме формирования платежной ссылки СБП.
// Добавлены реквизиты:
//   * ПредставлениеСсылкиСБПQRКод - вставляет платежную ссылку в виде картинки (Base64).
//   * ПредставлениеСсылкиСБП - вставляет платежную ссылку в виде строки.
//
// Параметры:
//  НастройкиШаблонов - Структура - настройки шаблонов для различных сценариев оплаты СБП:
//    * c2b - Массив - Массив структур данных, описывающих предопределенные шаблоны сообщения
//     для приема оплат от физических лиц.
//      ** ПолноеИмяТипаНазначения - Строка - Полное имя объекта метаданных, на основании которого по данному шаблону
//          будут создаваться письма.
//      ** Текст - Строка - Текст, который будет использоваться в качестве шаблона письма в формате HTML.
//      ** Тема - Строка - Текст, который будет использоваться в качестве шаблона темы письма.
//      ** Наименование - Строка - Текст, наименование шаблона письма.
//      ** Тип - Строка - Тип шаблона. Возможные значения:"Почта" или "SMS".
//    * b2b - Массив - Массив структур данных, описывающих предопределенные шаблоны сообщения
//     для приема оплат от физических лиц.
//      ** ПолноеИмяТипаНазначения - Строка - Полное имя объекта метаданных, на основании которого по данному шаблону
//          будут создаваться письма.
//      ** Текст - Строка - Текст, который будет использоваться в качестве шаблона письма в формате HTML.
//      ** Тема - Строка - Текст, который будет использоваться в качестве шаблона темы письма.
//      ** Наименование - Строка - Текст, наименование шаблона письма.
//      ** Тип - Строка - Тип шаблона. Возможные значения:"Почта" или "SMS".
//
//@skip-warning
Процедура ПриОпределенииПредопределенныхШаблоновСообщений(НастройкиШаблонов) Экспорт 
	
	//++ Локализация
	РозничныеПродажиЛокализация.ПриОпределенииПредопределенныхШаблоновСообщенийСБППоТипам(НастройкиШаблонов.c2b);
	//-- Локализация
	
КонецПроцедуры

// Определяет параметры отправки сообщений с использованием шаблонов СБП.
//
// Параметры:
//  ПараметрыОтправкиСообщений - Структура - описание параметров отправки сообщений:
//    * ПараметрыОтправкиПисем - Структура - описание параметров отправки электронных писем:
//       ** ОтправлятьПисьмаВФорматеHTML - Булево, Неопределено - признак отправки электронных писем в формате HTML.
//          Если свойство не задано, в дальнейшем при наличии подсистемы "Взаимодействия" будет получено значение
//          функциональной опции "ОтправлятьПисьмаВФорматеHTML", либо Ложь при ее отсутствии.
//
//@skip-warning
Процедура ПриОпределенииПараметровОтправкиСообщений(
		ПараметрыОтправкиСообщений) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ФормаПодготовкиПлатежнойСсылки

// Определяет объекты, которые могут выступать в качестве оснований платежа через СБП.
//
// Параметры:
//  ИменаДокументовОперации - Массив Из Строка - имена объектов метаданных оснований платежа через СБП.
//
//@skip-warning
Процедура ПриОпределенииОбъектовСКомандамиСБП(ИменаДокументовОперации) Экспорт
	
	ИменаДокументовОперации.Добавить("Документ.ЗаказКлиента");
	ИменаДокументовОперации.Добавить("Документ.СчетНаОплатуКлиенту");
	ИменаДокументовОперации.Добавить("Документ.АктВыполненныхРабот");
	ИменаДокументовОперации.Добавить("Документ.РеализацияТоваровУслуг");
	ИменаДокументовОперации.Добавить("Документ.РеализацияУслугПрочихАктивов");
	
КонецПроцедуры

// Определяет возможность формирования платежной ссылки на основании данных документа операции.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//    операцию в информационной базе.
//  Результат - Структура - результат проверки:
//    * ИнтеграцияДоступна - Булево - признак доступности работы с СБП по данным документа операции.
//    * СообщениеОбОшибке - Строка - сообщение для пользователя. Отображается в случае, если в параметр
//    ИнтеграцияДоступна установлено значение Ложь.
//
//@skip-warning
Процедура ПриОпределенииДоступностиПодключенияПоДокументуОперации(
		ДокументОперации,
		Результат) Экспорт
	
	МассивРеквизитовДокумента = Новый Массив;
	МассивРеквизитовДокумента.Добавить("Контрагент.ЮрФизЛицо");
	МассивРеквизитовДокумента.Добавить("Проведен");
	Если ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		МассивРеквизитовДокумента.Добавить("ХозяйственнаяОперация");
		МассивРеквизитовДокумента.Добавить("ПорядокРасчетов");
	ИначеЕсли ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		МассивРеквизитовДокумента.Добавить("ХозяйственнаяОперация");
	КонецЕсли;
	РеквизитыДокументаОперации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОперации, СтрСоединить(МассивРеквизитовДокумента,","));

	Если ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		Если РеквизитыДокументаОперации.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда	
			Результат.ИнтеграцияДоступна = Ложь;
			Результат.СообщениеОбОшибке = НСтр("ru = 'Оплата заказа клиента через СБП при передаче на комиссию не поддерживается.'");
		ИначеЕсли РеквизитыДокументаОперации.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным Тогда	
			Результат.ИнтеграцияДоступна = Ложь;
			Результат.СообщениеОбОшибке = НСтр("ru = 'Оплата заказа клиента через СБП с порядком расчетов по накладным не поддерживается.'");
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Если РеквизитыДокументаОперации.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда	
			Результат.ИнтеграцияДоступна = Ложь;
			Результат.СообщениеОбОшибке = НСтр("ru = 'Оплата через СБП при передаче на комиссию не поддерживается.'");
		КонецЕсли;
	КонецЕсли;
	Если Результат.ИнтеграцияДоступна Тогда
		Если Не (РеквизитыДокументаОперации.КонтрагентЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда	
			Результат.ИнтеграцияДоступна = Ложь;
			Результат.СообщениеОбОшибке = НСтр("ru = 'Оплата через СБП возможна только для физических лиц.'");
		ИначеЕсли РеквизитыДокументаОперации.Проведен = Ложь Тогда	
			Результат.ИнтеграцияДоступна = Ложь;
			Результат.СообщениеОбОшибке = НСтр("ru = 'Для оплаты через СБП необходимо провести документ.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Определяет перечень возможных настроек подключения на основании данных документа операции.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//    операцию в информационной базе.
//  НастройкиПодключения - Структура - настройки подключения к Системе быстрых платежей:
//    * c2b - Массив Из СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//      настройка подключения для приема оплат от физических лиц;
//    * b2b - Массив Из СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//      настройка подключения для приема оплат от юридических;
//  ДополнительныеНастройки - Структура - дополнительные настройки подключения СБП
//   * БИК - Строка, Неопределено - идентификатор банка. Используется для автоматического
//     выбора участника СБП.
//   * ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры подключения.
//     Значение будет передано в переопределяемые методы:
//       - СистемаБыстрыхПлатежейПереопределяемый.ПриНастройкеЭлементовФормыПодключения;
//       - СистемаБыстрыхПлатежейПереопределяемый.ПриНастройкеЭлементовФормыПодключения.
//   * ОтборУчастников - Строка, Неопределено - Параметры отбора участников СБП.
//     Допустимые значения - "Банки", "ПлатежныеАгрегаторы", "КассовыеСсылки", Неопределено.
//     Неопределено по умолчанию.
//   * МаксимальнаяСуммаОплаты - Число- определяет максимальную сумму оплаты по данным документа;
//   * ВариантНастройки - Строка, Неопределено - вариант настройки подключения к Системе быстрых платежей
//     для случаев когда требуется подключение настройки. Возможные значения:
//       c2b - подключение приема оплат от физических лиц;
//       b2b - подключение приема оплат от юридических лиц.
//  ПараметрыВопроса - Структура - настройки отображения вопроса, который будет выведен пользователю
//    перед началом формирования платежной ссылки или началом подключения к СБП.
//    Вопрос не выводится, если параметр "ТекстВопроса" имеет значение Неопределено.
//    * ТекстВопроса - Строка, Неопределено - текст вопроса для отображения.
//
//@skip-warning
Процедура ПриОпределенииПараметровПодключенияДокументаОперации(
		ДокументОперации,
		НастройкиПодключения,
		ДополнительныеНастройки,
		ПараметрыВопроса) Экспорт
	
	ТребуетсяПроверкаДокументаОснования = Ложь;
	
	РеквизитыДокументаОперации = Новый Массив;
	РеквизитыДокументаОперации.Добавить("Организация");
	Если ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.СчетНаОплатуКлиенту") Тогда
		РеквизитыДокументаОперации.Добавить("ДокументОснование");
		Если РегистрыСведений.ИдентификаторыОперацийСБПc2b.ПараметрыОпределенияСтатусаОперации(ДокументОперации) = Неопределено Тогда 
			ТребуетсяПроверкаДокументаОснования = Истина;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ЗаказКлиента")
		ИЛИ ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		РеквизитыДокументаОперации.Добавить("Склад");
	КонецЕсли;
	
	ЗначенияРеквизитовДокументаОперации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОперации, РеквизитыДокументаОперации);
	
	Склад = Неопределено;
	Если ЗначенияРеквизитовДокументаОперации.Свойство("Склад") Тогда
		Склад = ЗначенияРеквизитовДокументаОперации.Склад;
	КонецЕсли;
	
	ТаблицаПодключенийСБППоОрганизации = Справочники.НастройкиРМК.СписокДоговоровИПодключенийСБП(
		ЗначенияРеквизитовДокументаОперации.Организация,,
		Склад);
	Для Каждого Строка Из ТаблицаПодключенийСБППоОрганизации Цикл
		Если НастройкиПодключения.c2b.Найти(Строка.НастройкаПодключения) = Неопределено Тогда
			НастройкиПодключения.c2b.Добавить(Строка.НастройкаПодключения);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Интеграция КАК НастройкаПодключения
	|ИЗ РегистрСведений.НастройкиИнтеграцииСПлатежнымиСистемамиУТ КАК НастройкиИнтеграцииСПлатежнымиСистемамиУТ
	|ГДЕ
	|	НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Договор.Организация = &Организация
	|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Договор.ПометкаУдаления = ЛОЖЬ
	|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Магазин = &СкладПустой
	|	И НастройкиИнтеграцииСПлатежнымиСистемамиУТ.Интеграция.Используется = ИСТИНА";
	Запрос.УстановитьПараметр("Организация", ЗначенияРеквизитовДокументаОперации.Организация);
	Запрос.УстановитьПараметр("СкладПустой", Справочники.Склады.ПустаяСсылка());
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		Если НастройкиПодключения.c2b.Найти(Выборка.НастройкаПодключения) = Неопределено Тогда
			НастройкиПодключения.c2b.Добавить(Выборка.НастройкаПодключения);
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяПроверкаДокументаОснования
		И ЗначениеЗаполнено(ЗначенияРеквизитовДокументаОперации.ДокументОснование) Тогда
		
		Если Не РегистрыСведений.ИдентификаторыОперацийСБПc2b.ПараметрыОпределенияСтатусаОперации(ЗначенияРеквизитовДокументаОперации.ДокументОснование) = Неопределено Тогда 
			
			ПараметрыВопроса.ТекстВопроса = НСтр("ru = 'Для документа основания уже сформирована ссылка на оплату СБП. Продолжить?'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаСообщений

// Заполняет список получателей сообщения с платежной ссылкой.
//
// Параметры:
//  ДокументОперации - Произвольный - документ операции, для которого получена платежная ссылка.
//  ВариантОтправки - Строка - способ отправки ссылки. "ЭлектроннаяПочта" - по электронной почте, "Телефон" - по SMS.
//  Получатели - СписокЗначений - адреса электронной почты или номера телефонов получателей (строка).
//
//@skip-warning
Процедура ПриФормированииСпискаПолучателейСообщенияСБП(
		Знач ДокументОперации,
		Знач ВариантОтправки,
		Получатели) Экспорт
	
	//++ Локализация
	РозничныеПродажиЛокализация.ПриФормированииСпискаПолучателейСообщенияСБП(ДокументОперации, ВариантОтправки, Получатели);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ФормаОтображенияQRКода

// Определяет алгоритм, выполняющийся при создании формы отображения QR-кода на форме подготовки платежной ссылки СБП.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма отображения QR-кода.
//  НастройкиФормы - Структура - описание настроек формы для размещения
//    программно созданных объектов.
//    * Группа - ГруппаФормы - элемент формы для программного добавления новых элементов управления,
//        в качестве свойства "Действие" у программно создаваемых команд,
//        необходимо указать значение "Подключаемый_ПриОбработкеНажатияКоманды".
//  ДанныеПлатежнойСсылки - Структура - параметры выполнения команды:
//    * ПлатежнаяСсылка - Строка - ссылка сформированная по данным документа операции.
//    * QRКод - ДвоичныеДанные - данные изображения QR-кода.
//    * ОснованиеПлатежа - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//      оплату в информационной базе.
//
//@skip-warning
Процедура ПриСозданииНаСервереФормыQRКода(
		Форма,
		НастройкиФормы,
		ДанныеПлатежнойСсылки) Экспорт
	
	//++ Локализация
	
	// Добавляем реквизиты, которые используются БПО при вызове метода МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы
	Реквизиты = Новый Массив;	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИспользоватьПодключаемоеОборудование") Тогда
		Массив = Новый Массив;
		Массив.Добавить(Тип("Булево"));	
		Реквизиты.Добавить(Новый РеквизитФормы("ИспользоватьПодключаемоеОборудование", Новый ОписаниеТипов(Массив)));
	КонецЕсли;
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПоддерживаемыеТипыПодключаемогоОборудования") Тогда
		КвалификаторТипаСтроки = Новый КвалификаторыСтроки(0);
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		Реквизиты.Добавить(Новый РеквизитФормы("ПоддерживаемыеТипыПодключаемогоОборудования", Новый ОписаниеТипов(Массив, , КвалификаторТипаСтроки)));
	КонецЕсли;
	Если Реквизиты.Количество() Тогда
		Форма.ИзменитьРеквизиты(Реквизиты);
	КонецЕсли;
	Форма.ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудованиеИОплатуПлатежнымиКартами");
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
