#Область ПрограммныйИнтерфейс

// Вызывается для получения настроек подсистемы.
//
// Параметры:
//  Настройки - Структура:
//   * Реквизиты - Соответствие из КлючИЗначение - для переопределения имен реквизитов объекта, в которых содержится информация 
//                                о сумме и валюте, выводимых в списке связанных документов. 
//                                В ключе указывается полное имя объекта метаданных, в значении - соответствие 
//                                реквизитов Валюта и СуммаДокумента с реальными реквизитами объекта. 
//                                Если не задано, то значения зачитываются из реквизитов Валюта и СуммаДокумента.
//   * РеквизитыДляПредставления - Соответствие из КлючИЗначение - для переопределения представления объектов, выводимых
//                                в списке связанных документов. В ключе указывается полное имя объекта метаданных, в
//                                значении - массив имен реквизитов, значения которых участвуют в формировании представления.
//                                Для формирования представления перечисленных здесь объектов будет вызываться 
//                                процедура СтруктураПодчиненностиПереопределяемый.ПриПолученииПредставления.
//
// Пример:
//	Реквизиты = Новый Соответствие;
//	Реквизиты.Вставить("СуммаДокумента", Метаданные.Документы.СчетНаОплатуПокупателю.Реквизиты.СуммаОплаты.Имя);
//	Реквизиты.Вставить("Валюта", Метаданные.Документы.СчетНаОплатуПокупателю.Реквизиты.ВалютаДокумента.Имя);
//	Настройки.Реквизиты.Вставить(Метаданные.Документы.СчетНаОплатуПокупателю.ПолноеИмя(), Реквизиты);
//		
//	РеквизитыДляПредставления = Новый Массив;
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.ДатаОтправления.Имя);
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.Тема.Имя);
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.СписокПолучателейПисьма.Имя);
//	Настройки.РеквизитыДляПредставления.Вставить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.ПолноеИмя(), 
//		РеквизитыДляПредставления);
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Вызывается для получения представления объектов, выводимых в списке связанных документов.
// Только для тех объектов, которые перечислены в свойстве РеквизитыДляПредставления параметра Настройки
// процедуры СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
//
// Параметры:
//  ТипДанных - ЛюбаяСсылка - тип ссылки выводимого объекта, см. свойство Тип критерия отбора СвязанныеДокументы.
//  Данные    - ВыборкаИзРезультатаЗапроса
//            - Структура - содержит значения полей, из которых формируется представление:
//               * Ссылка - ЛюбаяСсылка - ссылка объекта, выводимого в списке связанных документов.
//               * ДополнительныйРеквизит1 - Произвольный - значение первого реквизита, указанного в массиве 
//                 РеквизитыДляПредставления параметра Настройки процедуры ПриОпределенииНастроек.
//               * ДополнительныйРеквизит2 - Произвольный - значение второго реквизита...
//               ...
//  Представление - Строка - поместить в этот параметр рассчитанное представление объекта. 
//  СтандартнаяОбработка - Булево - поместить в этот параметр Ложь, если установлено значение параметра Представление.
//
Процедура ПриПолученииПредставления(ТипДанных, Данные, Представление, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры	

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
// См. свойство РеквизитыДляПредставления параметра Настройки.
// Формирует массив реквизитов документа. 
// 
// Параметры: 
//  ИмяДокумента - Строка - имя документа.
//
// Возвращаемое значение:
//   Массив - массив наименований реквизитов документа. 
//
Функция МассивРеквизитовОбъектаДляФормированияПредставления(ИмяДокумента) Экспорт
	
	Возврат Новый Массив;
	
КонецФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриПолученииПредставления.
// Получает представление документа для печати.
//
// Параметры:
//  Выборка - ВыборкаИзРезультатаЗапроса - структура или выборка из результатов запроса
//            в которой содержатся дополнительные реквизиты, на основании
//            которых можно сформировать переопределенное представление 
//            документа для вывода в отчет "Структура подчиненности".
//
// Возвращаемое значение:
//   - Строка
//   - Неопределено - переопределенное представление документа, или Неопределено,
//                    если для данного типа документов такое не задано.
//
Функция ПредставлениеОбъектаДляВыводаВОтчет(Выборка) Экспорт
	
	// +CRM
	Если ТипЗнч(Выборка.Ссылка) = Тип("БизнесПроцессСсылка.CRM_БизнесПроцесс") Тогда
		ПредставлениеДокумента = Выборка.Ссылка.Наименование + ?(ЗначениеЗаполнено(Выборка.Ссылка.Проект),
			 "/ " + Выборка.Ссылка.Проект, "") + " / от  " + Формат(Выборка.Ссылка.Дата,
			 "ДФ=dd.MM.yyyy");
		
		Возврат ПредставлениеДокумента;
	КонецЕсли;
	
	Если ТипЗнч(Выборка.Ссылка) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		ПредставлениеДокумента = НСтр("ru='Этап: ';en='Stage:'") + Выборка.Ссылка.CRM_ТочкаМаршрута.Наименование + " / " 
			+ Выборка.Ссылка.Наименование 
			+ " / Срок до: " + Формат(Выборка.Ссылка.СрокИсполнения,
			 "ДФ=dd.MM.yyyy");
		
		Возврат ПредставлениеДокумента;
	КонецЕсли;
	Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		ПредставлениеДокумента = НСтр("ru='Исходящее эл. письмо: ';en='Outbox Email: '") 
			+  Выборка.Ссылка.СписокПолучателейПисьма 
			+ " " 
			+ """" + Выборка.Ссылка.Тема + """" + " от " + Формат(Выборка.Ссылка.Дата, "ДФ='d.MM.yyyy HH:mm'");
		Возврат ПредставлениеДокумента;
	ИначеЕсли ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		ПредставлениеДокумента = НСтр("ru='Входящее эл. письмо: ';en='Incoming e-mail: '") 
			+  Выборка.Ссылка.ОтправительПредставление 
			+ "<" 
			+ Выборка.Ссылка.ОтправительАдрес + "> " + """" + Выборка.Ссылка.Тема + """" + " от " 
			+ Формат(Выборка.Ссылка.Дата, "ДФ='d.MM.yyyy HH:mm'");
		Возврат ПредставлениеДокумента;
	ИначеЕсли ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
		Если ЗначениеЗаполнено(Выборка.Ссылка.АбонентКонтакт) Тогда
			ПредставлениеКонтакта = Выборка.Ссылка.АбонентКонтакт.Наименование;
		Иначе	
			ПредставлениеКонтакта = Выборка.Ссылка.АбонентПредставление;
		КонецЕсли;
		ПредставлениеДокумента = ?(Выборка.Ссылка.Входящий,
			 НСтр("ru='Входящий звонок';en='Incoming Call'"), НСтр("ru='Исходящий звонок'"))	
			+ ": " 
			+ ПредставлениеКонтакта + ", " 
			+ Формат(Выборка.Ссылка.Дата, "ДФ='d MMM'; ДЛФ=D") + " / "
			+ Формат(Выборка.Ссылка.Дата, "ДФ=HH:mm; ДЛФ=T; ДП=00:00") + " / " 
			+ Формат(Дата('00010101') + Выборка.Ссылка.сфпДлительностьЗвонка, "ДФ=mm:ss; ДЛФ=T; ДП=00:00") + ", " 
			+ Строка(Выборка.Ссылка.Автор.Наименование);
		Возврат ПредставлениеДокумента;
	ИначеЕсли ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.СообщениеSMS") Тогда
		ПредставлениеДокумента = ?(Выборка.Ссылка.SMS4B_ТипСообщения = Перечисления.SMS4B_ТипыСообщений.Входящее,
			НСтр("ru='Входящее сообщение SMS';en='Incoming SMS'"), НСтр("ru='Исходящее сообщение SMS'"))
			+ " от " + Формат(Выборка.Ссылка.Дата, "ДФ=dd.MM.yyyy; ДЛФ=DT")
			+ " (" + Выборка.Ссылка.SMS4B_СтатусСтрокой + "): " + Выборка.Ссылка.СписокУчастников;
		Возврат ПредставлениеДокумента;
	КонецЕсли;
	// -CRM
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
// См. свойство Реквизиты параметра Настройки.
// Возвращает имя реквизита документа, в котором содержится информация о Сумме и Валюте документа для вывода в
// структуру подчиненности.
// По умолчанию используются реквизиты Валюта и СуммаДокумента. Если для конкретного документа или конфигурации в целом
// используются другие
// реквизиты, то переопределить значения по умолчанию можно в данной функции.
//
// Параметры:
//  ИмяДокумента  - Строка - имя документа, для которого надо получить имя реквизита.
//  Реквизит      - Строка - строка, может принимать значения "Валюта" и "СуммаДокумента".
//
// Возвращаемое значение:
//   Строка   - имя реквизита документа, в котором содержится информация о Валюте или Сумме.
//
Функция ИмяРеквизитаДокумента(ИмяДокумента, Реквизит) Экспорт
	
	// +CRM
	МетаданныеДокумента = Метаданные.Документы.Найти(ИмяДокумента);
	
	Если МетаданныеДокумента = Неопределено Тогда
		МетаданныеДокумента = Метаданные.БизнесПроцессы.Найти(ИмяДокумента);
	КонецЕсли; 
	
	Если МетаданныеДокумента = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Реквизит = "СуммаДокумента" Тогда
		Если МетаданныеДокумента.Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
			Возврат "СуммаДокумента";
		КонецЕсли;
	ИначеЕсли Реквизит = "Валюта" Тогда
		Если МетаданныеДокумента.Реквизиты.Найти("Валюта") <> Неопределено Тогда
			Возврат "Валюта";
		КонецЕсли;
	КонецЕсли;
	// -CRM
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
