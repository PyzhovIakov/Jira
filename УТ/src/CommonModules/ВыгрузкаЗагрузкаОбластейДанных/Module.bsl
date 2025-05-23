#Область ПрограммныйИнтерфейс

// Выгружает данные приложения в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьИзАрхива().
//
// Параметры:
//	АдресДанных - Строка - адрес во временном хранилище, в который нужно поместить результат если данный параметр заполнен
//	РежимВыгрузкиДляТехническойПоддержки - Булево - признак выгрузки в режиме для технической поддержки
//	ДанныеСхемыКонфигурации - ДвоичныеДанные, Неопределено - двоичные данные схемы конфигурации сформированные методом
//	   СхемаКонфигурации.ДвоичныеДанныеСхемы(Истина, Ложь)
//	ИмяФайлаВыгрузки - Строка, Неопределено - требуемое имя файла выгрузки (zip). Если не указано, для выгрузки будет
//	  использовано имя нового временного файла
//	ВыгружатьДанныеРасширений - Булево - признак выгрузки исходных данных пользовательских расширений 
//  ПараметрыВыгрузки - Структура, Неопределено - параметры, используемые при выгрузке:
//    * ВыгружатьЗарегистрированныеИзмененияДляУзловПланаОбмена - Булево - включение в выгрузку зарегистрированных изменений для узлов плана обмена (по умолчанию: Ложь). 
//    * ИдентификаторСостояния - УникальныйИдентификатор, Неопределено - если передан, в процессе выполнения будет фиксироваться состояние выполнения и рассчитываться прогресс. Идентификатор будет использоваться как ключ записи в регистре СостоянияВыгрузкиЗагрузкиОбластейДанных.    
// 
// Возвращаемое значение:		
//  Структура - с полями:
//  * ИмяФайла - Строка - имя файла архива
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам выгрузки.
//
Функция ВыгрузитьТекущуюОбластьВАрхив(Знач АдресДанных = Неопределено,
		РежимВыгрузкиДляТехническойПоддержки = Ложь,
		ДанныеСхемыКонфигурации = Неопределено,
		ИмяФайлаВыгрузки = Неопределено,
		ВыгружатьДанныеРасширений = Ложь,
		ПараметрыВыгрузки = Неопределено) Экспорт
		
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);

	ТипыМоделиДанных = ПолучитьТипыМоделиДанныхОбласти();
	ТипыОбщихДанных = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	 
	Если Не ЗначениеЗаполнено(ПараметрыВыгрузки) Тогда
		ПараметрыВыгрузки = Новый Структура();
	КонецЕсли;	
	ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", ТипыМоделиДанных);
	ПараметрыВыгрузки.Вставить("ВыгружаемыеТипыОбщихДанных", ТипыОбщихДанных);
	ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Истина);
	ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Истина);
	ПараметрыВыгрузки.Вставить("РежимВыгрузкиДляТехническойПоддержки", РежимВыгрузкиДляТехническойПоддержки);
	
	Если ЗначениеЗаполнено(ДанныеСхемыКонфигурации) Тогда
		ПараметрыВыгрузки.Вставить("ДанныеСхемыКонфигурации", ДанныеСхемыКонфигурации);
	КонецЕсли;

	Если ЗначениеЗаполнено(ИмяФайлаВыгрузки) Тогда
		ПараметрыВыгрузки.Вставить("ИмяФайлаВыгрузки", ИмяФайлаВыгрузки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыгружатьДанныеРасширений) Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьДанныеРасширений", ВыгружатьДанныеРасширений);
	КонецЕсли;

	Результат = ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеТекущейОбластиВАрхив(ПараметрыВыгрузки);

	Если АдресДанных <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресДанных);
	КонецЕсли;

	Возврат Результат;


КонецФункции

// Выгружает данные приложения в zip-архив, который помещает во временное хранилище.
//  В дальнейшем данные из архива могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьИзАрхива().
//
// Параметры:
//	АдресХранилища - Строка - адрес во временном хранилище, в который нужно поместить
//  	zip-архив с данными.
//
Процедура ВыгрузитьТекущуюОбластьДанныхВоВременноеХранилище(АдресХранилища) Экспорт

	ИмяФайла = ВыгрузитьТекущуюОбластьВАрхив().ИмяФайла;

	Попытка

		ДанныеВыгрузки = Новый ДвоичныеДанные(ИмяФайла);
		ПоместитьВоВременноеХранилище(ДанныеВыгрузки, АдресХранилища);

		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);

	Исключение

		ТекстИсключения = ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке());

		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);

		ВызватьИсключение ТекстИсключения;

	КонецПопытки;

КонецПроцедуры

// Загружает данные приложения из zip архива с XML файлами.
//
// Параметры:
//  Архив - Строка, УникальныйИдентификатор - полное имя файла архива с данными или идентификатор файла в МС.
//  ПараметрыЗагрузки - Структура, Неопределено - см. ПараметрыЗагрузки
//
// Возвращаемое значение:
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьОбластьИзАрхива(Знач Архив, ПараметрыЗагрузки = Неопределено) Экспорт
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = ПараметрыЗагрузки();
	КонецЕсли;
	
	ИмяФайлаПолногоАрхива = ИмяФайлаПолногоАрхива();
	ПолныйАрхив = Неопределено;
	
	Если ТипЗнч(Архив) = Тип("Строка") Тогда
		
		ЧтениеZip = Новый ЧтениеZipФайла(Архив);
		ЭлементПолныйАрхив = ЧтениеZip.Элементы.Найти(ИмяФайлаПолногоАрхива);
		
		Если ЭлементПолныйАрхив <> Неопределено Тогда
			
			ВремКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
			СоздатьКаталог(ВремКаталог);
			
			ЧтениеZip.Извлечь(ЭлементПолныйАрхив, ВремКаталог);
			
			ПолныйАрхив = ВремКаталог + ИмяФайлаПолногоАрхива;
			
		КонецЕсли;
		
	Иначе
		
		АрхивКопии = ZipАрхивы.ПрочитатьАрхив(Архив);
		ЗаписьПолногоАрхива = ZipАрхивы.НайтиЗапись(АрхивКопии, ИмяФайлаПолногоАрхива);
		
		Если ЗаписьПолногоАрхива <> Неопределено Тогда
			
			ВремКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
			СоздатьКаталог(ВремКаталог);
			
			Если ЗаписьПолногоАрхива.МетодСжатия = 0 
				И ЗаписьПолногоАрхива.НесжатыйРазмер > 1024 * 1024 * 1024 Тогда
				
				// Большой файл, нужно читать из МС, чтение происходит в процессе загрузки данных
				ПолныйАрхив = Новый Структура();
				ПолныйАрхив.Вставить("ИдентификаторФайлаИсточника", Архив);
				
			Иначе
				
				// Файл небольшой, лучше скачать полностью
				ZipАрхивы.ИзвлечьФайл(АрхивКопии, ИмяФайлаПолногоАрхива, ВремКаталог);
				
				ПолныйАрхив = ВремКаталог + ИмяФайлаПолногоАрхива;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолныйАрхив = Неопределено Тогда
		
		РезультатЗагрузки = ЗагрузитьТекущуюОбласть(
			Архив,
			"Обычная",
			Неопределено,
			ПараметрыЗагрузки);
		
		РезультатЗагрузки.Удалить("СоответствиеСсылок");
		
	Иначе
		
		РезультатЗагрузки = ЗагрузитьДифференциальнуюКопиюВОбласть(
			ПолныйАрхив,
			Архив,
			ПараметрыЗагрузки);
		
		УдалитьФайлы(ВремКаталог);
		
	КонецЕсли;
	
	ПоместитьРезультатЗагрузкиВоВременноеХранилище(ПараметрыЗагрузки, РезультатЗагрузки);
	
	Возврат РезультатЗагрузки;

КонецФункции

// Загружает данные приложения из файла менеджера сервиса.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - полное имя файла архива с данными
//                     - Структура:
//                         * ИдентификаторФайлаПолнойКопии - УникальныйИдентификатор
//                         * ИдентификаторФайлаДифференциальнойКопии - УникальныйИдентификатор
//  ПараметрыЗагрузки - см. ПараметрыЗагрузки
//
// Возвращаемое значение:
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьОбластьИзТома(Знач ИдентификаторФайла, ПараметрыЗагрузки) Экспорт
	
	РазмерНебольшогоФайла = 1024 * 1024 * 1024;
	
	Если ТипЗнч(ИдентификаторФайла) = Тип("УникальныйИдентификатор") Тогда
		// Файл всего один
		РазмерФайла = РаботаВМоделиСервиса.ПолучитьРазмерФайлаИзХранилищаМенеджераСервиса(ИдентификаторФайла);
		Если РазмерФайла = Неопределено Или РазмерФайла <= РазмерНебольшогоФайла Тогда
			// Для небольших файлов, либо при отсутствии "Передача данных", загрузка выполняется непосредственно из файла
			Архив = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(ИдентификаторФайла);
		Иначе
			// Загрузка архивов  будет выполнятся частями 
			Архив = ИдентификаторФайла
		КонецЕсли;
		
		РезультатЗагрузки = ЗагрузитьОбластьИзАрхива(Архив, ПараметрыЗагрузки);
		
		Если ТипЗнч(Архив) = Тип("Строка") И Не ПустаяСтрока(Архив) Тогда
			Попытка
				УдалитьФайлы(Архив);
			Исключение
				ЗаписьЖурналаРегистрации(РаботаВМоделиСервиса.СобытиеЖурналаРегистрацииПодготовкаОбластиДанных(), 
					УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
		
		Возврат РезультатЗагрузки;
		
	КонецЕсли;
	
	// Передано 2 идентификатора
	ИдентификаторФайлаПолнойКопии = ИдентификаторФайла.ИдентификаторФайлаПолнойКопии;
	ИдентификаторФайлаДифференциальнойКопии = ИдентификаторФайла.ИдентификаторФайлаДифференциальнойКопии;
	
	РазмерФайла = РаботаВМоделиСервиса.ПолучитьРазмерФайлаИзХранилищаМенеджераСервиса(ИдентификаторФайлаПолнойКопии);
	Если РазмерФайла = Неопределено Или РазмерФайла <= РазмерНебольшогоФайла Тогда
		ПолныйАрхив = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(ИдентификаторФайлаПолнойКопии);
	Иначе
		ПолныйАрхив = ИдентификаторФайлаПолнойКопии;
	КонецЕсли;
	
	РазмерФайла = РаботаВМоделиСервиса.ПолучитьРазмерФайлаИзХранилищаМенеджераСервиса(ИдентификаторФайлаДифференциальнойКопии);
	Если РазмерФайла = Неопределено Или РазмерФайла <= РазмерНебольшогоФайла Тогда
		ДифференциальныйАрхив = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(ИдентификаторФайлаДифференциальнойКопии);
	Иначе
		ДифференциальныйАрхив = ИдентификаторФайлаДифференциальнойКопии;
	КонецЕсли;
	
	РезультатЗагрузки = ЗагрузитьДифференциальнуюКопиюВОбласть(ПолныйАрхив, ДифференциальныйАрхив, ПараметрыЗагрузки);
	
	Если ТипЗнч(ПолныйАрхив) = Тип("Строка") И Не ПустаяСтрока(ПолныйАрхив) Тогда
		Попытка
			УдалитьФайлы(ПолныйАрхив);
		Исключение
			ЗаписьЖурналаРегистрации(РаботаВМоделиСервиса.СобытиеЖурналаРегистрацииПодготовкаОбластиДанных(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Если ТипЗнч(ДифференциальныйАрхив) = Тип("Строка") И Не ПустаяСтрока(ДифференциальныйАрхив) Тогда
		Попытка
			УдалитьФайлы(ДифференциальныйАрхив);
		Исключение
			ЗаписьЖурналаРегистрации(РаботаВМоделиСервиса.СобытиеЖурналаРегистрацииПодготовкаОбластиДанных(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
	Возврат РезультатЗагрузки;
	
КонецФункции

// Загружает данные приложения из дифференциальной копии.
//
// Параметры:
//  ПолныйАрхив - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью ZipАрхивы.ПрочитатьАрхив().
//  ДифференциальныйАрхив - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью ZipАрхивы.ПрочитатьАрхив().
//  ПараметрыЗагрузки - см. ПараметрыЗагрузки
//
// Возвращаемое значение:
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьДифференциальнуюКопиюВОбласть(Знач ПолныйАрхив, Знач ДифференциальныйАрхив, ПараметрыЗагрузки) Экспорт

	ТипРезервнойКопииПолная = ВыгрузкаЗагрузкаДанныхСлужебный.ТипРезервнойКопииПолная();
	ТипРезервнойКопииДифференциальная = ВыгрузкаЗагрузкаДанныхСлужебный.ТипРезервнойКопииДифференциальная();
	
	Если ВыгрузкаЗагрузкаДанных.НеобходимоФиксироватьСостояниеВыгрузкиЗагрузкиОбластиДанных(ПараметрыЗагрузки) Тогда
		
		КоличествоЗагружаемыхОбъектовПолнойКопии = ВыгрузкаЗагрузкаДанныхСлужебный.КоличествоЗагружаемыхОбъектовРезервнойКопии(
			ПолныйАрхив,
			ТипРезервнойКопииПолная,
			Ложь);

		КоличествоЗагружаемыхОбъектовДифференциальнойКопии = ВыгрузкаЗагрузкаДанныхСлужебный.КоличествоЗагружаемыхОбъектовРезервнойКопии(
			ДифференциальныйАрхив,
			ТипРезервнойКопииДифференциальная,
			Ложь);
		
		ПараметрыЗагрузки.ВсегоОбъектов = 
			КоличествоЗагружаемыхОбъектовПолнойКопии + КоличествоЗагружаемыхОбъектовДифференциальнойКопии;
			
	КонецЕсли;
	
	РезультатЗагрузкиПолногоАрхива = ЗагрузитьТекущуюОбласть(
		ПолныйАрхив, 
		ТипРезервнойКопииПолная, 
		Неопределено, 
		ПараметрыЗагрузки);
	
	РезультатЗагрузкиДифференциальногоАрхива = ЗагрузитьТекущуюОбласть(
		ДифференциальныйАрхив, 
		ТипРезервнойКопииДифференциальная, 
		РезультатЗагрузкиПолногоАрхива.СоответствиеСсылок,
		ПараметрыЗагрузки);
		
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
		РезультатЗагрузкиДифференциальногоАрхива.Предупреждения,
		РезультатЗагрузкиПолногоАрхива.Предупреждения);
	
	РезультатЗагрузкиДифференциальногоАрхива.Удалить("СоответствиеСсылок");
	
	Возврат РезультатЗагрузкиДифференциальногоАрхива;
	
КонецФункции

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка - путь к файлу выгрузки.
//
// Возвращаемое значение: 
//	Булево - Истина если данные из архива могут быть загружены
//  	в текущую конфигурацию.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт

	Возврат ВыгрузкаЗагрузкаДанных.ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИмяАрхива);

КонецФункции

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка - путь к файлу выгрузки.
//
Процедура ПроверитьВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + ПолучитьРазделительПути();
	
	Архиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		
		ЭлементОписанияВыгрузки = Архиватор.Элементы.Найти("DumpInfo.xml");
		
		Если ЭлементОписанияВыгрузки = Неопределено Тогда
			ВызватьИсключение СтрШаблон(НСтр("ru = 'В файле выгрузки отсутствует файл %1'"), "DumpInfo.xml");
		КонецЕсли;
		
		Архиватор.Извлечь(ЭлементОписанияВыгрузки, Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		
		ФайлОписанияВыгрузки = Каталог + "DumpInfo.xml";
		
		ИнформацияОВыгрузке = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектXDTOИзФайла(
			ФайлОписанияВыгрузки, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo"));
		
		ВыгрузкаЗагрузкаДанныхСлужебный.ПроверитьВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИнформацияОВыгрузке);
		ВыгрузкаЗагрузкаДанныхСлужебный.ПроверитьВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(ИнформацияОВыгрузке);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
	Исключение
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Получает модель данных для дальнейшей загрузки/выгрузки данных
//
// Возвращаемое значение: 
//	Массив Из ОбъектМетаданных - типы.
Функция ПолучитьТипыМоделиДанныхОбласти() Экспорт

	Результат = Новый Массив();

	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодельДанных = МодульРаботаВМоделиСервиса.ПолучитьМодельДанныхОбласти();

	Для Каждого ЭлементМоделиДанных Из МодельДанных Цикл

		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементМоделиДанных.Ключ);

		Если Не ОбщегоНазначенияБТС.ЭтоРегламентноеЗадание(ОбъектМетаданных)
				И Не ОбщегоНазначенияБТС.ЭтоЖурналДокументов(ОбъектМетаданных)
				И Не ОбщегоНазначенияБТС.ЭтоВнешнийИсточникДанных(ОбъектМетаданных)
				И Не ОбщегоНазначенияБТС.ЭтоСервисИнтеграции(ОбъектМетаданных) Тогда

			Результат.Добавить(ОбъектМетаданных);

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

// Возвращает имя файла полного архива
//
// Возвращаемое значение:
//	Строка - наименование файла полного архива.
//
Функция ИмяФайлаПолногоАрхива() Экспорт 
	Возврат "full_data_dump.zip";	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьОбластьИзАрхива
// Загружает данные приложения из zip архива с XML файлами.
//
// Параметры:
//  Архив - Строка, УникальныйИдентификатор - полное имя файла архива с данными или идентификатор файла в МС.
//	ЗагружатьПользователей - Булево - флаг необходимости загрузки пользователей
//	СвернутьЭлементыСправочникаПользователи - Булево - признак необходимости сворачивания пользователей
//	СопоставлениеПользователей - ТаблицаЗначений - описание см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива()
//	ДанныеРасширений - Структура - содержит информацию о ключе области и восстанавливаемых расширениях:
//		* КлючОбластиДанных - Строка - ключ области данных
//		* РасширенияДляВосстановления - Массив - список восстанавливаемых расширений
//  ПараметрыЗагрузки - Структура, Неопределено - параметры, используемые при загрузке: 
//      * ИдентификаторСостояния - УникальныйИдентификатор, Неопределено - если передан, в процессе выполнения будет фиксироваться состояние выполнения и рассчитываться прогресс. Идентификатор будет использоваться как ключ записи в регистре СостоянияВыгрузкиЗагрузкиОбластейДанных.
//		* АдресХранилищаРезультата - Строка - если передан, результат загрузки будет помещен во временное хранилище по указанному адресу.
//    	* ПропуститьВосстановлениеРасширений - Булево - если передано значение Истина, восстановление расширений перед загрузкой выполняться не будет.
//   
// Возвращаемое значение:		
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьТекущуюОбластьИзАрхива(Знач Архив,
		Знач ЗагружатьПользователей = Ложь,
		Знач СвернутьЭлементыСправочникаПользователи = Ложь,
		СопоставлениеПользователей = Неопределено,
		ДанныеРасширений = Неопределено,
		ПараметрыЗагрузки = Неопределено) Экспорт
	
	ПараметрыЗагрузкиОбласти = ПараметрыЗагрузки();
	ПараметрыЗагрузкиОбласти.ЗагружатьПользователей = ЗагружатьПользователей;
	ПараметрыЗагрузкиОбласти.СвернутьЭлементыСправочникаПользователи = СвернутьЭлементыСправочникаПользователи;
	ПараметрыЗагрузкиОбласти.СопоставлениеПользователей = СопоставлениеПользователей;
	ПараметрыЗагрузкиОбласти.ДанныеРасширений = ДанныеРасширений;
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыЗагрузкиОбласти, ПараметрыЗагрузки);
	КонецЕсли;
	
	Возврат ЗагрузитьОбластьИзАрхива(Архив, ПараметрыЗагрузкиОбласти);
	
КонецФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьОбластьИзТома
// Загружает данные приложения из файла менеджера сервиса.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор, Структура - полное имя файла архива с данными 
//   или структура с полями ИдентификаторФайлаПолнойКопии и ИдентификаторФайлаПолнойКопии
//	ЗагружатьПользователей - Булево - флаг необходимости загрузки пользователей
//	СвернутьЭлементыСправочникаПользователи - Булево - признак необходимости сворачивания пользователей
//	СопоставлениеПользователей - ТаблицаЗначений - описание см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива()
//	ДанныеРасширений - Структура - содержит информацию о ключе области и восстанавливаемых расширениях:
//		* КлючОбластиДанных - Строка - ключ области данных
//		* РасширенияДляВосстановления - Массив - список восстанавливаемых расширений
//  ПараметрыЗагрузки - Структура, Неопределено - параметры, используемые при загрузке: 
//   	* ИдентификаторСостояния - УникальныйИдентификатор, Неопределено - если передан, в процессе выполнения будет фиксироваться состояние выполнения и рассчитываться прогресс. Идентификатор будет использоваться как ключ записи в регистре СостоянияВыгрузкиЗагрузкиОбластейДанных.
//		
// Возвращаемое значение:		
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьТекущуюОбластьИзТома(
	Знач ИдентификаторФайла,
	Знач ЗагружатьПользователей = Ложь,
	Знач СвернутьЭлементыСправочникаПользователи = Ложь,
	СопоставлениеПользователей = Неопределено,
	ДанныеРасширений = Неопределено,
	ПараметрыЗагрузки = Неопределено) Экспорт
	
	ПараметрыЗагрузкиОбласти = ПараметрыЗагрузки();
	ПараметрыЗагрузкиОбласти.ЗагружатьПользователей = ЗагружатьПользователей;
	ПараметрыЗагрузкиОбласти.СвернутьЭлементыСправочникаПользователи = СвернутьЭлементыСправочникаПользователи;
	ПараметрыЗагрузкиОбласти.СопоставлениеПользователей = СопоставлениеПользователей;
	ПараметрыЗагрузкиОбласти.ДанныеРасширений = ДанныеРасширений;
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыЗагрузкиОбласти, ПараметрыЗагрузки);
	КонецЕсли;
	
	Возврат ЗагрузитьОбластьИзТома(ИдентификаторФайла, ПараметрыЗагрузкиОбласти);
	
КонецФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьДифференциальнуюКопиюВОбласть
// Загружает данные приложения из дифференциальной копии.
//
// Параметры:
//  ПолныйАрхив - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью ZipАрхивы.ПрочитатьАрхив().
//  ДифференциальныйАрхив - Строка, УникальныйИдентификатор, Структура - имя файла, идентификатор файла или данные файла полученные с помощью ZipАрхивы.ПрочитатьАрхив().
//	ЗагружатьПользователей - Булево - флаг необходимости загрузки пользователей.
//	СвернутьЭлементыСправочникаПользователи - Булево - признак необходимости сворачивания пользователей.
//	СопоставлениеПользователей - ТаблицаЗначений - описание см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива().
//	ДанныеРасширений - Структура - содержит информацию о ключе области и восстанавливаемых расширениях:
//		* КлючОбластиДанных - Строка - ключ области данных
//		* РасширенияДляВосстановления - Массив - список восстанавливаемых расширений
//  ПараметрыЗагрузки - Структура, Неопределено - параметры, используемые при загрузке: 
//      * ИдентификаторСостояния - УникальныйИдентификатор, Неопределено - если передан, в процессе выполнения будет фиксироваться состояние выполнения и рассчитываться прогресс. Идентификатор будет использоваться как ключ записи в регистре СостоянияВыгрузкиЗагрузкиОбластейДанных.
//		
// Возвращаемое значение:		
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьДифференциальнуюКопию(
	Знач ПолныйАрхив,
	Знач ДифференциальныйАрхив,
	Знач ЗагружатьПользователей = Ложь,
	Знач СвернутьЭлементыСправочникаПользователи = Ложь,
	СопоставлениеПользователей = Неопределено,
	ДанныеРасширений = Неопределено,
	ПараметрыЗагрузки = Неопределено) Экспорт
	
	ПараметрыЗагрузкиОбласти = ПараметрыЗагрузки();
	ПараметрыЗагрузкиОбласти.ЗагружатьПользователей = ЗагружатьПользователей;
	ПараметрыЗагрузкиОбласти.СвернутьЭлементыСправочникаПользователи = СвернутьЭлементыСправочникаПользователи;
	ПараметрыЗагрузкиОбласти.СопоставлениеПользователей = СопоставлениеПользователей;
	ПараметрыЗагрузкиОбласти.ДанныеРасширений = ДанныеРасширений;
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыЗагрузкиОбласти, ПараметрыЗагрузки);
	КонецЕсли;
	
	Возврат ЗагрузитьДифференциальнуюКопиюВОбласть(ПолныйАрхив, ДифференциальныйАрхив, ПараметрыЗагрузкиОбласти);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание параметров загрузки
// 
// Возвращаемое значение:
//  Структура:
//   * ВидЗадания - ПеречислениеСсылка.ВидыЗаданийВыгрузкиЗагрузкиДанных
//   * ИдентификаторСостояния - УникальныйИдентификатор, Неопределено - идентификатор состояния
//   * ЗагружатьПользователей - Булево - флаг необходимости загрузки пользователей
//   * СвернутьЭлементыСправочникаПользователи - Булево - признак необходимости сворачивания пользователей
//   * СопоставлениеПользователей - ТаблицаЗначений, Неопределено - описание см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива()
//   * ДанныеРасширений - Структура, Неопределено - см. КаталогРасширений.ПолучитьРасширенияДляНовойОбласти
//   * ВидПриложения - Структура, Неопределено - свойства вида приложения, устанавливаемого при загрузке
//   * ВсегоОбъектов - Число
//   * ПропуститьВосстановлениеРасширений - Булево, Неопределено - 
//   * АдресХранилищаРезультата - Строка, Неопределено - 
//   * КоличествоПотоков - Число
//
Функция ПараметрыЗагрузки() Экспорт
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("ВидЗадания", Перечисления.ВидыЗаданийВыгрузкиЗагрузкиДанных.ЗагрузкаДанныхВСервис);
	ПараметрыЗагрузки.Вставить("ИдентификаторСостояния", Неопределено);
	ПараметрыЗагрузки.Вставить("ЗагружатьПользователей", Ложь);
	ПараметрыЗагрузки.Вставить("СвернутьЭлементыСправочникаПользователи", Ложь);
	ПараметрыЗагрузки.Вставить("СопоставлениеПользователей", Неопределено);
	ПараметрыЗагрузки.Вставить("ДанныеРасширений", Неопределено);
	ПараметрыЗагрузки.Вставить("ВидПриложения", Неопределено);
	ПараметрыЗагрузки.Вставить("ВсегоОбъектов", 0);
	ПараметрыЗагрузки.Вставить("ПропуститьВосстановлениеРасширений", Неопределено);
	ПараметрыЗагрузки.Вставить("АдресХранилищаРезультата", Неопределено);
	ПараметрыЗагрузки.Вставить("КоличествоПотоков", 0);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗагрузитьТекущуюОбласть(Знач Архив, ТипРезервнойКопии, СоответствиеСсылок, ПараметрыЗагрузки)
	
	ЗагружатьПользователей = ПараметрыЗагрузки.ЗагружатьПользователей;
	СопоставлениеПользователей = ПараметрыЗагрузки.СопоставлениеПользователей;
	ДанныеРасширений = ПараметрыЗагрузки.ДанныеРасширений;
	ПропуститьВосстановлениеРасширений = ПараметрыЗагрузки.ПропуститьВосстановлениеРасширений;
	АдресХранилищаРезультата = ПараметрыЗагрузки.АдресХранилищаРезультата;
	КоличествоПотоков = ПараметрыЗагрузки.КоличествоПотоков;
	ВсегоОбъектов = ПараметрыЗагрузки.ВсегоОбъектов;
	
	ПараметрыЗагрузкиВнутр = Новый Структура();
	Если ПараметрыЗагрузки.ИдентификаторСостояния <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("ВидЗадания", ПараметрыЗагрузки.ВидЗадания);
		ПараметрыЗагрузкиВнутр.Вставить("ИдентификаторСостояния", ПараметрыЗагрузки.ИдентификаторСостояния);
	КонецЕсли;
	
	Если ПропуститьВосстановлениеРасширений <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("ПропуститьВосстановлениеРасширений", ПропуститьВосстановлениеРасширений);
	КонецЕсли;
	
	Если АдресХранилищаРезультата <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("АдресХранилищаРезультата", АдресХранилищаРезультата);
	КонецЕсли;
	
	Если КоличествоПотоков > 0 Тогда
		ПараметрыЗагрузкиВнутр.Вставить("КоличествоПотоков", КоличествоПотоков);
	КонецЕсли;
	
	Если ВсегоОбъектов > 0 Тогда
		ПараметрыЗагрузкиВнутр.Вставить("ВсегоОбъектов", ВсегоОбъектов);
	КонецЕсли;
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ЗагружатьПользователей = Ложь;
		ЗагружатьНастройкиПользователей = Ложь;
	Иначе
		ЗагружатьПользователей = ЗагружатьПользователей;
		ЗагружатьНастройкиПользователей = ЗагружатьПользователей;
	КонецЕсли;
	
	ПараметрыЗагрузкиВнутр.Вставить("ВидПриложения", ПараметрыЗагрузки.ВидПриложения);
	ПараметрыЗагрузкиВнутр.Вставить("ЗагружатьПользователей", ЗагружатьПользователей);
	ПараметрыЗагрузкиВнутр.Вставить("ЗагружатьНастройкиПользователей", ЗагружатьНастройкиПользователей);
	ПараметрыЗагрузкиВнутр.Вставить("СвернутьРазделенныхПользователей", ПараметрыЗагрузки.СвернутьЭлементыСправочникаПользователи);

	Если СопоставлениеПользователей <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("СопоставлениеПользователей", СопоставлениеПользователей);
	КонецЕсли;

	Если ДанныеРасширений <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("ДанныеРасширений", ДанныеРасширений);
	КонецЕсли;
	
	ПараметрыЗагрузкиВнутр.Вставить("ТипРезервнойКопии", ТипРезервнойКопии);
	ПараметрыЗагрузкиВнутр.Вставить("ТребуетсяСопоставлениеПользователей", 
		Не ТипРезервнойКопии = ВыгрузкаЗагрузкаДанныхСлужебный.ТипРезервнойКопииПолная());
	
	Если СоответствиеСсылок <> Неопределено Тогда
		ПараметрыЗагрузкиВнутр.Вставить("СоответствиеСсылок", СоответствиеСсылок);
	КонецЕсли;
	
	ВыгрузкаЗагрузкаДанныхСлужебный.ПроверитьПараметрыПараллельнойВыгрузкиЗагрузкиДанных(ПараметрыЗагрузкиВнутр, Истина);
	
	Возврат ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива(Архив, ПараметрыЗагрузкиВнутр);
	
КонецФункции

Процедура ПоместитьРезультатЗагрузкиВоВременноеХранилище(ПараметрыЗагрузки, РезультатЗагрузки)
	АдресХранилищаРезультата = Неопределено;
	Если ПараметрыЗагрузки = Неопределено 
		Или Не ПараметрыЗагрузки.Свойство("АдресХранилищаРезультата", АдресХранилищаРезультата) Тогда
		Возврат;
	КонецЕсли;
	ПоместитьВоВременноеХранилище(РезультатЗагрузки, АдресХранилищаРезультата);
КонецПроцедуры

#КонецОбласти