
#Область ОбработчикиСобытий

&НаКлиенте
// Процедура - обработчик команды
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если CRM_ОбщегоНазначенияКлиент.смсПроверитьДоступностьSMS4B() Тогда
		Возврат;
	КонецЕсли;
	
	Контакт = ПараметрКоманды[0];
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрКоманды",				ПараметрКоманды);
	ДополнительныеПараметры.Вставить("ПараметрыВыполненияКоманды",	ПараметрыВыполненияКоманды);
	Если ЗначениеЗаполнено(Контакт) Тогда
		// Если Открыли из списка КЛ, покажем только тек. КЛ
		ОдноКонтактноеЛицо = ?(ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров"), Истина, Ложь);
		ПараметрыФормы = Новый Структура("Контакт, Тип, Вид, ОдноКонтактноеЛицо", Контакт,
			 ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"), "СМС",
			 ОдноКонтактноеЛицо);
		ПараметрыФормы.Вставить("КлючНазначенияИспользования",	"СозданиеДокументаСМС");
		ПараметрыФормы.Вставить("СокращеннаяФорма",	"Истина");
		ОписаниеВыбора = Новый ОписаниеОповещения("ОткрытьФормуДокументаСМС", CRM_ОбщегоНазначенияКлиент,
			 ДополнительныеПараметры);
		ОткрытьФорму("ОбщаяФорма.CRM_ФормаВыбораКонтактнойИнформации", ПараметрыФормы, ЭтотОбъект, , , ,
			 ОписаниеВыбора,
			 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		CRM_ОбщегоНазначенияКлиент.ОткрытьФормуДокументаСМС(Неопределено, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти
