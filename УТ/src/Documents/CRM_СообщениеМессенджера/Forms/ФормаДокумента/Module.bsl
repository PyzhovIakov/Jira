#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	CRM_ОбщегоНазначенияСервер.ЗакончитьЗамерВремениСозданияФормы(ЭтотОбъект, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	CRM_ОбщегоНазначенияКлиент.НачатьЗамерВремениОткрытияФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	CRM_ОбщегоНазначенияКлиент.НачатьЗамерВремениЗаписиВФорме(ЭтотОбъект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти
