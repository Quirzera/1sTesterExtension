
/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////Обработчики Событий Формы \\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивПутейККартинкам = ?(Параметры.Свойство("МассивПутейККартинкам", МассивПутейККартинкам), МассивПутейККартинкам, Неопределено);
	ВсеКартинкиВОдномОкне = ?(Параметры.Свойство("ВсеКартинкиВОдномОкне", ВсеКартинкиВОдномОкне), ВсеКартинкиВОдномОкне, Истина);
	ВыводитьКакHTML_Страницу = ?(Параметры.Свойство("ВыводитьКакHTML_Страницу", ВыводитьКакHTML_Страницу), ВыводитьКакHTML_Страницу, Истина);
	
	Если ТипЗнч(МассивПутейККартинкам) = Тип("Массив") Тогда
		ПутиККартинкам = новый ФиксированныйМассив(МассивПутейККартинкам);
	ИначеЕсли ТипЗнч(МассивПутейККартинкам) = Тип("ФиксированныйМассив") Тогда
		ПутиККартинкам = МассивПутейККартинкам;
	ИначеЕсли ТипЗнч(МассивПутейККартинкам) = Тип("СписокЗначений") Тогда
		ПутиККартинкам = новый ФиксированныйМассив(МассивПутейККартинкам.ВыгрузитьЗначения());
	КонецЕсли;
			
	ИндексТекущейКартинки = ?(НЕ ВсеКартинкиВОдномОкне И ЗначениеЗаполнено(ПутиККартинкам), 0, Неопределено);
	
	Если ЗначениеЗаполнено(ПутиККартинкам) Тогда
		
		масРеквизитовДляДобавления = новый Массив;
		
		Если ВсеКартинкиВОдномОкне Тогда
			
			Для инд = 0 по ПутиККартинкам.ВГраница() Цикл
				ИмяРеквизита = "КартинкаФормы" + Формат(инд, "ЧГ=0");
				нРеквизит = Новый РеквизитФормы(ИмяРеквизита, новый ОписаниеТипов("Строка"),,"");
				масРеквизитовДляДобавления.Добавить(нРеквизит);				
			КонецЦикла;	
			
		Иначе
			
			ИмяРеквизита = "КартинкаФормы";
			нРеквизит = Новый РеквизитФормы(ИмяРеквизита, новый ОписаниеТипов("Строка"),,"");
			масРеквизитовДляДобавления.Добавить(нРеквизит);
			
		КонецЕсли;
		
		ЭтаФорма.ИзменитьРеквизиты(масРеквизитовДляДобавления);
		
		Если ВсеКартинкиВОдномОкне Тогда
			Для инд = 0 по ПутиККартинкам.ВГраница() Цикл
				ИмяРеквизита = "КартинкаФормы" + Формат(инд, "ЧГ=0");
				нЭлемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭтаФорма);
				нЭлемент.Вид = ?(ВыводитьКакHTML_Страницу, ВидПоляФормы.ПолеHTMLДокумента, ВидПоляФормы.ПолеКартинки);
				нЭлемент.ПутьКДанным = ИмяРеквизита;
				нЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
				Если НЕ ВыводитьКакHTML_Страницу Тогда
					нЭлемент.Масштабировать = Истина;
				КонецЕсли;				
			КонецЦикла;			
		Иначе
			ИмяРеквизита = "КартинкаФормы";
			нЭлемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ЭтаФорма);
			нЭлемент.Вид = ?(ВыводитьКакHTML_Страницу, ВидПоляФормы.ПолеHTMLДокумента, ВидПоляФормы.ПолеКартинки);
			нЭлемент.ПутьКДанным = ИмяРеквизита;
			нЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			Если НЕ ВыводитьКакHTML_Страницу Тогда
				нЭлемент.Масштабировать = Истина;
			КонецЕсли;	
		КонецЕсли;	
		
	КонецЕсли;
				
	Элементы.ГруппаКнопкиНавигации.Видимость = НЕ ВсеКартинкиВОдномОкне;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Активизировать();
	
	Если НЕ ЗначениеЗаполнено(ПутиККартинкам) Тогда
		ТранзитныеПараметры = новый Структура("ДопДействие", "Закрыть()");
		КиурКл.ОтобразитьПредупреждение("Не переданы пути к файлам", ЭтаФорма, ТранзитныеПараметры);
	КонецЕсли;
		
	Если ВсеКартинкиВОдномОкне Тогда
		ТранзитныеПараметры = новый Структура();
		
		ТранзитныеПараметры.Вставить("ОшибкиДоступаКФайламКартинок","");
		ТранзитныеПараметры.Вставить("МассивПроверенныхПутейФайлов", новый Массив);
		ТранзитныеПараметры.Вставить("ТекИндексПутиФайла", 0);
		
		ПроверкаСуществованияМассиваФайлов(ТранзитныеПараметры);	
	Иначе
		ВывестиКартинкуВПолеФормы(ИндексТекущейКартинки);	
	КонецЕсли;		
КонецПроцедуры

#КонецОбласти


/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////Обработчики Событий Команд\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область КомандыФормы

&НаКлиенте
Процедура Следующая(Команда)
	ИндексТекущейКартинки = ИндексТекущейКартинки + 1;
	Если ИндексТекущейКартинки > ПутиККартинкам.Вграница() Тогда
		ИндексТекущейКартинки = 0;
	КонецЕсли;
		
	ВывестиКартинкуВПолеФормы(ИндексТекущейКартинки);
КонецПроцедуры

&НаКлиенте
Процедура Предыдущая(Команда)
ИндексТекущейКартинки = ИндексТекущейКартинки - 1;
	Если ИндексТекущейКартинки < 0 Тогда
		ИндексТекущейКартинки = ПутиККартинкам.Вграница();
	КонецЕсли;
		
	ВывестиКартинкуВПолеФормы(ИндексТекущейКартинки);
КонецПроцедуры

#КонецОбласти

/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////Обработчики Событий Элементов\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область ЭлементыФормы

#КонецОбласти

/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////////////////Служебные методы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область Служебные

&НаКлиенте
Процедура ВывестиКартинкуВПолеФормы(ИндексКартинкиВМассиве)
	Если ИндексКартинкиВМассиве = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если ИндексКартинкиВМассиве < 0 ИЛИ ИндексКартинкиВМассиве > ПутиККартинкам.Вграница() Тогда
		Возврат;
	КонецЕсли;
			
	ПутьКФайлу = ПутиККартинкам[ИндексКартинкиВМассиве];
	
	ФайлКартинки = новый Файл(ПутьКФайлу);
	
	ТранзитныеПараметры = новый Структура;
	ТранзитныеПараметры.Вставить("ПутьКФайлу", ПутьКФайлу);
	ОповещениеПроверкиФайла = новый ОписаниеОповещения("ВывестиКартинкуВПолеФормы_ПровереноСуществованиеФайла", ЭтаФорма, ТранзитныеПараметры);
	
	ФайлКартинки.НачатьПроверкуСуществования(ОповещениеПроверкиФайла);
КонецПроцедуры	

&НаКлиенте
Процедура ВывестиКартинкуВПолеФормы_ПровереноСуществованиеФайла(ФайлСуществует, ТранзитныеПараметры) ЭКСПОРТ
	
	ПутьКФайлу = ТранзитныеПараметры.ПутьКФайлу;
	
	Если НЕ ФайлСуществует Тогда
		ТекстПредупреждения = "По указанному пути отсутствует файл." + Символы.ПС;
		ТекстПредупреждения = ТекстПредупреждения + ПутьКФайлу + Символы.ПС;
		КиурКл.ОтобразитьПредупреждение(ТекстПредупреждения, ЭтаФорма);
		Возврат;
	КонецЕсли;
		
	ПутьКФайлу = СтрЗаменить(ПутьКФайлу, "\", "/");
	
	Если ВыводитьКакHTML_Страницу Тогда
		ЭтаФорма["КартинкаФормы"] = КиурКлСрв.ПолучитьТекстHTML_ФайлаКартинки(ПутьКФайлу);	
	Иначе
		ОписаниеФайла = новый ОписаниеПередаваемогоФайла(ПутьКФайлу);
		
		масОписанийФайлов = новый Массив;
		масОписанийФайлов.Добавить(ОписаниеФайла);
		
		ОповещениеПомещенияФайлов = новый ОписаниеОповещения("Помещены_ПутиККартинкам", ЭтаФорма);
		НачатьПомещениеФайлов(ОповещениеПомещенияФайлов, масОписанийФайлов, Ложь, УникальныйИдентификатор);		
	КонецЕсли;			
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСуществованияМассиваФайлов(ТранзитныеПараметры) ЭКСПОРТ
	
	МассивПроверенныхПутейФайлов = ТранзитныеПараметры.МассивПроверенныхПутейФайлов;
	ОшибкиДоступаКФайламКартинок = ТранзитныеПараметры.ОшибкиДоступаКФайламКартинок;
	ТекИндексПутиФайла = ТранзитныеПараметры.ТекИндексПутиФайла;
	
	Если ТекИндексПутиФайла > ПутиККартинкам.Вграница() Тогда
		
		ИтоговыеПараметры = новый Структура;
		ИтоговыеПараметры.Вставить("МассивПроверенныхПутейФайлов", МассивПроверенныхПутейФайлов);
		ИтоговыеПараметры.Вставить("ОшибкиДоступаКФайламКартинок", ОшибкиДоступаКФайламКартинок);
		ИтоговыеПараметры = новый ФиксированнаяСтруктура(ИтоговыеПараметры);
		
		ПроверкаСуществованияМассиваФайлов_Завершена(ИтоговыеПараметры);
		Возврат;
	КонецЕсли;
		
	ТранзитныеПараметры = новый Структура;
	ТранзитныеПараметры.Вставить("МассивПроверенныхПутейФайлов", МассивПроверенныхПутейФайлов);
	ТранзитныеПараметры.Вставить("ОшибкиДоступаКФайламКартинок", ОшибкиДоступаКФайламКартинок);
	ТранзитныеПараметры.Вставить("ТекИндексПутиФайла", ТекИндексПутиФайла);	
	
	ОповещениеПроверкиФайла = новый ОписаниеОповещения("ПроверкаСуществованияМассиваФайлов_ПровереноСуществованиеФайла", ЭтаФорма, ТранзитныеПараметры);
	
	ПутьКФайлу = ПутиККартинкам[ТекИндексПутиФайла];
	ФайлКартинки = новый Файл(ПутьКФайлу);
	ФайлКартинки.НачатьПроверкуСуществования(ОповещениеПроверкиФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияМассиваФайлов_ПровереноСуществованиеФайла(ФайлСуществует, ТранзитныеПараметры) ЭКСПОРТ
	
	ПутьКФайлу = ПутиККартинкам[ТранзитныеПараметры.ТекИндексПутиФайла];
	
	Если ФайлСуществует Тогда
		ТранзитныеПараметры.МассивПроверенныхПутейФайлов.Добавить(ПутьКФайлу);
	Иначе
		ТранзитныеПараметры.ОшибкиДоступаКФайламКартинок = ТранзитныеПараметры.ОшибкиДоступаКФайламКартинок + Символы.ПС + "Не удалось получить доступ к файлу: ";
		ТранзитныеПараметры.ОшибкиДоступаКФайламКартинок = ТранзитныеПараметры.ОшибкиДоступаКФайламКартинок + Символы.ПС + ПутьКФайлу;		
	КонецЕсли;

	ТранзитныеПараметры.ТекИндексПутиФайла = ТранзитныеПараметры.ТекИндексПутиФайла + 1;
	ПроверкаСуществованияМассиваФайлов(ТранзитныеПараметры);	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСуществованияМассиваФайлов_Завершена(НеМодифицируемыеПараметры, МодифицируемыеПараметры = Неопределено) ЭКСПОРТ
	
	Если ТИпЗнч(МодифицируемыеПараметры) <> Тип("Структура") Тогда
		МодифицируемыеПараметры = новый Структура();
	КонецЕсли;
	
	МассивПроверенныхПутейФайлов = НеМодифицируемыеПараметры.МассивПроверенныхПутейФайлов;
	ОшибкиДоступаКФайламКартинок = НеМодифицируемыеПараметры.ОшибкиДоступаКФайламКартинок;
	
	масОписанийФайлов = новый Массив;
	
	Для инд = 0 по МассивПроверенныхПутейФайлов.Вграница() Цикл
		
		ПутьКФайлу = МассивПроверенныхПутейФайлов[инд];
		ПутьКФайлу = СтрЗаменить(ПутьКФайлу, "\","/");
		
		Если ВыводитьКакHTML_Страницу Тогда
			ЭтаФорма["КартинкаФормы" + Формат(инд, "ЧГ=0")] = КиурКлСрв.ПолучитьТекстHTML_ФайлаКартинки(ПутьКФайлу);
		Иначе
			ОписаниеФайла = новый ОписаниеПередаваемогоФайла(ПутьКФайлу);
			масОписанийФайлов.Добавить(ОписаниеФайла);
		КонецЕсли;		
	КонецЦикла;	
		
	Если ЗначениеЗаполнено(ОшибкиДоступаКФайламКартинок) Тогда
		КиурКл.ОтобразитьПредупреждение(ОшибкиДоступаКФайламКартинок, ЭтаФорма);
	КонецЕсли;
		
	Если НЕ ВыводитьКакHTML_Страницу Тогда
		ОповещениеПомещенияФайлов = новый ОписаниеОповещения("Помещены_ПутиККартинкам", ЭтаФорма);
		НачатьПомещениеФайлов(ОповещениеПомещенияФайлов, масОписанийФайлов, Ложь, УникальныйИдентификатор);
	КонецЕсли;		
	
	
КонецПроцедуры

&НаКлиенте
Процедура Помещены_ПутиККартинкам(МассивФайловВоВременномХранилище, ТранзитныеПараметры) ЭКСПОРТ
	Если НЕ ЗначениеЗаполнено(МассивФайловВоВременномХранилище) Тогда
		Возврат;
	КонецЕсли;
		
	Для инд = 0 по МассивФайловВоВременномХранилище.ВГраница()  Цикл
		ЭтаФорма["КартинкаФормы" + Формат(инд, "ЧГ=0")] = МассивФайловВоВременномХранилище[инд].Хранение;
	КонецЦикла;
		
	ЭтаФорма.ТекущийЭлемент = Элементы.КартинкаФормы;
КонецПроцедуры
		

#КонецОбласти

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////Для удаления\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#Область ДляУдаления

#КонецОбласти

//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Для удаления/////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////