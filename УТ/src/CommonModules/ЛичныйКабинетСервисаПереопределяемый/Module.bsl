
#Область ПрограммныйИнтерфейс

// Определяет параметры работы личного кабинета сервиса.
// Требуется явное определение параметров при встраивании БТС.
//
// Параметры:
//  Параметры - Структура:
//   * Использовать - Булево - Определяет используется ли личный кабинет сервиса в прикладной конфигурации.
//   * ОтображатьВПанелиРазделов - Булево - Управляет отображением личного кабинета сервиса
//    в панели разделов прикладной конфигурации.
// @skip-check module-empty-method - переопределяемый метод.
Процедура ПриОпределенииПараметров(Параметры) Экспорт
	
	Параметры.Использовать = Истина;
	Параметры.ОтображатьВПанелиРазделов = Истина;
	
КонецПроцедуры

// Позволяет отключить использование личного кабинета сервиса для текущего приложения.
// При изменении данных влияющих на результат переопределения следует вызывать
// ЛичныйКабинетСервиса.ОбновитьИспользованиеЛичногоКабинета
//
// Параметры:
//  Используется - Булево
//
// @skip-check module-empty-method - переопределяемый метод.
Процедура ПриВключении(Используется) Экспорт
КонецПроцедуры

#КонецОбласти
