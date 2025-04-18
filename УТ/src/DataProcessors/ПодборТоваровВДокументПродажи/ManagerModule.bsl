#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить статус указания серии в строке
//  Заполняет статусы указания серий для набора строк.
// Параметры:
//  СтрокиДляУстановкиСтатусаСерий - Массив из СтрокаТабличнойЧасти - Набор строк для указания статуса
//  ПараметрыУказанияСерий		   - см. НоменклатураКлиентСервер.ПараметрыУказанияСерий
//  ВариантОбеспечения			   - ПеречислениеСсылка.ВариантыОбеспечения - Если не указан, берётся из строки
//
Процедура ЗаполнитьСтатусУказанияСерииВСтроке(СтрокиДляУстановкиСтатусаСерий, ПараметрыУказанияСерий, ВариантОбеспечения = Неопределено) Экспорт
	
	Если СтрокиДляУстановкиСтатусаСерий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПустаяСерия = Новый Структура("Серия", Справочники.СерииНоменклатуры.ПустаяСсылка());

	Если Не ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
		Для каждого Строка Из СтрокиДляУстановкиСтатусаСерий Цикл
			Строка.СтатусУказанияСерий = 0;
			ЗаполнитьЗначенияСвойств(Строка, ПустаяСерия);
		КонецЦикла;
		Возврат;
	КонецЕсли;
		
	ПерваяСтрока = СтрокиДляУстановкиСтатусаСерий[0];

	Склад = ПерваяСтрока.Склад;

	СтруктураСклады = Новый Структура;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСклад, Склад);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСкладОтправитель) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСкладОтправитель, Склад);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСкладПолучатель) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСкладПолучатель, Справочники.Склады.ПустаяСсылка());
	КонецЕсли;

	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("ВариантОбеспечения", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыОбеспечения"));
	ТаблицаТоваров.Колонки.Добавить("Обособленно", Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить(ПараметрыУказанияСерий.ИмяПоляКоличество, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный)));
	ТаблицаТоваров.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ТаблицаТоваров.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
		ТаблицаТоваров.Колонки.Добавить(ПараметрыУказанияСерий.ИмяПоляСклад, Новый ОписаниеТипов("СправочникСсылка.Склады"));
	КонецЕсли;

	НоменклатураСервер.ДополнитьТаблицуКолонкамиПоПолямПараметровУказанияСерий(ПараметрыУказанияСерий, ТаблицаТоваров); // Здесь же СтатусУказанияСерий

	Для каждого Строка Из СтрокиДляУстановкиСтатусаСерий Цикл
		Если ВариантОбеспечения = Неопределено Тогда
			ВариантОбеспеченияСтроки = Строка.ВариантОбеспечения;
		Иначе
			ВариантОбеспеченияСтроки = ВариантОбеспечения;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Строка.Номенклатура)
			Или Не ЗначениеЗаполнено(Строка.Склад)
			Или ПараметрыУказанияСерий.ЭтоЗаказ
				И ВариантОбеспеченияСтроки <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить")
				И ВариантОбеспеченияСтроки <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада") Тогда
			Строка.СтатусУказанияСерий = 0;
			ЗаполнитьЗначенияСвойств(Строка, ПустаяСерия);
		Иначе
			НоваяСтрока = ТаблицаТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			Если ВариантОбеспечения <> Неопределено Тогда
				НоваяСтрока.ВариантОбеспечения = ВариантОбеспеченияСтроки;
			КонецЕсли;
			НоваяСтрока.НомерСтроки = ТаблицаТоваров.Индекс(НоваяСтрока) + 1;
		КонецЕсли;
	КонецЦикла;

	Если ТаблицаТоваров.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ОбъектСтруктура = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаТоваров[0]);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ОбъектСтруктура, СтруктураСклады, Истина);

	Если Не ПараметрыУказанияСерий.ТоварВШапке Тогда
		ОбъектСтруктура.Вставить(ПараметрыУказанияСерий.ИмяТЧТовары, ТаблицаТоваров);
	КонецЕсли;

	Если ПараметрыУказанияСерий.ИмяТЧСерии <> ПараметрыУказанияСерий.ИмяТЧТовары
		И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяТЧСерии) Тогда
		ТаблицаСерий = ТаблицаТоваров.Скопировать();
		ОбъектСтруктура.Вставить(ПараметрыУказанияСерий.ИмяТЧСерии, ТаблицаСерий);
	КонецЕсли;
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ОбъектСтруктура, ПараметрыУказанияСерий);

	Если ПараметрыУказанияСерий.ТоварВШапке Тогда
		ПерваяСтрока.СтатусУказанияСерий = ?(ОбъектСтруктура.СтатусУказанияСерий > 8, ОбъектСтруктура.СтатусУказанияСерий, 0);
		Если ПерваяСтрока.СтатусУказанияСерий = 0 Тогда
			ЗаполнитьЗначенияСвойств(ПерваяСтрока, ПустаяСерия);
		КонецЕсли;
	Иначе
		Для каждого СтрокаТабличнойЧасти Из ОбъектСтруктура[ПараметрыУказанияСерий.ИмяТЧТовары] Цикл
			Строка = СтрокиДляУстановкиСтатусаСерий.Получить(СтрокаТабличнойЧасти.НомерСтроки - 1);
			Строка.СтатусУказанияСерий = ?(СтрокаТабличнойЧасти.СтатусУказанияСерий > 8, СтрокаТабличнойЧасти.СтатусУказанияСерий, 0);
			Если Строка.СтатусУказанияСерий = 0 Тогда
				ЗаполнитьЗначенияСвойств(Строка, ПустаяСерия);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли