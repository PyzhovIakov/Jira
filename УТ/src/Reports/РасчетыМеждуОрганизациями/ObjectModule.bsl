#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.ФормаПараметры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДанныеПоРасчетам");
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
		ПараметрДанных.ИдентификаторПользовательскойНастройки);
		
	Если ПользовательскаяНастройка <> Неопределено Тогда
		
		Если ПользовательскаяНастройка.Значение = 2 // В валюте упр. учета
			ИЛИ ПользовательскаяНастройка.Значение = 3 Тогда // В валюте регл. учета
				#Область АктуализацияВзаиморасчетов
				УстановитьПривилегированныйРежим(Истина);
				ПоляОтбора = РаспределениеВзаиморасчетовВызовСервера.ПоляОтбораПоУмолчанию();
				ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
				РаспределениеВзаиморасчетовВызовСервера.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства);
				УстановитьПривилегированныйРежим(Ложь);
				#КонецОбласти
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РаспределениеВзаиморасчетовВызовСервера.ВывестиАктуальностьРасчетов(ДокументРезультат, ДопСвойства);
	#КонецОбласти

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли