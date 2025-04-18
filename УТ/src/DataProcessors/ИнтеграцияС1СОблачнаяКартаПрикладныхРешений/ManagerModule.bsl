#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "Форма" И НЕ Параметры.Свойство("Ключ") Тогда
		ВыбраннаяФорма = "ОбщаяФорма.Вопрос";
		
		Параметры.Вставить("Заголовок", НСтр("ru = '1С:Облачная карта прикладных решений'"));
		Параметры.Вставить("ТекстСообщения", НСтр("ru = 'Интеграция с 1С:Облачная карта прикладных решений недоступна на мобильном клиенте'"));
		Параметры.Вставить("Кнопки", "РежимДиалогаВопрос.ОК");
		Параметры.Вставить("КнопкаПоУмолчанию", "КодВозвратаДиалога.ОК");
		Параметры.Вставить("ВыделятьКнопкуПоУмолчанию", Истина);
		Параметры.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Ложь); 
		
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

