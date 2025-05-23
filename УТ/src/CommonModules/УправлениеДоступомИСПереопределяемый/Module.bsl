#Область ПрограммныйИнтерфейс

// Одноименная процедура для заполнения текста органичения подсистемы БСП Управление доступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.
//  
// Параметры:
// 	МетаданныеОбъекта - ОбъектМетаданных - метаданные вызывающего объекта.
// 	Ограничение - Структура - Структура ограничения:
// 	 * Текст - Строка - Текст ограничения.
//
Процедура ПриЗаполненииОграниченияДоступа(МетаданныеОбъекта, Ограничение) Экспорт
	
	//++ НЕ ГОСИС
	
	Если Метаданные.Документы.МаркировкаТоваровИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ОтгрузкаТоваровИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ПриемкаТоваровИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ВыводИзОборотаИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ВозвратВОборотИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ = МетаданныеОбъекта
		Или Метаданные.Документы.ПеремаркировкаТоваровИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.СписаниеКодовМаркировкиИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.УточнениеСведенийОКодахМаркировкиИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ПодключениеКегаКОборудованиюРозливаИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ОтчетИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.РазрешениеНаОтгрузкуИСМП = МетаданныеОбъекта
		Или Метаданные.Документы.ПеремещениеМеждуМОДИСМП = МетаданныеОбъекта Тогда
		
		Ограничение.Текст =
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(Организация)";
		
	ИначеЕсли Метаданные.РегистрыСведений.ПулКодовМаркировкиСУЗ = МетаданныеОбъекта
		Или Метаданные.РегистрыСведений.НастройкиОбменаСУЗ = МетаданныеОбъекта
		Или Метаданные.РегистрыСведений.ОчередьСообщенийИСМП = МетаданныеОбъекта Тогда
		
		Ограничение.Текст =
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(Организация)";
	
	ИначеЕсли Метаданные.Документы.ВнесениеСведенийОСобранномУрожаеЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ЗапросОстатковПартийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ОформлениеСДИЗЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ПогашениеСДИЗЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.СписаниеПартийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ФормированиеПартийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ФормированиеПартийИзДругихПартийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Документы.ФормированиеПартийПриПроизводствеЗЕРНО = МетаданныеОбъекта
		Или Метаданные.Справочники.ДоговорыХраненияПартийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.РегистрыСведений.ОчередьСообщенийЗЕРНО = МетаданныеОбъекта
		Или Метаданные.РегистрыСведений.ВскрытыеПотребительскиеУпаковкиИС = МетаданныеОбъекта
		Или Метаданные.РегистрыСведений.СинхронизацияДанныхИСМП = МетаданныеОбъекта Тогда
		
		Ограничение.Текст =
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(Организация)";
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти