#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакрыватьПослеЗаписи;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Если ЗначениеЗаполнено(Объект.РольИсполнителя) Тогда
		ТекущиеПользователи = CRM_БизнесПроцессыСервер.ПолучитьВозможныхИсполнителейПоРоли(Объект.РольИсполнителя);
	Иначе
		ТекущиеПользователи.ЗагрузитьЗначения(РегистрыСведений.CRM_ОтсутствиеСотрудников.ЗамещаемыеПользователи(ТекущийПользователь));
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() И Не ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = ТекущаяДатаСеанса();
		Объект.Автор = ТекущийПользователь;
		Объект.Исполнитель = ТекущийПользователь;
		Объект.CRM_Личная = Истина;
	КонецЕсли;
	 
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Заголовок = НСтр("ru='Личная задача от ';en='Personal task from'") + Формат(Объект.Дата, "ДФ='d MMMM yyyy'; ДЛФ=DD") + ", " 
		+ Формат(Объект.Дата,
		 "ДФ=HH:mm; ДЛФ=T");
	
	ПризнакЕстьПодчиненныеЗадачи = CRM_БизнесПроцессыИЗадачиВызовСервера.ЕстьПодчиненныеЗадачи(Объект.Ссылка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезДень;
		Объект.СрокИсполнения = CRM_ОбщегоНазначенияКлиентСервер.ОкруглитьДатуДоМинут(Объект.ДатаНачала, 30) + 86400;
	Иначе
		ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Вручную;
	КонецЕсли;
	
	Если Параметры.Свойство("Начало") Тогда
		Объект.ДатаНачала = Параметры.Начало;
	КонецЕсли;
	Если Параметры.Свойство("Окончание") Тогда
		Объект.СрокИсполнения = Параметры.Окончание;
		ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Вручную;
	КонецЕсли;
	Если Параметры.Свойство("Наименование") Тогда
		Объект.Наименование = Параметры.Наименование;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.CRM_ВариантСрока) Или Объект.CRM_ВариантСрока = "Нет" Тогда
		Объект.CRM_ВариантСрока = "КСроку";
	КонецЕсли;
	CRM_ОбщегоНазначенияПовтИсп.ЗаполнитьСписокВыбораВариантовСроков(Элементы.ДатаНачалаПериода);
	
	ЗаполнитьДанныеФормыСервер();
	НачальныйПризнакВыполнения = Объект.Выполнена;
	
	Элементы.РольИсполнителя.Видимость = ЗначениеЗаполнено(Объект.РольИсполнителя)
		 И НЕ ЗначениеЗаполнено(Объект.Исполнитель);
	Элементы.Исполнитель.Видимость     = ЗначениеЗаполнено(Объект.Исполнитель);
	
	Если Не ТолькоПросмотр Тогда
		Если ЗначениеЗаполнено(Объект.РольИсполнителя) Тогда
			ТолькоПросмотр = (ТекущиеПользователи.НайтиПоЗначению(Объект.Автор) = Неопределено 
			И ТекущиеПользователи.НайтиПоЗначению(ТекущийПользователь) = Неопределено);
		Иначе
			ТолькоПросмотр = (ТекущиеПользователи.НайтиПоЗначению(Объект.Автор) = Неопределено 
			И ТекущиеПользователи.НайтиПоЗначению(Объект.Исполнитель) = Неопределено);
		КонецЕсли;
	КонецЕсли;
	Если Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая() Тогда
		Если ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.CRM_Интерес") Тогда
			Если Параметры.Свойство("РежимОткрытияОкна") Тогда
				РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
			КонецЕсли;
			Элементы.ДатаОкончание.АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач	= ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	CRM_ОбщегоНазначенияПовтИсп.ЗаполнитьСписокВыбораВариантовСроков(Элементы.ДатаОкончание);
	
	УстановитьСвойстваЭлементов();
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ТекущийЭлемент = Элементы.РезультатВыполнения;
	КонецЕсли;
	
	CRM_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Отбор = Новый Структура("Задача", Объект.Ссылка);
		Выборка = РегистрыСведений.CRM_ВажностьСрочностьЗадач.Выбрать(Отбор);
		Если Выборка.Следующий() Тогда
			Важная = Выборка.Важная;
			ВажнаяИсходноеЗначение = Важная;
			Срочная = Выборка.Срочная;
			СрочнаяИсходноеЗначение = Срочная;
		КонецЕсли;
	КонецЕсли;
	
	РазрешенаРучнаяНастройкаВажностиИСрочности = 
		РольДоступна("ПолныеПрава") Или РольДоступна("CRM_РазрешитьРучнуюНастройкуВажностиИСрочностиЗадач");
	Элементы.Важная.Доступность = РазрешенаРучнаяНастройкаВажностиИСрочности;
	Элементы.Срочная.Доступность = РазрешенаРучнаяНастройкаВажностиИСрочности;
	
	CRM_РаботаСЯзыковымиМоделямиСервер.ПриСозданииНаСервере(ЭтотОбъект, "ГруппаАссистент");

	CRM_ОбщегоНазначенияСервер.ЗакончитьЗамерВремениСозданияФормы(ЭтотОбъект, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// CRM_УправлениеДоступом
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступомУровниДоступа");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец CRM_УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	CRM_ОбщегоНазначенияКлиент.НачатьЗамерВремениОткрытияФормы(ЭтотОбъект);
	CRM_ТрудозатратыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	УстановитьВидимость();
	
	CRM_РаботаСЯзыковымиМоделямиКлиент.ПриОткрытии(ЭтотОбъект);

	CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.БизнесПроцессыИЗадачи.ЛичнаяЗадача.ДлительностьСценариев.ВремяРаботыВФорме");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	CRM_СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверитьНаКорректность() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Объект.CRM_НаВесьДень = (Объект.CRM_ВариантСрока = "КСроку");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПризнакНовойЗадачи = ТекущийОбъект.Ссылка.Пустая();
	
	Если НЕ ПризнакНовойЗадачи Тогда
		Если НЕ ПроверитьЗаполнение() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		Если НЕ ТекущийОбъект.ДатаНачала = ТекущийОбъект.Ссылка.ДатаНачала 
			Или Не ТекущийОбъект.CRM_ПлановаяДатаПринятияКИсполнению = 
				ТекущийОбъект.Ссылка.CRM_ПлановаяДатаПринятияКИсполнению Тогда
			ПризнакИзмененаДата = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Если Важная <> ВажнаяИсходноеЗначение
			Или Срочная <> СрочнаяИсходноеЗначение Тогда
			CRM_БизнесПроцессыИЗадачиСервер.ЗаписатьВажностьСрочность(ТекущийОбъект.Ссылка, Важная, Срочная);
		Иначе
			CRM_БизнесПроцессыИЗадачиСервер.ЗаписатьПризнакНеобходимостиПересчетаВажностиСрочностиЗадачи(ТекущийОбъект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстановитьСвойстваЭлементов();
	
	Оповестить("СохраненаЛичнаяЗадача", Объект.Предмет);
	
	Если ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		Оповестить("ОбновленыДанныеСобытия", Новый Структура("СсылкаНаОбъект, ОбновлятьКалендарь",
			 Неопределено, Параметры.ОбновлятьКалендарь),
			 ЭтотОбъект);
	КонецЕсли;
	
	Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь), ЭтотОбъект);
	Оповестить("ОбновитьПланировщик");
	Оповестить("ОбновитьАРМ");
	Оповестить("ЛентаСобытий_Обновить");
	
	Если ЗакрыватьПослеЗаписи Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ЗакрыватьПослеЗаписи = Истина;
	CRM_ТрудозатратыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	CRM_ЦентрМониторингаКлиент.ЗавершитьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.БизнесПроцессыИЗадачи.ЛичнаяЗадача.ДлительностьСценариев.ВремяРаботыВФорме");
	
	CRM_ТрудозатратыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВремяНачалоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Элемент", Элемент);
	Дополнительно.Вставить("Данные", "ВремяНачало");
	Дополнительно.Вставить("Обработчик", "ДатаВремяНачалаПриИзменении");
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОповещенияВыбранногоВремени", ЭтотОбъект, Дополнительно);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяНачало, Элемент, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Элемент", Элемент);
	Дополнительно.Вставить("Данные", "ВремяОкончание");
	Дополнительно.Вставить("Обработчик", "ДатаВремяОкончанияПриИзменении");
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОповещенияВыбранногоВремени", ЭтотОбъект, Дополнительно);
	Если НачалоДня(ДатаНачало) = НачалоДня(ДатаОкончание) Тогда
		CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяОкончание, Элемент,
			 ВремяНачало, Истина,
			 ОписаниеОповещения);
	Иначе
		CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяОкончание, Элемент, , , ОписаниеОповещения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаВремяНачалаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ДатаОкончание) Тогда
		Если ДатаНачало > ДатаОкончание Тогда
			ДатаОкончание = ДатаНачало;
			ВремяОкончание = ВремяНачало;
		ИначеЕсли (ДатаОкончание = ДатаНачало) И (ВремяОкончание < ВремяНачало) Тогда
			ВремяОкончание = ВремяНачало;
		КонецЕсли;
	КонецЕсли;
	
	СкорректироватьДатыЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ДатаВремяОкончанияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ДатаОкончание) Тогда
		Если ДатаОкончание < ДатаНачало Тогда
			ДатаНачало = ДатаОкончание;
			ВремяНачало = ВремяОкончание;
		ИначеЕсли (ДатаОкончание = ДатаНачало) И (ВремяОкончание < ВремяНачало) Тогда
			ВремяОкончание = ВремяНачало;
		КонецЕсли;
	КонецЕсли;
	
	СкорректироватьДатыЗадачи();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончаниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.CRM_ВариантыУстановкиДаты") Тогда
		СтандартнаяОбработка = Ложь;
		
		Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.CRM_ВариантыУстановкиДаты.Вручную") Тогда
			ОписаниеОповещения	= Новый ОписаниеОповещения("ДатаОкончаниеОбработкаВыбораЗавершение", ЭтотОбъект);
			ОткрытьФорму("ОбщаяФорма.CRM_ФормаРучногоПереносаВремени", , ЭтотОбъект, КлючУникальности, , , ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ПолнаяДатаОкончания = ДатаОкончание + (ВремяОкончание - Дата(1, 1, 1));
			
			ПолнаяДатаРезультат = CRM_ОбщегоНазначенияСервер.ДатаПоВариантуИнтервала(
				CRM_ОбщегоНазначенияСервер.БазоваяДатаПоВариантуИнтервала(ПолнаяДатаОкончания, ВыбранноеЗначение),
				ВыбранноеЗначение);
				
			ДатаОкончание = ПолнаяДатаРезультат;
			ВремяОкончание = ПолнаяДатаРезультат;
			
			СкорректироватьДатыЗадачи();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончаниеОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДатаОкончание	= Результат;
		ВремяОкончание	= Результат;
		
		СкорректироватьДатыЗадачи();
	КонецЕсли;
	
КонецПроцедуры // ДатаОкончаниеОбработкаВыбораЗавершение()

&НаКлиенте
Процедура РезультатПриИзменении(Элемент)
	УстановитьВидимость();	
КонецПроцедуры

&НаКлиенте
Процедура РезультатИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Элементы.Выполнить.Видимость = ЗначениеЗаполнено(Текст);
	Элементы.Выполнить.КнопкаПоУмолчанию = Элементы.Выполнить.Видимость;
	Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = НЕ Элементы.Выполнить.КнопкаПоУмолчанию;
КонецПроцедуры

&НаКлиенте
Процедура CRM_ВариантСрокаПриИзменении(Элемент)
	УстановитьВидимость();
	СкорректироватьДатыЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.CRM_ПлановаяДатаПринятияКИсполнению) Тогда
		ПараметрыОткрытия.Вставить("ДатаПоУмолчанию", Объект.CRM_ПлановаяДатаПринятияКИсполнению);
	КонецЕсли;
	
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("РежимВыбора_ОбъектАдресат",			Объект.Ссылка);
	ПараметрыОткрытия.Вставить("РежимВыбора_ДатаИВремяНачала",		Объект.CRM_ПлановаяДатаПринятияКИсполнению);
	ПараметрыОткрытия.Вставить("РежимВыбора_ДатаИВремяЗавершения",	Объект.СрокИсполнения);
	ПараметрыОткрытия.Вставить("РежимВыбора_ВесьДень",				Объект.CRM_НаВесьДень);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе",				Ложь);
	
	ОткрытьФорму(
		"Обработка.CRM_КалендарьМенеджера.Форма",
		ПараметрыОткрытия,
		Элемент,
		Объект.Ссылка, , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("ЭтоРезультатРаботыСКалендарем") Тогда
			СтандартнаяОбработка	= Ложь;
			
			ДатаИВремяПлановаяДатаПринятияКИсполнению = 
				CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(ВыбранноеЗначение.Начало);
			ДатаИВремяСрокИсполнения = 
				CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(ВыбранноеЗначение.Конец);
			
			ДатаНачало		= ДатаИВремяПлановаяДатаПринятияКИсполнению.Дата;
			ВремяНачало		= ДатаИВремяПлановаяДатаПринятияКИсполнению.Время;
			
			ДатаОкончание	= ДатаИВремяСрокИсполнения.Дата;
			ВремяОкончание	= ДатаИВремяСрокИсполнения.Время;
			
			Объект.CRM_ПлановаяДатаПринятияКИсполнению = ВыбранноеЗначение.Начало;
			Объект.СрокИсполнения = ВыбранноеЗначение.Конец;
			
			ДатаНачалаПериодаПриИзменении(Элементы.ДатаНачалаПериода);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.CRM_ВариантыУстановкиДаты") Тогда
		// Осуществляется перенос обеих дат на указанный интервал
		СтандартнаяОбработка	= Ложь;
		
		ДлительностьИнтервала	= Объект.СрокИсполнения - Объект.CRM_ПлановаяДатаПринятияКИсполнению;
		Если ДлительностьИнтервала < 0 Тогда
			ДлительностьИнтервала = 0;
		КонецЕсли;
	
		Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.CRM_ВариантыУстановкиДаты.Вручную") Тогда
			ОписаниеОповещения	= Новый ОписаниеОповещения(
				"ДатаНачалаПериодаОбработкаВыбораЗавершение", ЭтотОбъект, ДлительностьИнтервала);
			ОткрытьФорму("ОбщаяФорма.CRM_ФормаРучногоПереносаВремени", , ЭтотОбъект, КлючУникальности, , , ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			БазоваяПлановаяДата = 
				CRM_ОбщегоНазначенияСервер.БазоваяДатаПоВариантуИнтервала(Объект.CRM_ПлановаяДатаПринятияКИсполнению, 
				ВыбранноеЗначение);
			Объект.CRM_ПлановаяДатаПринятияКИсполнению = 
				CRM_ОбщегоНазначенияСервер.ДатаПоВариантуИнтервала(БазоваяПлановаяДата, ВыбранноеЗначение);
			Если ДлительностьИнтервала <> Неопределено Тогда
				Объект.СрокИсполнения	= Объект.CRM_ПлановаяДатаПринятияКИсполнению + ДлительностьИнтервала;
			КонецЕсли;
			
			СкорректироватьДатыЗадачиНаПериод();
			
			Модифицированность = Истина;
		КонецЕсли;
		
		CRM_ОповещенияКлиент.ПересчитатьДатыОповещений(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.CRM_ПлановаяДатаПринятияКИсполнению = Результат;
		Объект.СрокИсполнения = Объект.CRM_ПлановаяДатаПринятияКИсполнению + ДополнительныеПараметры;
		
		СкорректироватьДатыЗадачиНаПериод();
		
		Модифицированность = Истина;
		
		CRM_ОповещенияКлиент.ПересчитатьДатыОповещений(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	ДлительностьИнтервала = Объект.СрокИсполнения - Объект.CRM_ПлановаяДатаПринятияКИсполнению;
	ПересчитатьДатыЗадачиПоДлительности(ДлительностьИнтервала);
	CRM_ОповещенияКлиент.ПересчитатьДатыОповещений(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПериодаПриИзменении(Элемент)
	
	ДлительностьИнтервала = Объект.СрокИсполнения - Объект.CRM_ПлановаяДатаПринятияКИсполнению;
	ПересчитатьДатыЗадачиПоДлительности(ДлительностьИнтервала);
	CRM_ОповещенияКлиент.ПересчитатьДатыОповещений(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПериодаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВремяНачалаПериодаНачалоВыбораЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяНачало, Элемент, , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПериодаНачалоВыбораЗавершение(ВыбранноеВремя, СтандартнаяОбработка) Экспорт
	Если ВыбранноеВремя <> Неопределено Тогда
		ВремяНачало = ВыбранноеВремя.Значение;
		ВремяНачалаПериодаПриИзменении(Элементы.ВремяНачалаПериода);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПериодаПриИзменении(Элемент)
	
	СтароеВремяОкончания 	= Дата('00010101') + (Объект.СрокИсполнения - НачалоДня(Объект.СрокИсполнения));
	Объект.СрокИсполнения 	= 
		CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаОкончание, ВремяОкончание);
	Если (ДатаНачало = ДатаОкончание) И (ВремяНачало > ВремяОкончание) Тогда
		ИнтервалВремени	= (СтароеВремяОкончания - ВремяНачало);
		ВремяНачало		= ВремяОкончание - ИнтервалВремени;
		Если ВремяНачало > ВремяОкончание Тогда
			ВремяНачало	= НачалоДня(ВремяОкончание);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПериодаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВремяОкончанияПериодаЗавершение", ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиентСервер.ВыбратьВремяИзСписка(ЭтотОбъект, ВремяОкончание, Элемент, , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПериодаЗавершение(ВыбранноеВремя, СтандартнаяОбработка) Экспорт
	Если ВыбранноеВремя <> Неопределено Тогда
		ВремяОкончание = ВыбранноеВремя.Значение;
		ВремяОкончанияПериодаПриИзменении(Элементы.ВремяОкончанияПериода);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	СтараяДатаЗавершение	= Объект.СрокИсполнения; 
	ДлительностьИнтервала	= Объект.СрокИсполнения - Объект.CRM_ПлановаяДатаПринятияКИсполнению;
	Объект.СрокИсполнения	= CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаОкончание, 
		ВремяОкончание);
	
	Если НачалоДня(ДатаНачало) > НачалоДня(ДатаОкончание) Тогда
		Если НачалоДня(СтараяДатаЗавершение) = ДатаНачало Тогда
			ДатаНачало = ДатаОкончание;
		Иначе	
			ДатаНачало = НачалоДня(ДатаОкончание - (СтараяДатаЗавершение - Объект.CRM_ПлановаяДатаПринятияКИсполнению));
		КонецЕсли;
		Объект.CRM_ПлановаяДатаПринятияКИсполнению = 
			CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаНачало, ВремяНачало);
	КонецЕсли;
	
	Если НачалоДня(ДатаНачало) = НачалоДня(ДатаОкончание) И ВремяНачало > ВремяОкончание Тогда
		ПересчитатьДатыЗадачиПоДлительности(ДлительностьИнтервала);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ЗакрыватьПослеЗаписи = Истина;
	Если ВыполнитьЗадачу Тогда
		Записать(Новый Структура("ВыполнитьЗадачу", Истина));
	Иначе
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Если Не Объект.Выполнена Тогда
		ВыполнитьЗадачу = Истина;
		БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
		
		ВыполнитьЗадачу = Ложь;
	Иначе
		Объект.Выполнена = Ложь;
		ЗакрыватьПослеЗаписи = Истина;
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачу(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьЗадачуНачало", ЭтотОбъект);
	ПроверкаВопросЗаписатьДанные(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачуНачало(Продолжать, ДополнительныеПараметры) Экспорт
	
	Если Продолжать Тогда
		Если Не Объект.Выполнена Тогда
			
			ЗавершитьЗадачуЗавершение(Дата(1, 1, 1), ДополнительныеПараметры);
			
		Иначе
			Объект.Выполнена = Ложь;
			Если Записать() Тогда
				УстановитьСвойстваЭлементов();
				Оповестить("СохраненаЛичнаяЗадача", Объект.Предмет);
				Закрыть();
			КонецЕсли;
			Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь), ЭтотОбъект);
			Оповестить("ОбновитьАРМ");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачуЗавершение(ДатаПереноса, ДополнительныеПараметы)
	Если ДатаПереноса = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершитьЗадачуССобытиями(ДополнительныеПараметы.СобытияЗадачи,
		 ДополнительныеПараметы.ВариантЗавершенияСобытий,
		 ДатаПереноса) Тогда
		Если ДополнительныеПараметы.СобытияЗадачи.Количество() > 0 Тогда
			// Нужно чтобы обновился календарь.
			Оповестить("ОбновленыДанныеСобытия", Новый Структура("СсылкаНаОбъект, ОбновлятьКалендарь",
				 Неопределено, Параметры.ОбновлятьКалендарь),
				 ЭтотОбъект);
		КонецЕсли;
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("СохраненаЛичнаяЗадача", Объект.Предмет);
		
		Если (ЗначениеЗаполнено(Объект.Предмет)
			 И ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"))
			 И Объект.Выполнена Тогда
			
			УчетнаяЗапись = CRM_ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Предмет, "УчетнаяЗапись");
			ФормаПисьма = ПолучитьФорму("Документ.ЭлектронноеПисьмоВходящее.Форма.CRM_ФормаДокумента",
				 Новый Структура("Ключ",
				 Объект.Предмет)); 
			
			Если НЕ (ФормаПисьма = Неопределено) Тогда
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьЗадачуЗавершениеПереносВПапку", ЭтотОбъект, ФормаПисьма);
				CRM_УправлениеЭлектроннойПочтойКлиент.ВопросПеренестиПисьмоВПапкуОбработанные(УчетнаяЗапись,
					 ФормаПисьма.Папка,
					 ОписаниеОповещения);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Закрыть();
	КонецЕсли;
	
	Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь), ЭтотОбъект);
	
	Оповестить("ОбновитьАРМ");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачуЗавершениеПереносВПапку(ПапкаОтработанные, ФормаПисьма) Экспорт
	
	Если НЕ (ПапкаОтработанные = ПредопределенноеЗначение("Справочник.ПапкиЭлектронныхПисем.ПустаяСсылка")) Тогда
		CRM_ВзаимодействияВызовСервера.УстановитьПапкуЭлектронногоПисьма(Объект.Предмет, ПапкаОтработанные);
		Оповестить("CRM_УстановленФлагОбработано", , ФормаПисьма);
	КонецЕсли;
	
	Закрыть();
	
	Оповестить("ОбновитьНапоминания", Новый Структура("ОткрыватьАктивизироватьФормуНапоминаний", Ложь), ЭтотОбъект);
	Оповестить("ОбновитьАРМ");
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	Если ПроверитьЗаполнение() И ПроверитьНаКорректность() Тогда
		Если Модифицированность Тогда
			Записать();
		КонецЕсли;	
		ОткрытьФорму("Задача.ЗадачаИсполнителя.ФормаОбъекта", Новый Структура("Ключ,
			| ИзСпискаАктивностей", Объект.Ссылка, Ложь),
			 ВладелецФормы);
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	ТекстВопроса = НСтр("ru='Задача будет удалена. Продолжить?';en='Task will be deleted. Continue?'");
	ОповещениеЗавершения = Новый ОписаниеОповещения("УдалитьЗавершение", ЭтотОбъект, Новый Структура);
	ПоказатьВопрос(ОповещениеЗавершения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Модифицированность = Ложь;
		Закрыть();
	Иначе
		Объект.ПометкаУдаления = Истина;
		Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеФормыСервер()
	
	Если Объект.CRM_ВариантСрока = "КСроку" Тогда
		ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.ДатаНачала);
	Иначе
		ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.CRM_ПлановаяДатаПринятияКИсполнению);
	КонецЕсли;
	ДатаНачало	= ДатаВремя.Дата;
	ВремяНачало	= ДатаВремя.Время;
	
	ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.СрокИсполнения);
	ДатаОкончание	= ДатаВремя.Дата;
	ВремяОкончание	= ДатаВремя.Время;

КонецПроцедуры

&НаКлиенте
Функция ПроверитьНаКорректность()
	Если Объект.CRM_ВариантСрока = "КСроку" И Не ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата начала должна быть заполнена!';
			|en='The date started should be fill!'"), ,
			 "ДатаНачало");
		Возврат Ложь;
	КонецЕсли;
	Если Объект.CRM_ВариантСрока = "НаПериод" И Не ЗначениеЗаполнено(Объект.CRM_ПлановаяДатаПринятияКИсполнению) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите плановую дату принятия к исполнению.'"),,,
			"Объект.CRM_ПлановаяДатаПринятияКИсполнению");
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.CRM_Интерес") И Не ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен срок!';
			|en='The deadline is not filled!'"), ,
			 "ДатаОкончание");
		Возврат Ложь;
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.СрокИсполнения) И (Объект.СрокИсполнения < Объект.ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Срок должен быть больше даты начала!';
			|en='Period should be more date started!'"), ,
			 "ДатаОкончание");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура СкорректироватьДатыЗадачи()
	
	Если Объект.CRM_ВариантСрока = "КСроку" Тогда
		Объект.CRM_ПлановаяДатаПринятияКИсполнению = Дата('00010101');
	Иначе
		Объект.CRM_ПлановаяДатаПринятияКИсполнению = 
			CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаНачало, ВремяНачало);
	КонецЕсли;
	Объект.СрокИсполнения = 
		CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаОкончание, ВремяОкончание);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементов()
	Если Объект.Выполнена Тогда
		Элементы.Выполнить.Заголовок = НСтр("ru='Отменить выполнение';en='Cancelled execution'");
	Иначе
		Элементы.Выполнить.Заголовок = НСтр("ru='Выполнить';en='Perform'");
	КонецЕсли;
	
	Элементы.ГруппаПериодДаты.ТолькоПросмотр = ПризнакЕстьПодчиненныеЗадачи;
	Элементы.ГруппаПериодВремя.ТолькоПросмотр = ПризнакЕстьПодчиненныеЗадачи;
		
КонецПроцедуры

&НаСервере
Функция ЗавершитьЗадачуССобытиями(СобытияЗадачи, ВариантЗавершенияСобытий, ДатаПереноса)
	СтруктураЗаписи = Новый Структура("ВыполнитьЗадачу", Истина);
	Записать(СтруктураЗаписи);
	
	РезультатВыполнения = Объект.Выполнена;
	
	Если РезультатВыполнения И СобытияЗадачи.Количество() > 0 И ВариантЗавершенияСобытий <> Неопределено Тогда
		РезультатВыполнения = CRM_БизнесПроцессыИЗадачиВызовСервера.ПеренестиСобытияЗадачи(СобытияЗадачи,
			 Объект.ДатаНачала, ВариантЗавершенияСобытий,
			 ДатаПереноса);
	КонецЕсли;
	
	УстановитьСвойстваЭлементов();
	
	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ПроверкаВопросЗаписатьДанные(ОписаниеОповещенияОЗавершении)
	Если Объект.Ссылка.Пустая() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаВопросЗаписатьДанныеЗавершение",
			 ЭтотОбъект,
			 ОписаниеОповещенияОЗавершении);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Данные еще не записаны."
"Добавление события возможно только после записи данных."
"Данные будут записаны.';en='Data has not been written yet."
"Adding events is possible only after writing data."
"Data will be written.'"), РежимДиалогаВопрос.ОКОтмена);
		//
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаВопросЗаписатьДанныеЗавершение(Ответ, ОписаниеОповещенияОЗавершении) Экспорт
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Записать();
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Истина);
		Иначе
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Ложь);
		КонецЕсли;
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура обработки выбора времени из списка.
//
Процедура ОбработкаОповещенияВыбранногоВремени(ВыбранноеВремя, Дополнительно) Экспорт
	Если ВыбранноеВремя <> Неопределено Тогда
		ЭтотОбъект[Дополнительно.Данные] = ВыбранноеВремя.Значение;
		Если Дополнительно.Обработчик = "ДатаВремяОкончанияПриИзменении" Тогда
			ДатаВремяОкончанияПриИзменении(Дополнительно.Элемент);
		КонецЕсли;	
		Если Дополнительно.Обработчик = "ДатаВремяНачалаПриИзменении" Тогда
			ДатаВремяНачалаПриИзменении(Дополнительно.Элемент);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСрокОповещенияПоВарианту(ВариантСрока)

	ТекущаяДатадляСрока = ТекущаяДатаСеанса();
	
	Если ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Сейчас Тогда
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Через15Минут Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 900;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезЧас Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 3600;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Через4Часа Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 14400;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.Через8Часов Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 28800;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезДень Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 86400;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезТриДня Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 259200;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезНеделю Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 604800;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезДвеНедели Тогда	
		
		Объект.СрокИсполнения	= ТекущаяДатадляСрока + 1209600;
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезМесяц Тогда	
		
		Объект.СрокИсполнения	= ДобавитьМесяц(ТекущаяДатадляСрока, 1);
		
	ИначеЕсли ВариантСрока = Перечисления.CRM_ВариантыУстановкиДаты.ЧерезТриМесяца Тогда	
		
		Объект.СрокИсполнения	= ДобавитьМесяц(ТекущаяДатадляСрока, 3);
		
	Иначе // Если Объект.ВариантСрока=Перечисления.CRM_ВариантыУстановкиДаты.Вручную Тогда	
		
		Если Объект.СрокИсполнения = Дата(1, 1, 1) Тогда
		
			Объект.СрокИсполнения	= ТекущаяДатадляСрока;	
		
		КонецЕсли; 
		
	КонецЕсли;	
	
	ДатаВремя = CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.СрокИсполнения);
	ДатаОкончание	= ДатаВремя.Дата;
	ВремяОкончание	= ДатаВремя.Время;
	
КонецПроцедуры // ПолучитьСрокОповещенияПоВарианту()

// не используется
&НаКлиенте
Процедура ВариантВыбораПериодаПриИзменении(Элемент)
	ПолучитьСрокОповещенияПоВарианту(ВариантСрока);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.Выполнить.Видимость = ЗначениеЗаполнено(Объект.РезультатВыполнения);
	Элементы.Выполнить.КнопкаПоУмолчанию = Элементы.Выполнить.Видимость;
	Элементы.ЗаписатьИЗакрыть.КнопкаПоУмолчанию = НЕ Элементы.Выполнить.КнопкаПоУмолчанию;
	
	ВариантКСроку = (Объект.CRM_ВариантСрока = "КСроку");
	Элементы.ГруппаКСроку.Видимость 	= ВариантКСроку;
	Элементы.ГруппаНаПериод.Видимость 	= (Не ВариантКСроку);
	
КонецПроцедуры

// +CRM
#Область УчетРабочегоВремени

&НаКлиенте
Процедура Подключаемый_Команда_CRM_УказатьТрудозатраты(Команда) Экспорт // АПК:78 процедура вызывается из общего модуля CRM_ТрудозатратыКлиент.
	
	Подключаемый_Команда_CRM_УказатьТрудозатратыНаСервере();
	CRM_ТрудозатратыКлиент.УказатьТрудозатраты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатраты(Команда)
	
	Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатратыНаСервере(Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_ВыполнитьДействиеНадТаблицейЗаписейТрудозатратыНаСервере(ИмяКоманды)
	
	CRM_ТрудозатратыСервер.ВыполнитьДействиеНадТаблицейЗаписейТрудозатраты(ЭтотОбъект, ИмяКоманды);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_Команда_CRM_УказатьТрудозатратыНаСервере()
	
	CRM_ТрудозатратыСервер.УказатьТрудозатратыНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиПанельТрудозатрат()
	
	CRM_ТрудозатратыКлиент.ВывестиПанельТрудозатрат(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьПанельТрудозатрат()
	
	CRM_ТрудозатратыКлиент.ЗакрытьПанельТрудозатрат(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_РабочееВремяПользователейПриИзменении(Элемент)
	
	Отказ = Ложь;
	CRM_ТрудозатратыКлиент.РабочееВремяПользователейПриИзменении(ЭтотОбъект, Элемент, Отказ);
	
	Если НЕ Отказ Тогда
		Подключаемый_CRM_РабочееВремяПользователейПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_РабочееВремяПользователейПриИзмененииНаСервере()
	
	CRM_ТрудозатратыСервер.ТаблицаЗаписейПриИзмененииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавления(Элемент, Отказ,
	 Копирование, Родитель, Группа,
	 Параметр)
	
	Отказ = Истина;
	Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_CRM_РабочееВремяПользователейПередНачаломДобавленияНаСервере()
	
	CRM_ТрудозатратыСервер.ТаблицаЗаписейПередНачаломДобавленияНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
// -CRM

&НаКлиенте
Процедура ПересчитатьДатыЗадачиПоДлительности(ДлительностьИнтервала)
	
	НоваяПлановаяДатаПринятия	= CRM_ОбщегоНазначенияКлиентСервер.СформироватьДатуИзДатыИВремени(ДатаНачало, ВремяНачало);
	НовыйПлановыйСрокИсполнения = НачалоМинуты(НоваяПлановаяДатаПринятия + ДлительностьИнтервала);
	
	СрокИсполненияДатаИВремя =
		CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(НовыйПлановыйСрокИсполнения);
	
	ВремяОкончание	= СрокИсполненияДатаИВремя.Время;
	ДатаОкончание	= СрокИсполненияДатаИВремя.Дата;
	
	Объект.CRM_ПлановаяДатаПринятияКИсполнению	= НоваяПлановаяДатаПринятия;
	Объект.СрокИсполнения						= НовыйПлановыйСрокИсполнения;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьДатыЗадачиНаПериод()
	
	ДатаИВремя			= CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.CRM_ПлановаяДатаПринятияКИсполнению);
	ДатаНачало			= ДатаИВремя.Дата;
	ВремяНачало			= ДатаИВремя.Время;
	
	ДатаИВремя			= CRM_ОбщегоНазначенияКлиентСервер.РазделитьДатаНаДатуИВремя(Объект.СрокИсполнения);
	ДатаОкончание	= ДатаИВремя.Дата;
	ВремяОкончание	= ДатаИВремя.Время;
	
КонецПроцедуры

#Область ЯзыковыеМодели

&НаКлиенте
Процедура Подключаемый_ДоступностьМенюАссистент()
	
	CRM_РаботаСЯзыковымиМоделямиКлиент.ДоступностьМенюАссистент(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	CRM_СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
КонецПроцедуры

#КонецОбласти // ЯзыковыеМодели

#КонецОбласти

#Область Инициализация

НеПроверятьОповещения = Ложь;
ЗакрыватьПослеЗаписи = Ложь;

#КонецОбласти
