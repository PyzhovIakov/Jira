#Область ПрограммныйИнтерфейс
// Отправляет уведомление с указанными параметрами выбранному пользователю
// Параметры:
//		Пользователь - СправочникСсылка.Пользователи,
//		ТекстУведомления - Строка,
//		СрокНапоминания - Дата,
//		ВремяУведомления - Дата,
//		СпособУстановкиВремениНапоминания - ПеречислениеСсылка.СпособыУстановкиВремениНапоминания,
//		ИнтервалВремениНапоминания - Число,
//		ПредметУведомления - ДокументСсылка.cbr_Задача,
//		Идентификатор - Строка
//		База - Булево
//		Битрикс - Булево
//		Телеграм - Булево
//		ЭлектроннаяПочта - Булево
Процедура ОтправитьУведомлениеПользователю(Пользователь, ТекстУведомления, СрокНапоминания, ВремяУведомления,
	СпособУстановкиВремениНапоминания, ИнтервалВремениНапоминания = 600, ПредметУведомления = Неопределено,
	Идентификатор = Неопределено, База = Ложь, Битрикс = Ложь, Телеграм = Ложь, ЭлектроннаяПочта = Ложь) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	cbr_ПользовательскиеНастройки.ВидНастройки КАК ВидНастройки,
	|	cbr_ПользовательскиеНастройки.Значение КАК Значение
	|ПОМЕСТИТЬ вт_Настройки
	|ИЗ
	|	РегистрСведений.cbr_ПользовательскиеНастройки КАК cbr_ПользовательскиеНастройки
	|ГДЕ
	|	cbr_ПользовательскиеНастройки.Пользователь = &Пользователь
	|	И cbr_ПользовательскиеНастройки.ВидНастройки В
	|	(ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.База),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.ЭлектроннаяПочта),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Битрикс),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Телеграм))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(вт_Настройки.Значение, ЛОЖЬ) КАК Значение,
	|	cbr_ВидыПользовательскихНастроек.Ссылка КАК ВидНастройки
	|ИЗ
	|	ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек КАК cbr_ВидыПользовательскихНастроек
	|		ЛЕВОЕ СОЕДИНЕНИЕ вт_Настройки КАК вт_Настройки
	|		ПО cbr_ВидыПользовательскихНастроек.Ссылка = вт_Настройки.ВидНастройки
	|ГДЕ
	|	cbr_ВидыПользовательскихНастроек.Ссылка В (ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.База),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.ЭлектроннаяПочта),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Битрикс),
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Телеграм))";

	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл
		Если Выборка.ВидНастройки = ПредопределенноеЗначение(
			"ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.ЭлектроннаяПочта") И (Выборка.Значение
			Или ЭлектроннаяПочта) Тогда

		КонецЕсли;

		Если Выборка.ВидНастройки = ПредопределенноеЗначение(
			"ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Телеграм") И (Выборка.Значение Или Телеграм) Тогда
			ТекстУведомления = ДобавитьСсылкиНаПредметУведомленияКТекстуУведомления(ТекстУведомления, ПредметУведомления, Истина, Истина, Истина);	
			cbr_РаботаСTelegram.ОтправитьСообщениеПользователюПоСсылке(Пользователь,ТекстУведомления, ПредметУведомления);
		КонецЕсли;

		Если Выборка.ВидНастройки = ПредопределенноеЗначение(
			"ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.Битрикс") И (Выборка.Значение Или Битрикс) Тогда

		КонецЕсли;

		Если Выборка.ВидНастройки = ПредопределенноеЗначение(
			"ПланВидовХарактеристик.cbr_ВидыПользовательскихНастроек.База") И (Выборка.Значение Или База) Тогда
			ПараметрыНапоминания = Новый Структура;

			ПараметрыНапоминания.Вставить("Пользователь", Пользователь);
			ПараметрыНапоминания.Вставить("Описание", ТекстУведомления);
			ПараметрыНапоминания.Вставить("ВремяСобытия", ВремяУведомления);
			ПараметрыНапоминания.Вставить("СрокНапоминания", СрокНапоминания);
			ПараметрыНапоминания.Вставить("Источник", ПредметУведомления);
			ПараметрыНапоминания.Вставить("СпособУстановкиВремениНапоминания", СпособУстановкиВремениНапоминания);
			ПараметрыНапоминания.Вставить("ИнтервалВремениНапоминания", ИнтервалВремениНапоминания);
			ПараметрыНапоминания.Вставить("Идентификатор", Идентификатор);

			НапоминанияПользователяСлужебный.ПодключитьНапоминание(ПараметрыНапоминания, Ложь, Ложь);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ДобавитьСсылкиНаПредметУведомленияКТекстуУведомления(ТекстУведомления, ПредметУведомления,
	ДобавитьПредставлениеДокумента = Ложь, ДобавитьНавигационнуюСсылку = Ложь, ДобавитьВнешнююСсылку = Ложь)
	Если ТекстУведомления = "" Или ПредметУведомления = Неопределено Тогда
		Возврат ТекстУведомления;
	КонецЕсли;

	РазделительДобавлен = Ложь;
	Разделитель = Символы.ПС + "..." + Символы.ПС;
	ПредставлениеСсылки = "";
	ВнешняяНавигационаяСсылка = "";
	НавигационаяСсылка = "";

	Если ДобавитьПредставлениеДокумента Тогда
		ПредставлениеСсылки = Строка(ПредметУведомления);

		Если Не РазделительДобавлен Тогда
			ТекстУведомления = ТекстУведомления + Разделитель;
			РазделительДобавлен = Истина;
		Иначе
			ТекстУведомления = ТекстУведомления + Символы.ПС;
		КонецЕсли;

		ТекстУведомления = ТекстУведомления + ПредставлениеСсылки;
	КонецЕсли;

	Если ДобавитьВнешнююСсылку Тогда
		ВнешняяНавигационаяСсылка = ПолучитьВнешнююНавигационнуюСсылку(ПредметУведомления);
		Если Не ВнешняяНавигационаяСсылка = ПредставлениеСсылки Тогда
			ВнешняяНавигационаяСсылка = "Внешняя навигационая ссылка - "+"""["+ВнешняяНавигационаяСсылка+"]""";
			
			Если Не РазделительДобавлен Тогда
				ТекстУведомления = ТекстУведомления + Разделитель;
				РазделительДобавлен = Истина;
			Иначе
				ТекстУведомления = ТекстУведомления + Символы.ПС;
			КонецЕсли;

			ТекстУведомления = ТекстУведомления + ВнешняяНавигационаяСсылка;
		КонецЕсли;
	КонецЕсли;

	Если ДобавитьНавигационнуюСсылку Тогда
		НавигационаяСсылка = ПолучитьНавигационнуюСсылку(ПредметУведомления);
		
		НавигационаяСсылка = "Навигационная ссылка - "+"""["+НавигационаяСсылка+"]""";
		
		Если Не РазделительДобавлен Тогда
			ТекстУведомления = ТекстУведомления + Разделитель;
			РазделительДобавлен = Истина;
		Иначе
			ТекстУведомления = ТекстУведомления + Символы.ПС;
		КонецЕсли;

		ТекстУведомления = ТекстУведомления + НавигационаяСсылка;
		
	КонецЕсли;
	
	Возврат ТекстУведомления;

КонецФункции
#КонецОбласти