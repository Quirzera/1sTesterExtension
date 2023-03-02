
#Область СозданиеШаблонныхДанных 
Функция ЕстьНеПредопределенныеЗаписиВТаблице(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	ИмяТаблицы = ФиксированныеПараметры.ИмяТаблицы; 
	МогутБытьПредопределенные = ФиксированныеПараметры.МогутБытьПредопределенные;
	
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПроверяемаяТаблица.*
				   |ИЗ
	               |	&ИмяТаблицы КАК ПроверяемаяТаблица
	               |ГДЕ
	               |	&ПроверкаПредопределенных";
	
	ПроверкаПредопределенных = ?(МогутБытьПредопределенные,"ПроверяемаяТаблица.ИмяПредопределенныхДанных = """" ","ИСТИНА");
	
	СтруктураЗаменяемыхПараметровЗапроса = новый Структура;
	СтруктураЗаменяемыхПараметровЗапроса.Вставить("ИмяТаблицы",ИмяТаблицы);
	СтруктураЗаменяемыхПараметровЗапроса.Вставить("ПроверкаПредопределенных",ПроверкаПредопределенных);
	
	
	РезультатЗапроса = КиурСрв.ПолучитьРезультатПроизвольногоТекстаЗапроса(ТекстЗапроса,,СтруктураЗаменяемыхПараметровЗапроса);
	
	Возврат НЕ РезультатЗапроса.Пустой();
КонецФункции
 
Функция ПолученаСтандартнаяСхемаВыгрузкиШаблонныхДанных(Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ
	
	ШаблонСхемыВыгрузки = МодифицируемыеПараметры.ШаблонСхемыВыгрузки;
	
	ВеткиОсновныхТаблиц = ШаблонСхемыВыгрузки.ПолучитьЭлементы();
	ВеткиОсновныхТаблиц.Очистить();
	
	ИзменяемыеПараметры = новый Структура;
	
	Если НЕ ПолучитьТаблицы_БД_ДляРаботы_с_ШаблоннымиДанными(новый ФиксированнаяСтруктура,ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		СообщениеОшибки = "Не удалось получить структуру таблиц БД, по причине:" + Символы.ПС + СообщениеОшибки;
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	ТаблицыБД = ИзменяемыеПараметры.ТаблицыБД;
	
	ТаблицыБД = ТаблицыБД.Скопировать(,"ИмяТаблицы, Назначение, ТипМетаданных");
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("ТаблицыБД",ТаблицыБД);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицыБД.ТипМетаданных КАК ТипМетаданных,
	               |	ВЫРАЗИТЬ(ТаблицыБД.ИмяТаблицы КАК СТРОКА(150)) КАК ИмяТаблицы,
	               |	ВЫРАЗИТЬ(ТаблицыБД.Назначение КАК СТРОКА(15)) КАК Назначение
	               |ПОМЕСТИТЬ втТаблицыБД
	               |ИЗ
	               |	&ТаблицыБД КАК ТаблицыБД
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	втТаблицыБД.ТипМетаданных КАК ТипМетаданных,
	               |	втТаблицыБД.ИмяТаблицы КАК ИмяТаблицы,
	               |	втТаблицыБД.Назначение КАК Назначение
	               |ИЗ
	               |	втТаблицыБД КАК втТаблицыБД
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТипМетаданных,
	               |	ИмяТаблицы,
	               |	Назначение
	               |ИТОГИ ПО
	               |	ТипМетаданных";
	ДеревоСхемы = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	СписокИсключенийДляДокументов = новый СписокЗначений;
	СписокИсключенийДляДокументов.Добавить("Ссылка");
	СписокИсключенийДляДокументов.Добавить("Дата");
	СписокИсключенийДляДокументов.Добавить("ВерсияДанных");
	СписокИсключенийДляДокументов.Добавить("МоментВремени");	
	
	СписокИсключенийДляТабличныхЧастейДокументов = новый СписокЗначений;
	СписокИсключенийДляТабличныхЧастейДокументов.Добавить("Ссылка");     
	СписокИсключенийДляТабличныхЧастейДокументов.Добавить("НомерСтроки");
	
	
	СписокИсключенийДляСправочников = новый СписокЗначений;
	СписокИсключенийДляСправочников.Добавить("Ссылка");
	СписокИсключенийДляСправочников.Добавить("ВерсияДанных");
	
	СписокИсключенийДляТабличныхЧастейСправочников = новый СписокЗначений;
	СписокИсключенийДляТабличныхЧастейСправочников.Добавить("Ссылка");
	СписокИсключенийДляТабличныхЧастейСправочников.Добавить("НомерСтроки");
	
	Для каждого ВеткаТипа из ДеревоСхемы.Строки Цикл
		нВеткаТипа = ВеткиОсновныхТаблиц.Добавить();
		нВеткаТипа.ТипМетаданных = ВеткаТипа.ТипМетаданных; 
		
		Для каждого ЛистТаблиц из ВеткаТипа.Строки Цикл
			
			Если СокрЛП(ЛистТаблиц.Назначение) = "Основная" Тогда
				нВеткаОсновнойТаблицы = нВеткаТипа.ПолучитьЭлементы().Добавить();
				нВеткаОсновнойТаблицы.ИмяОсновнойТаблицы = СокрЛП(ЛистТаблиц.ИмяТаблицы); 
				
				ИменаКолонокИсключений = Неопределено;
				Если нВеткаТипа.ТипМетаданных = "Документ" Тогда				
					ИменаКолонокИсключений = СписокИсключенийДляДокументов;
				ИначеЕсли нВеткаТипа.ТипМетаданных = "Справочник" Тогда
					ИменаКолонокИсключений = СписокИсключенийДляСправочников;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ИменаКолонокИсключений) Тогда				
					нВеткаОсновнойТаблицы.ИменаКолонокИсключений = ИменаКолонокИсключений;
				КонецЕсли;	
					
			ИначеЕсли СокрЛП(ЛистТаблиц.Назначение) = "ТабличнаяЧасть" Тогда
				нВеткиТабличныхЧастей = нВеткаОсновнойТаблицы.ПолучитьЭлементы().Добавить();
				нВеткиТабличныхЧастей.ИмяОсновнойТаблицы = нВеткаОсновнойТаблицы.ИмяОсновнойТаблицы;
				нВеткиТабличныхЧастей.ИмяТаблицыТабличнойЧасти = СокрЛП(ЛистТаблиц.ИмяТаблицы);
				
				ИменаКолонокИсключений = Неопределено;
				Если нВеткаТипа.ТипМетаданных = "Документ" Тогда				
					ИменаКолонокИсключений = СписокИсключенийДляТабличныхЧастейДокументов;
				ИначеЕсли нВеткаТипа.ТипМетаданных = "Справочник" Тогда
					ИменаКолонокИсключений = СписокИсключенийДляТабличныхЧастейСправочников;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ИменаКолонокИсключений) Тогда				
					нВеткиТабличныхЧастей.ИменаКолонокИсключений = ИменаКолонокИсключений;
				КонецЕсли;			
				
			КонецЕсли;				
		КонецЦикла;			
	КонецЦикла;	
	
	МодифицируемыеПараметры.Вставить("ШаблонСхемыВыгрузки",ШаблонСхемыВыгрузки);
	
	Возврат Истина;	
КонецФункции

Функция ПолучитьТаблицы_БД_ДляРаботы_с_ШаблоннымиДанными(Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ
	
	ТаблицыБД = ПолучитьСтруктуруХраненияБазыДанных(,Истина);
		
	КвалСтроки = новый КвалификаторыСтроки(35);
	ТаблицыБД.Колонки.Добавить("ТипМетаданных",новый ОписаниеТипов("Строка",,,,КвалСтроки));
		
	ИндексОбхода = ТаблицыБД.Количество() - 1;
	
	Пока ИндексОбхода >= 0 Цикл
		стр = ТаблицыБД[ИндексОбхода];
		ИмяТаблицы = стр.ИмяТаблицы;
		
		Если ЭтоСлужебнаяТаблицаРасширенияTester(ИмяТаблицы) Тогда
			ТаблицыБД.Удалить(стр);
			ИндексОбхода = ИндексОбхода - 1;
			Продолжить;			
		КонецЕсли;	
		
		Если НЕ((НЕ СтрНачинаетсяС(ИмяТаблицы,"Документ") И НЕ СтрНачинаетсяС(ИмяТаблицы,"Справочник"))
				И (НЕ СтрНачинаетсяС(ИмяТаблицы,"РегистрСведений") И НЕ СтрНачинаетсяС(ИмяТаблицы,"РегистрНакопления"))) Тогда
				
			СоставСтроки = СтрРазделить(ИмяТаблицы,".",Ложь);
			стр.ТипМетаданных = СоставСтроки[0];	
	       	ИндексОбхода = ИндексОбхода - 1;
			Продолжить;
		КонецЕсли;	
		
		ТаблицыБД.Удалить(стр);
		ИндексОбхода = ИндексОбхода - 1;
	КонецЦикла;
	
	МодифицируемыеПараметры.Вставить("ТаблицыБД",ТаблицыБД);
	
	Возврат Истина;	
КонецФункции

Функция ЭтоСлужебнаяТаблицаРасширенияTester(Знач ИмяТаблицы) ЭКСПОРТ 
	Возврат НЕ (СтрНайти(ИмяТаблицы,"Tester_") = 0 И СтрНайти(ИмяТаблицы,"Kiur_") = 0);
КонецФункции	

Функция ПолучитьСодержимоеТабличнойЧастиТаблицыБД(Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ 
	ИмяОсновнойТаблицы = ФиксированныеПараметры.ИмяОсновнойТаблицы;
	ИмяТаблицыТабличнойЧасти = ФиксированныеПараметры.ИмяТаблицыТабличнойЧасти;
	ИменаКолонокИсключений = ФиксированныеПараметры.ИменаКолонокИсключений;
	ТипМетаданных = ФиксированныеПараметры.ТипМетаданных;
	
	Текст_ЗапросаИменКолонокТаблицы = "ВЫБРАТЬ ПЕРВЫЕ 1
	 	              					|	ТабличнаяЧасть.*
					   					|ИЗ
	 	              					|	&ИмяТаблицыТабличнойЧасти КАК ТабличнаяЧасть";
	
	СтруктураЗаменяемыхПараметровЗапроса = новый Структура;
	СтруктураЗаменяемыхПараметровЗапроса.Вставить("ИмяТаблицыТабличнойЧасти",ИмяТаблицыТабличнойЧасти);
	
	РезультатЗапросаИменКолонок = КиурСрв.ПолучитьРезультатПроизвольногоТекстаЗапроса(Текст_ЗапросаИменКолонокТаблицы,,СтруктураЗаменяемыхПараметровЗапроса);
	ТаблицаЗначенийЗапросаКолонок = РезультатЗапросаИменКолонок.Выгрузить();
	
	МассивИменКолонокИтоговойТаблицы = новый Массив;
	МассивИменИсключений = ИменаКолонокИсключений.ВыгрузитьЗначения(); 
	 
	Для каждого Колонка из ТаблицаЗначенийЗапросаКолонок.Колонки Цикл
		Если МассивИменИсключений.Найти(Колонка.Имя) = Неопределено И МассивИменКолонокИтоговойТаблицы.Найти(Колонка.Имя) = Неопределено Тогда
			МассивИменКолонокИтоговойТаблицы.Добавить(Колонка.Имя);	
		КонецЕсли;		
	КонецЦикла;
	
	Текст_ЗапросаИтоговойТаблицы = "ВЫБРАТЬ";	
	
	ДобавкаЗапроса = "";
	Если ТипМетаданных = "Документ" Тогда
		ДобавкаЗапроса = "	ОсновнаяТаблица.Номер КАК НомерДокумента,";		
	ИначеЕсли ТипМетаданных = "Справочник" Тогда
		ДобавкаЗапроса = "	ОсновнаяТаблица.Код КАК КодЭлемента,";
		ДобавкаЗапроса = ДобавкаЗапроса + Символы.ПС + "	ОсновнаяТаблица.Наименование КАК НаименованиеЭлемента,";
	КонецЕсли;

	Если НЕ ПустаяСтрока(ДобавкаЗапроса) Тогда
		Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + ДобавкаЗапроса;
	КонецЕсли;
	
	ИндексПоследнегоЭлемента = МассивИменКолонокИтоговойТаблицы.ВГраница();
	
	Для ИндексЭлемента = 0 По ИндексПоследнегоЭлемента Цикл   
		НужнаЗапятая = (ИндексЭлемента <> ИндексПоследнегоЭлемента);
		Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "	ТабличнаяЧасть." + МассивИменКолонокИтоговойТаблицы.Получить(ИндексЭлемента) + ?(НужнаЗапятая,",","");
	КонецЦикла;
	
	Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "ИЗ" + Символы.ПС + "	" + ИмяТаблицыТабличнойЧасти + " КАК ТабличнаяЧасть";	
	
	Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "	ВНУТРЕННЕЕ СОЕДИНЕНИЕ " + ИмяОсновнойТаблицы + " КАК ОсновнаяТаблица";
	Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "		ПО ТабличнаяЧасть.Ссылка = ОсновнаяТаблица.Ссылка";
	
	РезультатЗапросаИтоговойТаблицы = КиурСрв.ПолучитьРезультатПроизвольногоТекстаЗапроса(Текст_ЗапросаИтоговойТаблицы);
	
	ИтоговаяТаблицаЗначений = РезультатЗапросаИтоговойТаблицы.Выгрузить();
	МодифицируемыеПараметры.Вставить("ИтоговаяТаблицаЗначений",ИтоговаяТаблицаЗначений);
	Возврат Истина;
КонецФункции	

Функция ПолучитьСодержимоеОсновнойТаблицыБД(Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ
	ИмяТаблицы = ФиксированныеПараметры.ИмяТаблицы;
	ИменаКолонокИсключений = ФиксированныеПараметры.ИменаКолонокИсключений;
	 
	Текст_ЗапросаИменКолонокТаблицы = "ВЫБРАТЬ ПЕРВЫЕ 1
	 	              					|	ОсновнаяТаблица.*
					   					|ИЗ
	 	              					|	&ИмяТаблицы КАК ОсновнаяТаблица";
	 
	СтруктураЗаменяемыхПараметровЗапроса = новый Структура;
	СтруктураЗаменяемыхПараметровЗапроса.Вставить("ИмяТаблицы",ИмяТаблицы);
	
	РезультатЗапросаИменКолонок = КиурСрв.ПолучитьРезультатПроизвольногоТекстаЗапроса(Текст_ЗапросаИменКолонокТаблицы,,СтруктураЗаменяемыхПараметровЗапроса);
	ТаблицаЗначенийЗапросаКолонок = РезультатЗапросаИменКолонок.Выгрузить();
		 
	МассивИменКолонокИтоговойТаблицы = новый Массив;
	МассивИменИсключений = ИменаКолонокИсключений.ВыгрузитьЗначения();
		 
	Для каждого Колонка из ТаблицаЗначенийЗапросаКолонок.Колонки Цикл
		Если МассивИменИсключений.Найти(Колонка.Имя) = Неопределено И МассивИменКолонокИтоговойТаблицы.Найти(Колонка.Имя) = Неопределено И НЕ Колонка.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			МассивИменКолонокИтоговойТаблицы.Добавить(Колонка.Имя);	
		КонецЕсли;		
	КонецЦикла;
	
	Текст_ЗапросаИтоговойТаблицы = "ВЫБРАТЬ";
	ИндексПоследнегоЭлемента = МассивИменКолонокИтоговойТаблицы.ВГраница();
	
	Для ИндексЭлемента = 0 По ИндексПоследнегоЭлемента Цикл   
		НужнаЗапятая = (ИндексЭлемента <> ИндексПоследнегоЭлемента);
		Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "	ОсновнаяТаблица." + МассивИменКолонокИтоговойТаблицы.Получить(ИндексЭлемента) + ?(НужнаЗапятая,",","");
	КонецЦикла;
	
	Текст_ЗапросаИтоговойТаблицы = Текст_ЗапросаИтоговойТаблицы + Символы.ПС + "ИЗ" + Символы.ПС + "	" + ИмяТаблицы + " КАК ОсновнаяТаблица";
	РезультатЗапросаИтоговойТаблицы = КиурСрв.ПолучитьРезультатПроизвольногоТекстаЗапроса(Текст_ЗапросаИтоговойТаблицы);
	
	ИтоговаяТаблицаЗначений = РезультатЗапросаИтоговойТаблицы.Выгрузить();
	МодифицируемыеПараметры.Вставить("ИтоговаяТаблицаЗначений",ИтоговаяТаблицаЗначений);
	Возврат Истина;               	 
КонецФункции	

Функция ПолучитьСоответствиеШаблонныхДанных(Знач ФиксированныеПараметры, МодифицируемыеПараметры) Экспорт
	СхемаВыгрузкиШаблонныхДанных = ФиксированныеПараметры.СхемаВыгрузкиШаблонныхДанных; 
	
	СоответствиеШаблонныхДанных = новый Соответствие;  
	//Мапа из Мап: Мапа первого уровня:
	//Ключ - "ИмяТаблицыДляЗапроса", Значение : Мапа 2го уровня
	//Мапа 2го уровня:
	//Ключ - Таблица значений по запросу сверху, Значение : ИменаКолонокИсключений
	
	ВеткиТиповМетаданных = СхемаВыгрузкиШаблонныхДанных.ПолучитьЭлементы();
	Для каждого ВеткаТипаМетаданных из ВеткиТиповМетаданных Цикл 
		ВеткиОсновныхТаблиц = ВеткаТипаМетаданных.ПолучитьЭлементы();
		
		Для каждого ВеткаОсновнойТаблицы из ВеткиОсновныхТаблиц Цикл
			
			Если НЕ ВеткаОсновнойТаблицы.Выгружать Тогда
				Продолжить;
			КонецЕсли;
			
			ВложенноеСоответствиеТаблиц = новый Соответствие;
			
			ИзменяемыеПараметры = новый Структура;
			НеИзменяемыеПараметры = новый Структура;
				
			НеИзменяемыеПараметры.Вставить("ИмяТаблицы",ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы);
			НеИзменяемыеПараметры.Вставить("ИменаКолонокИсключений",ВеткаОсновнойТаблицы.ИменаКолонокИсключений);
							
			НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
			
			Если ПустаяСтрока(ВеткаОсновнойТаблицы.МетодЗапросаКТаблице) Тогда
				
				Если НЕ ПолучитьСодержимоеОсновнойТаблицыБД(НеИзменяемыеПараметры,ИзменяемыеПараметры) Тогда
					СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
					СообщениеОшибки = "Не удалось получить шаблонную таблицу: " + ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы + ", по причине:" + Символы.ПС + СообщениеОшибки;
					МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
					Возврат Ложь;
				КонецЕсли;
				
			Иначе
				Выполнить ВеткаОсновнойТаблицы.МетодЗапросаКТаблице + "(НеИзменяемыеПараметры, ИзменяемыеПараметры)";
				
				Успешно = ?(ИзменяемыеПараметры.Свойство("Успешно",Успешно),Успешно,Ложь);
				
				Если НЕ Успешно Тогда
					СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
					СообщениеОшибки = "Не удалось получить шаблонную таблицу: " + ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы + ", по причине:" + Символы.ПС + СообщениеОшибки;
					МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
					Возврат Ложь;
				КонецЕсли;
				
			КонецЕсли;
			
			ШаблоннаяТаблицаЗначений = ИзменяемыеПараметры.ИтоговаяТаблицаЗначений;
						
			ВложенноеСоответствиеТаблиц.Вставить(ШаблоннаяТаблицаЗначений,ВеткаОсновнойТаблицы.ИменаКолонокИсключений);
			ВложенноеСоответствиеТаблиц = новый ФиксированноеСоответствие(ВложенноеСоответствиеТаблиц);
			
			СоответствиеШаблонныхДанных.Вставить(ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы,ВложенноеСоответствиеТаблиц);
			
			ЛистьяТабличныхЧастей = ВеткаОсновнойТаблицы.ПолучитьЭлементы();
			
			Для каждого ЛистТабличнойЧасти из ЛистьяТабличныхЧастей Цикл
				
				Если НЕ ЛистТабличнойЧасти.Выгружать Тогда
					Продолжить;
				КонецЕсли;
				
				ВложенноеСоответствиеТаблиц = новый Соответствие;
				
				ИзменяемыеПараметры = новый Структура;
				НеИзменяемыеПараметры = новый Структура;
				
				НеИзменяемыеПараметры.Вставить("ИмяОсновнойТаблицы",ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы);
				НеИзменяемыеПараметры.Вставить("ИмяТаблицыТабличнойЧасти",ЛистТабличнойЧасти.ИмяТаблицыТабличнойЧасти);
				НеИзменяемыеПараметры.Вставить("ИменаКолонокИсключений",ЛистТабличнойЧасти.ИменаКолонокИсключений);
				НеИзменяемыеПараметры.Вставить("ТипМетаданных",ВеткаТипаМетаданных.ТипМетаданных);
						
				НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
				
				Если ПустаяСтрока(ЛистТабличнойЧасти.МетодЗапросаКТаблице) Тогда
				
					Если НЕ ПолучитьСодержимоеТабличнойЧастиТаблицыБД(НеИзменяемыеПараметры,ИзменяемыеПараметры) Тогда
						СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
						СообщениеОшибки = "Не удалось получить шаблонную таблицу: " + ЛистТабличнойЧасти.ИмяТаблицыТабличнойЧасти + ", по причине:" + Символы.ПС + СообщениеОшибки;
						МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
						Возврат Ложь;
					КонецЕсли;
				
				Иначе
					Выполнить ЛистТабличнойЧасти.МетодЗапросаКТаблице + "(НеИзменяемыеПараметры, ИзменяемыеПараметры)";	
					
					Успешно = ?(ИзменяемыеПараметры.Свойство("Успешно",Успешно),Успешно,Ложь);
					
					Если НЕ Успешно Тогда
						СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
						СообщениеОшибки = "Не удалось получить шаблонную таблицу: " + ЛистТабличнойЧасти.ИмяТаблицыТабличнойЧасти + ", по причине:" + Символы.ПС + СообщениеОшибки;
						МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
						Возврат Ложь;
					КонецЕсли;
					
				КонецЕсли;
			   
				ШаблоннаяТаблицаЗначений = ИзменяемыеПараметры.ИтоговаяТаблицаЗначений;
				
				ВложенноеСоответствиеТаблиц.Вставить(ШаблоннаяТаблицаЗначений,ЛистТабличнойЧасти.ИменаКолонокИсключений);
				ВложенноеСоответствиеТаблиц = новый ФиксированноеСоответствие(ВложенноеСоответствиеТаблиц);
			
				СоответствиеШаблонныхДанных.Вставить(ЛистТабличнойЧасти.ИмяТаблицыТабличнойЧасти,ВложенноеСоответствиеТаблиц);				
				 				
			КонецЦикла;				
		КонецЦикла;			
	КонецЦикла;
	
	
	СоответствиеШаблонныхДанных = новый ФиксированноеСоответствие(СоответствиеШаблонныхДанных);
	МодифицируемыеПараметры.Вставить("СоответствиеШаблонныхДанных",СоответствиеШаблонныхДанных);	
	Возврат Истина;
КонецФункции 

#КонецОбласти


#Область СверкаШаблонныхДанных

Функция ВыполненаСтандартнаяСверкаШаблонныхДанных(Знач ФиксированныеПараметры,МодифицируемыеПараметры) ЭКСПОРТ
	UID_ТекущегоШага = ФиксированныеПараметры.UID_ТекущегоШага;
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("UIDОбъекта",UID_ТекущегоШага);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;	
	
	ХранилищеШаблонныхДанных = РегистрыСведений.Tester_ШаблонныеДанные.ПолучитьШаблонныеДанныеОбъекта(НеИзменяемыеПараметры, ИзменяемыеПараметры);
	Если ТипЗнч(ХранилищеШаблонныхДанных) <> Тип("ХранилищеЗначения") Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураХранилищаШаблонныхДанных = ХранилищеШаблонныхДанных.Получить();
	СхемаВыгрузкиШаблонныхДанных = КиурКлСрв.Десериализовать_из_XML_Строки(СтруктураХранилищаШаблонныхДанных.СхемаВыгрузкиШаблонныхДанных);
	ШаблонныеДанныеШага = новый Соответствие(КиурКлСрв.Десериализовать_из_XML_Строки(СтруктураХранилищаШаблонныхДанных.ШаблонныеДанные));
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	
	Если НЕ ПолучитьСоответствиеШаблонныхДанных(НеИзменяемыеПараметры, ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;	
	КонецЕсли;	
	
	ТекущиеДанныеБД = новый Соответствие(ИзменяемыеПараметры.СоответствиеШаблонныхДанных);
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	ИзменяемыеПараметры.Вставить("ТекущиеДанныеБД",ТекущиеДанныеБД);
	ИзменяемыеПараметры.Вставить("ШаблонныеДанныеШага",ШаблонныеДанныеШага);
	
	Если НЕ ВыполненаПроверкаИдентичностиСоответствийДанных(НеИзменяемыеПараметры, ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");		
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

Функция ВыполненаПроверкаИдентичностиСоответствийДанных(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	
	ТекущиеДанныеБД = МодифицируемыеПараметры.ТекущиеДанныеБД;
	ШаблонныеДанныеШага = МодифицируемыеПараметры.ШаблонныеДанныеШага;	
	
	масТаблицПрошедшихПроверки = новый Массив;
	
	Для каждого ИмяТаблицы_ВложенноеСоответствие из ТекущиеДанныеБД Цикл
		ИмяПроверяемойТаблицыБД = ИмяТаблицы_ВложенноеСоответствие.Ключ;		
		ВложенноеСоответствиеТекущихДанных = ИмяТаблицы_ВложенноеСоответствие.Значение;
		
		ВложенноеСоответствиеШаблона = ШаблонныеДанныеШага.Получить(ИмяПроверяемойТаблицыБД); 
		
		Если ВложенноеСоответствиеШаблона = Неопределено Тогда
			СообщениеОшибки = "В шаблонных данных отсутствуют данные для таблицы: " + ИмяПроверяемойТаблицыБД; 
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ( ВложенноеСоответствиеШаблона.Количество() = 1 И ВложенноеСоответствиеТекущихДанных.Количество() = 1 ) Тогда
			СообщениеОшибки = "Некорректное содержимое щаблонных данных для таблицы: " + ИмяПроверяемойТаблицыБД; 
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;			
		КонецЕсли;	
		
		ТаблицаДанныхШаблона = Неопределено;
		ТекущаяТаблицаДанныхБД = Неопределено;
		
		Для каждого Кл_Зн из ВложенноеСоответствиеШаблона Цикл
			ТаблицаДанныхШаблона = Кл_Зн.Ключ;
		КонецЦикла;
		
		Для каждого Кл_Зн из ВложенноеСоответствиеТекущихДанных Цикл
			ТекущаяТаблицаДанныхБД = Кл_Зн.Ключ;
		КонецЦикла;
		
		НеИзменяемыеПараметры = новый Структура;
		НеИзменяемыеПараметры.Вставить("ПерваяТаблица",ТекущаяТаблицаДанныхБД);
		НеИзменяемыеПараметры.Вставить("ВтораяТаблица",ТаблицаДанныхШаблона);
		НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
		ИзменяемыеПараметры = новый Структура;
		
		Если НЕ КиурСрв.ВыполненаПроверкаНаИдентичностьТаблицЗначений(НеИзменяемыеПараметры, ИзменяемыеПараметры) Тогда
			СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
			СообщениеОшибки = "Не прошла сверка шаблонных данных для таблицы: " + ИмяПроверяемойТаблицыБД + ", по причине:" + Символы.ПС + СообщениеОшибки; 	
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецЕсли;
		
		масТаблицПрошедшихПроверки.Добавить(ИмяПроверяемойТаблицыБД);
		
	КонецЦикла;
	
	Для Каждого ИмяТаблицы из масТаблицПрошедшихПроверки Цикл
		ТекущиеДанныеБД.Удалить(ИмяТаблицы);
		ШаблонныеДанныеШага.Удалить(ИмяТаблицы);
	КонецЦикла;
	
	масИменТаблицНеПрошедшихПроверки = новый Массив;
	
	Для каждого Ключ_Значение из ТекущиеДанныеБД Цикл
		масИменТаблицНеПрошедшихПроверки.Добавить("ТекДанные: " + Ключ_Значение.Ключ);	
	КонецЦикла;
	
	Для каждого Ключ_Значение из ШаблонныеДанныеШага Цикл
		масИменТаблицНеПрошедшихПроверки.Добавить("ШаблонДанные: " + Ключ_Значение.Ключ);	
	КонецЦикла;
	
	Если ЗначениеЗаполнено(масИменТаблицНеПрошедшихПроверки) Тогда
		СообщениеОшибки = "Не прошли проверку идентичности таблицы: " + Символы.ПС;
		
		Для каждого ИмяТаблицы из масИменТаблицНеПрошедшихПроверки Цикл
			СообщениеОшибки = СообщениеОшибки + ИмяТаблицы + Символы.ПС;	
		КонецЦикла;	
		
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции



#КонецОбласти