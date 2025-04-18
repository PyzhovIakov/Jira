
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("Отбор", КомпоновщикНастроек.Настройки.Отбор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ВладелецФормы <> Неопределено И Не ТипЗнч(ВладелецФормы) = Тип("ТаблицаФормы") Тогда
		CRM_ОбщегоНазначенияКлиент.ОпределитьУровеньПоддержки(ВладелецФормы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	СхемаКомпоновки = Справочники.CRM_УровниПоддержки.ПолучитьСхемуКомпоновки();
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОтбор = ТекущийОбъект.Отбор.Получить();
	Если ТипЗнч(ТекущийОтбор) = Тип("ОтборКомпоновкиДанных") Тогда
		Справочники.CRM_УровниПоддержки.СкопироватьОтборКомпоновкиДанных(КомпоновщикНастроек.Настройки.Отбор, ТекущийОтбор);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	ЭтоУровеньПоУмолчанию = (Объект.Ссылка = Справочники.CRM_УровниПоддержки.ПоУмолчанию);
	Если ЭтоУровеньПоУмолчанию Тогда
		Элементы.Используется.Доступность = Ложь;
		Элементы.Отбор.Доступность = Ложь;
		Элементы.СтраницыОтбор.ТекущаяСтраница = Элементы.СтраницаНетОтбора;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
