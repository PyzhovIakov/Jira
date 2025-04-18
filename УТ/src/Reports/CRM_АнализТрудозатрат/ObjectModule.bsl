////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции модуля объекта "Отчеты.CRM_АнализТрудозатрат".
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

#Область ДляВызоваИзДругихПодсистем

// +СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Если КлючВарианта = "ДанныеВиджета" Или КлючВарианта = "ДанныеВиджетаРасшифровка" Тогда
		Настройки.ФормироватьСразу = Истина;
		Настройки.РазрешеноИзменятьВарианты = Ложь;
		Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ОпределитьНастройкиФормы()

// -СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
