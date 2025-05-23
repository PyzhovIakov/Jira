
///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ СЕРВЕР

///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ КЛИЕНТ

&НаКлиенте
Функция ПроверитьНаКорректностьЗаполнитьВозвращаемыеЗначения()
	бЕстьОтмеченныеКатегории = Ложь;
	бЕстьОсновнаяКатегория = Ложь;
	Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
		Если КатегорияСтрока.Пометка Тогда
			бЕстьОтмеченныеКатегории = Истина;
		КонецЕсли;
		Если КатегорияСтрока.Пометка И КатегорияСтрока.ЭтоОсновнаяКатегория Тогда
			бЕстьОсновнаяКатегория = Истина;
		КонецЕсли;
		Если бЕстьОтмеченныеКатегории И бЕстьОсновнаяКатегория Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если бЕстьОтмеченныеКатегории И Не бЕстьОсновнаяКатегория Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не назначена основная категория!';
			|en='The main category are not assigned!'"), ,
			 "ТаблицаКатегории");
		Возврат Ложь;
	КонецЕсли;
	
	ОсновнаяКатегория = ПредопределенноеЗначение("Справочник.CRM_Категории.ПустаяСсылка");
	СписокВыбранныеКатегории.Очистить();
	Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
		Если КатегорияСтрока.Пометка
			 И СписокВыбранныеКатегории.НайтиПоЗначению(КатегорияСтрока.Категория) = Неопределено Тогда
			СписокВыбранныеКатегории.Добавить(КатегорияСтрока.Категория);
		КонецЕсли;
		Если КатегорияСтрока.ЭтоОсновнаяКатегория Тогда
			ОсновнаяКатегория = КатегорияСтрока.Категория;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ПроверитьУстановитьОсновнуюКатегорию(Категория = Неопределено, КатегорияТекущихДанных = Неопределено)
	Если Категория = Неопределено Тогда
		бНайденаОсновнаяКатегория = Ложь;
		ВыбраннаяОсновнаяКатегория = Неопределено;
		Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
			Если КатегорияСтрока.ЭтоОсновнаяКатегория И КатегорияСтрока.Пометка Тогда
				бНайденаОсновнаяКатегория = Истина;
				ВыбраннаяОсновнаяКатегория = КатегорияСтрока.Категория;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не бНайденаОсновнаяКатегория Тогда
			Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
				Если КатегорияСтрока.Пометка И КатегорияСтрока.Категория <> КатегорияТекущихДанных Тогда
					бНайденаОсновнаяКатегория = Истина;
					КатегорияСтрока.ЭтоОсновнаяКатегория = Истина;
					ВыбраннаяОсновнаяКатегория = КатегорияСтрока.Категория;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если Не бНайденаОсновнаяКатегория Тогда
			Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка = Ложь;
		КонецЕсли;
		
		Если ВыбраннаяОсновнаяКатегория = Неопределено Тогда
			Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
				КатегорияСтрока.ЭтоОсновнаяКатегория = Ложь;
			КонецЦикла;
		Иначе
			Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
				КатегорияСтрока.ЭтоОсновнаяКатегория = (КатегорияСтрока.Категория = ВыбраннаяОсновнаяКатегория);
			КонецЦикла;
		КонецЕсли;
	Иначе
		Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
			Если КатегорияСтрока.Категория = Категория Тогда
				КатегорияСтрока.ЭтоОсновнаяКатегория = Истина;
				Если Не КатегорияСтрока.Пометка Тогда
					КатегорияСтрока.Пометка = Истина;
				КонецЕсли;
			Иначе
				КатегорияСтрока.ЭтоОсновнаяКатегория = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ТаблицаКатегорииПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ТаблицаКатегории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка = (ТекущиеДанные.ЭтоОсновнаяКатегория);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКатегорииПометкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаКатегории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьУстановитьОсновнуюКатегорию(, ?(ТекущиеДанные.Пометка, Неопределено, ТекущиеДанные.Категория));
	
	ТаблицаКатегорииПриАктивизацииСтроки(Элементы.ТаблицаКатегории);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	Если ПроверитьНаКорректностьЗаполнитьВозвращаемыеЗначения() Тогда
		ДанныеБылиИзменены = Истина;
		Модифицированность = Ложь;
		Результат = Новый Структура("СписокВыбранныеКатегории, ОсновнаяКатегория",
			 СписокВыбранныеКатегории,
			 ОсновнаяКатегория);
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОсновнаяКатегория(Команда)
	ТекущиеДанные = Элементы.ТаблицаКатегории.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка = Не Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка;
	Если Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка И Не ТекущиеДанные.Пометка Тогда
		ТекущиеДанные.Пометка = Истина;
	КонецЕсли;
	ТекущиеДанные.ЭтоОсновнаяКатегория = Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка;
	
	ПроверитьУстановитьОсновнуюКатегорию(?(Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка,
		 ТекущиеДанные.Категория,
		 Неопределено));
	
	Если ТекущиеДанные.ЭтоОсновнаяКатегория И Не Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка Тогда
		Элементы.ТаблицаКатегорииКнопкаОсновная.Пометка = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
		КатегорияСтрока.Пометка = Истина;
	КонецЦикла;
	ПроверитьУстановитьОсновнуюКатегорию();
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	Для Каждого КатегорияСтрока Из ТаблицаКатегории Цикл
		КатегорияСтрока.Пометка = Ложь;
	КонецЦикла;
	ПроверитьУстановитьОсновнуюКатегорию();
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Параметры.Свойство("ОписаниеКатегорий") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеКатегорий = Параметры.ОписаниеКатегорий;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Категории.Ссылка																	КАК Категория,
	|	ВЫБОР КОГДА Категории.Ссылка В (&ВыбранныеКатегории) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ	КАК Пометка,
	|	ВЫБОР КОГДА Категории.Ссылка = &ОсновнаяКатегория ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ		КАК ЭтоОсновнаяКатегория,
	|	Категории.ЦветИндекс																КАК ЦветИндекс
	|ИЗ
	|	Справочник.CRM_Категории КАК Категории
	|ГДЕ
	|	НЕ Категории.ПометкаУдаления
	|");
	Запрос.УстановитьПараметр("ВыбранныеКатегории",	ОписаниеКатегорий.МассивКатегорий);
	Запрос.УстановитьПараметр("ОсновнаяКатегория",	ОписаниеКатегорий.ОсновнаяКатегория);
	Таблица = Запрос.Выполнить().Выгрузить();
	ЗначениеВРеквизитФормы(Таблица, "ТаблицаКатегории");
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПередЗакрытием".
//
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если Модифицированность Тогда
		Отказ = Истина;
		ОбратныйВызов = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОбратныйВызов,
			 НСтр("ru='Данные были изменены. Сохранить данные?';en='Data has been changed. Save data?'"),
			 РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик ответа на вопрос перед закрытием формы.
//
// Параметры:
//	Результат				- КодВозвратаДиалога	- Ответ на вопрос.
//	ДополнительныеПараметры	- Структура				- Структура дополнительных параметров.
//
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
		Если ПроверитьНаКорректностьЗаполнитьВозвращаемыеЗначения() Тогда
			ДанныеБылиИзменены = Истина;
			Модифицированность = Ложь;
			Результат = Новый Структура("СписокВыбранныеКатегории, ОсновнаяКатегория",
				 СписокВыбранныеКатегории,
				 ОсновнаяКатегория);
			Закрыть(Результат);
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность	= Ложь;
		Закрыть();
    КонецЕсли;
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти
