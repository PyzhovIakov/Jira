
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Обработка.CRM_ПланированиеПроектов.Форма", , ПараметрыВыполненияКоманды.Источник,
		 ПараметрыВыполненияКоманды.Уникальность,
		 ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
