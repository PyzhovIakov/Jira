
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если CRM_ЛицензированиеКлиент.ПроверитьПодключениеОтраслевыхСервисовИОткрыть() Тогда
	
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			ИмяФормыИмпортаКлиентов = "Обработка.CRM_ЗагрузкаДанныхИзФайла.Форма.ФормаИмпортаКлиентов";
		Иначе
			ИмяФормыИмпортаКлиентов = "Обработка.CRM_ЗагрузкаДанныхИзФайла.Форма.CRM_Модуль_ФормаИмпортаКлиентов";
		КонецЕсли;
		ОткрытьФорму(ИмяФормыИмпортаКлиентов, , ПараметрыВыполненияКоманды.Источник,
			 ПараметрыВыполненияКоманды.Уникальность);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
