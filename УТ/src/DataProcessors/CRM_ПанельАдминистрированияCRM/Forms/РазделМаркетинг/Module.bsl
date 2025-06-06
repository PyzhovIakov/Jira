
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не CRM_ЛицензированиеЭкспортныеМетоды.ПодсистемаCRMИспользуется() Тогда
		CRM_ЛицензированиеЭкспортныеМетоды.ВывестиУведомлениеОНедоступности(НСтр("ru = 'форму настройки'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗащищенныйОбъект = CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьЗащищеннуюОбработку();
	ЗащищенныйОбъект.ПанельАдминистрированияCRM_ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не Константы.ИспользоватьРазделениеПоОбластямДанных.Получить() Тогда
		Задание =
			РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.CRM_ОтправкаРассылокЭлектронныхПисем);
		ПериодОтправкиПисемЭлектроннойРассылки = Задание.Расписание.ПериодПовтораВТечениеДня;
	Иначе	
		ПериодОтправкиПисемЭлектроннойРассылки = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	УстановитьДоступность();
	
	Если Не НаборКонстант.ИспользоватьХарактеристикиНоменклатуры Тогда
		Элементы.ИспользоватьХарактеристикиНоменклатуры.ОтображениеПредупрежденияПриРедактировании =
			ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	Иначе
		Элементы.ИспользоватьХарактеристикиНоменклатуры.ОтображениеПредупрежденияПриРедактировании =
			ОтображениеПредупрежденияПриРедактировании.Отображать;
	КонецЕсли;
	
	// Видимость команд
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		Элементы.ГруппаСправочникиГруппыТоваров.Видимость = Ложь;
		Элементы.ГруппаСправочникиСкидкиНаценки.Видимость = Ложь;
		Элементы.ГруппаКонстантыВеденияПродаж.Видимость   = Ложь;
	КонецЕсли;
	
	ИмяФОИспользуетсяСегментацияНоменклатуры = ?(CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM(),
		 "CRM_ИспользоватьСегментацию",
		 "ИспользоватьСегментыНоменклатуры");
	Элементы.ОткрытьСегментыНоменклатуры.Видимость = ПолучитьФункциональнуюОпцию(ИмяФОИспользуетсяСегментацияНоменклатуры);
	
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ЭтоРазделенныйРежимРаботы = Константы.ИспользоватьРазделениеПоОбластямДанных.Получить();
		ЭтоПлатныйТариф = Константы.CRM_ПлатныйТарифДоступен.Получить();
		Элементы.ГруппаМаркетинг.Видимость = Не ЭтоРазделенныйРежимРаботы Или ЭтоПлатныйТариф;
		Элементы.CRM_ИспользоватьМаркетинговыеМероприятия.Видимость = Не ЭтоРазделенныйРежимРаботы Или ЭтоПлатныйТариф;
		Элементы.ГруппаСправочникиКампаний.Видимость =
			ПолучитьФункциональнуюОпцию("CRM_ИспользоватьМаркетинговыеМероприятия");
		Элементы.ГруппаСправочникиЦены.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаСправочникиГруппыТоваров.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаСправочникиСкидкиНаценки.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаКонстантыВеденияПродаж.Видимость = Не ЭтоРазделенныйРежимРаботы;
		
		Элементы.ГруппаСквознаяАналитика.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаКлассификация.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаАнкетирование.Видимость = Не ЭтоРазделенныйРежимРаботы;
		Элементы.ГруппаТелемаркетинг.Видимость = Не ЭтоРазделенныйРежимРаботы Или ЭтоПлатныйТариф;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПриЗакрытии".
//
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ОбработкаОповещения".
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // Такие событие не обрабатываются.
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Клиент

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти // ВызовСервера

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьАнкетирование" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.CRM_АдресWebДоступа.Видимость = НаборКонстант.ИспользоватьАнкетирование;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.CRM_ИспользоватьКлассификаторы" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СправочникЗначенияКлассификаторов.Видимость = НаборКонстант.CRM_ИспользоватьКлассификаторы;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.CRM_СквознаяАналитика" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьФормуНастройкиСквознойАналитики.Видимость = НаборКонстант.CRM_СквознаяАналитика;
	КонецЕсли;
	
	ЭтоРазделенныйРежимРаботы = Константы.ИспользоватьРазделениеПоОбластямДанных.Получить();
	ЭтоПлатныйТариф = Константы.CRM_ПлатныйТарифДоступен.Получить();
	Элементы.CRM_ИспользоватьРассылкиЭлектронныхПисем.Видимость = ЭтоПлатныйТариф ИЛИ НЕ ЭтоРазделенныйРежимРаботы;

	Если РеквизитПутьКДанным = "НаборКонстант.CRM_ИспользоватьСегментацию" ИЛИ РеквизитПутьКДанным = "" Тогда
		ИмяФОИспользуетсяСегментацияНоменклатуры = ?(CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM(),
			 "CRM_ИспользоватьСегментацию",
			 "ИспользоватьСегментыНоменклатуры");
		Элементы.ОткрытьСегментыНоменклатуры.Видимость =
			ПолучитьФункциональнуюОпцию(ИмяФОИспользуетсяСегментацияНоменклатуры);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти // Сервер

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область Классификация

&НаКлиенте
Процедура CRM_ИспользоватьСегментациюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// +CRM_Модуль
//&НаКлиенте
//Процедура CRM_ИспользоватьСегментациюПриИзменении(Элемент)
//	Подключаемый_ПриИзмененииРеквизита(Элемент);
//КонецПроцедуры
// -CRM_Модуль

&НаКлиенте
Процедура ОткрытьСегментыКлиентов(Команда)
	ОткрытьФорму("Справочник.СегментыПартнеров.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСегментыНоменклатуры(Команда)
	ОткрытьФорму("Справочник.СегментыНоменклатуры.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьABCXYZКлассификациюПартнеровПоВыручкеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродажПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОписаниеСегментацияКлиентов(Команда)
	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("СегментацияКлиентов"));
КонецПроцедуры

#КонецОбласти // Классификация

#Область Рассылки

&НаКлиенте
Процедура ОткрытьСпискиРассылок(Команда)
	ОткрытьФорму("Справочник.CRM_СпискиРассылок.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныРассылок(Команда)
	ОткрытьФорму("Справочник.CRM_ШаблоныРассылки.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура CRM_КоличествоПисемЭлектроннойРассылкиВОтправляемомПакетеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтправкиПисемЭлектроннойРассылкиПриИзменении(Элемент)
	ПериодОтправкиПисемЭлектроннойРассылкиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодОтправкиПисемЭлектроннойРассылкиПриИзмененииНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	Задание =
		РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.CRM_ОтправкаРассылокЭлектронныхПисем);
	Задание.Расписание.ПериодПовтораВТечениеДня = ПериодОтправкиПисемЭлектроннойРассылки;
	Задание.Записать();
КонецПроцедуры

#КонецОбласти // Рассылки

#Область Анкетирование

&НаКлиенте
Процедура ИспользоватьАнкетированиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура CRM_АдресWebДоступаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВопросыДляАнкетирования(Команда)
	ОткрытьФорму("ПланВидовХарактеристик.ВопросыДляАнкетирования.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти // Анкетирование

#Область Маркетинг

&НаКлиенте
Процедура ОткрытьМаркетинговыеМероприятия(Команда)
	ОткрытьФорму("Справочник.МаркетинговыеМероприятия.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыМаркетинговыхМероприятий(Команда)
	ОткрытьФорму("Справочник.CRM_ВидыМаркетинговыхКампаний.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаправленияДеятельности(Команда)
	ОткрытьФорму("Справочник.НаправленияДеятельности.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаналыРекламныхВоздействий(Команда)
	ОткрытьФорму("ПланВидовХарактеристик.КаналыРекламныхВоздействий.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция ОтказСнятьФункциональнаяОпцияИспользоватьСкидкиНаценки() 
	
	Отказ = Ложь;
	
	ВыборкаВидыСкидокНаценок = Справочники["ВидыСкидокНаценок"].Выбрать();
	Пока ВыборкаВидыСкидокНаценок.Следующий() Цикл
		
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(ВыборкаВидыСкидокНаценок.Ссылка);
		ТаблицаСсылок = НайтиПоСсылкам(МассивСсылок);
		
		Если ТаблицаСсылок.Количество() > 0 Тогда
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru='В базе используются виды скидок,
				| наценок! Снятие опции запрещено!';en='Types of discounts,
				| margins are used in the database! Option de-selection is not allowed!'");	
			Сообщение.Поле = "НаборКонстант.ФункциональнаяОпцияИспользоватьСкидкиНаценки";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Прервать;
		
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат Отказ;
	
КонецФункции  

&НаСервере
Функция МожноОтключитьКонстантуИспользоватьСкидкиНаценки()
	
	// Если есть ссылки на виды скидок в документах, то нельзя снять флаг ФункциональнаяОпцияИспользоватьСкидкиНаценки.
	Если Константы["ФункциональнаяОпцияИспользоватьСкидкиНаценки"].Получить() <> НаборКонстант.ФункциональнаяОпцияИспользоватьСкидкиНаценки 
		И (НЕ НаборКонстант.ФункциональнаяОпцияИспользоватьСкидкиНаценки)
			 И ОтказСнятьФункциональнаяОпцияИспользоватьСкидкиНаценки() Тогда
		НаборКонстант.ФункциональнаяОпцияИспользоватьСкидкиНаценки = Истина;
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ФункциональнаяОпцияИспользоватьСкидкиНаценкиПриИзменении(Элемент)
	Если МожноОтключитьКонстантуИспользоватьСкидкиНаценки() Тогда
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыСкидокНаценок(Команда)
	СтрокаИмяФормы = "Справочник.ВидыСкидокНаценок.ФормаСписка";
	ОткрытьФорму(СтрокаИмяФормы, , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦен(Команда)
	ОткрытьФорму("Справочник.ВидыЦен.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныОтказовПриОбзвоне(Команда)
	ОткрытьФорму("Справочник.CRM_ПричиныОтказовПриОбзвоне.Форма.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЦеновыеГруппы(Команда)
	ОткрытьФорму("Справочник.ЦеновыеГруппы.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНоменклатурныеГруппы(Команда)
	СтрокаИмяФормы = "Справочник.НоменклатурныеГруппы.ФормаСписка";
	ОткрытьФорму(СтрокаИмяФормы, , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтавкиНДС(Команда)
	СтрокаИмяФормы = "Справочник.СтавкиНДС.ФормаСписка";
	ОткрытьФорму(СтрокаИмяФормы, , ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция ОтказСнятьФункциональнаяОпцияИспользоватьХарактеристики() 
	
	ЕстьДвижения = Ложь;
	
	ИменаРегистров = Новый Массив;
	ИменаРегистров.Добавить("CRM_Продажи");
	ИменаРегистров.Добавить("CRM_Предложения");
	
	ТекстЗапроса = "";
	Для Инд = 0 По ИменаРегистров.ВГраница() Цикл
		
		ИмяРегистра = ИменаРегистров[Инд];
		
		ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	" + ИмяРегистра + ".ХарактеристикаНоменклатуры
		|ИЗ
		|	РегистрНакопления." + ИмяРегистра + " КАК " + ИмяРегистра + "
		|ГДЕ
		|	" + ИмяРегистра + ".ХарактеристикаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)";
		
		Если Инд <> ИменаРегистров.ВГраница() Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ЕстьДвижения = Не РезультатЗапроса.Пустой();
	
	Если ЕстьДвижения Тогда
		ТекстСообщения =
			НСтр("ru = 'В информационной базе есть движения по характеристикам. Выключение настройки запрещено.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат ЕстьДвижения;
	
КонецФункции  

&НаСервере
Функция МожноОтключитьКонстантуИспользоватьХарактеристики()
	
	// Если характетистики уже используются в движениях документов, то нельзя снять флаг
	// ИспользоватьХарактеристикиНоменклатуры.
	Если Константы.ИспользоватьХарактеристикиНоменклатуры.Получить() <> НаборКонстант.ИспользоватьХарактеристикиНоменклатуры 
		И (НЕ НаборКонстант.ИспользоватьХарактеристикиНоменклатуры)
			 И ОтказСнятьФункциональнаяОпцияИспользоватьХарактеристики() Тогда
		НаборКонстант.ИспользоватьХарактеристикиНоменклатуры = Истина;
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ФункциональнаяОпцияИспользоватьХарактеристикиПриИзменении(Элемент)
	
	Если МожноОтключитьКонстантуИспользоватьХарактеристики() Тогда
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;	
	
	Если НЕ НаборКонстант.ИспользоватьХарактеристикиНоменклатуры Тогда
		Элементы.ИспользоватьХарактеристикиНоменклатуры.ОтображениеПредупрежденияПриРедактировании =
			ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	Иначе
		Элементы.ИспользоватьХарактеристикиНоменклатуры.ОтображениеПредупрежденияПриРедактировании =
			ОтображениеПредупрежденияПриРедактировании.Отображать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФункциональнаяОпцияУчетВРазличныхЕдиницахИзмеренияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура CRM_ЗаполнятьПервичныйИнтересПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастроекПервичногоИнтереса()

	Если НаборКонстант.ФиксироватьПервичныйИнтерес Тогда
	
		Элементы.CRM_ЗаполнятьПервичныйИнтерес.Видимость = Истина;
		
	Иначе
		
		Элементы.CRM_ЗаполнятьПервичныйИнтерес.Видимость = Ложь;
		НаборКонстант.CRM_ЗаполнятьПервичныйИнтерес = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФиксироватьПервичныйИнтересПриИзменении(Элемент)
	ПриИзмененииНастроекПервичногоИнтереса();
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныАнкет(Команда)
	ОткрытьФорму("Справочник.ШаблоныАнкет.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСервисыРассылокНажатие(Элемент)
	ОткрытьФорму("Справочник.CRM_СервисыРассылок.Форма.ФормаСписка");                                 
КонецПроцедуры

&НаКлиенте
Процедура CRM_СпособОтправкиРассылокПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОписаниеСервисовРассылки(Команда)
	
	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("ИнтеграцияUnisender"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗначенияКлассификаторов(Команда)
	ОткрытьФорму("Справочник.CRM_ЗначенияКлассификаторов.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсточникиПолученияЛидов(Команда)
	ОткрытьФорму("Справочник.CRM_ИсточникиПолученияЛидов.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура CRM_СквознаяАналитикаПриИзменении(Элемент)

	КонстантаИмя = ПриИзмененииРеквизитаСквознаяАналитика(Элемент.Имя);

	ОбновитьПовторноИспользуемыеЗначения();

	ОбновитьИнтерфейс = Истина;
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);

	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСквознаяАналитика(ИмяЭлемента)

	Если НаборКонстант.CRM_СквознаяАналитика Тогда
		CRM_СистемаСквознойАналитики.УстановитьПредопределенныеЭлементыИнтерваловВремени();
	КонецЕсли;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьИсточникиПолученияАналитики(Команда)
	ОткрытьФорму("Справочник.CRM_ИсточникиРекламныхКампаний.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура CRM_ИспользоватьРассылкиЭлектронныхПисемПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура CRM_НеСохранятьТекстыПисемРассылокПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаСервере
Процедура ПолучитьДоступностьМероприятий()
	Элементы.ГруппаСправочникиКампаний.Видимость = ПолучитьФункциональнуюОпцию("CRM_ИспользоватьМаркетинговыеМероприятия");
КонецПроцедуры

&НаКлиенте
Процедура CRM_ИспользоватьМаркетинговыеМероприятияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ПолучитьДоступностьМероприятий();
	Оповестить("ОбновитьОбъектыКалендаря");
КонецПроцедуры

&НаКлиенте
Процедура CRM_ИспользоватьТелемаркетингПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Оповестить("ОбновитьОбъектыКалендаря");
КонецПроцедуры

&НаКлиенте
Процедура CRM_ИспользоватьПотенциальныхКлиентовПриИзменении(Элемент)
	Если НЕ НаборКонстант.CRM_ИспользоватьПотенциальныхКлиентов
		И НЕ ВозможноОтключениеПотенциальныхКлиентов() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтключениеПотенциальныхКлиентовПродолжение", ЭтотОбъект, Элемент);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Для отключения потенциальных клиентов,
			| необходимо конвертировать их в клиентов.
                                                |Запустить обработку конвертации?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		ОбновитьУчетныеЗаписи();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтключениеПотенциальныхКлиентовПродолжение(Результат, Элемент) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтключениеПотенциальныхКлиентовЗавершение", ЭтотОбъект, Элемент);
		ОткрытьФорму("Обработка.CRM_КонвертацияПотенциальныхКлиентовВПартнеров.Форма.Форма", , ЭтотОбъект,
			 , , , ОписаниеОповещения,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		НаборКонстант.CRM_ИспользоватьПотенциальныхКлиентов = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключениеПотенциальныхКлиентовЗавершение(Результат, Элемент) Экспорт
	Если Результат = Истина Тогда
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		ОбновитьУчетныеЗаписи();
	Иначе
		НаборКонстант.CRM_ИспользоватьПотенциальныхКлиентов = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВозможноОтключениеПотенциальныхКлиентов()
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	CRM_ПотенциальныеКлиенты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_ПотенциальныеКлиенты КАК CRM_ПотенциальныеКлиенты
	                      |ГДЕ
	                      |	CRM_ПотенциальныеКлиенты.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	                      |	И CRM_ПотенциальныеКлиенты.КонтактноеЛицо = ЗНАЧЕНИЕ(Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка)");

	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ОбновитьУчетныеЗаписи()
	
	Если НаборКонстант.CRM_ИспользоватьПотенциальныхКлиентов Тогда // учетные записи изменяются только при
																// отключении константы
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиСозданияКлиентов = Константы.CRM_НастройкиСозданияКлиентовПриЗвонке.Получить().Получить();
	Если НастройкиСозданияКлиентов <> Неопределено Тогда
		Если НастройкиСозданияКлиентов.Свойство("CRM_ВариантАвтосозданияКлиентов")
			И НастройкиСозданияКлиентов.CRM_ВариантАвтосозданияКлиентов = Перечисления.CRM_ВариантыАвтосозданияКлиентов.СоздаватьПК Тогда
			
			НастройкиСозданияКлиентов.CRM_ВариантАвтосозданияКлиентов =
				Перечисления.CRM_ВариантыАвтосозданияКлиентов.СоздаватьКлиента;
			Константы.CRM_НастройкиСозданияКлиентовПриЗвонке.Установить(Новый ХранилищеЗначения(НастройкиСозданияКлиентов));
			
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRM_ИсточникиПолученияЛидов.Ссылка КАК Ссылка,
		|	CRM_ИсточникиПолученияЛидов.CRM_ВариантАвтосозданияКлиентов КАК CRM_ВариантАвтосозданияКлиентов
		|ИЗ
		|	Справочник.CRM_ИсточникиПолученияЛидов КАК CRM_ИсточникиПолученияЛидов
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	CRM_ПравилаОбработкиОбращений.Ссылка,
		|	CRM_ПравилаОбработкиОбращений.CRM_ВариантАвтосозданияКлиентов
		|ИЗ
		|	Справочник.CRM_ПравилаОбработкиОбращений КАК CRM_ПравилаОбработкиОбращений
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	CRM_УчетныеЗаписиМессенджеров.Ссылка,
		|	CRM_УчетныеЗаписиМессенджеров.CRM_ВариантАвтосозданияКлиентов
		|ИЗ
		|	Справочник.CRM_УчетныеЗаписиМессенджеров КАК CRM_УчетныеЗаписиМессенджеров
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка,
		|	УчетныеЗаписиЭлектроннойПочты.CRM_ВариантАвтосозданияКлиентов
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.CRM_ВариантАвтосозданияКлиентов = Перечисления.CRM_ВариантыАвтосозданияКлиентов.СоздаватьПК Тогда
			СпрОб = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			СпрОб.ОбменДанными.Загрузка = Истина;
			СпрОб.CRM_ВариантАвтосозданияКлиентов = Перечисления.CRM_ВариантыАвтосозданияКлиентов.СоздаватьКлиента;
			Попытка
				СпрОб.Записать();
			Исключение
				ТекстСообщенияШаблон =
					НСтр("ru = 'Не удалось изменить вариант создания клиента в объекте %1. Рекомендуется сделать это вручную.'");
				ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщенияШаблон,
					 ВыборкаДетальныеЗаписи.Ссылка));
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиСквознойАналитики(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоИсточникиПолученияАналитики", Истина);
	ФормаНастройкиСквознойАналитики = ОткрытьФорму("Обработка.CRM_АРМ_РабочееМестоСквознаяАналитика.Форма.ФормаНастройкиСквознойАналитики",
	                                  ПараметрыФормы , ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
