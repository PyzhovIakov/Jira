#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	
	МеханизмыДокумента.Добавить("ПодарочныеСертификаты");
	

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив из Строка - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект, МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов, МассивРеквизитовОперации, МассивНепроверяемыхРеквизитов);
	
	ФлагОбменСБанками = Ложь;
	Если ДополнительныеСвойства.Свойство("ОбменСБанками")
		И ДополнительныеСвойства.ОбменСБанками Тогда
		ФлагОбменСБанками = Истина;
	КонецЕсли;
	
	Если Не ФлагОбменСБанками
		И Не Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту Тогда
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту Тогда
		
		Если ИспользуетсяПодтверждениеЗачисления(Объект.ДокументВыдачи) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПодтверждениеЗачисленияЗарплаты");
		КонецЕсли;
	
	КонецЕсли;
	
	
	ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(Объект, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДокОснование - Произвольный - Значение, которое используется как основание для заполнения.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения, данный параметр будет дозаполнен данными.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДокОснование, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	
	Если ЗначениеЗаполнено(ДокОснование) Тогда
		
		ТипОснования = ТипЗнч(ДокОснование);
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ХозяйственнаяОперация")
		И Не ДанныеЗаполнения.Свойство("ТипПлатежногоДокумента") Тогда
		
		Если ДанныеЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыПоПлатежнойКарте
			Или ДанныеЗаполнения.ХозяйственнаяОперация =  Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыНаРасчетныйСчет Тогда
			
			ДанныеЗаполнения.Вставить("ТипПлатежногоДокумента", Перечисления.ТипыПлатежныхДокументов.ПлатежныйОрдер);
			ДанныеЗаполнения.Вставить("ПроведеноБанком", Истина);
		КонецЕсли;
	КонецЕсли;
	
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//++ Локализация
	НеиспользуемыеРеквизиты = Новый Массив;
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, МассивВсехРеквизитов, МассивРеквизитовОперации);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту Тогда
		
		Если ИспользуетсяПодтверждениеЗачисления(Объект.ДокументВыдачи) Тогда
			НеиспользуемыеРеквизиты.Добавить("ПодтверждениеЗачисленияЗарплаты");
		КонецЕсли;
	
	КонецЕсли;
	
	Для каждого НеиспользуемыйРеквизит Из НеиспользуемыеРеквизиты Цикл
		УдаляемыйРеквизит = МассивРеквизитовОперации.Найти(НеиспользуемыйРеквизит);
		Если УдаляемыйРеквизит <> Неопределено Тогда
			МассивРеквизитовОперации.Удалить(УдаляемыйРеквизит);
		КонецЕсли;
	КонецЦикла;
	
	Если ДенежныеСредстваСервер.ОперацияПоЗарплате(Объект.ХозяйственнаяОперация) Тогда
		
	КонецЕсли;
	
	
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(Объект, МассивВсехРеквизитов, МассивРеквизитовОперации);
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

#КонецОбласти


#Область Фискализация

//++ Локализация

// Возвращает параметры операции фискализации чека для печати чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Структура - Структура параметров операции фискализации чека
Функция ОсновныеПараметрыОперации(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ОсновныеПараметрыОперации = ФормированиеФискальныхЧековСерверПереопределяемый.СтруктураОсновныхПараметровОперации();
	
	ОсновныеПараметрыОперации.ДокументСсылка  = Объект.Ссылка;
	ОсновныеПараметрыОперации.Организация     = Объект.Организация;
	ОсновныеПараметрыОперации.Контрагент      = Объект.Контрагент;
	ОсновныеПараметрыОперации.Партнер         = Форма.Партнер;
	ОсновныеПараметрыОперации.Валюта          = Объект.Валюта;
	ОсновныеПараметрыОперации.СуммаДокумента  = Объект.СуммаДокумента;
	
	ОсновныеПараметрыОперации.ИмяРеквизитаГиперссылкиНаФорме = "ФискальнаяОперацияСтатус";
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика Тогда
		ОсновныеПараметрыОперации.ИмяКомандыПробитияЧека = "ПробитьЧек";
	КонецЕсли;
	
	Возврат ОсновныеПараметрыОперации;
	
КонецФункции

// Определяет, разрешено ли пробитие фискального чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Булево - Истина, если разрешено пробитие чека
Функция РазрешеноПробитиеФискальныхЧековПоДокументу(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	РазрешеноПробитиеФискальныхЧековПоДокументу =
		(Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
			Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо
		И Объект.ПроведеноБанком;
	
	Возврат РазрешеноПробитиеФискальныхЧековПоДокументу;
	
КонецФункции

// Формирует массив форматированных строк для формирования гиперссылки пробития фискального чека
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ-ссылка, по которому пробивается фискальный чек
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// 	МассивПредставлений - Массив из ФорматированнаяСтрока - Массив форматированных строк для формирования гиперссылки
//    пробития фискального чека.
Процедура ОбновитьГиперссылкуПробитияФискальногоЧека(ДокументСсылка, Форма, МассивПредставлений) Экспорт
	
	ФискальнаяОперацияДанныеЖурнала = ФормированиеФискальныхЧековСервер.ДанныеПробитогоФискальногоЧекаПоДокументу(ДокументСсылка);
	
	Если ФискальнаяОперацияДанныеЖурнала <> Неопределено Тогда
		
		НомерЧекаККМ = ФискальнаяОперацияДанныеЖурнала.НомерЧекаККМ;
		ТекстСсылки = "ОткрытьЗаписьФискальнойОперации";
		
		ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуЧекПробит(МассивПредставлений, НомерЧекаККМ, ТекстСсылки);
		
	ИначеЕсли ФормированиеФискальныхЧековСервер.ЕстьПравоНаПробитиеФискальногоЧекаПоДокументу(ДокументСсылка) Тогда
		
		Если ФормированиеФискальныхЧековСервер.ЕстьПодключенноеОборудованиеККассамОрганизации(Форма.Объект.Организация) Тогда 
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуПробитьЧек(МассивПредставлений, "ПробитьЧек");
		Иначе
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений, "НастроитьОборудование");
		КонецЕсли;
		
	Иначе
		
		ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет виды фискальных чеков, доступных по документу
// 
// Параметры:
// 	ВидыЧеков - ТаблицаЗначений - Таблица значений, содержащая виды фискальных чеков, доступных по документу
// 	Операция - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция по документу
// 	ИмяКомандыПробитияЧека - Строка - Имя команды пробития чека
Процедура ЗаполнитьВидыФискальныхЧековПоДокументу(ВидыЧеков, Операция, ИмяКомандыПробитияЧека) Экспорт
	
	ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств; // Операция = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
	Если Операция = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика Тогда
		ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратРасходаДенежныхСредств;
	КонецЕсли;
	
	ВидЧека = ВидыЧеков.Добавить();
	ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧек;
	ВидЧека.ТипРасчетаДенежнымиСредствами = ТипРасчетовДенежнымиСредствами;
	ВидЧека.ВидЧекаКоррекции = Неопределено;
	
	Если ФормированиеФискальныхЧековСерверПереопределяемый.РазрешенКассовыйЧекКоррекцииДляТипаРасчетов(ТипРасчетовДенежнымиСредствами) Тогда
		ВидЧека = ВидыЧеков.Добавить();
		ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧекКоррекции;
		ВидЧека.ТипРасчетаДенежнымиСредствами = ТипРасчетовДенежнымиСредствами;
		ВидЧека.ВидЧекаКоррекции = Перечисления.ВидыЧековКоррекции.НеприменениеККТ;
	КонецЕсли;
	
КонецПроцедуры

// Определяет систему налогообложения по документу
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	ПеречислениеСсылка.ТипыСистемНалогообложенияККТ - Система налогообложения по документу
Функция СистемаНалогообложенияПоДокументу(ДокументСсылка) Экспорт
	
	РасшифровкаПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "РасшифровкаПлатежа").Выгрузить();
	
	МассивОбъектовРасчетов = РасшифровкаПлатежа.ВыгрузитьКолонку("ОбъектРасчетов");
	МассивОбъектовРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектовРасчетов, "НалогообложениеНДС");
	
	НалогообложениеНДСПоОбъектамРасчетов = Новый Массив();
	Для Каждого ОбъектРасчетов Из МассивОбъектовРасчетов Цикл
		
		Если ЗначениеЗаполнено(ОбъектРасчетов.Значение.НалогообложениеНДС) Тогда
			Если НалогообложениеНДСПоОбъектамРасчетов.Найти(ОбъектРасчетов.Значение.НалогообложениеНДС) = Неопределено Тогда
				НалогообложениеНДСПоОбъектамРасчетов.Добавить(ОбъектРасчетов.Значение.НалогообложениеНДС);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	СистемаНалогообложения = Неопределено;
	Если НалогообложениеНДСПоОбъектамРасчетов.Количество() = 1 Тогда
		Если НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаПоПатенту Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.Патент;
		ИначеЕсли НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД;
		КонецЕсли;
	КонецЕсли;
	
	Если СистемаНалогообложения = Неопределено Тогда
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Организация");
		СистемаНалогообложения = РозничныеПродажиЛокализация.СистемаНалогообложенияФискальнойОперации(РеквизитыДокумента.Организация);
	КонецЕсли;
	
	Возврат СистемаНалогообложения;
	
КонецФункции

// Возвращает наименование клиента, кто внес или получил денежные средства в качестве аванса
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	Строка - Наименование клиента платежа-аванса
Функция КлиентАвансовогоПлатежаНаименование(ДокументСсылка) Экспорт
	
	Клиент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Контрагент");
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Клиент, "НаименованиеПолное");
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	
	ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры);
	
	
	ТекстЗапросаТаблицаРасчетыПоЕдиномуНалоговомуСчету(Запрос, ТекстыЗапроса, Регистры);

	//-- Локализация
	
КонецПроцедуры

//++ Локализация

Функция ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АктивацияПодарочныхСертификатов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОбъектыРасчетов.Объект КАК ПодарочныйСертификат,
		|	&Период КАК ДатаНачалаДействия,
		|	ВЫБОР
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		ИНАЧЕ &Период
		|	КОНЕЦ КАК ДатаОкончанияДействия,
		|	&Организация КАК Организация
		|ИЗ
		|	Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ТабличнаяЧасть
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеБезналичныхДенежныхСредств КАК Документ
		|			ПО Документ.Ссылка = ТабличнаяЧасть.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|		ПО (ОбъектыРасчетов.Ссылка = ТабличнаяЧасть.ОбъектРасчетов)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
		|		ПО (ВидыПодарочныхСертификатов.Ссылка = ОбъектыРасчетов.Объект.Владелец)
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &Ссылка
		|	И ОбъектыРасчетов.Объект ССЫЛКА Справочник.ПодарочныеСертификаты
		|	И Документ.ПроведеноБанком";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


Функция ТекстЗапросаТаблицаРасчетыПоЕдиномуНалоговомуСчету(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЕдиномуНалоговомуСчету";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	&ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ДанныеДокумента.Ссылка КАК ПлатежныйДокумент,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15,2)) КАК Сумма
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратНалогов)
	|	И ДанныеДокумента.ТипНалога = ЗНАЧЕНИЕ(Справочник.ВидыНалоговВзносов.ЕдиныйНалоговыйПлатеж)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ИспользуетсяПодтверждениеЗачисления(ДокументВыдачи)

	ПеречислениеПоРеестру = Ложь;
	
	Если ЗначениеЗаполнено(ДокументВыдачи)
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументВыдачи, "СписокФизЛиц") Тогда
		ПеречислениеПоРеестру = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВыдачи, "СписокФизЛиц");
	КонецЕсли;
	
	Возврат Не ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ")
		И Не ПеречислениеПоРеестру;

КонецФункции

//-- Локализация

#КонецОбласти

#Область ЗаполнениеНаОсновании

//++ Локализация


//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	Объект - ДокументОбъект.ПоступлениеБезналичныхДенежныхСредств - данные объекта.
//	МассивВсехРеквизитов - Массив из Строка - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив из Строка - Массив имен реквизитов, используемых в выбранной хозяйственной операции.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	Если МассивВсехРеквизитов = Неопределено Тогда
		МассивВсехРеквизитов = Новый Массив;
	КонецЕсли;
	Если МассивРеквизитовОперации = Неопределено Тогда
		МассивРеквизитовОперации = Новый Массив;
	КонецЕсли;
	
	ХозяйственнаяОперация = Объект.ХозяйственнаяОперация;
	
	МассивВсехРеквизитов.Добавить("ДокументВыдачи");
	МассивВсехРеквизитов.Добавить("ПодтверждениеЗачисленияЗарплаты");
	МассивВсехРеквизитов.Добавить("СтатьяЦелевыхСредств");
	МассивВсехРеквизитов.Добавить("ПеречислениеВБюджет");
	МассивВсехРеквизитов.Добавить("ВидПеречисленияВБюджет");
	МассивВсехРеквизитов.Добавить("КодБК");
	МассивВсехРеквизитов.Добавить("КодОКАТО");
	МассивВсехРеквизитов.Добавить("СтатусСоставителя");
	МассивВсехРеквизитов.Добавить("ПоказательДаты");
	МассивВсехРеквизитов.Добавить("ПоказательНомера");
	МассивВсехРеквизитов.Добавить("ПоказательОснования");
	МассивВсехРеквизитов.Добавить("ПоказательПериода");
	МассивВсехРеквизитов.Добавить("ПоказательТипа");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорЗаймаСотруднику");
	МассивВсехРеквизитов.Добавить("РасшифровкаПлатежа.СтатьяЦелевыхСредств");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтАрендодателя Тогда
		
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.СтатьяЦелевыхСредств");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыПоПлатежнойКарте
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.КонвертацияВалюты Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяЦелевыхСредств");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПогашениеЗаймаСотрудником Тогда
		
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
		МассивРеквизитовОперации.Добавить("РасшифровкаПлатежа.СтатьяЦелевыхСредств");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленныхДС Тогда
		
		МассивРеквизитовОперации.Добавить("ПодотчетноеЛицо");
		МассивРеквизитовОперации.Добавить("БанковскийСчетКонтрагента");
		МассивРеквизитовОперации.Добавить("СтатьяДвиженияДенежныхСредств");
		МассивРеквизитовОперации.Добавить("СтатьяЦелевыхСредств");
		МассивРеквизитовОперации.Добавить("Подразделение");
		МассивРеквизитовОперации.Добавить("ДокументВыдачи");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту Тогда
		
		МассивРеквизитовОперации.Добавить("Контрагент");
		МассивРеквизитовОперации.Добавить("БанковскийСчетКонтрагента");
		МассивРеквизитовОперации.Добавить("СтатьяДвиженияДенежныхСредств");
		МассивРеквизитовОперации.Добавить("СтатьяЦелевыхСредств");
		МассивРеквизитовОперации.Добавить("Подразделение");
		МассивРеквизитовОперации.Добавить("ДокументВыдачи");
		МассивРеквизитовОперации.Добавить("ПодтверждениеЗачисленияЗарплаты");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствСДругогоСчета Тогда
		МассивРеквизитовОперации.Добавить("СтатьяЦелевыхСредств");
	КонецЕсли;
	
	ДопускаетсяПеречислениеВБюджет =
		(ДенежныеСредстваСерверЛокализация.МассивОперацийПеречисленияВБюджет().Найти(ХозяйственнаяОперация) <> Неопределено);
	
	Если ДопускаетсяПеречислениеВБюджет Тогда
		МассивРеквизитовОперации.Добавить("ПеречислениеВБюджет");
	КонецЕсли;
	
	Если ДопускаетсяПеречислениеВБюджет 
		И (Объект.ПеречислениеВБюджет = Неопределено Или Объект.ПеречислениеВБюджет) Тогда
		МассивРеквизитовОперации.Добавить("ВидПеречисленияВБюджет");
		МассивРеквизитовОперации.Добавить("КодБК");
		МассивРеквизитовОперации.Добавить("КодОКАТО");
		МассивРеквизитовОперации.Добавить("ПоказательДаты");
		МассивРеквизитовОперации.Добавить("ПоказательНомера");
		МассивРеквизитовОперации.Добавить("ПоказательОснования");
		МассивРеквизитовОперации.Добавить("ПоказательПериода");
		МассивРеквизитовОперации.Добавить("ПоказательТипа");
		МассивРеквизитовОперации.Добавить("СтатусСоставителя");
	КонецЕсли;
	
КонецПроцедуры

// Определяет свойства полей формы в зависимости от данных
//
// Параметры:
//    Настройки - см. ДенежныеСредстваСервер.ИнициализироватьНастройкиПолейФормы.
//
Процедура ЗаполнитьНастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	Операции = Перечисления.ХозяйственныеОперации;
	
	#Область Шапка
	// СПАРК
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГруппаИндексыСПАРКРиски");
	
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
	
	Финансы.НовыйОтбор(Элемент.Условие, "ТипПлатежногоДокумента", Перечисления.ТипыПлатежныхДокументов.ПлатежноеТребование);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользованиеСПАРКРазрешено", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// СтраницаВалютныйКонтроль
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтраницаВалютныйКонтроль");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйКонтроль", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьВалютныеПлатежи", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("КодВалютнойОперации");
	Элемент.Поля.Добавить("КодВалютнойОперацииНаименованиеПолное");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйКонтроль", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьВалютныеПлатежи", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// СтатьяЦелевыхСредств
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяЦелевыхСредств");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.КонвертацияВалюты);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВнутренняяПередачаДенежныхСредств);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеОплатыПоПлатежнойКарте);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратНеперечисленныхДС);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратНеперечисленнойЗарплатыПоЗарплатномуПроекту);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствСДругогоСчета);
	
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.БанковскийСчетПоГосконтракту", Истина);
	
	Элемент.Свойства.Вставить("Видимость");
	#КонецОбласти
	
	#Область РасшифровкаПлатежа
	// ДоговорЗаймаСотруднику, ТипСуммыКредитаДепозита
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РасшифровкаПлатежа.ДоговорЗаймаСотруднику");
	Элемент.Поля.Добавить("РасшифровкаБезРазбиенияДоговорЗаймаСотруднику");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьНачислениеЗарплатыУТ", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ХозяйственнаяОперация", Операции.ПогашениеЗаймаСотрудником);
	Элемент.Свойства.Вставить("Видимость");
	
	// ТипСуммыКредитаДепозита
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
	Элемент.Поля.Добавить("РасшифровкаБезРазбиенияТипСуммыКредитаДепозита");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоДепозитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоЗаймамВыданным);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПогашениеЗаймаСотрудником);
	Элемент.Свойства.Вставить("Видимость");
	
	// СтатьяЦелевыхСредств
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РасшифровкаПлатежа.СтатьяЦелевыхСредств");
	Элемент.Поля.Добавить("РасшифровкаБезРазбиенияСтатьяЦелевыхСредств");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеОплатыОтКлиента);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратДенежныхСредствОтПоставщика);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПрочееПоступлениеДенежныхСредств);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоКредитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоДепозитам);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствПоЗаймамВыданным);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПогашениеЗаймаСотрудником);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратДенежныхСредствОтПодотчетника);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ПоступлениеДенежныхСредствИзДругойОрганизации);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратДенежныхСредствОтДругойОрганизации);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратДенежныхСредствОтАрендодателя);
	Финансы.НовыйОтбор(ГруппаИли, "ХозяйственнаяОперация", Операции.ВозвратНалогов);
	
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.БанковскийСчетПоГосконтракту", Истина);
	
	Элемент.Свойства.Вставить("Видимость");
	#КонецОбласти
	
КонецПроцедуры

//-- Локализация
#КонецОбласти

//++ Локализация


//-- Локализация

#КонецОбласти
