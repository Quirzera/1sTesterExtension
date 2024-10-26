

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Формы \\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)   
			
	ШаблонныеДанные = ?(Параметры.Свойство("ШаблонныеДанные",ШаблонныеДанные),ШаблонныеДанные,"");
	ПереданнаяСхемаВыгрузкиШаблонныхДанных = ?(Параметры.Свойство("СхемаВыгрузкиШаблонныхДанных",ПереданнаяСхемаВыгрузкиШаблонныхДанных),ПереданнаяСхемаВыгрузкиШаблонныхДанных,Неопределено);
	
	Если ПереданнаяСхемаВыгрузкиШаблонныхДанных = Неопределено Тогда  
		
		ФиксированныеПараметры = новый ФиксированнаяСтруктура(новый Структура);
		МодифицируемыеПараметры = новый Структура;
		МодифицируемыеПараметры.Вставить("ШаблонСхемыВыгрузки",СхемаВыгрузкиШаблонныхДанных);
		
		Если TesterСрв.ПолученаСтандартнаяСхемаВыгрузкиШаблонныхДанных(ФиксированныеПараметры, МодифицируемыеПараметры) Тогда
			КопироватьДанныеФормы(МодифицируемыеПараметры.ШаблонСхемыВыгрузки,СхемаВыгрузкиШаблонныхДанных);
		Иначе
			Отказ = Истина;
			СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,""); 
			ВызватьИсключение "Не удалось получить Схему выгрузки шаблонных данных" + СообщениеОшибки;			
		КонецЕсли;
	Иначе			
		КопироватьДанныеФормы(ПереданнаяСхемаВыгрузкиШаблонныхДанных,СхемаВыгрузкиШаблонныхДанных);
	КонецЕсли;	
	
	
КонецПроцедуры 

#КонецОбласти


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Команд\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область КомандыФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("ЗначениеМетки",Истина);
	ФиксированныеПараметры.Вставить("ИмяПоля","Выгружать");
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
		
	МодифицируемыеПараметры = новый Структура;
	МодифицируемыеПараметры.Вставить("ДеревоФормы",СхемаВыгрузкиШаблонныхДанных);
		
	КиурКлСрв.УстановитьБулевуПометкуПоДеревуФормы(ФиксированныеПараметры,МодифицируемыеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсех(Команда)
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("ЗначениеМетки",Ложь);
	ФиксированныеПараметры.Вставить("ИмяПоля","Выгружать");
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
		
	МодифицируемыеПараметры = новый Структура;
	МодифицируемыеПараметры.Вставить("ДеревоФормы",СхемаВыгрузкиШаблонныхДанных);
		
	КиурКлСрв.УстановитьБулевуПометкуПоДеревуФормы(ФиксированныеПараметры,МодифицируемыеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьЗаполненныеТаблицы(Команда) 
	
	СнятьОтметкуСоВсех(Неопределено);
	
	МодифицируемыеПараметры = новый Структура;
	МодифицируемыеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	
	Если ОтметитьЗаполненныеТаблицыСрв(новый ФиксированнаяСтруктура,МодифицируемыеПараметры) Тогда		
		КопироватьДанныеФормы(МодифицируемыеПараметры.СхемаВыгрузкиШаблонныхДанных,СхемаВыгрузкиШаблонныхДанных);
	Иначе
		СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,""); 
		СообщениеОшибки = "Не удалось отметить только заполненные таблицы, по причине: " + Символы.ПС + СообщениеОшибки;	
		КиурКл.ОтобразитьПредупреждение(СообщениеОшибки,ЭтаФорма);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьXMLШаблона(Команда)
	
	МодифицируемыеПараметры = новый Структура;
	
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
			
	Если НЕ ПолучитьТекстШаблонныхДанных(ФиксированныеПараметры, МодифицируемыеПараметры) Тогда 
		СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		СообщениеОшибки = "Не удалось сформировать текст шаблона, по причине:" + Символы.ПС + СообщениеОшибки;
		КиурКл.ОтобразитьПредупреждение(СообщениеОшибки,ЭтаФорма);
	Иначе
		ТекстШаблона = МодифицируемыеПараметры.ТекстШаблонныхДанных; 
		
		ПараметрыОткрытия = новый Структура;
		ПараметрыОткрытия.Вставить("РедактируемыйТекст",ТекстШаблона);
		ПараметрыОткрытия.Вставить("РежимПросмотра",Истина);
		ОткрытьФорму("ОбщаяФорма.Tester_ФормаРедактированияТекста",ПараметрыОткрытия,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблонныеДанныеПоСхеме(Команда)
	МодифицируемыеПараметры = новый Структура;
	
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
			
	Если НЕ ПолучитьТекстШаблонныхДанных(ФиксированныеПараметры, МодифицируемыеПараметры) Тогда 
		СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		СообщениеОшибки = "Не удалось сформировать текст шаблона, по причине:" + Символы.ПС + СообщениеОшибки;
		КиурКл.ОтобразитьПредупреждение(СообщениеОшибки,ЭтаФорма);
	Иначе
		ШаблонныеДанные = МодифицируемыеПараметры.ТекстШаблонныхДанных;
		
		СтруктураВозврата = новый Структура;
		СтруктураВозврата.Вставить("ШаблонныеДанные",ШаблонныеДанные);
		СтруктураВозврата.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
		Закрыть(СтруктураВозврата);
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьВыбраннуюТаблицу(Команда)
	ВыбраннаяСтрока = Элементы.СхемаВыгрузкиШаблонныхДанных.ТекущиеДанные;
	Если ВыбраннаяСтрока = Неопределено Тогда
		КиурКл.ОтобразитьПредупреждение("Не выбрана строка для обновления таблицы шаблонных данных.",ЭтаФорма);
		Возврат;
	КонецЕсли;	
	
	Если ПустаяСтрока(ШаблонныеДанные) Тогда
		КиурКл.ОтобразитьПредупреждение("Текущие шаблонные пусты. Сперва необходимо выполнить полную генерацию шаблонных данных.",ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	Если НЕ ВыбраннаяСтрока.Выгружать Тогда
		КиурКл.ОтобразитьПредупреждение("Текущая строка не помечена к выгрузке.",ЭтаФорма);
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ВыбраннаяСтрока.ИмяОсновнойТаблицы) И ПустаяСтрока(ВыбраннаяСтрока.ИмяТаблицыТабличнойЧасти) Тогда
		КиурКл.ОтобразитьПредупреждение("Выберите строку конкретной таблицы.",ЭтаФорма);		
		Возврат;
	КонецЕсли;
	
	ИмяОсновнойТаблицы = ВыбраннаяСтрока.ИмяОсновнойТаблицы;
	ИмяТаблицыТабличнойЧасти = ВыбраннаяСтрока.ИмяТаблицыТабличнойЧасти;
	МетодЗапросаКТаблице = ВыбраннаяСтрока.МетодЗапросаКТаблице;
	ИменаКолонокИсключений  = ВыбраннаяСтрока.ИменаКолонокИсключений;  
	
	ИмяТаблицыДляОбновления = ?(ПустаяСтрока(ИмяТаблицыТабличнойЧасти),ИмяОсновнойТаблицы,ИмяТаблицыТабличнойЧасти);
	
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("ИмяОсновнойТаблицы",ИмяОсновнойТаблицы);
	ФиксированныеПараметры.Вставить("ИмяТаблицыТабличнойЧасти",ИмяТаблицыТабличнойЧасти);
	ФиксированныеПараметры.Вставить("МетодЗапросаКТаблице",МетодЗапросаКТаблице);
	ФиксированныеПараметры.Вставить("ИменаКолонокИсключений",ИменаКолонокИсключений);
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
	
	МодифицируемыеПараметры = новый Структура; 
	МодифицируемыеПараметры.Вставить("ШаблонныеДанные",ШаблонныеДанные);
	
	Если НЕ ОбновленаТаблицаШаблонныхДанных(ФиксированныеПараметры, МодифицируемыеПараметры) Тогда
		СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		КиурКл.ОтобразитьПредупреждение("Не удалось обновить таблицу " + ИмяТаблицыДляОбновления + Символы.ПС,ЭтаФорма);
		Возврат;
	Иначе
		ШаблонныеДанные = МодифицируемыеПараметры.ТекстШаблонныхДанных;
		
		СтруктураВозврата = новый Структура;
		СтруктураВозврата.Вставить("ШаблонныеДанные",ШаблонныеДанные);
		СтруктураВозврата.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
		Закрыть(СтруктураВозврата);
	КонецЕсли;	
КонецПроцедуры




#КонецОбласти  
                         


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////Обработчики Событий Элементов\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область ЭлементыФормы 

 &НаКлиенте
Процедура СхемаВыгрузкиШаблонныхДанныхВыгружатьПриИзменении(Элемент)
	ТекДанные = Элементы.СхемаВыгрузкиШаблонныхДанных.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФиксированныеПараметры = новый Структура;
	ФиксированныеПараметры.Вставить("ЗначениеМетки",ТекДанные.Выгружать);
	ФиксированныеПараметры.Вставить("ИмяПоля","Выгружать");
	ФиксированныеПараметры = новый ФиксированнаяСтруктура(ФиксированныеПараметры);
		
	МодифицируемыеПараметры = новый Структура;
	МодифицируемыеПараметры.Вставить("ТекущаяВеткаДерева",ТекДанные);
		
	КиурКлСрв.УстановитьБулевуПометкуПоДеревуФормы(ФиксированныеПараметры,МодифицируемыеПараметры);
	
КонецПроцедуры
  
#КонецОбласти 

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////Служебные методы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область Служебные

&НаСервереБезКонтекста
Функция ОтметитьЗаполненныеТаблицыСрв(Знач ФиксированныеПараметры, МодифицируемыеПараметры)
	//--адаптация
	УстановитьПривилегированныйРежим(Истина);
	//
	
	СхемаВыгрузкиШаблонныхДанных = МодифицируемыеПараметры.СхемаВыгрузкиШаблонныхДанных;
		
	ВеткиТиповМетаданных = СхемаВыгрузкиШаблонныхДанных.ПолучитьЭлементы();
	Для каждого ВеткаТипаМетаданных из ВеткиТиповМетаданных Цикл 
		ВеткиОсновныхТаблиц = ВеткаТипаМетаданных.ПолучитьЭлементы();
		
		Для каждого ВеткаОсновнойТаблицы из ВеткиОсновныхТаблиц Цикл
			МогутБытьПредопределенные = (ВеткаТипаМетаданных.ТипМетаданных = "Справочник");
			
			НеизменяемыПараметры = новый Структура;
			НеизменяемыПараметры.Вставить("ИмяТаблицы",ВеткаОсновнойТаблицы.ИмяОсновнойТаблицы);
			НеизменяемыПараметры.Вставить("МогутБытьПредопределенные",МогутБытьПредопределенные);
			НеизменяемыПараметры = новый ФиксированнаяСтруктура(НеизменяемыПараметры); 
			
			ВеткаОсновнойТаблицы.Выгружать = TesterСрв.ЕстьНеПредопределенныеЗаписиВТаблице(НеизменяемыПараметры,новый Структура);
			
			ЛистьяТабличныхЧастей = ВеткаОсновнойТаблицы.ПолучитьЭлементы();
			
			Для каждого ЛистТабличнойЧасти из ЛистьяТабличныхЧастей Цикл
				
				НеизменяемыПараметры = новый Структура;
				НеизменяемыПараметры.Вставить("ИмяТаблицы",ЛистТабличнойЧасти.ИмяТаблицыТабличнойЧасти);
				НеизменяемыПараметры.Вставить("МогутБытьПредопределенные",Ложь);
				НеизменяемыПараметры = новый ФиксированнаяСтруктура(НеизменяемыПараметры);
				
				ЛистТабличнойЧасти.Выгружать = TesterСрв.ЕстьНеПредопределенныеЗаписиВТаблице(НеизменяемыПараметры,новый Структура); 				
			КонецЦикла;				
		КонецЦикла;			
	КонецЦикла;	
	
	МодифицируемыеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	//--адаптация
	УстановитьПривилегированныйРежим(Ложь);
	//	
	Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстШаблонныхДанных(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	//--адаптация
	УстановитьПривилегированныйРежим(Истина);
	//
	//
	//В соответствии лежат таблицы значений, напрямую на клиент вернуть не получится.
	СхемаВыгрузкиШаблонныхДанных = ФиксированныеПараметры.СхемаВыгрузкиШаблонныхДанных;
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("СхемаВыгрузкиШаблонныхДанных",СхемаВыгрузкиШаблонныхДанных);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	
	Если НЕ TesterСрв.ПолучитьСоответствиеШаблонныхДанных(НеИзменяемыеПараметры, ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(МодифицируемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		СообщениеОшибки ="Не удалось получить соответствие шаблонных данных, по причине:" + Символы.ПС + СообщениеОшибки;
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	СоответствиеШаблонныхДанных = ИзменяемыеПараметры.СоответствиеШаблонныхДанных;

	ТекстШаблонныхДанных = КиурКлСрв.Сериализовать_в_XML_Строку(СоответствиеШаблонныхДанных);
	
	МодифицируемыеПараметры.Вставить("ТекстШаблонныхДанных",ТекстШаблонныхДанных);
	//--адаптация
	УстановитьПривилегированныйРежим(Ложь);
	//
	Возврат Истина;	
КонецФункции

&НаСервереБезКонтекста
Функция ОбновленаТаблицаШаблонныхДанных(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	ИмяОсновнойТаблицы = ФиксированныеПараметры.ИмяОсновнойТаблицы;
	ИмяТаблицыТабличнойЧасти = ФиксированныеПараметры.ИмяТаблицыТабличнойЧасти;
	МетодЗапросаКТаблице = ФиксированныеПараметры.МетодЗапросаКТаблице;
	ИменаКолонокИсключений = ФиксированныеПараметры.ИменаКолонокИсключений;
	
	ШаблонныеДанные = МодифицируемыеПараметры.ШаблонныеДанные; 
		
	СоставСтроки = СтрРазделить(ИмяОсновнойТаблицы,".",Ложь);
	ТипМетаданных = СоставСтроки[0];
			
	ИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры = новый Структура;
	
	НеИзменяемыеПараметры.Вставить("ИмяТаблицы",ИмяОсновнойТаблицы);
	НеИзменяемыеПараметры.Вставить("ИмяОсновнойТаблицы",ИмяОсновнойТаблицы);
	НеИзменяемыеПараметры.Вставить("ИмяТаблицыТабличнойЧасти",ИмяТаблицыТабличнойЧасти);
	НеИзменяемыеПараметры.Вставить("ИменаКолонокИсключений",ИменаКолонокИсключений);
	НеИзменяемыеПараметры.Вставить("ТипМетаданных",ТипМетаданных);
						
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	Если НЕ ПустаяСтрока(МетодЗапросаКТаблице) Тогда
		
		Попытка
			УстановитьБезопасныйРежим(Истина);							
			Выполнить МетодЗапросаКТаблице + "(НеИзменяемыеПараметры, ИзменяемыеПараметры)";
			УстановитьБезопасныйРежим(ложь);
		Исключение
			СообщениеОшибки = ОписаниеОшибки();
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецПопытки; 
		
		Успешно = ?(ИзменяемыеПараметры.Свойство("Успешно",Успешно),Успешно,Ложь);
		
		Если НЕ Успешно Тогда
			СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецЕсли;  
		
	Иначе
		Если ПустаяСтрока(ИмяТаблицыТабличнойЧасти) Тогда //Основная таблица 
			
			Если НЕ TesterСрв.ПолучитьСодержимоеОсновнойТаблицыБД(НеИзменяемыеПараметры,ИзменяемыеПараметры) Тогда
				СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
				МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
				Возврат Ложь;
			КонецЕсли;
			
		ИначеЕсли НЕ ПустаяСтрока(ИмяОсновнойТаблицы) И НЕ ПустаяСтрока(ИмяТаблицыТабличнойЧасти) Тогда	//ТабличнаяЧасть
			
			Если НЕ TesterСрв.ПолучитьСодержимоеТабличнойЧастиТаблицыБД(НеИзменяемыеПараметры,ИзменяемыеПараметры) Тогда
				СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
				МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
		
	ШаблоннаяТаблицаЗначений = ?(ИзменяемыеПараметры.Свойство("ИтоговаяТаблицаЗначений",ШаблоннаяТаблицаЗначений),ШаблоннаяТаблицаЗначений,Неопределено);
	
	Если ШаблоннаяТаблицаЗначений = Неопределено Тогда
		СообщениеОшибки = "Не определена ИтоговаяТаблицаЗначений";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	ИмяТаблицыКлюч = ?(ПустаяСтрока(ИмяТаблицыТабличнойЧасти),ИмяОсновнойТаблицы,ИмяТаблицыТабличнойЧасти);
	
	ВложенноеСоответствиеТаблиц = новый Соответствие;
	ВложенноеСоответствиеТаблиц.Вставить(ШаблоннаяТаблицаЗначений,ИменаКолонокИсключений);
	ВложенноеСоответствиеТаблиц = новый ФиксированноеСоответствие(ВложенноеСоответствиеТаблиц);
	
	СоответствиеШаблонныхДанных = новый Соответствие(КиурКлСрв.Десериализовать_из_XML_Строки(ШаблонныеДанные));
	СоответствиеШаблонныхДанных.Вставить(ИмяТаблицыКлюч,ВложенноеСоответствиеТаблиц);
	
	ШаблонныеДанные = КиурКлСрв.Сериализовать_в_XML_Строку(новый ФиксированноеСоответствие(СоответствиеШаблонныхДанных));
	
	МодифицируемыеПараметры.Вставить("ТекстШаблонныхДанных",ШаблонныеДанные);
	Возврат Истина;	
КонецФункции





#КонецОбласти 



/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////////////Для удаления\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#Область ДляУдаления

#КонецОбласти

////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////
////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Для удаления/////////////////////////////
////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////