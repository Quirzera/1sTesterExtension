/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////Обработчики Событий Формы \\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Надпись = Параметры.ТекстПредупреждения;
	Заголовок = ?(Параметры.Свойство("ЗаголовокФормы",Заголовок),Заголовок,"Предупреждение");
	
	ТекущийЭлемент = Элементы.Закрыть;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Активизировать();
КонецПроцедуры


#КонецОбласти


/////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/////////////////////Обработчики Событий Команд\\\\\\\\\\\\\\\\\\\\\\\\\\
//////////////\\\\\\\\\\\\\\\///////////////\\\\\\\\\\\\\\///////////////

#Область КомандыФормы

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

#КонецОбласти

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////Для удаления\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#Область ДляУдаления

#КонецОбласти

//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Для удаления/////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////