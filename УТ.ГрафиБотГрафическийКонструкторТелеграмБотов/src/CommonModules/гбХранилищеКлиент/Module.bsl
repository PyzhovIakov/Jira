

Процедура ОбработкаОповещения_ФормаЭлемента(ЭтаФорма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ГрафиБот:ИзменениеСостоянияХранилищаБлокСхем" тогда
		
	КонецЕсли;

КонецПроцедуры


Процедура ОбработкаОповещения_ФормаСписка(ЭтаФорма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ГрафиБот:ИзменениеСостоянияХранилищаБлокСхем" тогда
		СписокПриАктивизацииСтроки(ЭтаФорма, ЭтаФорма.Элементы.Список);
	КонецЕсли;

КонецПроцедуры

Процедура СписокПриАктивизацииСтроки(ЭтаФорма, Элемент) Экспорт	
	
	Если Элемент.ТекущиеДанные = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Структура = Новый Структура("ИндексКартинки, ЭтоВложеннаяБлокСхема");
	ЗаполнитьЗначенияСвойств(Структура, Элемент.ТекущиеДанные);
	
	Если Структура.ИндексКартинки = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	ПодключеноКХранилищу = Структура.ИндексКартинки >= 4;
	
	Для Каждого Кнопка из ЭтаФорма.Элементы.КомандыХранилища.ПодчиненныеЭлементы цикл
		Кнопка.Видимость = ПодключеноКХранилищу;
	КонецЦикла;
	
	Кнопка = ЭтаФорма.Элементы.Найти("ФормаСправочникгбХранилищаБлокСхемПодключитьКХранилищу");
	Если Кнопка <> Неопределено тогда
		Кнопка.Видимость = не ПодключеноКХранилищу и Структура.ЭтоВложеннаяБлокСхема = Ложь;
	КонецЕсли;
	
	Кнопка = ЭтаФорма.Элементы.Найти("ФормаСправочникгбХранилищаБлокСхемОтключитьОтХранилища");
	Если Кнопка <> Неопределено тогда
		Кнопка.Видимость = ПодключеноКХранилищу и Структура.ЭтоВложеннаяБлокСхема = Ложь;
	КонецЕсли;
	
КонецПроцедуры
