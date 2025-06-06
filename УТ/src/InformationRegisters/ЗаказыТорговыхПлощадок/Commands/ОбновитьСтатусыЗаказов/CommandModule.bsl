#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ОчиститьСообщения();
	
	ЕстьУчетнаяЗапись =
		ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыВыполненияКоманды.Источник, "УчетнаяЗапись");
	Если Не ЕстьУчетнаяЗапись Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не предусмотрено обновление статусов заказов из этого источника.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("УчетнаяЗапись", ПараметрыВыполненияКоманды.Источник.УчетнаяЗапись);
	ПараметрыЗадания.Вставить("Форма", ПараметрыВыполненияКоманды.Источник);
	
	Если ПараметрыЗадания.Форма.Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Нет заказов для обновления статусов.'"));
		Возврат;
	Иначе
		ТолькоВыделенные = Истина;
	КонецЕсли;
	
	ЗапуститьОбновлениеСтатусовЗаказов(ПараметрыЗадания, ТолькоВыделенные);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапуститьОбновлениеСтатусовЗаказов(Параметры, ТолькоВыделенные = Ложь)

	ВыделенныеСтроки = ?(ТолькоВыделенные, Параметры.Форма.Элементы.Список.ВыделенныеСтроки, Неопределено);
	
	Если ВыделенныеСтроки = Неопределено Тогда
		ТекстОжидания = НСтр("ru = 'Выполняется обновление статусов незавершенных заказов.'");
	Иначе
		ТекстОжидания  = НСтр("ru = 'Выполняется обновление статусов выделенных заказов.'");
	КонецЕсли;
	
	ДанныеУчетнойЗаписи = Новый Структура;
	ДанныеУчетнойЗаписи.Вставить("УчетнаяЗапись", Параметры.УчетнаяЗапись);
	ДанныеУчетнойЗаписи.Вставить("ВидМаркетплейса", ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.ПустаяСсылка"));
	
	ДлительнаяОперация = ОбновитьСтатусыЗаказов(
		ДанныеУчетнойЗаписи,
		Параметры.Форма.УникальныйИдентификатор,
		ВыделенныеСтроки);
	
	ВидМаркетплейса = ДанныеУчетнойЗаписи.ВидМаркетплейса;
	
	Логотип = ИнтеграцияСМаркетплейсамиКлиентСервер.ЛоготипТорговойПлощадки(ВидМаркетплейса);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Параметры.Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ТекстСообщения = ТекстОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Текст = ВидМаркетплейса;
	ПараметрыОжидания.ОповещениеПользователя.Пояснение =
		НСтр("ru = 'Завершено фоновое обновление статусов заказов.'");
	ПараметрыОжидания.ОповещениеПользователя.НавигационнаяСсылка = "";
	ПараметрыОжидания.ОповещениеПользователя.Картинка = Логотип;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьСтатусыЗаказовЗавершение",
		ЭтотОбъект,
		Параметры.Форма);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ОбновитьСтатусыЗаказов(ДанныеУчетнойЗаписи, Знач ИдентификаторФормы, Знач ВыделенныеСтроки)

	ДанныеУчетнойЗаписи.ВидМаркетплейса =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеУчетнойЗаписи.УчетнаяЗапись, "ВидМаркетплейса");
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Ozon. Обновление статусов заказов.'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	ИмяМетода = "ИнтеграцияСМаркетплейсамиСервер.ОбновитьСтатусыЗаказовСТорговойПлощадки";
	
	Если ВыделенныеСтроки = Неопределено Тогда
		Заказы = Неопределено;
	Иначе
		Заказы = Новый Массив;
		Для Каждого ДанныеВыделеннойСтроки Из ВыделенныеСтроки Цикл
			Заказы.Добавить(ДанныеВыделеннойСтроки.Заказ);
		КонецЦикла;
	КонецЕсли;
	
	Если ДанныеУчетнойЗаписи.ВидМаркетплейса = Перечисления.ВидыМаркетплейсов.МаркетплейсOzon Тогда
		ПараметрыФункции = Новый Структура;
		ПараметрыФункции.Вставить("НачалоПериода",       Неопределено);
		ПараметрыФункции.Вставить("ОкончаниеПериода",    Неопределено);
		ПараметрыФункции.Вставить("ИдентификаторЗаказа", Неопределено);
		ПараметрыФункции.Вставить("Заказ",               Заказы);
	Иначе
		ПараметрыФункции = Новый Структура;
	КонецЕсли;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода,
		ДанныеУчетнойЗаписи.УчетнаяЗапись,
		ПараметрыФункции);

КонецФункции

&НаКлиенте
// Обработка оповещения обновления статусов.
//
// Параметры:
//   РезультатЗадания - см. ДлительныеОперации.ВыполнитьВФоне.
//   ДополнительныеПараметры - Произвольный - дополнительные параметры оповещения.
//
Процедура ОбновитьСтатусыЗаказовЗавершение(РезультатЗадания, ДополнительныеПараметры) Экспорт

	Если РезультатЗадания <> Неопределено Тогда
		Если РезультатЗадания.Статус = "Ошибка" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗадания.ПодробноеПредставлениеОшибки);
			
		ИначеЕсли РезультатЗадания.Статус = "Выполнено" Тогда
			Ошибка = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
			УдалитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
			
			ИнтеграцияСМаркетплейсамиКлиент.ВывестиСостояние(Ошибка, Неопределено, Истина);
			
			Форма = ДополнительныеПараметры; // ФормаКлиентскогоПриложения
			Форма.Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
