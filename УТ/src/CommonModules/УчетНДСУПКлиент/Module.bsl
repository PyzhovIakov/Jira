#Область ПрограммныйИнтерфейс

#Область УчетВходящегоНДС

#Область РегистрацияСчетовФактурПолученных

// Выполняет обработку навигационной ссылки форматированной строки, полученной с помощью функции УчетНДСУП.СчетаФактурыПолученныеНаОсновании(). 
// Открывает форму нового или существующего счета-фактуры. Если на основании документа зарегистрировано несколько счетов-фактур, то открывает список документов.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	НавигационнаяСсылка - Строка - Навигационная ссылка форматированной строки.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
// 	ПараметрыРегистрации - См. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурПолученных
//
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыПолученные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыПолученные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации);
	//-- Локализация
	
КонецПроцедуры

// Вызывается в обработчике ОбработкаВыбора() формы документа-основания счета-фактуры полученного.
// Возвращает признак того, что закрыта форма форма счета-фактуры. 
// При этом требуется обновить представление счетов-фактур на форме документа.
//
// Параметры:
// 	РезультатВыбора - Произвольный - Результат выбора.
// 	ИсточникВыбора - Произвольный - Форма, пославшая оповещение о выборе.
//
// Возвращаемое значение:
// 	Булево - Признак того, что событие закрытия формы документа.
//
Функция ЗаконченоРедактированиеСчетаФактурыПолученного(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	//++ Локализация
	Результат = УчетНДСРФКлиент.ЗаконченоРедактированиеСчетаФактурыПолученного(РезультатВыбора, ИсточникВыбора);
	//-- Локализация
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область УчетИсходящегоНДС

#Область ФормированиеСчетовФактурВыданных

// Выполняет обработку навигационной ссылки форматированной строки, полученной с помощью функции УчетНДСУП.СчетаФактурыВыданныеНаОсновании(). 
// Открывает форму нового или существующего счета-фактуры. Если на основании документа зарегистрировано несколько счетов-фактур, то открывает список документов.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	НавигационнаяСсылка - Строка - Навигационная ссылка форматированной строки.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
// 	ПараметрыРегистрации - См. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурВыданных
//
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыВыданные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыВыданные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации);
	//-- Локализация
	
КонецПроцедуры

// Вызывается в обработчике ОбработкаВыбора() формы документа-основания счета-фактуры выданного.
// Возвращает признак того, что закрыта форма форма счета-фактуры. 
// При этом требуется обновить представление счетов-фактур на форме документа.
//
// Параметры:
// 	РезультатВыбора - Произвольный - Результат выбора.
// 	ИсточникВыбора - Произвольный - Форма, пославшая оповещение о выборе.
//
// Возвращаемое значение:
// 	Булево - Признак того, что событие закрытия формы документа.
//
Функция ЗаконченоРедактированиеСчетаФактурыВыданного(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	//++ Локализация
	Результат = УчетНДСРФКлиент.ЗаконченоРедактированиеСчетаФактурыВыданного(РезультатВыбора, ИсточникВыбора);
	//-- Локализация
	Возврат Результат;
	
КонецФункции

// Выполняет печать сформированных исправительный счетов-фактур.
//
// Параметры:
// 	ТаблицаИзмененныхДокументов - ТаблицаЗначений - Измененные документы продажи и их реквизиты:
// 	  * Документ - ОпределяемыйТип.ОснованиеСчетФактураВыданный - документ-основание
// 	  * Организация - СправочникСсылка.Организации - Организация документа-основания
// 	  * Дата - Дата - Дата документа-основания
// 	  * Ответственный - СправочникСсылка.Пользователи - Ответственный за документ-основание
// 	Форма - ФормаКлиентскогоПриложения - Форма-владелец, из которой выполняется печать счетов-фактур. 
//
Процедура ПечатьИсправительныхСчетовФактурПоИзмененнымДокументам(ТаблицаИзмененныхДокументов, Форма) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ПечатьИсправительныхСчетовФактурПоИзмененнымДокументам(ТаблицаИзмененныхДокументов, Форма);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеСчетовФактурКомиссионеру
	
// Выполняет обработку навигационной ссылки форматированной строки, полученной с помощью функции УчетНДСУП.СчетаФактурыКомиссионеруНаОсновании(). 
// Открывает форму счета-фактуры или форму рабочего места по оформлению.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	НавигационнаяСсылка - Строка - Навигационная ссылка форматированной строки.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
// 	ПараметрыРегистрации - См. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурКомиссионеру
//
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыКомиссионеру(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт

	//++ Локализация
	УчетНДСРФКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыКомиссионеру(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации);
	//-- Локализация
	
КонецПроцедуры

// Вызывается в обработчике ОбработкаВыбора() формы отчета комиссионера.
// Возвращает признак того, что закрыта форма форма счета-фактуры, списка или рабочего места по формированию. 
// При этом требуется обновить представление счетов-фактур на форме документа.
//
// Параметры:
// 	РезультатВыбора - Произвольный - Результат выбора.
// 	ИсточникВыбора - Произвольный - Форма, пославшая оповещение о выборе.
//
// Возвращаемое значение:
// 	Булево - Признак того, что событие закрытия формы редактирования счетов-фактур.
//
Функция ЗаконченоРедактированиеСчетовФактурКомиссионеру(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	//++ Локализация
	Результат = УчетНДСРФКлиент.ЗаконченоРедактированиеСчетовФактурКомиссионеру(РезультатВыбора, ИсточникВыбора);
	//-- Локализация
	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область ВыборИОформлениеСчетовФактурДляОтчетаКомитенту

// Возвращает структуру параметров для открытия формы выбора счета-фактуры для отчета комитенту.
//
// Возвращаемое значение:
// 	Структура - Параметры открытия формы выбора счета-фактуры для отчета комитенту:
// 	                  * Организация - СправочникСсылка.Организации - Организация-комиссионер
// 	                  * Покупатель - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Покупатель комиссионного товара.
// 	                  * Дата - Дата - Дата выставления счета-фактуры. В общем случае дата реализации товаров покупателю.
// 	                  * ВыбранныйСчетФактура - ДокументСсылка - Ссылка на уже выбранный счет-фактуру.
// 
Функция ПараметрыВыбораСчетаФактурыДляОтчетаКомитенту() Экспорт
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Организация");
	ПараметрыВыбора.Вставить("Покупатель");
	ПараметрыВыбора.Вставить("Дата");
	ПараметрыВыбора.Вставить("ВыбранныйСчетФактура");
	
	Возврат ПараметрыВыбора;
	
КонецФункции

// Открывает форму выбора счета-фактуры для отчета комитенту. 
// Вызывается в обработчике НачалоВыбора() поля формы счета-фактуры, выданного покупателю.
//
// Параметры:
// 	Элемент - ПолеФормы - Элемент управления.
// 	ПараметрыВыбора - Структура - Параметры выбора счета-фактуры. См. УчетНДСУПКлиент.ПараметрыВыбораСчетаФактурыДляОтчетаКомитенту.
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события.
//
Процедура НачалоВыбораСчетаФактурыДляОтчетаКомитенту(Элемент, ПараметрыВыбора, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.НачалоВыбораСчетаФактурыДляОтчетаКомитенту(Элемент, ПараметрыВыбора, СтандартнаяОбработка);
	//-- Локализация
	
КонецПроцедуры

// Возвращает структуру параметров необходимых для открытия формы ОформленияСчетовФактурДляОтчетаКомитенту
//
// Возвращаемое значение:
//	Структура - Структура параметров содержащая следующие ключи:
//              * Организация - СправочникСсылка.Организации - содержит организацию продавца комиссионного товара
//              * АдресТаблицыРеализацийКомиссионныхТоваров - Строка - содержит адрес во временном хранилище на таблицу 
//																	 документов реализации комиссионного товара
//					Таблица реализаций должна иметь колонки:
//						Ссылка - ДокументСсылка - ссылка на документ реализации
//						Дата - Дата - Дата документа реализации
//						Сумма - Число - сумма документа реализации
//						Валюта - СправочникСсылка.Валюта - валюта документа реализации
//						Партнер - СправочникСсылка.Партнеры - партнер кому был реализован комиссионный товар
//						Контрагент - СправочникСсылка.Контрагенты - контрагент кому был реализован комиссионный товар.
//  
Функция ПараметрыФормыОформленияСчетовФактурДляОтчетаКомитенту() Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация");
	ПараметрыФормы.Вставить("АдресТаблицыРеализацийКомиссионныхТоваров");
	Возврат ПараметрыФормы;
	
КонецФункции

// Открывает форму оформления счетов-фактур выданных.
// При закрытии формы будет сформировано оповещение о выборе, в результате выборка будет передано соответствие, в котором
//      Ключ - Документ реализации, для которого сформирован счет-фактура
//      Значение - Ссылка на сформированный счет-фактуру.
//
// Параметры:
//  ПараметрыФормы - Структура - Параметры открываемой формы см. УчетНДСУПКлиент.ПараметрыФормыОформленияСчетовФактурДляОтчетаКомитенту
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма открывающая оформление счетов-фактур 
//
Процедура ОткрытьФормуОформленияСчетовФактурДляОтчетаКомитенту(ПараметрыФормы, ФормаВладелец) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОткрытьФормуОформленияСчетовФактурДляОтчетаКомитенту(ПараметрыФормы, ФормаВладелец);
	//-- Локализация	
	
КонецПроцедуры

// Вызывается в обработчике ОбработкаВыбора() для проверки необходимости обновления данных о счетах-фактурах выданных.
// Возвращает признак того, что закрыта форма оформления счетов-фактур выданных.
//
// Параметры:
// 	РезультатВыбора - Произвольный - Результат выбора.
// 	ИсточникВыбора - Произвольный - Форма, пославшая оповещение о выборе.
//
// Возвращаемое значение:
// 	Булево - Признак того, что событие закрытия формы документа.
//
Функция ЗаконченоОформлениеСчетовФактурВыданных(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	//++ Локализация
	Результат = УчетНДСРФКлиент.ЗаконченоОформлениеСчетовФактурВыданных(РезультатВыбора, ИсточникВыбора);
	//-- Локализация
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПеречислениеНДСВБюджетПоОтдельнымОперациям

// Описание
// 
// Параметры:
// 	ПараметрыПодбора - см. УчетНДСУПКлиент.ПараметрыПодбораСчетовФактурТребующихОплатыНДС.
// 	ОповещениеОПодборе - ОписаниеОповещения - оповещение, которое будет вызвано после подбора документов.
//			В обработчик в параметр «Результат» будет передан адрес временного хранилища 
//			с таблицей подобранных документов. 
//			Таблица содержит колонки:
//				Контрагент - СправочникСсылка.Контрагенты - Поставщик.
//				Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор с поставщиком.
//				СчетФактура - ДокументСсылка - Документ, требующий оплаты НДС.
//				СуммаОплаты - Число - Сумма оплаты НДС по документу.
//
Процедура ОткрытьФормуПодбораСчетовФактурТребующихОплатыНДС(ПараметрыПодбора, ОповещениеОПодборе) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОткрытьФормуПодбораСчетовФактурТребующихОплатыНДС(ПараметрыПодбора, ОповещениеОПодборе);
	//-- Локализация
	
КонецПроцедуры

// Возвращает структуру параметров для открытия формы подбора документов, требующих оплаты НДС.
// 
// Возвращаемое значение:
// 	Структура - Структура параметров подбора:
//							* ТипНалога - СправочникСсылка.ВидыНалоговВзносов - Тип оплачиваемого налога: НДС_ВвозимыеТовары или НДС_НалоговыйАгент
//							* Организация - СправочникСсылка.Организации - Отбор документов по организации
//							* ДатаДокумента - Дата - Отбор документов по периоду
//							* ДокументСсылка - ДокументСсылка - Ссылка на документ оплаты
//							* АдресВременногоХранилища - Строка
//- Ссылка на временное хранилище с таблицей уже подобранных документов.
//			Таблица должна иметь следующие колонки:
//				Контрагент - Поставщик.
//				Договор - Договор с поставщиком.
//				СчетФактура - Документ, по которому оплачивается НДС.
//				СуммаОплаты - Сумма оплаты НДС по документу.
//
Функция ПараметрыПодбораСчетовФактурТребующихОплатыНДС() Экспорт
	
	ПараметрыПодбора = Новый Структура;
	
	ПараметрыПодбора.Вставить("ТипНалога", Тип("СправочникСсылка.ВидыНалоговВзносов"));
	ПараметрыПодбора.Вставить("Организация", Тип("СправочникСсылка.Организации"));
	ПараметрыПодбора.Вставить("ДатаДокумента");
	ПараметрыПодбора.Вставить("ДокументСсылка");
	ПараметрыПодбора.Вставить("АдресВременногоХранилища");
	
	Возврат ПараметрыПодбора;
	
КонецФункции

// Открывает форму просмотра и редактирования состояния оплаты НДС по счету-фактуре.
// 
// Параметры:
// 	СчетФактура - ОпределяемыйТип.СчетФактура - Документ, требующий оплаты НДС.
//	ФормаВладелец - ФормаКлиентскогоПриложения - форма, вызвавшая метод
//
Процедура ОткрытьФормуСостоянияОплатыНДСПоСчетуФактуре(СчетФактура, ФормаВладелец) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОткрытьФормуСостоянияОплатыНДСПоСчетуФактуре(СчетФактура, ФормаВладелец);
	//-- Локализация
	
КонецПроцедуры

// Обновляет заголовок команды просмотра состояния оплаты НДС по документу после ручного редактирования в форме документов оплаты.
// 
// Параметры:
//	ИсточникВыбора - Произвольный - Форма, где осуществлен выбор
// 	ТекстСостояния - Строка - новый текст состояния оплаты.
// 	КомандаСостояния - КнопкаФормы - Элемент команды просмотра состояния.
Процедура ОбработкаИзмененияСостоянияОплатыНДСПоСчетуФактуре(ИсточникВыбора, ТекстСостояния, КомандаСостояния) Экспорт
	
	//++ Локализация
	УчетНДСРФКлиент.ОбработкаИзмененияСостоянияОплатыНДСПоСчетуФактуре(ИсточникВыбора, ТекстСостояния, КомандаСостояния);
	//-- Локализация
	
КонецПроцедуры

// Обновляет команду просмотра состояния оплаты НДС по документу после изменений в форме документа учета НДС.
// 
// Параметры:
// 	КомандаСостояния - КнопкаФормы - Элемент команды просмотра состояния.
// 	ТребуетсяОплатаНДСВБюджет - Булево - определяет необходимость отображения состояния оплаты в форме документа
Процедура ОбработкаИзмененияСостоянияОплатыНДСВФормеДокумента(КомандаСостояния, ТребуетсяОплатаНДСВБюджет) Экспорт
	
	//++ Локализация
	КомандаСостояния.Видимость = ТребуетсяОплатаНДСВБюджет;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

// Обработчик команды ввода на основании
// 
// Параметры:
// 	МассивСсылок - Массив Из ДокументСсылка.СчетФактураВыданныйАванс -
//  ПараметрыВыполнения - Структура:
//                         * ОписаниеКоманды - Структура:
//                            ** Идентификатор           - Строка  - Идентификатор команды.
//                            ** Представление           - Строка  - Представление команды в форме.
//                            ** ДополнительныеПараметры - Структура - Дополнительные параметры команды.
//                            ** МножественныйВыбор      - Булево - признак множественного выбора.
//                        * Форма           - ФормаКлиентскогоПриложения - Форма, из которой вызвана команда.
//                        * ЭтоФормаОбъекта - Булево - Истина, если команда вызвана из формы объекта.
//                        * Источник        - ТаблицаФормы, ДанныеФормыСтруктура - Объект или список формы с полем "Ссылка".
//
Процедура ИсправительныйСчетФактураВыданныйАванс(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура();
	
	ПараметрыВыполненияКоманды.Вставить("Источник");
	ПараметрыВыполненияКоманды.Вставить("Уникальность");
	ПараметрыВыполненияКоманды.Вставить("Окно");
	ПараметрыВыполненияКоманды.Вставить("НавигационнаяСсылка");
	
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Исправление", Истина);
	ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураВыданныйАванс.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

// Обработчик команды ввода на основании
// 
// Параметры:
// 	МассивСсылок - Массив Из ДокументСсылка.СчетФактураПолученныйАванс -
//  ПараметрыВыполнения - Структура:
//                         * ОписаниеКоманды - Структура:
//                            ** Идентификатор           - Строка  - Идентификатор команды.
//                            ** Представление           - Строка  - Представление команды в форме.
//                            ** ДополнительныеПараметры - Структура - Дополнительные параметры команды.
//                            ** МножественныйВыбор      - Булево - признак множественного выбора.
//                        * Форма           - ФормаКлиентскогоПриложения - Форма, из которой вызвана команда.
//                        * ЭтоФормаОбъекта - Булево - Истина, если команда вызвана из формы объекта.
//                        * Источник        - ТаблицаФормы, ДанныеФормыСтруктура - Объект или список формы с полем "Ссылка".
//
Процедура ИсправительныйСчетФактураПолученныйАванс(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура();
	
	ПараметрыВыполненияКоманды.Вставить("Источник");
	ПараметрыВыполненияКоманды.Вставить("Уникальность");
	ПараметрыВыполненияКоманды.Вставить("Окно");
	ПараметрыВыполненияКоманды.Вставить("НавигационнаяСсылка");
	
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Исправление", Истина);
	ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураПолученныйАванс.ФормаОбъекта",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

