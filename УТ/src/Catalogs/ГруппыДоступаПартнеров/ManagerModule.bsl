#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет, используются или нет группы доступа партнеров
//
//	Возвращаемое значение:
//		Булево - если ИСТИНА, значит группы доступа используются.
//
Функция ИспользуютсяГруппыДоступа() Экспорт
	
	Возврат
		ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей")
		И ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаПартнеров");
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли