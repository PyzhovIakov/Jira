
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыВызова = Новый Структура("Источник,  Окно, НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВызова, ПараметрыВыполненияКоманды);
	
	ПараметрыВызова.Вставить("Уникальность", "Панель_РаботаСКлиентами");
	
	ИмяРаздела = "CRM_РазделРаботаСКлиентами";
	Если НЕ CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ИмяРаздела = "CRM_МодульCRM." + ИмяРаздела ;
	КонецЕсли;
	
	ВариантыОтчетовКлиент.ПоказатьПанельОтчетов(ИмяРаздела, ПараметрыВызова);
	
КонецПроцедуры

#КонецОбласти
