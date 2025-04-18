// @strict-types

#Область ПрограммныйИнтерфейс

// Состояние передачи между организациями. Гиперссылка если есть право на обработку.
// 
// Параметры:
//  ДокументСсылка - ОпределяемыйТип.ДокументыСПредварительнойПередачейМеждуОрганизациями - проверяемый документ
// 
// Возвращаемое значение:
//  Структура - состояние передачи:
//   * ПередачаДоступна - Булево - право доступа на обработку "ОформлениеПередачиТоваровМеждуОрганизациями"
//   * Состояние - ФорматированнаяСтрока - состояние передачи между организациями
// 
Функция СостояниеПередачиМеждуОрганизациями(ДокументСсылка) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПередачаДоступна", ПравоДоступа("Просмотр", Метаданные.Обработки.ОформлениеПередачиТоваровМеждуОрганизациями));
	УстановитьПривилегированныйРежим(Истина);
	Состояние = Обработки.ОформлениеПередачиТоваровМеждуОрганизациями.СостояниеПередачиМеждуОрганизациями(ДокументСсылка);
	Если Не Результат.ПередачаДоступна Тогда
		Состояние = Новый ФорматированнаяСтрока("" + Состояние);
	КонецЕсли;
	Результат.Вставить("Состояние", Состояние);
	Возврат Результат;
	
КонецФункции

#КонецОбласти