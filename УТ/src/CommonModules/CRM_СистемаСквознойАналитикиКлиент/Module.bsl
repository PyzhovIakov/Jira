////////////////////////////////////////////////////////////////////////////////
// Система сквозной аналитики (клиент)
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОповещенияОбОкончанииВыполненияРегламентныхЗаданий() Экспорт
	
	ОтключитьОбработчик = Ложь;
	
	Попытка
		Если са_глПараметры.ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() = 0 Тогда
			ОтключитьОбработчик = Истина;
		КонецЕсли;
	Исключение
		ОтключитьОбработчик = Истина;
	КонецПопытки;
	
	Если НЕ ОтключитьОбработчик Тогда
		Оповещения =
			CRM_СистемаСквознойАналитикиВызовСервера.ОповещенияОбОкончанииВыполненияРегламентныхЗаданий(са_глПараметры);
	
		Попытка
			Если са_глПараметры.ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() = 0 Тогда
				ОтключитьОбработчик = Истина;
			КонецЕсли;
		Исключение
			ОтключитьОбработчик = Истина;
		КонецПопытки;
	КонецЕсли;
	
	Если ОтключитьОбработчик Тогда
		ОтключитьОбработчикОжидания("са_СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания");
		
	Иначе
		ПодключитьОбработчикОжидания("са_СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 2, Истина);
	КонецЕсли;
	
	Возврат Оповещения;
	
КонецФункции

Процедура ЗапуститьЗагрузкуДанных(ЭтаФорма, ЗапуститьЗадание = Ложь, ЗаписатьОбъект = Истина) Экспорт
	
	Если ЗаписатьОбъект Тогда
		ЭтаФорма.Записать();
	КонецЕсли;
	
	Если НЕ ЗапуститьЗадание Тогда
		ЗапуститьЗадание = ЭтаФорма.Объект.Включено;
	КонецЕсли;
	
	Если ЗапуститьЗадание Тогда
		ПараметрыВыполнения = CRM_СистемаСквознойАналитикиВызовСервера.ЗапуститьЗаданиеВРучную(ЭтаФорма.Объект.Ссылка);
		Если ПараметрыВыполнения <> Неопределено Тогда
			Если ПараметрыВыполнения.ЗапускВыполнен Тогда
				ПоказатьОповещениеПользователя(
					НСтр("ru='Запущена процедура регламентного задания';en='Scheduled job is launched'"), ,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1."
"Процедура запущена в фоновом задании %2';en='%1."
"The procedure is run in background job%2'"),
						ПараметрыВыполнения.НаименованиеЗадания,
						Строка(ПараметрыВыполнения.МоментЗапуска)),
						БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
						
				Если ТипЗнч(са_глПараметры) <> Тип("Структура") Тогда
					са_глПараметры = Новый Структура();
				КонецЕсли;
				Если НЕ са_глПараметры.Свойство("ИдентификаторыФоновыхЗаданийПриРучномВыполнении") Тогда
					са_глПараметры.Вставить("ИдентификаторыФоновыхЗаданийПриРучномВыполнении", Новый СписокЗначений());
				КонецЕсли;
				са_глПараметры.ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Добавить(ПараметрыВыполнения.ИдентификаторФоновогоЗадания,
					 ПараметрыВыполнения.НаименованиеЗадания);
				
				ПодключитьОбработчикОжидания("са_СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 0.1, Истина);

			ИначеЕсли ПараметрыВыполнения.ПроцедураУжеВыполняется Тогда
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Процедура регламентного задания ""%1"""
"  уже выполняется в фоновом задании ""%2"", начатом %3.'"),
					ПараметрыВыполнения.НаименованиеЗадания,
					ПараметрыВыполнения.ПредставлениеФоновогоЗадания,
					Строка(ПараметрыВыполнения.МоментЗапуска));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ЭтаФорма.ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", 0.1, Истина);
	Исключение
		Возврат;
	КонецПопытки;

КонецПроцедуры
		
#КонецОбласти
