
////////////////////////////////////////////////////////////////////////////////
// Лицензирование СофтФон экспортные методы
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруЛицензий(СкрыватьПросроченные = Истина) Экспорт
	Возврат сфпЛицензированиеСервер.ПолучитьСтруктуруЛицензий(СкрыватьПросроченные);
КонецФункции

Функция ПолучитьКоличествоЛицензий() Экспорт
	Возврат сфпЛицензированиеСервер.ПолучитьКоличествоЛицензий();
КонецФункции

Функция ПолучитьКоличествоЗанятыхЛицензий() Экспорт
	Возврат сфпЛицензированиеСервер.ПолучитьКоличествоЗанятыхЛицензий();
КонецФункции	

Функция ПроверятьЛицензииСофтФон() Экспорт
	Возврат сфпЛицензированиеСервер.ПроверятьЛицензииСофтФон();
КонецФункции

Функция ПроверитьЛицензию(Пользователь = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ПроверитьЛицензию(Пользователь);
КонецФункции

Функция ЗаписатьИнформациюОЛицензии(ДанныеАбонентов, Лицензия) Экспорт
	Возврат сфпЛицензированиеСервер.ЗаписатьИнформациюОЛицензии(ДанныеАбонентов, Лицензия);
КонецФункции

Процедура УстановитьВидимостьЭлементовЛицензирования(ЭтаФорма) Экспорт
	сфпЛицензированиеСервер.УстановитьВидимостьЭлементовЛицензирования(ЭтаФорма);
КонецПроцедуры

Функция ОбновитьИнформациюПоЛицензиям() Экспорт
	Возврат сфпЛицензированиеСервер.ОбновитьИнформациюПоЛицензиям();
КонецФункции

Процедура ЗаполнитьАбонентовОблачнойАТС(ЭтаФорма) Экспорт
	сфпЛицензированиеСервер.ЗаполнитьАбонентовОблачнойАТС(ЭтаФорма);
КонецПроцедуры	//	ЗаполнитьАбонентовОблачнойАТС()

Функция ВыполнитьЗапросОблачнойАТС(ИмяСобытия, ИдентификаторЗвонка = "", НомерТелефона = "",
	 ВнутреннийНомер = "", Hold = Неопределено, РежимПолученияЗаписи = "download",
	 ПараметрыАвтоподписки = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ВыполнитьЗапросОблачнойАТС(ИмяСобытия, ИдентификаторЗвонка,
		 НомерТелефона, ВнутреннийНомер, Hold, РежимПолученияЗаписи,
		 ПараметрыАвтоподписки);
КонецФункции

Функция ПолучитьДанныеАбонентаОблачнойАТС(ВнутреннийНомер, ПолучатьИсходящиеНомера = Ложь) Экспорт
	Возврат сфпЛицензированиеСервер.ПолучитьДанныеАбонентаОблачнойАТС(ВнутреннийНомер, ПолучатьИсходящиеНомера);
КонецФункции

Функция ПредставлениеОшибкиОблачнойАТС(Ошибка) Экспорт
	Возврат сфпЛицензированиеСервер.ПредставлениеОшибкиОблачнойАТС(Ошибка);
КонецФункции

Функция СтруктураJSON(СтрокаJSON) Экспорт
	Возврат сфпЛицензированиеСервер.СтруктураJSON(СтрокаJSON);
КонецФункции

Функция ДанныеПользователяАТС(Знач Пользователь = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ДанныеПользователяАТС(Пользователь);
КонецФункции

Функция ПредставлениеСоответствияСтрокой(Соответствие) Экспорт
	Возврат сфпЛицензированиеСервер.ПредставлениеСоответствияСтрокой(Соответствие);
КонецФункции

Функция ПозвонитьПоНомеру(НомерКому, Контакт = Неопределено, Событие = Неопределено, Ошибка,
	 СтрокаПояснения,
	 ОбъектОснование = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ПозвонитьПоНомеру(НомерКому, Контакт, Событие, Ошибка,
		 СтрокаПояснения,
		 ОбъектОснование);
КонецФункции

Процедура сфпСоздатьСообщениеВзаимодействия(ПользовательИБ, ТипЗвонка, ИдентификаторЗвонка,
	 ИдентификаторЗаписи = "", ДлительностьЗвонка = "", СостояниеЗвонка = "", Звонок = "",
	 ПредставлениеСообщения = "") Экспорт
	сфпЛицензированиеСервер.сфпСоздатьСообщениеВзаимодействия(ПользовательИБ, ТипЗвонка,
		 ИдентификаторЗвонка, ИдентификаторЗаписи, ДлительностьЗвонка, СостояниеЗвонка, Звонок,
		 ПредставлениеСообщения);
КонецПроцедуры

Функция ОбработатьВходящийЗвонок(НомерКонтакта, Пользователь, ДатаНачалаРазговора = Неопределено,
	 ИдентификаторЗвонкаВАТС = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьВходящийЗвонок(НомерКонтакта, Пользователь,
		 ДатаНачалаРазговора,
		 ИдентификаторЗвонкаВАТС);
КонецФункции

Функция ОбработатьИсходящийЗвонок(ДатаСобытия, Пользователь, Контрагент = Неопределено,
	 НомерКонтакта = Неопределено, ИдентификаторЗвонкаВАТС = Неопределено,
	 ДатаНачалаРазговора = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьИсходящийЗвонок(ДатаСобытия, Пользователь, Контрагент,
		 НомерКонтакта, ИдентификаторЗвонкаВАТС,
		 ДатаНачалаРазговора);
КонецФункции

Функция ОбработатьИзменениеЗвонка(ИдентификаторЗвонкаВАТС = Неопределено, ДатаНачалаРазговора,
	 Пользователь = Неопределено, ВходящееИсходящее = Неопределено,
	 НомерКонтакта = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьИзменениеЗвонка(ИдентификаторЗвонкаВАТС,
		 ДатаНачалаРазговора, Пользователь, ВходящееИсходящее,
		 НомерКонтакта);
КонецФункции

Функция ОбработатьУдержаниеЗвонка(ИдентификаторЗвонкаВАТС, Пользователь) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьУдержаниеЗвонка(ИдентификаторЗвонкаВАТС, Пользователь);
КонецФункции

Функция ОбработатьЗавершениеЗвонка(Входящий = Неопределено, НомерКонтакта = Неопределено,
	 ДатаНачалаВызова = Неопределено, ДатаЗавершенияВызова = Неопределено,
	 ДлительностьРазговора = Неопределено,
		Неотвеченный = Неопределено, СсылкаНаЗаписьРазговора = Неопределено, ТрубетсяЗапроситьЗаписьРазговора = Ложь, ИдентификаторЗвонкаВАТС = Неопределено, ОпределятьНеотвеченный = Истина, Пользователь = Неопределено) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьЗавершениеЗвонка(Входящий, НомерКонтакта, ДатаНачалаВызова,
		ДатаЗавершенияВызова, ДлительностьРазговора, Неотвеченный, СсылкаНаЗаписьРазговора, ТрубетсяЗапроситьЗаписьРазговора,
		ИдентификаторЗвонкаВАТС, ОпределятьНеотвеченный, Пользователь);
КонецФункции

Функция ОбработатьЗаписьЗвонка(ИдентификаторЗвонкаВАТС, СсылкаНаЗаписьРазговора) Экспорт
	Возврат сфпЛицензированиеСервер.ОбработатьЗаписьЗвонка(ИдентификаторЗвонкаВАТС, СсылкаНаЗаписьРазговора);
КонецФункции

// Переопределение параметров серий ключей защиты, определенных в конфигурации
// В зависимости от параметра Активные - возвращаются параметры или всех серий или
// доступные по установленным пользователю сеанса ролям
//
// Параметры:
//  СерииКлючейКонфигурации - Соответствие - Соответствие параметров подключения 
//											сериям ключей защиты
//
Процедура ПереопределитьСерииКлючейКонфигурации(СерииКлючейКонфигурации) Экспорт
	сфпЛицензированиеСервер.ПереопределитьСерииКлючейКонфигурации(СерииКлючейКонфигурации);
КонецПроцедуры // ПереопределитьСерииКлючейКонфигурации()

Функция ТекущийПользовательСистемыВзаимодействия() Экспорт
	Возврат сфпЛицензированиеСервер.ТекущийПользовательСистемыВзаимодействия();
КонецФункции

#КонецОбласти
