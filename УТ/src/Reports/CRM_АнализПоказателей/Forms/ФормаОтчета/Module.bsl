
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьПодразделения = CRM_ОбщегоНазначенияПовтИсп.ИспользоватьПодразделения();
	
	Элементы.Подразделение.Видимость = ИспользоватьПодразделения;
	
	МодульУправлениеДоступом = CRM_ОбщегоНазначенияСервер.ОбщийМодуль("CRM_УправлениеДоступом");
	Если МодульУправлениеДоступом <> Неопределено Тогда
		МодульУправлениеДоступом.ОграничитьВыводКлиентскойБазы(ЭтотОбъект, "Результат");
	КонецЕсли;
	
	ПериодОтчета.ДатаНачала = НачалоМесяца(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса());
	ПериодОтчета.ДатаОкончания = КонецМесяца(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса());
	ПредставлениеПериода = ПредставлениеПериода(ПериодОтчета.ДатаНачала, КонецДня(ПериодОтчета.ДатаОкончания));
	ВидОтклонения = "Абсолютное";
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПересчетПоказателей" Тогда
		СформироватьОтчетНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДатаВперед(Команда)
	
	Месяцев = 1;
	ПериодОтчета.ДатаНачала = ДобавитьМесяц(ПериодОтчета.ДатаНачала, Месяцев);
	ПериодОтчета.ДатаОкончания = КонецМесяца(ДобавитьМесяц(ПериодОтчета.ДатаОкончания, Месяцев));
	ПредставлениеПериода = ПредставлениеПериода(ПериодОтчета.ДатаНачала, КонецДня(ПериодОтчета.ДатаОкончания));
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНазад(Команда)
	
	Месяцев = -1;
	ПериодОтчета.ДатаНачала = ДобавитьМесяц(ПериодОтчета.ДатаНачала, Месяцев);
	ПериодОтчета.ДатаОкончания = КонецМесяца(ДобавитьМесяц(ПериодОтчета.ДатаОкончания, Месяцев));
	ПредставлениеПериода = ПредставлениеПериода(ПериодОтчета.ДатаНачала, КонецДня(ПериодОтчета.ДатаОкончания));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Команда)
	ПараметрВыбора = Новый Структура("НачалоПериода,КонецПериода", ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.CRM_ВыборСтандартногоПериода", ПараметрВыбора, Элементы.ВыборПериода, , , ,
		 ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПериодОтчета.ДатаНачала = РезультатВыбора.НачалоПериода;
	ПериодОтчета.ДатаОкончания  = РезультатВыбора.КонецПериода;
	ПредставлениеПериода = РезультатВыбора.ПредставлениеПериода;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДанные(Команда)
	
	CRM_УправлениеЦелевымиПоказателямиКлиент.ПересчитатьПоказатели(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчетНаСервере()
	
	Результат.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Менеджер КАК Менеджер,
	|	ВложенныйЗапрос.ДатаЗначения КАК ДатаЗначения,
	|	ВложенныйЗапрос.Показатель КАК Показатель,
	|	ВложенныйЗапрос.Показатель.ПериодАнализа КАК ПериодАнализа,
	|	ВложенныйЗапрос.Факт КАК Факт,
	|	ВложенныйЗапрос.План КАК План,
	|	ВложенныйЗапрос.ПланМаксимум КАК ПланМаксимум
	|ИЗ
	|	(ВЫБРАТЬ
	|		CRM_ЗначенияКлючевыхПоказателей.Менеджер КАК Менеджер,
	|		CRM_ЗначенияКлючевыхПоказателей.ДатаЗначения КАК ДатаЗначения,
	|		CRM_ЗначенияКлючевыхПоказателей.Показатель КАК Показатель,
	|		CRM_ЗначенияКлючевыхПоказателей.Значение КАК Факт,
	|		0 КАК План,
	|		0 КАК ПланМаксимум
	|	ИЗ
	|		РегистрСведений.CRM_ЗначенияКлючевыхПоказателей КАК CRM_ЗначенияКлючевыхПоказателей
	|	ГДЕ
	|		CRM_ЗначенияКлючевыхПоказателей.ДатаЗначения МЕЖДУ &НачДата И &КонДата
	|		И CRM_ЗначенияКлючевыхПоказателей.Показатель.Включен
	|	" + ?(Менеджер.Пустая(), "", "И CRM_ЗначенияКлючевыхПоказателей.Менеджер = &Менеджер") + "
	|	" + ?(Подразделение.Пустая(), "", "И CRM_ЗначенияКлючевыхПоказателей.Менеджер.Подразделение = &Подразделение") + "
	|	" + ?(Показатель.Пустая(), "", "И CRM_ЗначенияКлючевыхПоказателей.Показатель = &Показатель") + "
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		CRM_ИспользуемыеКлючевыеПоказатели.Менеджер,
	|		CRM_ИспользуемыеКлючевыеПоказатели.Период,
	|		CRM_ИспользуемыеКлючевыеПоказатели.Показатель,
	|		0,
	|		CRM_ИспользуемыеКлючевыеПоказатели.ЗначениеПоказателя,
	|		CRM_ИспользуемыеКлючевыеПоказатели.ЗначениеПоказателяМаксимум
	|	ИЗ
	|		РегистрСведений.CRM_ИспользуемыеКлючевыеПоказатели КАК CRM_ИспользуемыеКлючевыеПоказатели
	|	ГДЕ
	|		CRM_ИспользуемыеКлючевыеПоказатели.Период МЕЖДУ &НачДата И &КонДата
	|		И CRM_ИспользуемыеКлючевыеПоказатели.Показатель.Включен
	|	" + ?(Менеджер.Пустая(), "", "И CRM_ИспользуемыеКлючевыеПоказатели.Менеджер = &Менеджер") + "
	|	" + ?(Подразделение.Пустая(), "", "И CRM_ИспользуемыеКлючевыеПоказатели.Менеджер.Подразделение = &Подразделение") + "
	|	" + ?(Показатель.Пустая(), "", "И CRM_ИспользуемыеКлючевыеПоказатели.Показатель = &Показатель") + "
	|   ) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	Менеджер,
	|	Показатель,
	|	ДатаЗначения
	|ИТОГИ
	|	СУММА(Факт),
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Показатель.ПериодАнализа = ""День""
	|			ТОГДА МАКСИМУМ(План)
	|		ИНАЧЕ СУММА(План)
	|	КОНЕЦ КАК План,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Показатель.ПериодАнализа = ""День""
	|			ТОГДА МАКСИМУМ(ПланМаксимум)
	|		ИНАЧЕ СУММА(ПланМаксимум)
	|	КОНЕЦ КАК ПланМаксимум
	|ПО
	|	Менеджер,
	|	Показатель,
	|	ДатаЗначения";
	
	Запрос.УстановитьПараметр("НачДата", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонДата", ПериодОтчета.ДатаОкончания);
	Если НЕ Менеджер.Пустая() Тогда
		Запрос.УстановитьПараметр("Менеджер", Менеджер);
	КонецЕсли;	
	Если НЕ Показатель.Пустая() Тогда
		Запрос.УстановитьПараметр("Показатель", Показатель);
	КонецЕсли;
	Если НЕ Подразделение.Пустая() Тогда
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
	КонецЕсли;

	РезультатЗапроса = Запрос.Выполнить();
	ДеревоОтчета = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	КЧ = Новый КвалификаторыЧисла(12, 2);
	Массив = Новый Массив;
	Массив.Добавить(Тип("Число"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , , КЧ);
	
	ТабРезультат = Новый ТаблицаЗначений;
	ТабРезультат.Колонки.Добавить("Менеджер");
	ТабРезультат.Колонки.Добавить("Показатель");
	ТабРезультат.Колонки.Добавить("План");
	ТабРезультат.Колонки.Добавить("ПланМаксимум");
	ТабРезультат.Колонки.Добавить("Факт");
	ТабРезультат.Колонки.Добавить("Цвет");
	НачПер = КонецДня(ПериодОтчета.ДатаНачала);
	Пока НачПер <= ПериодОтчета.ДатаОкончания Цикл
		ИмяКолонкиДата = Формат(НачПер, "ДФ=dd_MM_yyyy");
		ТабРезультат.Колонки.Добавить("Колонка_" + ИмяКолонкиДата + "_План", ОписаниеТиповЧ);
		ТабРезультат.Колонки.Добавить("Колонка_" + ИмяКолонкиДата + "_ПланМаксимум", ОписаниеТиповЧ);
		ТабРезультат.Колонки.Добавить("Колонка_" + ИмяКолонкиДата + "_Факт", ОписаниеТиповЧ);
		ТабРезультат.Колонки.Добавить("Колонка_" + ИмяКолонкиДата + "_Цвет", ОписаниеТиповЧ);
		НачПер = КонецДня(НачПер) + 1;
	КонецЦикла;	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("ЗначениеПоказателя");
	ТаблицаДанных.Колонки.Добавить("ЗначениеПоказателяМаксимум");
	ТаблицаДанных.Колонки.Добавить("Сумма");
	ТаблицаДанных.Колонки.Добавить("Количество");
	Для Каждого СтрокаМенеджер Из ДеревоОтчета.Строки Цикл
		Для Каждого СтрокаПоказатель Из СтрокаМенеджер.Строки Цикл
			ИтогФакт = 0;
			Строка = ТабРезультат.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаПоказатель);
			НачПер = КонецДня(ПериодОтчета.ДатаНачала);
			КонецОтчета = ?(ПериодОтчета.ДатаОкончания > КонецДня(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса()),
				 КонецДня(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса()),
				 ПериодОтчета.ДатаОкончания);

			Для Каждого СтрокаДата Из СтрокаПоказатель.Строки Цикл
				Если СтрокаДата.ДатаЗначения > КонецОтчета Тогда
					Прервать;
				КонецЕсли;
				ИмяКолонкиДата = Формат(СтрокаДата.ДатаЗначения, "ДФ=dd_MM_yyyy");
				Строка["Колонка_" + ИмяКолонкиДата + "_План"] = СтрокаДата.План;
				Строка["Колонка_" + ИмяКолонкиДата + "_ПланМаксимум"] = СтрокаДата.ПланМаксимум;
				Строка["Колонка_" + ИмяКолонкиДата + "_Факт"] = СтрокаДата.Факт;
				ТаблицаДанных.Очистить();
				СтрокаДанных = ТаблицаДанных.Добавить();
				
				СтрокаДанных.ЗначениеПоказателя = СтрокаПоказатель.План;
				СтрокаДанных.ЗначениеПоказателяМаксимум = СтрокаПоказатель.ПланМаксимум;
				СтрокаДанных.Сумма = СтрокаДата.Факт;
				СтрокаДанных.Количество = СтрокаДата.Факт;
				Если СтрокаПоказатель.Показатель.ПериодАнализа = "Месяц" Тогда
					Строка.Факт = СтрокаДата.Факт;
				КонецЕсли;	
				Строка["Колонка_" + ИмяКолонкиДата + "_Цвет"] = ПолучитьЦветПоказателя(Строка.Показатель, ТаблицаДанных);	
			КонецЦикла;	
			ТаблицаДанных.Очистить();
			СтрокаДанных = ТаблицаДанных.Добавить();
			СтрокаДанных.ЗначениеПоказателя = Строка.План;
			СтрокаДанных.ЗначениеПоказателяМаксимум = Строка.ПланМаксимум;
			СтрокаДанных.Сумма = Строка.Факт;
			СтрокаДанных.Количество = Строка.Факт;
			Строка.Цвет = ПолучитьЦветПоказателя(Строка.Показатель, ТаблицаДанных);

		КонецЦикла;	
	КонецЦикла;	
	
	Макет = Отчеты.CRM_АнализПоказателей.ПолучитьМакет("Макет");
	
	ТабДок = Новый ТабличныйДокумент;
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьШапка|ОбластьОсновная");
	// ОбластьМакета.Параметры.ЗаголовокОтчета = "Анализ показателей за "+ПредставлениеПериода;
	ОбластьМакета.Параметры.ДатаАктуальности = "Данные отчета актуальны на " 
		+ Формат(Константы.CRM_ДатаАктуальностиЦелевыхПоказателей.Получить(), "ДЛФ=DD; ДП='не актуален'");
	ТабДок.Вывести(ОбластьМакета);
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьШапка|ОбластьДень");
	НачПер = КонецДня(ПериодОтчета.ДатаНачала);
	КонецОтчета = ?(ПериодОтчета.ДатаОкончания > КонецДня(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса()),
		 КонецДня(CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса()),
		 ПериодОтчета.ДатаОкончания);
	Пока НачПер <= КонецОтчета Цикл
		ИмяКолонкиДата = Формат(НачПер, "ДФ='dd ddd'");
		ОбластьМакета.Параметры.ДатаЗначения = ИмяКолонкиДата;
		ОбластьМакета.Области.ЯчейкаДата.ЦветТекста = WebЦвета.Черный;
		Если ДеньНедели(НачПер) > 5 Тогда
			ОбластьМакета.Области.ЯчейкаДата.ЦветТекста = WebЦвета.СветлоСерый;
		КонецЕсли;	
		НачПер = КонецДня(НачПер) + 1;
		
		ТабДок.Присоединить(ОбластьМакета);
	КонецЦикла;
	ОбластьМакетаГраница = Макет.ПолучитьОбласть("ОбластьШапка|ОбластьПраваяГраница");	
	ТабДок.Присоединить(ОбластьМакетаГраница);
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьСтрока|ОбластьОсновная");
	ОбластьМакетаДень = Макет.ПолучитьОбласть("ОбластьСтрока|ОбластьДень");
	ОбластьМакетаГраница = Макет.ПолучитьОбласть("ОбластьСтрока|ОбластьПраваяГраница");
	ЦветЖелтый = WebЦвета.СветлоЗолотистый;
	ЦветКрасный = WebЦвета.Лосось;
	ЦветЗеленый = WebЦвета.СветлоЗеленый;
	НомерПервойСтроки = 5;
	КолСтрок = 0;
	Для Каждого Строка Из ТабРезультат Цикл
		Если ОбластьМакета.Параметры.Менеджер <> Строка.Менеджер И КолСтрок > 0 Тогда
			ТабДок.Область(НомерПервойСтроки, 2, НомерПервойСтроки + (КолСтрок - 1) * 2, 2).Объединить();
			НомерПервойСтроки = НомерПервойСтроки + КолСтрок * 2;
			КолСтрок = 0;
			
		КонецЕсли;	
		ОбластьМакета.Параметры.Менеджер = Строка.Менеджер;
		ОбластьМакета.Параметры.Показатель = Строка.Показатель.КраткоеНаименование 
			+ ?(Строка.Показатель.ЕдиницаИзмерения <> "", ", " + Лев(Строка.Показатель.ЕдиницаИзмерения, 3), "");
		ОбластьМакета.Параметры.Факт = Строка.Факт;
		ОбластьМакета.Области.ЯчейкаОтклонение.ЦветФона = WebЦвета.Белый;
		Если  Строка.Показатель.ЦелевойТренд = "Максимум" Тогда 
			ОбластьМакета.Параметры.План = "> " + Строка.План;
		ИначеЕсли  Строка.Показатель.ЦелевойТренд = "Минимум" Тогда 	
			ОбластьМакета.Параметры.План = "< " + Строка.План;
		Иначе
			ОбластьМакета.Параметры.План = "от " + Строка.План + " до " + Строка.ПланМаксимум;
		КонецЕсли;	
		Если Строка.Показатель.ПериодАнализа = "День" Тогда
			ОбластьМакета.Параметры.Отклонение = "-";
			// ОбластьМакета.Параметры.План = "";
			ОбластьМакета.Параметры.Факт = "-";
		Иначе
			Если ВидОтклонения = "Абсолютное" Тогда
				ОбластьМакета.Параметры.Отклонение = Строка.Факт - Строка.План;
			Иначе
				ОбластьМакета.Параметры.Отклонение = ?(Строка.План = 0, "-", Строка.Факт / Строка.План * 100 - 100);
			КонецЕсли;	
			Если  Показатель.ЦелевойТренд = "Интервал" Тогда 
				Если Строка.Факт < Строка.План Тогда
					Если ВидОтклонения = "Абсолютное" Тогда
						ОбластьМакета.Параметры.Отклонение = Строка.Факт - Строка.План;
					Иначе
						ОбластьМакета.Параметры.Отклонение = ?(Строка.План = 0, "-", Строка.Факт / Строка.План * 100 - 100);
					КонецЕсли;
				КонецЕсли;	
				Если Строка.Факт > Строка.ПланМаксимум Тогда
					Если ВидОтклонения = "Абсолютное" Тогда
						ОбластьМакета.Параметры.Отклонение = Строка.Факт - Строка.ПланМаксимум;
					Иначе
						ОбластьМакета.Параметры.Отклонение = ?(Строка.ПланМаксимум = 0, "-",
							 Строка.Факт / Строка.ПланМаксимум * 100 - 100);
					КонецЕсли;
				КонецЕсли;	
				Если Строка.Факт <= Строка.ПланМаксимум И Строка.Факт >= Строка.План Тогда
					ОбластьМакета.Параметры.Отклонение = "-";
				КонецЕсли;
			КонецЕсли;	
			Если Строка["Цвет"] = 0 Тогда
				ОбластьМакета.Области.ЯчейкаОтклонение.ЦветФона = ЦветКрасный;
			ИначеЕсли Строка["Цвет"] = 1 Тогда
				ОбластьМакета.Области.ЯчейкаОтклонение.ЦветФона = ЦветЖелтый;	
			ИначеЕсли Строка["Цвет"] = 2 Тогда
				ОбластьМакета.Области.ЯчейкаОтклонение.ЦветФона = ЦветЗеленый;
			КонецЕсли;
		КонецЕсли;	
		
		ТабДок.Вывести(ОбластьМакета);
		НачПер = КонецДня(ПериодОтчета.ДатаНачала);
		Пока НачПер <= КонецОтчета Цикл
			ИмяКолонкиДата = Формат(НачПер, "ДФ=dd_MM_yyyy");
			ОбластьМакетаДень.Параметры.ЗначениеПоказателя = Строка["Колонка_" + ИмяКолонкиДата + "_Факт"]; 
			ОбластьМакетаДень.Области.ЦветПоказателя.ЦветФона = WebЦвета.Белый;
			
			Если Строка["Колонка_" + ИмяКолонкиДата + "_Цвет"] = 0 Тогда
				ОбластьМакетаДень.Области.ЦветПоказателя.ЦветФона = ЦветКрасный;
			ИначеЕсли Строка["Колонка_" + ИмяКолонкиДата + "_Цвет"] = 1 Тогда
				ОбластьМакетаДень.Области.ЦветПоказателя.ЦветФона = ЦветЖелтый;	
			ИначеЕсли Строка["Колонка_" + ИмяКолонкиДата + "_Цвет"] = 2 Тогда
				ОбластьМакетаДень.Области.ЦветПоказателя.ЦветФона = ЦветЗеленый;
			КонецЕсли;	
			ОбластьМакетаДень.Области.ЯчейкаЗначение.ЦветТекста = WebЦвета.Черный;
			Если ДеньНедели(НачПер) > 5 Тогда
				ОбластьМакетаДень.Области.ЯчейкаЗначение.ЦветТекста = WebЦвета.СветлоСерый;
				ОбластьМакетаДень.Области.ЦветПоказателя.ЦветФона = WebЦвета.Белый;
			КонецЕсли;
			
			ТабДок.Присоединить(ОбластьМакетаДень);
			НачПер = КонецДня(НачПер) + 1;
		КонецЦикла;
		КолСтрок = КолСтрок + 1;
			
		ТабДок.Присоединить(ОбластьМакетаГраница);
	КонецЦикла;	
	ТабДок.Область(НомерПервойСтроки, 2, НомерПервойСтроки + (КолСтрок - 1) * 2, 2).Объединить();
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьПодвал|ОбластьОсновная");	
	ТабДок.Вывести(ОбластьМакета);
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьПодвал|ОбластьДень");
	НачПер = КонецДня(ПериодОтчета.ДатаНачала);
	Пока НачПер <= КонецОтчета Цикл
		НачПер = КонецДня(НачПер) + 1;
		
		ТабДок.Присоединить(ОбластьМакета);
	КонецЦикла;
	
	Результат.Вывести(ТабДок);
	Результат.ФиксацияСлева = 3;
	Результат.ФиксацияСверху = 4;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЦветПоказателя(Показатель, ТаблицаДанных) 
	
	КонтролируемыйПоказатель = Показатель.КонтролируемыйПоказатель;
	
	Если  Показатель.ЦелевойТренд = "Максимум" Тогда
		
		ПлановоеЗначение = ТаблицаДанных.Итог("ЗначениеПоказателя");
		ТекущееЗначение = ТаблицаДанных.Итог(КонтролируемыйПоказатель);
		
		Если ТекущееЗначение <= ПлановоеЗначение * 0.5 Тогда
			Возврат 0;
		ИначеЕсли ТекущееЗначение > ПлановоеЗначение * 0.5 И ТекущееЗначение <= ПлановоеЗначение * 0.8 Тогда
			Возврат 1;
		Иначе
			Возврат 2;
		КонецЕсли;	
	ИначеЕсли  Показатель.ЦелевойТренд = "Минимум" Тогда
		
		ПлановоеЗначение = ТаблицаДанных.Итог("ЗначениеПоказателя");
		ТекущееЗначение = ТаблицаДанных.Итог(КонтролируемыйПоказатель);
		
		Если ПлановоеЗначение = 0 Тогда
			
			Если ТекущееЗначение > 3 Тогда
				Возврат 0;
			ИначеЕсли ТекущееЗначение > 1 И ТекущееЗначение <= 3 Тогда
				Возврат 1;
			Иначе
				Возврат 2;
			КонецЕсли;
			
		Иначе	
			
			Если ТекущееЗначение > ПлановоеЗначение * 1.5 Тогда
				Возврат 0;
			ИначеЕсли ТекущееЗначение > ПлановоеЗначение * 1.2 И ТекущееЗначение <= ПлановоеЗначение * 1.5 Тогда
				Возврат 1;
			Иначе
				Возврат 2;
			КонецЕсли;
			
		КонецЕсли;	
		
	Иначе
		
		ПлановоеЗначениеМин = ТаблицаДанных.Итог("ЗначениеПоказателя");
		ПлановоеЗначениеМакс = ТаблицаДанных.Итог("ЗначениеПоказателяМаксимум");
		ТекущееЗначение = ТаблицаДанных.Итог(КонтролируемыйПоказатель);
		
		Если ТекущееЗначение <= ПлановоеЗначениеМин * 0.5 ИЛИ ТекущееЗначение >= ПлановоеЗначениеМакс * 1.5 Тогда
			Возврат 0;
		ИначеЕсли (ТекущееЗначение > ПлановоеЗначениеМин * 0.5
			 И ТекущееЗначение <= ПлановоеЗначениеМин * 0.8) ИЛИ (ТекущееЗначение >= ПлановоеЗначениеМакс * 1.2
			 И ТекущееЗначение < ПлановоеЗначениеМакс * 1.5) Тогда
			Возврат 1;
		Иначе
			Возврат 2;
		КонецЕсли;
	
	КонецЕсли;

КонецФункции

#КонецОбласти
