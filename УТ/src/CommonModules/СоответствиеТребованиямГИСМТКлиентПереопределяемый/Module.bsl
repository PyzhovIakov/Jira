
#Область ПрограммныйИнтерфейс

// Позволяет запустить команды после выполнения проверки документа на соответствие требованиям ГИСМТ,
// переопредилить результат проверки документа или отменить открытие формы с ошибками.
// 
// Параметры:
//  Результат - Структура:
//  *РезультатПроверки - См. СоответствиеТребованиямГИСМТ.ПроверкаДокументаНаСоответствиеТребованиямГИСМТ
//  ДополнительныеПараметры - Структура:
//  *Форма - ФормаКлиентскогоПриложения - Форма документа.
Процедура ПослеПроверкиДокументаНаСоответствиеТребованиямГИСМТ(Результат, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Форма = ДополнительныеПараметры.Форма;	
	Элемент = Форма.Элементы.Найти("ГруппаСоответствиеТребованиямГИСМТГосИС");
	
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Параметр = Новый Структура("Основание", Результат.РезультатПроверки.Документ);
	
	ОформлениеПередачиТоваровМеждуОрганизациямиКлиент.ОбработкаОповещения(ДополнительныеПараметры.Форма, 
		"ИСМП", Параметр);
	
	Если Не Элемент.Видимость Тогда
		ДополнительныеПараметры.Вставить("ОтменитьОткрытиеФормыСОшибками", Истина);
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти