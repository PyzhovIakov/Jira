
#Область СлужебныйПрограммныйИнтерфейс

Функция CRM_ЭтоФормаПартнераКакКонтрагента(Форма) Экспорт
	
	Если Форма.ИмяФормы = "Справочник.Партнеры.Форма.CRM_Модуль_ФормаЭлементаРеквизитыКонтрагентаНовая"
		И Форма.CRM_ИспользоватьПартнеровКакКонтрагентов Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ДополнительныеПараметрыКонтрагентаПоФорме(Форма, ДополнительныеПараметры) Экспорт
	
	Если CRM_ЭтоФормаПартнераКакКонтрагента(Форма) Тогда
		ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Форма);
	КонецЕсли;
	
КонецФункции

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
//             справочника,  в котором выполняется проверка контрагента, по форме.
// 		Обязательна к заполнению.
// Параметры:
//  Форма		 - УправляемаяФорма - Форма документа или справочника, в котором выполняется проверка контрагента.
//  Результат	 - Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
Процедура ПолучитьОбъектИСсылкуПоФорме(Форма, Результат) Экспорт
	
	Если CRM_ЭтоФормаПартнераКакКонтрагента(Форма) Тогда
		ИсточникОбъект = Форма;
		ИсточникСсылка = ИсточникОбъект.КонтрагентПартнера;
		Результат.Вставить("Объект", ИсточникОбъект); 
		Результат.Вставить("Ссылка", ИсточникСсылка);
	ИначеЕсли Форма.ИмяФормы = "Справочник.Партнеры.Форма.CRM_Модуль_ФормаБыстрогоВвода" Тогда
		Результат.Вставить("Объект", Форма); 
		Результат.Вставить("Ссылка", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры

// Определяет свойства контрагента в форме или подписках на события.
//
// Параметры:
//	Форма - УправляемаяФорма - форма, из которой вызывается обработчик.
//		Если вызывается вне формы, тогда значение Неопределено;
//	СвойстваКонтрагента - Структура - в параметре возвращаются свойства контрагента:
//		* ИНН - Строка - ИНН контрагента. Значение по умолчанию - пустая строка;
//		* ПодлежитПроверке - Булево - в параметре необходимо возвратить Истина, если контрагент
//			подлежит проверке в сервисе 1СПАРК Риски, Ложь - в противном случае.
//			Важно. Сервис 1СПАРК Риски предоставляет информацию только по не иностранным
//			юридическим лицам;
//			Значение по умолчанию - Ложь;
//		* СвояОрганизация - Булево - признак того, что контрагент является собственным.
//			Значение по умолчанию - Ложь.
//			Свойство может быть использовано для отбора данных в отчетах.
//
Функция ПриОпределенииСвойствКонтрагентаВОбъекте(Форма, СвойстваКонтрагента) Экспорт

	Если Форма <> Неопределено И CRM_ЭтоФормаПартнераКакКонтрагента(Форма) Тогда
		СвойстваКонтрагента.ИНН = Форма.ИНН;
		СвойстваКонтрагента.ПодлежитПроверке = Форма.ЮридическоеФизическоеЛицо =
			ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо")
			И НЕ Форма.ОбособленноеПодразделение;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти // СлужебныйПрограммныйИнтерфейс
