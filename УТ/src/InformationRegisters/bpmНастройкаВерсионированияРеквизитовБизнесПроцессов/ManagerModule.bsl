#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Эта функция больше не используется, она нужна для перехода с релизов меньше 2_0_6_2 на более поздние,
//  для получения признака ведения версионирования нужно использовать выражение
//  ПолучитьФункциональнуюОпцию("CRM_ВестиИсториюРеквизитовКлиентов").
// 
// Возвращаемое значение:
//  Булево - Признак использования версионирования. Истина, если версионирование используется. 
//
Функция ПолучитьИспользованиеВерсионирования() Экспорт
	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров) Тогда
		Запрос =
			Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Использовать ИЗ РегистрСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров ГДЕ Использовать = ИСТИНА");
		Возврат Не Запрос.Выполнить().Пустой();
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

// Процедура - Сохранить настройку
//  Процедура сохраняет настройку версионирования.
//
// Параметры:
//  СтруктураНастройки	 - Структура - Структура параметров настройки 
//
Процедура СохранитьНастройку(СтруктураНастройки) Экспорт
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ЗначениеНастройки = Новый ХранилищеЗначения(СтруктураНастройки);
	МенеджерЗаписи.Использовать = Истина;
	МенеджерЗаписи.Записать();
КонецПроцедуры

// Функция - Получить настройку
// 
// Возвращаемое значение:
//  Структура - Структура массивов.
//  	Реквизиты - Массив - Реквизиты версионирования бизнесс процесса CRM_БизнесПроцесс.
//  	РеквизитыЗадачи - Массив - Реквизиты версионирования задачи ЗадачаИсполнителя.
//
Функция ПолучитьНастройку() Экспорт
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат Новый Структура("СтруктураНастройки", МенеджерЗаписи.ЗначениеНастройки.Получить());
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Функция - Получить список версионируемых реквизитов
// Функция возвращает список версионируемых реквизитов.
//
// Возвращаемое значение:
//  Список -  СписокЗначений - Список версионируемых реквизитов. 
//
Функция ПолучитьСписокВерсионируемыхРеквизитов() Экспорт
	Список = Новый СписокЗначений();
	
	Настройка = РегистрыСведений.CRM_НастройкаВерсионированияРеквизитовПартнеров.ПолучитьНастройку();
	Если ТипЗнч(Настройка) = Тип("Структура") Тогда
		Если (ТипЗнч(Настройка.СтруктураНастройки) <> Тип("Структура")
			 Или Не Настройка.СтруктураНастройки.Свойство("Реквизиты")) Тогда
			Возврат Список;
		КонецЕсли;
	Иначе
		Возврат Список;
	КонецЕсли;
	Реквизиты = Настройка.СтруктураНастройки.Реквизиты;
	Если ТипЗнч(Реквизиты) <> Тип("Массив") Тогда
		Возврат Список;
	КонецЕсли;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		Если ТипЗнч(Реквизит) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			Список.Добавить(Реквизит, Строка(Реквизит));
		ИначеЕсли ТипЗнч(Реквизит) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			Список.Добавить(Реквизит, Строка(Реквизит));
		ИначеЕсли Реквизит = "Сегмент" Тогда
			Список.Добавить(Реквизит, НСтр("ru='Сегмент';en='Segment'"));
		Иначе
			НайденныйРеквизит = Неопределено;
			Для Каждого РеквизитМд Из Метаданные.Справочники.Партнеры.СтандартныеРеквизиты Цикл
				Если РеквизитМд.Имя = Реквизит Тогда
					НайденныйРеквизит = РеквизитМд;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НайденныйРеквизит = Неопределено Тогда
				Для Каждого РеквизитМд Из Метаданные.Справочники.Партнеры.Реквизиты Цикл
					Если РеквизитМд.Имя = Реквизит Тогда
						НайденныйРеквизит = РеквизитМд;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если НайденныйРеквизит <> Неопределено Тогда
				Список.Добавить(НайденныйРеквизит.Имя, ?(ЗначениеЗаполнено(НайденныйРеквизит.Синоним),
					 НайденныйРеквизит.Синоним,
					 НайденныйРеквизит.Синоним));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Список.Добавить("ABCКласс", НСтр("ru='ABC класс';en='ABC Class'"));
	Список.Добавить("XYZКласс", НСтр("ru='XYZ класс';en='XYZ class'"));
	Возврат Список;
КонецФункции

#КонецОбласти

#КонецЕсли
