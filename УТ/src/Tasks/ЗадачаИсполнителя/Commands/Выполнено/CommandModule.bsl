///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбраны задачи.'"));
		Возврат;
	КонецЕсли;
	
	// +CRM
	CRM_БизнесПроцессыИЗадачиКлиент.ЗадачаИсполнителя_Выполнено_ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды);
	Возврат;
	// -CRM
	
	ОчиститьСообщения();
	Для Каждого Задача Из ПараметрКоманды Цикл
		БизнесПроцессыИЗадачиВызовСервера.ВыполнитьЗадачу(Задача, Истина);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Задача выполнена'"),
			ПолучитьНавигационнуюСсылку(Задача),
			Строка(Задача));
	КонецЦикла;
	Оповестить("Запись_ЗадачаИсполнителя", Новый Структура("Выполнена", Истина), ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти