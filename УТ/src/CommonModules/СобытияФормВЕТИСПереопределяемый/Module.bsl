#Область Локализация

// Переопределение параметров интеграции ВЕТИС (расположения форматированной строки)
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   ПараметрыНадписи - Структура        - (см. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования)
Процедура ПриОпределенииПараметровИнтеграцииВЕТИС(Форма, ПараметрыНадписи) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Обработка.ПодборСерийВДокументы.Форма.УказаниеСерииВСтрокеТоваров" Тогда
			ПараметрыНадписи.ИмяРеквизитаФормы = "";
			ПараметрыНадписи.ИмяЭлементаФормы = "";
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ГруппаСостояние") Тогда
		ПараметрыНадписи.РазмещениеВ = "ГруппаСостояние";
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры


Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                       НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ПриИзмененииНоменклатуры(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ИмяТЧ = ПараметрыЗаполнения.ИмяТабличнойЧасти;
	
	ЗаполнитьПризнакАртикул                    = Новый Структура("Номенклатура", "Артикул");
	ЗаполнитьПризнакТипНоменклатуры            = Новый Структура("Номенклатура", "ТипНоменклатуры");
	НоменклатураПриИзмененииПереопределяемый   = Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, ИмяТЧ);
	ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	ЗаполнитьПризнакЕдиницаИзмерения           = Новый Структура("Номенклатура", "ЕдиницаИзмерения");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул",                    ЗаполнитьПризнакАртикул);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",            ЗаполнитьПризнакТипНоменклатуры);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",   НоменклатураПриИзмененииПереопределяемый);
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",         ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", ЗаполнитьПризнакХарактеристикиИспользуются);
	СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения",           ЗаполнитьПризнакЕдиницаИзмерения);
	СтруктураДействий.Вставить("ЗаполнитьПродукциюВЕТИС",                    ПараметрыЗаполнения);
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		ПересчитатьКоличествоЕдиницВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПересчитатьКоличествоЕдиницВЕТИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ПересчитатьКоличествоЕдиницПоВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницПоВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", ПересчитатьКоличествоЕдиницПоВЕТИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус Тогда
		
		Если ПараметрыУказанияСерий <> Неопределено
			И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад)
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта], ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			Склад = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта][ПараметрыУказанияСерий.ИмяПоляСклад];
			
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад);
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПроверитьСериюРассчитатьСтатус);
		
	КонецЕсли;
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                       НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ПриИзмененииХарактеристики(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ИмяТЧ = ПараметрыЗаполнения.ИмяТабличнойЧасти;
	
	ХарактеристикаПриИзмененииПереопределяемый = Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, ИмяТЧ);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", ХарактеристикаПриИзмененииПереопределяемый);
	СтруктураДействий.Вставить("ЗаполнитьПродукциюВЕТИС",                    ПараметрыЗаполнения);
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//  КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
Процедура ПриИзмененииКоличестваВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ПересчитатьКоличествоЕдиницПоВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницПоВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", ПересчитатьКоличествоЕдиницПоВЕТИС);
	КонецЕсли;
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Форма, в которой произошло событие.
//	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка таблицы товаров.
//	КэшированныеЗначения - Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//	ПараметрыЗаполнения - (См. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти).
//
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		ПересчитатьКоличествоЕдиницВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПересчитатьКоличествоЕдиницВЕТИС);
	КонецЕсли;
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Заполняет табличную часть Товары подобранными товарами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//  ПараметрыУказанияСерий - Структура - Состав полей определен в функции 
//                                     НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ОбработкаРезультатаПодбораНоменклатуры(Форма,
												ВыбранноеЗначение,
												ПараметрыЗаполнения,
												ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	КэшированныеЗначения = ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	ИмяТабличнойЧасти = Неопределено;
	Если НЕ ПараметрыЗаполнения.Свойство("ИмяТабличнойЧасти", ИмяТабличнойЧасти) Тогда
		ИмяТабличнойЧасти = "Товары";
	КонецЕсли;
	
	ТекущаяСтрока = Неопределено;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);

	Если ПараметрыЗаполнения.Свойство("ЗаполнитьПродукциюВЕТИС") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПродукциюВЕТИС", ПараметрыЗаполнения);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ПересчитатьКоличествоЕдиницВЕТИС") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПараметрыЗаполнения);
	КонецЕсли;
		
	Если ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус Тогда
		
		Если ПараметрыУказанияСерий <> Неопределено
			И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад)
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта], ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			Склад = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта][ПараметрыУказанияСерий.ИмяПоляСклад];
			
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад);
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПроверитьСериюРассчитатьСтатус);
		
	КонецЕсли;
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",
		Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, ИмяТабличнойЧасти));
		
	ОбрабатываемыеСтроки = Новый Массив();
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Форма.Объект[ИмяТабличнойЧасти].Добавить();
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара,,"НомерСтроки");
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока,ПараметрыЗаполнения.ДанныеЗаполнения);
		
		Если ПараметрыЗаполнения.УстановитьУникальныйИдентификаторСтроки Тогда
			ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		КонецЕсли;
		
		ОбрабатываемыеСтроки.Добавить(ТекущаяСтрока);
		
		Если ПараметрыЗаполнения.Свойство("ДобавленныеСтроки") Тогда
			ПараметрыЗаполнения.ДобавленныеСтроки.Добавить(ТекущаяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ОбработатьСтрокиТЧ(
		ОбрабатываемыеСтроки,
		СтруктураДействий,
		Форма.Объект[ИмяТабличнойЧасти],
		КэшированныеЗначения);
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
