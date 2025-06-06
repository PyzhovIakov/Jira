#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбязательныеМетодыПрограмногоИнтерфейса

Функция ПолучитьСообщения(УчетнаяЗапись) Экспорт
	
	СтруктураПараметровДоступа = CRM_РаботаСМессенджерамиСерверПовтИсп.СтруктураПараметровДоступа(УчетнаяЗапись);
	Если СтруктураПараметровДоступа = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	CRM_СообщениеМессенджера.Группа КАК Группа,
	                      |	CRM_СообщениеМессенджера.ID_Сообщения КАК ID_Сообщения,
	                      |	CRM_СообщениеМессенджера.Дата КАК Дата
	                      |ПОМЕСТИТЬ Сообщения
	                      |ИЗ
	                      |	Документ.CRM_СообщениеМессенджера КАК CRM_СообщениеМессенджера
	                      |ГДЕ
	                      |	CRM_СообщениеМессенджера.УчетнаяЗапись = &УчетнаяЗапись
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Сообщения.Группа КАК Группа,
	                      |	МАКСИМУМ(Сообщения.Дата) КАК Дата
	                      |ПОМЕСТИТЬ МаксДаты
	                      |ИЗ
	                      |	Сообщения КАК Сообщения
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Сообщения.Группа
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Сообщения.Группа КАК Группа,
	                      |	МАКСИМУМ(Сообщения.ID_Сообщения) КАК ID_Сообщения
	                      |ИЗ
	                      |	Сообщения КАК Сообщения
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксДаты КАК МаксДаты
	                      |		ПО Сообщения.Группа = МаксДаты.Группа
	                      |			И Сообщения.Дата = МаксДаты.Дата
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Сообщения.Группа");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Выборка = Запрос.Выполнить().Выбрать();
	СоответствиеТоваров = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		СоответствиеТоваров.Вставить(Выборка.Группа, Выборка.ID_Сообщения);
	КонецЦикла;
	СоответствиеТоваровJSON = CRM_РаботаСМессенджерамиСервер.ПолучитьСтрокуJSON(СоответствиеТоваров);
	
	Смещение = 0;
	ВсеПолучены = Ложь;
	
	Пока Не ВсеПолучены Цикл
		КодЗапроса = ПолучитьМакет("МетодПолученияКомментариев").ПолучитьТекст();
		КодЗапроса = СтрЗаменить(КодЗапроса, "&group_id", "-" + СтруктураПараметровДоступа.IDГруппы);
		КодЗапроса = СтрЗаменить(КодЗапроса, "&offset", Формат(Смещение, "ЧН=; ЧГ="));
		КодЗапроса = СтрЗаменить(КодЗапроса, "&last_comments", СоответствиеТоваровJSON);
		Ресурс = "/method/execute?v=5.131&access_token=" + СтруктураПараметровДоступа.Токен;
		СтрЗапрос = "code=" + КодЗапроса;
		
		МассивСообщений = Новый Массив;
		СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(CRM_РаботаСМессенджерамиСервер.ВыполнитьЗапрос("api.vk.com",
			 СтрЗапрос,
			Ресурс, СтруктураПараметровДоступа.ПараметрыПрокси, "x-www-form-urlencoded"));
		Если СтруктураОтвета.Свойство("error") Тогда
			ВызватьИсключение СтруктураОтвета.error.error_msg;
		ИначеЕсли СтруктураОтвета.response.count > 0 Тогда
			Для каждого КомментарииПоТовару Из СтруктураОтвета.response.commentsByItem Цикл
				id_Товара = Формат(КомментарииПоТовару.item, "ЧГ=");
				title_Товара = Формат(КомментарииПоТовару.title, "ЧГ=");
				ПрофилиКоментаторов = Новый Соответствие;
				Для каждого Профиль Из КомментарииПоТовару.profiles Цикл
					ПрофилиКоментаторов.Вставить(Формат(Профиль.id, "ЧГ="), Профиль.first_name + " " + Профиль.last_name);
				КонецЦикла;
				Для каждого Комментарий Из КомментарииПоТовару.comments Цикл
					id_Комментария = Формат(Комментарий.id, "ЧГ=");
					Если СоответствиеТоваров.Получить(id_Комментария) <> Неопределено Тогда
						Продолжить;
					КонецЕсли;
					Если Комментарий.from_id > 0 Тогда
						user_id = Формат(Комментарий.from_id, "ЧГ=");
						ВидСообщения = "Входящее";
					ИначеЕсли Комментарий.Свойство("reply_to_user") Тогда
						user_id = Формат(Комментарий.reply_to_user, "ЧГ=");
						ВидСообщения = "Исходящее";
					Иначе
						Продолжить;
					КонецЕсли;
					Контакт = CRM_РаботаСМессенджерамиСерверПовтИсп.НайтиКонтактПоКонтактнойИнформации(ПредставлениеКонтактнойИнформацииПользователя(user_id),
						 УчетнаяЗапись,
						 Перечисления.ТипыКонтактнойИнформации.ВебСтраница);
					ИмяПользователя = ПрофилиКоментаторов.Получить(user_id);
					Сообщение = CRM_РаботаСМессенджерамиСервер.СтруктураСообщенияМесенджера();
					Сообщение.Дата = МестноеВремя(Дата(1970, 1, 1) + Комментарий.date);
					Сообщение.ID_Сообщения = id_Комментария;
					Сообщение.ТекстСообщения = Комментарий.text;
					Сообщение.ВидСообщения = ВидСообщения;
					Сообщение.Контакт = Контакт;
					Сообщение.ID_Пользователя = user_id;
					Сообщение.КонтактПредставление = ИмяПользователя;
					Сообщение.Группа = id_Товара;
					Сообщение.ГруппаПредставление = title_Товара;
					Если Комментарий.Свойство("attachments") Тогда
						КаталогВременныхФайлов = КаталогВременныхФайлов();
						Для каждого Вложение Из Комментарий.attachments Цикл
							Если Вложение.type = "doc" Тогда
								ПутьКФайлу = Вложение.doc.url;
								ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
								CRM_ПолучитьФайл("vk.com", СтрЗаменить(ПутьКФайлу, "https://vk.com", ""), ИмяВременногоФайла,
									СтруктураПараметровДоступа.ПараметрыПрокси);
								Данные = Новый ДвоичныеДанные(ИмяВременногоФайла);
								АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(Данные);
								ПараметрыФайла = Новый Структура;
								ПараметрыФайла.Вставить("ВладелецФайлов", Неопределено);
								ПараметрыФайла.Вставить("Автор", Неопределено);
								ПараметрыФайла.Вставить("ИмяБезРасширения", Лев(Вложение.doc.title, СтрНайти(Вложение.doc.title, ".") - 1));
								ПараметрыФайла.Вставить("РасширениеБезТочки", Вложение.doc.ext);
								ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
								ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
								ПараметрыФайла.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
								Сообщение.Вложения.Добавить(ПараметрыФайла);
								Попытка
									УдалитьФайлы(ИмяВременногоФайла);
								Исключение
									ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление файла'", ОбщегоНазначения.КодОсновногоЯзыка()),
										УровеньЖурналаРегистрации.Информация,
										,
										,
										ИнформацияОбОшибке().Описание);
								КонецПопытки;
							ИначеЕсли Вложение.type = "photo" Тогда
								ТекРазмер = 0;
								ПутьКФайлу = "";
								Для каждого Размер Из Вложение.photo.sizes Цикл
									Если Размер.width > ТекРазмер Тогда
										ПутьКФайлу = Размер.url;
									КонецЕсли;
								КонецЦикла;
								Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
									МассивПодстрок = СтрРазделить(ПутьКФайлу, "/", Ложь);
									ИмяФайла = МассивПодстрок[МассивПодстрок.Количество() - 1];
									Если СтрНайти(ИмяФайла, "?") > 1 Тогда
										ИмяФайла = Лев(ИмяФайла, СтрНайти(ИмяФайла, "?") - 1);
									КонецЕсли;
									КопироватьФайл(ПутьКФайлу, КаталогВременныхФайлов + ИмяФайла);
									Данные = Новый ДвоичныеДанные(КаталогВременныхФайлов + ИмяФайла);
									АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(Данные);
									ПараметрыФайла = Новый Структура;
									ПараметрыФайла.Вставить("ВладелецФайлов", Неопределено);
									ПараметрыФайла.Вставить("Автор", Неопределено);
									ПараметрыФайла.Вставить("ИмяБезРасширения", Лев(ИмяФайла, СтрНайти(ИмяФайла, ".") - 1));
									ПараметрыФайла.Вставить("РасширениеБезТочки", Сред(ИмяФайла, СтрНайти(ИмяФайла, ".") + 1));
									ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
									ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
									ПараметрыФайла.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
									Сообщение.Вложения.Добавить(ПараметрыФайла);
									Попытка
										УдалитьФайлы(КаталогВременныхФайлов + ИмяФайла);
									Исключение
										ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление файла'", ОбщегоНазначения.КодОсновногоЯзыка()),
											УровеньЖурналаРегистрации.Информация,
											,
											,
											ИнформацияОбОшибке().Описание);
									КонецПопытки;
								КонецЕсли;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
					МассивСообщений.Добавить(Сообщение);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		Если СтруктураОтвета.response.last Тогда
			ВсеПолучены = Истина;
		Иначе
			Смещение = Смещение + 20;
		КонецЕсли;
	
	КонецЦикла;

	Возврат МассивСообщений;
	
КонецФункции

Функция ОтправитьСообщение(Сообщение, УчетнаяЗапись, IDПользователя, СписокФайлов, ДопПараметры) Экспорт
	
	Возврат CRM_ЛицензированиеЭкспортныеМетоды.ПолучитьЗащищеннуюОбработку().ОтправитьСообщениеМессенджера(Сообщение,
		 УчетнаяЗапись, IDПользователя, СписокФайлов,
		 ДопПараметры);

КонецФункции

Процедура ОжиданиеСобытий(УчетнаяЗапись) Экспорт
	
КонецПроцедуры

Функция ПолучитьВидКИМессенджера(Контакт) Экспорт
	
	Наименование = "ВКонтакте";
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВидыКонтактнойИнформации.Ссылка КАК Ссылка,
	                      |	ВидыКонтактнойИнформации.ПометкаУдаления КАК ПометкаУдаления
	                      |ИЗ
	                      |	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	                      |ГДЕ
	                      |	ВидыКонтактнойИнформации.Наименование = &Наименование
	                      |	И ВидыКонтактнойИнформации.Тип = &Тип
	                      |	И ВидыКонтактнойИнформации.Родитель = &Родитель");
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Партнеры") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПартнеры;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.CRM_ПотенциальныеКлиенты") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникCRM_ПотенциальныеКлиенты;
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.Пользователи") Тогда
		Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПользователи;
	КонецЕсли;
	
	ТипКИ = ТипКИМессенджера();
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Тип", ТипКИ);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ПометкаУдаления Тогда
			Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		Возврат Выборка.Ссылка;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НовыйВидКИ = Справочники.ВидыКонтактнойИнформации.СоздатьЭлемент();
		НовыйВидКИ.Родитель = Родитель;
		НовыйВидКИ.Наименование = Наименование;
		НовыйВидКИ.Тип = ТипКИ;
		НовыйВидКИ.Используется = Истина;
		НовыйВидКИ.ВидРедактирования = "Диалог";
		НовыйВидКИ.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		Возврат НовыйВидКИ.Ссылка;
	КонецЕсли;
	
КонецФункции

Функция ТипКИМессенджера() Экспорт
	
	Возврат Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
	
КонецФункции

Функция НачалоАдресаСтраницыПользователя() Экспорт
	Возврат "https://vk.com/id";
КонецФункции

Функция ПутьКДиалогуВБраузере(Структура) Экспорт
	Возврат "https://vk.com/gim" + Структура.Группа + "?sel=" + Структура.ID_Пользователя;
КонецФункции

Функция ПредставлениеКонтактнойИнформацииПользователя(ID_Пользователя) Экспорт
	Возврат НачалоАдресаСтраницыПользователя() + ID_Пользователя;
КонецФункции

Функция ВозможноИзменениеСообщений() Экспорт
	Возврат Ложь; 
КонецФункции

Функция ИспользуютсяВложения() Экспорт
	Возврат Истина; 
КонецФункции

Функция HTMLКонтекста(УчетнаяЗапись, idПользователя, idГруппы) Экспорт
	HTML = Неопределено;
	Если УчетнаяЗапись.Включена Тогда
		СтруктураПараметровДоступа = CRM_РаботаСМессенджерамиСерверПовтИсп.СтруктураПараметровДоступа(УчетнаяЗапись);
		Ресурс = "/method/market.getById?v=5.131&item_ids=-" + СтруктураПараметровДоступа.IDГруппы + "_" 
			+ idГруппы + "&access_token=" 
			+ СтруктураПараметровДоступа.Токен;
		СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(CRM_РаботаСМессенджерамиСервер.ВыполнитьЗапрос("api.vk.com",
			 "", Ресурс,
			 СтруктураПараметровДоступа.ПараметрыПрокси));
		Если СтруктураОтвета.Свойство("error") Тогда
			ВызватьИсключение СтруктураОтвета.error.error_msg;
		ИначеЕсли СтруктураОтвета.response.Свойство("items") И СтруктураОтвета.response.items.Количество() > 0 Тогда
			HTML = ПолучитьМакет("HTML_МакетКонтекста").ПолучитьТекст();
			HTML = СтрЗаменить(HTML, "media_url", СтруктураОтвета.response.items[0].thumb_photo);
			HTML = СтрЗаменить(HTML, "permalink", "https://vk.com/public" + СтруктураПараметровДоступа.IDГруппы + "?w=product-" + СтруктураПараметровДоступа.IDГруппы 
				+ "_" 
				+ idГруппы);
			HTML = СтрЗаменить(HTML, "caption", СтруктураОтвета.response.items[0].description);
			HTML = СтрЗаменить(HTML, "price", СтруктураОтвета.response.items[0].price.text);
			HTML = СтрЗаменить(HTML, "sku", ?(СтруктураОтвета.response.items[0].Свойство("sku"),
				 СтруктураОтвета.response.items[0].sku,
				 ""));
		КонецЕсли;
	КонецЕсли;
	Возврат HTML;
КонецФункции

Функция Отключиться(СтруктураПараметровДоступа) Экспорт
	Возврат Истина;
КонецФункции

Процедура ПометитьКакПрочтенные(УчетнаяЗапись, МассивСообщений) Экспорт
	
КонецПроцедуры

Функция ПользовательДоступен(УчетнаяЗапись, ДополнительныеДанные) Экспорт
	
	Возврат Новый Структура("Доступен, Описание", Ложь, "");
	
КонецФункции

Функция ПараметрыМессенджера() Экспорт
	
	ПараметрыМессенджера = CRM_РаботаСМессенджерамиСервер.СтруктураПараметровМессенджера();
	
	Возврат ПараметрыМессенджера;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеМетоды

Функция ПолучитьСписокГруппПользователя(Токен, ПараметрыПрокси) Экспорт
	Ресурс = "/method/groups.get?v=5.131&extended=1&filter=admin&access_token=" + Токен;
	СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(CRM_РаботаСМессенджерамиСервер.ВыполнитьЗапрос("api.vk.com",
		 "", Ресурс,
		 ПараметрыПрокси));
	Если СтруктураОтвета.Свойство("error") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураОтвета.error.error_msg);
	Иначе
		СписокГрупп = Новый СписокЗначений;
		Для каждого Группа Из СтруктураОтвета.response.items Цикл
			СписокГрупп.Добавить(Формат(Группа.id, "ЧГ="), Группа.name);
		КонецЦикла;
		Возврат СписокГрупп;
	КонецЕсли;
КонецФункции

Процедура CRM_ПолучитьФайл(Сервер, Ресурс, ИмяФайла, Прокси) Экспорт  
	
	Если Прокси <> Неопределено Тогда
		HTTPПрокси = Новый ИнтернетПрокси;	
		HTTPПрокси.Установить("https", Прокси.Сервер, Прокси.Порт, Прокси.Пользователь, Прокси.Пароль, Ложь); 
	Иначе
		HTTPПрокси = Неопределено;
	КонецЕсли;
	HTTP =  Новый HTTPСоединение(Сервер, , , , HTTPПрокси, 20, Новый ЗащищенноеСоединениеOpenSSL);
	
	HTTPОтвет = HTTP.Получить(Ресурс, ИмяФайла);
	ПутьКФайлу = HTTPОтвет.Заголовки.Получить("Location");
	Если ПутьКФайлу <> Неопределено Тогда
		КопироватьФайл(ПутьКФайлу, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеГруппы(Токен, ПараметрыПрокси) Экспорт
	Ресурс = "/method/users.get?v=5.131&fields=id,name&access_token=" + Токен;
	СтруктураОтвета = CRM_РаботаСМессенджерамиСервер.ПолучитьЗначениеИзОтветаJSON(CRM_РаботаСМессенджерамиСервер.ВыполнитьЗапрос("api.vk.com",
		 "", Ресурс,
		 ПараметрыПрокси));
	Если СтруктураОтвета.Свойство("error") Тогда
		ВызватьИсключение СтруктураОтвета.error.error_msg;
	Иначе
		Для каждого Пользователь Из СтруктураОтвета.response Цикл
			Возврат Пользователь.first_name + " " + Пользователь.last_name;
		КонецЦикла;
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
