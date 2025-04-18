
////////////////////////////////////////////////////////////////////////////////
// Бизнес-процессы экспортные методы
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает структура с исходящей точкой.
//
// Параметры:
//  ТочкаМаршрута	 - ТочкаМаршрута - Точка маршрута для получения.
//  Версия			 - Число - Номер версии.
//  Вариант			 - Число - Индекс точки маршрута. 
// 
// Возвращаемое значение:
//  Структура, Неопределено - Структура с исходящей точкой
//
Функция ПолучитьИсходящуюТочку(ТочкаМаршрута, Версия, Вариант = 0) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьИсходящуюТочку(ТочкаМаршрута, Версия, Вариант);
КонецФункции

// Функция возвращает массив структур с точками маршрута, являющимися следующими относительно переданной точки маршрута.
//
// Параметры:
//  БизнесПроцесс				 - БизнесПроцессСсылка - Ссылка на текущий бизнес-процесс.
//  НачальнаяТочка				 - ТочкаМаршрута	 - Ссылка на точку маршрута, от которой начали следующие точки.
//  ТекущаяТочка				 - ТочкаМаршрута	 - Ссылка на текущую точку маршрута.
//  Маршрут						 - ТаблицаЗначений	 - Таблица значений с маршрутом бизнес-процесса.
//  ВариантВыполнения			 - Число	 - Число, вариант выполнения для точек условия или выбора варианта.
//  ТочкаВеткиРазделения		 - Структура - Структура с первой точкой ветки разделения.
//  ИспользоватьОбработчикиТочек - Булево - Использование обработчики точек маршрута.
// 
// Возвращаемое значение:
//  Результат - массив структур с исходящими точками маршрута.
//
Функция ПолучитьСледующиеТочкиМаршрута(БизнесПроцесс, НачальнаяТочка, ТекущаяТочка = Неопределено,
	 Маршрут = Неопределено, ВариантВыполнения = 0, ТочкаВеткиРазделения = Неопределено,
	 ИспользоватьОбработчикиТочек = Ложь) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьСледующиеТочкиМаршрута(БизнесПроцесс,
		 НачальнаяТочка, ТекущаяТочка, Маршрут, ВариантВыполнения, ТочкаВеткиРазделения,
		 ИспользоватьОбработчикиТочек);
КонецФункции

// Функция возвращает массив структур с исходящими точками.
//
// Параметры:
//  ТочкаМаршрута	 - ТочкаМаршрута - Точка маршрута для получения.
//  Версия			 - Число - Номер версии.
// 
// Возвращаемое значение:
//  Массив - Массив структур с исходящими точками.
//
Функция ПолучитьИсходящиеТочки(ТочкаМаршрута, Версия) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьИсходящиеТочки(ТочкаМаршрута, Версия);
КонецФункции

// Функция возвращает список значений с точками старта бизнес-процесса.
//
// Параметры:
//	КартаМаршрута	- СправочникСсылка	- Карта маршрута.
// 
// Возвращаемое значение:
//  СписокЗначений - Список значений с точками старта. 
//
Функция ПолучитьВариантыСтарта(КартаМаршрута) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьВариантыСтарта(КартаМаршрута);
КонецФункции

// Процедура устанвливает пометку удаления для точек, у которых нет ни входящих,
// ни исходящих точек, иными словами - не участвуют ни в одной версии карт маршрута.
//
// Параметры:
//	КартаМаршрута	- СправочникСсылка	- Карта маршрута.
//
Процедура УстановитьПометкуУдаленияНеАктуальныхТочек(КартаМаршрута) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.УстановитьПометкуУдаленияНеАктуальныхТочек(КартаМаршрута);
КонецПроцедуры

// Процедура формирует точки маршрута.
//
// Параметры:
//	ТабТочекМаршрута    - ТаблицаЗначений	- Таблица точек маршрута.
//	КартаМаршрута		- СправочникСсылка - Карта маршрута.
//	НомерНовойВерсии	- Число				- Номер новой версии.
//
Процедура СформироватьТочкиМаршрута(ТабТочекМаршрута, КартаМаршрута, НомерНовойВерсии) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.СформироватьТочкиМаршрута(ТабТочекМаршрута, КартаМаршрута, НомерНовойВерсии);
КонецПроцедуры

// Функция возвращает массив структур с входящими точками.
//
// Параметры:
//  ТочкаМаршрута	 - ТочкаМаршрута - Точка маршрута для получения.
//  Версия			 - Число - Номер версии. 
// 
// Возвращаемое значение:
//  Массив - Массив структур.
//
Функция ПолучитьВходящиеТочки(ТочкаМаршрута, Версия) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьВходящиеТочки(ТочкаМаршрута, Версия);
КонецФункции

// Функция читает графическую схему дерева точек.
//
// Параметры:
//  СхемаМаршрута		 - Файл	 - Схема маршрута.
//  ПутьКВременномуФайлу - Строка - Путь к временному файлу.
// 
// Возвращаемое значение:
//  Структура - Структура графической схемы.
//
Функция ПрочитатьГрафическуюСхемуСформироватьДеревоТочек(СхемаМаршрута, ПутьКВременномуФайлу) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПрочитатьГрафическуюСхемуСформироватьДеревоТочек(СхемаМаршрута,
		 ПутьКВременномуФайлу);
КонецФункции

// Процедура устанавливает признак "Не актуальна для точек, которые не задействованы в текущей версии".
//
//
// Параметры:
//	КартаМаршрута		- СправочникСсылка	- Карта маршрута.
//	КартаМаршрутаВерсия	- Число	- Номер версии карты маршрута.
//
Процедура УстановитьАктуальностьТочекОтносительноПоследнейВерсии(КартаМаршрута, КартаМаршрутаВерсия) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.УстановитьАктуальностьТочекОтносительноПоследнейВерсии(КартаМаршрута,
		 КартаМаршрутаВерсия);
КонецПроцедуры

// Функция возвращает максимальное значение даты из колонки срок в ТЧ "Исполнители" бизнес-процесса или сделки.
//
// Параметры:
//  Исполнители	 - СправочникСсылка - Исполнители бизнес процесса или сделки.
// 
// Возвращаемое значение:
//  Дата - Значение даты.
//
Функция ПолучитьМаксимальнуюДатуИзКолонкиСрокБизнесПроцесса(Исполнители) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьМаксимальнуюДатуИзКолонкиСрокБизнесПроцесса(Исполнители);
КонецФункции

// Процедура очищает входящие и исходящие точки.
//
// Параметры:
//	КартаМаршрута		- СправочникСсылка	- Карта маршрута.
//	НомерНовойВерсии	- Число	- Номер новой версии.
//
Процедура ОчиститьВходящиеИсходящиеТочки(КартаМаршрута, НомерНовойВерсии) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.ОчиститьВходящиеИсходящиеТочки(КартаМаршрута, НомерНовойВерсии);
КонецПроцедуры

// Процедура прописывает какой ветке принадлит точка маршрута и какой точкой слияния оканчивается ветка.
//
// Параметры:
//	КартаМаршрута		 - СправочникСсылка	- Карта маршрута.
//  КартаМаршрутаВерсия	 - Число - Номер версии карты маршрута.
//
Процедура УстановитьПринадлежностьТочекВеткамРазделения(КартаМаршрута, КартаМаршрутаВерсия) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.УстановитьПринадлежностьТочекВеткамРазделения(КартаМаршрута, КартаМаршрутаВерсия);
КонецПроцедуры

// Процедура проверяет наличие точек разделения и прописывает связь в ТЧ точки.
//
// Параметры:
//	КартаМаршрута		 - СправочникСсылка	- Карта маршрута.
//  КартаМаршрутаВерсия	 - Число - Номер версии карты маршрута. 
//
Процедура УстановитьСвязьТочекРазделенияСоСлияниями(КартаМаршрута, КартаМаршрутаВерсия) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.УстановитьСвязьТочекРазделенияСоСлияниями(КартаМаршрута, КартаМаршрутаВерсия);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает точку слияния для точки разделения.
//
Функция ПолучитьТочкуСлияния(ТочкаМаршрута, Знач НомерВерсии, ТаблицаПройденныхТочек = Неопределено) Экспорт
	Возврат CRM_БизнесПроцессыОбщегоНазначения.ПолучитьТочкуСлияния(ТочкаМаршрута, НомерВерсии, ТаблицаПройденныхТочек);
КонецФункции

// Процедура читает маршрут бизнес-процесса.
//
Процедура ПрочитатьМаршрутБизнесПроцесса(БизнесПроцесс, Маршрут = Неопределено) Экспорт
	CRM_БизнесПроцессыОбщегоНазначения.ПрочитатьМаршрутБизнесПроцесса(БизнесПроцесс, Маршрут);
КонецПроцедуры

#КонецОбласти
