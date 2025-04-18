
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере".
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокШаговМастера.Добавить("ДекорацияШагОбщаяИнформация", "СтраницаСтарт");
	СписокШаговМастера.Добавить("ДекорацияШагВыборПорядка",    "СтраницаВыборПорядкаРеквизитов");
	СписокШаговМастера.Добавить("ДекорацияШагРедактирование",  "СтраницаРедактирование");
	СписокШаговМастера.Добавить("ДекорацияШагЗавершение",      "СтраницаЗавершено");
	
	Разделители = " ,;";
	
	Элементы.ПанельОсновная.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	ОбрабатыватьПартнеров = Истина;
	ОбрабатыватьКонтактныеЛица = Истина;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	НоваяСтрока = ТаблицаПорядокРеквизитов.Добавить();
	НоваяСтрока.Имя = "Фамилия";
	НоваяСтрока.Представление = НСтр("ru='Фамилия';en='Last Name'");
	НоваяСтрока = ТаблицаПорядокРеквизитов.Добавить();
	НоваяСтрока.Имя = "Имя";
	НоваяСтрока.Представление = НСтр("ru='Имя';en='First Name'");
	НоваяСтрока = ТаблицаПорядокРеквизитов.Добавить();
	НоваяСтрока.Имя = "Отчество";
	НоваяСтрока.Представление = НСтр("ru='Отчество';en='Middle Name'");
	
	СписокШаговМастера[0].Пометка = Истина;
	НастроитьЗаголовкиШагов(ЭтотОбъект);
	
	// Размещать текст в конце процедуры, проверка на снятие флага показа стартовой страницы.
	НазваниеМастера = "МастерЗаполненияФИО";        		
	ПоказыватьНачальнуюСтраницу = CRM_ХранилищеНастроек.Загрузить(ЭтотОбъект.ИмяФормы, "ПоказыватьНачальнуюСтраницу" 
		+ НазваниеМастера);
	Если НЕ ЗначениеЗаполнено(ПоказыватьНачальнуюСтраницу) Тогда
		ФлагПоказыватьНачальнуюСтраницу = Истина;
	Иначе
		ФлагПоказыватьНачальнуюСтраницу = ПоказыватьНачальнуюСтраницу;
	КонецЕсли;			
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПриОткрытии".
//
Процедура ПриОткрытии(Отказ)
	Если НЕ ФлагПоказыватьНачальнуюСтраницу Тогда
		КомандаДалее(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы "ПередЗакрытием".
//
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если Модифицированность Тогда
		Отказ = Истина;
		ОбратныйВызов = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОбратныйВызов,
			 НСтр("ru='Данные были изменены. Закрыть форму?';en='Data has been changed. Close the form?'"),
			 РежимДиалогаВопрос.ДаНет);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаРеквизитПриИзменении(Элемент)
	Модифицированность = Истина;
	Попытка
		ТекДанные = Элемент.Родитель.ТекущиеДанные;
	
	Исключение	ТекДанные = Неопределено;
	КонецПопытки;
	Если ТекДанные <> Неопределено И Не ТекДанные.Пометка Тогда
		ТекДанные.Пометка = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФлагПоказыватьНачальнуюСтраницуПриИзменении(Элемент)
	НазваниеМастера = "МастерЗаполненияФИО";        			
	CRM_ХранилищеНастроек.Сохранить(ИмяФормы, "ПоказыватьНачальнуюСтраницу" 
		+ НазваниеМастера,
		 ФлагПоказыватьНачальнуюСтраницу);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаКЛ

&НаКлиенте
Процедура ТаблицаКЛВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ТаблицаКЛСсылка" Тогда
		СтандартнаяОбработка = Ложь;
		// BSLLS:MissingCodeTryCatchEx-off
		Попытка
			ПоказатьЗначение(, ТаблицаКЛ.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка);
		
		Исключение 
		КонецПопытки;
		// BSLLS:MissingCodeTryCatchEx-on
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПартнеры

&НаКлиенте
Процедура ТаблицаПартнерыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ТаблицаПартнерыСсылка" Тогда
		СтандартнаяОбработка = Ложь;
        // BSLLS:MissingCodeTryCatchEx-off
		Попытка
			ПоказатьЗначение(, ТаблицаПартнеры.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка);
		
		Исключение
		КонецПопытки;
		// BSLLS:MissingCodeTryCatchEx-on
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаСтарт Тогда
		Элементы.ГруппаПоказыватьНачальнуюСтраницу.Видимость = Ложь;		
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаВыборПорядкаРеквизитов;
		Элементы.КомандаНазад.Доступность = Истина;
		
	ИначеЕсли Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаВыборПорядкаРеквизитов Тогда
		УправлениеЭлементамиФормы(ЭтотОбъект);
		
		Если Не ОбрабатыватьПартнеров И Не ОбрабатыватьКонтактныеЛица Тогда
			ПоказатьПредупреждение(, НСтр("ru='Не выбран ни один справочник!';en='No catalog selected!'"));
			Возврат;
			
		КонецЕсли;
		
		бЗаполнитьТаблицы = Истина;
		Если ТаблицаПартнеры.Количество() > 0 Или ТаблицаКЛ.Количество() > 0 Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("КомандаДалееПослеВопроса", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения,
				 НСтр("ru='Перечитать данные? Все изменения будут отменены.';
				|en='Reread data? All changes will be cancelled.'"),
				 РежимДиалогаВопрос.ДаНет);
		Иначе	
			ЗаполнитьТаблицы();
			Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаРедактирование;
		КонецЕсли;
		
	ИначеЕсли Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаРедактирование Тогда
		бПартнерыВыбраны = Ложь;
		бКЛВыбраны = Ложь;
		Если ОбрабатыватьПартнеров И ТаблицаПартнеры.Количество() > 0 Тогда
			НайденныеСтроки = ТаблицаПартнеры.НайтиСтроки(Новый Структура("Пометка", Истина));
			Если НайденныеСтроки.Количество() > 0 Тогда
				бПартнерыВыбраны = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ОбрабатыватьКонтактныеЛица И ТаблицаКЛ.Количество() > 0 Тогда
			НайденныеСтроки = ТаблицаКЛ.НайтиСтроки(Новый Структура("Пометка", Истина));
			Если НайденныеСтроки.Количество() > 0 Тогда
				бКЛВыбраны = Истина;
			КонецЕсли;
		КонецЕсли;
		Если Не бПартнерыВыбраны И Не бКЛВыбраны Тогда
			ПоказатьПредупреждение(,
				 НСтр("ru='Не выбран ни один элемент справочника!';
				|en='There is no selected catalog item!'"));
			Возврат;
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандаДалееПослеВопроса", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Реквизиты ""Фамилия"", ""Имя"", ""Отчество"" будут перезаписаны."
"Продолжить?';en='Details ""Surname"", ""Name"", ""Patronymic"" will be overwritten."
"Continue?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
	НастроитьЗаголовкиШагов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалееПослеВопроса(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаВыборПорядкаРеквизитов Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаполнитьТаблицы();
		КонецЕсли;
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаРедактирование;
	ИначеЕсли Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаРедактирование Тогда
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ПринятьИзменения();
			
			Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаЗавершено;
			
			Элементы.КомандаНазад.Видимость = Ложь;
			Элементы.КомандаДалее.Видимость = Ложь;
			Элементы.КомандаЗавершить.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НастроитьЗаголовкиШагов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаВыборПорядкаРеквизитов Тогда
		Элементы.ГруппаПоказыватьНачальнуюСтраницу.Видимость = Истина;		
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаСтарт;
	    Элементы.КомандаНазад.Доступность = Ложь;
		
	ИначеЕсли Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаРедактирование Тогда
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаВыборПорядкаРеквизитов;
		
	КонецЕсли;
	
	НастроитьЗаголовкиШагов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗавершить(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажкиПартнеры(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаПартнеры Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажкиКЛ(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаКЛ Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажкиПартнеры(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаПартнеры Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажкиКЛ(Команда)
	Для Каждого СтрокаТаблицы Из ТаблицаКЛ Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПринятьИзменения()
	Для Каждого СтрокаТаблицы Из ТаблицаПартнеры Цикл
		Если СтрокаТаблицы.Пометка Тогда
			СправочникОбъект = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			СправочникОбъект.CRM_Фамилия = СтрокаТаблицы.Фамилия;
			СправочникОбъект.CRM_Имя = СтрокаТаблицы.Имя;
			СправочникОбъект.CRM_Отчество = СтрокаТаблицы.Отчество;
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ТаблицаКЛ Цикл
		Если СтрокаТаблицы.Пометка Тогда
			СправочникОбъект = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			СправочникОбъект.CRM_Фамилия = СтрокаТаблицы.Фамилия;
			СправочникОбъект.CRM_Имя = СтрокаТаблицы.Имя;
			СправочникОбъект.CRM_Отчество = СтрокаТаблицы.Отчество;
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	Модифицированность = Ложь;
КонецПроцедуры

&НаСервере
Функция РазбитьСтрокуНаФИО(СтрокаФИО, КоличествоУспешно = 0)
	СтрНаименование = СокрЛП(СтрокаФИО);
	
	МассивСтрок = Новый Массив();
	
	Для нФио = 1 По 3 Цикл
		ТекСтрФио = "";
		Для нРазделитель = 1 По СтрДлина(Разделители) Цикл
			ТекРазделитель = Сред(Разделители, нРазделитель, 1);
			
			Если нФио = 3 Тогда
				ТекСтрФио = СокрЛП(СтрНаименование);
				КоличествоУспешно = КоличествоУспешно + 1;
				Прервать;
			Иначе
				Поз = СтрНайти(СтрНаименование, ТекРазделитель);
				Если Поз > 0 Тогда
					ТекСтрФио = СокрЛП(Лев(СтрНаименование, Поз - 1));
					СтрНаименование = Сред(СтрНаименование, Поз + 1);
					Для нПозРазделитель = 1 По СтрДлина(СтрНаименование) Цикл
						Если СтрНайти(Разделители, Сред(СтрНаименование, нПозРазделитель, 1)) = 0 Тогда
							СтрНаименование = Сред(СтрНаименование, нПозРазделитель);
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					КоличествоУспешно = КоличествоУспешно + 1;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если нФио <> 3 Тогда
			Если Не ПустаяСтрока(ТекСтрФио) Тогда
				Для нРазделитель = 1 По СтрДлина(Разделители) Цикл
					ТекСтрФио = СтрЗаменить(ТекСтрФио, Сред(Разделители, нРазделитель, 1), "");
				КонецЦикла;
				ТекСтрФио = СокрЛП(ТекСтрФио);
			КонецЕсли;
		КонецЕсли;
		
		МассивСтрок.Добавить(ТекСтрФио);
	КонецЦикла;
	
	Если	Не ЗначениеЗаполнено(МассивСтрок[0])
		И	Не ЗначениеЗаполнено(МассивСтрок[1])
		И	ЗначениеЗаполнено(МассивСтрок[2]) Тогда
		//
		МассивСтрок[0] = МассивСтрок[2];
		МассивСтрок[2] = "";
	КонецЕсли;
	
	СтруктураРезультат = Новый Структура("Фамилия,Имя,Отчество");
	Для н = 0 По 2 Цикл
		СтруктураРезультат[ТаблицаПорядокРеквизитов[н].Имя] = МассивСтрок[н];
	КонецЦикла;
	
	Возврат СтруктураРезультат;
КонецФункции

&НаСервере
Функция РазбитьНаименование(Выборка, ИскатьИВПолномНаименовании = Ложь)
	Если ИскатьИВПолномНаименовании Тогда
		КоличествоУспешноПоНаименованию = 0;
		КоличествоУспешноПоПолномуНаименованию = 0;
		
		СтруктураРезультатПоНаименованию = РазбитьСтрокуНаФИО(Выборка.Наименование, КоличествоУспешноПоНаименованию);
		СтруктураРезультатПоПолномуНаименованию = РазбитьСтрокуНаФИО(Выборка.НаименованиеПолное,
			 КоличествоУспешноПоПолномуНаименованию);
		
		Если КоличествоУспешноПоНаименованию = 1 И КоличествоУспешноПоПолномуНаименованию = 1 Тогда
			Возврат СтруктураРезультатПоНаименованию;
		ИначеЕсли КоличествоУспешноПоПолномуНаименованию > КоличествоУспешноПоНаименованию Тогда
			Возврат СтруктураРезультатПоПолномуНаименованию;
		Иначе
			Возврат СтруктураРезультатПоНаименованию;
		КонецЕсли;
		
	Иначе
		Возврат РазбитьСтрокуНаФИО(Выборка.Наименование);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицы()
	ТаблицаПартнеры.Очистить();
	ТаблицаКЛ.Очистить();
	
	Если ОбрабатыватьПартнеров Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ТаблицаСправочника.Ссылка КАК Ссылка,
		|	ТаблицаСправочника.Наименование КАК Наименование,
		|	ТаблицаСправочника.НаименованиеПолное КАК НаименованиеПолное,
		|	ТаблицаСправочника.CRM_Фамилия КАК Фамилия,
		|	ТаблицаСправочника.CRM_Имя КАК Имя,
		|	ТаблицаСправочника.CRM_Отчество КАК Отчество
		|	
		|ИЗ
		|	Справочник.Партнеры КАК ТаблицаСправочника
		|	
		|ГДЕ
		|	НЕ (ТаблицаСправочника.CRM_Фамилия ЕСТЬ NULL)
		|	И ТаблицаСправочника.CRM_Фамилия = """"
		|	И ТаблицаСправочника.CRM_Имя = """"
		|	И ТаблицаСправочника.CRM_Отчество = """"
		|	И ТаблицаСправочника.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.КомпанияЧастноеЛицо.ЧастноеЛицо)
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаСправочника.Наименование
		|");
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаПартнеры.Добавить();
			НоваяСтрока.Ссылка = Выборка.Ссылка;
			НоваяСтрока.Наименование = Выборка.Наименование;
			СтруктураФИО = РазбитьНаименование(Выборка, Истина);
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураФИО);
			
			НоваяСтрока.Пометка = ЗначениеЗаполнено(НоваяСтрока.Фамилия)
				И ЗначениеЗаполнено(НоваяСтрока.Имя)
				И ЗначениеЗаполнено(НоваяСтрока.Отчество);
			//
		КонецЦикла;
	КонецЕсли;
	
	Если ОбрабатыватьКонтактныеЛица Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаСправочника.Ссылка КАК Ссылка,
		|	ТаблицаСправочника.Наименование КАК Наименование,
		|	ТаблицаСправочника.CRM_Фамилия КАК Фамилия,
		|	ТаблицаСправочника.CRM_Имя КАК Имя,
		|	ТаблицаСправочника.CRM_Отчество КАК Отчество
		|	
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров КАК ТаблицаСправочника
		|	
		|ГДЕ
		|	ТаблицаСправочника.CRM_Фамилия = """"
		|	И ТаблицаСправочника.CRM_Имя = """"
		|	И ТаблицаСправочника.CRM_Отчество = """"
		|	
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаСправочника.Наименование
		|");
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаКЛ.Добавить();
			НоваяСтрока.Ссылка = Выборка.Ссылка;
			НоваяСтрока.Наименование = Выборка.Наименование;
			СтруктураФИО = РазбитьНаименование(Выборка);
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураФИО);
			
			НоваяСтрока.Пометка = ЗначениеЗаполнено(НоваяСтрока.Фамилия)
				И ЗначениеЗаполнено(НоваяСтрока.Имя)
				И ЗначениеЗаполнено(НоваяСтрока.Отчество);
			//
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	Форма.Элементы.СтраницаПартнеры.Видимость = Форма.ОбрабатыватьПартнеров;
	Форма.Элементы.СтраницаКЛ.Видимость = Форма.ОбрабатыватьКонтактныеЛица;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗаголовкиШагов(Форма)
	
	Для Каждого ЭлементСписка Из Форма.СписокШаговМастера Цикл
		
		Если ЭлементСписка.Пометка Тогда
			Форма.Элементы[ЭлементСписка.Значение].Шрифт = Новый Шрифт(); 
			ЭлементСписка.Пометка = Ложь;
		КонецЕсли;	
		
		ИмяЗакладки = ЭлементСписка.Представление;
		Если Форма.Элементы.ПанельОсновная.ТекущаяСтраница = Форма.Элементы[ИмяЗакладки] Тогда
			Форма.Элементы[ЭлементСписка.Значение].Шрифт = Новый Шрифт(, , Истина);
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;	
		
	КонецЦикла; 
		
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик ответа на вопрос перед закрытием формы.
//
// Параметры:
//	Результат				- КодВозвратаДиалога	- Ответ на вопрос.
//	ДополнительныеПараметры	- Структура				- Структура дополнительных параметров.
//
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность	= Ложь;
		Закрыть();
    КонецЕсли;
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти
