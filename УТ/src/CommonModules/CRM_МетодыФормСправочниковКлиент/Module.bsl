
////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область Справочник_ВидыКонтактнойИнформации_ФормаЭлемента

// Процедура установливает доступность флажка "CRM_ИспользоватьДляОповещений".
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - Передаваемая форма. 
//
Процедура УстановитьВидимостьИспользоватьДляОповещений(Форма) Экспорт
	
	Если (Форма.Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"))
		Или (Форма.Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"))
		Или (Форма.Объект.ИдентификаторДляФормул = "Telegram") Тогда
		Форма.Элементы.CRM_ИспользоватьДляОповещений.Видимость = Истина;
	Иначе
		Форма.Элементы.CRM_ИспользоватьДляОповещений.Видимость = Ложь;
		Если Форма.Объект.CRM_ИспользоватьДляОповещений Тогда
			Форма.Объект.CRM_ИспользоватьДляОповещений = Ложь;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры // УстановитьДоступностьИспользоватьДляОповещений()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Справочник_ФизическиеЛица_ФормаЭлемента

Процедура ФизическиеЛицаФормаЭлементаПослеЗаписи(Форма, Объект) Экспорт
	
	Если Форма.НеобходимоОповещение Тогда
		Оповестить("ЗаполнитьКонтактВТелефонномЗвонке", Новый Структура("Звонок, Контакт",
			 Форма.ОбъектОснование,
			 Объект.Ссылка));
		Форма.НеобходимоОповещение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// +CRM_Модуль
#Область ПартнерыИКонтрагентыКлиент

Процедура ПартнерыФормаСпискаВыбораСписокПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа, Основание = Неопределено) Экспорт
	
	Если Копирование Тогда
		Если НЕ Форма.УпрощенныйВводДоступен Тогда
			Отказ = Истина;
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru='Копирование %1 запрещено.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			            ТекстСообщения, 
			            ?(Форма.ИспользоватьПартнеровКакКонтрагентов, НСтр("ru='контрагентов'"), НСтр("ru='партнеров'")));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Копирование партнеров запрещено.'"));
		КонецЕсли;
	Иначе
		Отказ = Истина;
		ИспользоватьМастерВводаНового = CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ИспользоватьПомощникВводаНовогоКлиента");		
		ИспользоватьФормуУТ = CRM_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеНастройки("ИспользоватьТиповуюФормуРегистрацииНовогоПартнера");
		Если ИспользоватьМастерВводаНового Тогда		
			Если ИспользоватьФормуУТ Тогда
				ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового",Новый Структура("СписокОтборПоТипуПартнера, Основание", Форма.СписокОтборПоТипуПартнера, Основание), Форма);
			Иначе
				ОткрытьФорму("Справочник.Партнеры.Форма.CRM_Модуль_ФормаБыстрогоВвода", Новый Структура("ЗаголовокФормыВладельца, СписокОтборПоТипуПартнера", Форма.Заголовок, Форма.СписокОтборПоТипуПартнера), Форма);
			КонецЕсли;
		Иначе
			ПартнерыФормаСпискаВыбораСоздатьНового(Форма);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из различных форм списка справочника "Партнеры" при выполнении команды по созданию нового партнера.
// Параметры:
//  Форма                - УправляемаяФорма - форма, в которой выполняется команда.
//  Элемент              - КомандаФормы     - выполненная команда формы.
//
Процедура ПартнерыФормаСпискаВыбораСоздатьНового(Форма, Команда = Неопределено) Экспорт
	
	СтруктураПараметры = Новый Структура;
	СтруктураЗначенияЗаполнения = Новый Структура;
	
	Для каждого ЭлементОтбора Из ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Форма.Список).Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно И ЭлементОтбора.Использование Тогда
			СтруктураЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Если Форма.Элементы.Список.Отображение <> ОтображениеТаблицы.Список Тогда
		СтруктураЗначенияЗаполнения.Вставить("Родитель", Форма.Элементы.Список.ТекущийРодитель);
	КонецЕсли;
	
	СтруктураПараметры.Вставить("ЗначенияЗаполнения", СтруктураЗначенияЗаполнения);
	СтруктураПараметры.Вставить("СписокОтборПоТипуПартнера", Форма.СписокОтборПоТипуПартнера);
	
	ВыбраннаяФорма = "CRM_Модуль_ФормаЭлементаРеквизитыКонтрагентаНовая";
	ОткрытьФорму("Справочник.Партнеры.Форма."+ВыбраннаяФорма, СтруктураПараметры, Форма);
	
КонецПроцедуры

#КонецОбласти
// -CRM_Модуль

#КонецОбласти
