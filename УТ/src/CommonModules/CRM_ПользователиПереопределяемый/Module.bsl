
////////////////////////////////////////////////////////////////////////////////
// Пользователи переопределяемый
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура заполняет настройки пользователя по умолчанию.
// 
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь.
//
Процедура CRM_ЗаполнитьНастройкиПользователяПоУмолчанию(Пользователь) Экспорт
	
	// +CRM fresh
	Если CRM_ОбщегоНазначенияСервер.РаботаВМоделиСервисаНЕРазделенныйСеанс() Тогда
		Возврат;
	КонецЕсли;
	// -CRM fresh
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(Пользователь, "ОсновнойОтветственный", Пользователь);
	Если CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
		CRM_ОбщегоНазначенияСервер.УстановитьНастройкуПользователя(CRM_ОбщегоНазначенияСервер.ПолучитьПредопределеннуюОрганизацию(),
			 "ОсновнаяОрганизация",
			 Пользователь);
	КонецЕсли;
	ПользовательИБ =
		ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь.ИдентификаторПользователяИБ);
	CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами(Пользователь);
	
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		// Настройки поля отображения содержания.
		CRM_ОбщегоНазначенияСервер.НастройкиПолейОтображенияСодержанияЗагрузитьИзМакета(, ПользовательИБ.Имя);
	КонецЕсли;
	
	// Настройки оповещений
	НаборЗаписей = РегистрыСведений.CRM_ОповещенияПользовательскиеНастройки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	// 1. Значимые события
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ЗавершениеБизнесПроцесса;
	Запись.Напоминание		= Ложь;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхВходящихПисьмах;
	Запись.Напоминание		= Ложь;
	Запись.СрокОповещения	= 10;
	Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхСообщенияхМессенджеров;
	Запись.Напоминание		= Ложь;
	Запись.СрокОповещения	= 1;
	Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ПросроченныеНеЗавершенныеСобытияЗадачи;
	Запись.Напоминание		= Ложь;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ПросроченныеКонтрольныеТочки;
	Запись.Напоминание		= Ложь;
	
	// 2. Оповещения о событиях/задачах.
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхЗадачах;
	Запись.Напоминание		= Ложь;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОНовыхВзаимодействиях;
	Запись.Напоминание		= Ложь;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещатьОПереадресованныхДокументахЗадачах;
	Запись.Напоминание		= Ложь;
	
	// 3. Запланированные события
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_1;
	Запись.Напоминание		= Истина;
	Запись.СрокОповещения	= 15;
	Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_2;
	Запись.ЭлектроннаяПочта	= Ложь;
	//Запись.СрокОповещения	= 1;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Час;
	
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.Оповещение_3;
	Запись.СМС				= Ложь;
	//Запись.СрокОповещения	= 10;
	//Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.Минута;
	
	// 4. Дни рождения
	Запись = НаборЗаписей.Добавить();
	Запись.Пользователь		= Пользователь;
	Запись.ВидОповещения	= Справочники.CRM_ВидыОповещений.ОповещенияОДняхРождения;
	Запись.Напоминание		= Истина;
	Запись.СрокОповещения	= 1;
	Запись.Периодичность	= Перечисления.CRM_ПериодичностьОповещений.День;
	
	НаборЗаписей.Записать();
	
	// 5. Заполнение пользовательских настроек динамических списков по умолчанию.
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		CRM_ОбщегоНазначенияСервер.ПользовательскиеНастройкиСпискаЗаполнитьПоУмолчанию(, ПользовательИБ.Имя);
	КонецЕсли;
	
	// 6. Заполнение пользовательских настроек работы с почтой по умолчанию.
	Если НЕ (ПользовательИБ = Неопределено) Тогда
		ЗаполнитьНастройкиРаботыСПочтойПоУмолчанию(ПользовательИБ.Имя);
	КонецЕсли;
	
КонецПроцедуры // CRM_ЗаполнитьНастройкиПользователяПоУмолчанию()

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// Большинство ролей конфигурации не требуется здесь указывать, т.к. они предназначены для любых пользователей, 
// кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнихПользователейБСП.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ДобавлениеИзменениеЛичныхВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	// ТолькоДляАдминистраторовСистемы.
	НазначениеРолей.ТолькоДляАдминистраторовСистемы.Добавить(
		Метаданные.Роли.слкУправлениеМенеджеромЛицензийСЛК.Имя);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура создает пользовательскую цветовую категорию по номеру цвета и наименованию.
//
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь
//	Наименование	- Строка			- Наименование
//	нЦвет			- Число, Цвет		- Цвет.
//
Процедура CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, Наименование, нЦвет)
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	НайденнаяЦветоваяГруппа = Справочники.CRM_КатегорииПользователей.НайтиПоНаименованию(Наименование,
		 Истина, ,
		 Пользователь);
	Если НЕ ЗначениеЗаполнено(НайденнаяЦветоваяГруппа) Тогда
		СтруктураЦвет = CRM_ОбщегоНазначенияКлиентСервер.ПолучитьЦветПоКлючу(нЦвет);
		Если НЕ (СтруктураЦвет = Неопределено) Тогда
			НоваяКатегория = Справочники.CRM_КатегорииПользователей.СоздатьЭлемент();
			НоваяКатегория.Владелец			 = Пользователь;
			НоваяКатегория.Наименование		 = Наименование;
			НоваяКатегория.ЦветПредставление = СтруктураЦвет.Представление;
			НоваяКатегория.ЦветКрасный		 = СтруктураЦвет.Цвет.Красный;
			НоваяКатегория.ЦветСиний		 = СтруктураЦвет.Цвет.Синий;
			НоваяКатегория.ЦветЗеленый		 = СтруктураЦвет.Цвет.Зеленый;
			НоваяКатегория.ЦветИндекс		 = нЦвет;
			НоваяКатегория.Записать();
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры // CRM_СоздатьЦветовуюГруппуПользователя)
	
// Процедура заполняет пользователя предопределенными цветовыми гпруппами.
//
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь.
//
Процедура CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами(Пользователь)
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='Длительные проекты';en='The durable projects'"),	7);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='Мелкие задачи';en='Small tasks'"),		4);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='Задачи в офисе';en='Tasks at office'"),		24);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='От шефа';en='From the chief'"),				15);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='Приятные задачи';en='Pleasant tasks'"),		0);
	CRM_СоздатьЦветовуюГруппуПользователя(Пользователь, НСтр("ru='Личные';en='Personal'"),				8);
КонецПроцедуры // CRM_ЗаполнитьПредопределеннымиЦветовымиГруппами()

// Процедура заполняет настройки всех пользователей по умолчанию.
// 
// Параметры:
//	Нет.
//
Процедура CRM_ЗаполнитьНастройкиВсехПользователейПоУмолчанию() Экспорт
	ПустойУникальныйИдентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойУникальныйИдентификатор
	|");
	Запрос.УстановитьПараметр("ПустойУникальныйИдентификатор", ПустойУникальныйИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		CRM_ЗаполнитьНастройкиПользователяПоУмолчанию(Выборка.Ссылка);
	КонецЦикла;
КонецПроцедуры // CRM_ЗаполнитьНастройкиВсехПользователейПоУмолчанию()

Функция СлужебныйПользовательСервисовЛогин() Экспорт
	Возврат "httpService";
КонецФункции

Функция СлужебныйПользовательСервисовПароль() Экспорт
	Возврат "Rhp5931QwL";
КонецФункции

Процедура ИзменитьРолиСлужебногоПользователя(ПользовательИзСправочника)
	
	ОбновляемыеСвойства = Новый Структура();
	ОбновляемыеСвойства.Вставить("Роли", Новый Массив());
	ОбновляемыеСвойства.Роли.Добавить(Метаданные.Роли.CRM_СлужебныеПраваДляВнешнихСервисов.Имя);
	
	ОписаниеОшибки = "";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательЗаписан = сфпОбщегоНазначения.ЗаписатьПользователяИБ(
	    сфпОбщегоНазначения.сфпЗначениеРеквизитаОбъекта(ПользовательИзСправочника, "ИдентификаторПользователяИБ"),
		ОбновляемыеСвойства,
		Ложь,
		ОписаниеОшибки,
		ПользовательИзСправочника
	);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ПользовательЗаписан Тогда
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Функция - Создать изменить служебного пользователя http-сервисов
//  Функция создает нового пользователя. Если пользователь уже создан, то изменяет настройки его аутентификации.
//
// Возвращаемое значение:
//  Булево - Результат выполнения функции. Истина, если пользователь создан или изменен.
//
Функция СоздатьИзменитьСлужебногоПользователяСервисов() Экспорт
	
	Логин = СлужебныйПользовательСервисовЛогин();
	Пароль = СлужебныйПользовательСервисовПароль();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИзСправочника = сфпОбщегоНазначения.НайтиПользователяПоИмени(Логин);
	УстановитьПривилегированныйРежим(Ложь);
	
	Попытка
		Если ПользовательИзСправочника = Неопределено Тогда
			
			ИмяСобытия = "HTTP-сервисы.СозданиеСлужебногоПользователя";
			
			ОписаниеПользователяИБ = сфпОбщегоНазначения.НовоеОписаниеПользователяИБ();
			ОписаниеПользователяИБ.Имя = Логин;
			ОписаниеПользователяИБ.ПолноеИмя = НСтр("ru='Служебный пользователь http-сервисов';en='HTTP-service user'");
			ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
			ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
			ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Истина);
			ОписаниеПользователяИБ.ЗапрещеноИзменятьПароль = Истина;
			ОписаниеПользователяИБ.Пароль = Пароль;
			ОписаниеПользователяИБ.Роли = Новый Массив;
			ОписаниеПользователяИБ.Роли.Добавить(Метаданные.Роли.CRM_СлужебныеПраваДляВнешнихСервисов.Имя);
			
			НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
			НовыйПользователь.Наименование = ОписаниеПользователяИБ.ПолноеИмя;
			НовыйПользователь.Служебный = Истина;
			НовыйПользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			НовыйПользователь.Записать();
			
		Иначе
			
			ИмяСобытия = "HTTP-сервисы.ИзменениеДоступаСлужебногоПользователя";
			ИзменитьРолиСлужебногоПользователя(ПользовательИзСправочника);
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация,
			 Метаданные.Справочники.Пользователи,
			 ПользовательИзСправочника);
		Возврат Истина;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , ,
			 ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

// Процедура заполняет настройки работы с почтой по умолчанию.
//
// Параметры: 
//	ИмяПользователя - Строка - имя пользователя информациооной базы.
//
Процедура ЗаполнитьНастройкиРаботыСПочтойПоУмолчанию(ИмяПользователя = Неопределено)
	
	НастройкиХранилище = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("РаботаСПочтой",
		 "НастройкиПользователя", , ,
		 ИмяПользователя);
	
	Если ТипЗнч(НастройкиХранилище) = Тип("Структура") Тогда
		
		НастройкиХранилище.Вставить("ОтображатьТелоИсходногоПисьма", Истина);
		НастройкиХранилище.Вставить("ВключатьТелоИсходногоПисьма",	 Истина);
		
	Иначе	
		
		НастройкиХранилище = Новый Структура;
		НастройкиХранилище.Вставить("ВключатьПодписьДляНовыхСообщений",				Истина);
		НастройкиХранилище.Вставить("ВключатьПодписьПриОтветеПересылке",			Истина);
		НастройкиХранилище.Вставить("ВсегдаЗапрашиватьУведомлениеОПрочтении",		Ложь);
		НастройкиХранилище.Вставить("ВсегдаЗапрашиватьУведомленияОДоставке",		Ложь);
		НастройкиХранилище.Вставить("НовоеСообщениеФорматированныйДокумент",		Неопределено);
		НастройкиХранилище.Вставить("ПодписьДляНовыхСообщенийПростойТекст",			Неопределено);
		НастройкиХранилище.Вставить("ПодписьПриОтветеПересылкеПростойТекст",		Неопределено);
		НастройкиХранилище.Вставить("ПорядокОтветовНаЗапросыУведомленийОПрочтении",
			 Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ЗапрашиватьПередТемКакОтправитьУведомление);
		НастройкиХранилище.Вставить("ПриОтветеПересылкеФорматированныйДокумент",	Неопределено);
		НастройкиХранилище.Вставить("ФорматПодписиДляНовыхСообщений",
							Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст);
		НастройкиХранилище.Вставить("ФорматПодписиПриОтветеПересылке",
							Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст);
		НастройкиХранилище.Вставить("ОтображатьТелоИсходногоПисьма",				Истина);
		НастройкиХранилище.Вставить("ВключатьТелоИсходногоПисьма",					Истина);
		НастройкиХранилище.Вставить("ОтправлятьСообщенияСразу",						Истина);
	
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РаботаСПочтой",
		 "НастройкиПользователя", НастройкиХранилище, ,
		 ИмяПользователя);	
	
КонецПроцедуры

#КонецОбласти
