#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗаписиКалендаря = Новый Массив;
	Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
		
		ЗаписьКалендаря = cbr_КаленарьКлиентСервер.НовыйЭлементЗаписиКалендаря();
		ЗаписьКалендаря.Ссылка = ЭлементПараметраКоманды;
		
		ЗаписиКалендаря.Добавить(ЗаписьКалендаря);
		
	КонецЦикла;
КонецПроцедуры

#КонецОбласти