
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Обработка.CRM_МастерЗаполненияФИО.Форма", , ПараметрыВыполненияКоманды.Источник,
		 ПараметрыВыполненияКоманды.Уникальность);
КонецПроцедуры

#КонецОбласти
