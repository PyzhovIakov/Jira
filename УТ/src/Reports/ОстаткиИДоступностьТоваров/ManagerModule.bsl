#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ОстаткиИДоступностьТоваров)
		И НЕ ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ОстаткиИДоступностьТоваров.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Остатки и доступность'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "ОстаткиИДоступность");
		
		КомандаОтчет.КлючВарианта = "ПоНоменклатуреКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// Задает расширенные настройки отчета
//
// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   ВыводитьВариантыОтчетов - Булево.
//
Процедура НастроитьВариантыОтчета(Настройки, ВыводитьВариантыОтчетов) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ОстаткиИДоступностьТоваров);
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, ОписаниеОтчета, ВыводитьВариантыОтчетов);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;

	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "");
	ОписаниеВарианта.Описание = НСтр("ru= 'Каков остаток товаров и сколько из них доступно?
		|Сколько товаров отгружается, в резерве или в обособлении?
		|Какими заказами зарезервирован товар?'");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ИспользоватьНазначенияБезЗаказа");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("ИспользоватьНазначенияБезЗаказа");
	ОписаниеВарианта.Описание = НСтр("ru= 'Каков остаток товаров и сколько из них доступно?
		|Сколько товаров отгружается, в резерве или в обособлении?
		|Какими заказами зарезервирован товар?'");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "НеИспользоватьНазначенияБезЗаказа");
	ОписаниеВарианта.ФункциональныеОпции.Добавить("НеИспользоватьНазначенияБезЗаказа");
	ОписаниеВарианта.Описание = НСтр("ru= 'Каков остаток товаров и сколько из них доступно?
		|Сколько товаров отгружается, в резерве или в обособлении?
		|Какими заказами зарезервирован товар?'");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоНоменклатуреКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоНоменклатуреКонтекстНазначенияБезЗаказа");
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ИспользоватьНазначенияБезЗаказаМобильныйКлиент");
	ОписаниеВарианта.Описание = НСтр("ru= 'Каков остаток товаров и сколько из них доступно?
		|Сколько товаров отгружается, в резерве или в обособлении?
		|Какими заказами зарезервирован товар?'");
	ОписаниеВарианта.Наименование = НСтр("ru='Остатки и доступность товаров (моб.)'");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Истина;
	ОписаниеВарианта.Назначение = Перечисления.НазначенияВариантовОтчетов.ДляСмартфонов;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
		
#КонецЕсли