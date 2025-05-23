
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПисьмоОбменСБанками.Ссылка КАК Ссылка,
		|	ПисьмоОбменСБанками.Идентификатор КАК Идентификатор,
		|	ПисьмоОбменСБанками.ИдентификаторИсходногоПисьма КАК ИдентификаторИсходногоПисьма,
		|	ВЫБОР
		|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭДО.Входящий)
		|			ТОГДА ПисьмоОбменСБанками.Организация
		|		ИНАЧЕ ПисьмоОбменСБанками.Банк
		|	КОНЕЦ КАК Кому,
		|	ВЫБОР
		|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭДО.Исходящий)
		|			ТОГДА ПисьмоОбменСБанками.Организация
		|		ИНАЧЕ ПисьмоОбменСБанками.Банк
		|	КОНЕЦ КАК ОтКого,
		|	ВЫБОР
		|		КОГДА ПисьмоОбменСБанками.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияЭДО.Входящий)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Вид,
		|	ПисьмоОбменСБанками.Тема КАК Тема,
		|	ПисьмоОбменСБанками.Дата КАК Дата,
		|	ПисьмоОбменСБанками.ЕстьВложение КАК ЕстьВложение
		|ИЗ
		|	Документ.ПисьмоОбменСБанками КАК ПисьмоОбменСБанками
		|ГДЕ
		|	ПисьмоОбменСБанками.ИдентификаторПереписки = &ИдентификаторПереписки";
	
	Запрос.УстановитьПараметр("ИдентификаторПереписки", Параметры.ИдентификаторПереписки);
	РезультатЗапроса = Запрос.Выполнить();             
	ТаблицаВсехПисем = РезультатЗапроса.Выгрузить(); 
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИдентификаторИсходногоПисьма", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ПисьмаВерхнегоУровня = ТаблицаВсехПисем.НайтиСтроки(Отбор);   
	
	ДеревоЗначений = РеквизитФормыВЗначение("ДеревоПисем");
	Для Каждого ВыборкаПисьмо Из ПисьмаВерхнегоУровня Цикл
		СтрокаДерева = ДеревоЗначений.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДерева, ВыборкаПисьмо);
		ЗаполнитьПодчиненныеПисьмаРекурсивно(СтрокаДерева, ВыборкаПисьмо.Идентификатор, ТаблицаВсехПисем);
	КонецЦикла;  
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоПисем");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого СтрокаДерева Из ДеревоПисем.ПолучитьЭлементы() Цикл
		Элементы.ДеревоПисем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПисем 

&НаКлиенте
Процедура ДеревоПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение( , Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПодчиненныеПисьмаРекурсивно(ДеревоЗначений, ИдентификаторИсходногоПисьма, ТаблицаВсехПисем)  
	
	Отбор = Новый Структура("ИдентификаторИсходногоПисьма",ИдентификаторИсходногоПисьма);
	ПодчиненныеПисьма = ТаблицаВсехПисем.НайтиСтроки(Отбор);   
	
	Для Каждого СтрПисьмо Из ПодчиненныеПисьма Цикл 
		СтрокаДерева = ДеревоЗначений.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрПисьмо);
		ЗаполнитьПодчиненныеПисьмаРекурсивно(СтрокаДерева, СтрПисьмо.Идентификатор, ТаблицаВсехПисем);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти  

