
#Область ПрограммныйИнтерфейс

// Возвращает результат установки штампов в документ.
//
// Параметры:
//   ПараметрыУстановкиШтампов - см. Интеграция1СШтампКлиентСервер.НовыеПараметрыШтампированияФайлаДокумента.
//   ПользовательскийСценарий  - Строка (250) - Строковое описание без пробелов, информирующее о месте использования 
//     механики 1С:Штамп внутри конфигурации. Рекомендуется указывать условный путь к ключевому интерфейсу или механизму,
//     который использует механики 1С:Штамп с описанием события использования.
//     
//     Примеры:
//      - "БЭД.ИнтерфейсДокументовЭДО.ТекущиеДелаПоЭДО.ПредпросмотрПриАктивизацииСтроки"
//      - "БЭД.ДемоШтампированиеФайлов.ВизуализацияПроштампированногоЭлектронногоДокумента"
//      - "Документ.СчетНаОплату.ПечатьСчетаНаОплатуКонтрагенту"
//      - "РегламентноеЗадание.ВыгрузкаЭлектронныхДокументов"
//
//   Таймаут                   - Число, Неопределено - Максимальное время ожидания получения результата выполнения задания из сервиса
//                                    (не больше 600 сек). По умолчанию - 600 сек.
//
// Возвращаемое значение:
//   Структура: 
//    * ЕстьОшибки          - Булево - Признак наличия ошибок.
//    * ИнформацияОбОшибках - Структура - Информация об ошибках выополнения запроса:
//       ** КодСостояния - Число      - Код состояния http ответа.
//       ** Данные       - Структура  - Данные ответа сервиса.
//       ** URLРедиректа - Строка     - URL адрес для повторного обращения.
//       ** Интервал     - Число      - Интервал (в секундах) для повторного обращения к сервису.
//       ** ТекстОшибки  - Строка     - Текст ошибки на стороне сервиса.
//    * ЕстьРезультат      - Булево         - Признак успешного выполнения запроса.
//    * ДвоичныеДанные     - ДвоичныеДанные - Двоичные данные результата (PDF документа).
//
// Пример:
// 
//  МассивШтампов = Новый Массив;
//	
//	МассивШтампов.Добавить(ДвоичныеДанныеШтампа);
//	ПараметрыШтампов = ПараметрыШтампов(МассивШтампов);
//	
//	ПараметрыУстановкиШтамповВДокумент = Интеграция1СШтампКлиентСервер.НовыеПараметрыШтампированияФайлаДокумента();
//	
//	ПараметрыУстановкиШтамповВДокумент.ПараметрыДокумента.ДвоичныеДанные   = ДвоичныеДанныеДокумента;
//	ПараметрыУстановкиШтамповВДокумент.ПараметрыДокумента.Расширение       = "pdf";
//	ПараметрыУстановкиШтамповВДокумент.ПараметрыШтампов.ПоПозиционированию = ПараметрыШтампов;
//	
//	Сценарий = "БЭД.ИнтерфейсДокументовЭДО.ТекущиеДелаПоЭДО.ПредпросмотрПриАктивизацииСтроки";
//
//	Интеграция1СШтамп.РезультатУстановкиШтамповВДокумент(
//		ПараметрыУстановкиШтамповВДокумент,
//		Сценарий,
//		600);
//
Функция РезультатУстановкиШтамповВДокумент(Знач ПараметрыУстановкиШтампов, Знач ПользовательскийСценарий, Знач Таймаут = Неопределено) Экспорт
	
	Возврат Интеграция1СШтампСлужебный.РезультатУстановкиШтамповВДокумент(
		ПараметрыУстановкиШтампов,
		ПользовательскийСценарий,
		Таймаут);
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать Интеграция1СШтамп.РезультатУстановкиШтамповВДокумент.
// Возвращает результат добавления штампов в документ.
//
// Параметры:
//   ПараметрыДобавленияШтампов - см. Интеграция1СШтампКлиентСервер.НовыеПараметрыДобавленияШтамповВДокумент
//   ПользовательскийСценарий       - Строка (250) - Строковое описание без пробелов, информирующее о месте использования 
//     механики 1С:Штамп внутри конфигурации. Рекомендуется указывать условный путь к ключевому интерфейсу или механизму,
//     который использует механики 1С:Штамп с описанием события использования.
//     
//     Примеры:
//      - "БЭД.ИнтерфейсДокументовЭДО.ТекущиеДелаПоЭДО.ПредпросмотрПриАктивизацииСтроки"
//      - "БЭД.ДемоШтампированиеФайлов.ВизуализацияПроштампированногоЭлектронногоДокумента"
//      - "Документ.СчетНаОплату.ПечатьСчетаНаОплатуКонтрагенту"
//      - "РегламентноеЗадание.ВыгрузкаЭлектронныхДокументов"
//
//   Таймаут                    - Число, Неопределено - Максимальное время ожидания получения результата выполнения задания из сервиса
//                                    (не больше 600 сек). По умолчанию - 600 сек.
//
// Возвращаемое значение:
//   Структура: 
//    * ЕстьОшибки          - Булево - Признак наличия ошибок.
//    * ИнформацияОбОшибках - Структура - Информация об ошибках выополнения запроса:
//       ** КодСостояния - Число      - Код состояния http ответа.
//       ** Данные       - Структура  - Данные ответа сервиса.
//       ** URLРедиректа - Строка     - URL адрес для повторного обращения.
//       ** Интервал     - Число      - Интервал (в секундах) для повторного обращения к сервису.
//       ** ТекстОшибки  - Строка     - Текст ошибки на стороне сервиса.
//    * ЕстьРезультат      - Булево         - Признак успешного выполнения запроса.
//    * ДвоичныеДанные     - ДвоичныеДанные - Двоичные данные результата (PDF документа).
//
// Пример:
// 
//  МассивШтампов = Новый Массив;
//	
//	МассивШтампов.Добавить(ДвоичныеДанныеШтампа);
//	ПараметрыШтампов = ПараметрыШтампов(МассивШтампов);
//	
//	ПараметрыДобавленияШтамповВДокумент = Интеграция1СШтампКлиентСервер.НовыеПараметрыШтампированияФайлаДокумента();
//	
//	ПараметрыДобавленияШтамповВДокумент.ПараметрыДокумента.ДвоичныеДанные   = ДвоичныеДанныеДокумента;
//	ПараметрыДобавленияШтамповВДокумент.ПараметрыДокумента.Расширение       = "pdf";
//	ПараметрыДобавленияШтамповВДокумент.ПараметрыШтампов.ПоПозиционированию = ПараметрыШтампов;
//	
//	Сценарий = "БЭД.ИнтерфейсДокументовЭДО.ТекущиеДелаПоЭДО.ПредпросмотрПриАктивизацииСтроки";
//
//	Интеграция1СШтамп.РезультатДобавленияШтамповВДокумент(
//		ПараметрыДобавленияШтамповВДокумент,
//		Сценарий,
//		600);
//
Функция РезультатДобавленияШтамповВДокумент(Знач ПараметрыДобавленияШтампов, Знач ПользовательскийСценарий, Знач Таймаут = Неопределено) Экспорт
	
	ПараметрыУстановкиШтампов = Интеграция1СШтампКлиентСервер.НовыеПараметрыШтампированияФайлаДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыУстановкиШтампов.ПараметрыДокумента, ПараметрыДобавленияШтампов.ПараметрыДокумента);
	
	МассивШтампов = Новый Массив;
	
	Для Каждого ПараметрыШтампа Из ПараметрыДобавленияШтампов.ПараметрыШтампов Цикл
		
		НовыеПараметрыШтампа = Интеграция1СШтампКлиентСервер.НовыеПараметрыВставкиШтампаПоПозиции();
		ЗаполнитьЗначенияСвойств(НовыеПараметрыШтампа.ПараметрыШтампа    , ПараметрыШтампа.ПараметрыШтампа);
		ЗаполнитьЗначенияСвойств(НовыеПараметрыШтампа.ПараметрыРазмещения, ПараметрыШтампа.ПараметрыРазмещения);
		ЗаполнитьЗначенияСвойств(НовыеПараметрыШтампа.ПравилаРасположения, ПараметрыШтампа.ПравилаРасположения);
		ЗаполнитьЗначенияСвойств(НовыеПараметрыШтампа.Настройки          , ПараметрыШтампа.Настройки);
		
		НовыеПараметрыШтампа.ПараметрыРазмещения.ОтступОтГраниц    = ПараметрыШтампа.ОтступОтГраниц;
		НовыеПараметрыШтампа.Настройки.КоэффициентИзмененияРазмера = ПараметрыШтампа.КоэффициентИзмененияРазмера;
		
		МассивШтампов.Добавить(НовыеПараметрыШтампа);
		
	КонецЦикла;
	
	ПараметрыУстановкиШтампов.ПараметрыШтампов.ПоПозиционированию  = МассивШтампов;
	ПараметрыУстановкиШтампов.ПараметрыРезультата.ФорматРезультата = "pdf";
	
	РезультатУстановкиШтампов = РезультатУстановкиШтамповВДокумент(
		ПараметрыУстановкиШтампов,
		ПользовательскийСценарий,
		Таймаут);
		
	РезультатУстановкиШтампов.Вставить("ДвоичныеДанные", РезультатУстановкиШтампов.ДанныеФайла.ДвоичныеДанные);
	
	Возврат РезультатУстановкиШтампов;
	
КонецФункции

#КонецОбласти

#КонецОбласти