
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает прочитанный пароль администратора из безопасного хранилища по данным записи регистра
// 
// Параметры:
//  ХешСумма - Строка - хеш сумма настроек подключения, определяющие пароль
// 
// Возвращаемое значение:
//  Произвольный, Структура, Неопределено - Пароль администратора из безопасного хранилища
Функция ПарольАдминистратораИзБезопасногоХранилища(ХешСумма) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пароль = ПрочитатьПарольАдминистратораИзБезопасногоХранилища(ХешСумма);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Пароль;
	
КонецФункции

// Процедура сохраняет пароль администратора в безопасное хранилище под данными регистра
// 
// Параметры:
//  ХешСумма - Строка - хеш сумма настроек подключения, определяющие пароль
//  Пароль - Строка - установленный пароль
Процедура СохранитьПарольАдминистратораВБезопасноеХранилище(ХешСумма, Пароль) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписатьПарольАдминистратораВБезопасноеХранилище(ХешСумма, Пароль);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Конструктор записи владельца пароля и расчета хеша
// 
// Возвращаемое значение:
//  Структура - Конструктор записи владельца пароля:
// * РабочееМесто - Произвольный, Неопределено - рабочее место
// * АдресПодключенияЛМ - Строка - строка подключения
Функция КонструкторЗаписиВладельцаПароля() Экспорт
	
	СтруктураВозврата = Новый Структура();
	
	СтруктураВозврата.Вставить("РабочееМесто",       ОбщегоНазначенияИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.РабочиеМестаИС));
	СтруктураВозврата.Вставить("АдресПодключенияЛМ", "");
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НомерПриоритетаНастройкиПодключения(Организация, РабочееМесто) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиПодключенияЛокальныхМодулейИСМП.Приоритет КАК Приоритет
		|ИЗ
		|	РегистрСведений.НастройкиПодключенияЛокальныхМодулейИСМП КАК НастройкиПодключенияЛокальныхМодулейИСМП
		|ГДЕ
		|	НастройкиПодключенияЛокальныхМодулейИСМП.Организация = &Организация
		|	И НастройкиПодключенияЛокальныхМодулейИСМП.РабочееМесто = &РабочееМесто
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет УБЫВ";
	
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Приоритет + 1;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьПарольАдминистратораИзБезопасногоХранилища(ХешСумма)
	
	Возврат ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ХешСумма);
	
КонецФункции

Процедура ЗаписатьПарольАдминистратораВБезопасноеХранилище(ХешСумма, Пароль)
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ХешСумма, Пароль);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли