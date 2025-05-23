#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ОценкаРентабельностиПродаж) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ОценкаРентабельностиПродаж.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Оценка рентабельности продажи'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		
		ИспользоватьРучныеСкидкиВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
		ИспользоватьАвтоматическиеСкидкиВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
		Если Не ИспользоватьРучныеСкидкиВПродажах
			И Не ИспользоватьАвтоматическиеСкидкиВПродажах Тогда
			КлючВарианта = "ОценкаРентабельностиПродажиБезСкидокКонтекст";
		ИначеЕсли ИспользоватьРучныеСкидкиВПродажах И Не ИспользоватьАвтоматическиеСкидкиВПродажах Тогда
			КлючВарианта = "ОценкаРентабельностиПродажиТолькоРучныеСкидкиКонтекст";
		ИначеЕсли Не ИспользоватьРучныеСкидкиВПродажах И ИспользоватьАвтоматическиеСкидкиВПродажах Тогда
			КлючВарианта = "ОценкаРентабельностиПродажиТолькоАвтоСкидкиКонтекст";
		Иначе
			КлючВарианта = "ОценкаРентабельностиПродажиКонтекст";
		КонецЕсли;
		КомандаОтчет.КлючВарианта = КлючВарианта;
		
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
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ОценкаРентабельностиПродаж);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	ВариантыОтчетовУТПереопределяемый.ОтключитьОтчет(ОписаниеОтчета);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
		
#КонецЕсли