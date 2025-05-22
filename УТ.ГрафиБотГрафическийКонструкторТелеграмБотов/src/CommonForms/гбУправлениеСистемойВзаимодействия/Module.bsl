
#Область ОбработчикиСобытийФормы

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If InfoBaseUsers.CurrentUser().Name = "" Then
		Cancel = True;
		Return;
	EndIf;
	
	If NOT AccessRight("CollaborationSystemInfoBaseRegistration", Metadata) Then
		Cancel = True;
		Return;
	EndIf;
	
	Server = "wss://1cdialog.com:443";
	IBName = Metadata.Synonym;
	If IBName = "" Then
		IBName = Metadata.BriefInformation;
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(СистемаВзаимодействия.ИспользованиеДоступно(),
		Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ОтменаРегистрации,
		Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Регистрация);
		
	ПодключитьОбработчикОжидания("AfterOpen", 0.1, Истина);
EndProcedure

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Оповестить("ИзмененыПараметрыСистемыВзаимодействия", , ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&AtClient
Procedure EMailOnChange(Item)
	
	SetButtonsEnabled();
	
EndProcedure

&AtClient
Procedure IBNameOnChange(Item)
	
	SetButtonsEnabled();
	
EndProcedure

&AtClient
Procedure RegisterCodeOnChange(Item)
	
	SetButtonsEnabled();
	
EndProcedure


&AtClient
Procedure EMailEditTextChange(Item, Text, StandardProcessing)
	
	Items.Register.Enabled = 
		Not IsBlankString(Text) AND
		Not IsBlankString(IBName) AND
		Not IsBlankString(RegisterCode);
		
	Items.GetRegisterCode.Enabled =
		Not IsBlankString(Text) AND
		Not IsBlankString(IBName);
		
EndProcedure

&AtClient
Procedure UnregisterAgreeOnChange(Item)
	
	Items.UnRegister.Enabled = UnregisterAgree;
	Items.ClearInfoBaseRegistrationData.Enabled = UnregisterAgree;
	ClearInfoBaseRegistrationData = UnregisterAgree;
	Items.UnRegister.DefaultButton = True;

EndProcedure


&НаКлиенте
Процедура Use1CServerПриИзменении(Элемент)
	Перем Use1CServer;
	
	Use1CServer = не ЭтаФорма.UseOwnServer;
	Элементы.ServerAddress.Доступность = не Use1CServer;
	
	Элементы.EMail.Видимость = Use1CServer;
	EMail = ?(Use1CServer, "", "mail@mail.ml");
	
	Элементы.GetRegisterCode.Видимость = Use1CServer;
	Элементы.GetRegisterCode.КнопкаПоУмолчанию = Use1CServer;
	
	Элементы.RegisterCode.Видимость = Use1CServer;
	RegisterCode = ?(Use1CServer, "", Format(CurrentDate(), "DF=""yyyyMMddHHmmss"""));

	Элементы.Register.КнопкаПоУмолчанию = не Use1CServer;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&AtClient
Procedure GetRegisterCode(Command)
	
	Params = New CollaborationSystemInfoBaseRegistrationParameters();
	Params.ServerAddress = ?(UseOwnServer, ServerAddress, Server);
	Params.Email = EMail;
	
	NotifyDescr = New NotifyDescription("GetRegisterCodeDone", ThisForm, , "GetRegisterCodeError", ThisForm);
	
	CollaborationSystem.BeginInfoBaseRegistration(NotifyDescr, Params);
	
	ThisForm.Enabled = False;
	
EndProcedure

&AtClient
Procedure Register(Command)
	
	Params = New CollaborationSystemInfoBaseRegistrationParameters();
	Params.ServerAddress = ?(UseOwnServer, ServerAddress, Server);
	Params.Email = EMail;
	Params.InfoBaseName = IBName;
	Params.ActivationCode = TrimAll(RegisterCode);
	
	NotifyDescr = New NotifyDescription("ActivateDone", ThisForm, , "ActivateError", ThisForm);
	
	CollaborationSystem.BeginInfoBaseRegistration(NotifyDescr, Params);
	
	ThisForm.Enabled = False;
	
EndProcedure

&AtClient
Procedure UnRegister(Command)
	
	ClearInfoBaseRegistrationData();

	CollaborationSystem.BeginInfoBaseUnregistration(New NotifyDescription("UnRegisterDone", ThisForm, , "UnRegisterError", ThisForm));
	
	ThisForm.Enabled = False;
	
EndProcedure

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&AtClient
Procedure AfterOpen()
	Если не СистемаВзаимодействия.ИспользованиеДоступно() тогда
		Use1CServerПриИзменении(Неопределено);
	КонецЕсли;
EndProcedure

&AtServer
Procedure ClearInfoBaseRegistrationData()
	
	CollaborationSystem.SetInfoBaseRegistrationData(Undefined);
	РегистрыСведений.гбПараметрыИнтеграцииСистемыВзаимодействия.СоздатьНаборЗаписей().Записать();
	РегистрыСведений.гбПараметрыПользователейСистемыВзаимодействия.СоздатьНаборЗаписей().Записать();

EndProcedure

&AtClient
Procedure SetButtonsEnabled()

	Items.Register.Enabled = 
		Not IsBlankString(EMail) AND
		Not IsBlankString(IBName) AND
		Not IsBlankString(RegisterCode);
	
	Items.GetRegisterCode.Enabled =
		Not IsBlankString(EMail) AND
		Not IsBlankString(IBName);
		
	Items.UnRegister.Enabled = UnregisterAgree;
		
EndProcedure

&AtClient
Procedure GetRegisterCodeDone(Result, MessageText, AdditionalParams) Export

	NotifyDescr = New NotifyDescription("GetRegisterCodeMessageBoxDone", ThisForm);
	ShowMessageBox(NotifyDescr, MessageText);
	
EndProcedure

&AtClient
Procedure GetRegisterCodeMessageBoxDone(AdditionalParams) Export
	
	ThisForm.Enabled = True;
	
	CurrentItem = Items.RegisterCode;
	Items.Register.DefaultButton = True;
	
EndProcedure

&AtClient
Procedure GetRegisterCodeError(ErrorInfo, StandardProcessing, AdditionalParams) Export

	StandardProcessing = False;
	
	ShowErrorInfo(ErrorInfo);
	
	ThisForm.Enabled = True;

EndProcedure

&AtClient
Procedure ActivateDone(Result, MessageText, AdditionalParams) Export

	NotifyDescr = New NotifyDescription("ActivateDoneMessageBoxDone", ThisForm);
	ShowMessageBox(NotifyDescr, NStr("ru = 'Приложение зарегистрировано'; SYS = 'Activate done'", "ru"));
	
EndProcedure

&AtClient
Procedure ActivateDoneMessageBoxDone(AdditionalParams) Export
	
	Close(1);
	
EndProcedure

&AtClient
Procedure UnRegisterDone(AdditionalParams) Export

	NotifyDescr = New NotifyDescription("UnRegisterDoneMessageBoxDone", ThisForm);
	ShowMessageBox(NotifyDescr, NStr("ru = 'Регистрация отменена'; SYS = 'Unregister done'", "ru"));
	
EndProcedure

&AtClient
Procedure UnRegisterDoneMessageBoxDone(AdditionalParams) Export
	
	Close(1);
	
EndProcedure

&AtClient
Procedure UnRegisterError(ErrorInfo, StandardProcessing, AdditionalParams) Export

	StandardProcessing = False;
	ShowErrorInfo(ErrorInfo);

	Close(0);
	
EndProcedure

&AtClient
Procedure ActivateError(ErrorInfo, StandardProcessing, AdditionalParams) Export

	StandardProcessing = False;
	ShowErrorInfo(ErrorInfo);

	ThisForm.Enabled = True;
	
EndProcedure



#КонецОбласти








