#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СостояниеАссортимента) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СостояниеАссортимента.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Состояние ассортимента'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "СостояниеАссортимента");
		
		КомандаОтчет.КлючВарианта = "ОсновнойКонтекст";
		
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
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.СостояниеАссортимента);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	ВариантыОтчетовУТПереопределяемый.ОтключитьОтчет(ОписаниеОтчета);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
		
#КонецЕсли