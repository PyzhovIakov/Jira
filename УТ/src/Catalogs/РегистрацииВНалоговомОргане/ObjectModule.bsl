#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет значением по умолчанию код региона
//
Процедура ЗаполнитьКодРегиона() Экспорт
	
	Если ЗначениеЗаполнено(КодРегиона) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Возврат;
	КонецЕсли;
	
	КодРегиона = Справочники.РегистрацииВНалоговомОргане.КодРегионаПоКодуНалоговогоОргана(Код);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Организация = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеЗаполнения, "Владелец");
	Если Организация = Неопределено ИЛИ ТипЗнч(Организация) <> Тип("СправочникСсылка.Организации") Тогда
		ДанныеЗаполнения.Вставить("Владелец", Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	КрупнейшийНалогоплательщик = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеЗаполнения, "КрупнейшийНалогоплательщик");
	
	Если КрупнейшийНалогоплательщик = Неопределено 
			ИЛИ КрупнейшийНалогоплательщик = Ложь Тогда
		
		КППОрганизации = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Владелец, "КПП"));

		Если Не ДанныеЗаполнения.Свойство("КПП") Или Не ЗначениеЗаполнено(ДанныеЗаполнения.КПП) Тогда
			ДанныеЗаполнения.Вставить("КПП", КППОрганизации);
		КонецЕсли;

		Если Не ДанныеЗаполнения.Свойство("Код") Или Не ЗначениеЗаполнено(ДанныеЗаполнения.Код) Тогда
			ДанныеЗаполнения.Вставить("Код", Лев(КППОрганизации, 4));
		КонецЕсли;
		
	Иначе
		
		КППОрганизации = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Владелец, "КрупнейшийНалогоплательщикКПП"));
		ДанныеЗаполнения.Вставить("КПП", КППОрганизации);
		ДанныеЗаполнения.Вставить("Код", Лев(КППОрганизации, 4));

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТекстСообщения				  = "";
	МассивНепроверяемыхРеквизитов = Новый Массив;
	РеквизитыОрганизации 		  = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ЮридическоеФизическоеЛицо,ОбособленноеПодразделение");
	
	// Организация
	Если ЗначениеЗаполнено(Владелец) И НЕ Справочники.РегистрацииВНалоговомОргане.ВозможнаРегистрацияДляОбособленныхПодразделений()
	 И РеквизитыОрганизации.ОбособленноеПодразделение Тогда
		ТекстСообщения = НСтр("ru = 'Организация, для которой оформляется регистрация, не должна являться обособленным подразделением.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Владелец",, Отказ);
	КонецЕсли;
	
	// КПП
	Если ЗначениеЗаполнено(Владелец) И НЕ ПартнерыИКонтрагенты.ЭтоЮрЛицо(РеквизитыОрганизации.ЮридическоеФизическоеЛицо) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КПП");
	ИначеЕсли ЗначениеЗаполнено(КПП) И НЕ РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(КПП, ТекстСообщения) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "КПП",, Отказ);
	КонецЕсли;
	
	Если КрупнейшийНалогоплательщик
			И ЗначениеЗаполнено(Владелец)
			И ПартнерыИКонтрагенты.ЭтоЮрЛицо(РеквизитыОрганизации.ЮридическоеФизическоеЛицо)
			И РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(КПП, ТекстСообщения) Тогда
				
		Если Сред(КПП, 5, 2) <> "50" Тогда
			ТекстСообщения = НСтр("ru = 'В КПП крупнейшего налогоплательщика 5й и 6й символы должны быть ""50""'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "КПП",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	// Код налогового органа
	Если ЗначениеЗаполнено(Код)
	 И (СтрДлина(Код) <> 4 ИЛИ НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Код)) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Код налогового органа"" заполнено некорректно.'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Код",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
	
	Если НЕ ПартнерыИКонтрагенты.ЭтоЮрЛицо(РеквизитыОрганизации.ЮридическоеФизическоеЛицо) И НЕ ПустаяСтрока(КПП) Тогда
		КПП = "";
	КонецЕсли;
	
	Если РеквизитыОрганизации.ОбособленноеПодразделение И ЗначениеЗаполнено(ЦифровойИндексОбособленногоПодразделения) Тогда
		ЦифровойИндексОбособленногоПодразделения = 0;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = НаименованиеИФНС;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Представитель) Тогда
		ДокументПредставителя 			= "";
		УполномоченноеЛицоПредставителя = "";
	ИначеЕсли ТипЗнч(Представитель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда	
		УполномоченноеЛицоПредставителя = "";
	КонецЕсли;
	
	Если НЕ ЭтоНовый() Тогда
		РегистрыСведений.РегистрацииВНалоговомОргане.АктуализироватьСоставРегистрацииВНалоговомОргане(ЭтотОбъект);
	КонецЕсли;
	
	ЗаполнитьКодРегиона();
	
	Если НЕ ПустаяСтрока(НаименованиеОбособленногоПодразделения) Тогда
		НаименованиеСлужебное = НаименованиеОбособленногоПодразделения;
	ИначеЕсли ЭтоНовый() Тогда
		// При вводе новой регистрации из формы подразделения или организации используется метод УстановитьСсылкуНового()
		// Полученная таким образом ссылка на новую регистрацию устанавливается в поле объекта справочника подразделений/организаций при записи
		// В этом случае метод ПолучитьСсылкуНового() вернет ссылку, которая уже установлена в объекте, "вызвавшем" создание регистрации
		НаименованиеСлужебное = Справочники.РегистрацииВНалоговомОргане.НаименованиеСлужебное(ПолучитьСсылкуНового());
	Иначе
		НаименованиеСлужебное = Справочники.РегистрацииВНалоговомОргане.НаименованиеСлужебное(Ссылка);
	КонецЕсли;
	
	КрупнейшийНалогоплательщик = ЭтоКрупнейшийНалогоплательщик(КПП);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет, является ли регистрация в налоговом органе регистрацией крупнейшего 
// налогоплательщика по 5-му и 6-му символам КПП.
// 
// Параметры:
//  КПП - Строка - КПП
// 
// Возвращаемое значение:
//  Булево - Это крупнейший налогоплательщик
Функция ЭтоКрупнейшийНалогоплательщик(КПП)
	
	Если Не ПустаяСтрока(КПП) И СтрДлина(КПП) = 9 Тогда
		Если Сред(КПП, 5, 2) = "50" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецЕсли