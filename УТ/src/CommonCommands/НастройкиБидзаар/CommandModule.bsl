
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Раздел"			, "НастройкиИнтеграцииСБидзаар");
	ПараметрыФормы.Вставить("Заголовок"			, НСтр("ru = 'Интеграция с Бидзаар'"));
	ПараметрыФормы.Вставить("ОписаниеРаздела"	, НСтр("ru = 'Настройки интеграции с Бидзаар'"));
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияИнтеграцийСЭТП.Форма.Форма",
		ПараметрыФормы,,Истина);

КонецПроцедуры

#КонецОбласти