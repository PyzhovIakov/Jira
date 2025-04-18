
////////////////////////////////////////////////////////////////////////////////
// CRM методы общих форм сервер
//  
// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.
// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбщаяФорма_ДополнительныеОтчетыИОбработки

// Процедура дополняет таблицу внешними печатными формами.
//
// Параметры:
//	ДоступныеКоманды	- Таблица значений.
//
Процедура ДополнитьВнешнимиПечатнымиФормами(Форма, ДоступныеКоманды) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", ?(Форма.ЭтоГлобальныеОбработки, Форма.СсылкаРаздела.ПолноеИмя,
		 Форма.СсылкаРодителя.ПолноеИмя));
	Запрос.Текст = "ВЫБРАТЬ
	|	ПользовательскиеМакетыПечати.ИмяМакета КАК ИмяМакета,
	|	ПользовательскиеМакетыПечати.Объект КАК Объект,
	|	ПользовательскиеМакетыПечати.CRM_Представление КАК CRM_Представление
	|ИЗ
	|	РегистрСведений.ПользовательскиеМакетыПечати КАК ПользовательскиеМакетыПечати
	|ГДЕ
	|	ПользовательскиеМакетыПечати.CRM_ВнешнийМакет
	|	И ПользовательскиеМакетыПечати.Объект = &Объект";
	Выборка = Запрос.Выполнить().Выбрать();
	Форма.CRM_Варианты.Очистить();
	Форма.CRM_УчитыватьВарианты = Ложь;
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ДоступныеКоманды.Добавить();
		НоваяСтрока.Представление	= Выборка.CRM_Представление + ?(Форма.CRM_УчитыватьВарианты,
			 НСтр("ru=' (все варианты)';en=' (All Options)'"), "");
		НоваяСтрока.Идентификатор	= Выборка.ИмяМакета;
		НоваяСтрока.Ссылка			= Выборка.Объект;
		НоваяСтрока.CRM_Печать		= Истина;
		НоваяСтрока.CRM_ВсеВарианты	= Истина;
		Если Форма.CRM_УчитыватьВарианты Тогда
			НоваяСтрока = ДоступныеКоманды.Добавить();
			НоваяСтрока.Представление	= Выборка.CRM_Представление + ?(Форма.CRM_УчитыватьВарианты,
				 НСтр("ru=' (выбор варианта)';en=' (select option)'"), "");
			НоваяСтрока.Идентификатор	= Выборка.ИмяМакета;
			НоваяСтрока.Ссылка			= Выборка.Объект;
			НоваяСтрока.CRM_Печать		= Истина;
			НоваяСтрока.CRM_ВсеВарианты	= Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // CRM_ДополнитьВнешнимиПечатнымиФормами()

#КонецОбласти

#Область ОбщаяФорма_ОтправкаТабличныхДокументовПоПочте

Функция ПолучитьИмяВременногоФайлаДляТабличногоДокумента(ИмяМакета, Расширение, ИспользованныеИменаФайлов) Экспорт
	
	ШаблонИмениФайла = "%1%2.%3";
	ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, ИмяМакета, "", Расширение));
	НомерИспользования = ?(ИспользованныеИменаФайлов[ИмяВременногоФайла] <> Неопределено,
		ИспользованныеИменаФайлов[ИмяВременногоФайла] + 1, 1);
	ИспользованныеИменаФайлов.Вставить(ИмяВременногоФайла, НомерИспользования);
	
	// Если имя уже было ранее использовано, прибавляем счетчик в конце имени.
	Если НомерИспользования > 1 Тогда
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, ИмяМакета,
			" (" + НомерИспользования + ")", Расширение));
	КонецЕсли;
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

Функция ПолучитьИмяФайлаДляАрхива(Форма) Экспорт
	Результат = "";
	Для Каждого ТабличныйДокумент Из Форма.ТабличныеДокументы Цикл
		Если ТабличныйДокумент.Значение.Вывод = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		Если ПустаяСтрока(Результат) Тогда
			Результат = СтрЗаменить(ТабличныйДокумент.Представление, " ", "_");
		Иначе
			Результат = НСтр("ru='Документы';en='Documents'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат + ".zip";
КонецФункции

#КонецОбласти

#Область ОбщаяФорма_ПечатьДокументов

Функция ПроверитьЭтоСсылка(ТипОбъекта) Экспорт
	
	Если НЕ (ТипОбъекта = Тип("Неопределено")) Тогда
		Возврат ОбщегоНазначения.ЭтоСсылка(ТипОбъекта);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти
