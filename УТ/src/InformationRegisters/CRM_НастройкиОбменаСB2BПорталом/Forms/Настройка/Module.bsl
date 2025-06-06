
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьНастройкиОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущийЭлемент = Элементы.ИспользоватьОбмен;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьНастройки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьнастройкиОбмена();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьНастройкиОбмена()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Узел = ПланыОбмена.CRM_ОбменB2BПортал.НайтиПоКоду("01");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Узел);
	URLПортала = Узел.URL;
	
	Если Не ЗначениеЗаполнено(EmailКонтактов) Тогда
		EmailКонтактов = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
	КонецЕсли;
	Если Таймаут = 0 Тогда
		Таймаут = 3;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкиОбменаСB2BПорталом.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, МенеджерЗаписи);
	КонецЕсли;
	
	ИспользоватьОбмен = ПолучитьФункциональнуюОпцию("CRM_ИспользоватьОбменB2BПортал");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОбмена()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Узел = ПланыОбмена.CRM_ОбменB2BПортал.НайтиПоКоду("01");
	
	УзелОбъект = Узел.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(УзелОбъект, ЭтотОбъект);
	УзелОбъект.URL = URLПортала;
	УзелОбъект.Записать();
	
	МенеджерЗаписи = РегистрыСведений.CRM_НастройкиОбменаСB2BПорталом.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЭтотОбъект);
	МенеджерЗаписи.Записать();
	
	ИспользоватьОбменПрежнееЗначение = ПолучитьФункциональнуюОпцию("CRM_ИспользоватьОбменB2BПортал");
	Если ИспользоватьОбмен <> ИспользоватьОбменПрежнееЗначение Тогда
		Константы.CRM_ИспользоватьОбменB2BПортал.Установить(ИспользоватьОбмен);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСПочтовымиСообщениямиКлиент.ПолеПароляНачалоВыбора(Элемент, Пароль, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
// Процедура определяет доступность первичного интереса.
//
// Параметры:
//	Нет.
//
Процедура ДоступностьКаналаИИсточникаОбращения()
      
	Если ЗначениеЗаполнено(КаналРекламногоВоздействия) И НЕ ЗначениеЗаполнено(ИсточникРекламногоВоздействия) Тогда
		Элементы.ИсточникРекламногоВоздействия.АвтоОтметкаНезаполненного	= Истина;
		Элементы.ИсточникРекламногоВоздействия.ОтметкаНезаполненного		= Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаналРекламногоВоздействия)
		 И (ТипПВХ(КаналРекламногоВоздействия) = Тип("ПеречислениеСсылка.CRM_КаналыБезУказанияИсточника")) Тогда
		Элементы.ИсточникРекламногоВоздействия.АвтоОтметкаНезаполненного	= Ложь;
		Элементы.ИсточникРекламногоВоздействия.ОтметкаНезаполненного		= Ложь;
	КонецЕсли;
	
КонецПроцедуры // ДоступностьКаналаИИсточникаОбращения()

&НаСервереБезКонтекста
// Функция возвращает тип значения элемента ПВХ.
//
// Параметры:
//	ПВХСсылкка	- ЛюбаяСсылка	- Ссылка на элемент ПВХ.
//
// Возвращаемое значение:
//	Тип	- Тип значения элемента ПВХ.
//
Функция ТипПВХ(ПВХСсылка)
	Возврат ТипЗнч(ПВХСсылка.ТипЗначения.ПривестиЗначение());
КонецФункции // ТипПВХ()

&НаКлиенте
Процедура КаналРекламногоВзаимодействияПриИзменении(Элемент)
	ДоступностьКаналаИИсточникаОбращения();
	
	Если ИсточникРекламногоВоздействия = Неопределено ИЛИ ИсточникРекламногоВоздействия.Пустая() Тогда
		Элементы.ИсточникРекламногоВоздействия.ПодсказкаВвода = Строка(CRM_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(КаналРекламногоВоздействия,
			 "ТипЗначения"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаналРекламногоВоздействия)
		 И ТипПВХ(КаналРекламногоВоздействия) <> Тип("ПеречислениеСсылка.CRM_КаналыБезУказанияИсточника") Тогда
		Элементы.ИсточникРекламногоВоздействия.Видимость = Истина;
		Элементы.ИсточникРекламногоВоздействия.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ИсточникРекламногоВоздействия.Видимость = Ложь;
		Элементы.ИсточникРекламногоВоздействия.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаналРекламногоВоздействия) И Не ЗначениеЗаполнено(ИсточникРекламногоВоздействия) Тогда
		Элементы.ИсточникРекламногоВоздействия.АвтоОтметкаНезаполненного = Истина;
		Элементы.ИсточникРекламногоВоздействия.ОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаналРекламногоВоздействия)	И ТипПВХ(КаналРекламногоВоздействия) = Тип("ПеречислениеСсылка.CRM_КаналыБезУказанияИсточника") Тогда
		Элементы.ИсточникРекламногоВоздействия.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ИсточникРекламногоВоздействия.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	//Подключаемый_ПриИзмененииРеквизита(Элемент);
	ИсточникРекламногоВоздействия = Неопределено;
	//Подключаемый_ПриИзмененииРеквизита(Элементы.ИсточникРекламногоВоздействия);

КонецПроцедуры

&НаКлиенте
Процедура КаналРекламногоВзаимодействияНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",		Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока",	КаналРекламногоВоздействия);
	ОткрытьФорму("ПланВидовХарактеристик.КаналыРекламныхВоздействий.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ИсточникРекламногоВоздействияНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
		Если ЗначениеЗаполнено(КаналРекламногоВоздействия) Тогда
		
		Если ТипПВХ(КаналРекламногоВоздействия)= Тип("СправочникСсылка.МаркетинговыеМероприятия") Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора",		Истина);
			ПараметрыФормы.Вставить("ТекущаяСтрока",	ИсточникРекламногоВоздействия);
			ПараметрыФормы.Вставить("СкрытьПодменюВид",	Истина);
			ФормаВыбора = ПолучитьФорму("Справочник.МаркетинговыеМероприятия.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);
			ЭлементОтбора					= ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеРавно;
			ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Завершено");
			ЭлементОтбора.ПравоеЗначение	= Истина;
			ЭлементОтбора.Использование		= Истина;
			
			ГруппаОтбора					= ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаОтбора.ТипГруппы			= ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ЭлементОтбора					= ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ДатаОкончания");
			ЭлементОтбора.ПравоеЗначение	= Дата("00010101");
			ЭлементОтбора.Использование		= Истина;
			ЭлементОтбора					= ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("CRM_ДатаАктуальности");
			ЭлементОтбора.ПравоеЗначение	= НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			ЭлементОтбора.Использование		= Истина;
			ФормаВыбора.Открыть();
			
		ИначеЕсли ТипПВХ(КаналРекламногоВоздействия) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
			СтандартнаяОбработка	= Ложь;
			ДополнительныеПараметры	= Новый Структура("Элемент", Элемент);
			ОписаниеВыбораПартнера	= Новый ОписаниеОповещения("ОбработкаВыбораПартнераИсточника", ЭтотОбъект,
				 ДополнительныеПараметры);
			ПараметрыФормы			= Новый Структура;
			Если ЗначениеЗаполнено(ИсточникРекламногоВоздействия)
				 И (ТипЗнч(ИсточникРекламногоВоздействия) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров")) Тогда
				ПараметрыФормы.Вставить("ТекущаяСтрока",
					 CRM_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(ИсточникРекламногоВоздействия,
					 "Владелец"));
			КонецЕсли;
			ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", ПараметрыФормы, Элемент, ,
				 ВариантОткрытияОкна.ОтдельноеОкно, ,
				 ОписаниеВыбораПартнера);
			
		ИначеЕсли ТипПВХ(КаналРекламногоВоздействия) = Тип("СправочникСсылка.Партнеры") Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора",		Истина);
			ПараметрыФормы.Вставить("ТекущаяСтрока",	ИсточникРекламногоВоздействия);
			ФормаВыбора = ПолучитьФорму("Справочник.Партнеры.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);
			ФормаВыбора.Открыть();
			
		ИначеЕсли ТипПВХ(КаналРекламногоВоздействия) = Тип("СправочникСсылка.Пользователи") Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора",		Истина);
			ПараметрыФормы.Вставить("ТекущаяСтрока",	ИсточникРекламногоВоздействия);
			ФормаВыбора = ПолучитьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);
			ФормаВыбора.Открыть();
			
		ИначеЕсли ТипПВХ(КаналРекламногоВоздействия) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора",		Истина);
			ПараметрыФормы.Вставить("ТекущаяСтрока",	ИсточникРекламногоВоздействия);
			ФормаВыбора = ПолучитьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);
			ФормаВыбора.Открыть();
			
		ИначеЕсли ТипПВХ(КаналРекламногоВоздействия) = Тип("ДокументСсылка.CRM_Телемаркетинг") Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора",		Истина);
			ПараметрыФормы.Вставить("ТекущаяСтрока",	ИсточникРекламногоВоздействия);
			ФормаВыбора = ПолучитьФорму("Документ.CRM_Телемаркетинг.ФормаВыбора", ПараметрыФормы, Элемент, ЭтотОбъект);
			ФормаВыбора.Открыть();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДоступностьКаналаИИсточникаОбращения();

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик выбора партнера - владельца.
//
// Параметры:
//	РезультатЗакрытия		- СправочникСсылка	- Владелец контактных лиц.
//	ДополнительныеПараметры	- Структура			- Структура дополнительных параметров.
//
Процедура ОбработкаВыбораПартнераИсточника(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	ПараметрыФормы = Новый Структура;
	Если РезультатЗакрытия <> Неопределено Тогда 
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", РезультатЗакрытия));
	КонецЕсли;
	ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.ФормаВыбора", ПараметрыФормы,
		 ДополнительныеПараметры.Элемент, ,
		 ВариантОткрытияОкна.ОтдельноеОкно);
КонецПроцедуры // ОбработкаВыбораПартнераИсточника()

#КонецОбласти
