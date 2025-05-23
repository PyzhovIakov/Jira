
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ТекстПояснения = "";
	ВысотаПояснения = 1;
	
	Если Параметры.Отбор.Свойство("Ссылка")
	 И ТипЗнч(Параметры.Отбор.Ссылка) = Тип("СписокЗначений") Тогда
	 	
	 	ДоступныеВарианты = Параметры.Отбор.Ссылка;
		Если ДоступныеВарианты.НайтиПоЗначению(Перечисления.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУчестьПриИнвентаризации) <> Неопределено
			Или Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУвеличениеКоличестваПоОрдерномуСкладу" Тогда
			ВысотаПояснения = 4;
			ТекстПояснения = НСтр("ru='Количество товара по документу больше. Используется ордерная схема при отражении излишков и недостач.'") + Символы.ПС + Символы.ПС;
		ИначеЕсли ДоступныеВарианты.НайтиПоЗначению(Перечисления.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУвеличитьСкладскиеОстатки) <> Неопределено
			Или Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУвеличениеКоличестваБезИнвентаризации" Тогда
			ВысотаПояснения = 4;
			ТекстПояснения = НСтр("ru='Количество товара по документу больше. Не используется ордерная схема при отражении излишков и недостач.'") + Символы.ПС + Символы.ПС;
		ИначеЕсли ДоступныеВарианты.НайтиПоЗначению(Перечисления.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУчестьПриИнвентаризации) <> Неопределено
			Или Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУменьшениеКоличестваПоОрдерномуСкладу" Тогда
			ВысотаПояснения = 4;
			ТекстПояснения = НСтр("ru='Количество товара по документу меньше. Используется ордерная схема при отражении излишков и недостач.'") + Символы.ПС + Символы.ПС;
		ИначеЕсли ДоступныеВарианты.НайтиПоЗначению(Перечисления.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУменьшитьСкладскиеОстатки) <> Неопределено
			Или Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУменьшениеКоличестваБезИнвентаризации" Тогда
			ВысотаПояснения = 4;
			ТекстПояснения = НСтр("ru='Количество товара по документу меньше. Не используется ордерная схема при отражении излишков и недостач.'") + Символы.ПС + Символы.ПС;
		ИначеЕсли Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУменьшениеСуммы" Тогда
			ВысотаПояснения = 2;
			ТекстПояснения = НСтр("ru='Сумма по документу меньше.'") + Символы.ПС + Символы.ПС;
		ИначеЕсли Параметры.ИмяСвойстваДляРезультатаВыбора = "ВариантОтраженияУвеличениеСуммы" Тогда
			ВысотаПояснения = 2;
			ТекстПояснения = НСтр("ru='Сумма по документу больше.'") + Символы.ПС + Символы.ПС;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ТекстПояснения.Высота = ВысотаПояснения;
	ТекстПояснения = ТекстПояснения + НСтр("ru='Выберите вариант отражения расхождений:'");
	
КонецПроцедуры

#КонецОбласти
