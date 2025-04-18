// @strict-types
#Область СлужебныйПрограммныйИнтерфейс

#Область ОшибкиКриптографии

// Параметры:
//  Ошибка - См. ОбработкаНеисправностейБЭДКлиентСервер.НоваяОшибка
// 
// Возвращаемое значение:
//  Строка
Функция СформироватьМеченныйТекстОшибки(Ошибка) Экспорт
	Возврат СтрШаблон("%1
					  |#Метка: %2", Ошибка.ПодробноеПредставлениеОшибки, Ошибка.Идентификатор);
КонецФункции

// Параметры:
//  ТекстОшибкиБСП - Строка
//  ОшибкиБЭД - Массив Из См. ОбработкаНеисправностейБЭДКлиентСервер.НоваяОшибка
// 
// Возвращаемое значение:
//  Булево
Функция ВТекстеОшибкиБСПЕстьМеткаОшибкиБЭД(ТекстОшибкиБСП, ОшибкиБЭД) Экспорт
	Для Каждого Ошибка Из ОшибкиБЭД Цикл
		СтрокаПоиска = СтрШаблон("#Метка: %1", Ошибка.Идентификатор);
		Если СтрНайти(ТекстОшибкиБСП, СтрокаПоиска) > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

#КонецОбласти // ОшибкиКриптографии

#Область СерверныеОповещения

// Возвращаемое значение:
//  Булево
Функция УведомленияКлиентаДоступны() Экспорт
	
	Если ТолькоДляТестирования() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Версия = СистемнаяИнформация.ВерсияПриложения;
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Версия, "8.3.26.1498") >= 0
	      И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Версия, "8.3.27.0") < 0
	    Или ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Версия, "8.3.27.1288") >= 0;
	
КонецФункции

#КонецОбласти // СерверныеОповещения

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОповещения

// Возвращаемое значение:
//  Булево
Функция ТолькоДляТестирования()
	
// АПК:547-выкл временное решение для тестирования.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
#Иначе
	РазделениеВключено = ОбщегоНазначенияКлиент.РазделениеВключено();
#КонецЕсли
// АПК:547-вкл
	
	Возврат РазделениеВключено;
	
КонецФункции

#КонецОбласти // СерверныеОповещения

#КонецОбласти