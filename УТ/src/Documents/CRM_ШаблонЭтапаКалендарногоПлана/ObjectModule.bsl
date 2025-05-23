#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	CRM_ОбщегоНазначенияСервер.ЗаполнитьШапкуДокумента(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(ШаблонПроекта) И ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.CRM_ШаблоныПроектов") Тогда
		ШаблонПроекта = ДанныеЗаполнения;
	КонецЕсли;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("ТипЭтапа") И ТипЭтапа = Перечисления.CRM_ТипыЭтапов.Этап Тогда
			ПродолжительностьДней = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Описание = "";
	Автор = CRM_ОбщегоНазначенияСервер.ТекущийПользователь();
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ЗаполнитьСписокУчастников();
	
	Если ТипЭтапа = Перечисления.CRM_ТипыЭтапов.КонтрольнаяТочка Тогда	
		ПродолжительностьДней  = 0;
	ИначеЕсли ТипЭтапа = Перечисления.CRM_ТипыЭтапов.Этап И ПродолжительностьДней = 0 Тогда
		ПродолжительностьДней = 1;
	КонецЕсли;
	
	// Минимизируем процедуру обновления дат пакетов задач.
	Если Смещение <> Ссылка.Смещение Или ШаблонЭтапаПроекта <> Ссылка.ШаблонЭтапаПроекта
		 Или ПометкаУдаления <> Ссылка.ПометкаУдаления
		 Или ПродолжительностьДней <> Ссылка.ПродолжительностьДней Тогда
		
		ДополнительныеСвойства.Вставить("ОбновитьСмещенияШаблонаЭтапа", Истина);
		Если ШаблонЭтапаПроекта <> Ссылка.ШаблонЭтапаПроекта Тогда
			ДополнительныеСвойства.Вставить("ПредыдущийШаблонЭтапа", Ссылка.ШаблонЭтапаПроекта);
		КонецЕсли;
		
	КонецЕсли;
	
	// Смещение от задачи
	Если НЕ ДополнительныеСвойства.Свойство("НеПересчитыватьДеревоШаблонаПроекта")
		И (СмещениеОтЗадачи <> Ссылка.СмещениеОтЗадачи
		ИЛИ ШаблонЭтапаПроекта <> Ссылка.ШаблонЭтапаПроекта
		ИЛИ ШаблонПроекта <> Ссылка.ШаблонПроекта
		ИЛИ ПорядокВШаблоне <> Ссылка.ПорядокВШаблоне
	 	ИЛИ ПометкаУдаления <> Ссылка.ПометкаУдаления) Тогда
		
		ДополнительныеСвойства.Вставить("СмещениеОтЗадачиИзменено");
		
		Если ШаблонПроекта <> Ссылка.ШаблонПроекта Тогда
			ДополнительныеСвойства.Вставить("ПредыдущийШаблонПроекта", Ссылка.ШаблонПроекта);
		КонецЕсли;
		
		Если ШаблонЭтапаПроекта <> Ссылка.ШаблонЭтапаПроекта Тогда
			ДополнительныеСвойства.Вставить("ПредыдущийШаблонЭтапа", Ссылка.ШаблонЭтапаПроекта);
		КонецЕсли;
		
	КонецЕсли;
	
	// Следующий блок должен быть в обработчике ПередЗаписью, а не ПриЗаписи,
	// чтобы успешно обновить Смещение после пересчета дерева.
	Если ДополнительныеСвойства.Свойство("СмещениеОтЗадачиИзменено") Тогда
		
		ДанныеИсключаемогоЭтапа = Новый Структура("Этап, ШаблонЭтапаПроекта, ШаблонПроекта, СмещениеОтЗадачи, Смещение, ПометкаУдаления, ПорядокВШаблоне",
													Ссылка, ШаблонЭтапаПроекта, ШаблонПроекта, СмещениеОтЗадачи, Смещение, ПометкаУдаления, ПорядокВШаблоне);
		
		CRM_УправлениеПроектамиСервер.ПересчитатьДеревоШаблонаПроекта(ШаблонПроекта, ДанныеИсключаемогоЭтапа);
		Если ЗначениеЗаполнено(ШаблонЭтапаПроекта) И ШаблонЭтапаПроекта.ШаблонПроекта <> ШаблонПроекта Тогда
			CRM_УправлениеПроектамиСервер.ПересчитатьДеревоШаблонаПроекта(ШаблонЭтапаПроекта.ШаблонПроекта, ДанныеИсключаемогоЭтапа);
		КонецЕсли;
		
		ПредыдущийШаблонПроекта = Неопределено;
		Если ДополнительныеСвойства.Свойство("ПредыдущийШаблонПроекта") Тогда
			ПредыдущийШаблонПроекта = ДополнительныеСвойства.ПредыдущийШаблонПроекта;
			CRM_УправлениеПроектамиСервер.ПересчитатьДеревоШаблонаПроекта(ПредыдущийШаблонПроекта, ДанныеИсключаемогоЭтапа);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПредыдущийШаблонЭтапа")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПредыдущийШаблонЭтапа)
			И ДополнительныеСвойства.ПредыдущийШаблонЭтапа.ШаблонПроекта <> ПредыдущийШаблонПроекта
			И ДополнительныеСвойства.ПредыдущийШаблонЭтапа.ШаблонПроекта <> ШаблонПроекта Тогда
			CRM_УправлениеПроектамиСервер.ПересчитатьДеревоШаблонаПроекта(ДополнительныеСвойства.ПредыдущийШаблонЭтапа.ШаблонПроекта,
																			ДанныеИсключаемогоЭтапа);
		КонецЕсли;
																		
		Смещение = ДанныеИсключаемогоЭтапа.Смещение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьСмещенияШаблонаЭтапа") Тогда
		// Обновим все даты пакета задачи и всех родителей этого пакета (если даты были изменены).
		Если ЗначениеЗаполнено(ШаблонЭтапаПроекта) Тогда
			CRM_УправлениеПроектамиВызовСервера.ОбновитьСмещенияШаблонаЭтапаИВсехРодителей(ШаблонЭтапаПроекта);
		КонецЕсли;
		Если ДополнительныеСвойства.Свойство("ПредыдущийШаблонЭтапа")
			 И ЗначениеЗаполнено(ДополнительныеСвойства.ПредыдущийШаблонЭтапа) Тогда
			CRM_УправлениеПроектамиВызовСервера.ОбновитьСмещенияШаблонаЭтапаИВсехРодителей(ДополнительныеСвойства.ПредыдущийШаблонЭтапа);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьРеквизитыПоУмолчанию()
	Дата = ТекущаяДатаСеанса();
КонецПроцедуры

// Процедура заполняет список участников мероприятия
//
// Параметры: Нет
//
Процедура ЗаполнитьСписокУчастников() Экспорт
	
	СписокУчастников = "";
	Для Каждого Участник Из Участники Цикл
		СписокУчастников = СписокУчастников + ?(СписокУчастников = "", "", "; ") + Участник.Пользователь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
