#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Процедура выполняет заполнение предопределенных элементов справочника.
//
// Параметры:
//	Нет.
//
Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	
	// Сценарий по умолчанию
	Сценарий = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	Сценарий.Наименование = НСтр("ru='Продажа';en='Sale'");
	Сценарий.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	Сценарий.ДополнительныеСвойства.Вставить("НеСоздаватьОбязательные", Истина);
	Сценарий.ДополнительныеСвойства.Вставить("НеОбновлятьВоронкуПродаж", Истина);
	Сценарий.ИдентификаторПредопределенногоЭлемента = "445f4824-5aa6-41ca-b0ab-947f8daf7d17";
	Сценарий.Записать();
	
	Воронка = Справочники.CRM_ВоронкиПродаж.Интересы.ПолучитьОбъект();
	Воронка.СценарийИнтереса = Сценарий.Ссылка;
	Воронка.Записать();
	
	// Элемент "ПервичныйИнтерес"
	ЭлементСправочника = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	ЭлементСправочника.Родитель					= Сценарий.Ссылка;
	ЭлементСправочника.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.Первое;
	ЭлементСправочника.Наименование = НСтр("ru='Переговоры';en='Negotiations'");
	ЭлементСправочника.ВероятностьСделки			= 10;
	ЭлементСправочника.ВидДела						= Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	ЭлементСправочника.Завершено					= Ложь;
	ЭлементСправочника.Используется					= Истина;
	ЭлементСправочника.ОбязательноеПланированиеАктивности =
		Перечисления.CRM_ПланируемыеТипыАктивности.ВзаимодействиеИлиЗадача;
	ЭлементСправочника.ИдентификаторПредопределенногоЭлемента = "95829933-6e17-4f3d-bcc2-39972430f2e0";
	ЭлементСправочника.ИндексЦвета = 16;
	ЭлементСправочника.Записать();
	
	// Элемент "Предложение"
	ЭлементСправочника = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	ЭлементСправочника.Родитель					= Сценарий.Ссылка;
	ЭлементСправочника.Наименование = НСтр("ru='Счет';en='Account'");
	ЭлементСправочника.ВероятностьСделки			= 60;
	ЭлементСправочника.ВидДела						= Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	ЭлементСправочника.Завершено					= Ложь;
	ЭлементСправочника.Используется					= Истина;
	ЭлементСправочника.ОбязательноеПланированиеАктивности =
		Перечисления.CRM_ПланируемыеТипыАктивности.ВзаимодействиеИлиЗадача;
	ЭлементСправочника.ИдентификаторПредопределенногоЭлемента = "6965b336-b89d-4a4a-81eb-9db37d0dd087";
	ЭлементСправочника.ИндексЦвета = 22;
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Партнер");
	ЭлементСправочника.ПроверяемыеРеквизитыИнтереса =
		Новый ХранилищеЗначения(Новый ФиксированныйМассив(ПроверяемыеРеквизиты));
	ЭлементСправочника.Записать();
	
	// Элемент "ВыполнениеДоговора"
	ЭлементСправочника = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	ЭлементСправочника.Родитель					= Сценарий.Ссылка;
	ЭлементСправочника.Наименование = НСтр("ru='Отгрузка';en='Shipment'");
	ЭлементСправочника.ВероятностьСделки			= 100;
	ЭлементСправочника.ВидДела						= Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	ЭлементСправочника.Завершено					= Ложь;
	ЭлементСправочника.Используется					= Истина;
	ЭлементСправочника.ОбязательноеПланированиеАктивности =
		Перечисления.CRM_ПланируемыеТипыАктивности.ВзаимодействиеИлиЗадача;
	ЭлементСправочника.ИдентификаторПредопределенногоЭлемента = "b1bdc813-af6d-4103-86a2-77d73c84eae3";
	ЭлементСправочника.ИндексЦвета = 4;
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Партнер");
	ЭлементСправочника.ПроверяемыеРеквизитыИнтереса =
		Новый ХранилищеЗначения(Новый ФиксированныйМассив(ПроверяемыеРеквизиты));
	ЭлементСправочника.Записать();
	
	// Элемент "ИнтересЗакрыт"
	ЭлементСправочника = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	ЭлементСправочника.Родитель					= Сценарий.Ссылка;
	ЭлементСправочника.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение;
	ЭлементСправочника.Наименование = НСтр("ru='Завершен успешно';en='Finished successfully'");
	ЭлементСправочника.ВероятностьСделки			= 100;
	ЭлементСправочника.ВидДела						= Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	ЭлементСправочника.Завершено					= Истина;
	ЭлементСправочника.Используется					= Истина;
	ЭлементСправочника.ЗавершатьЗапланированныеАктивности =
		Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
	ЭлементСправочника.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
	ЭлементСправочника.РеквизитДопУпорядочивания	= 98;
	ЭлементСправочника.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
	ЭлементСправочника.ИдентификаторПредопределенногоЭлемента = "e9477c0f-e2f9-476b-8c82-122c95f87514";
	ЭлементСправочника.ИндексЦвета = 19;
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Партнер");
	ЭлементСправочника.ПроверяемыеРеквизитыИнтереса =
		Новый ХранилищеЗначения(Новый ФиксированныйМассив(ПроверяемыеРеквизиты));
	ЭлементСправочника.Записать();
	
	// Элемент "ИнтересПотерян"
	ЭлементСправочника = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	ЭлементСправочника.Родитель					= Сценарий.Ссылка;
	ЭлементСправочника.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.НеудачноеЗавершение;
	ЭлементСправочника.Наименование = НСтр("ru='Завершен неудачно';en='Unsuccessful'");
	ЭлементСправочника.ВероятностьСделки			= 0;
	ЭлементСправочника.ВидДела						= Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	ЭлементСправочника.Завершено					= Истина;
	ЭлементСправочника.Используется					= Истина;
	ЭлементСправочника.ЗавершатьЗапланированныеАктивности =
		Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
	ЭлементСправочника.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
	ЭлементСправочника.РеквизитДопУпорядочивания	= 99;
	ЭлементСправочника.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
	ЭлементСправочника.ИдентификаторПредопределенногоЭлемента = "48f2b1da-3a47-4602-961e-d1aef3701d95";
	ЭлементСправочника.ИндексЦвета = 15;
	ЭлементСправочника.Записать();
	
	СоздатьСценарийПоддержкиПоУмолчанию(Новый Структура("ОбработкаЗавершена", Ложь));
	
КонецПроцедуры // ЗаполнитьПредопределенныеЭлементы()

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.ДобавитьВероятностьВПредставлениеСостояния = Истина И ЗначениеЗаполнено(Данные.ВероятностьСделки) Тогда
		Представление = Данные.Наименование + " (" + Данные.ВероятностьСделки + "%)";
	Иначе
		Представление = Данные.Наименование;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Наименование");
	Поля.Добавить("ВероятностьСделки");
	Поля.Добавить("ДобавитьВероятностьВПредставлениеСостояния");

КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("Ключ") Тогда
		СтандартнаяОбработка = Ложь;
		Если НЕ ЗначениеЗаполнено(Параметры.Ключ.Родитель) Тогда
			ВыбраннаяФорма = "Справочник.CRM_СостоянияИнтересов.Форма.ФормаЭлементаСценария";
		Иначе
			ВыбраннаяФорма = "Справочник.CRM_СостоянияИнтересов.Форма.ФормаЭлемента";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьОбязательныеСостоянияСценария(Сценарий, ЭтоПоддержка = Ложь) Экспорт
	
	Если ЭтоПоддержка Тогда
		СоздатьОбязательныеСостоянияСценарияПоддержки(Сценарий);
	Иначе
		СоздатьОбязательныеСостоянияСценарияПродажи(Сценарий);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьОбязательныеСостоянияСценарияПродажи(Сценарий)
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='Переговоры';en='Negotiations'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Ложь;
	НовыйЭлемент.РеквизитДопУпорядочивания = 1;
	НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.Первое;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.ОбязательноеПланированиеАктивности = Перечисления.CRM_ПланируемыеТипыАктивности.ВзаимодействиеИлиЗадача;
	НовыйЭлемент.Записать();
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='Завершен успешно';en='Finished successfully'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Истина;
	НовыйЭлемент.РеквизитДопУпорядочивания = 98;
	НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.ВероятностьСделки = 100;
	НовыйЭлемент.ЗавершатьЗапланированныеАктивности = Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
	НовыйЭлемент.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
	НовыйЭлемент.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("ОжидаемаяВыручка");
	ПроверяемыеРеквизиты.Добавить("Партнер");
	НовыйЭлемент.ПроверяемыеРеквизитыИнтереса = Новый ХранилищеЗначения(ПроверяемыеРеквизиты);
	НовыйЭлемент.Записать();
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='Завершен неудачно';en='Unsuccessful'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Истина;
	НовыйЭлемент.РеквизитДопУпорядочивания = 99;
	НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.НеудачноеЗавершение;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.ВероятностьСделки = 0;
	НовыйЭлемент.ЗавершатьЗапланированныеАктивности = Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
	НовыйЭлемент.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
	НовыйЭлемент.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
	НовыйЭлемент.Записать();
	
КонецПроцедуры

Процедура СоздатьОбязательныеСостоянияСценарияПоддержки(Сценарий)
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='К выполнению'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Ложь;
	НовыйЭлемент.РеквизитДопУпорядочивания = 1;
	НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.Первое;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.КВыполнению;
	НовыйЭлемент.Записать();
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='В работе'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Ложь;
	НовыйЭлемент.РеквизитДопУпорядочивания = 2;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.ВРаботе;
	НовыйЭлемент.Записать();
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru='В ожидании'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Ложь;
	НовыйЭлемент.РеквизитДопУпорядочивания = 3;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.ВОжидании;
	НовыйЭлемент.Записать();
	
	НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
	НовыйЭлемент.Родитель = Сценарий;
	НовыйЭлемент.Наименование = НСтр("ru = 'Выполнено'");
	НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
	НовыйЭлемент.Завершено = Истина;
	НовыйЭлемент.РеквизитДопУпорядочивания = 99;
	НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение;
	НовыйЭлемент.Используется = Истина;
	НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.Выполнено;
	НовыйЭлемент.ЗавершатьЗапланированныеАктивности = Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
	НовыйЭлемент.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
	НовыйЭлемент.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Партнер");
	НовыйЭлемент.ПроверяемыеРеквизитыИнтереса = Новый ХранилищеЗначения(ПроверяемыеРеквизиты);
	НовыйЭлемент.Записать();
	
КонецПроцедуры

Функция ПервичноеСостояниеСценария(Сценарий) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |ГДЕ
	                      |	CRM_СостоянияИнтересов.ВидСостояния = &ВидСостояния
	                      |	И CRM_СостоянияИнтересов.Родитель = &Родитель");
	
	Запрос.УстановитьПараметр("Родитель", Сценарий);
	Запрос.УстановитьПараметр("ВидСостояния", Перечисления.CRM_ВидыСостоянияИнтереса.Первое);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе	
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция УспешноеЗавершениеСценария(Сценарий) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |ГДЕ
	                      |	CRM_СостоянияИнтересов.ВидСостояния = &ВидСостояния
	                      |	И CRM_СостоянияИнтересов.Родитель = &Родитель");
	
	Запрос.УстановитьПараметр("Родитель", Сценарий);
	Запрос.УстановитьПараметр("ВидСостояния", Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе	
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция НеудачноеЗавершениеСценария(Сценарий) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |ГДЕ
	                      |	CRM_СостоянияИнтересов.ВидСостояния = &ВидСостояния
	                      |	И CRM_СостоянияИнтересов.Родитель = &Родитель");
	
	Запрос.УстановитьПараметр("Родитель", Сценарий);
	Запрос.УстановитьПараметр("ВидСостояния", Перечисления.CRM_ВидыСостоянияИнтереса.НеудачноеЗавершение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе	
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция МассивСостоянийПоСценарию(Сценарий) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |ГДЕ
	                      |	CRM_СостоянияИнтересов.Родитель = &Родитель");
	Запрос.УстановитьПараметр("Родитель", Сценарий);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

Процедура УстановитьЦветаСостояниям() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СостоянияИнтересов.Родитель КАК Родитель,
	                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка,
	                      |	CRM_СостоянияИнтересов.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	                      |ИЗ
	                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
	                      |ГДЕ
	                      |	CRM_СостоянияИнтересов.Родитель <> ЗНАЧЕНИЕ(Справочник.CRM_СостоянияИнтересов.ПустаяСсылка)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	РеквизитДопУпорядочивания
	                      |ИТОГИ ПО
	                      |	Родитель");
	ВыборкаРодитель = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СписокЦветовПоУмолчанию = CRM_ОбщегоНазначенияКлиентСервер.ПолучитьСписокЦветовПоУмолчанию();
	Пока ВыборкаРодитель.Следующий() Цикл
		Индекс = 0;
		Выборка = ВыборкаРодитель.Выбрать();
		Пока Выборка.Следующий() Цикл
			Состояние = Выборка.Ссылка.ПолучитьОбъект();
			Если Состояние.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение Тогда
				Состояние.ИндексЦвета = 19;
			ИначеЕсли Состояние.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.НеудачноеЗавершение Тогда
				Состояние.ИндексЦвета = 22;
			Иначе
				Если Индекс > 7 Тогда
					Состояние.ИндексЦвета = 17;
				Иначе
					Состояние.ИндексЦвета = СписокЦветовПоУмолчанию[Индекс].Значение;
				КонецЕсли;
				Индекс = Индекс + 1;
			КонецЕсли;
			Состояние.Записать();
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#Область КопированиеСценария

Функция СкопироватьСценарий(КопируемыйСценарий) Экспорт
	
	НачатьТранзакцию();
	Попытка
		// Сценарий
		НовСценарийОбъект = КопируемыйСценарий.Скопировать();
		НовСценарийОбъект.Наименование = КопируемыйСценарий.Наименование + " - " + НСтр("ru = 'копия'");
		НовСценарийОбъект.ДополнительныеСвойства.Вставить("НеСоздаватьОбязательные", Истина);	
		НовСценарийОбъект.Записать();
		
		НовСценарий = НовСценарийОбъект.Ссылка;
		
		// Состояния интереса
		СоответствиеСостояний = Новый Соответствие;
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	CRM_СостоянияИнтересов.Ссылка КАК Ссылка,
		                      |	CRM_СостоянияИнтересов.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		                      |ИЗ
		                      |	Справочник.CRM_СостоянияИнтересов КАК CRM_СостоянияИнтересов
		                      |ГДЕ
		                      |	НЕ CRM_СостоянияИнтересов.ПометкаУдаления
		                      |	И CRM_СостоянияИнтересов.Родитель = &Сценарий
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	CRM_СостоянияИнтересов.РеквизитДопУпорядочивания");
		Запрос.УстановитьПараметр("Сценарий", КопируемыйСценарий);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НовСостояниеОбъект = Выборка.Ссылка.Скопировать();
			НовСостояниеОбъект.Родитель = НовСценарий;
			НовСостояниеОбъект.РеквизитДопУпорядочивания = Выборка.РеквизитДопУпорядочивания;
			НовСостояниеОбъект.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
			НовСостояниеОбъект.Записать();
			
			СоответствиеСостояний.Вставить(Выборка.Ссылка, НовСостояниеОбъект.Ссылка);
		КонецЦикла;
		
		// Триггеры сценария
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	CRM_Триггеры.Ссылка КАК Ссылка,
		|	CRM_Триггеры.ПредставлениеНастроекДействия КАК ПредставлениеНастроекДействия,
		|	CRM_Триггеры.ПредставлениеНастроекУсловия КАК ПредставлениеНастроекУсловия
		|ИЗ
		|	Справочник.CRM_Триггеры КАК CRM_Триггеры
		|ГДЕ
		|	CRM_Триггеры.СценарийКарта = &Сценарий
		|	И НЕ CRM_Триггеры.ПометкаУдаления
		|	И CRM_Триггеры.СостояниеИнтереса = ЗНАЧЕНИЕ(Справочник.CRM_СостоянияИнтересов.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	CRM_Триггеры.Ссылка,
		|	CRM_Триггеры.ПредставлениеНастроекДействия,
		|	CRM_Триггеры.ПредставлениеНастроекУсловия
		|ИЗ
		|	Справочник.CRM_Триггеры КАК CRM_Триггеры
		|ГДЕ
		|	CRM_Триггеры.СценарийКарта = &Сценарий
		|	И НЕ CRM_Триггеры.ПометкаУдаления
		|	И НЕ CRM_Триггеры.СостояниеИнтереса = ЗНАЧЕНИЕ(Справочник.CRM_СостоянияИнтересов.ПустаяСсылка)
		|	И НЕ CRM_Триггеры.СостояниеИнтереса.ПометкаУдаления");
		
		Запрос.УстановитьПараметр("Сценарий", КопируемыйСценарий);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НовТриггерОбъект = Выборка.Ссылка.Скопировать();
			НовТриггерОбъект.СценарийКарта = НовСценарий;
			Если ЗначениеЗаполнено(НовТриггерОбъект.СостояниеИнтереса) Тогда
				ТекСостояние = СоответствиеСостояний.Получить(НовТриггерОбъект.СостояниеИнтереса);
				Если ТекСостояние = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				НовТриггерОбъект.СостояниеИнтереса = ТекСостояние;
			КонецЕсли;
			НовТриггерОбъект.ПредставлениеНастроекДействия = Выборка.ПредставлениеНастроекДействия;
			НовТриггерОбъект.ПредставлениеНастроекУсловия = Выборка.ПредставлениеНастроекУсловия;
			НовТриггерОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось скопировать текущий сценарий!'"));
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат НовСценарий;
	
КонецФункции

#КонецОбласти

#Область ПереходНаНовуюВерсию

Процедура СоздатьСценарийПоддержкиПоУмолчанию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Попытка
	
		НаименованиеСценарияПоддержки = НСтр("ru = 'Поддержка'");
		РезультатПоискаСценария = Справочники.CRM_СостоянияИнтересов.НайтиПоНаименованию(НаименованиеСценарияПоддержки,
			 Истина,
			 Справочники.CRM_СостоянияИнтересов.ПустаяСсылка());
		Если НЕ ЗначениеЗаполнено(РезультатПоискаСценария) Тогда
		
			СценарийОб = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
			СценарийОб.Наименование = НаименованиеСценарияПоддержки;
			СценарийОб.ЭтоПоддержка = Истина;
			СценарийОб.ДополнительныеСвойства.Вставить("НеСоздаватьОбязательные", Истина);
			СценарийОб.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
			НС_ТипыОбращений = СценарийОб.ТипыОбращений.Добавить();
			НС_ТипыОбращений.ТипОбращения = Справочники.CRM_ТипыОбращений.Обращение;
			СценарийОб.Записать();
			Сценарий = СценарийОб.Ссылка;
			
			НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
			НовыйЭлемент.Родитель = Сценарий;
			НовыйЭлемент.Наименование = НСтр("ru='К выполнению'");
			НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
			НовыйЭлемент.Завершено = Ложь;
			НовыйЭлемент.РеквизитДопУпорядочивания = 1;
			НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.Первое;
			НовыйЭлемент.Используется = Истина;
			НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.КВыполнению;
			НовыйЭлемент.ИндексЦвета = 16; // темно-оранжевый
			НовыйЭлемент.Записать();
			
			НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
			НовыйЭлемент.Родитель = Сценарий;
			НовыйЭлемент.Наименование = НСтр("ru='В работе'");
			НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
			НовыйЭлемент.Завершено = Ложь;
			НовыйЭлемент.РеквизитДопУпорядочивания = 2;
			НовыйЭлемент.Используется = Истина;
			НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.ВРаботе;
			НовыйЭлемент.ИндексЦвета = 22; // темно-синий
			НовыйЭлемент.Записать();
			
			НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
			НовыйЭлемент.Родитель = Сценарий;
			НовыйЭлемент.Наименование = НСтр("ru='В ожидании'");
			НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
			НовыйЭлемент.Завершено = Ложь;
			НовыйЭлемент.РеквизитДопУпорядочивания = 3;
			НовыйЭлемент.Используется = Истина;
			НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.ВОжидании;
			НовыйЭлемент.ИндексЦвета = 4; // зеленый
			НовыйЭлемент.Записать();
			
			НовыйЭлемент = Справочники.CRM_СостоянияИнтересов.СоздатьЭлемент();
			НовыйЭлемент.Родитель = Сценарий;
			НовыйЭлемент.Наименование = НСтр("ru = 'Выполнено'");
			НовыйЭлемент.ВидДела = Справочники.CRM_ВидыДелВзаимодействий.Документ_CRM_Интерес;
			НовыйЭлемент.Завершено = Истина;
			НовыйЭлемент.РеквизитДопУпорядочивания = 99;
			НовыйЭлемент.ВидСостояния = Перечисления.CRM_ВидыСостоянияИнтереса.УспешноеЗавершение;
			НовыйЭлемент.Используется = Истина;
			НовыйЭлемент.КатегорияСостояния = Перечисления.CRM_КатегорииСостоянийПоддержки.Выполнено;
			НовыйЭлемент.ЗавершатьЗапланированныеАктивности = Перечисления.CRM_ЗавершаемыеТипыАктивности.ВзаимодействияИЗадачи;
			НовыйЭлемент.ОтборЗавершаемыхАктивностей = Перечисления.CRM_ОтборыЗавершаемыхАктивностей.ВсеЗапланированные;
			НовыйЭлемент.ДополнительныеСвойства.Вставить("РеквизитаУпорядочиванияУстановлен", Истина);
			НовыйЭлемент.ИндексЦвета = 19; // темно-зеленый
			ПроверяемыеРеквизиты = Новый Массив;
			ПроверяемыеРеквизиты.Добавить("Партнер");
			НовыйЭлемент.ПроверяемыеРеквизитыИнтереса = Новый ХранилищеЗначения(ПроверяемыеРеквизиты);
			НовыйЭлемент.Записать();
			
		КонецЕсли;
	
	Исключение
		
		ОбработкаЗавершена = Ложь;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось создать сценарий поддержки по причине:""%1';en='Failed to create script due to:""%1'"), 
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			 УровеньЖурналаРегистрации.Предупреждение,
				, , ТекстСообщения);
		
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
