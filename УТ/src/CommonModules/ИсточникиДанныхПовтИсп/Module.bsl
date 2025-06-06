
#Область ПрограммныйИнтерфейс


#Область НастройкиХозяйственныхОпераций

// Для хозяйственной операции возвращает схему компоновки данных
// с помощью которой можно получить движения по текущей хозяйственной операции.
//
// Параметры:
//  ХозяйственнаяОперация - СправочникСсылка.НастройкиХозяйственныхОпераций - хозяйственная операция 
//                        для которой требуется получить схему получения данных.
//
// Возвращаемое значение:
//   СхемаКомпоновкиДанных - схема получения данных по текущей хозяйственной операции.
//
Функция СхемаПолученияДанных(ХозяйственнаяОперация) Экспорт

	СхемаПолученияДанных = Неопределено;
	ИмяИсточникаДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ХозяйственнаяОперация, "ИсточникДанных");
	МакетыИсточниковПолученияДанных = Метаданные.Справочники.НастройкиХозяйственныхОпераций.Макеты;
	МакетИсточникаПолученияДанных = МакетыИсточниковПолученияДанных.Найти(ИмяИсточникаДанных); // ОбъектМетаданныхМакет -
	Если МакетИсточникаПолученияДанных <> Неопределено Тогда
		ИмяСхемы = МакетИсточникаПолученияДанных.Имя; 
		СхемаПолученияДанных = Справочники.НастройкиХозяйственныхОпераций.ПолучитьМакет(ИмяСхемы);
	КонецЕсли;
	
	Возврат СхемаПолученияДанных;

КонецФункции

// Определяет список хозяйственных операций отражаемых в текущем регистре накопления.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра накопления.
//
// Возвращаемое значение:
//    СправочникСсылка.НастройкиХозяйственныхОпераций - массив хозяйственных операций отражаемых в переданном регистре накопления.
//
Функция ХозяйственныеОперацииАналитическихРегистров(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиХозяйственныхОпераций.Ссылка
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
	|ГДЕ
	|	НастройкиХозяйственныхОпераций.ИсточникДанных = &ИмяРегистра";
	Запрос.УстановитьПараметр("ИмяРегистра", ИмяРегистра);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает список всех регистров накопления используемых для хранения аналитической информации.
//
// Возвращаемое значение:
//    СписокЗначений - список регистров накопления.
//
Функция ДоступныеИсточникиДанных() Экспорт
	
	Список = Новый СписокЗначений;
	Список.Добавить(Метаданные.РегистрыНакопления.ВыручкаИСебестоимостьПродаж.Имя, Метаданные.РегистрыНакопления.ВыручкаИСебестоимостьПродаж.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияДенежныеСредстваДоходыРасходы.Имя, Метаданные.РегистрыНакопления.ДвиженияДенежныеСредстваДоходыРасходы.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияДенежныеСредстваКонтрагент.Имя, Метаданные.РегистрыНакопления.ДвиженияДенежныеСредстваКонтрагент.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияДенежныхСредств.Имя, Метаданные.РегистрыНакопления.ДвиженияДенежныхСредств.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы.Имя, Метаданные.РегистрыНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияКонтрагентДоходыРасходы.Имя, Метаданные.РегистрыНакопления.ДвиженияКонтрагентДоходыРасходы.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияКонтрагентКонтрагент.Имя, Метаданные.РегистрыНакопления.ДвиженияКонтрагентКонтрагент.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияНоменклатураДоходыРасходы.Имя, Метаданные.РегистрыНакопления.ДвиженияНоменклатураДоходыРасходы.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.ДвиженияНоменклатураНоменклатура.Имя, Метаданные.РегистрыНакопления.ДвиженияНоменклатураНоменклатура.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.Закупки.Имя, Метаданные.РегистрыНакопления.Закупки.Синоним);
	
	Список.Добавить(Метаданные.РегистрыНакопления.ПрочиеРасходы.Имя, Метаданные.РегистрыНакопления.ПрочиеРасходы.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоДокументам.Имя, Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоДокументам.Синоним);
	Список.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоДокументам.Имя, Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоДокументам.Синоним);
	
	РегистрыНДС = УчетНДСУП.ИсточникиДанныхХозяйственныхОпераций();
	Для каждого Регистр Из РегистрыНДС Цикл
		Список.Добавить(Регистр.Значение, Регистр.Представление);	
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

#КонецОбласти 

#КонецОбласти


