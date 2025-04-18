
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	КоманднаяПанель.ТолькоПросмотр = Истина;
	
	Заголовок = НСтр("ru='Сценарий';en='Script'") + ": " + Объект.Родитель.Наименование;
	
	Элементы.Используется.Видимость = НЕ ЗначениеЗаполнено(Объект.ВидСостояния);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если ТипЗнч(ТекущийОбъект.ПроверяемыеРеквизитыИнтереса.Получить()) = Тип("ФиксированныйМассив") Тогда
		МассивПроверяемыеРеквизиты = Новый Массив(ТекущийОбъект.ПроверяемыеРеквизитыИнтереса.Получить());
		ПроверяемыеРеквизитыИнтереса.ЗагрузитьЗначения(МассивПроверяемыеРеквизиты);
	КонецЕсли;
	
	Если ТипЗнч(ТекущийОбъект.БлокируемыеРеквизитыИнтереса.Получить()) = Тип("ФиксированныйМассив") Тогда
		МассивБлокируемыеРеквизиты = Новый Массив(ТекущийОбъект.БлокируемыеРеквизитыИнтереса.Получить());
		БлокируемыеРеквизитыИнтереса.ЗагрузитьЗначения(МассивБлокируемыеРеквизиты);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПроверяемыеРеквизитыИнтереса <> Неопределено Тогда
		ТекущийОбъект.ПроверяемыеРеквизитыИнтереса =
			Новый ХранилищеЗначения(Новый ФиксированныйМассив(ПроверяемыеРеквизитыИнтереса.ВыгрузитьЗначения()));
	КонецЕсли;
	Если БлокируемыеРеквизитыИнтереса <> Неопределено Тогда
		ТекущийОбъект.БлокируемыеРеквизитыИнтереса =
			Новый ХранилищеЗначения(Новый ФиксированныйМассив(БлокируемыеРеквизитыИнтереса.ВыгрузитьЗначения()));
	КонецЕсли;

	ТипСтр = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150));
	ИзмененныеОписания = Новый ТаблицаЗначений;
	ИзмененныеОписания.Колонки.Добавить("СтароеОписание", ТипСтр); 
	ИзмененныеОписания.Колонки.Добавить("НовоеОписание", ТипСтр); 
	Для каждого ЗадачаЧЛ Из Объект.ЧекЛист Цикл
		Если ЗначениеЗаполнено(ЗадачаЧЛ.СтароеОписание) И ЗадачаЧЛ.СтароеОписание <> ЗадачаЧЛ.ОписаниеЗадачи Тогда
			СтрИО = ИзмененныеОписания.Добавить();
			СтрИО.СтароеОписание = ЗадачаЧЛ.СтароеОписание;
			СтрИО.НовоеОписание = ЗадачаЧЛ.ОписаниеЗадачи;
		КонецЕсли;
	КонецЦикла;
	Если ИзмененныеОписания.Количество() > 0 Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ИзмененныеОписания.СтароеОписание КАК СтароеОписание,
		                      |	ИзмененныеОписания.НовоеОписание КАК НовоеОписание
		                      |ПОМЕСТИТЬ ИзмененныеОписанияВТ
		                      |ИЗ
		                      |	&ИзмененныеОписания КАК ИзмененныеОписания
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка,
		                      |	CRM_СостоянияИнтересовЧекЛист.ОписаниеЗадачи КАК СтароеОписание,
		                      |	ИзмененныеОписанияВТ.НовоеОписание КАК НовоеОписание
		                      |ИЗ
		                      |	Справочник.CRM_СостоянияИнтересов.ЧекЛист КАК CRM_СостоянияИнтересовЧекЛист
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
		                      |		ПО CRM_СостоянияИнтересовЧекЛист.Ссылка = CRM_СостоянияИнтересов.Ссылка
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИзмененныеОписанияВТ КАК ИзмененныеОписанияВТ
		                      |		ПО CRM_СостоянияИнтересовЧекЛист.ОписаниеЗадачи = ИзмененныеОписанияВТ.СтароеОписание
		                      |ГДЕ
		                      |	CRM_СостоянияИнтересов.Ссылка <> &Ссылка
		                      |	И CRM_СостоянияИнтересов.Родитель = &Родитель
		                      |ИТОГИ ПО
		                      |	Ссылка
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |УНИЧТОЖИТЬ ИзмененныеОписанияВТ");
		Запрос.УстановитьПараметр("Родитель", ТекущийОбъект.Родитель);
		Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
		Запрос.УстановитьПараметр("ИзмененныеОписания", ИзмененныеОписания);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			ТекущийОбъект.ДополнительныеСвойства.Вставить("СостоянияДляИзмененияЗадач",
				 Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство("СостоянияДляИзмененияЗадач") Тогда
		Для Каждого СтрСостояния Из ТекущийОбъект.ДополнительныеСвойства.СостоянияДляИзмененияЗадач.Строки Цикл
			ИзменяемыйОбъект = СтрСостояния.Ссылка.ПолучитьОбъект();
			Для каждого Задача Из СтрСостояния.Строки Цикл
				СтрЗадачи = ИзменяемыйОбъект.ЧекЛист.Найти(Задача.СтароеОписание, "ОписаниеЗадачи");
				Если СтрЗадачи <> Неопределено Тогда
					СтрЗадачи.ОписаниеЗадачи = Задача.НовоеОписание;
				КонецЕсли;
			КонецЦикла;
			ИзменяемыйОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзмененоСостояниеИнтереса", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиНажатие(Элемент)
	Настройки = Новый  Структура;
	Настройки.Вставить("ПроверяемыеРеквизитыИнтереса",
		 Новый ФиксированныйМассив(ПроверяемыеРеквизитыИнтереса.ВыгрузитьЗначения()));
	Настройки.Вставить("БлокируемыеРеквизитыИнтереса",
		 Новый ФиксированныйМассив(БлокируемыеРеквизитыИнтереса.ВыгрузитьЗначения()));
	Настройки.Вставить("ОбязательноеПланированиеАктивности", Объект.ОбязательноеПланированиеАктивности);
	Настройки.Вставить("ИнтерактивноеПланированиеАктивностей", Объект.ИнтерактивноеПланированиеАктивностей);
	Настройки.Вставить("ЗавершатьЗапланированныеАктивности", Объект.ЗавершатьЗапланированныеАктивности);
	Настройки.Вставить("ОтборЗавершаемыхАктивностей", Объект.ОтборЗавершаемыхАктивностей);
	Настройки.Вставить("УказыватьДостигнутыйРезультат", Объект.УказыватьДостигнутыйРезультат);
	Настройки.Вставить("РазрешитьРолевуюАдресацию", Объект.РазрешитьРолевуюАдресацию);
	Настройки.Вставить("РольОтветственного", Объект.РольОтветственного);
	Настройки.Вставить("ВидСостояния", Объект.ВидСостояния);
	Настройки.Вставить("ДобавитьВероятностьВПредставлениеСостояния", Объект.ДобавитьВероятностьВПредставлениеСостояния);
	Настройки.Вставить("ВероятностьСделки", Объект.ВероятностьСделки);
	Настройки.Вставить("ИндексЦвета", Объект.ИндексЦвета);
	Настройки.Вставить("ЭтоНовыйОбъект", Объект.Ссылка.Пустая());
	Настройки.Вставить("Родитель", Объект.Родитель);
	Настройки.Вставить("ИспользоватьЧекЛист", Объект.ИспользоватьЧекЛист);
	Настройки.Вставить("ПроверкаВыполненияЧекЛиста", Объект.ПроверкаВыполненияЧекЛиста);
	Настройки.Вставить("ЧекЛист", Объект.ЧекЛист);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеРедактированияНастроек", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура("Настройки", Настройки);
	ОткрытьФорму("Справочник.CRM_СостоянияИнтересов.Форма.ФормаНастройкиСостояния", ПараметрыОткрытия,
		 ЭтотОбъект, , , , ОписаниеОповещения,
		 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ИндексЦветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповещениеНовое = Новый ОписаниеОповещения("ЦветНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ТекущийЦвет", Объект.ИндексЦвета);
	ФормаВыбораЦвета = ОткрытьФорму("Справочник.CRM_Категории.Форма.ФормаВыбораЦвета", ПараметрыФормы, Элемент, , , ,
		ОповещениеНовое, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры // ЦветНачалоВыбора()

&НаКлиенте
// Продолжение процедуры "ЦветНачалоВыбора"
//
Процедура ЦветНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ (Результат = Неопределено) И НЕ (Результат = КодВозвратаДиалога.Отмена) Тогда
		Объект.ИндексЦвета = Результат[0].Картинка;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Справка(Команда)
	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("НастройкаСценариевПродажи"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершениеРедактированияНастроек(Настройки, ДопПараметры) Экспорт
	
	Если Настройки <> Неопределено Тогда
		ЗаполнитьДанныеИзНастроек(Настройки);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеИзНастроек(Настройки)
	
	ЗаполнитьЗначенияСвойств(Объект, Настройки, , "ЧекЛист");
	Если ТипЗнч(Настройки.ПроверяемыеРеквизитыИнтереса) = Тип("ФиксированныйМассив") Тогда
		МассивПроверяемыеРеквизиты = Новый Массив(Настройки.ПроверяемыеРеквизитыИнтереса);
		ПроверяемыеРеквизитыИнтереса.ЗагрузитьЗначения(МассивПроверяемыеРеквизиты);
	КонецЕсли;
	Если ТипЗнч(Настройки.БлокируемыеРеквизитыИнтереса) = Тип("ФиксированныйМассив") Тогда
		МассивБлокируемыеРеквизиты = Новый Массив(Настройки.БлокируемыеРеквизитыИнтереса);
		БлокируемыеРеквизитыИнтереса.ЗагрузитьЗначения(МассивБлокируемыеРеквизиты);
	КонецЕсли;
	Если Настройки.Свойство("ЧекЛист") Тогда
		Объект.ЧекЛист.Загрузить(Настройки.ЧекЛист.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
