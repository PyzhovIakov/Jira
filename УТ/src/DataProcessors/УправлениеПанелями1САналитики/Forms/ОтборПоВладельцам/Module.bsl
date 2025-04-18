#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаВладельцев.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Закрыть(АдресВоВременномХранилище());
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ОтметитьЭлементыТаблицы(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	ОтметитьЭлементыТаблицы(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтметитьЭлементыТаблицы(Пометка) 
	Для Каждого Строка Из ТаблицаВладельцев Цикл
		Строка.Пометка = Пометка;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция АдресВоВременномХранилище()
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВладельцев.Выгрузить(), УникальныйИдентификатор)
КонецФункции

#КонецОбласти
