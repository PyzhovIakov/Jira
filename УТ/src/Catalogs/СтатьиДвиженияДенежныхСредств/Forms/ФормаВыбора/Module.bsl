
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокХозяйственныхОпераций = Новый Массив;
	
	Если Параметры.Отбор.Свойство("ТолькоПоступленияДенежныхСредств") Тогда
		
		ОтборПоСпискуХозяйственныхОпераций = Истина;

		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника);
		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);
		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеДоходы);
		СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТолькоРасходДенежныхСредств") Тогда
		
		ОтборПоСпискуХозяйственныхОпераций = Истина;
		
		СписокХозяйственныхОпераций = Справочники.СтатьиДвиженияДенежныхСредств.ХозяйственныеОперацииРасходаДенежныхСредств();
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация")
		И ТипЗнч(Параметры.Отбор.ХозяйственнаяОперация) = Тип("Массив") Тогда
	
		ОтборПоСпискуХозяйственныхОпераций = Истина;
		СписокХозяйственныхОпераций = Параметры.Отбор.ХозяйственнаяОперация;
	
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ХозяйственныеОперации.ХозяйственнаяОперация",
			СписокХозяйственныхОпераций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			СписокХозяйственныхОпераций.Количество());
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
