
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
	Если ЗначениеЗаполнено(Объект.КлючДоступа) Тогда
		СпискиКонтактов = Обработки.CRM_РаботаССервисомРассылокUnisender.СпискиКонтактовUniSender(Объект.КлючДоступа);
		Элементы.CRM_СписокКонтактовUniSenderДляОповещений.СписокВыбора.Очистить();
		Элементы.CRM_СписокКонтактовUniSenderДляРассылок.СписокВыбора.Очистить();
		Для каждого Список Из СпискиКонтактов Цикл
			Элементы.CRM_СписокКонтактовUniSenderДляОповещений.СписокВыбора.Добавить(Список.Значение, Список.Представление);
			Элементы.CRM_СписокКонтактовUniSenderДляРассылок.СписокВыбора.Добавить(Список.Значение, Список.Представление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Если ПроверитьЗаполнение() Тогда
		ПараметрыДоступа = Новый Структура;
		ПараметрыДоступа.Вставить("КлючДоступа", Объект.КлючДоступа);
		ПараметрыДоступа.Вставить("СписокДляРассылок", Объект.СписокДляРассылок);
		ПараметрыДоступа.Вставить("СписокДляОповещений", Объект.СписокДляОповещений);
		Закрыть(ПараметрыДоступа);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеКUniSender(Команда)
	ПроверитьПодключениеКUniSenderНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОписаниеUniSender(Команда)
	
	ПерейтиПоНавигационнойСсылке(CRM_ОбщегоНазначенияСервер.ПолучитьСсылкуНаРазделСправки("ИнтеграцияUnisender"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьАвтотекстЭлектронногоПисьмаВUniSender(Команда)
	ВыгрузитьАвтотекстЭлектронногоПисьмаВUniSenderНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура CRM_КлючДоступаКUniSenderПриИзмененииНаСервере()
	Элементы.CRM_СписокКонтактовUniSenderДляОповещений.СписокВыбора.Очистить();
	Элементы.CRM_СписокКонтактовUniSenderДляРассылок.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.КлючДоступа) Тогда
		СпискиКонтактов = Обработки.CRM_РаботаССервисомРассылокUnisender.СпискиКонтактовUniSender(Объект.КлючДоступа);
		Для каждого Список Из СпискиКонтактов Цикл
			Элементы.CRM_СписокКонтактовUniSenderДляОповещений.СписокВыбора.Добавить(Список.Значение, Список.Представление);
			Элементы.CRM_СписокКонтактовUniSenderДляРассылок.СписокВыбора.Добавить(Список.Значение, Список.Представление);
		КонецЦикла;
	Иначе	
		СпискиКонтактов = Новый СписокЗначений;
	КонецЕсли;
	Если СпискиКонтактов.Количество() > 0 Тогда
		Объект.СписокДляРассылок = СпискиКонтактов[0].Значение;
	Иначе
		Объект.СписокДляРассылок = "";
	КонецЕсли;
	Если СпискиКонтактов.Количество() > 0 Тогда
		Объект.СписокДляОповещений = СпискиКонтактов[0].Значение;
	Иначе
		Объект.СписокДляОповещений = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура CRM_КлючДоступаКUniSenderПриИзменении(Элемент)
	
	CRM_КлючДоступаКUniSenderПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеКUniSenderНаСервере()
	СпискиКонтактов = Обработки.CRM_РаботаССервисомРассылокUnisender.СпискиКонтактовUniSender(Объект.КлючДоступа);
	Если СпискиКонтактов.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Подключение к UniSender прошло успешно.';
			|en='Connection to UniSender was successful.'"));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьАвтотекстЭлектронногоПисьмаВUniSenderНаСервере()
	Обработки.CRM_РаботаССервисомРассылокUnisender.ВыгрузитьАвтотекстВUniSender(Объект.КлючДоступа);
КонецПроцедуры

#КонецОбласти
