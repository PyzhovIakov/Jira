
#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ЛичныйКабинетСервисаКлиент.ЗапуститьЛичныйКабинетСервиса
// Открывает личный кабинет сервиса. Доступность использования личного кабинета определяется
// в РаботаВМоделиСервиса.ЛичныйКабинетСервисаДоступен.
// Параметры:
//  Владелец - ФормаКлиентскогоПриложения
//  Уникальность - Произвольный
//  Окно - ОкноКлиентскогоПриложения
//  НавигационнаяСсылка - Строка
Процедура ЗапуститьЛичныйКабинетСервиса(Владелец = Неопределено, Уникальность = Неопределено, Окно = Неопределено,
	НавигационнаяСсылка = Неопределено) Экспорт
	ЛичныйКабинетСервисаКлиент.ЗапуститьЛичныйКабинетСервиса(Владелец, Уникальность, Окно, НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы
// 
// Параметры:
//	Параметры - См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.Параметры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ОбластьДанныхЗаблокирована") Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент,
			ПараметрыКлиента.ОбластьДанныхЗаблокирована);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти