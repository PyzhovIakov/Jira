 #Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Номенклатура = Параметры.Номенклатура;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьФорму();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьНовый(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Номенклатура", Номенклатура);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму(
	"РегистрСведений.ШтрихкодыНоменклатуры.ФормаЗаписи", ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьФорму(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьФормуНаСервере(); 

КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуНаСервере() Экспорт
	
	Штрихкоды.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
		|	ШтрихкодыНоменклатуры.Упаковка КАК Упаковка
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = Штрихкоды.Добавить();
		НоваяСтрока.Штрихкод = ВыборкаДетальныеЗаписи.Штрихкод;
		НоваяСтрока.Характеристика = ВыборкаДетальныеЗаписи.Характеристика;
		НоваяСтрока.Упаковка = ВыборкаДетальныеЗаписи.Упаковка;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти