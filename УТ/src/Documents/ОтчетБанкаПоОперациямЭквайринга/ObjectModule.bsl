#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ДоговорЭквайринга") Тогда
		ЗаполнитьПоДоговоруЭквайринга(ДанныеЗаполнения.ДоговорЭквайринга, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ДоговорЭквайринга")
		И Не ЗначениеЗаполнено(ДанныеЗаполнения.ДоговорЭквайринга) И ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
		ЗаполнитьПоДоговоруЭквайринга(ДоговорЭквайринга, ДанныеЗаполнения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетБанкаПоОперациямЭквайринга.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ЗаполнитьИтоговыеСуммы();
	
	Если Не ДетальнаяСверкаТранзакций Тогда
		Покупки.Очистить();
		Возвраты.Очистить();
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Покупки,Возвраты");
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетБанкаПоОперациямЭквайринга.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СуммаКомиссии = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	Если Не ДетальнаяСверкаТранзакций Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Покупки");
		МассивНепроверяемыхРеквизитов.Добавить("Возвраты");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорЭквайринга)
		И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорЭквайринга, "ИспользуютсяЭквайринговыеТерминалы") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Покупки.ЭквайринговыйТерминал");
		МассивНепроверяемыхРеквизитов.Добавить("Возвраты.ЭквайринговыйТерминал");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
		
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетБанкаПоОперациямЭквайринга.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Покупки,Возвраты");
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьПоДоговоруЭквайринга(Договор, ДанныеЗаполнения)

	ЗначенияРеквизитов = Справочники.ДоговорыЭквайринга.РеквизитыДоговора(Договор);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Валюта");
	ДанныеЗаполнения.Вставить("ОтражатьКомиссию", ЗначенияРеквизитов.СпособОтраженияКомиссии = Перечисления.СпособыОтраженияЭквайринговойКомиссии.ВОтчете);
	
	Если ДанныеЗаполнения.ОтражатьКомиссию Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "СтатьяРасходов, АналитикаРасходов");
		Подразделение = ЗначенияРеквизитов.ПодразделениеРасходов;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьИтоговыеСуммы()
	
	РасчетСуммаПокупок = Покупки.Итог("Сумма");
	Если СуммаПокупок <> РасчетСуммаПокупок Тогда
		СуммаПокупок = РасчетСуммаПокупок;
	КонецЕсли;
	
	РасчетСуммаВозвратов = Возвраты.Итог("Сумма");
	Если СуммаВозвратов <> РасчетСуммаВозвратов Тогда
		СуммаВозвратов = РасчетСуммаВозвратов;
	КонецЕсли;
	
	Если ДетальнаяСверкаТранзакций Тогда
		РасчетСуммаДокумента = СуммаПокупок - СуммаВозвратов - СуммаКомиссии;
	Иначе
		РасчетСуммаДокумента = СуммаКомиссии;
	КонецЕсли;
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
