
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Создать взаимодействие по выбранному контакту.
Процедура СоздатьВзаимодействие(ИмяФормы)
	
	Основание = Новый Структура();
	Основание.Вставить("Предмет", Объект.Ссылка);
	Основание.Вставить("Контакт",
	?(ЗначениеЗаполнено(Элементы.ПартнерыИКонтактныеЛица.ТекущиеДанные.КонтактноеЛицо),
	Элементы.ПартнерыИКонтактныеЛица.ТекущиеДанные.КонтактноеЛицо,
	Элементы.ПартнерыИКонтактныеЛица.ТекущиеДанные.Партнер));
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", Основание), , , , , ,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВалютыДокумента()
	
	Элементы.Валюта.Подсказка = НСтр("ru='Курс: ';en='Rate: '") + Формат(Объект.CRM_Курс, "ЧДЦ=4; ЧН=0,0000") + НСтр("ru=',
		| крат.: '") 
		+ Объект.CRM_Кратность;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКурсИКратностьВалюты(Валюта, ДатаКурса)
	
	Возврат РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьВидимостьИДоступностьФормы(Форма)
	
	Форма.Элементы.ДатаАктуальности.Видимость = ?(ЗначениеЗаполнено(Форма.Объект.CRM_ПериодАктуальности), Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодДатыАктуальности()
	
	Если ЗначениеЗаполнено(Объект.CRM_ПериодАктуальности) Тогда
		Объект.CRM_ДатаАктуальности = Объект.ДатаНачала + (Объект.CRM_ПериодАктуальности * 86400);
	Иначе
		Объект.CRM_ДатаАктуальности = Объект.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеДатыАктуальности()
	
	Если ЗначениеЗаполнено(Объект.CRM_ДатаАктуальности) И (Объект.CRM_ДатаАктуальности > Объект.ДатаОкончания) Тогда
		
		пЗаголовок = НСтр("ru='дней ';en='days '") + НСтр("ru='( до '") + Формат(Объект.CRM_ДатаАктуальности, "ДЛФ=DD") + ")";
		Элементы.ДатаАктуальности.Заголовок = пЗаголовок;
		Элементы.ДатаАктуальности.Видимость = Истина;
		
	Иначе
		
		Элементы.ДатаАктуальности.Видимость = Истина;
		Элементы.ДатаАктуальности.Заголовок = НСтр("ru='дней ';en='days '");
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборУчастников()
	МассивУчастников = Новый Массив();
	Для Каждого СтрокаТаблицы Из Объект.CRM_СвоиУчастники Цикл
		Если	ЗначениеЗаполнено(СтрокаТаблицы.Участник)
			И	ТипЗнч(СтрокаТаблицы.Участник) = Тип("СправочникСсылка.Пользователи")
			И	ЗначениеЗаполнено(СтрокаТаблицы.ДатаНачала)
			И	ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания) Тогда
			//
			МассивУчастников.Добавить(Новый Структура("Пользователь,НачалоПериода,ОкончаниеПериода",
				 СтрокаТаблицы.Участник, СтрокаТаблицы.ДатаНачала,
				 СтрокаТаблицы.ДатаОкончания));
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыСтруктура = Новый Структура();
	ПараметрыСтруктура.Вставить("Пользователи",		МассивУчастников);
	ПараметрыСтруктура.Вставить("ПериодНачало",		Объект.ДатаНачала);
	ПараметрыСтруктура.Вставить("ПериодОкончание",	Объект.ДатаОкончания);
	ПараметрыСтруктура.Вставить("ВыбиратьПериоды");
	ПараметрыСтруктура.Вставить("ПоказыватьТаблицуПериодов");
	ПараметрыСтруктура.Вставить("ИнтервалШкалыВремени", 60);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодборУчастниковЗавершение", ЭтотОбъект, МассивУчастников);
	ОткрытьФорму("ОбщаяФорма.CRM_ПодборПользователейПоКалендарю", ПараметрыСтруктура, ЭтотОбъект, , , ,
		 ОписаниеОповещения,
		 РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ПодборУчастниковЗавершение(РезультатОткрытия, МассивУчастников) Экспорт
	Если ТипЗнч(РезультатОткрытия) = Тип("Массив") Тогда
		МинимальнаяВыбраннаяДата = Неопределено;
		МаксимальнаяВыбраннаяДата = Неопределено;
		МассивВыбранныеПользователи = Новый Массив();
		Для Каждого ДобавляемыйПользователь Из РезультатОткрытия Цикл
			МассивВыбранныеПользователи.Добавить(ДобавляемыйПользователь.Пользователь);
			
			СтруктураПоиска = Новый Структура("Участник,ДатаНачала,ДатаОкончания",
				 ДобавляемыйПользователь.Пользователь, ДобавляемыйПользователь.НачалоПериода,
				 ДобавляемыйПользователь.ОкончаниеПериода);
			Если Объект.CRM_СвоиУчастники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
				НоваяСтрока = Объект.CRM_СвоиУчастники.Добавить();
				НоваяСтрока.Участник		= ДобавляемыйПользователь.Пользователь;
				НоваяСтрока.ДатаНачала		= ДобавляемыйПользователь.НачалоПериода;
				НоваяСтрока.ДатаОкончания	= ДобавляемыйПользователь.ОкончаниеПериода;
			КонецЕсли;
			Если МинимальнаяВыбраннаяДата = Неопределено
				 Или МинимальнаяВыбраннаяДата > ДобавляемыйПользователь.НачалоПериода Тогда
				МинимальнаяВыбраннаяДата = ДобавляемыйПользователь.НачалоПериода;
			КонецЕсли;
			Если МаксимальнаяВыбраннаяДата = Неопределено
				 Или МаксимальнаяВыбраннаяДата < ДобавляемыйПользователь.ОкончаниеПериода Тогда
				МаксимальнаяВыбраннаяДата = ДобавляемыйПользователь.ОкончаниеПериода;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого УдаляемыйПользователь Из МассивУчастников Цикл
			Если МассивВыбранныеПользователи.Найти(УдаляемыйПользователь.Пользователь) = Неопределено Тогда
				НайденныеСтроки = Объект.CRM_СвоиУчастники.НайтиСтроки(Новый Структура("Участник",
					 УдаляемыйПользователь.Пользователь));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Объект.CRM_СвоиУчастники.Удалить(НайденнаяСтрока);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(МинимальнаяВыбраннаяДата) И ЗначениеЗаполнено(МаксимальнаяВыбраннаяДата) Тогда
			Объект.ДатаНачала = МинимальнаяВыбраннаяДата;
			Объект.ДатаОкончания = МаксимальнаяВыбраннаяДата;
			
			ДатаНачалаПриИзменении(Неопределено);
			ДатаОкончанияПриИзменении(Неопределено);
		КонецЕсли;
		
		Модифицированность = Истина;
		ВычислитьОбщееЧислоУчастников();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПоложениеТумблераСтатусДокумента()
	
	Если Объект.Завершено Тогда
		СтатусДокумента = "Завершено";
	Иначе		
		СтатусДокумента = "ВРаботе";
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура НаписатьПисьмоВыполнить()
	
	СоздатьВзаимодействие("Документ.ЭлектронноеПисьмоИсходящее.ФормаОбъекта");
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьОбщееЧислоУчастников()
	КоличествоУчастников = Объект.ПартнерыИКонтактныеЛица.Количество() + Объект.CRM_СвоиУчастники.Количество();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ПриИзмененииВалютыДокумента();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	
	Если CRM_ОбщегоНазначенияСервер.ЕстьРеквизитДокумента("ПлановаяДатаНачала",
		 Метаданные.Справочники.МаркетинговыеМероприятия) Тогда
		Элемент = Элементы.Добавить("ПлановаяДатаНачала", Тип("ПолеФормы"), Элементы.ГруппаПлан);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Объект.ПлановаяДатаНачала";
		Элемент = Элементы.Добавить("ПлановаяДатаОкончания", Тип("ПолеФормы"), Элементы.ГруппаПлан);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Объект.ПлановаяДатаОкончания";
		Элементы.ГруппаФакт.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	КонецЕсли;	
	
	НастроитьВидимостьИДоступностьФормы(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.Ответственный.ТолькоПросмотр = Ложь;
		Элементы.Ответственный.КнопкаВыбора = Истина;
	Иначе
		Элементы.Ответственный.ТолькоПросмотр = Истина;
		Элементы.Ответственный.КнопкаВыбора = Ложь;
	КонецЕсли;
	
	УстановитьПоложениеТумблераСтатусДокумента();	
	ВычислитьОбщееЧислоУчастников();
	Элементы.ГруппаВидеофиксация.Видимость = Объект.CRM_ВедетсяВидеофиксация
		 И ПолучитьФункциональнуюОпцию("CRM_ИспользоватьСервисРаспознаванияЛиц");
	Элементы.ГруппаИнформационныеНадписи.Видимость = Объект.CRM_ВедетсяВидеофиксация
		 И ПолучитьФункциональнуюОпцию("CRM_ИспользоватьСервисРаспознаванияЛиц");
	ПроверитьАктивностьВидеофиксации();
	СформироватьПредставлениеВложений();
	// +CRM_Сквозная аналитика
	// ПолучитьДанныеПоФактическимЗатратамНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// CRM_УправлениеДоступом
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступомУровниДоступа");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец CRM_УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАктивностьВидеофиксации()
	ЗапросНастроек = Новый Запрос;
	ЗапросНастроек.Текст = "ВЫБРАТЬ
	|	АктивныеСеансыВидеофиксацииСрезПоследних.СервисИдентификации КАК СервисИдентификации,
	|	АктивныеСеансыВидеофиксацииСрезПоследних.АктивноеМероприятие КАК АктивноеМероприятие
	|ИЗ
	|	РегистрСведений.CRM_АктивныеСеансыВидеофиксации.СрезПоследних КАК АктивныеСеансыВидеофиксацииСрезПоследних
	|ГДЕ
	|	АктивныеСеансыВидеофиксацииСрезПоследних.СеансЗапущен
	|	И АктивныеСеансыВидеофиксацииСрезПоследних.АктивноеМероприятие = &АктивноеМероприятие";
	ЗапросНастроек.УстановитьПараметр("АктивноеМероприятие", Объект.Ссылка);
	Выборка = ЗапросНастроек.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВидеофиксацияАктивна = Истина;
	Иначе	
		ВидеофиксацияАктивна = Ложь;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновленыДанныеСобытия", Новый Структура("СсылкаНаОбъект, ОбновлятьКалендарь",
		 Объект.Ссылка, Параметры.ОбновлятьКалендарь),
		 ЭтотОбъект);
	Элементы.Ответственный.ТолькоПросмотр = Истина;
	Элементы.Ответственный.КнопкаВыбора = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		НастроитьОтображениеДатыАктуальности();
		
	Иначе
		
		Элементы.ДатаАктуальности.Заголовок = НСтр("ru='дней ';en='days '");
		
	КонецЕсли;
	
	Если ВидеофиксацияАктивна Тогда
		Подключаемый_ПомещенияВидеофиксацииПриАктивизацииСтроки();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Маркетинг.МаркетинговоеМероприятие.ДлительностьСценариев.ВремяРаботыВФорме");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	Если ИмяСобытия = "ИзменениеСпискаПрисоединенныхФайлов" И Объект.Ссылка = Параметр Тогда
		СформироватьПредставлениеВложений();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл"
		 И (ТипЗнч(Источник) = Тип("СправочникСсылка.МаркетинговыеМероприятияПрисоединенныеФайлы")
		ИЛИ ТипЗнч(Источник) = Тип("Массив") И Источник.Количество() > 0 И ТипЗнч(Источник[0]) = Тип("СправочникСсылка.МаркетинговыеМероприятияПрисоединенныеФайлы")) Тогда
		СформироватьПредставлениеВложений();
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// +CRM_СквознаяАналитика
	Если Объект.CRM_СквознаяАналитика И Объект.CRM_Неограниченно Тогда
		ПроверкаНеВыполняется = Истина;
	Иначе
		ПроверкаНеВыполняется = Ложь;
	КонецЕсли;
	
	Если НЕ ПроверкаНеВыполняется Тогда
		
		УстановитьПериодДатыАктуальности();
		Если Объект.CRM_ДатаАктуальности < Объект.ДатаОкончания Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Дата окончания должна быть меньше чем Дата начала 
				|+ Период актуальности.';en='The expiry date should be less than the Date started 
				|+ the Period of an urgency.'");
			Сообщение.Сообщить(); 
			Отказ = Истина;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Объект.ДатаОкончания) И (Объект.ДатаОкончания < Объект.ДатаНачала) Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Дата окончания не может быть меньше чем Дата начала.';
				|en='The expiry date could not be less than the Date started.'");
			Сообщение.Сообщить(); 
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	// -CRM_СквознаяАналитика
	
	// данные по участникам нам не нужны
	Если НЕ Объект.CRM_СквознаяАналитика Тогда
		СтрОшибки = НСтр("ru='Ошибки заполнения таблицы ""Участники"":';
			|en='Errors of filling of the table ""Participants"":'");
		бОшибки = Ложь;
		МассивОбработанныеСтроки = Новый Массив();
		Для Каждого СтрокаТаблицы Из Объект.CRM_СвоиУчастники Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Участник) Тогда
				Продолжить;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ДатаНачала) И Не ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрНомерСтроки = Формат(Объект.CRM_СвоиУчастники.Индекс(СтрокаТаблицы) + 1, "ЧН=0; ЧГ=");
			Если	(ЗначениеЗаполнено(СтрокаТаблицы.ДатаНачала) И Не ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания))
				Или	(ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания) И Не ЗначениеЗаполнено(СтрокаТаблицы.ДатаНачала)) Тогда
				//
				СтрОшибки = СтрОшибки + Символы.ПС
				+ НСтр("ru='Строка';en='String'") + " " + СтрНомерСтроки + ": "
				+ НСтр("ru='Дата начала и дата окончания должны быть обе заполнены,
					| или обе не заполнены!';en='The date started and expiry date should be fill both,
					| or both was not fill!'");
				//
				бОшибки = Истина;
				Продолжить;
			КонецЕсли;
			
			Если	(ЗначениеЗаполнено(Объект.ДатаНачала) И СтрокаТаблицы.ДатаНачала < НачалоДня(Объект.ДатаНачала))
				Или	(ЗначениеЗаполнено(Объект.ДатаОкончания) И СтрокаТаблицы.ДатаОкончания > КонецДня(Объект.ДатаОкончания)) Тогда
				//
				СтрОшибки = СтрОшибки + Символы.ПС
				+ НСтр("ru='Строка';en='String'") + " " + СтрНомерСтроки + ": "
				+ НСтр("ru='Выбранный период выходит за границы периода документа!';
					|en='Selected period overstepped the bounds of the period of the document!'");
				//
				бОшибки = Истина;
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.ДатаНачала) И ЗначениеЗаполнено(СтрокаТаблицы.ДатаОкончания)
				 И СтрокаТаблицы.ДатаНачала > СтрокаТаблицы.ДатаОкончания Тогда
				СтрОшибки = СтрОшибки + Символы.ПС
				+ НСтр("ru='Строка';en='String'") + " " + СтрНомерСтроки + ": "
				+ НСтр("ru='Дата окончания должна быть больше даты начала!';en='The expiry date should be more date started!'");
				бОшибки = Истина;
				Продолжить;
			КонецЕсли;
			
			Если МассивОбработанныеСтроки.Найти(СтрокаТаблицы) = Неопределено Тогда
				НайденныеСтроки = Объект.CRM_СвоиУчастники.НайтиСтроки(Новый Структура("Участник,ДатаНачала,ДатаОкончания",
				СтрокаТаблицы.Участник, СтрокаТаблицы.ДатаНачала, СтрокаТаблицы.ДатаОкончания));
				//
				Если НайденныеСтроки.Количество() > 1 Тогда
					бОшибки = Истина;
					СтрНомераСтрок = "";
					Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
						МассивОбработанныеСтроки.Добавить(НайденнаяСтрока);
						СтрНомераСтрок = СтрНомераСтрок + ?(ПустаяСтрока(СтрНомераСтрок), "", ",")
						+ Формат(Объект.CRM_СвоиУчастники.Индекс(НайденнаяСтрока) + 1, "ЧН=0; ЧГ=");
						//
					КонецЦикла;
					СтрОшибки = СтрОшибки + Символы.ПС
					+ НСтр("ru='Строки';en='Lines'") + СтрНомераСтрок + ": "
					+ НСтр("ru='Для одного и того же участника периоды не должны повторяться!';
						|en='For the same participant the periods should not repeat!'");
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если бОшибки Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрОшибки, , "Объект.CRM_СвоиУчастники");
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	CRM_ЦентрМониторингаКлиент.ЗавершитьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Маркетинг.МаркетинговоеМероприятие.ДлительностьСценариев.ВремяРаботыВФорме");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перенаправить(Команда)
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	МассивЗадач = Новый Массив;
	МассивЗадач.Добавить(Объект.Ссылка);
	CRM_БизнесПроцессыИЗадачиКлиент.ОбработкаКомандыПеренаправить(МассивЗадач, Новый Структура("Источник", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодборСвоихУчастников(Команда)
	ПодборУчастников();
КонецПроцедуры

&НаКлиенте
Процедура КомандаСортироватьУчастниковПоВозростанию(Команда)
	Объект.CRM_СвоиУчастники.Сортировать("Участник ВОЗР");
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСортироватьУчастниковПоУбыванию(Команда)
	Объект.CRM_СвоиУчастники.Сортировать("Участник УБЫВ");
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодборКлиентов(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("РежимВыбора", 		  Истина);
	ПараметрыФормы.Вставить("ПрограммноеОткрытие", Истина);		
	
	ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", ПараметрыФормы, Элементы.ПартнерыИКонтактныеЛица);
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик команды "ОтборПериод".
//
Процедура ОткрытьСписокИнтересов(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МаркетинговаяКампания", Объект.Ссылка);
	ОткрытьФорму("Справочник.МаркетинговыеМероприятия.Форма.CRM_ФормаСпискаИнтересов", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры // ОткрытьСписокИнтересов()

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура СтатусДокументаПриИзменении(Элемент)
	
	Если СтатусДокумента = "Завершено" Тогда
		Объект.Завершено = Истина;
	Иначе		
		Объект.Завершено = Ложь;
	КонецЕсли;	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,
		 ЭтотОбъект,
		 "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	СтруктураВалюты = ПолучитьКурсИКратностьВалюты(Объект.CRM_Валюта, Объект.ДатаНачала);
	Объект.CRM_Кратность	= СтруктураВалюты.Кратность;
	Объект.CRM_Курс			= СтруктураВалюты.Курс;
	
	ПриИзмененииВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура CRM_ПериодАктуальностиПриИзменении(Элемент)
	
	УстановитьПериодДатыАктуальности();
	НастроитьОтображениеДатыАктуальности();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	Если Объект.ДатаНачала > Объект.ДатаОкончания Тогда
		Объект.ДатаОкончания = Объект.ДатаНачала;
	КонецЕсли;
	
	УстановитьПериодДатыАктуальности();
	НастроитьОтображениеДатыАктуальности();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	Если Объект.ДатаОкончания < Объект.ДатаНачала Тогда
		Объект.ДатаНачала = Объект.ДатаОкончания;
	КонецЕсли;
	
	УстановитьПериодДатыАктуальности();
	НастроитьОтображениеДатыАктуальности();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСтороннихУчастниковПоРезультатамОтчета(Команда)
	Если Объект.ПартнерыИКонтактныеЛица.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОчисткаСтороннихУчастниковПослеВопроса", ЭтотОбъект, Команда);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Список будет очищен. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаЗаполнитьСтороннихУчастниковПоРезультатамОтчетаЗавершение",
		 ЭтотОбъект);
	CRM_ОбщегоНазначенияКлиент.ОткрытьФормуЗаполненияПоРезультатамОтчета(ЭтотОбъект, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСтороннихУчастниковПоРезультатамОтчетаЗавершение(НаименованиеСохраненногоСписка,
	 ДополнительныеПараметры) Экспорт
	
	Если НаименованиеСохраненногоСписка <> Неопределено Тогда
		СохраненныйСписок =
			CRM_ОбщегоНазначенияСервер.ПолучитьСохраненныйРезультатОтчетаПоНаименованию(НаименованиеСохраненногоСписка);
		Если СохраненныйСписок <> Неопределено Тогда
			ДопустимыеТипы = Новый ОписаниеТипов("СправочникСсылка.Партнеры, СправочникСсылка.КонтактныеЛицаПартнеров");
			Для Каждого СтрокаСписка Из СохраненныйСписок Цикл
				Если ДопустимыеТипы.СодержитТип(ТипЗнч(СтрокаСписка.Значение)) Тогда
					НоваяСтрока = Объект.ПартнерыИКонтактныеЛица.Добавить();
					Если ТипЗнч(СтрокаСписка.Значение) = Тип("СправочникСсылка.Партнеры") Тогда
						НоваяСтрока.Партнер = СтрокаСписка.Значение;
					Иначе
						НоваяСтрока.КонтактноеЛицо = СтрокаСписка.Значение;
						НоваяСтрока.Партнер = CRM_ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(СтрокаСписка.Значение, "Владелец");
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	ВычислитьОбщееЧислоУчастников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаСтороннихУчастниковПослеВопроса(Ответ, Команда) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.ПартнерыИКонтактныеЛица.Очистить();
		КомандаЗаполнитьСтороннихУчастниковПоРезультатамОтчета(Команда);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПомещенияВидеофиксацииПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_ПомещенияВидеофиксацииПриАктивизацииСтроки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПомещенияВидеофиксацииПриАктивизацииСтроки()
	ТекСтрока = Элементы.ПомещенияВидеофиксации.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Элементы.КамерыВидеофиксации.ОтборСтрок = Новый ФиксированнаяСтруктура("Помещение",
			 ПредопределенноеЗначение("Справочник.CRM_Помещения.ПустаяСсылка"));
		CRM_ОбщегоНазначенияКлиентСервер.ОбновлениеТаблицыФормы(Элементы.КамерыВидеофиксации); 
	Иначе	
		Элементы.КамерыВидеофиксации.ОтборСтрок = Новый ФиксированнаяСтруктура("Помещение", ТекСтрока.Помещение);
		CRM_ОбщегоНазначенияКлиентСервер.ОбновлениеТаблицыФормы(Элементы.КамерыВидеофиксации);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПомещенияВидеофиксацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ПодключитьОбработчикОжидания("Подключаемый_ПомещенияВидеофиксацииПриАктивизацииСтроки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КамерыВидеофиксацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ТекСтрока = Элементы.ПомещенияВидеофиксации.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Сначала необходимо ВЫБРАТЬ помещение";
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КамерыВидеофиксацииПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтрока = Элементы.ПомещенияВидеофиксации.ТекущиеДанные;	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда   
		Элемент.ТекущиеДанные.Помещение = ТекСтрока.Помещение;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивКамер()
	Возврат Объект.CRM_КамерыВидеофиксации.Выгрузить().ВыгрузитьКолонку("Камера");
КонецФункции

&НаКлиенте
Процедура КамерыВидеофиксацииКамераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКамерыОкончание", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ФильтрКамер, ИсключатьСписок", ПолучитьМассивКамер(), Истина);
	Открытьформу("Справочник.CRM_Камеры.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ВыборКамерыОкончание(ДанныеВыбора, ДопПараметры) Экспорт
	Элементы.КамерыВидеофиксации.ТекущиеДанные.Камера = ДанныеВыбора;	
КонецПроцедуры

&НаКлиенте
Процедура CRM_ВедетсяВидеофиксацияПриИзменении(Элемент)
	Элементы.ГруппаВидеофиксация.Видимость = Объект.CRM_ВедетсяВидеофиксация;
	Элементы.ГруппаИнформационныеНадписи.Видимость = Объект.CRM_ВедетсяВидеофиксация;
КонецПроцедуры

&НаСервере
Процедура ДекорацияСтартоватьМероприятиеНажатиеНаСервере()
	Если Объект.Ссылка.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для старта сеанса распознавания лиц необходимо записать документ.";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	Если Объект.CRM_УчетнаяЗаписьСервисаРаспознавания.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для старта сеанса распознавания лиц необходимо указать учетную запись сервиса распознавания";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	Набор = РегистрыСведений.CRM_АктивныеСеансыВидеофиксации.СоздатьНаборЗаписей();
	Набор.Очистить();
	Набор.Записать(Истина);
	Запись = Набор.Добавить();
	Запись.Период = ТекущаяДатаСеанса();
	Запись.СервисИдентификации = Объект.CRM_УчетнаяЗаписьСервисаРаспознавания;
	Запись.АктивноеМероприятие = Объект.Ссылка;
	Запись.СеансЗапущен = Истина;
	Набор.Записать(Истина);
	//ПроверитьАктивностьВидеофиксации();
КонецПроцедуры

&НаСервере
Процедура ДекорацияОстановитьРаспознаваниеНажатиеНаСервере()
	Набор = РегистрыСведений.CRM_АктивныеСеансыВидеофиксации.СоздатьНаборЗаписей();
	Набор.Очистить();
	Набор.Записать(Истина);
	//ПроверитьАктивностьВидеофиксации();
КонецПроцедуры

&НаКлиенте
Процедура ВидеофиксацияАктивнаПриИзменении(Элемент)
	Если ВидеофиксацияАктивна Тогда
		ДекорацияСтартоватьМероприятиеНажатиеНаСервере();
	Иначе
		ДекорацияОстановитьРаспознаваниеНажатиеНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАнализСтатистикиПосещенияМероприятияНажатие(Элемент)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "Основной");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ФормаРасшифровки = ПолучитьФорму("Отчет.CRM_АнализСтатистикиПосещенияМероприятия.Форма", ПараметрыФормы);
	ПараметрМероприятие = Новый ПараметрКомпоновкиДанных("Мероприятие");
	Для Каждого Параметр Из ФормаРасшифровки.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если Параметр.Параметр = ПараметрМероприятие Тогда
			Параметр.Использование = Истина;
			Параметр.Значение = Объект.Ссылка;	
		КонецЕсли;	
	КонецЦикла;	
	ФормаРасшифровки.Открыть();
КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда,
	 НавигационнаяСсылка = Неопределено,
	 СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

&НаКлиенте
Процедура НеограниченоПриИзменении(Элемент)
	
	Если Объект.CRM_Неограниченно Тогда
		
		Элементы.ДатаОкончания.АвтоОтметкаНезаполненного = Ложь;
		Объект.ДатаОкончания = Дата(1, 1, 1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЧислоВложений()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(МаркетинговыеМероприятияПрисоединенныеФайлы.Ссылка) КАК КоличествоФайлов
	|ИЗ
	|	Справочник.МаркетинговыеМероприятияПрисоединенныеФайлы КАК МаркетинговыеМероприятияПрисоединенныеФайлы
	|ГДЕ
	|	МаркетинговыеМероприятияПрисоединенныеФайлы.ВладелецФайла = &Проект
	|	И НЕ МаркетинговыеМероприятияПрисоединенныеФайлы.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Проект", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.КоличествоФайлов;
	КонецЕсли;
	
КонецФункции

// Процедура заполняет надпись представление вложений.
//
// Параметры:
//	Нет.
&НаСервере
Процедура СформироватьПредставлениеВложений()
	
	ЧислоВложений = 0;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ЧислоВложений = ПолучитьЧислоВложений();
	КонецЕсли;
	
	ВложенияПредставление = НСтр("ru='Файлы('") + ЧислоВложений + ")";
	УчастникиКоличество = Объект.ПартнерыИКонтактныеЛица.Количество() + Объект.CRM_СвоиУчастники.Количество();
	Элементы.ОткрытьУчастники.Заголовок = НСтр("ru='Участники('") + УчастникиКоличество + ")";
	
КонецПроцедуры // СформироватьПредставлениеВложений()

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
Процедура ПроверкаВопросЗаписатьДанные(ОписаниеОповещенияОЗавершении)
	
	Если Объект.Ссылка.Пустая() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаВопросЗаписатьДанныеЗавершение",
			 ЭтотОбъект,
			 ОписаниеОповещенияОЗавершении);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Данные еще не записаны."
"Действие возможно только после записи данных. Записать?'"), 
		РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлыЗавершение", ЭтотОбъект);
	ПроверкаВопросЗаписатьДанные(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлыЗавершение(ПродолжитьВыполнение, ПараметрыВыполнения) Экспорт
	
	Если ПродолжитьВыполнение Тогда
		ПараметрыФормы = Новый Структура("ВладелецФайла", Объект.Ссылка);
		ПараметрыФормы.Вставить("ТолькоВложения",	Истина);
		ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.CRM_ПрисоединенныеФайлы",
		ПараметрыФормы, ЭтотОбъект, Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьФайлыЗавершение()

&НаКлиенте
Процедура ОткрытьЗатратыНаРКНажатие(Элемент)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьЗатратПоРКЗавершение", ЭтотОбъект);
	ПроверкаВопросЗаписатьДанные(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗатратПоРКЗавершение(ПродолжитьВыполнение, ПараметрыВыполнения) Экспорт
	
	Если ПродолжитьВыполнение Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("CRM_РекламнаяКампания", Объект.Ссылка);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		
		ОткрытьФорму("РегистрСведений.CRM_ЗатратыРекламныхКампаний.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьОбъявленияРекламныхКампанийНажатие(Элемент)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьОбъявленияРекламныхКампанийЗавершение", ЭтотОбъект);
	ПроверкаВопросЗаписатьДанные(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъявленияРекламныхКампанийЗавершение(ПродолжитьВыполнение, ПараметрыВыполнения) Экспорт
	
	Если ПродолжитьВыполнение Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("Владелец", Объект.Ссылка);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		
		ОткрытьФорму("Справочник.CRM_ОбъявленияРекламныхКампаний.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьБизнесПроцессыЗавершение()

&НаКлиенте
Процедура ОткрытьУчастникиНажатие(Элемент)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьУчастникиЗавершение", ЭтотОбъект);
	ПроверкаВопросЗаписатьДанные(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУчастникиЗавершение(ПродолжитьВыполнение, ПараметрыВыполнения) Экспорт
	
	Если ПродолжитьВыполнение Тогда
		ПараметрыФормы = Новый Структура("ПартнерыИКонтактныеЛица,CRM_СвоиУчастники,ДатаНачала,
			|ДатаОкончания", Объект.ПартнерыИКонтактныеЛица, Объект.CRM_СвоиУчастники, Объект.ДатаНачала,
			 Объект.ДатаОкончания);
		ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ОткрытьФорму("Справочник.МаркетинговыеМероприятия.Форма.CRM_ФормаУчастники", ПараметрыФормы,
			 ЭтотОбъект, , , , Новый ОписаниеОповещения("УчастникиЗавершениеЗаполнения", ЭтотОбъект),
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьУчастникиЗавершение()

&НаСервере
Процедура УчастникиЗавершениеЗаполненияНаСервере(Результат)
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ПартнерыИКонтактныеЛица.Загрузить(Результат.ПартнерыИКонтактныеЛица.Выгрузить());
		Объект.CRM_СвоиУчастники.Загрузить(Результат.CRM_СвоиУчастники.Выгрузить());
		СформироватьПредставлениеВложений();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УчастникиЗавершениеЗаполнения(Результат, Контекст) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		УчастникиЗавершениеЗаполненияНаСервере(Результат);
	КонецЕсли;
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

#КонецОбласти
