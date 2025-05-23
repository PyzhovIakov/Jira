
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	CRM_ЦентрМониторингаКлиент.НачатьЗамерОперацииБизнесСтатистики(
		"CRM_Статистика.Взаимодействия.Календарь.ДлительностьСценариев.ВремяОткрытияФормы", Истина);
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("CRM_КонтекстВызова", "Органайзер");
	ОткрытьФорму("Обработка.CRM_КалендарьМенеджера.Форма", ПараметрыОтчета,
		 ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		 ПараметрыВыполненияКоманды.Окно,
		 ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
