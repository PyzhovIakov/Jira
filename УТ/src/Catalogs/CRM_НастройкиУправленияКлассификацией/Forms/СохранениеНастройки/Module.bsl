
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Настройки", Настройки) Тогда
		ВызватьИсключение НСтр("ru='Не определены сохраняемые настройки';en='No saved settings defined'");	
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПоискПоНаименованию", Новый Соответствие);
	
	Параметры.Свойство("ИмяСписка", ИмяСписка);
	CRM_КлассификаторыЭкспортныеМетоды.ЗаполнитьИменаСписковУправленияКлассификацией(СписокУправленияКлассификацией);	
	Заголовок = СписокУправленияКлассификацией.НайтиПоЗначению(ИмяСписка).Представление;
	
	Автор = Пользователи.ТекущийПользователь();
	Доступ.Добавить().Пользователь = Автор;
	ДоступПредставление = ПредставлениеНастроекДоступа(ЭтотОбъект);
	
	ЗаполнитьСписокНастроек();
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьНаСервере();
		Если ЗначениеЗаполнено(НастройкаСсылка) Тогда
			Оповестить("ЗаписьНастройкиКлассификации", НастройкаСсылка, ИмяСписка);
		КонецЕсли;
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьНаСервере();
		Если ЗначениеЗаполнено(НастройкаСсылка) Тогда
			Оповестить("ЗаписьНастройкиКлассификации", НастройкаСсылка, ИмяСписка);
		КонецЕсли;
		
		Закрыть();
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НаименованиеМодифицировано = Истина;
	Элементы.СписокНастроек.ТекущаяСтрока = Контекст.ПоискПоНаименованию.Получить(НастройкаНаименование);
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ОписаниеНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение,
		 Элементы.Описание.ТекстРедактирования,
		НСтр("ru='Описание';en='Description'"));
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбораЗавершение(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	НастройкаОписание = ВведенныйТекст;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	ОписаниеМодифицировано = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПриАктивизацииСтроки(Элемент)
	
	НаименованиеМодифицировано = Ложь;
	ОписаниеМодифицировано = Ложь;
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередУдалением(Элемент, Отказ)
	Отказ = Истина;	
КонецПроцедуры

&НаКлиенте
Процедура ДоступПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокДоступа = Новый СписокЗначений;
	Для каждого СтрокаПользователь Из Доступ Цикл
		СписокДоступа.Добавить(СтрокаПользователь.Пользователь);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Автор"		   , Автор);
	ПараметрыФормы.Вставить("СписокДоступа", СписокДоступа);
	
	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияДоступа", ЭтотОбъект);
	ОткрытьФорму("Справочник.CRM_НастройкиУправленияКлассификацией.Форма.НастройкаДоступа", 
		ПараметрыФормы, ЭтотОбъект, , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРедактированияДоступа(Структура, Контекст) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Доступ.Очистить();
	Для Каждого ЭлементСписка Из Структура.СписокДоступа Цикл
		Доступ.Добавить().Пользователь = ЭлементСписка.Значение;
	КонецЦикла;
	
	ДоступПредставление = ПредставлениеНастроекДоступа(ЭтотОбъект);

КонецПроцедуры // ПослеРедактированияДоступа()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВспомогательныеПроцедурыФункции

&НаСервере
Процедура ЗаполнитьСписокНастроек()
	
	СписокНастроек.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяСписка", ИмяСписка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	CRM_НастройкиУправленияКлассификацией.Ссылка КАК Ссылка,
		|	CRM_НастройкиУправленияКлассификацией.Наименование КАК Наименование,
		|	CRM_НастройкиУправленияКлассификацией.ИмяСписка КАК ИмяСписка,
		|	CRM_НастройкиУправленияКлассификацией.ИмяСпискаПредставление КАК ИмяСпискаПредставление,
		|	CRM_НастройкиУправленияКлассификацией.Описание КАК Описание,
		|	CRM_НастройкиУправленияКлассификацией.Предопределенный КАК Предопределенный,
		|	CRM_НастройкиУправленияКлассификацией.Автор КАК Автор,
		|	CRM_НастройкиУправленияКлассификацией.Доступ.(
		|		Ссылка,
		|		НомерСтроки,
		|		Пользователь
		|	)
		|ИЗ
		|	Справочник.CRM_НастройкиУправленияКлассификацией КАК CRM_НастройкиУправленияКлассификацией
		|ГДЕ
		|	CRM_НастройкиУправленияКлассификацией.ИмяСписка = &ИмяСписка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СписокНастроек.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Доступ");
		
		НоваяСтрока.ИндексКартинки = ?(Выборка.Предопределенный, 5, 3);
		НоваяСтрока.Доступ.Загрузить(Выборка.Доступ.Выгрузить());
		
	КонецЦикла;

	СписокНастроек.Сортировать("Наименование Возр");
	
	Контекст.ПоискПоНаименованию = Новый Соответствие;
	Для Каждого Настройка Из СписокНастроек Цикл
		Контекст.ПоискПоНаименованию.Вставить(Настройка.Наименование, Настройка.ПолучитьИдентификатор());

	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьСписокНастроек()

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНастроекДоступа(Форма)
	
	Результат = "";
	Для Каждого СтрокаТаблицы Из Форма.Доступ Цикл
		ПредставлениеСтроки = СокрЛП(Строка(СтрокаТаблицы.Пользователь));
		Если ПредставлениеСтроки <> "" Тогда
			Если Результат = "" Тогда
				Результат = Результат + ПредставлениеСтроки;
			Иначе
				Результат = Результат + ", " + ПредставлениеСтроки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = "" Тогда
		Результат = НСтр("ru='Пользователи не выбраны';en='No users selected'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма)
	
	БудетЗаписанНовый = Ложь;
	БудетПерезаписанСуществующий = Ложь;
	ПерезаписьНевозможна = Ложь;
	
	Идентификатор = Форма.Элементы.СписокНастроек.ТекущаяСтрока;
	Если Идентификатор = Неопределено Тогда
		Настройка = Неопределено;
	Иначе
		Настройка = Форма.СписокНастроек.НайтиПоИдентификатору(Идентификатор);
	КонецЕсли;
	
	Если Настройка = Неопределено Тогда
		БудетЗаписанНовый = Истина;
		Форма.НастройкаСсылка = Неопределено;
		Если Не Форма.ОписаниеМодифицировано Тогда
			Форма.НастройкаОписание = "";
		КонецЕсли;
		Форма.Элементы.СписокНастроек.ТекущаяСтрока = Неопределено;
		
	Иначе		
		Если Не Настройка.Предопределенный Тогда
			БудетПерезаписанСуществующий = Истина;
			Форма.НаименованиеМодифицировано = Ложь;
			Форма.НастройкаНаименование = Настройка.Наименование;
			
			Форма.НастройкаСсылка = Настройка.Ссылка;
			Если Не Форма.ОписаниеМодифицировано Тогда
				Форма.НастройкаОписание = Настройка.Описание;
			КонецЕсли;
		Иначе
			Если Форма.НаименованиеМодифицировано Тогда
				ПерезаписьНевозможна = Истина;
				Форма.Элементы.СписокНастроек.ТекущаяСтрока = Неопределено;
			Иначе
				БудетЗаписанНовый = Истина;
				Форма.НастройкаНаименование = СформироватьСвободноеНаименование(Настройка, Форма.СписокНастроек);
			КонецЕсли;
			
			Форма.НастройкаСсылка = Неопределено;
			Если Не Форма.ОписаниеМодифицировано Тогда
				Форма.НастройкаОписание = "";
			КонецЕсли;
		КонецЕсли;

		Форма.Доступ.Очистить();
		Форма.Доступ.Добавить().Пользователь = Форма.Автор;
		Для каждого СтрокаТаблицы Из Настройка.Доступ Цикл
			Если СтрокаТаблицы.Пользователь = Форма.Автор Тогда
				Продолжить;
				
			КонецЕсли;
			
			Форма.Доступ.Добавить().Пользователь = СтрокаТаблицы.Пользователь;			
		КонецЦикла;
		
		Форма.ДоступПредставление = ПредставлениеНастроекДоступа(Форма);
		
	КонецЕсли;
	
	Если БудетЗаписанНовый Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.Новый;
		Форма.Элементы.Сохранить.Доступность = Истина;
		
	ИначеЕсли БудетПерезаписанСуществующий Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.Перезапись;
		Форма.Элементы.Сохранить.Доступность = Истина;
		
	ИначеЕсли ПерезаписьНевозможна Тогда
		Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница = Форма.Элементы.ПерезаписьНевозможна;
		Форма.Элементы.Сохранить.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСвободноеНаименование(Настройка, СписокНастроек)
	
	ШаблонИмени = СокрЛП(Настройка.Наименование) + " - " + НСтр("ru='копия';en='copy'");
	
	СвободноеНаименование = ШаблонИмени;
	Найденные = СписокНастроек.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
	Если Найденные.Количество() = 0 Тогда
		Возврат СвободноеНаименование;
	КонецЕсли;
	
	НомерНастройки = 1;
	
	Пока Истина Цикл
		НомерНастройки = НомерНастройки + 1;
		СвободноеНаименование = ШаблонИмени + " (" + Формат(НомерНастройки, "") + ")";
		Найденные = СписокНастроек.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
		Если Найденные.Количество() = 0 Тогда
			Возврат СвободноеНаименование;
			
		КонецЕсли;
		
	КонецЦикла;     
	
КонецФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	НастройкаЭтоНовый = Не ЗначениеЗаполнено(НастройкаСсылка);
	Если НастройкаЭтоНовый Тогда
		НастройкаОбъект = Справочники.CRM_НастройкиУправленияКлассификацией.СоздатьЭлемент();
		
		НастройкаОбъект.ИмяСписка  			   = ИмяСписка;
		НастройкаОбъект.ИмяСпискаПредставление = СписокУправленияКлассификацией.НайтиПоЗначению(ИмяСписка).Представление;
		НастройкаОбъект.Автор      			   = Автор;
		
	Иначе
		НастройкаОбъект = НастройкаСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	НастройкаОбъект.Наименование = НастройкаНаименование;
	НастройкаОбъект.Описание     = НастройкаОписание;
	НастройкаОбъект.Настройки 	 = Новый ХранилищеЗначения(Настройки, Новый СжатиеДанных(9));
	
	НастройкаОбъект.Доступ.Загрузить(Доступ.Выгрузить());
	
	НастройкаОбъект.Записать();
	
	НастройкаСсылка = НастройкаОбъект.Ссылка;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти 
