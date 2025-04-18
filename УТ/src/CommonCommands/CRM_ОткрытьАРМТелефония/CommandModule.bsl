
#Область ОбработчикиСобытий

&НаКлиенте
// Процедура - обработчик выполнения команды.
//
// Параметры:
//	ПараметрКоманды				- Произвольный	- Параметр команды.
//	ПараметрыВыполненияКоманды	- Структура		- Параметры выполнения команды.
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	CRM_ЦентрМониторингаКлиент.ЗаписатьОперациюБизнесСтатистики("CRM_Статистика.СофтФон.Подключение.РазделОрганайзерТелефония");
	ОткрытьФорму("Обработка.сфпАРМ_Телефония.Форма", , ПараметрыВыполненияКоманды.Источник,
		 ПараметрыВыполненияКоманды.Уникальность,
		 ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры 

#КонецОбласти
