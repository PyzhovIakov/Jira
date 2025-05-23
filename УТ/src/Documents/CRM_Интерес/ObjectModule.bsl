#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.CRM_Интерес") Тогда
		Дата				= CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
		Автор				= ДанныеЗаполнения.Автор;
		Валюта				= ДанныеЗаполнения.Валюта;
		КонтактноеЛицо		= ДанныеЗаполнения.КонтактноеЛицо;
		Описание			= ДанныеЗаполнения.Описание;
		Партнер				= ДанныеЗаполнения.Партнер;
		ПотенциальныйКлиент	= ДанныеЗаполнения.ПотенциальныйКлиент;
		Подразделение		= ДанныеЗаполнения.Подразделение;
		Проект				= ДанныеЗаполнения.Проект;
		ТипУслуги			= ДанныеЗаполнения.ТипУслуги;
		ЦенаВключаетНДС		= ДанныеЗаполнения.ЦенаВключаетНДС;
		ТипОбращения		= ДанныеЗаполнения.ТипОбращения;
		ИсточникОбращения	= ДанныеЗаполнения.ИсточникОбращения;
		Ответственный		= ДанныеЗаполнения.Ответственный;
		ДокументОснование	= ДанныеЗаполнения.Ссылка;
		Организация			= ДанныеЗаполнения.Организация;
		КаналОбращения		= ДанныеЗаполнения.КаналОбращения;
		ИсточникОбращения	= ДанныеЗаполнения.ИсточникОбращения;
		Офис				= ДанныеЗаполнения.Офис;
		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			ВидСкидкиНаценки	= ДанныеЗаполнения.ВидСкидкиНаценки;
			ВидЦен				= ДанныеЗаполнения.ВидЦен;
			Договор				= ДанныеЗаполнения.Договор;
		Иначе
			ВидСкидкиНаценки	= ДанныеЗаполнения.СделкаСКлиентом;
			ВидЦен				= ДанныеЗаполнения.Соглашение;
			НалогообложениеНДС	= ДанныеЗаполнения.НалогообложениеНДС;
			СкидкиРассчитаны	= ДанныеЗаполнения.СкидкиРассчитаны;
			Склад				= ДанныеЗаполнения.Склад;
			Контрагент			= ДанныеЗаполнения.Контрагент;
		КонецЕсли;

		СостояниеИнтереса	= Справочники.CRM_СостоянияИнтересов.ПервичноеСостояниеСценария(
			ДокументОснование.СостояниеИнтереса.Родитель
		);
		
		Товары.Загрузить(ДанныеЗаполнения.Товары.Выгрузить());
		Контакты.Загрузить(ДанныеЗаполнения.Контакты.Выгрузить());
		ДополнительныеРеквизиты.Загрузить(ДанныеЗаполнения.ДополнительныеРеквизиты.Выгрузить());
		CRM_Теги.Загрузить(ДанныеЗаполнения.CRM_Теги.Выгрузить());
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		Если ДанныеЗаполнения.Ссылка.ЭтоГруппа Тогда
			СтандартнаяОбработка = Ложь;	
			Возврат;
		КонецЕсли;	
		Партнер				= ДанныеЗаполнения.Ссылка;		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			Автор = ДанныеЗаполнения.Автор;
		КонецЕсли;
		Дата = CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			Партнер = ДанныеЗаполнения.Партнер;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("КонтактноеЛицо") Тогда
			Если ЗначениеЗаполнено(ДанныеЗаполнения.КонтактноеЛицо) Тогда
				КонтактноеЛицо = ДанныеЗаполнения.КонтактноеЛицо;
			ИначеЕсли ЗначениеЗаполнено(Партнер) Тогда
				Если  ЗначениеЗаполнено(Партнер.CRM_ОсновноеКонтактноеЛицо) Тогда
					КонтактноеЛицо = Партнер.CRM_ОсновноеКонтактноеЛицо; 
				Иначе
					КонтактноеЛицо = CRM_МетодыМодулейМенеджеровДокументов.ВернутьКЛПартнера(Партнер);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("ПотенциальныйКлиент") Тогда
			ПотенциальныйКлиент = ДанныеЗаполнения.ПотенциальныйКлиент;
		КонецЕсли;		
		Если ДанныеЗаполнения.Свойство("Описание") Тогда
			Описание = ДанныеЗаполнения.Описание;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Ответственный") Тогда
			Ответственный = ДанныеЗаполнения.Ответственный;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Подразделение") Тогда
			Подразделение = ДанныеЗаполнения.Подразделение;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Офис") Тогда
			Офис = ДанныеЗаполнения.Офис;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СостояниеИнтереса") Тогда
			СостояниеИнтереса = ДанныеЗаполнения.СостояниеИнтереса;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("СостояниеИнтереса") Тогда
			СостояниеИнтереса = ДанныеЗаполнения.СостояниеИнтереса;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Тема") Тогда
			Тема = ДанныеЗаполнения.Тема;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("ТипУслуги") Тогда
			ТипУслуги = ДанныеЗаполнения.ТипУслуги;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Если ЗначениеЗаполнено(ДанныеЗаполнения.БизнесПроцесс) Тогда
			Партнер			= ДанныеЗаполнения.БизнесПроцесс.Партнер;
			КонтактноеЛицо	= ДанныеЗаполнения.БизнесПроцесс.КонтактноеЛицо;
			Организация		= ДанныеЗаполнения.БизнесПроцесс.Организация;
			Ответственный	= ДанныеЗаполнения.БизнесПроцесс.Ответственный;
			Подразделение	= ДанныеЗаполнения.БизнесПроцесс.Подразделение;
		КонецЕсли;
		
		Дата = CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
		Тема = ДанныеЗаполнения.Наименование;
		Описание = ДанныеЗаполнения.Описание;
	КонецЕсли;
	
	// Заполнение по статистике
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "Контрагент")
			И Не ЗначениеЗаполнено(ЭтотОбъект["Контрагент"]) Тогда
			МодульПартнерыИКонтрагенты = ОбщегоНазначения.ОбщийМодуль("ПартнерыИКонтрагенты");
			МодульПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, ЭтотОбъект["Контрагент"]);
		КонецЕсли;
		
		МодульЗаполнениеОбъектовПоСтатистике = ОбщегоНазначения.ОбщийМодуль("ЗаполнениеОбъектовПоСтатистике");
		МодульЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Если НЕ ЗначениеЗаполнено(ТипОбращения) Тогда
		ТипОбращения = Справочники.CRM_ТипыОбращений.Интерес;
	КонецЕсли;
	
	ЭтоПоддержка = ?(ТипОбращения = Справочники.CRM_ТипыОбращений.Интерес, Ложь, Истина);
	
	Если ЗначениеЗаполнено(СостояниеИнтереса) И ВероятностьСделки <> СостояниеИнтереса.ВероятностьСделки Тогда
		ВероятностьСделки = СостояниеИнтереса.ВероятностьСделки;
	КонецЕсли;
	
	Если СостояниеИнтереса.Завершено <> Завершен Тогда
		ВероятностьСделки = СостояниеИнтереса.ВероятностьСделки;
		Завершен = СостояниеИнтереса.Завершено;
	КонецЕсли;
	
	Если Завершен И Не ЗначениеЗаполнено(ДатаЗакрытия) Тогда
		ДатаЗакрытия = ТекущаяДата;
	КонецЕсли;
	
	Если Завершен И Не ЗначениеЗаполнено(ПричинаОтказа) Тогда
		ПричинаОтказа = Справочники.CRM_ПричиныОтказаПоИнтересам.Выполнено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтактноеЛицо) И Контакты.Найти(КонтактноеЛицо, "Контакт") = Неопределено Тогда
		НовСтрКонтакт = Контакты.Вставить(0);
		НовСтрКонтакт.Контакт = КонтактноеЛицо;
		НовСтрКонтакт.Роль = КонтактноеЛицо.CRM_РольКонтактногоЛица;
	КонецЕсли;
	
	Контакты.Свернуть("Контакт, Роль");
	
	Если СостояниеИнтереса.Родитель <> Ссылка.СостояниеИнтереса.Родитель Тогда
		ДополнительныеСвойства.Вставить("ОчиститьСостоянияВоронкиПродаж", ЭтоНовый());
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	ПредыдущееСостояниеИнтереса = Ссылка.СостояниеИнтереса;
	ПредыдущийПартнер = Ссылка.Партнер;
	
	ДополнительныеСвойства.Вставить("ПредыдущееСостояниеИнтереса", ПредыдущееСостояниеИнтереса);
	ДополнительныеСвойства.Вставить("ПредыдущийПартнер", ПредыдущийПартнер);
	ДополнительныеСвойства.Вставить("СостояниеИнтересаДатаНачала", ТекущаяДата);
	Если СостояниеИнтереса <> ПредыдущееСостояниеИнтереса Тогда
		
		СостояниеИнтересаДатаНачала = ТекущаяДата;
		СостояниеИнтересаДнейСНачалаГода = 0;
		СостояниеИнтересаДнейДоКонцаГода = 0;
		
		Календарь = Константы.ОсновнойКалендарьПредприятия.Получить();
		Если ЗначениеЗаполнено(Календарь) Тогда
			
			СостояниеИнтересаДнейСНачалаГода = CRM_ОбщегоНазначенияСервер.КоличествоДнейСНачалаГодаПоКалендарю(
				Календарь, ТекущаяДата);
				
			ДнейВГодуПоКалендарю = CRM_ОбщегоНазначенияСервер.КоличествоДнейСНачалаГодаПоКалендарю(
				Календарь, КонецГода(ТекущаяДата));
				
			СостояниеИнтересаДнейДоКонцаГода = ДнейВГодуПоКалендарю - СостояниеИнтересаДнейСНачалаГода;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Завершен И НЕ РучнойВводДатыПродажи И ПредыдущееСостояниеИнтереса <> СостояниеИнтереса Тогда
		ОжидаемаяДатаПродажи = CRM_ИнтересыСервер.ПлановаяДатаПродажи(ЭтотОбъект);
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Ссылка.Ответственный) И Ответственный <> Ссылка.Ответственный Тогда
		ДополнительныеСвойства.Вставить("ПредыдущийОтветственный", Ссылка.Ответственный);
	КонецЕсли;
	
	Если Не ЭтоНовый Тогда
		
		// Регистрация истории состояний.
		РегистрыСведений.CRM_ИсторияСостоянийОбращений.ЗаписатьИсториюСостояний(ЭтотОбъект);
		
		// Пересчет времени по SLA при выходе из состояния ожидания.
		Категория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущееСостояниеИнтереса, "КатегорияСостояния");
		Если Категория = Перечисления.CRM_КатегорииСостоянийПоддержки.ВОжидании Тогда
			СрокиПоОбращению = Справочники.CRM_УровниПоддержки.СрокиПоУровнюПоддержки(Дата, УровеньПоддержки, Ссылка);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СрокиПоОбращению);
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("CRM_ВестиИсториюРеквизитовКлиентов") Тогда
			СтарыеЗначенияРеквизитовОбъекта =
				РегистрыСведений.CRM_ИсторияРеквизитовОбъектов.ПолучитьСтарыеЗначенияРеквизитовОбъекта(Ссылка);
			ДополнительныеСвойства.Вставить("СтарыеЗначения", СтарыеЗначенияРеквизитовОбъекта);
		КонецЕсли;
		
		Если Ссылка.Завершен И Не Завершен Тогда
			ДатаЗакрытия =  Дата("00010101");
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		Валюта = Константы.ВалютаУправленческогоУчета.Получить();

		Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
			ВалютаРасчетовКурсКратность = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Валюта));
			ЭтотОбъект["Курс"]      = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
			ЭтотОбъект["Кратность"] = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);
		КонецЕсли;
	КонецЕсли;
	
	Если СостояниеИнтереса.ИспользоватьЧекЛист И СостояниеИнтереса.ЧекЛист.Количество() > 0
		И ЧекЛист.Найти(СостояниеИнтереса) = Неопределено Тогда
		
		Для Каждого СтрокаЧЛ Из СостояниеИнтереса.ЧекЛист Цикл
			НовСтрЧЛ = ЧекЛист.Добавить();
			НовСтрЧЛ.ОписаниеЗадачи = СтрокаЧЛ.ОписаниеЗадачи;
			НовСтрЧЛ.СостояниеИнтереса = СостояниеИнтереса;
		КонецЦикла;
		
	КонецЕсли;
	

#Область Соисполнители

	СписокИсполнителей = Новый СписокЗначений;
	СписокИсполнителей.ЗагрузитьЗначения(Соисполнители.ВыгрузитьКолонку("Соисполнитель"));
	СоисполнителиПредставление = Строка(СписокИсполнителей);
	
	НовыеСоисполнители = Новый СписокЗначений;
	УдаленныеСоисполнители = Новый СписокЗначений;
	Если Ссылка.Соисполнители.Количество() = 0 Тогда
		НовыеСоисполнители = СписокИсполнителей.Скопировать();
	Иначе
		РазницаСоисполнителей = CRM_ОбщегоНазначенияКлиентСервер.ИсключающееИЛИ(
			Ссылка.Соисполнители.ВыгрузитьКолонку("Соисполнитель"),
			Соисполнители.ВыгрузитьКолонку("Соисполнитель"));
	
		Для Каждого Отличающийся Из РазницаСоисполнителей Цикл
			Если СписокИсполнителей.НайтиПоЗначению(Отличающийся) = Неопределено Тогда
				УдаленныеСоисполнители.Добавить(Отличающийся);
			Иначе
				НовыеСоисполнители.Добавить(Отличающийся);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НовыеСоисполнители.Количество() > 0 Тогда
		Для Каждого Соисполнитель Из НовыеСоисполнители Цикл
			Документы.CRM_Интерес.ДобавитьДействие(ЭтотОбъект, Перечисления.CRM_ДействияСИнтересами.ДобавленСоисполнитель,
				ТекущаяДатаСеанса(), Пользователи.ТекущийПользователь(), Соисполнитель.Значение);
		КонецЦикла;
		ДополнительныеСвойства.Вставить("НовыеСоисполнители", НовыеСоисполнители);
	КонецЕсли;
	Если УдаленныеСоисполнители.Количество() > 0 Тогда
		Для Каждого Соисполнитель Из УдаленныеСоисполнители Цикл
			Документы.CRM_Интерес.ДобавитьДействие(ЭтотОбъект, Перечисления.CRM_ДействияСИнтересами.УдаленСоисполнитель,
				ТекущаяДатаСеанса(), Пользователи.ТекущийПользователь(), Соисполнитель.Значение);
		КонецЦикла;
		ДополнительныеСвойства.Вставить("УдаленныеСоисполнители", УдаленныеСоисполнители);
	КонецЕсли;
	
#КонецОбласти
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	Если ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый) И ЭтоНовый И Автор <> Ответственный 
		И Не ДополнительныеСвойства.Свойство("ВыполнениеТриггера") Тогда
		ПараметрыОповещения = CRM_ОповещенияСервер.ПолучитьПараметрыОповещения(Ответственный,
			Справочники.CRM_ВидыОповещений.СозданНовыйИнтерес, Ссылка);
		Если ПараметрыОповещения <> Неопределено Тогда
			CRM_ОповещенияСервер.ДобавитьОповещение(ПараметрыОповещения);
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ПометкаУдаления Тогда
		РегистрыСведений.CRM_ЗапланированныеАктивности.ОтменитьАктивности(Ссылка,
			 НСтр("ru='Интерес помечен на удаление.';
			|en='Lead is marked for deletion.'"));
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПредыдущийОтветственный") Тогда
		Если ТипЗнч(Ответственный) = Тип("СправочникСсылка.Пользователи") Тогда
			CRM_БизнесПроцессыИЗадачиВызовСервера.ПолучитьТекущиеЗадачиПеренаправитьНаОтветственного(Ссылка,
				 ДополнительныеСвойства.ПредыдущийОтветственный);
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоНовый Тогда
		// Регистрация истории состояний для нового объекта.
		РегистрыСведений.CRM_ИсторияСостоянийОбращений.ЗаписатьИсториюСостояний(ЭтотОбъект);
	КонецЕсли; 
	
	Если Не ЭтоНовый И ПолучитьФункциональнуюОпцию("CRM_ИспользоватьОбменB2BПортал") И Завершен Тогда
		// закрыть диалоги B2BПортала
		CRM_РаботаСМессенджерамиСервер.ЗавершитьДиалогиИнтереса(Ссылка, "B2BПортал");
	КонецЕсли;
	Если ДополнительныеСвойства.Свойство("ПредыдущееСостояниеИнтереса")
		И ДополнительныеСвойства.ПредыдущееСостояниеИнтереса <> СостояниеИнтереса
		И СостояниеИнтереса.Завершено
		И СостояниеИнтереса.ЗавершатьСвязанныеДиалоги Тогда
		CRM_РаботаСМессенджерамиСервер.ЗавершитьДиалогиИнтереса(Ссылка, Неопределено, Ложь);
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	Если ДополнительныеСвойства.Свойство("НовыеСоисполнители") Тогда
		Для каждого НовыйСоисполнитель Из ДополнительныеСвойства.НовыеСоисполнители Цикл
			ПараметрыОповещения = CRM_ОповещенияСервер.ПолучитьПараметрыОповещения(НовыйСоисполнитель.Значение,
				Справочники.CRM_ВидыОповещений.ОповещатьОПереадресованныхДокументахЗадачах, Ссылка);
			Если НЕ (ПараметрыОповещения = Неопределено) Тогда
				Для Каждого ПараметрОповещения Из ПараметрыОповещения Цикл
					ПараметрОповещения.Вставить("ДобавлениеСоисполнителя", Новый Структура("Дата, Автор",
						 ТекущаяДатаСеанса,
						 Пользователи.ТекущийПользователь()));
				КонецЦикла;
				CRM_ОповещенияСервер.ДобавитьОповещение(ПараметрыОповещения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("УдаленныеСоисполнители") Тогда
		Для каждого УдаленныйСоисполнитель Из ДополнительныеСвойства.УдаленныеСоисполнители Цикл
			ПараметрыОповещения = CRM_ОповещенияСервер.ПолучитьПараметрыОповещения(УдаленныйСоисполнитель.Значение,
				Справочники.CRM_ВидыОповещений.ОповещатьОПереадресованныхДокументахЗадачах, Ссылка);
			Если НЕ (ПараметрыОповещения = Неопределено) Тогда
				Для Каждого ПараметрОповещения Из ПараметрыОповещения Цикл
					ПараметрОповещения.Вставить("УдалениеСоисполнителя", Новый Структура("Дата, Автор",
						 ТекущаяДатаСеанса,
						 Пользователи.ТекущийПользователь()));
				КонецЦикла;
				CRM_ОповещенияСервер.ДобавитьОповещение(ПараметрыОповещения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ВыполнениеТриггера") Тогда
		ДополнительныеСвойства.Вставить("ИнтересИзмененТриггером", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипЗнч(Ответственный) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		ПодразделениеИндекс = ПроверяемыеРеквизиты.Найти("Подразделение");
		Если ПодразделениеИндекс <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ПодразделениеИндекс);
		КонецЕсли;
		
		ОфисИндекс = ПроверяемыеРеквизиты.Найти("Офис");
		Если ОфисИндекс <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ОфисИндекс);
		КонецЕсли;
		
	КонецЕсли;
	
	// +CRM_Модуль
	Если ТипОбращения <> Справочники.CRM_ТипыОбращений.Интерес Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "НалогообложениеНДС");
	КонецЕсли;
	// -CRM_Модуль
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик при копировании Интереса.
Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Документы.CRM_Интерес.ПустаяСсылка());
	
	Дата				= CRM_ОбщегоНазначенияСервер.ПолучитьТекущуюДатуСеанса();
	Автор				= ОбъектКопирования.Автор;
	Валюта				= ОбъектКопирования.Валюта;
	КонтактноеЛицо		= ОбъектКопирования.КонтактноеЛицо;
	Описание			= ОбъектКопирования.Описание;
	Партнер				= ОбъектКопирования.Партнер;
	ПотенциальныйКлиент	= ОбъектКопирования.ПотенциальныйКлиент;
	Подразделение		= ОбъектКопирования.Подразделение;
	Проект				= ОбъектКопирования.Проект;
	ТипУслуги			= ОбъектКопирования.ТипУслуги;
	ЦенаВключаетНДС		= ОбъектКопирования.ЦенаВключаетНДС;
	ТипОбращения		= ОбъектКопирования.ТипОбращения;
	ИсточникОбращения	= ОбъектКопирования.ИсточникОбращения;
	Ответственный		= ОбъектКопирования.Ответственный;
	ДокументОснование	= ОбъектКопирования.Ссылка;
	Организация			= ОбъектКопирования.Организация;
	КаналОбращения		= ОбъектКопирования.КаналОбращения;
	ИсточникОбращения	= ОбъектКопирования.ИсточникОбращения;
	Офис				= ОбъектКопирования.Офис;
	ЭтоПоддержка		= (ТипОбращения <> Справочники.CRM_ТипыОбращений.Интерес);
	УровеньПоддержки	= ОбъектКопирования.УровеньПоддержки;
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		ВидСкидкиНаценки	= ОбъектКопирования.ВидСкидкиНаценки;
		ВидЦен				= ОбъектКопирования.ВидЦен;
		Договор				= ОбъектКопирования.Договор;
	Иначе
		ВидСкидкиНаценки	= ОбъектКопирования.СделкаСКлиентом;
		ВидЦен				= ОбъектКопирования.Соглашение;
		НалогообложениеНДС	= ОбъектКопирования.НалогообложениеНДС;
		СкидкиРассчитаны	= ОбъектКопирования.СкидкиРассчитаны;
		Склад				= ОбъектКопирования.Склад;
		Контрагент			= ОбъектКопирования.Контрагент;
	КонецЕсли;

	СостояниеИнтереса	= Справочники.CRM_СостоянияИнтересов.ПервичноеСостояниеСценария(
		ОбъектКопирования.СостояниеИнтереса.Родитель
	);
	
	Товары.Загрузить(ОбъектКопирования.Товары.Выгрузить());
	Контакты.Загрузить(ОбъектКопирования.Контакты.Выгрузить());
	ДополнительныеРеквизиты.Загрузить(ОбъектКопирования.ДополнительныеРеквизиты.Выгрузить());
	CRM_Теги.Загрузить(ОбъектКопирования.CRM_Теги.Выгрузить());

	ЧекЛист.Очистить();
	Если СостояниеИнтереса.ИспользоватьЧекЛист И СостояниеИнтереса.ЧекЛист.Количество() > 0 Тогда
		
		Для Каждого СтрокаЧЛ Из СостояниеИнтереса.ЧекЛист Цикл
			НовСтрЧЛ = ЧекЛист.Добавить();
			НовСтрЧЛ.ОписаниеЗадачи = СтрокаЧЛ.ОписаниеЗадачи;
			НовСтрЧЛ.СостояниеИнтереса = СостояниеИнтереса;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// +CRM_Модуль
// Заполняет условия продаж в заказе клиента
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияПродаж.ВалютаВзаиморасчетов;
	ХозяйственнаяОперация = УсловияПродаж.ХозяйственнаяОперация;
	
	
	ЦенаВключаетНДС      		   = УсловияПродаж.ЦенаВключаетНДС;
	ВернутьМногооборотнуюТару 	   = УсловияПродаж.ВозвращатьМногооборотнуюТару;
	СрокВозвратаМногооборотнойТары = УсловияПродаж.СрокВозвратаМногооборотнойТары;
	ТребуетсяЗалогЗаТару 		   = УсловияПродаж.ТребуетсяЗалогЗаТару;
	НаправлениеДеятельности 	   = УсловияПродаж.НаправлениеДеятельности;
	
	ИзмененаОрганизация = ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация <> Организация;
	
	Если ИзмененаОрганизация Тогда
		Организация = УсловияПродаж.Организация;
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.КонтактноеЛицо) 
			И НЕ ЗначениеЗаполнено(КонтактноеЛицо) Тогда
			КонтактноеЛицо = УсловияПродаж.КонтактноеЛицо;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
	
		Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперация, Валюта);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) Тогда
		Склад = УсловияПродаж.Склад;
	КонецЕсли;
	
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация = Организация;
	
	CRM_Модуль_БанковскийСчет            = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	CRM_Модуль_БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(
	Контрагент, , 
	CRM_Модуль_БанковскийСчетКонтрагента);
КонецПроцедуры

// Заполняет условия продаж по умолчанию (из Заказа)
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если ЗначениеЗаполнено (Партнер) ИЛИ Не ИспользоватьСоглашенияСКлиентами Тогда
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура("УчитыватьГруппыСкладов, ВыбранноеСоглашение, ПустаяСсылкаДокумента", 
			Истина, 
			Соглашение,
			Документы.ЗаказКлиента.ПустаяСсылка()));
			
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если НЕ ИспользоватьСоглашенияСКлиентами ИЛИ 
				(Соглашение <> УсловияПродажПоУмолчанию.Соглашение И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
			
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
				ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
				
				ПараметрыЗаполнения.Организация = Организация;
				ПараметрыЗаполнения.Дата = Дата;
				ПараметрыЗаполнения.Склад = Склад;
				ПараметрыЗаполнения.ЭтоЗаказ = Истина;
				
				ПараметрыЗаполнения.РеализацияТоваров = Истина;
				ПараметрыЗаполнения.РеализацияРаботУслуг = Истина;
					
				УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
								
				Если ИспользоватьСоглашенияСКлиентами Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					ПараметрыЗаполнения = Новый Структура;
					ПараметрыЗаполнения.Вставить("Дата", Дата);
					ПараметрыЗаполнения.Вставить("Валюта", Валюта);
					ПараметрыЗаполнения.Вставить("Соглашение", Соглашение);
					ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
					ПараметрыЗаполнения.Вставить("ВозвращатьМногооборотнуюТару", Ложь);
					ПараметрыЗаполнения.Вставить("РассчитыватьНаборы", Истина);
					ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС, ВидЦены");
					
					СтруктураДействий = Новый Структура;
					СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
					СтруктураДействий.Вставить("ПересчитатьСуммуРучнойСкидки", "КоличествоУпаковок");
					СтруктураДействий.Вставить("ОчиститьАвтоматическуюСкидку", Неопределено);
					СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
					
					ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
						Товары,
						, // Массив строк или структура отбора
						ПараметрыЗаполнения,
						СтруктураДействий);
				КонецЕсли;
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
			КонецЕсли;
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	Если Контрагент.Пустая() Тогда
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	КонецЕсли;	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер,КонтактноеЛицо);
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru='Недопустимый вызов объекта на клиенте.';en='Invalid call of object on client.'");
#КонецЕсли
