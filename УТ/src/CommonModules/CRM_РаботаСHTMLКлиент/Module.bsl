
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Процедура-обработчик события ПолеHTMLПриИзменении
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML - ПолеФормы					 - HTML-документ.
//
Процедура ПолеHTMLПриИзменении(Форма, ПолеHTML) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Процедура-обработчик события ПолеHTMLДокументСформирован
//
// Параметры:
//  Форма					 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML				 - ПолеФормы					 - HTML-документ.
//  ВключитьРедактирование	 - Булево						 - Признак включения редактирования.
//
Процедура ПолеHTMLДокументСформирован(Форма, ПолеHTML, ВключитьРедактирование = Истина) Экспорт
	
	Если CRM_ОбщегоНазначенияКлиент.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	ПолеHTML.Документ.Body.ContentEditable = ?(Форма.ТолькоПросмотр Или Не ВключитьРедактирование, "false", "true");
	
КонецПроцедуры

// Процедура-обработчик события ПолеHTMLПриНажатии
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML			 - ПолеФормы					 - HTML-документ.
//  ДанныеСобытия		 - ФиксированнаяСтруктура		 - Данные события.
//  СтандартнаяОбработка - Булево						 - Признак стандартной обработки.
//
Процедура ПолеHTMLПриНажатии(Форма, ПолеHTML, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	
	Если ДанныеСобытия.Element.nodeName = "IMG" И Не Форма.ТолькоПросмотр Тогда
		ИзменитьИзображение(Форма, ПолеHTML, ДанныеСобытия);
	Иначе
		CRM_ОбщегоНазначенияКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, , ПолеHTML.Документ);
	КонецЕсли;
	
	ПоказатьРежимыКнопок(Форма, ПолеHTML);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыРедатирования

// Процедура выполняет вставку картинки из буфера.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML - ПолеФормы					 - HTML-документ.
//
Процедура ВставитьКартинкуИзБуфера(Форма, ПолеHTML) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	
	КомпонентаУстановлена = Не(КомпонентаПолученияКартинкиИзБуфера = Неопределено);
	Если Не КомпонентаУстановлена Тогда
		
		Обработчик = Новый ОписаниеОповещения("ВставитьКартинкуИзБуфераЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		УстановитьКомпоненту(Обработчик);
		Возврат;
		
	КонецЕсли;
	
	ВставитьКартинкуИзБуфераЗавершение(Истина, ДополнительныеПараметры);
	
КонецПроцедуры

// Процедура-обработчик завершения вставки картинки из буфера.
//
// Параметры:
//  Результат				 - Булево	 - Результат.
//  ДополнительныеПараметры	 - Структура	 - Дополнительные параметры.
//
Процедура ВставитьКартинкуИзБуфераЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		ПолеHTML = ДополнительныеПараметры.ПолеHTML;
		
		ПутьФайла = КомпонентаПолученияКартинкиИзБуфера.ПолучитьКартинкуИзБуфера();
		Если Не ПустаяСтрока(ПутьФайла) Тогда
			ВыполнитьHTMLКоманду(Форма, ПолеHTML, "insertImage", "file://" + ПутьФайла);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Буфер обмена не содержит картинки'"));
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет вставку изображения.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML	 - ПолеФормы					 - HTML-документ.
//  Кодировать	 - Булево						 - Признак кодирвоания.
//
Процедура ВставитьИзображение(Форма, ПолеHTML, Кодировать = Ложь) Экспорт
	
	Форма.ТекущийЭлемент = ПолеHTML;
	
	Фильтр = НСтр("ru = 'Все картинки (*.bmp;
		|*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;
		|*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf'")
		+ НСтр("ru = '|Все файлы(*.*)|*.*'")
		+ НСтр("ru = '|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle'")
		+ НСтр("ru = '|Формат GIF(*.gif*)|*.gif'")
		+ НСтр("ru = '|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg'")
		+ НСтр("ru = '|Формат PNG(*.png*)|*.png'")
		+ НСтр("ru = '|Формат TIFF(*.tif)|*.tif'")
		+ НСтр("ru = '|Формат icon(*.ico)|*.ico'")
		+ НСтр("ru = '|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = Форма.УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = Фильтр;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	
	Если ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда
		Кодировать = Истина;
	Иначе
		#Если ВебКлиент Тогда
			Кодировать = Истина;
		#Иначе
			// используется значение аргумента процедуры Кодировать
		#КонецЕсли
	КонецЕсли;
	
	Если Кодировать Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьИзображениеПослеПомещенияФайла",
			 CRM_РаботаСHTMLКлиент,
			 ДополнительныеПараметры);
		ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения, ПараметрыЗагрузки);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьИзображениеПослеВыбораФайла",
			 CRM_РаботаСHTMLКлиент,
			 ДополнительныеПараметры);
		ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ПараметрыЗагрузки.Диалог);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет вставку изображения после помещения файла.
//
// Параметры:
//  ПомещенныйФайл			 - Файл, Неопределено	 - Помещаемый файл.
//  ДополнительныеПараметры	 - Структура	 - Дополнительные параметры.
//
Процедура ВставитьИзображениеПослеПомещенияФайла(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
	Файл = Новый Файл(ПомещенныйФайл.Имя);
	
	ВыбранноеЗначение = "data:image/" + СтрЗаменить(Файл.Расширение, ".", "") + ";base64," + Base64Строка(ДвоичныеДанные);
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "insertImage", ВыбранноеЗначение);
	
КонецПроцедуры 

// Процедура выполняет вставку изображения после выбора файла.
//
// Параметры:
//  ВыбранныеФайлы			 - Массиа, Неопределено	 - Выбранные файлы.
//  ДополнительныеПараметры	 - Структура	 - Дополнительные параметры.
//
Процедура ВставитьИзображениеПослеВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	
	ПутьФайла = ВыбранныеФайлы[0];
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "insertImage", "file://" + ПутьФайла);
	
КонецПроцедуры

// Процедура выполняет изменение изображения.
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML		 - ПолеФормы					 - HTML-документ.
//  ДанныеСобытия	 - Структура					 - Данные события.
//
Процедура ИзменитьИзображение(Форма, ПолеHTML, ДанныеСобытия) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	
	Если ПустаяСтрока(ДанныеСобытия.Element.id) Тогда
		УИД_Элемента = Строка(Новый УникальныйИдентификатор());
		ДанныеСобытия.Element.id = УИД_Элемента;
	Иначе
		УИД_Элемента = ДанныеСобытия.Element.id;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("УИД_Элемента", УИД_Элемента);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИзменитьИзображениеЗавершение", CRM_РаботаСHTMLКлиент, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ширина", ДанныеСобытия.Element.width);
	ПараметрыФормы.Вставить("Высота", ДанныеСобытия.Element.height);
	
	ОткрытьФорму("Обработка.CRM_РаботаСHTML.Форма.ИзменениеКартинки", ПараметрыФормы, Форма, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик завершения изменения изображения.
//
// Параметры:
//  СтруктураВозврата		 - Структура	 - Структура возврата.
//  ДополнительныеПараметры	 - Структура	 - Дополнительные параметры.
//
Процедура ИзменитьИзображениеЗавершение(СтруктураВозврата, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(СтруктураВозврата) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма		= ДополнительныеПараметры.Форма;
	ПолеHTML	= ДополнительныеПараметры.ПолеHTML;
	
	Элемент = ПолеHTML.Документ.getElementById(ДополнительныеПараметры.УИД_Элемента);
	Элемент.width	= СтруктураВозврата.Ширина;
	Элемент.height	= СтруктураВозврата.Высота;
	
	ПоказатьРежимыКнопок(Форма, ПолеHTML);
	
КонецПроцедуры

// Процедура выполняет вставку гиперссылки.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML - ПолеФормы					 - HTML-документ.
//
Процедура ВставитьГиперссылку(Форма, ПолеHTML) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьГиперссылкуЗавершение",
		 CRM_РаботаСHTMLКлиент,
		 ДополнительныеПараметры);
	
	ОткрытьФорму("Обработка.CRM_РаботаСHTML.Форма.ВыборГиперссылки", , Форма, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик завершения вставки гиперссылки.
//
// Параметры:
//  Гиперссылка				 - Строка	 - Гиперссылка.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ВставитьГиперссылкуЗавершение(Гиперссылка, ДополнительныеПараметры) Экспорт
	
	Если Гиперссылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "CreateLink", Гиперссылка);
	
КонецПроцедуры

// Процедура выполняет вставку таблицы.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML			 - ПолеФормы					 - HTML-документ.
//  РазрешитьВставкуТЧ	 - Булево						 - Признак, разрешающий вставку таблицы.
//
Процедура ВставитьТаблицу(Форма, ПолеHTML, РазрешитьВставкуТЧ = Ложь) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьТаблицуЗавершение", CRM_РаботаСHTMLКлиент,
		 ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РазрешитьВставкуТЧ", РазрешитьВставкуТЧ);
	
	ОткрытьФорму("Обработка.CRM_РаботаСHTML.Форма.СозданиеТаблицы", ПараметрыФормы, Форма, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик завершения вставки таблицы.
//
// Параметры:
//  ПараметрыТаблицы		 - Структура - Параметры таблицы.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ВставитьТаблицуЗавершение(ПараметрыТаблицы, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ПараметрыТаблицы) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	
	ЭтоТЧ = ПараметрыТаблицы.ЭтоТЧ;
	Колонки = ПараметрыТаблицы.Колонок;
	Строк = ПараметрыТаблицы.Строк;
	ШиринаКолонкиПикс = ПараметрыТаблицы.Ширина;
	ШиринаТаблицыПикс = ШиринаКолонкиПикс * Колонки;
	ШиринаВПикселях = ШиринаКолонкиПикс > 0;
	БезРамки = ПараметрыТаблицы.БезРамки;
	
	Если Не ТипЗнч(Колонки) = Тип("Число") Тогда
		Возврат;
	КонецЕсли;
	
	ШиринаКолонки = Цел(100 / Колонки);
	ДопШиринаПоследней = 100 - ШиринаКолонки * Колонки;
	
	Если ЭтоТЧ Тогда
		ТекстВставкиТаблицы = "<!--НачалоТаблицы-->
		|";
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<div><table border cellspacing=0 width=""" 
			+ ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
		|<tbody><tr width=""" + ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
		|";
		Для а = 1 По Колонки Цикл
			Если ШиринаВПикселях Тогда
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td style=""text-align: center;"" width=""" 
					+ Формат(ШиринаКолонкиПикс, "ЧГ=0") + "px""><b>" + НСтр("ru='Заголовок колонки '") + а + "</b></td>
				|";
			Иначе
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td style=""text-align: center;"" width=""" 
					+ ?(а = Колонки, ШиринаКолонки + ДопШиринаПоследней, ШиринаКолонки) + "%""><b>" + НСтр("ru='Заголовок колонки '") 
						+ а 
					+ "</b></td>
				|";
			КонецЕсли;
		КонецЦикла;
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + "</tr>
		|<!--НачалоСтроки-->
		|<tr width=""" + ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
		|";
		Для а = 1 По Колонки Цикл
			Если ШиринаВПикселях Тогда
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + Формат(ШиринаКолонкиПикс, "ЧГ=0") 
					+ "px""><" + НСтр("ru='автотекст колонки '") + а 
					+ "></td>
				|";
			Иначе
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + ?(а = Колонки, ШиринаКолонки 
					+ ДопШиринаПоследней, ШиринаКолонки) + "%""><" + НСтр("ru='автотекст колонки '") + а + "></td>
				|";
			КонецЕсли;
		КонецЦикла;
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + "</tr>
		|<!--ОкончаниеСтроки-->
		|</tbody></table></div>
		|<!--ОкончаниеТаблицы-->
		|<br>
		|<br>
		|";
	Иначе	
		ТекстВставкиТаблицы = "";
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<div><table border cellspacing=0 width=""" 
			+ ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
		|<tbody><tr width=""" + ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
		|";
		Для а = 1 По Колонки Цикл
			Если ШиринаВПикселях Тогда
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + Формат(ШиринаКолонкиПикс, "ЧГ=0") + "px"">&nbsp;</td>
				|";
			Иначе	
				ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + ?(а = Колонки, ШиринаКолонки 
					+ ДопШиринаПоследней, ШиринаКолонки) + "%"">&nbsp;</td>
				|";
			КонецЕсли;
		КонецЦикла;
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + "</tr>";
		// BSLLS:UnusedLocalVariable-off
		Для Стр = 2 По Строк Цикл
		// BSLLS:UnusedLocalVariable-on
			ТекстВставкиТаблицы = ТекстВставкиТаблицы + "
			|<tr width=""" + ?(ШиринаВПикселях, Формат(ШиринаТаблицыПикс, "ЧГ=0") + "px", "100%") + """>
			|";
			Для а = 1 По Колонки Цикл
				Если ШиринаВПикселях Тогда
					ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + Формат(ШиринаКолонкиПикс, "ЧГ=0") + "px"">&nbsp;</td>
					|";
				Иначе	
					ТекстВставкиТаблицы = ТекстВставкиТаблицы + "<td width=""" + ?(а = Колонки, ШиринаКолонки 
						+ ДопШиринаПоследней, ШиринаКолонки) + "%"">&nbsp;</td>
					|";
				КонецЕсли;
			КонецЦикла;
			ТекстВставкиТаблицы = ТекстВставкиТаблицы + "</tr>";
		КонецЦикла;
		ТекстВставкиТаблицы = ТекстВставкиТаблицы + " 
		|</table>
		|<br>
		|<br>
		|";
	КонецЕсли;
	
	Если БезРамки Тогда
		ТекстВставкиТаблицы = СтрЗаменить(ТекстВставкиТаблицы, "border ", "");
	КонецЕсли;
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "insertHTML", ТекстВставкиТаблицы);
	
КонецПроцедуры

// Процедура увеличивает шрифт в поле HTML.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML			 - ПолеФормы					 - HTML-документ.
//
Процедура УвеличитьШрифт(Форма, ПолеHTML) Экспорт
	
	Размер = Число(ПолеHTML.Документ.queryCommandValue("fontSize"));
	
	Если Не ЗначениеЗаполнено(Размер) Тогда 
		Размер = 2;
	КонецЕсли;
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "fontSize", Размер + 1, Ложь);
	
	Форма.ТекущийЭлемент = ПолеHTML;
	
КонецПроцедуры

// Процедура уменьшает шрифт в поле HTML.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML			 - ПолеФормы					 - HTML-документ.
//
Процедура УменьшитьШрифт(Форма, ПолеHTML) Экспорт
	
	Размер = Число(ПолеHTML.Документ.queryCommandValue("fontSize"));
	
	Если Не ЗначениеЗаполнено(Размер) Тогда 
		Размер = 3;
	КонецЕсли;
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "fontSize", Размер - 1, Ложь);
	
	Форма.ТекущийЭлемент = ПолеHTML;
	
КонецПроцедуры

// Процедура изменяет шрифт в поле HTML.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML			 - ПолеФормы					 - HTML-документ.
//
Процедура ИзменитьШрифт(Форма, ПолеHTML) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьШрифтЗавершение", CRM_РаботаСHTMLКлиент,
		 ДополнительныеПараметры);
	
	ДиалогВыбораШрифта = Новый ДиалогВыбораШрифта;
	ДиалогВыбораШрифта.Показать(ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик завершения изменения шрифта.
//
// Параметры:
//  Шрифт		 - Шрифт - Шрифт.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ИзменитьШрифтЗавершение(Шрифт, ДополнительныеПараметры) Экспорт
	
	Если Шрифт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	
	Если Не ПустаяСтрока(Шрифт.Имя) Тогда
		ВыполнитьHTMLКоманду(Форма, ПолеHTML, "fontName", Шрифт.Имя, Ложь);
	КонецЕсли;
	
	РазмерШрифта = 2;
	
	Если Шрифт.Размер <> -1 Тогда
		Если Шрифт.Размер < 8 Тогда
			РазмерШрифта = 1;
		ИначеЕсли Шрифт.Размер <= 10 Тогда
			РазмерШрифта = 2;	
		ИначеЕсли Шрифт.Размер <= 12 Тогда
			РазмерШрифта = 3;	
		ИначеЕсли Шрифт.Размер <= 14 Тогда
			РазмерШрифта = 4;	
		ИначеЕсли Шрифт.Размер <= 16 Тогда
			РазмерШрифта = 5;	
		ИначеЕсли Шрифт.Размер <= 18 Тогда
			РазмерШрифта = 6;	
		Иначе
			РазмерШрифта = 7;	
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, "fontSize", РазмерШрифта, Ложь);
	
	Если Шрифт.Зачеркивание = Истина Тогда
		ВыполнитьHTMLКоманду(Форма, ПолеHTML, "strikeThrough", , Ложь);
	КонецЕсли;
	
	Если Шрифт.Полужирный = Истина Тогда
		ВыполнитьHTMLКоманду(Форма, ПолеHTML, "Bold", , Ложь);
	КонецЕсли;
	
	Если Шрифт.Наклонный = Истина Тогда
		ВыполнитьHTMLКоманду(Форма, ПолеHTML, "italic", , Ложь);
	КонецЕсли;
	
	Если Шрифт.Подчеркивание = Истина Тогда
		ВыполнитьHTMLКоманду(Форма, ПолеHTML, "underline", , Ложь);
	КонецЕсли;
	
	ПоказатьРежимыКнопок(Форма, ПолеHTML);
	
КонецПроцедуры

// Процедура выплоняет выбор цвета в поле HTML.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML	 - ПолеФормы					 - HTML-документ.
//  ИмяКоманды	 - Строка						 - Имя команды.
//
Процедура ВыборЦвета(Форма, ПолеHTML, ИмяКоманды) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ПолеHTML", ПолеHTML);
	ДополнительныеПараметры.Вставить("ИмяКоманды", ИмяКоманды);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЦветаЗавершение", CRM_РаботаСHTMLКлиент, ДополнительныеПараметры);
	
	ОткрытьФорму("Обработка.CRM_РаботаСHTML.Форма.ВыборЦвета", , Форма, , , , ОписаниеОповещения);
	
КонецПроцедуры

// Процедура-обработчик завершения выбора цвета.
//
// Параметры:
//  Цвет		 - Цвет - Цвет.
//  ДополнительныеПараметры	 - Структура - Дополнительные параметры.
//
Процедура ВыборЦветаЗавершение(Цвет, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(Цвет) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПолеHTML = ДополнительныеПараметры.ПолеHTML;
	ИмяКоманды = ДополнительныеПараметры.ИмяКоманды;
	
	СтрокаЦвета = "" + HEX(Цвет.Красный) + HEX(Цвет.Зеленый) + HEX(Цвет.Синий);
	
	ВыполнитьHTMLКоманду(Форма, ПолеHTML, ИмяКоманды, СтрокаЦвета, Ложь);
	
КонецПроцедуры

// Процедура выплоняет команду HTML.
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма.
//  ПолеHTML		 - ПолеФормы					 - HTML-документ.
//  ИмяКоманды		 - Строка						 - Имя команды.
//  ПараметрКоманды	 - Строка						 - Параметр команды.
//  Обновлять		 - Булево						 - Признак обновления.
//
Процедура ВыполнитьHTMLКоманду(Форма, ПолеHTML, ИмяКоманды, ПараметрКоманды = "", Обновлять = Истина) Экспорт
	
	Если ПолеHTML.Документ.queryCommandSupported(ИмяКоманды) Тогда
		ПолеHTML.Документ.execCommand(ИмяКоманды, Ложь, ПараметрКоманды);
		Если Обновлять Тогда
			ПоказатьРежимыКнопок(Форма, ПолеHTML);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПоддержкаLinux

// Процедура используется для поддержки метода closest для ОС Linux. Замена методу closest.
//
// Параметры:
//  ТекущийУзел	 - ВнешнийОбъект	 - HTML элемент.
//  Стили		 - Строка			 - CSS класс для поиска.
//
// Возвращаемое значение:
//  ВнешнийОбъект - Найденный ближайшей элемент по стилю.
//
Функция Полифил_closest(Знач ТекущийУзел, Стили) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат ТекущийУзел.closest(Стили);
	#Иначе
		Если ТекущийУзел.closest = Неопределено Тогда
			Пока ТекущийУзел <> Неопределено Цикл
				Если ТекущийУзел.webkitMatchesSelector(Стили) = Истина Тогда
					Возврат ТекущийУзел;
				КонецЕсли;
				
				ТекущийУзел = ТекущийУзел.parentElement;
			КонецЦикла;
			
			Возврат Неопределено;
		Иначе
			Возврат ТекущийУзел.closest(Стили);
		КонецЕсли;
	#КонецЕсли
	
КонецФункции // Полифил_closest()

// Процедура используется для поддержки метода replaceWith для ОС Linux. Замена методу replaceWith.
//
// Параметры:
//  ПолеДокументаHTML	 - ПолеФормы			 - HTML-документ.
//  ЭлементЗамены		 - ВнешнийОбъект		 - Элемент, у которого будут замещаться все дочерние элементы.
//  Замена				 - Массив или Строка	 - Массив элементов на которые заменяем, либо текст.
//
Процедура Полифил_replaceWith(ПолеДокументаHTML, ЭлементЗамены, Замена) Экспорт
	
	#Если ВебКлиент Тогда
		ЭлементЗамены.replaceWith(Замена);
	#Иначе
		Если ЭлементЗамены.replaceWith = Неопределено Тогда
			ДокументHTML		= ПолеДокументаHTML.Документ;
			ФрагментДокумента	= ДокументHTML.createDocumentFragment();
			
			Если ТипЗнч(Замена) = Тип("Массив") Тогда
				Для Каждого ТекущийЭлементЗамены Из Замена Цикл
					Если ТипЗнч(ТекущийЭлементЗамены) = Тип("Строка") Тогда
						НовыйЭлемент = ДокументHTML.createTextNode(ТекущийЭлементЗамены);
						ФрагментДокумента.appendChild(НовыйЭлемент);
					Иначе
						ФрагментДокумента.appendChild(ТекущийЭлементЗамены);
					КонецЕсли;
				КонецЦикла;
			Иначе
				НовыйЭлемент = ДокументHTML.createTextNode(Замена);
				ФрагментДокумента.appendChild(НовыйЭлемент);
			КонецЕсли;
			
			ЭлементЗамены.parentNode.replaceChild(ФрагментДокумента, ЭлементЗамены);
		Иначе
			ЭлементЗамены.replaceWith(Замена);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры // Полифил_replaceWith()

#КонецОбласти

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#Область КомпонентаВставкиКартинокИзБуфера

//Функция ПроинициализироватьКомпоненту()
//	
//	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
//		
//		Возврат Ложь;
//		
//	КонецЕсли;
//	
//	Возврат Истина;
//	
//КонецФункции

Процедура УстановитьКомпоненту(ОбработчикРезультата)

	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УстановитьКомпонентуПодключениеВнешнейКомпонентыПродолжение",
			ЭтотОбъект,
			ОбработчикРезультата);
		
		НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, 
			"ОбщийМакет.CRM_КомпонентаПолученияКартинкиИзБуфера", 
			"ImageFromClipboard", 
			ТипВнешнейКомпоненты.Native);
		
	Иначе
		Состояние(НСтр("ru = 'Компонента копирования из буфера уже установлена.'"));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение установки компоненты
//
// Параметры:
//  Подключена			 - Булево	 - Признак того, что компонента подключена.
//  ОбработчикРезультата - ОписаниеОповещения	 - Обработчик результата.
//
Процедура УстановитьКомпонентуПодключениеВнешнейКомпонентыПродолжение(Подключена, ОбработчикРезультата) Экспорт
	
	Если Подключена Тогда
		Состояние(НСтр("ru = 'Компонента копирования из буфера уже установлена.'"));
	Иначе
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"НачатьУстановкуВнешнейКомпонентыПродолжение",
			ЭтотОбъект,
			ПараметрыВыполнения);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, "ОбщийМакет.CRM_КомпонентаПолученияКартинкиИзБуфера");
		Возврат;
		
	КонецЕсли;
	
	// BSLLS:UnusedLocalVariable-off
	КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");
	// BSLLS:UnusedLocalVariable-on
	
КонецПроцедуры

Процедура НачатьУстановкуВнешнейКомпонентыПродолжение(ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияДляПодключения = Новый Структура;
	ПараметрыВыполненияДляПодключения.Вставить("ОбработчикРезультата", ПараметрыВыполнения.ОбработчикРезультата);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьПодключениеВнешнейКомпонентыПродолжение",
		ЭтотОбъект,
		ПараметрыВыполненияДляПодключения);
	
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, 
		"ОбщийМакет.CRM_КомпонентаПолученияКартинкиИзБуфера", 
		"ImageFromClipboard", 
		ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Продолжение установки компоненты
Процедура НачатьПодключениеВнешнейКомпонентыПродолжение(Подключена, ПараметрыВыполнения) Экспорт
	
	Если Подключена Тогда
		
		// BSLLS:UnusedLocalVariable-off
		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");
		// BSLLS:UnusedLocalVariable-on
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОбработчикРезультата, Подключена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Подготавливает HTML документ
//	Параметры:
//		ПолеHTML - Элемент формы ПолеHTMLДокумента
//		ДобавленныеКартинки - Массив в который подгружаются двоичные данные картинок 
//		УникальныйИдентификаторФормы - УникальныйИдентификаторФормы
//		ИгнорироватьТеги - Строка - CSS селекторы (теги, слассы
	// и др.), через запятую, в которых картинки обрабатываться не будут
Процедура ЗаписатьHTML(ПолеHTML, ДобавленныеКартинки, УникальныйИдентификаторФормы,
	 ИгноририруемыеСелекторы = "") Экспорт
	
	HTMLДокумент = ПолеHTML.Документ;
	МассивИгнорСелекторов = СтрРазделить(ИгноририруемыеСелекторы, ",", Ложь);
	
	Для Индекс = 0 По HTMLДокумент.images.length - 1 Цикл
		
		Изображение = HTMLДокумент.images.item(Индекс);
		
		ПропуститьКартинку = Ложь;
		Для Каждого Селектор Из МассивИгнорСелекторов Цикл
			Если CRM_РаботаСHTMLКлиент.Полифил_closest(Изображение, Селектор) <> Неопределено Тогда
				ПропуститьКартинку = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПропуститьКартинку Тогда
			Продолжить;
		КонецЕсли;

		ДобавлятьВложение = Ложь;
		
		Если СтрНайти(ВРег(Изображение.src), ВРег("file://")) = 1 Тогда
			
			ДобавлятьВложение = Истина;
			
			ПутьФайла = Сред(Изображение.src, СтрДлина("file://") + 1);
			ПутьФайла = СтрЗаменить(ПутьФайла, "%20", " ");
			
			ПервыйСимвол = Лев(ПутьФайла, 1);
			ПервыеДваСимвола = Лев(ПутьФайла, 2);
			Если (ПервыйСимвол = "/"  И Не ПервыеДваСимвола = "//")
				Или ПервыйСимвол = "\" Тогда
				ПутьФайла = Сред(ПутьФайла, 2);
			КонецЕсли;
			
			Данные = Новый ДвоичныеДанные(ПутьФайла);
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификаторФормы);
			
			Файл = Новый Файл(ПутьФайла);
			Расширение = Файл.Расширение;
			Размер = Данные.Размер();
			
		ИначеЕсли СтрНайти(ВРег(Изображение.src), ВРег("data:image/")) = 1 Тогда
			
			ДобавлятьВложение = Истина;
			
			ПозицияТипКартинки = СтрНайти(Изображение.src, ";base64,");
			Если ПозицияТипКартинки = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ДлинаФрагмента = СтрДлина(";base64,");
			ДвоичныеДанные = Base64Значение(Сред(Изображение.src, ПозицияТипКартинки + ДлинаФрагмента));
			
			РезультатПомещения = CRM_ВзаимодействияВызовСервера.ПоместитьКартинкуВоВременноеХранилище(ДвоичныеДанные,
				 УникальныйИдентификаторФормы);
			
			Расширение = РезультатПомещения.Расширение;
			Размер = РезультатПомещения.Размер;
			АдресВоВременномХранилище = РезультатПомещения.АдресВХранилище;
			
		КонецЕсли;
		
		Если ДобавлятьВложение Тогда
			
			УникальныйИдентификаторФайла = Строка(Новый УникальныйИдентификатор);
			Изображение.src = "cid:" + УникальныйИдентификаторФайла;
			
			ПараметрыВложения = Новый Структура;
			ПараметрыВложения.Вставить("ИмяФайла", "_" + СтрЗаменить(УникальныйИдентификаторФайла, "-", "_") + Расширение);
			ПараметрыВложения.Вставить("Размер", Размер);
			ПараметрыВложения.Вставить("ИДФайлаЭлектронногоПисьма", УникальныйИдентификаторФайла);
			ПараметрыВложения.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
			
			ДобавленныеКартинки.Добавить(ПараметрыВложения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗапомнитьПозициюHTML(ПолеHTML, ПозицияHTML) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	Если ПозицияHTML = Неопределено Тогда
		ПозицияHTML = СтруктураПозицииHTML();
	КонецЕсли;
	
	HTMLДокумент = ПолеHTML.Документ; 
	
	Попытка
		// BSLLS:UnusedLocalVariable-off
		ie9_body = HTMLДокумент.ie9_body;
		// BSLLS:UnusedLocalVariable-on
	Исключение
		Возврат; // IE8 не поддерживаем
	КонецПопытки;
	
	Попытка
		
		Выделение = HTMLДокумент.getSelection();
		
		Узел = Выделение.getRangeAt(0).startContainer;
		ПозицияHTML.ТекущееПоложениеНачало = Выделение.getRangeAt(0).startOffset;
		ПозицияHTML.ТекущееПоложениеКонец = Выделение.getRangeAt(0).endOffset;
		
		Счетчик = 0;
		НайденныйНомерУзла = -1;
		
		НайтиНомерУзла(HTMLДокумент, Узел, Счетчик, НайденныйНомерУзла);
		
		ПозицияHTML.ТекущийНомерУзла = НайденныйНомерУзла;
		
		ПозицияHTML.ГоризонтальнаяПрокруткаHTML = HTMLДокумент.body.scrollLeft;
		ПозицияHTML.ВертикальнаяПрокруткаHTML = HTMLДокумент.body.scrollTop;
		
	Исключение
		// не бросаем исключение - иногда HTMLДокумент дает ошибку
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Процедура ВосстановитьПоложениеHTML(ПолеHTML, ПозицияHTML) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	Если ПозицияHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	HTMLДокумент = ПолеHTML.Документ; 
	
	Попытка
		// BSLLS:UnusedLocalVariable-off
		ie9_body = HTMLДокумент.ie9_body;
		// BSLLS:UnusedLocalVariable-on
	Исключение
		Возврат; // IE8 не поддерживаем
	КонецПопытки;
	
	Счетчик = 0;
	НайденныйУзел = Неопределено;
	
	Если ПозицияHTML.ТекущийНомерУзла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Результат = НайтиУзелПоНомеру(HTMLДокумент, ПозицияHTML.ТекущийНомерУзла, Счетчик, НайденныйУзел);
		Если Результат Тогда
			
			Диапазон = HTMLДокумент.createRange();
			Диапазон.setStart(НайденныйУзел, ПозицияHTML.ТекущееПоложениеНачало);
			Диапазон.setEnd(НайденныйУзел, ПозицияHTML.ТекущееПоложениеКонец);
			
			Выделение = HTMLДокумент.getSelection();
			Выделение.removeAllRanges();
			Выделение.addRange(Диапазон);
			
			HTMLДокумент.body.scrollLeft = ПозицияHTML.ГоризонтальнаяПрокруткаHTML;
			HTMLДокумент.body.scrollTop = ПозицияHTML.ВертикальнаяПрокруткаHTML;
			
		КонецЕсли;
		
	Исключение
		// не бросаем исключение - иногда HTMLДокумент дает ошибку
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Функция НайтиНомерУзла(ТекущийУзел, ВыделенныйУзел, Счетчик, НайденныйНомерУзла)
	
	Если ТекущийУзел.childNodes.length = 0 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Для Каждого Узел Из ТекущийУзел.childNodes Цикл
		
		Счетчик = Счетчик + 1;
		
		Если Узел = ВыделенныйУзел Тогда
			НайденныйНомерУзла = Счетчик;
			Возврат Истина;
		КонецЕсли;	
		
		Результат = НайтиНомерУзла(Узел, ВыделенныйУзел, Счетчик, НайденныйНомерУзла);
		Если Результат = Истина Тогда
			Возврат Результат;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция НайтиУзелПоНомеру(ТекущийУзел, НомерУзла, Счетчик, НайденныйУзел)
	
	Если ТекущийУзел.childNodes.length = 0 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Для Каждого Узел Из ТекущийУзел.childNodes Цикл
		
		Счетчик = Счетчик + 1;
		
		Если Счетчик = НомерУзла Тогда
			НайденныйУзел = Узел;
			Возврат Истина;
		КонецЕсли;	
		
		Результат = НайтиУзелПоНомеру(Узел, НомерУзла, Счетчик, НайденныйУзел);
		Если Результат = Истина Тогда
			Возврат Результат;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция СтруктураПозицииHTML()
	
	Возврат Новый Структура("ТекущееПоложениеНачало,ТекущееПоложениеКонец,ТекущийНомерУзла,
		|ГоризонтальнаяПрокруткаHTML,
		|ВертикальнаяПрокруткаHTML");
	
КонецФункции

Функция ТекстВПолеHTML(ПолеHTML) Экспорт
	
	HTMLДокумент = ПолеHTML.Документ;
	
	Если HTMLДокумент = Неопределено Тогда
		Возврат "<html></html>";
	КонецЕсли;
	
	ContentEditable = HTMLДокумент.body.ContentEditable;
	Если ContentEditable = "true" Тогда
		HTMLДокумент.body.ContentEditable = "false";
	КонецЕсли;
	
	ТекстHTMLЗаголовка = HTMLДокумент.head.outerHTML;
	ТекстHTMLТела = HTMLДокумент.body.outerHTML;
	
	Если ContentEditable = "true" Тогда
		HTMLДокумент.body.ContentEditable = "true";
	КонецЕсли;
	
	Возврат "<html>" + ТекстHTMLЗаголовка + ТекстHTMLТела + "</html>";
	
КонецФункции

Процедура ПоказатьРежимыКнопок(Форма, ПолеHTML) Экспорт
	
	КоманднаяПанель = Форма.Элементы.КоманднаяПанельКнопок;
	
	Для Каждого Группа Из КоманднаяПанель.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Группа) = Тип("ГруппаФормы") Тогда
			Для Каждого Кнопка Из Группа.ПодчиненныеЭлементы Цикл
				Если ТипЗнч(Кнопка) = тип("КнопкаФормы") Тогда
					Команда = Сред(Кнопка.Имя, 8);
					Пометка = ПолеHTML.Документ.queryCommandSupported(Команда);
					Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Кнопка, "Пометка") Тогда
						Кнопка.Пометка = Пометка И Кнопка.Пометка;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Если Лев(Группа.Имя, 8) = "Команда" Тогда
				Команда = Сред(Группа.Имя, 8);
				Пометка = ПолеHTML.Документ.queryCommandSupported(Команда);
			Иначе
				Пометка = Истина;
			КонецЕсли;
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Группа, "Пометка") Тогда
				Группа.Пометка = Пометка И Группа.Пометка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция HEX(Знач Значение, Разрядность = 2)
	
	Перем Результат;
	
	Пока Значение > 0 Цикл
		Результат = Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", Значение % 16 + 1, 1) + Результат;
		Значение = Цел(Значение / 16);
	КонецЦикла;
	
	Результат = Прав("00000000" + Результат, Разрядность);
	
	Возврат Результат;
	
КонецФункции

Процедура ВставитьСсылкуНаОбъект(ПолеHTML, Ссылка, ПредставлениеСсылки) Экспорт
	
	Документ = ПолеHTML.Документ;
	Выделение = Документ.getSelection().getRangeAt(0);
	ТекстСсылки = СтрШаблон("<a href=""%1"">%2</a>", Ссылка, ПредставлениеСсылки);
	Узел = Выделение.createContextualFragment(ТекстСсылки);
	Выделение.insertNode(Узел);
	
КонецПроцедуры

#КонецОбласти
