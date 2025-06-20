#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область СлужебныеПроцедурыИФункции
// Установить взята в работу для последнего исполнителя
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
//				- СправочникСсылка.cbr_Роли. 
//				- СправочникСсылка.cbr_ГруппыДоступаКЗадачам. 
//  ВыбраннаяДоска - СправочникСсылка.cbr_Доски
Процедура ИзменениеНастроекДоска(Пользователь, ВыбраннаяДоска) Экспорт 
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(Пользователь);
	Набор.Прочитать();
	Если Набор.Количество() Тогда
		Запись = Набор[0];
		Запись.Доска = ВыбраннаяДоска;
	Иначе
		Запись = Набор.Добавить();
		Запись.Пользователь = Пользователь;
		Запись.Доска = ВыбраннаяДоска;
	КонецЕсли;
	Набор.Записать();
		
КонецПроцедуры

// Установить взята в работу для последнего исполнителя
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи.
//				- СправочникСсылка.cbr_Роли. 
//				- СправочникСсылка.cbr_ГруппыДоступаКЗадачам. 
//  АвтообновлениеДоски - Число
//  Акцентирование - Булево
Процедура ИзменениеНастроекАвтообновление(Пользователь, АвтообновлениеДоски, Акцентирование) Экспорт 
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(Пользователь);
	Набор.Прочитать();
	Если Набор.Количество() Тогда
		Запись = Набор[0];
		Запись.АвтообновлениеДоски = АвтообновлениеДоски;
		Запись.Акцентирование = Акцентирование;
	Иначе
		Запись = Набор.Добавить();
		Запись.Пользователь = Пользователь;
		Запись.АвтообновлениеДоски = АвтообновлениеДоски;
		Запись.Акцентирование = Акцентирование;
	КонецЕсли;
	Набор.Записать();
		
КонецПроцедуры
#КонецОбласти
#КонецЕсли