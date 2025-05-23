#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СведенияОВнешнейОбработке() Экспорт

ПараметрыРегистрации = Новый Структура;
МассивНазначений = Новый Массив;
МассивНазначений.Добавить("");

ИмяОтчета = Метаданные().Представление();

ПараметрыРегистрации.Вставить("Вид", "ДополнительныйОтчет");
ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
ПараметрыРегистрации.Вставить("Наименование", ИмяОтчета);
ПараметрыРегистрации.Вставить("Версия", "1.0");
ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
ПараметрыРегистрации.Вставить("Информация", "Дополнительный отчет");

ТаблицаКоманд = ПолучитьТаблицуКоманд();

ДобавитьКоманду(ТаблицаКоманд, ИмяОтчета, Метаданные().ПолноеИмя(), "ОткрытиеФормы", Истина);

ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);

Возврат ПараметрыРегистрации;
КонецФункции

Функция ПолучитьТаблицуКоманд()
Команды = Новый ТаблицаЗначений;
Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь,Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры

#КонецОбласти

#Иначе
	ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
