
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ВидСправочника", "Номенклатура");
	ОткрытьФорму("Обработка.CRM_ЗагрузкаСправочниковИзФайла.Форма", ПараметрыФормы ,
		 ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры

#КонецОбласти
