#Область Работа_с_СКД   

//@skip-check redundant-export-method
Функция ПолучитьСтруктуруРезультатаВыполненияОтчетаИзСКД_ИзВнешнейТаблицы(СтруктураПараметров) ЭКСПОРТ
	
	СхемаКомпоновкиОтчета = СтруктураПараметров.СхемаКомпоновкиОтчета;
	ТекстЗапроса = СтруктураПараметров.ТекстЗапроса;
	СтруктураПараметровЗапроса = ?(СтруктураПараметров.Свойство("СтруктураПараметровЗапроса",СтруктураПараметровЗапроса),СтруктураПараметровЗапроса,новый Структура);
	СтруктураЗаменяемыхЗначений = ?(СтруктураПараметров.Свойство("СтруктураЗаменяемыхЗначений",СтруктураЗаменяемыхЗначений),СтруктураЗаменяемыхЗначений,новый Структура);
	
	ДокументРезультат = ?(СтруктураПараметров.Свойство("ДокументРезультат",ДокументРезультат),ДокументРезультат,новый ТабличныйДокумент);
	Если НЕ СтруктураПараметров.Свойство("КомпоновщикНастроек") ИЛИ СтруктураПараметров.КомпоновщикНастроек = Неопределено Тогда
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиОтчета));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиОтчета.НастройкиПоУмолчанию);		
	Иначе
		КомпоновщикНастроек = СтруктураПараметров.КомпоновщикНастроек;	
	КонецЕсли;
	
	ДанныеОтчета = новый Структура;
	
	РезультатЗапроса = ПолучитьРезультатПроизвольногоТекстаЗапроса(ТекстЗапроса,СтруктураПараметровЗапроса,СтруктураЗаменяемыхЗначений); 
	ТаблицаОтчета = РезультатЗапроса.Выгрузить();
	
	ВнешниеНаборыДанных = новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаОтчета",ТаблицаОтчета);
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = новый ДанныеРасшифровкиКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиОтчета,Настройки,ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных,ДанныеРасшифровки);
	
	ПроцессорВывода = новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;	
	ДокументРезультат.АвтоМасштаб = Истина;	
	ХранилищеРасшифровок = Новый ХранилищеЗначения(ДанныеРасшифровки);
	
	ДанныеОтчета.Вставить("ВыводТабличногоДокумента",ДокументРезультат);
	ДанныеОтчета.Вставить("ХранилищеРасшифровок",ХранилищеРасшифровок);
	Возврат ДанныеОтчета;	 
	
КонецФункции

#КонецОбласти

#Область Работа_с_Формами

Процедура ДобавитьПроизвольнуюТаблицуНаФорму(ИмяТаблицыНаФорме,Форма,ТаблицаЗначений,ГруппаФормыДляТаблицы = Неопределено) ЭКСПОРТ
	МассивРеквизитовДляДобавления = новый Массив;
	
	РеквизитыФормы = Форма.ПолучитьРеквизиты();
	НужноСоздатьТаблицу = Истина;
	Для каждого Реквизит из РеквизитыФормы Цикл
		Если Реквизит.Имя = ИмяТаблицыНаФорме Тогда
			НужноСоздатьТаблицу = Ложь;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	

	Если НужноСоздатьТаблицу Тогда
		нРеквизит = новый РеквизитФормы(ИмяТаблицыНаФорме,новый ОписаниеТипов("ТаблицаЗначений"));
		МассивРеквизитовДляДобавления.Добавить(нРеквизит);
	КонецЕсли;	
	
	Для каждого Колонка из ТаблицаЗначений.Колонки цикл		
		нРеквизит = новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,ИмяТаблицыНаФорме,Колонка.Заголовок);
		МассивРеквизитовДляДобавления.Добавить(нРеквизит);
	КонецЦикла;

	Форма.ИзменитьРеквизиты(МассивРеквизитовДляДобавления);	
	
	РодительЭлементаТаблица = ?(ГруппаФормыДляТаблицы <> Неопределено,ГруппаФормыДляТаблицы,Форма);
	элТаблицаНаФорме = Форма.Элементы.Добавить(ИмяТаблицыНаФорме,Тип("ТаблицаФормы"),РодительЭлементаТаблица);
	элТаблицаНаФорме.ПутьКДанным = ИмяТаблицыНаФорме; 
	элТаблицаНаФорме.ТолькоПросмотр = Истина;
	
	Для каждого Колонка из ТаблицаЗначений.Колонки Цикл
		элКолонкаТаблицы = Форма.Элементы.Добавить(ИмяТаблицыНаФорме + Колонка.Имя,Тип("ПолеФормы"),элТаблицаНаФорме);
		элКолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
		элКолонкаТаблицы.ПутьКДанным = ИмяТаблицыНаФорме + "." + Колонка.Имя;
	КонецЦикла;
	
	Форма[ИмяТаблицыНаФорме].Загрузить(ТаблицаЗначений);	
КонецПроцедуры

//@skip-check redundant-export-method
Функция ВернутьНаКлиентКопиюОбъекта(Знач ОбъектКлиента) ЭКСПОРТ
	Возврат ОбъектКлиента;	
КонецФункции

#КонецОбласти

#Область ПолучениеДанных

Функция ПолучитьРезультатПроизвольногоТекстаЗапроса(ТекстЗапроса,Знач СтруктураПараметровЗапроса = Неопределено, Знач СтруктураЗаменяемыхЗначений = Неопределено) ЭКСПОРТ
	
	Если ТипЗнч(СтруктураПараметровЗапроса) <> Тип("Структура") Тогда
		СтруктураПараметровЗапроса = новый Структура;			
	КонецЕсли;
	
	Если ТипЗнч(СтруктураЗаменяемыхЗначений) <> Тип("Структура") Тогда
		СтруктураЗаменяемыхЗначений = новый Структура;			
	КонецЕсли;	
	
	Запрос = новый Запрос;	
	
	Для каждого ПараметрЗапроса из СтруктураПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ПараметрЗапроса.Ключ,ПараметрЗапроса.Значение);	
	КонецЦикла;
	
	Для каждого ТекстЗамены из СтруктураЗаменяемыхЗначений цикл
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&" + ТекстЗамены.Ключ,ТекстЗамены.Значение);		
	КонецЦикла;	

	Запрос.Текст = ТекстЗапроса;
	Возврат Запрос.Выполнить();	
КонецФункции

#КонецОбласти 

#Область Телеграма

//@skip-check module-unused-method
Процедура ТестОтправки(AccessToken,ChatId,ТекстСообщения)
	ОтправкаВТелерам = новый HTTPСоединение("api.telegram.org",443,,,,15,новый ЗащищенноеСоединениеOpenSSL());
	ОтправкаВТелерам.Получить(новый HTTPЗапрос("bot" + AccessToken + "/sendMessage?chat_id" + ChatId + "&text=" + ТекстСообщения));
КонецПроцедуры

#КонецОбласти 

Функция СоздатьХранилищеЗначения(Знач СериализуемоеЗначение,Знач АлгоритмСжатияДанных = Неопределено) ЭКСПОРТ
	Если ТипЗнч(АлгоритмСжатияДанных) = Тип("Число") И АлгоритмСжатияДанных > 0 И АлгоритмСжатияДанных < 10 Тогда
		Возврат новый ХранилищеЗначения(СериализуемоеЗначение,новый СжатиеДанных(АлгоритмСжатияДанных));
	Иначе
		Возврат новый ХранилищеЗначения(СериализуемоеЗначение);		
	КонецЕсли;	
КонецФункции

Функция ВернутьЗначениеХранилища(ХранилищеЗначения) ЭКСПОРТ
	Возврат ХранилищеЗначения.Получить();
КонецФункции

Функция ВыполненаПроверкаНаИдентичностьТаблицЗначений(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	ПерваяТаблица = ФиксированныеПараметры.ПерваяТаблица;
	ВтораяТаблица = ФиксированныеПараметры.ВтораяТаблица; 
	
	Если НЕ ( ТипЗнч(ПерваяТаблица) = Тип("ТаблицаЗначений") И ТипЗнч(ВтораяТаблица) = Тип("ТаблицаЗначений") ) Тогда
		СообщениеОшибки = "Переданные аргументы не являются таблицами значений.";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ИдентичныИменаКолонокТаблицЗначений(ФиксированныеПараметры,МодифицируемыеПараметры) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПерваяТаблица) И НЕ ЗначениеЗаполнено(ВтораяТаблица) Тогда
		Возврат Истина;
	КонецЕсли;	
	
	ИменаКолонокТаблиц = новый Массив;
	
	Для каждого Колонка из ПерваяТаблица.Колонки Цикл
		ИменаКолонокТаблиц.Добавить(Колонка.Имя);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ИменаКолонокТаблиц) Тогда
		СообщениеОшибки = "ТаблицыЗначений со строками но без колонок 0_о.";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);		
		Возврат Ложь;
	КонецЕсли;
	
	ТемпПерваяТаблица = ПерваяТаблица.Скопировать();
	ТепмВтораяТаблица = ВтораяТаблица.Скопировать();
	
	ПоследИдн = ТемпПерваяТаблица.Количество() - 1; 
	
	Пока ПоследИдн >= 0 Цикл
		
		стр_первойТЗ = ТемпПерваяТаблица[ПоследИдн];
		
		СтруктураПоискаСтрокиВоВтройТаблице = новый Структура;
		Для каждого ИмяКолонки из ИменаКолонокТаблиц Цикл
			СтруктураПоискаСтрокиВоВтройТаблице.Вставить(ИмяКолонки,стр_первойТЗ[ИмяКолонки]);
		КонецЦикла;	
		
		масСтрокВторойТаблицы = ТепмВтораяТаблица.НайтиСтроки(СтруктураПоискаСтрокиВоВтройТаблице);
		
		Если НЕ ЗначениеЗаполнено(масСтрокВторойТаблицы) Тогда
			СообщениеОшибки = "Во второй таблице не найдено соответсвующих строк по отбору.";
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецЕсли;
		
		стр_для_удаления_из_второй_таблицы = масСтрокВторойТаблицы[0];
		ТепмВтораяТаблица.Удалить(стр_для_удаления_из_второй_таблицы);
		ТемпПерваяТаблица.Удалить(стр_первойТЗ);
		
		ПоследИдн = ПоследИдн - 1;		
	КонецЦикла;	
	
	Если НЕ (НЕ ЗначениеЗаполнено(ТемпПерваяТаблица) И НЕ ЗначениеЗаполнено(ТепмВтораяТаблица) )Тогда
		СообщениеОшибки = "Не пройдена проверка идентичности для таблиц.";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

//@skip-check redundant-export-method
Функция ИдентичныИменаКолонокТаблицЗначений(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ 
	
	ПерваяТаблица = ФиксированныеПараметры.ПерваяТаблица;
	ВтораяТаблица = ФиксированныеПараметры.ВтораяТаблица;
	
	ИменаКолонокПервойТаблицы = новый Массив;
	ИменаКолонокВторойТаблицы = новый Массив;
	
	Для каждого Колонка из ПерваяТаблица.Колонки Цикл
		ИменаКолонокПервойТаблицы.Добавить(Колонка.Имя);
	КонецЦикла;
	
	Для каждого Колонка из ВтораяТаблица.Колонки Цикл
		ИменаКолонокВторойТаблицы.Добавить(Колонка.Имя);
	КонецЦикла;

	ИтераторУдаления = ИменаКолонокПервойТаблицы.ВГраница();
	Пока ИтераторУдаления >= 0 Цикл 
		ИмяКолонкиПервойТаблицы = ИменаКолонокПервойТаблицы[ИтераторУдаления];
		
		ИндексИмениКолонкиВторойТаблицы = ИменаКолонокВторойТаблицы.Найти(ИмяКолонкиПервойТаблицы);
		Если ИндексИмениКолонкиВторойТаблицы = Неопределено Тогда
			СообщениеОшибки = "Во второй таблице отсутствует колонка: " + ИмяКолонкиПервойТаблицы;
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;			
		КонецЕсли;	
		
		ИменаКолонокПервойТаблицы.Удалить(ИтераторУдаления);
		ИменаКолонокВторойТаблицы.Удалить(ИндексИмениКолонкиВторойТаблицы);
		ИтераторУдаления = ИтераторУдаления - 1;			
	КонецЦикла;
	
	масИменНеИдентичныхКолонок = новый Массив;
	
	Для каждого ИмяКолонки из ИменаКолонокПервойТаблицы Цикл
		масИменНеИдентичныхКолонок.Добавить("ПерваяТаблица: " + ИмяКолонки);	
	КонецЦикла;	
	
	Для каждого ИмяКолонки из ИменаКолонокВторойТаблицы Цикл
		масИменНеИдентичныхКолонок.Добавить("ВтораяТаблица: " + ИмяКолонки);	
	КонецЦикла;
	
	Если ЗначениеЗаполнено(масИменНеИдентичныхКолонок) Тогда
		СообщениеОшибки = "Обнаружены различные колонки в таблицах: " + Символы.ПС;
		
		Для каждого ИмяКолонки из масИменНеИдентичныхКолонок Цикл
			СообщениеОшибки = СообщениеОшибки + ИмяКолонки + Символы.ПС;	
		КонецЦикла;	
		
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли; 
	
	Возврат Истина;
КонецФункции
	
#Область ВыгрузкаЗагрузкаXML8_3
	
Функция ВыполненаЗагрузкаИзДанныхXML(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	XMLДанных = ФиксированныеПараметры.XMLДанных;
	
	//------>В оригинале были глобальными переменными объекта обработки, найти от чего зависели ------>
	ВключитьВозможностьРедактированияИспользованияИтогов = ?(ФиксированныеПараметры.Свойство("ВключитьВозможностьРедактированияИспользованияИтогов",ВключитьВозможностьРедактированияИспользованияИтогов),ВключитьВозможностьРедактированияИспользованияИтогов,Ложь);
	ПриЗагрузкеИспользоватьРежимОбменаДанными = ?(ФиксированныеПараметры.Свойство("ПриЗагрузкеИспользоватьРежимОбменаДанными",ПриЗагрузкеИспользоватьРежимОбменаДанными),ПриЗагрузкеИспользоватьРежимОбменаДанными,Истина);
	ИспользующиеИтоги = ?(ФиксированныеПараметры.Свойство("ИспользующиеИтоги",ИспользующиеИтоги),ИспользующиеИтоги,новый Массив);
	ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки = ?(ФиксированныеПараметры.Свойство("ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки",ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки),ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки,Ложь);
	//------>В оригинале были глобальными переменными объекта обработки, найти от чего зависели <------ 
	
	Если ПустаяСтрока(XMLДанных) Тогда
		СообщениеОшибки = "Пустая строка XML данных.";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;		
	КонецЕсли;	
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("СтрокаДанныхXML",XMLДанных);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	
	ЧтениеXML = КиурКлСрв.ПолучитьЧтениеXML(НеИзменяемыеПараметры);
	
	Если ЧтениеXML = Неопределено Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЧтениеXML.Прочитать() Тогда
		СообщениеОшибки = "Пустой объект чтения XML.";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;		
	КонецЕсли;

	//------> Взято из другой обработки, кажется там вцелом часть про предопределённые кривая. ------>
	//Мнение - на основании использования оригинальной обработки в живых базах.
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("ЧтениеXML",ЧтениеXML);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	
	Если НЕ ПрочитатьПредопределенныеЭлементыИзXML(НеИзменяемыеПараметры,ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;	
	
	// ТаблицаПредопределенных = возможно и не нужна к возврату. Пока пусть будет, потом убрать.
	//В Оригинале автор вроде пляшет вокруг соответствия только.			
	ТаблицаПредопределенных	= ИзменяемыеПараметры.ТаблицаПредопределенных;
	СоответствиеЗаменыСсылок = ИзменяемыеПараметры.СоответствиеЗаменыСсылок;
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("ЧтениеXML",ЧтениеXML);
	НеИзменяемыеПараметры.Вставить("СоответствиеЗаменыСсылок",СоответствиеЗаменыСсылок);	
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;	
	Если НЕ ЗаменитьСсылкиНаПредопределенные(НеИзменяемыеПараметры, ИзменяемыеПараметры) Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		//----
		СообщениеОшибки = "Замена ссылок на предопределенные пока не доступна." + Символы.ПС + СообщениеОшибки;
		//---
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	//------> Взято из другой обработки, кажется там вцелом часть про предопределённые кривая. <------
		
	XMLДанных_ЗамененыСсылкиПредопределенных = ?(МодифицируемыеПараметры.Свойство("XMLДанных_ЗамененыСсылкиПредопределенных",XMLДанных_ЗамененыСсылкиПредопределенных),XMLДанных_ЗамененыСсылкиПредопределенных,XMLДанных);
	
	НеИзменяемыеПараметры = новый Структура;
	НеИзменяемыеПараметры.Вставить("СтрокаДанныхXML",XMLДанных_ЗамененыСсылкиПредопределенных);
	НеИзменяемыеПараметры = новый ФиксированнаяСтруктура(НеИзменяемыеПараметры);
	
	ИзменяемыеПараметры = новый Структура;
	
	ЧтениеXML = КиурКлСрв.ПолучитьЧтениеXML(НеИзменяемыеПараметры);
	Если ЧтениеXML = Неопределено Тогда
		СообщениеОшибки = ?(ИзменяемыеПараметры.Свойство("СообщениеОшибки",СообщениеОшибки),СообщениеОшибки,"");
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;
	КонецЕсли; 
	
	//Спускаемся к нужному узлу.
	ЧтениеXML.Прочитать();
	ЧтениеXML.Прочитать();
	
	// чтение и запись в ИБ записанных в выгрузке объектов
	Если Не ЧтениеXML.Прочитать() Тогда 
		СообщениеОшибки = "Неверный формат файла выгрузки";
		МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
		Возврат Ложь;		
	КонецЕсли;
	
	СообщениеПользователю = "Начало загрузки: " + ТекущаяДатаСеанса();
	СообщитьПользователю(СообщениеПользователю);
	
	СериализаторXDTOСАннотациейТипов = ИнициализироватьСериализаторXDTOСАннотациейТипов();
	Загружено = 0;
	//---------
	Пока СериализаторXDTOСАннотациейТипов.ВозможностьЧтенияXML(ЧтениеXML) Цикл
		
		Попытка
			ЗаписанноеЗначение = СериализаторXDTOСАннотациейТипов.ПрочитатьXML(ЧтениеXML);
		Исключение
			Если ВключитьВозможностьРедактированияИспользованияИтогов Тогда
				ВосстановитьИспользованиеИтогов(ИспользующиеИтоги);
			КонецЕсли;	
			
			СообщениеОшибки = ОписаниеОшибки(); 
			МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
			Возврат Ложь;
		КонецПопытки;
		
		Если ПриЗагрузкеИспользоватьРежимОбменаДанными Тогда
			
			Попытка // Планы обмена свойства ОбменДанными не имеют
				ЗаписанноеЗначение.ОбменДанными.Загрузка = Истина;
			Исключение
				СообщениеПользователю = "Возникли проблемы при установке РежимаОбменаДанными.Загрузка";
				СообщениеПользователю = СообщениеПользователю + ОписаниеОшибки();
				СообщитьПользователю(СообщениеПользователю);				
			КонецПопытки;
			
		КонецЕсли;
		
		Попытка
			ЗаписанноеЗначение.Записать();
		Исключение
			
			ТекстОшибки = ОписаниеОшибки();
			
			Если НЕ ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки Тогда
				
				Если ВключитьВозможностьРедактированияИспользованияИтогов Тогда
					ВосстановитьИспользованиеИтогов(ИспользующиеИтоги);
				КонецЕсли;
				
				СообщениеОшибки = "Не удалось записать объект, по причине:" + Символы.ПС;
				СообщениеОшибки = СообщениеОшибки + ТекстОшибки; 
				МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
				Возврат Ложь;				
				
			Иначе
				
				Попытка
					ТекстСообщения = Нстр("ru = 'При загрузке объекта %1(%2) возникла ошибка:
						|%3'");
					ТекстСообщения = КиурКлСрв.ПодставитьПараметрыВСтроку(ТекстСообщения, ЗаписанноеЗначение, ТипЗнч(ЗаписанноеЗначение), ТекстОшибки);
				Исключение
					ТекстСообщения = Нстр("ru = 'При загрузке данных возникла ошибка:
						|%1'");
					ТекстСообщения = КиурКлСрв.ПодставитьПараметрыВСтроку(ТекстСообщения, ТекстОшибки);
				КонецПопытки;
				
				СообщитьПользователю(ТекстСообщения);
				
			КонецЕсли;
			
			Загружено = Загружено - 1;
			
		КонецПопытки;	
		
		Загружено = Загружено + 1;
		
	КонецЦикла;
	//------------
	Если ВключитьВозможностьРедактированияИспользованияИтогов Тогда
		ВосстановитьИспользованиеИтогов(ИспользующиеИтоги);
	КонецЕсли;
	
	//Проверки корректности окончания файла XML. в конце. Мы уже всё загрузили в БД, транзакций не было.
	//Смысл в возвратах?...
	
	// проверка формата файла обмена
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента
		Или ЧтениеXML.ЛокальноеИмя <> "Data" Тогда
		
		СообщитьПользователю(Нстр("ru = 'Неверный формат файла выгрузки'"));
		//Возврат;
		
	КонецЕсли;
	
	Если Не ЧтениеXML.Прочитать()
		Или ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
		Или ЧтениеXML.ЛокальноеИмя <> "PredefinedData" Тогда
		
		СообщитьПользователю(Нстр("ru = 'Неверный формат файла выгрузки'"));
		//Возврат;
		
	КонецЕсли;
	
	ЧтениеXML.Пропустить();
	
	Если Не ЧтениеXML.Прочитать()
		Или ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента
		Или ЧтениеXML.ЛокальноеИмя <> "_1CV8DtUD"
		Или ЧтениеXML.URIПространстваИмен <> "http://www.1c.ru/V8/1CV8DtUD/" Тогда
		
		СообщитьПользователю(Нстр("ru = 'Неверный формат файла выгрузки'"));
		//Возврат;
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть();
	
	ШаблонЗагружено = Нстр("ru = 'Загружено объектов: %Количество'");
	СообщениеЗагружено = СтрЗаменить(ШаблонЗагружено, "%Количество", Загружено);
	
	ШаблонОкончание = Нстр("ru = 'Окончание загрузки: %Дата'");
	СообщениеОкончание = СтрЗаменить(ШаблонОкончание, "%Дата", ТекущаяДатаСеанса());
	
	СообщитьПользователю(СообщениеЗагружено);
	СообщитьПользователю(СообщениеОкончание);
	СообщитьПользователю(Нстр("ru = 'Загрузка данных успешно завершена'"));	
	
	Возврат Истина; 	
КонецФункции

Функция ВосстановитьИспользованиеИтогов(ИспользующиеИтоги)
	Если НЕ ЗначениеЗаполнено(ИспользующиеИтоги) Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Для Каждого Регистр_СДЗ Из ИспользующиеИтоги Цикл
			
		Регистр_СДЗ.ЭлементОписания.Менеджер[Регистр_СДЗ.ОбъектМД.Имя].УстановитьИспользованиеИтогов(Истина);
			
	КонецЦикла;
	
	Возврат Истина;
КонецФункции	 

Функция ИнициализироватьСериализаторXDTOСАннотациейТипов()
	
	ТипыСАннотациейСсылок = ПредопределенныеТипыПриВыгрузке();
	
	Если ТипыСАннотациейСсылок.Количество() > 0 Тогда
		
		Фабрика = ПолучитьФабрикуСУказаниемТипов(ТипыСАннотациейСсылок);
		Возврат Новый СериализаторXDTO(Фабрика);
		
	Иначе
		
		Возврат СериализаторXDTO;
		
	КонецЕсли
	
КонецФункции

// Возвращает фабрику с указанием типов.
//
// Параметры:
//	Типы - ФиксированныйМассив (Метаданные) - массив типов.
//
// Возвращаемое значение:
//	ФабрикаXDTO - фабрика.
//
Функция ПолучитьФабрикуСУказаниемТипов(Знач Типы)
	
	НаборСхем = ФабрикаXDTO.ЭкспортСхемыXML("http://v8.1c.ru/8.1/data/enterprise/current-config");
	Схема = НаборСхем[0];
	Схема.ОбновитьЭлементDOM();
	
	УказанныеТипы = Новый Соответствие;
	Для каждого Тип Из Типы Цикл
		УказанныеТипы.Вставить(XMLТипСсылки(Тип), Истина);
	КонецЦикла;
	
	ПространствоИмен = Новый Соответствие;
	ПространствоИмен.Вставить("xs", "http://www.w3.org/2001/XMLSchema");
	РазыменовательПространствИменDOM = Новый РазыменовательПространствИменDOM(ПространствоИмен);
	ТекстXPath = "/xs:schema/xs:complexType/xs:sequence/xs:element[starts-with(@type,'tns:')]";
	
	Запрос = Схема.ДокументDOM.СоздатьВыражениеXPath(ТекстXPath, РазыменовательПространствИменDOM);
	УстановитьБезопасныйРежим(Истина);
	Результат = Запрос.Вычислить(Схема.ДокументDOM);
	УстановитьБезопасныйРежим(Ложь);

	Пока Истина Цикл
		
		УзелПоля = Результат.ПолучитьСледующий();
		Если УзелПоля = Неопределено Тогда
			Прервать;
		КонецЕсли;
		АтрибутТип = УзелПоля.Атрибуты.ПолучитьИменованныйЭлемент("type");
		ТипБезNSПрефикса = Сред(АтрибутТип.ТекстовоеСодержимое, СтрДлина("tns:") + 1);
		
		Если УказанныеТипы.Получить(ТипБезNSПрефикса) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		УзелПоля.УстановитьАтрибут("nillable", "true");
		УзелПоля.УдалитьАтрибут("type");
	КонецЦикла;
	
	ЗаписьXML = Новый ЗаписьXML;
	ИмяФайлаСхемы = ПолучитьИмяВременногоФайла("xsd");
	ЗаписьXML.ОткрытьФайл(ИмяФайлаСхемы);
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(Схема.ДокументDOM, ЗаписьXML);
	ЗаписьXML.Закрыть();
	
	Фабрика = СоздатьФабрикуXDTO(ИмяФайлаСхемы);
	
	Попытка
		УдалитьФайлы(ИмяФайлаСхемы);
	Исключение
		СообщениеПользователю = "Возникли проблемы при удалении временного файла Схемы XDTO:" + Символы.ПС;
		СообщениеПользователю = СообщениеПользователю + ОписаниеОшибки();
		СообщитьПользователю(СообщениеПользователю);		
	КонецПопытки;
	
	Возврат Фабрика;
	
КонецФункции

Функция ПредопределенныеТипыПриВыгрузке()
	
	Типы = Новый Массив;
	
	Для Каждого ОбъектМетаданных Из Метаданные.Справочники Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыСчетов Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовХарактеристик Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовРасчета Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	
	Возврат Типы;
	
КонецФункции

Функция ЗаменитьСсылкиНаПредопределенные(Знач ФиксированныеПараметры, МодифицируемыеПараметры)
	//В оригинале идёт работа с файлом, а не XML Строкой. Пока закомменчено
	Возврат Истина;
	
		//ПотокЧтения = Новый ЧтениеТекста(ИмяФайла);
	//
	//ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
	//
	//ПотокЗаписи = Новый ЗаписьТекста(ВременныйФайл);
	//
	//// Константы для разбора текста
	//НачалоТипа = "xsi:type=""v8:";
	//ДлинаНачалаТипа = СтрДлина(НачалоТипа);
	//КонецТипа = """>";
	//ДлинаКонцаТипа = СтрДлина(КонецТипа);
	//
	//ИсходнаяСтрока = ПотокЧтения.ПрочитатьСтроку();
	//Пока ИсходнаяСтрока <> Неопределено Цикл
	//	
	//	ОстатокСтроки = Неопределено;
	//	
	//	ТекущаяПозиция = 1;
	//	ПозицияТипа = Найти(ИсходнаяСтрока, НачалоТипа);
	//	Пока ПозицияТипа > 0 Цикл
	//		
	//		ПотокЗаписи.Записать(Сред(ИсходнаяСтрока, ТекущаяПозиция, ПозицияТипа - 1 + ДлинаНачалаТипа));
	//		
	//		ОстатокСтроки = Сред(ИсходнаяСтрока, ТекущаяПозиция + ПозицияТипа + ДлинаНачалаТипа - 1);
	//		ТекущаяПозиция = ТекущаяПозиция + ПозицияТипа + ДлинаНачалаТипа - 1;
	//		
	//		ПозицияКонцаТипа = Найти(ОстатокСтроки, КонецТипа);
	//		Если ПозицияКонцаТипа = 0 Тогда
	//			Прервать;
	//		КонецЕсли;
	//		
	//		ИмяТипа = Лев(ОстатокСтроки, ПозицияКонцаТипа - 1);
	//		СоответствиеЗамены = СоответствиеЗаменыСсылок.Получить(ИмяТипа);
	//		Если СоответствиеЗамены = Неопределено Тогда
	//			ПозицияТипа = Найти(ОстатокСтроки, НачалоТипа);
	//			Продолжить;
	//		КонецЕсли;
	//		
	//		ПотокЗаписи.Записать(ИмяТипа);
	//		ПотокЗаписи.Записать(КонецТипа);
	//		
	//		ИсходнаяСсылкаXML = Сред(ОстатокСтроки, ПозицияКонцаТипа + ДлинаКонцаТипа, 36);
	//		
	//		НайденнаяСсылкаXML = СоответствиеЗамены.Получить(ИсходнаяСсылкаXML);
	//		
	//		Если НайденнаяСсылкаXML = Неопределено Тогда
	//			ПотокЗаписи.Записать(ИсходнаяСсылкаXML);
	//		Иначе
	//			ПотокЗаписи.Записать(НайденнаяСсылкаXML);
	//		КонецЕсли;
	//		
	//		ТекущаяПозиция = ТекущаяПозиция + ПозицияКонцаТипа - 1 + ДлинаКонцаТипа + 36;
	//		ОстатокСтроки = Сред(ОстатокСтроки, ПозицияКонцаТипа + ДлинаКонцаТипа + 36);
	//		ПозицияТипа = Найти(ОстатокСтроки, НачалоТипа);
	//		
	//	КонецЦикла;
	//	
	//	Если ОстатокСтроки <> Неопределено Тогда
	//		ПотокЗаписи.ЗаписатьСтроку(ОстатокСтроки);
	//	Иначе
	//		ПотокЗаписи.ЗаписатьСтроку(ИсходнаяСтрока);
	//	КонецЕсли;
	//	
	//	ИсходнаяСтрока = ПотокЧтения.ПрочитатьСтроку();
	//	
	//КонецЦикла;
	//
	//ПотокЧтения.Закрыть();
	//ПотокЗаписи.Закрыть();
	//
	//ИмяФайла = ВременныйФайл;

	
	
КонецФункции	

Функция ПрочитатьПредопределенныеЭлементыИзXML(Знач ФиксированныеПараметры, МодифицируемыеПараметры) ЭКСПОРТ
	ЧтениеXML = ФиксированныеПараметры.ЧтениеXML;
	
	ТаблицаПредопределенных = ИнициализироватьТаблицуПредопределенныхДляВыгрузкиЗагрузкиXML();
	
	//--- original---->
	ВременнаяСтрока = ТаблицаПредопределенных.Добавить();
	
	СоответствиеЗаменыСсылок = Новый Соответствие;
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Если ЧтениеXML.ЛокальноеИмя <> "item" Тогда
				
				ВременнаяСтрока.ИмяТаблицы = ЧтениеXML.ЛокальноеИмя;
				
				ТекстЗапроса = 
				"ВЫБРАТЬ
				|	Таблица.Ссылка КАК Ссылка
				|ИЗ
				|	" + ВременнаяСтрока.ИмяТаблицы + " КАК Таблица
				|ГДЕ
				|	Таблица.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных";
				Запрос = Новый Запрос(ТекстЗапроса);
				
			Иначе
				
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					
					ВременнаяСтрока[ЧтениеXML.ЛокальноеИмя] = ЧтениеXML.Значение;
					
				КонецЦикла;
				
				Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", ВременнаяСтрока.ИмяПредопределенныхДанных);
				
				//@skip-check query-in-loop
				РезультатЗапроса = Запрос.Выполнить();
				Если Не РезультатЗапроса.Пустой() Тогда
					
					Выборка = РезультатЗапроса.Выбрать();
					
					Если Выборка.Количество() = 1 Тогда
						
						Выборка.Следующий();
						
						СсылкаВБазе = XMLСтрока(Выборка.Ссылка);
						СсылкаВФайле = ВременнаяСтрока.Ссылка;
						
						Если СсылкаВБазе <> СсылкаВФайле Тогда
							
							XMLТип = XMLТипСсылки(Выборка.Ссылка);
							
							СоответствиеТипа = СоответствиеЗаменыСсылок.Получить(XMLТип);
							
							Если СоответствиеТипа = Неопределено Тогда
								
								СоответствиеТипа = Новый Соответствие;
								СоответствиеТипа.Вставить(СсылкаВФайле, СсылкаВБазе);
								СоответствиеЗаменыСсылок.Вставить(XMLТип, СоответствиеТипа);
								
							Иначе
								
								СоответствиеТипа.Вставить(СсылкаВФайле, СсылкаВБазе);
								
							КонецЕсли;
							
						КонецЕсли;
						
					Иначе
																		
						СообщениеОшибки = НСтр("ru = 'Обнаружено дублирование предопределенных элементов %1 в таблице %2!'");
						СообщениеОшибки = СтрЗаменить(СообщениеОшибки, "%1", ВременнаяСтрока.ИмяПредопределенныхДанных);
						СообщениеОшибки = СтрЗаменить(СообщениеОшибки, "%2", ВременнаяСтрока.ИмяТаблицы);
						МодифицируемыеПараметры.Вставить("СообщениеОшибки",СообщениеОшибки);
						Возврат Ложь;						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	МодифицируемыеПараметры.Вставить("ТаблицаПредопределенных",ТаблицаПредопределенных);
	МодифицируемыеПараметры.Вставить("СоответствиеЗаменыСсылок",СоответствиеЗаменыСсылок);
	Возврат Истина;
КонецФункции

Функция ИнициализироватьТаблицуПредопределенныхДляВыгрузкиЗагрузкиXML()
	ТаблицаПредопределенных = Новый ТаблицаЗначений;
	ТаблицаПредопределенных.Колонки.Добавить("ИмяТаблицы");
	ТаблицаПредопределенных.Колонки.Добавить("Ссылка");
	ТаблицаПредопределенных.Колонки.Добавить("ИмяПредопределенныхДанных");
	Возврат ТаблицаПредопределенных;	
КонецФункции

// Возвращает имя типа, который будет использован в xml файле для указанного объекта метаданных
// Используется при поиске и замене ссылок при загрузке, при модификации схемы current-config при записи
// 
// Параметры:
//  Значение - Объект метаданных или Ссылка
//
// Возвращаемое значение:
//  Строка - Строка вида AccountingRegisterRecordSet.Хозрасчетный, описывающая объект метаданных 
Функция XMLТипСсылки(Знач Значение)
	Если ТипЗнч(Значение) = Тип("ОбъектМетаданных") Тогда
		ОбъектМетаданных = Значение;
		МенеджерОбъекта = МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		Ссылка = МенеджерОбъекта.ПолучитьСсылку();
	Иначе
		ОбъектМетаданных = Значение.Метаданные();
		Ссылка = Значение;
	КонецЕсли;
	
	Если ОбъектОбразуетСсылочныйТип(ОбъектМетаданных) Тогда
		
		Возврат СериализаторXDTO.XMLТипЗнч(Ссылка).ИмяТипа;
		
	Иначе
		
		ТекстИсключения = НСтр("ru = 'Ошибка при определении XMLТипа ссылки для объекта %1: объект не является ссылочным!'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%1", ОбъектМетаданных.ПолноеИмя());
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецФункции

// Возвращает менеджер объекта по полному имени объекта метаданных.
// Ограничение: не обрабатываются точки маршрутов бизнес-процессов.
//
// Параметры:
//  ПолноеИмя - Строка - полное имя объекта метаданных. Пример: "Справочник.Организации".
//
// Возвращаемое значение:
//  СправочникМенеджер, ДокументМенеджер.
// 
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмя)
	
	ЧастиИмени = КиурКлСрв.РазложитьСтрокуВМассивПодстрок(ПолноеИмя);
	
	Если ЧастиИмени.Количество() >= 2 Тогда
		КлассОМ = ЧастиИмени[0];
		ИмяОМ = ЧастиИмени[1];
	КонецЕсли;
	
	Если ВРег(КлассОМ) = "СПРАВОЧНИК" Тогда
		Менеджер = Справочники;
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
	КонецЕсли;
	
	Возврат Менеджер[ИмяОМ];
	
КонецФункции

// Функция определяет имеет ли переданный объект метаданных ссылочный тип
//
// Возврат - Истина, если переданный объект метаданных имеет ссылочный тип, Ложь - противном случае
Функция ОбъектОбразуетСсылочныйТип(ОбъектМД) Экспорт
	
	Если ОбъектМД = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Метаданные.Справочники.Содержит(ОбъектМД)
		ИЛИ Метаданные.Документы.Содержит(ОбъектМД)
		ИЛИ Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМД)
		ИЛИ Метаданные.ПланыСчетов.Содержит(ОбъектМД)
		ИЛИ Метаданные.ПланыВидовРасчета.Содержит(ОбъектМД)
		ИЛИ Метаданные.ПланыОбмена.Содержит(ОбъектМД)
		ИЛИ Метаданные.БизнесПроцессы.Содержит(ОбъектМД)
		ИЛИ Метаданные.Задачи.Содержит(ОбъектМД) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции	

Процедура СообщитьПользователю(Текст)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
	
КонецПроцедуры

#КонецОбласти			
	
	