
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Справочник.ДемонстрационныеСценарии.ФормаСписка",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность, 
	             ПараметрыВыполненияКоманды.Окно,
	             ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
