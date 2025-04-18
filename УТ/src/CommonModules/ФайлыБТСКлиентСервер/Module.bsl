//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Параметры: 
//  ИмяФайла - Строка
//  РазмерФайла - Число
// 
// Возвращаемое значение: 
//  Строка - представление файла.
Функция ПредставлениеФайла(ИмяФайла, РазмерФайла) Экспорт

	ОбъектФС = Новый Файл(ИмяФайла);
	Возврат СтрШаблон("%1 (%2)", ОбъектФС.Имя, ПредставлениеРазмераФайла(РазмерФайла));

КонецФункции

// Параметры: 
//  РазмерФайла - Число
// 
// Возвращаемое значение: 
//  Строка - Представление размера файла.
Функция ПредставлениеРазмераФайла(РазмерФайла) Экспорт
	
	Если РазмерФайла < 1024 Тогда
		Результат = СтрШаблон(НСтр("ru = '%1 байт'"), РазмерФайла);
	ИначеЕсли РазмерФайла < 1024 * 1024 Тогда
		Результат = СтрШаблон(НСтр("ru = '%1 Кб'"), Формат(РазмерФайла / 1024, "ЧДЦ=0"));
	ИначеЕсли РазмерФайла < 1024 * 1024 * 1024 Тогда
		Результат = СтрШаблон(НСтр("ru = '%1 Мб'"), Формат(РазмерФайла / 1024 / 1024, "ЧДЦ=0"));
	Иначе
		Результат = СтрШаблон(НСтр("ru = '%1 Гб'"), Формат(РазмерФайла / 1024 / 1024 / 1024, "ЧДЦ=0"));
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Параметры: 
//  РазмерФайла - Число 
// 
// Возвращаемое значение: 
//  Число - Размер порции обработки
Функция РазмерПорцииОбработки(РазмерФайла, ЗагрузкаВСервис = Ложь) Экспорт
	
	Если ЗагрузкаВСервис Тогда
		МинимальныйРазмер = 5 * 1024 * 1024;
	Иначе
		МинимальныйРазмер = 1;
	КонецЕсли;
	
	МаксимальныйРазмер = 10 * 1024 * 1024;
	
	Результат = Окр(РазмерФайла / 10);
	Результат = Мин(Результат, МаксимальныйРазмер);
	Результат = Макс(Результат, МинимальныйРазмер);
	
	Возврат Макс(Результат, 1);
	
КонецФункции

// Максимальный размер временного хранилища
// 
// Возвращаемое значение: 
//  Число - Максимальный размер временного хранилища.
Функция МаксимальныйРазмерВременногоХранилища() Экспорт

	Возврат 4 * 1024 * 1024 * 1024;

КонецФункции

// Приемлемый размер временного хранилища
// 
// Возвращаемое значение: 
//  Число - Приемлемый размер временного хранилища.
Функция ПриемлемыйРазмерВременногоХранилища() Экспорт

	Возврат 100 * 1024 * 1024;

КонецФункции

#КонецОбласти