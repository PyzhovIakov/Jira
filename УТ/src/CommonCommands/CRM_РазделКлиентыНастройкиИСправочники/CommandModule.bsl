
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.CRM_ПанельАдминистрированияCRM.Форма.РазделКлиенты",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.CRM_ПанельАдминистрированияCRM.Форма.РазделКлиенты" 
			+ ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
