#Область СлужебныеПроцедурыИФункции

// Отключает режим записи логов.
// 
Процедура ОтключитьЛогированиеЗапросов() Экспорт
	
	ПараметрыЛогирования                 = ПараметрыЛогированияЗапросов();
	ПараметрыЛогирования.Включено        = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Возвращает текствое описание текущего окружения и параметров.
// 
// Возвращаемое значение:
// 	Строка - Текстовое описание текущего окружения.
Функция ИнформацияОбОкружении() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеОкружения = Новый Массив();
	
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииШапка(ДанныеОкружения);
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			"%1: %2",
			Метаданные.Константы.РежимРаботыСТестовымКонтуромСАТУРН.Синоним,
			ИнтеграцияСАТУРНКлиентСервер.РежимРаботыСТестовымКонтуромСАТУРН()));
	
	ПараметрыОптимизации = ИнтеграцияСАТУРНСлужебный.ПараметрыОптимизации();
	
	СинонимыПараметровОптимизации = ИнтеграцияСАТУРНПовтИсп.ПредставленияНастроекОптимизации();
	
	Для Каждого КлючИЗначение Из ПараметрыОптимизации Цикл
		
		Если КлючИЗначение.Ключ = "АвторизацияHTTPТестовыйКонтурЛогин"
			Или КлючИЗначение.Ключ = "АвторизацияHTTPТестовыйКонтурПароль" Тогда
			Продолжить;
		КонецЕсли;
		
		ПредставлениеПараметра = СинонимыПараметровОптимизации.Получить(КлючИЗначение.Ключ);
		Если ПредставлениеПараметра = Неопределено Тогда
			ПредставлениеПараметра = ОбщегоНазначенияИСКлиентСервер.ПредставлениеВстроенногоИмени(КлючИЗначение.Ключ);
		КонецЕсли;
		
		ДанныеОкружения.Добавить(
			СтрШаблон(
				"%1: %2%3",
				ПредставлениеПараметра,
				Формат(КлючИЗначение.Значение, "ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да;")));
		
	КонецЦикла;
	
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииПодвал(ДанныеОкружения);
	
	Возврат СтрСоединить(ДанныеОкружения, Символы.ПС);
	
КонецФункции

// Получает текущие параметры логирования.
// 
// Возвращаемое значение:
// 	см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов.
Функция ПараметрыЛогированияЗапросов() Экспорт
	
	Возврат ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов("ПараметрыЛогированияЗапросовСАТУРН");
	
КонецФункции

// Выполняет запись HTTP запроса / ответа в файл логирования в формат протокола обмена, если запись лога включена.
// 
// Параметры:
// 	РезультатЗапроса - см. ЛогированиеЗапросовИС.НоваяСтруктураДанныхЗаписи.
Процедура ВывестиДанныеДляПротоколаОбмена(РезультатЗапроса) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	Если Не ЛогированиеЗапросовИС.ВыполняетсяЛогированиеЗапросовДляПротоколаОбмена(ПараметрыЛогирования) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПротоколОбмена", Неопределено);
	
	ПротоколОбмена = ИнтеграцияСАТУРНСлужебный.ИнициализироватьТаблицуПротоколОбмена();
	Результат.ПротоколОбмена = ПротоколОбмена;
	
	ПараметрыОтправкиHTTPЗапросов = РезультатЗапроса.ПараметрыОтправкиHTTPЗапросов;
	HTTPМетод                     = РезультатЗапроса.HTTPМетод;
	HTTPЗапрос                    = РезультатЗапроса.HTTPЗапрос;
	HTTPОтвет                     = РезультатЗапроса.HTTPОтвет;
	
	ЗапросЗаголовки = Новый Массив;
	Для Каждого КлючИЗначение Из HTTPЗапрос.Заголовки Цикл
		ЗапросЗаголовки.Добавить(
			СтрШаблон("%1: %2", КлючИЗначение.Ключ, КлючИЗначение.Значение));
	КонецЦикла;
	
	ЗаписьПротокола = ПротоколОбмена.Добавить();
	ЗаписьПротокола.ДатаУниверсальная = ТекущаяУниверсальнаяДата();
	ЗаписьПротокола.Запрос            = ИнтеграцияСАТУРНСлужебный.URLЗапроса(HTTPЗапрос, ПараметрыОтправкиHTTPЗапросов, HTTPМетод);
	ЗаписьПротокола.ЗапросЗаголовки   = СтрСоединить(ЗапросЗаголовки, Символы.ПС);
	ЗаписьПротокола.ЗапросТело        = HTTPЗапрос.ПолучитьТелоКакСтроку();
	
	Если HTTPОтвет <> Неопределено Тогда
		
		ЗаписьПротокола.ОтветЗаголовки = ИнтеграцияСАТУРНСлужебный.ЗаголовкиИзHTTPОтвета(HTTPОтвет);
		
		Если ТипЗнч(HTTPОтвет) = Тип("Структура") Тогда
			ЗаписьПротокола.ОтветТело = HTTPОтвет.Тело;
		Иначе
			ЗаписьПротокола.ОтветТело = HTTPОтвет.ПолучитьТелоКакСтроку();
		КонецЕсли;
		
		ЗаписьПротокола.КодСостояния = Строка(HTTPОтвет.КодСостояния);
		
		Если РезультатЗапроса.Свойство("ТекстОшибки")
			И Не ЗначениеЗаполнено(ЗаписьПротокола.ОтветТело) Тогда
			ЗаписьПротокола.ОтветТело = РезультатЗапроса.ТекстОшибки;
		КонецЕсли;
		
	Иначе
		ЗаписьПротокола.ОтветТело = РезультатЗапроса.ТекстОшибки;
	КонецЕсли;
	
	ТекущийИдентификатор = ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена;
	ФайлыПротокола = ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Получить(ТекущийИдентификатор);
	Если ФайлыПротокола = Неопределено Тогда
		ФайлыПротокола = Новый Массив;
	КонецЕсли;
	//@skip-check missing-temporary-file-deletion
	ИмяФайла = ПолучитьИмяВременногоФайла(".log");
	ФайлыПротокола.Добавить(ИмяФайла);
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8,, Ложь);
	ЗаписьТекста.ЗаписатьСтроку(ОбщегоНазначения.ЗначениеВСтрокуXML(Результат));
	ЗаписьТекста.Закрыть();
	
	ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена[ТекущийИдентификатор] = ФайлыПротокола;
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Сохраняет параметры логирования в параметр сеанса.
// 
// Параметры:
// 	ПараметрыЛогирования - см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов.
Процедура УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования) Экспорт
	
	ПараметрыСеанса.ПараметрыЛогированияЗапросовСАТУРН = ОбщегоНазначения.ФиксированныеДанные(ПараметрыЛогирования);
	
КонецПроцедуры

// Дописывает полученные данные лога запросов в текущий уровень логирования.
// 
// Параметры:
// 	ДанныеДокумента - Структура:
// 	* ДанныеЛогаЗапросов - Строка - Данные для записи в лог запросовю
Процедура ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента) Экспорт
	
	ЛогированиеЗапросовИС.ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента, ПараметрыЛогированияЗапросов());
	
КонецПроцедуры

#КонецОбласти
