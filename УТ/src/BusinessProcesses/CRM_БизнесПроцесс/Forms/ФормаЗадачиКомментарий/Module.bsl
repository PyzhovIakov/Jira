
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
// Процедура - обработчик события формы "ПередЗакрытием".
//
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если НЕ ЗавершениеРаботы Тогда	
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			 НСтр("ru='Данные были изменены. Сохранить изменения?';
			|en='Data has been changed. Save the changes?'"),
			 РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик ответа на вопрос перед закрытием формы.
//
// Параметры:
//	Результат				- КодВозвратаДиалога	- Ответ на вопрос.
//	ДополнительныеПараметры	- Структура				- Структура дополнительных параметров.
//
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		КомандаОтмена(Неопределено);
	Иначе
		КомандаОК(Неопределено);
	КонецЕсли;
	
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Модифицированность = Ложь;
	Закрыть(Новый Структура("Коментарий", Коментарий));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
