#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокСервисов = CRM_РаботаСЯзыковымиМоделямиСервер.СписокПоддерживаемыхСервисов();
	НастроитьИконкуСервиса();
	
	Для Каждого Сервис Из СписокСервисов Цикл
		Элементы.ИмяСервиса.СписокВыбора.Добавить(Сервис.Значение, Сервис.Представление);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.ИмяСервиса) Тогда
		СоздатьЭлементыНастроек();
		Настройки = Объект.Ссылка.ХранилищеНастроек.Получить();
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			Для Каждого Настройка Из Настройки Цикл
				Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса, ИмяНастройки",
						Объект.ИмяСервиса, Настройка.Ключ));
				Если Строки.Количество() > 0 Тогда
					Строки[0].Значение = Настройка.Значение;
					ЭтотОбъект[Строки[0].ИмяРеквизита] = Настройка.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Включен = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса", Объект.ИмяСервиса));
	Для Каждого Строка Из Строки Цикл
		Если Строка.ПроверкаЗаполнения Тогда
			ПроверяемыеРеквизиты.Добавить(Строка.ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Ссылка.Пустая() И Не ПодтверждениеПолучено И ПроверитьЗаполнение() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаПередЗаписью", ЭтотОбъект);
		ТекстВопроса = CRM_РаботаСЯзыковымиМоделямиВызовСервера.ТекстПредупреждения("ПредупреждениеПередЗаписьюСервиса");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "&lt;ИМЯ_СЕРВИСА&gt;",
			Элементы.ИмяСервиса.СписокВыбора.НайтиПоЗначению(Объект.ИмяСервиса).Представление);

		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Продолжить", "Продолжить", Истина);
		Кнопки.Добавить("Отмена", "Отмена", Ложь);
		
		ПараметрыВопроса = Новый Структура;
		ПараметрыВопроса.Вставить("ТекстHTML", ТекстВопроса);
		ПараметрыВопроса.Вставить("Заголовок",НСтр("ru = 'Использование языковой модели'"));
		ПараметрыВопроса.Вставить("Кнопки", Кнопки);
		ПараметрыВопроса.Вставить("Размер", Новый Структура("Высота, Ширина", 20, 60));
		
		ОткрытьФорму("ОбщаяФорма.CRM_ВыводHTMLДокумента", ПараметрыВопроса, , , , ,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаПередЗаписью(Ответ, ДопПараметры) Экспорт
	Если Ответ <> Неопределено И Ответ = "Продолжить" Тогда
		ПодтверждениеПолучено = Истина;
		Записать();
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СтруктураНастроек = Новый Структура;
	Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса", Объект.ИмяСервиса));
	Для Каждого Строка Из Строки Цикл
		СтруктураНастроек.Вставить(Строка.ИмяНастройки, Строка.Значение);
	КонецЦикла;
	ТекущийОбъект.ХранилищеНастроек = Новый ХранилищеЗначения(СформироватьСтруктуруНастроек());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ИмяСервисаПриИзмененииНаСервере()
	СкрытьЭлементыНастроек();
	Если ЗначениеЗаполнено(Объект.ИмяСервиса) Тогда
		СоздатьЭлементыНастроек();
	КонецЕсли;
	НастроитьИконкуСервиса();
КонецПроцедуры

&НаКлиенте
Процедура ИмяСервисаПриИзменении(Элемент)
	ИмяСервисаПриИзмененииНаСервере();
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ЗначениеНастройкиПриИзменении(Элемент)
	Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса, ИмяРеквизита",
			Объект.ИмяСервиса, Элемент.Имя));
	Если Строки.Количество() > 0 Тогда
		Строки[0].Значение = ЭтотОбъект[Элемент.Имя];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	Если Элемент.Имя = "Настройка_Модель" И Элемент.СписокВыбора.Количество() = 0 Тогда
		ЗаполнитьСписокМоделей();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере()
	Если ПроверитьЗаполнение() Тогда
		Если ЗначениеЗаполнено(Объект.ПроксиСервер) Тогда
			Прокси = Новый Структура("ПроксиСервер, ПроксиПорт, ПроксиПользователь, ПроксиПароль",
				Объект.ПроксиСервер, Объект.ПроксиПорт, Объект.ПроксиПользователь, Объект.ПроксиПароль);
		Иначе
			Прокси = Неопределено;
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(CRM_РаботаСЯзыковымиМоделямиСервер.ПроверитьПодключение(Объект.ИмяСервиса,
			СформироватьСтруктуруНастроек(), Прокси));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	ПроверитьПодключениеНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеМетоды

&НаСервере
Процедура СкрытьЭлементыНастроек()
	Для Каждого Настройка Из ТекущиеНастройки Цикл
		Элемент = Элементы.Найти("Настройка_" + Настройка.ИмяНастройки);
		Если Элемент <> Неопределено Тогда
			Элемент.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыНастроек()
	Если ЗначениеЗаполнено(Объект.ПроксиСервер) Тогда
		Прокси = Новый Структура("ПроксиСервер, ПроксиПорт, ПроксиПользователь, ПроксиПароль",
			Объект.ПроксиСервер, Объект.ПроксиПорт, Объект.ПроксиПользователь, Объект.ПроксиПароль);
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	СтруктураНастроек = CRM_РаботаСЯзыковымиМоделямиСервер.СтруктураНастроекСервиса(Объект.ИмяСервиса,
		СформироватьСтруктуруНастроек(), Прокси);
	
	СоздаваемыеРеквизиты = Новый Массив;

	Для Каждого Настройка Из СтруктураНастроек Цикл
		Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса, ИмяНастройки",
				Объект.ИмяСервиса, Настройка.Ключ));
		Если Строки.Количество() = 0 Тогда
			ТекНастройка = ТекущиеНастройки.Добавить();
			ТекНастройка.ИмяСервиса = Объект.ИмяСервиса;
			ТекНастройка.ИмяНастройки = Настройка.Ключ;
			ТекНастройка.ИмяРеквизита = "Настройка_" + Настройка.Ключ;
			ТекНастройка.Заголовок = Настройка.Значение.Заголовок;
			ТекНастройка.ПроверкаЗаполнения = Настройка.Значение.ПроверкаЗаполнения;
			ТекНастройка.Значение = Настройка.Значение.Значение;
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(Настройка.Значение.Значение));
			ТекНастройка.ТипЗнч = Новый ОписаниеТипов(МассивТипов);
		Иначе
			ТекНастройка = Строки[0];
		КонецЕсли;
		Элемент = Элементы.Найти("Настройка_" + Настройка.Ключ);
		Если Элемент = Неопределено Тогда
			СоздаваемыеРеквизиты.Добавить(Новый РеквизитФормы(ТекНастройка.ИмяРеквизита,
				Новый ОписаниеТипов(),, ТекНастройка.Заголовок));
		Иначе
			Элемент.Видимость = Истина;
			Элемент.ОграничениеТипа = ТекНастройка.ТипЗнч;
			Если СтруктураНастроек[ТекНастройка.ИмяНастройки].Свойство("СписокВыбора") Тогда
				Элемент.СписокВыбора.Очистить();
				Для Каждого ЭлементВыбора Из СтруктураНастроек[ТекНастройка.ИмяНастройки].СписокВыбора Цикл
					Элемент.СписокВыбора.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
				КонецЦикла;
				Элемент.РежимВыбораИзСписка = Истина;
			Иначе	
				Элемент.РежимВыбораИзСписка = Ложь;
			КонецЕсли;
			ЭтотОбъект[ТекНастройка.ИмяРеквизита] = ТекНастройка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если СоздаваемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(СоздаваемыеРеквизиты);
		
		Для Каждого Реквизит Из СоздаваемыеРеквизиты Цикл
			НовЭлемент = Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), Элементы.ГруппаНастройки);
			НовЭлемент.ПутьКДанным = Реквизит.Имя;
			НовЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			НовЭлемент.УстановитьДействие("ПриИзменении", "Подключаемый_ЗначениеНастройкиПриИзменении");
			Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса, ИмяРеквизита",
					Объект.ИмяСервиса, Реквизит.Имя));
			Если Строки.Количество() > 0 Тогда
				ТекНастройка = Строки[0]; 
				НовЭлемент.АвтоОтметкаНезаполненного = ТекНастройка.ПроверкаЗаполнения;
				НовЭлемент.Заголовок = ТекНастройка.Заголовок;
				НовЭлемент.ОграничениеТипа = ТекНастройка.ТипЗнч;
				Если СтруктураНастроек[ТекНастройка.ИмяНастройки].Свойство("СписокВыбора") Тогда
					Для Каждого ЭлементВыбора Из СтруктураНастроек[ТекНастройка.ИмяНастройки].СписокВыбора Цикл
						НовЭлемент.СписокВыбора.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
					КонецЦикла;
					НовЭлемент.РежимВыбораИзСписка = Истина;
					НовЭлемент.УстановитьДействие("НачалоВыбора", "Подключаемый_НачалоВыбора");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьСтруктуруНастроек()
	СтруктураНастроек = Новый Структура;
	Если ТекущиеНастройки.Количество() > 0 Тогда
		Строки = ТекущиеНастройки.НайтиСтроки(Новый Структура("ИмяСервиса", Объект.ИмяСервиса));
		Для Каждого Строка Из Строки Цикл
			СтруктураНастроек.Вставить(Строка.ИмяНастройки, Строка.Значение);
		КонецЦикла;
	ИначеЕсли Не Объект.Ссылка.Пустая() Тогда
		СтруктураНастроек = Объект.Ссылка.ХранилищеНастроек.Получить();
	КонецЕсли;
	Возврат СтруктураНастроек;
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокМоделей()
	Если ЗначениеЗаполнено(Объект.ПроксиСервер) Тогда
		Прокси = Новый Структура("ПроксиСервер, ПроксиПорт, ПроксиПользователь, ПроксиПароль",
			Объект.ПроксиСервер, Объект.ПроксиПорт, Объект.ПроксиПользователь, Объект.ПроксиПароль);
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	СтруктураНастроек = CRM_РаботаСЯзыковымиМоделямиСервер.СтруктураНастроекСервиса(Объект.ИмяСервиса,
		СформироватьСтруктуруНастроек(), Прокси);
		

	Если СтруктураНастроек.Свойство("Модель") И СтруктураНастроек.Модель.Свойство("СписокВыбора") Тогда
		ЭлементМ = Элементы.Найти("Настройка_Модель");

		Для Каждого ЭлементВыбора Из СтруктураНастроек.Модель.СписокВыбора Цикл
			ЭлементМ.СписокВыбора.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастроитьИконкуСервиса()
	
	ВидимостьИконки = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ИмяСервиса) Тогда
		НайденныйЭлемент = СписокСервисов.НайтиПоЗначению(Объект.ИмяСервиса);
		Если НайденныйЭлемент <> Неопределено Тогда
			Элементы.ИконкаСервиса.Картинка = НайденныйЭлемент.Картинка;
			ВидимостьИконки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ИконкаСервиса", "Видимость", ВидимостьИконки);
	
КонецПроцедуры

#КонецОбласти
