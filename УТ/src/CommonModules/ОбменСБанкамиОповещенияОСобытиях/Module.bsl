////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиОповещенияОСобытиях: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Имя оповещения о новых письмах.
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяОповещенияОНовыхПисьмах() Экспорт
	Возврат "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНовыеПисьма";
КонецФункции  

// Имя оповещения о непрочитанных письмах.
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяОповещенияОНепрочитанныхПисьмах() Экспорт
	Возврат "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНепрочитанныеПисьма";
КонецФункции

// Имя оповещения о неотправленных письмах.
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяОповещенияОНеотправленныхПисьмах() Экспорт
	Возврат "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНеотправленныеПисьма";
КонецФункции  

// Доступно серверное оповещение о новых документах.
// 
// Возвращаемое значение:
//  Булево
//
Функция ДоступноСерверноеОповещениеОНовыхДокументах() Экспорт
	Возврат ОбщегоНазначенияБЭД.ДоступныСерверныеОповещения() И ОбменСБанкамиСлужебный.ЕстьПравоОбработкиДокументов();
КонецФункции

#КонецОбласти