
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Документ.CRM_Телемаркетинг.ФормаСписка", , ПараметрыВыполненияКоманды.Источник,
		 ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		 ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти
