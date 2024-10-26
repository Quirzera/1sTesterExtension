
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаголовокФормы = ?(Параметры.Свойство("ЗаголовокФормы",ЗаголовокФормы),ЗаголовокФормы,"");
	ЭтаФорма.Заголвок = ЗаголовокФормы;
	ВыводТабличногоДокумента = Параметры.ВыводТабличногоДокумента;
	ХранилищеРасшифровок = ?(Параметры.Свойство("ХранилищеРасшифровок",ХранилищеРасшифровок),ХранилищеРасшифровок,Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыводТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;	
	Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		//@skip-check transfer-object-between-client-server
		ЗначРасшифровки = ПолучитьЗначениеРасшифровки(Расшифровка,ХранилищеРасшифровок);
		ПоказатьЗначение(,ЗначРасшифровки);
		Возврат;
	ИначеЕсли ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		//Заготовка для открытия результат отчёта вместо дополнительной расшифровеи. Закоменчены примеры конкретной реализации, надо сделать
		//что-то более универсальное. Общий смысл - получаем параметры открытия этой же формы из какой-то схемы компоновки данных(т.е. по сути програмно формируем отчет) и открываем ещё раз эту же форму:
		// Т.е. то что должно вернуться из цепочки методов формирования отчета по скд:
		// обСрв.ПолучитьСтруктуруРезультатаВыполненияОтчетаИзСКД_ИзВнешнейТаблицы(СтруктураПараметров);

		ДействиеРасшифровки = ?(Расшифровка.Свойство("ДействиеРасшифровки",ДействиеРасшифровки),ДействиеРасшифровки,"");
		
		Если ДействиеРасшифровки = "РазвернутьНоменклатуруПо_ВЗ" Тогда
	//		СтруктураТабДокаСКД = ПолучитьСтруктуруТабДокаДляНомеклатурыВ_РазрезеВЗ(Расшифровка.СВЗ,Расшифровка.Номенклатура);
	//		ОткрытьФорму("Документ.СводнаяЗаявкаВнутреннихЗаказовМенеджеров.Форма.ФормаПечати",СтруктураТабДокаСКД,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//		Возврат;
		ИначеЕсли ДействиеРасшифровки = "РазвернутьНоменклатуруПо_СВЗ" Тогда
	//		СтруктураТабДокаСКД = ПолучитьСтруктуруТабДокаДляНомеклатурыВ_РазрезеСВЗ(Расшифровка.ПЗ,Расшифровка.Номенклатура);
	//		ОткрытьФорму("Документ.СводнаяЗаявкаВнутреннихЗаказовМенеджеров.Форма.ФормаПечати",СтруктураТабДокаСКД,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//		Возврат;
		КонецЕсли;
	Иначе
		ПоказатьЗначение(,Расшифровка);
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыводТабличногоДокументаОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРасшифровки(ИдентификаторРасшифровки,ХранилищеРасшифровок)
	ДанныеРасшифровки = ХранилищеРасшифровок.Получить();
	ЗначениеРасшифровки = Неопределено;
		
	МассивПолейРасшифровки = ДанныеРасшифровки.Элементы[ИдентификаторРасшифровки].ПолучитьПоля();
	Для Каждого ЭлементМассива Из МассивПолейРасшифровки Цикл
		ТипЗначения = ТипЗнч(ЭлементМассива.Значение);
		Если ТипЗнч(ЭлементМассива) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") И ЭлементМассива.Иерархия = Ложь Тогда
			ЗначениеРасшифровки = ЭлементМассива.Значение;
			Прервать;
		КонецЕсли;		
	КонецЦикла;	
	
	Возврат ЗначениеРасшифровки;	
КонецФункции


