#Область ПрограммныйИнтерфейс

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// 
// см. ПользователиПереопределяемый.ПриОпределенииНазначенияРолей
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	//++ Локализация
	#Область РолиСовместногоИспользованияДляВнешнихПользователейИПользователей
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.БазовыеПраваЭД.Имя);
	#КонецОбласти
	
	#Область БиблиотечныеРоли	

	
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриОпределенииНазначенияРолей(НазначениеРолей);
	// Конец ИнтернетПоддержкаПользователей
	
	// БРО


	#КонецОбласти
	//-- Локализация
	
		
КонецПроцедуры

#КонецОбласти
