//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает настройки отправки.
// 
// Параметры:
// 	КлючНастроекОтправки - см. НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки
// Возвращаемое значение:
// 	- Неопределено - настройки не существуют
// 	- См. НастройкиЭДОКлиентСервер.НоваяНастройкаОтправки
Функция НастройкиОтправки(КлючНастроекОтправки) Экспорт
	
	Возврат НастройкиЭДО.НастройкиОтправки(КлючНастроекОтправки);
	
КонецФункции

Процедура ВключитьИспользованиеОбменаЭД(Включить = Истина) Экспорт
	
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	ИспользуетсяОбменЭД = НастройкиЭДО.ИспользуетсяОбменЭлектроннымиДокументами(КонтекстДиагностики);
	Если Не ИспользуетсяОбменЭД Тогда
		Константы.ИспользоватьОбменЭД.Установить(Включить);
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьПравоНастройкиАвтоматическогоСозданияКонтрагентов() Экспорт
	
	Возврат НастройкиЭДО.ЕстьПравоНастройкиАвтоматическогоСозданияКонтрагентов();
	
КонецФункции

#КонецОбласти
