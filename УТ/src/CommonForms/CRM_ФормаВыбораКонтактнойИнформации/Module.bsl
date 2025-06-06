
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Тип = Параметры.Тип;
	Отказ1 = ?(Параметры.Свойство("Тип"), Ложь, Истина);
	Отказ2 = ?(Параметры.Свойство("Контакт"), Ложь, Истина);
	Отказ = Отказ1 ИЛИ Отказ2;
	
	Если Параметры.Свойство("Вид") Тогда
		Вид = Параметры.Вид;
	КонецЕсли;
		
	Если Не Отказ Тогда
		
		СписокКонтактов = Новый Массив;
		
		Если НЕ ТипЗнч(Параметры.Контакт) = Тип("Массив") Тогда
			СписокКонтактов.Добавить(Параметры.Контакт);
		Иначе
			СписокКонтактов = Параметры.Контакт;
		КонецЕсли;
		
		Для каждого Эл Из СписокКонтактов Цикл
			
			Контакт = Эл;
			Тип = Параметры.Тип;
			ЗаполнитьДеревоЗначенийПоКонтрагенту(Контакт, ?(Параметры.Свойство("ОдноКонтактноеЛицо"),
				 Параметры.ОдноКонтактноеЛицо,
				 Ложь));
			Если (Тип = Перечисления.ТипыКонтактнойИнформации.Телефон И НЕ Параметры.Свойство("Вид")) ИЛИ
				Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
				// Звонить можно только по одному номеру, адрес на карте можно открыть только один.
				Элементы.ДеревоЗначений.КоманднаяПанель.ПодчиненныеЭлементы.КомандаОтметитьВсе.Видимость = Ложь;
				Элементы.ДеревоЗначений.КоманднаяПанель.ПодчиненныеЭлементы.КомандаСнятьВсе.Видимость = Ложь;
				
				Заголовок = НСтр("ru='Форма выбора телефонного номера';en='Form of a choice of telephone number'");
				
			ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				
				Заголовок = НСтр("ru='Форма выбора электронного адреса';en='Form of a choice of the electronic address'");
				
			ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
				
				Заголовок = НСтр("ru='Форма выбора адреса';en='Form of a choice of the address'");
				
			ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
				
				Заголовок = НСтр("ru='Форма выбора Web-страницы';en='Form of a choice of the Web page'");
				
			ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.Факс Тогда
				
				Заголовок = НСтр("ru='Форма выбора номера факса';en='Form of a choice of number of a fax'");
				
			Иначе	
				
				Заголовок = НСтр("ru='Форма выбора контактной информации';en='Form of a choice of the contact information'");
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КоличествоКонтактов = 1 Тогда
		СписокРезультат = Новый СписокЗначений;
		СтруктураЗначения = Новый Структура("Контакт, Тип, Вид");
		ЭлементыДерева = ДеревоЗначений.ПолучитьЭлементы();
		Родитель = ЭлементыДерева[0];
		УзлыРодителя = Родитель.ПолучитьЭлементы();
		Узел = УзлыРодителя[0];
		КонтактнаяИнформация = ?(ЗначениеЗаполнено(Узел.КонтактнаяИнформация), Узел.КонтактнаяИнформация, Узел.Представление);
		СтруктураЗначения.Контакт = Родитель.Контакт;
		СтруктураЗначения.Тип = Узел.Тип;
		СтруктураЗначения.Вид = Узел.Вид;
		СписокРезультат.Добавить(СтруктураЗначения, КонтактнаяИнформация);
		Если КлючНазначенияИспользования = "СозданиеДокументаСМС" Тогда
			ДополнительныеПараметры = Новый Структура;
			CRM_ОбщегоНазначенияКлиент.ОткрытьФормуДокументаСМС(СписокРезультат, ДополнительныеПараметры);
			Отказ = Истина;
			Закрыть();
		ИначеЕсли Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
			сфпСофтФонПроКлиент.сфпПозвонить(КонтактнаяИнформация, СтруктураЗначения.Контакт);
			Отказ = Истина;
			Закрыть();
		Иначе
			Закрыть(СписокРезультат);
		КонецЕсли;	
	ИначеЕсли КоличествоКонтактов = 0 Тогда	
		
		Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Партнеры") Тогда
        Текст = НСтр("ru='У данного клиента не указан ';en='Client has not been specified'") + НРег(Тип);
            ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		        Текст,
		        Контакт
		        );
        ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
                Текст = НСтр("ru='У данного контактного лица не указан ';en='This contact is not specify '") 
                	+ НРег(Тип);
                ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
    		        Текст,
    		        Контакт
   		        );
        КонецЕсли;
		
		Отказ = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоЗначений

&НаКлиенте
Процедура ДеревоЗначенийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокРезультат = Новый СписокЗначений;
	СтруктураЗначения = Новый Структура("Контакт, Тип, Вид");
	
	ЭлементыДерева = ДеревоЗначений.ПолучитьЭлементы();
	Узел = Элементы.ДеревоЗначений.ТекущиеДанные;
	Родитель = Узел.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		
		Родитель = Узел;
		ЭлРодителя = Родитель.ПолучитьЭлементы();
		КолЭлРодителя = ЭлРодителя.Количество();
		
		Если КолЭлРодителя = 1 Тогда
			Узел = ЭлРодителя[0];
			КонтактнаяИнформация = ?(ЗначениеЗаполнено(Узел.КонтактнаяИнформация), Узел.КонтактнаяИнформация,
				 Узел.Представление);
			
			СтруктураЗначения.Контакт = Родитель.Контакт;
			СтруктураЗначения.Тип = Узел.Тип;
			СтруктураЗначения.Вид = Узел.Вид;
			
			СписокРезультат.Добавить(СтруктураЗначения, КонтактнаяИнформация);
			
			Закрыть(СписокРезультат);
			
		КонецЕсли;
	Иначе
		
		КонтактнаяИнформация = ?(ЗначениеЗаполнено(Узел.КонтактнаяИнформация), Узел.КонтактнаяИнформация, Узел.Представление);
		
		СтруктураЗначения.Контакт = Родитель.Контакт;
		СтруктураЗначения.Тип = Узел.Тип;
		СтруктураЗначения.Вид = Узел.Вид;
		
		СписокРезультат.Добавить(СтруктураЗначения, КонтактнаяИнформация);
		
		Закрыть(СписокРезультат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЗначенийПометкаПриИзменении(Элемент)
	
	ТекущийЭлементДерева = Элементы.ДеревоЗначений.ТекущиеДанные;
	Родитель = ТекущийЭлементДерева.ПолучитьРодителя();
	Пометка = ТекущийЭлементДерева.Пометка;
	РадиоКнопка = ?(Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"), Истина, Ложь);
	
	Если Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты")
		 ИЛИ Вид = "СМС"  Тогда
		
		Если Родитель = Неопределено Тогда
			ПодчиненныеУзлы = ТекущийЭлементДерева.ПолучитьЭлементы();
			Для каждого Узел Из ПодчиненныеУзлы Цикл
				Узел.Пометка = Пометка;
			КонецЦикла;
		Иначе
			Родитель = ТекущийЭлементДерева.ПолучитьРодителя();
			Родитель.Пометка = Пометка;
			
		КонецЕсли;
		
	Иначе
		
		ИзменениеПометкиПриВыбореТелефона();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПродолжить(Команда)
	
	СписокРезультат = Новый СписокЗначений;
	ДеревоПолучитьВсеПомеченные(ДеревоЗначений, СписокРезультат);
	Закрыть(СписокРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьВсе(Команда)
	ПометитьВсе(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтметитьВсе(Команда)
	ПометитьВсе(Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьКонтактнуюИнформацию(Контакт, Тип, ВключатьПартнера = Истина,
	 ВключатьКонтактныхЛиц = Истина,
	 ОдноКонтактноеЛицо = Ложь)
	
	Запрос = Новый Запрос;
	Владелец = Неопределено;
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Партнеры") Тогда
		Владелец = Контакт;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		Владелец = Контакт.Владелец;
	КонецЕсли;
	Запрос.Текст =  "ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка,
	|   ИСТИНА КАК ЭтоПартнер,
	|	КонтрагентыКонтактнаяИнформация.Тип,
	|	КонтрагентыКонтактнаяИнформация.Вид,
	|	КонтрагентыКонтактнаяИнформация.АдресЭП,
	|	КонтрагентыКонтактнаяИнформация.НомерТелефона,
	|	КонтрагентыКонтактнаяИнформация.Представление,
	|   КонтрагентыКонтактнаяИнформация.CRM_ОсновнойДляСвязи КАК ОсновнойВидДляСвязи,
	|	0 Порядок
	|ИЗ
	|	Справочник.Партнеры.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|   &ВключатьПартнера И 
	|	КонтрагентыКонтактнаяИнформация.Тип = &Тип
	|	И КонтрагентыКонтактнаяИнформация.Ссылка = &Владелец
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактныеЛицаКонтактнаяИнформация.Ссылка,
	|   Ложь, //ЭтоПартнер
	|	КонтактныеЛицаКонтактнаяИнформация.Тип,
	|	КонтактныеЛицаКонтактнаяИнформация.Вид,
	|	КонтактныеЛицаКонтактнаяИнформация.АдресЭП,
	|	КонтактныеЛицаКонтактнаяИнформация.НомерТелефона,
	|	КонтактныеЛицаКонтактнаяИнформация.Представление,
	|   КонтактныеЛицаКонтактнаяИнформация.CRM_ОсновнойДляСвязи КАК ОсновнойВидДляСвязи,
	|	1 // Порядок
	|ИЗ
	|	Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
	|ГДЕ
	|";
	
	Если ОдноКонтактноеЛицо И ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		Запрос.Текст =  Запрос.Текст + "
		|	КонтактныеЛицаКонтактнаяИнформация.Ссылка = &Контакт И
		|";
		Запрос.УстановитьПараметр("Контакт", Контакт);
	КонецЕсли;
	
	Запрос.Текст =  Запрос.Текст + "
	|   &ВключатьКонтактныхЛиц И 
	|	КонтактныеЛицаКонтактнаяИнформация.Ссылка.Владелец = &Владелец
	|	И КонтактныеЛицаКонтактнаяИнформация.Тип = &Тип
	|ИТОГИ ПО
	|	Порядок,
	|	Ссылка";
	Запрос.УстановитьПараметр("Тип", Тип);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ВключатьПартнера", ВключатьПартнера);
	Запрос.УстановитьПараметр("ВключатьКонтактныхЛиц", ВключатьКонтактныхЛиц);
	Возврат Запрос.Выполнить();
КонецФункции

&НаКлиенте
Процедура ИзменениеПометкиПриВыбореТелефона()
	
	ТекущийЭлементДерева = Элементы.ДеревоЗначений.ТекущиеДанные;
	Пометка = ТекущийЭлементДерева.Пометка;
	
	Родитель = ТекущийЭлементДерева.ПолучитьРодителя();
	Узлы = ДеревоЗначений.ПолучитьЭлементы();
	ПометитьВсе(Ложь);
	Если Родитель = Неопределено Тогда
		Родитель = ТекущийЭлементДерева;
		Родитель.Пометка = Пометка;
		Если Пометка = Истина Тогда
			ДочерниеЭлементы = Родитель.ПолучитьЭлементы();
			ДочУзел = ДочерниеЭлементы.Получить(0);
			Если ДочУзел <> Неопределено Тогда
				ДочУзел.Пометка = Пометка;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ТекущийЭлементДерева.Пометка = Пометка;
		Родитель.Пометка = Пометка;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция  ЗаполнитьДеревоЗначенийПоКонтрагенту(Контакт, ОдноКонтактноеЛицо = Ложь)
	
	РезультатЗапроса = Неопределено;
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Партнеры") Тогда
		РезультатЗапроса = ПолучитьКонтактнуюИнформацию(Контакт, Тип, Истина, Истина);
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		РезультатЗапроса = ПолучитьКонтактнуюИнформацию(Контакт, Тип, Ложь, Истина, ОдноКонтактноеЛицо);
	КонецЕсли;
	
	ВыборкаПорядок = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КорневыеЭлементы = ДеревоЗначений.ПолучитьЭлементы();
	
	МобильныйТелефонКонтактногоЛица =
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица");
	МобильныйТелефонПользователя 	=
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.CRM_МобильныйТелефонПользователя");
	
	// Порядок
	Пока ВыборкаПорядок.Следующий() Цикл
		
		ВыборкаВладельцы = ВыборкаПорядок.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		// Ссылки конрагентов и КЛ
		Пока ВыборкаВладельцы.Следующий() Цикл
			
			ЭлементУровень0 = КорневыеЭлементы.Добавить();
			ЭлементУровень0.Контакт = ВыборкаВладельцы.Ссылка;
			
			Если ТипЗнч(ВыборкаВладельцы.Ссылка) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
				ЭлементУровень0.Представление = ВыборкаВладельцы.Ссылка.CRM_Должность;
			КонецЕсли;
			
			ЭлементУровень0.ЭтоВладелецКонтактнойИнформации = Ложь;
			ДеревоДетальныеЗаписи = ЭлементУровень0.ПолучитьЭлементы();
			ВыборкаДетальныеЗаписи = ВыборкаВладельцы.Выбрать();
			ЭлементУровень0.ЭтоПартнер = Ложь;
			
			// Детальные записи контактной информации.
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				// проверим что это Партнер
				Если НЕ ЭлементУровень0.ЭтоПартнер И ВыборкаДетальныеЗаписи.ЭтоПартнер Тогда
					ЭлементУровень0.ЭтоПартнер = Истина;	
				КонецЕсли; 
				
				Если Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
					НомерТелефона = ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.НомерТелефона),
						 ВыборкаДетальныеЗаписи.НомерТелефона,
						 ВыборкаДетальныеЗаписи.Представление);
					
					// Выводим строку только, если заполнены.
					Если ЗначениеЗаполнено(НомерТелефона) Тогда
						
						ДетальнаяЗапись = ДеревоДетальныеЗаписи.Добавить();
						ДетальнаяЗапись.Тип = ВыборкаДетальныеЗаписи.Тип;
						ДетальнаяЗапись.Вид = ВыборкаДетальныеЗаписи.Вид;
						ДетальнаяЗапись.ОсновнойВидДляСвязи = ВыборкаДетальныеЗаписи.ОсновнойВидДляСвязи;
						ДетальнаяЗапись.КонтактнаяИнформация = НомерТелефона;
						ДетальнаяЗапись.ЭтоВладелецКонтактнойИнформации = Истина;
						Представление = ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Представление),
							 ВыборкаДетальныеЗаписи.Представление,
							 НомерТелефона);
						
						КоличествоКонтактов = КоличествоКонтактов + 1;
						
						// Для того чтобы можно было отличить мобильный от обычного.
						Если ВыборкаДетальныеЗаписи.Вид = МобильныйТелефонКонтактногоЛица
							ИЛИ ВыборкаДетальныеЗаписи.Вид = МобильныйТелефонПользователя 
							Тогда
							
							ДетальнаяЗапись.Представление = Представление + НСтр("ru=' (моб.)';en=' (mob.)'");
							
						Иначе
							ДетальнаяЗапись.Представление = Представление;
						КонецЕсли;
					КонецЕсли;
					
				ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
					
					// Выведем адреса электронной почты.
					АдресЭП = ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.АдресЭП), ВыборкаДетальныеЗаписи.АдресЭП,
						 ВыборкаДетальныеЗаписи.Представление);
					Если ЗначениеЗаполнено(АдресЭП) Тогда
						
						ДетальнаяЗапись = ДеревоДетальныеЗаписи.Добавить();
						ДетальнаяЗапись.Тип = ВыборкаДетальныеЗаписи.Тип;
						ДетальнаяЗапись.Вид = ВыборкаДетальныеЗаписи.Вид;
						
						// Сразу отметим вид КИ, коотрый указан как "Основной для связи"
						// он будет выводиться "жирным".
						ДетальнаяЗапись.ОсновнойВидДляСвязи = ВыборкаДетальныеЗаписи.ОсновнойВидДляСвязи;
						
						ДетальнаяЗапись.КонтактнаяИнформация = ВыборкаДетальныеЗаписи.АдресЭП;
						ДетальнаяЗапись.ЭтоВладелецКонтактнойИнформации = Истина;
						Представление = ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Представление),
										  ВыборкаДетальныеЗаписи.Представление, ВыборкаДетальныеЗаписи.АдресЭП);
						ДетальнаяЗапись.Представление = Представление;
						
						КоличествоКонтактов = КоличествоКонтактов + 1;
						
					КонецЕсли;
				
				ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
					// Покажем адреса
					Адрес = ВыборкаДетальныеЗаписи.Представление;
					Если ЗначениеЗаполнено(Адрес) Тогда
						
						ДетальнаяЗапись = ДеревоДетальныеЗаписи.Добавить();
						ДетальнаяЗапись.Тип = ВыборкаДетальныеЗаписи.Тип;
						ДетальнаяЗапись.Вид = ВыборкаДетальныеЗаписи.Вид;
						
						// Сразу отметим вид КИ, коотрый указан как "Основной для связи"
						// он будет выводиться "жирным".
						ДетальнаяЗапись.ОсновнойВидДляСвязи = ВыборкаДетальныеЗаписи.ОсновнойВидДляСвязи;
						
						ДетальнаяЗапись.КонтактнаяИнформация = Адрес;
						ДетальнаяЗапись.ЭтоВладелецКонтактнойИнформации = Истина;
						ДетальнаяЗапись.Представление = Адрес;
						
						КоличествоКонтактов = КоличествоКонтактов + 1;
						
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	Возврат ДеревоЗначений;
КонецФункции

&НаКлиенте
Процедура ДеревоПолучитьВсеПомеченные(Дерево, СписокРезультат)
	
	УзлыДерева = Дерево.ПолучитьЭлементы();
	
	Если УзлыДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Узел Из УзлыДерева Цикл
	
		Если Узел.ЭтоВладелецКонтактнойИнформации И Узел.Пометка Тогда
			Родитель = Узел.ПолучитьРодителя();
			КонтактнаяИнформация = ?(ЗначениеЗаполнено(Узел.КонтактнаяИнформация), Узел.КонтактнаяИнформация,
				 Узел.Представление);
			
			СтруктураЗначения = Новый Структура("Контакт, Тип, Вид");
			СтруктураЗначения.Контакт = Родитель.Контакт;
			СтруктураЗначения.Тип = Узел.Тип;
			СтруктураЗначения.Вид = Узел.Вид;
			
			СписокРезультат.Добавить(СтруктураЗначения, КонтактнаяИнформация);
			
		КонецЕсли;
		
		ДеревоПолучитьВсеПомеченные(Узел, СписокРезультат);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Пометка)

	Узлы = ДеревоЗначений.ПолучитьЭлементы();
	Для каждого Узел Из Узлы Цикл
		
		Узел.Пометка = Пометка;
		УзлыКорневыхЭл = Узел.ПолучитьЭлементы();

		Для каждого УзелКорня Из УзлыКорневыхЭл Цикл
		
			УзелКорня.Пометка = Пометка;
		
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
