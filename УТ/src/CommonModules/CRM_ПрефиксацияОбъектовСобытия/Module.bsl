
#Область СлужебныеПроцедурыИФункции

Процедура CRM_УстановитьПрефиксИнформационнойБазыИОрганизацииНомеруДокументаИнтересПриУстановкеНовогоНомера(Источник,
	 СтандартнаяОбработка,
	 Префикс) Экспорт
	Если Источник.СостояниеИнтереса.Родитель.ЭтоПоддержка Тогда
		Префикс = "О";
	Иначе
		Префикс = "И";
	КонецЕсли;
	
	ПрефиксИБ = "";
	ПрефиксацияОбъектовСобытия.ПриОпределенииПрефиксаИнформационнойБазы(ПрефиксИБ);
	ПрефиксИБ = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(ПрефиксИБ, 2, "0", "Слева");
	
	ШаблонПрефикса = "[Префикс][ПрефиксИБ]-";
	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[Префикс]", Префикс);
	ШаблонПрефикса = СтрЗаменить(ШаблонПрефикса, "[ПрефиксИБ]", ПрефиксИБ);
	
	Префикс = ШаблонПрефикса;
	
КонецПроцедуры

#КонецОбласти
