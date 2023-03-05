Функция ЗаписатьШаблонныеДанныеОбъекта (Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ
	
	UIDОбъекта = ФиксированныеПараметры.UIDОбъекта;
	ХранилищеШаблонныхДанных = ФиксированныеПараметры.ХранилищеШаблонныхДанных;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.UIDОбъекта.Установить(UIDОбъекта);
	
	нЗапись = НаборЗаписей.Добавить();
	нЗапись.UIDОбъекта = UIDОбъекта;
	нЗапись.ХранилищеШаблонныхДанных = ХранилищеШаблонныхДанных;
	
	Попытка
		НаборЗаписей.Записать(Истина);	
		Возврат Истина;
	Исключение
		СообщениеОшибки = ОписаниеОшибки();		
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;		
	КонецПопытки;
	
КонецФункции

Функция ПолучитьШаблонныеДанныеОбъекта(Знач ФиксированныеПараметры,МодифицируемыеПараметры = Неопределено) ЭКСПОРТ
	Если ТипЗнч(МодифицируемыеПараметры) <> Тип("Структура") Тогда
		МодифицируемыеПараметры = новый Структура;
	КонецЕсли;	
	
	UIDОбъекта = ФиксированныеПараметры.UIDОбъекта;
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("UIDОбъекта",UIDОбъекта);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Tester_ШаблонныеДанные.ХранилищеШаблонныхДанных КАК ХранилищеШаблонныхДанных
	               |ИЗ
	               |	РегистрСведений.Tester_ШаблонныеДанные КАК Tester_ШаблонныеДанные
	               |ГДЕ
	               |	Tester_ШаблонныеДанные.UIDОбъекта = &UIDОбъекта";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.ХранилищеШаблонныхДанных;
	КонецЕсли;
	
	Возврат Неопределено;	
КонецФункции