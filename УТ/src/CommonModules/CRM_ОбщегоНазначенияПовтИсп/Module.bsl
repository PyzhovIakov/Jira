////////////////////////////////////////////////////////////////////////////////
// Общего назначения повторное использование
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//////////////////////////////////////////////////////////////////////////////// 
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

// Функция возвращает валюту управленческого учета
//
// Возвращаемое значение:
//	Строка - наименование валюты управленческого учета.
//
Функция ПолучитьНаименованиеВалютыУправленческогоУчета() Экспорт
 Возврат Константы.ВалютаУправленческогоУчета.Получить().Наименование;	
КонецФункции	

// Функция возвращает список значений, содержащий имена и представления вариантов стандартного периода.
// 
// Возвращаемое значение:
//  СписокЗначений - Список, который содержит имена и представления вариантов стандартного периода.
//
Функция ПериодПолучитьСписокВыбора() Экспорт
	ТипыПериодов = Новый СписокЗначений;
	ТипыПериодов.Добавить("НеВыбран", НСтр("ru='Без ограничения';en='Without restriction'"));
	ТипыПериодов.Добавить("ПроизвольныйПериод", НСтр("ru='Произвольный период';en='Custom Period'"));
	ТипыПериодов.Добавить("Сегодня", НСтр("ru='Сегодня';en='Today'"));
	ТипыПериодов.Добавить("Вчера", НСтр("ru='Вчера';en='Yesterday'"));
	ТипыПериодов.Добавить("ПрошлаяНеделя", НСтр("ru='Прошлая неделя';en='Last week'"));
	ТипыПериодов.Добавить("ЭтаНеделя", НСтр("ru='Эта неделя';en='This week'"));
	ТипыПериодов.Добавить("ПрошлыйМесяц", НСтр("ru='Прошлый месяц';en='Last month'"));
	ТипыПериодов.Добавить("ЭтотМесяц", 	НСтр("ru='Этот месяц';en='This month'"));
	ТипыПериодов.Добавить("ПрошлыйКвартал", НСтр("ru='Прошлый квартал';en='Last quarter'"));
	ТипыПериодов.Добавить("ЭтотКвартал", НСтр("ru='Этот квартал';en='This quarter'"));
	ТипыПериодов.Добавить("ПрошлыйГод", НСтр("ru='Прошлый год';en='Last year'"));
	ТипыПериодов.Добавить("ЭтотГод", НСтр("ru='Этот год';en='This year'"));
	Возврат ТипыПериодов;
КонецФункции // ПериодПолучитьСписокВыбора()

// Функция получает значение ставки НДС.
//
// Параметры:
//	СтавкаНДС	- Число	- Ставка НДС.
//
// Возвращаемое значение:
//	Число	- СтавкаНДС
//
Функция ПолучитьЗначениеСтавкиНДС(СтавкаНДС) Экспорт
	Возврат ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС.Ставка, 0);
КонецФункции // ПолучитьЗначениеСтавкиНДС()

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//	Пользователь - СправочникСсылка - Текущий пользователь программы.
//	Настройка	 - Строка - имя настройки, для которой возвращается значение по умолчанию.
//
// Возвращаемое значение:
//	Произвольный	- Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	// +CRM fresh
	Попытка
		Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.CRM_НастройкиПользователей[Настройка]);
	Исключение
		Если Настройка = "ОсновнойОтветственный" Тогда
			НастройкаПользователей = ПланыВидовХарактеристик.CRM_НастройкиПользователей.СоздатьЭлемент();
			НастройкаПользователей.Наименование = "Основной ответственный";
			НастройкаПользователей.ИмяПредопределенныхДанных = Настройка;
			Массив = Новый Массив;
			Массив.Добавить(Тип("СправочникСсылка.Пользователи"));
			ОписаниеТиповД = Новый ОписаниеТипов(Массив);
			НастройкаПользователей.ТипЗначения = ОписаниеТиповД;
			НастройкаПользователей.ОбменДанными.Загрузка = Истина;
			НастройкаПользователей.Записать();
		ИначеЕсли Настройка = "ОсновнаяОрганизация" Тогда
			НастройкаПользователей = ПланыВидовХарактеристик.CRM_НастройкиПользователей.СоздатьЭлемент();
			НастройкаПользователей.Наименование = "Основная организация";
			НастройкаПользователей.ИмяПредопределенныхДанных = Настройка;
			Массив = Новый Массив;
			Массив.Добавить(Тип("СправочникСсылка.Организации"));
			ОписаниеТиповД = Новый ОписаниеТипов(Массив);
			НастройкаПользователей.ТипЗначения = ОписаниеТиповД;
			НастройкаПользователей.ОбменДанными.Загрузка = Истина;
			НастройкаПользователей.Записать();	
		КонецЕсли;         
		Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.CRM_НастройкиПользователей[Настройка]);
	КонецПопытки;	
	// -CRM fresh
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Значение
	|ИЗ
	|	РегистрСведений.CRM_НастройкиПользователей КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Пользователь = &Пользователь
	| И Настройка    = &Настройка";
	Выборка = Запрос.Выполнить().Выбрать();
	ПустоеЗначение = ПланыВидовХарактеристик.CRM_НастройкиПользователей[Настройка].ТипЗначения.ПривестиЗначение();
	Если Выборка.Количество() = 0 Тогда
		Возврат ПустоеЗначение;
	ИначеЕсли Выборка.Следующий() Тогда
		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Возврат ПустоеЗначение;
		Иначе
			Возврат Выборка.Значение;
		КонецЕсли;
	Иначе
		Возврат ПустоеЗначение;
	КонецЕсли;
КонецФункции // ПолучитьЗначениеПоУмолчаниюПользователя()

// Функция возвращает значение настройки для текущего пользователя сеанса.
//
// Параметры:
//	Настройка	 - Строка - имя настройки, для которой возвращается значение по умолчанию.
//	Пользователь - СправочникСсылка - Пользователь, для которого получается настройка.
//
// Возвращаемое значение:
//	Произвольный	- Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеНастройки(Настройка, Пользователь = Неопределено) Экспорт
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.АвторизованныйПользователь(), Настройка);
	Иначе
		Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка);
	КонецЕсли;
КонецФункции // ПолучитьЗначениеНастройки()

// Функция возвращает ставку НДС - Без НДС.
// 
// Возвращаемое значение:
//  Неопределено - или ПеречислениеСсылка	- Ставка НДС без НДС.
//
Функция ПолучитьСтавкуНДСБезНДС() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.НеОблагается
	|	И СтавкиНДС.Ставка = 0";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции // ПолучитьСтавкуНДСБезНДС()

// Функция возвращает ставку НДС - Ноль.
// 
// Возвращаемое значение:
//  Неопределено - или ПеречислениеСсылка	- Ставка НДС 0.
//
Функция ПолучитьСтавкуНДСНоль() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	(НЕ СтавкиНДС.НеОблагается)
	|	И СтавкиНДС.Ставка = 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции // ПолучитьСтавкуНДСНоль()

// Функция возвращает ставку НДС по значению ставки (не расчетная).
//
// Параметры:
//  ЗначениеСтавкиНДС	 - Число - Значение ставки НДС. 
// 
// Возвращаемое значение:
//  СправочникСсылка.СтавкиНДС - Ставка НДС 
//
Функция ПолучитьСтавкуНДС(ЗначениеСтавкиНДС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	НЕ СтавкиНДС.Расчетная
	|	И НЕ СтавкиНДС.НеОблагается
	|	И СтавкиНДС.Ставка = &Ставка";
	
	Запрос.УстановитьПараметр("Ставка", ЗначениеСтавкиНДС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьСтавкуНДСРасчетная()

// Функция возвращает признак использования режима закладок или панели открытых окон.
//
// Возвращаемое значение:
//	Булево	- признак использования режима закладок.
//
Функция ИспользуетсяРежимЗакладок() Экспорт
	Настройки = CRM_ОбщегоНазначенияСервер.ПолучитьНастройкиКлиентскогоПриложения();
	
	Если Настройки.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		
		Возврат CRM_ОбщегоНазначенияСервер.ЕстьпанельИнтерфейса("ПанельОткрытых");
		
	Иначе
		
		Если Настройки = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат (Настройки.РежимОткрытияФормВЗакладках = Истина);
		КонецЕсли;
		
	КонецЕсли;
КонецФункции

// Проверяет, есть ли у справочника или плана видов характеристик предопределенный элемент с заданным именем
//
// Параметры:
//   ПолноеИмяПредопределенного - Строка - имя предопределенного элемента, как к нему обращаются в коде.
//
// Возвращаемое значение:
//   Ссылка - предопределенный элемент, если он присутствует в конфигурации, иначе Неопределено
//
Функция НайтиПредопределенныйЭлементПоИмени(ПолноеИмяПредопределенного) Экспорт
	
	ПредопределенныйЭлементСсылка = Неопределено;
	
	ИмяПредопределенного = ПолноеИмяПредопределенного;
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяКоллекции = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	Точка = СтрНайти(ИмяПредопределенного, ".");
	ИмяОбъекта = Лев(ИмяПредопределенного, Точка - 1);
	ИмяПредопределенного = Сред(ИмяПредопределенного, Точка + 1);
	
	КоллекцияОбъектовМетаданных = Неопределено;
	
	Если ИмяКоллекции = "Справочник" Тогда
	
		КоллекцияОбъектовМетаданных = Метаданные.Справочники;
		
	ИначеЕсли ИмяКоллекции = "ПланВидовХарактеристик" Тогда
	
		КоллекцияОбъектовМетаданных = Метаданные.ПланыВидовХарактеристик;
		
	КонецЕсли;
	
	Если Не КоллекцияОбъектовМетаданных = Неопределено Тогда
	
		МетаданныеОбъект = КоллекцияОбъектовМетаданных.Найти(ИмяОбъекта);
		
		Если Не МетаданныеОбъект = Неопределено Тогда			
			
			МассивИменПредопределенных = МетаданныеОбъект.ПолучитьИменаПредопределенных();
			
			ЕстьПредопределенныйЭлемент = ?(МассивИменПредопределенных.Найти(ИмяПредопределенного) = Неопределено, Ложь, Истина);
			
			Если ЕстьПредопределенныйЭлемент Тогда
							
				Если ИмяКоллекции = "Справочник" Тогда
				
					ПредопределенныйЭлементСсылка = Справочники[ИмяОбъекта][ИмяПредопределенного];
					
				ИначеЕсли ИмяКоллекции = "ПланВидовХарактеристик" Тогда
				
					ПредопределенныйЭлементСсылка = ПланыВидовХарактеристик[ИмяОбъекта][ИмяПредопределенного];
					
				КонецЕсли;
				
			КонецЕсли;		
			
		КонецЕсли;
	
	КонецЕсли;	
	
	Возврат ПредопределенныйЭлементСсылка;
	
КонецФункции

// Возвращает имя конфигурации, как оно задано в конфигураторе
// 
// Возвращаемое значение:
//  Строка - имя конфигурации
//
Функция ПолучитьИмяКонфигурации() Экспорт
	Возврат Метаданные.Имя;
КонецФункции

// Функция возвращает предопределенное подразделение.
// 
// Возвращаемое значение:
//  СправочникСсылка - Предопределенное подразделение.
//
Функция ПолучитьПредопределенноеПодразделение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Подразделения.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК Подразделения
	|ГДЕ
	|	Подразделения.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Подразделение;
	Иначе	
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции // ПолучитьПредопределенноеПодразделение()

// Возвращает признак:текущая конфигурация является CRM или нет
// 
// Возвращаемое значение:
//  Булево - признак что тек. конфигурация - CRM
//
Функция ЭтоCRM() Экспорт
	Возврат ВРег(ПолучитьИмяКонфигурации()) = ВРег("CRM" + ?(СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации(), "3Базовая", ""));
КонецФункции

// Возвращает признак:текущая конфигурация является CRM или нет
// 
// Возвращаемое значение:
//  Булево - признак что тек. конфигурация - CRM
//
Функция ЭтоУТиВСК() Экспорт
	Возврат  ВРег(ПолучитьИмяКонфигурации()) = ВРег("УправлениеТорговлей_CRM_2");
КонецФункции

// Возвращает признак:текущая конфигурация является спаркой с Управлением холдингом или нет.
// 
// Возвращаемое значение:
//  Булево - признак что тек. конфигурация - спарка с УХ.
//
Функция ЭтоУХ() Экспорт
	Возврат (СтрНайти(ВРег(ПолучитьИмяКонфигурации()), ВРег("УправлениеХолдингом")) > 0);
КонецФункции

// Возвращает признак использования CRM
// 
// Возвращаемое значение:
//   - Булево - признак использования CRM
//
Функция ИспользоватьCRM() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПараметрыСеанса.CRM_ИспользоватьCRM;
	
КонецФункции

#Область РасширеннаяКарточкаОбъектов

// Функция возвращает найденный элемент по имени таблицы.
//
// Параметры:
//  ИмяТаблицы	 - Строка - Имя таблицы. 
// 
// Возвращаемое значение:
//  Число, Неопределено - Индекс элемента или неопределено.
//
Функция ИспользуетсяРасширеннаяКарточка(ИмяТаблицы) Экспорт
	
	Возврат МассивОбъектовРасширеннойКарточки().Найти(ИмяТаблицы) <> Неопределено;
	
КонецФункции // ИспользуетсяРасширеннаяКарточка()

// Массив объектов расширенной карточки
// 
// Возвращаемое значение:
//  Массив - Массив объектов.
//
Функция МассивОбъектовРасширеннойКарточки() Экспорт

	МассивИспользуемыхОбъектов = Новый Массив;
	МассивИспользуемыхОбъектов.Добавить("Справочник.Партнеры");

	Возврат МассивИспользуемыхОбъектов;
	
КонецФункции // МассивИспользуемыхОбъектов()

// Возвращает адрес публикации информационной базы в интернете.
//
// Возвращаемое значение:
//	Строка - адрес публикации информационной базы в интернете.
//
Функция АдресПубликацииИнформационнойБазыВИнтернете() Экспорт
	
	Возврат ОбщегоНазначения.АдресПубликацииИнформационнойБазыВИнтернете();
	
КонецФункции

// Возвращает значение константы "Служебный пользователь робот"
// 
// Возвращаемое значение:
//   - СправочникСсылка.Пользователи - служебный пользователь
//
Функция СлужебныйПользовательРобот() Экспорт
	Возврат Константы.CRM_СлужебныйПользовательРобот.Получить();
КонецФункции

#КонецОбласти

// Функция возвращает Истина, если используются подразделения.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ИспользоватьПодразделения() Экспорт
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Возврат Истина;
	Иначе
		ИмяОпции = "CRM_Модуль_ИспользоватьПодразделения";
		Возврат ПолучитьФункциональнуюОпцию(ИмяОпции);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает массив дат по календарю на год; используется как вспомогательная для ускорения вычислений даты по
//  календарю.
//
// Параметры:
//  Календарь	 - 	 - 
//  Год			 - 	 - 
// 
// Возвращаемое значение:
//  Соответствие - 
//
Функция ПолучитьСоответствиеДатПоКалендарюНаГод(Календарь, Год) Экспорт
	Если Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	СоответствиеРезультат = Новый Соответствие();
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика,
	|	КалендарныеГрафики.ДеньВключенВГрафик КАК ДеньВключенВГрафик
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.Год = &Год
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|");
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("Год", Год);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СоответствиеРезультат.Вставить(НачалоДня(Выборка.ДатаГрафика), Выборка.ДеньВключенВГрафик);
	КонецЦикла;
	
	Возврат СоответствиеРезультат;
	
КонецФункции

Функция НайтиВМетаданныхПоИмени(ПутьКОбъектуКоллекции = "", Имя = "") Экспорт
	
	ВыполняемыйКод	= "Результат = НЕ Метаданные";
	Массив			= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьКОбъектуКоллекции, ".", Ложь);
	
	Для Каждого ЭлементМассива Из Массив Цикл
		ВыполняемыйКод = ВыполняемыйКод + "[""" + ЭлементМассива + """]";
	КонецЦикла;
	ВыполняемыйКод = ВыполняемыйКод + ".Найти(""" + Имя + """) = Неопределено";
	
	Попытка
		Выполнить(ВыполняемыйКод);
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ВидEMailДляОповещений(ВладелецКонтактнойИнформации) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.CRM_ИспользоватьДляОповещений
	|	И ВидыКонтактнойИнформации.Родитель = &ВладелецКонтактнойИнформации
	|	И ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)");
	
	Запрос.Параметры.Вставить("ВладелецКонтактнойИнформации", ВладелецКонтактнойИнформации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

// Функция возвращает представление не заполненного адреса E-Mail
// 
// Возвращаемое значение:
//  Строка - представление не заполненного адреса E-Mail.
//
Функция АдресСайтаНеУказанПредставление() Экспорт
	Возврат "<" + НСтр("ru='адрес сайта не указан';en='website address is not specified'") + ">";
КонецФункции

// Заполняет список выбора переданного элемента формы вида Поле ввода
Процедура ЗаполнитьСписокВыбораВариантовСроков(Элемент) Экспорт
	
	Для Сч = 0 По Перечисления.CRM_ВариантыУстановкиДаты.Количество() - 1 Цикл
		Элемент.СписокВыбора.Добавить(Перечисления.CRM_ВариантыУстановкиДаты[Сч]);
	КонецЦикла;
	
КонецПроцедуры

Функция ДоступенРасчетРазмераХранимыхДанных() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	
	Возврат (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, "8.3.20.0") > 0);
	
КонецФункции

#КонецОбласти
