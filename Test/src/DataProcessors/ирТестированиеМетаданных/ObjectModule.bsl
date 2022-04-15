//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мНепустыеЗначения Экспорт ;
Перем мПлатформа Экспорт;
Перем мТекущееПолноеИмяМД Экспорт;

Функция ДобавитьСтрокуОшибкиЛкс(ИмяОперации, Знач пИнформацияОбОшибке, ГлубинаОшибки = 0, Контекст = "КлиентскоеПриложение") Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    пИнформацияОбОшибке = ИнформацияОбОшибке();
	#КонецЕсли
	Если ГлубинаОшибки = 1 Тогда
		Если Истина
			И пИнформацияОбОшибке.Причина <> Неопределено 
			И пИнформацияОбОшибке.Причина.Причина <> Неопределено 
		Тогда
			пИнформацияОбОшибке = пИнформацияОбОшибке.Причина;
		КонецЕсли; 
	КонецЕсли; 
	Фрагменты = ирОбщий.СтрРазделитьЛкс(ИмяОперации);
	СтрокаРезультатов = Ошибки.Добавить();
	СтрокаРезультатов.Контекст = Контекст;
	СтрокаРезультатов.Операция = Фрагменты[Фрагменты.ВГраница()];
	Фрагменты.Удалить(Фрагменты.ВГраница());
	Если Фрагменты.Количество() = 3 И Фрагменты[Фрагменты.ВГраница()] = "Форма" Тогда
		СтрокаРезультатов.Операция = "Форма." + СтрокаРезультатов.Операция;
		Фрагменты.Удалить(Фрагменты.ВГраница());
	КонецЕсли; 
	СтрокаРезультатов.Метаданные = ирОбщий.СтрСоединитьЛкс(Фрагменты, ".");
	СтрокаРезультатов.ПодробноеОписаниеОшибки = ирОбщий.ПодробноеПредставлениеОшибкиЛкс(пИнформацияОбОшибке);
	ОписаниеОшибки = пИнформацияОбОшибке.Описание;
	Если пИнформацияОбОшибке.Причина <> Неопределено Тогда
		ОписаниеОшибки = ОписаниеОшибки + ": " + ирОбщий.ПодробноеПредставлениеОшибкиЛкс(пИнформацияОбОшибке.Причина);
	КонецЕсли; 
	СтрокаРезультатов.ОписаниеОшибки = ОписаниеОшибки;
	СтрокаРезультатов.ИнформацияОбОшибке = пИнформацияОбОшибке;
	Возврат СтрокаРезультатов;
	
КонецФункции

Функция ГлобальныйТестОбъектов(ЭтаФорма = Неопределено) Экспорт
	
	#Если ВнешнееСоединение Тогда
		СбойноеИмяМД = мТекущееПолноеИмяМД;
	#КонецЕсли
	ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
	ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТипыМетаданных.Количество(), "Объекты. Типы метаданных");
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
		Если ирОбщий.ЛиКорневойТипРегистраБДЛкс(СтрокаТипаМетаданных.Единственное) Тогда
			Подтип = "НаборЗаписей";
		ИначеЕсли СтрокаТипаМетаданных.Единственное = "Константа" Тогда 
			Подтип = "МенеджерЗначения";
		Иначе //Если ирОбщий.ЛиКорневойТипСсылкиЛкс(СтрокаТипаМетаданных.Единственное) Тогда
			Подтип = "Объект";
		КонецЕсли; 
		Если Ложь
			//Или СтрокаТипаМетаданных.Единственное = "ПланОбмена" // Временно. Антибаг платформы 8.2.16.352 http://partners.v8.1c.ru/forum/thread.jsp?id=1080147#1080147
			Или СтрокаТипаМетаданных.Единственное = "Перечисление"
			Или СтрокаТипаМетаданных.Единственное = "Перерасчет"
		Тогда
			Продолжить;
		КонецЕсли; 
		КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
		Индикатор2 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор2);
			КоличествоОшибок = Ошибки.Количество();
			мТекущееПолноеИмяМД = МетаОбъект.ПолноеИмя();
			#Если ВнешнееСоединение Тогда
				Если СбойноеИмяМД <> Неопределено Тогда 
					Если СбойноеИмяМД = мТекущееПолноеИмяМД Тогда
						СбойноеИмяМД = Неопределено;
					КонецЕсли; 
					Продолжить;
				КонецЕсли; 
			#КонецЕсли
			Если Истина
				И ОбъектыМетаданных.Количество() > 0
				И ОбъектыМетаданных.НайтиПоЗначению(мТекущееПолноеИмяМД) = Неопределено
			Тогда
				Продолжить;
			КонецЕсли; 
			ИмяОперации = мТекущееПолноеИмяМД + ".Объект";
			Если ВыводитьСообщения Тогда
				ирОбщий.СообщитьЛкс("" + ТекущаяДата() + " " + ИмяОперации);
			КонецЕсли; 
			Попытка
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(мТекущееПолноеИмяМД); // Ошибки инициализации здесь все равно не ловятся попыткой. Проектное решение 1С https://partners.v8.1c.ru/forum/t/1302121/m/1302121 
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ОписаниеОшибки = ИнформацияОбОшибке.Описание;
				Если Найти(ОписаниеОшибки, "Тип не определен") <> 1 Тогда
					ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке, 1);
				КонецЕсли; 
				Продолжить;
			КонецПопытки; 
			НачатьТранзакцию();
			Попытка
				Если Подтип = "Объект" Тогда
					МенеджерТипа = ирОбщий.ПолучитьМенеджерЛкс(МетаОбъект);
					Если ирОбщий.ЛиКорневойТипСсылкиЛкс(СтрокаТипаМетаданных.Единственное) Тогда
						ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1 Т.Ссылка ИЗ " + МетаОбъект.ПолноеИмя() + " КАК Т";
						МассивТиповСтрок = Новый Массив;
						МассивТиповСтрок.Добавить(Ложь);
						Если ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(МетаОбъект) Тогда
							ТекстЗапроса = ТекстЗапроса + " ГДЕ Т.ЭтоГруппа = &ЭтоГруппа";
							МассивТиповСтрок.Добавить(Истина);
						КонецЕсли; 
						Запрос = Новый Запрос(ТекстЗапроса);
						Для Каждого ТипСтроки Из МассивТиповСтрок Цикл
							Если ПравоДоступа("Изменение", МетаОбъект) Тогда
								Запрос.УстановитьПараметр("ЭтоГруппа", ТипСтроки);
								Выборка = Запрос.Выполнить().Выбрать();
								Если Выборка.Следующий() Тогда 
									СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(мТекущееПолноеИмяМД, Выборка.Ссылка);
									ПроверитьСсылочныйОбъект(СтруктураОбъекта, ИмяОперации, СтрокаТипаМетаданных.Единственное);
									Если ПравоДоступа("Добавление", МетаОбъект) Тогда
										КопияОбъекта = СтруктураОбъекта.Методы.Скопировать();
										ПроверитьСсылочныйОбъект(КопияОбъекта, ИмяОперации, СтрокаТипаМетаданных.Единственное, Истина);
									КонецЕсли; 
								КонецЕсли;
							КонецЕсли; 
							Если ПравоДоступа("Добавление", МетаОбъект) Тогда
								СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(мТекущееПолноеИмяМД, ТипСтроки);
								ЗаполнитьРеквизитыНепустымиЗначениями(СтруктураОбъекта.Данные, МетаОбъект);
								СтруктураОбъекта.Методы.Скопировать();
								Если ПравоДоступа("Изменение", МетаОбъект) Тогда
									ПроверитьСсылочныйОбъект(СтруктураОбъекта, ИмяОперации, СтрокаТипаМетаданных.Единственное, Истина);
								КонецЕсли; 
							КонецЕсли; 
						КонецЦикла;
					КонецЕсли; 
				ИначеЕсли Подтип = "НаборЗаписей" Тогда
					Если ПравоДоступа("Изменение", МетаОбъект) Тогда
						МенеджерТипа = ирОбщий.ПолучитьМенеджерЛкс(МетаОбъект); // Создаем чисто для проверки компиляции модуля менеджера
						СтрокаНабора = СтруктураОбъекта.Данные.Добавить();
						ЗаполнитьРеквизитыНепустымиЗначениями(СтрокаНабора, МетаОбъект);
						Для Каждого ЭлементОтбора Из СтруктураОбъекта.Методы.Отбор Цикл
							ЭлементОтбора.Установить(СтрокаНабора[ЭлементОтбора.Имя]);
						КонецЦикла;
						ирОбщий.ЗаполнитьНаборЗаписейПоОтборуЛкс(СтруктураОбъекта);
						Попытка
							ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы);
						Исключение
							ОтменитьТранзакцию();
							Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
								ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке(), 1);
							КонецЕсли; 
							НачатьТранзакцию();
						КонецПопытки;
					КонецЕсли; 
				Иначе
					Если ПравоДоступа("Изменение", МетаОбъект) Тогда
						Попытка
							ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы);
						Исключение
							ОтменитьТранзакцию();
							Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
								ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке(), 1);
							КонецЕсли; 
							НачатьТранзакцию();
						КонецПопытки;
					КонецЕсли; 
				КонецЕсли; 
			Исключение
				// Сюда попадаем при ошибках не при записи
				ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке());
			КонецПопытки;
			ОтменитьТранзакцию();
			Если ЭтаФорма <> Неопределено Тогда
				Если КоличествоОшибок <> Ошибки.Количество() Тогда
					ЭтаФорма.ОбновитьОтображение();
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	
КонецФункции

Функция ПроверитьСсылочныйОбъект(Знач СтруктураОбъекта, ИмяОперации, ТипМетаданных, ЭтоКопия = Ложь) Экспорт

	Объект = СтруктураОбъекта.Данные;
	Если ЭтоКопия Тогда
		НовыйКод = 333333333333;
		Попытка
			Объект.Код = НовыйКод;
		Исключение
		КонецПопытки; 
		НоваяДата = ПолучитьНепустоеЗначениеПоОписаниюТипов(Новый ОписаниеТипов("Дата"));
		Попытка
			Объект.Дата = НоваяДата;
		Исключение
		КонецПопытки; 
	КонецЕсли;
	Попытка
		Объект.ПометкаУдаления = Ложь;
	Исключение
		// Предопределенный узел
	КонецПопытки;
	ОбразОбъекта = СтруктураОбъекта.Методы.Снимок();
	Попытка
		ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы);
	Исключение
		ОтменитьТранзакцию();
		Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
			ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке(), 1);
		КонецЕсли; 
	КонецПопытки;
	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли; 
	СтруктураОбъекта.Методы.ЗагрузитьСнимок(ОбразОбъекта);
	НачатьТранзакцию();
	//ФормаОбъекта = Объект.ПолучитьФорму();
	//ФормаОбъекта.ЗаписатьВФорме();
	ОбъектМД = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(СтруктураОбъекта));
	Если ТипМетаданных = "Документ" И ОбъектМД.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
		СтруктураОбъекта.Данные.Проведен = Ложь;
		Попытка
			ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы,, РежимЗаписиДокумента.Проведение);
		Исключение
			ОтменитьТранзакцию();
			Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
				ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке(), 1);
			КонецЕсли; 
		КонецПопытки;
		Если ТранзакцияАктивна() Тогда
			//Объект = ирОбщий.ОбъектИзСтрокиXMLЛкс(ОбразОбъекта,, Ложь);
			//Объект.Проведен = Истина;
			Попытка
				ирОбщий.ЗаписатьОбъектЛкс(СтруктураОбъекта.Методы,, РежимЗаписиДокумента.ОтменаПроведения);
			Исключение
				ОтменитьТранзакцию();
				Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
					ДобавитьСтрокуОшибкиЛкс(ИмяОперации, ИнформацияОбОшибке(), 1);
				КонецЕсли; 
			КонецПопытки;
		КонецЕсли; 
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли; 
		СтруктураОбъекта.Методы.ЗагрузитьСнимок(ОбразОбъекта);
		СтруктураОбъекта.Данные.Проведен = Ложь;
		НачатьТранзакцию();
	КонецЕсли; 
	//Попытка
	//	Объект.ПометкаУдаления = Истина;
	//Исключение
	//	Возврат Неопределено;
	//КонецПопытки; 
	//Попытка
	//	ирОбщий.ЗаписатьОбъектЛкс(Объект);
	//Исключение
	//	ОтменитьТранзакцию();
	//	ОписаниеОшибки = ОписаниеОшибки();
	//	Если Не ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки()) Тогда 
	//		ДобавитьСтрокуОшибки(ИмяОперации, ИнформацияОбОшибке(), 1);
	//	КонецЕсли; 
	//КонецПопытки;
	//Если ТранзакцияАктивна() Тогда
	//	ОтменитьТранзакцию();
	//КонецЕсли; 
	//НачатьТранзакцию();
	Возврат Неопределено;

КонецФункции

Функция ЗаполнитьРеквизитыНепустымиЗначениями(Объект, ОбъектМД, Назначение = "Основная", ОбъектВладелец = Неопределено) Экспорт
	
	ПолноеИмяМД = ОбъектМД.ПолноеИмя();
	ПоляТаблицыБД = ирОбщий.ПоляТаблицыМДЛкс(ПолноеИмяМД,,,, Ложь);
	#Если Сервер И Не Сервер Тогда
	    ПоляТаблицыБД = НайтиПоСсылкам().Колонки;
	#КонецЕсли
	Для Каждого ПолеТаблицыБД Из ПоляТаблицыБД Цикл
		ИмяПоля = ПолеТаблицыБД.Имя;
		Если Истина
			И ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(ОбъектМД)
			И (Ложь
				Или ИмяПоля = "Предопределенный" 
				Или ИмяПоля = "ИмяПредопределенныхДанных" 
				Или ИмяПоля = "Ссылка"
				Или ИмяПоля = "ВерсияДанных"
				Или (Истина
					И ИмяПоля = "ЭтотУзел"
					И Метаданные.ПланыОбмена.Содержит(ОбъектМД)))
		Тогда
			Продолжить;
		КонецЕсли;
		Если ПолеТаблицыБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			МетаТЧ = ОбъектМД.ТабличныеЧасти.Найти(ПолеТаблицыБД.Имя);
			Если МетаТЧ <> Неопределено Тогда
				Попытка
					СтрокаТЧ = Объект[МетаТЧ.Имя].Добавить();
				Исключение
					СтрокаТЧ = Неопределено;
				КонецПопытки; 
				Если СтрокаТЧ <> Неопределено Тогда
					ЗаполнитьРеквизитыНепустымиЗначениями(СтрокаТЧ, МетаТЧ, "ТабличнаяЧасть", Объект);
				КонецЕсли; 
			КонецЕсли; 
			Продолжить;
		КонецЕсли; 
		НепустоеЗначение = Неопределено;
		СтруктураОтбора = Неопределено;
		//СтрокаСтрукутрыПоля = СтруктураХраненияПолей.Найти(ИмяПоля, "ИмяПоля");
		//Если СтрокаСтрукутрыПоля <> Неопределено Тогда
		//	МетаданныеПоля = СтрокаСтрукутрыПоля.Метаданные;
		//	Если ЗначениеЗаполнено(МетаданныеПоля) Тогда
		//		МетаданныеПоля = ирКэш.ОбъектМДПоПолномуИмениЛкс(МетаданныеПоля);
		//	Иначе
		//		МетаданныеПоля = Неопределено;
		//	КонецЕсли;
			МетаданныеПоля = ПолеТаблицыБД.Метаданные;
			Если МетаданныеПоля <> Неопределено Тогда
				Попытка
					НепустоеЗначение = МетаданныеПоля.ЗначениеЗаполнения; // У измерений и ресурсов нет такого свойства
					ЗначениеЗаполнено(НепустоеЗначение); // Там бывает "НеизвестныйОбъект", тогда будет исключение
				Исключение
					НепустоеЗначение = Неопределено;
				КонецПопытки; 
			КонецЕсли; 
			СтруктураОтбора = Новый Структура;
			Если МетаданныеПоля <> Неопределено И Не ЗначениеЗаполнено(НепустоеЗначение) Тогда
				Если ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(Назначение) Тогда
					СтруктураТЧ = Новый Структура(ирОбщий.ПоследнийФрагментЛкс(ПолноеИмяМД), Объект);
					ОсновныеДанные = ОбъектВладелец;
				Иначе
					СтруктураТЧ = Неопределено;
					ОсновныеДанные = Объект;
				КонецЕсли; 
				СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ОсновныеДанные, МетаданныеПоля, СтруктураТЧ);
			КонецЕсли; 
			Если Истина
				И ИмяПоля = "Родитель" 
				И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
			Тогда
				СтруктураОтбора.Вставить("ЭтоГруппа", Истина);
			КонецЕсли;
			Если Истина
				И ИмяПоля = "Родитель" 
				И Найти(ПолноеИмяМД, "Справочник.") = 1
				И ОбъектМД.Владельцы.Количество() > 0
			Тогда
				СтруктураОтбора.Вставить("Владелец", Объект.Владелец);
			КонецЕсли;
			Если СтруктураОтбора.Количество() = 0 Тогда
				СтруктураОтбора = Неопределено;
			КонецЕсли; 
		//КонецЕсли; 
		Если Не ЗначениеЗаполнено(НепустоеЗначение) Или СтруктураОтбора <> Неопределено Тогда
			НепустоеЗначение = ПолучитьНепустоеЗначениеПоОписаниюТипов(ПолеТаблицыБД.ТипЗначения, СтруктураОтбора);
		КонецЕсли; 
		Попытка
			Объект[ИмяПоля] = НепустоеЗначение;
		Исключение
		КонецПопытки; 
	КонецЦикла; 
	
КонецФункции

Функция ПолучитьНепустоеЗначениеПоОписаниюТипов(ОписаниеТипов, СтруктураОтбора = Неопределено) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    ОписаниеТипов = Новый ОписаниеТипов();
	#КонецЕсли
	Типы = ОписаниеТипов.Типы();
	Если Типы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Для Каждого Тип Из ОписаниеТипов.Типы() Цикл
		Если ирОбщий.ЛиТипСсылкиБДЛкс(Тип, Ложь) Тогда
			ВыбранныйТипЗначения = Тип;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Если ВыбранныйТипЗначения = Неопределено Тогда
		ВыбранныйТипЗначения = Типы[0];
	КонецЕсли; 
	МетаданныеТипа = Метаданные.НайтиПоТипу(ВыбранныйТипЗначения);
	Если МетаданныеТипа <> Неопределено Тогда 
		ИмяТаблицыБД = МетаданныеТипа.ПолноеИмя();
		Если ирОбщий.ЛиТипСсылкиТочкиМаршрутаЛкс(ВыбранныйТипЗначения) Тогда
			ИмяТаблицыБД = ИмяТаблицыБД + "." + ирОбщий.ПеревестиСтроку("Точки");
		КонецЕсли; 
		Если СтруктураОтбора <> Неопределено Или СтрЧислоВхождений(ИмяТаблицыБД, ".") > 1 Тогда
			ПостроительЗапроса = Новый ПостроительЗапроса("ВЫБРАТЬ ПЕРВЫЕ 1 Т.* ИЗ " + ИмяТаблицыБД + " КАК Т");
			ПостроительЗапроса.ЗаполнитьНастройки();
			//Пока ПостроительЗапроса.Отбор.Количество() > 0 Цикл
			//	ПостроительЗапроса.Отбор.Удалить(0);
			//КонецЦикла; 
			ПостроительЗапроса.ВыбранныеПоля.Очистить();
			ПостроительЗапроса.ВыбранныеПоля.Добавить("Ссылка");
			//ирОбщий.УстановитьОтборПоСтруктуреЛкс(ПостроительЗапроса.Отбор, СтруктураОтбора);
			Если СтруктураОтбора <> Неопределено Тогда 
				Для Каждого КлючИЗначение Из СтруктураОтбора Цикл
					Если ПостроительЗапроса.ДоступныеПоля.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
						Попытка
							ирОбщий.НайтиДобавитьЭлементОтбораЛкс(ПостроительЗапроса, КлючИЗначение.Ключ,, КлючИЗначение.Значение);
						Исключение
							ОписаниеОшибки = ОписаниеОшибки(); // Для отладки
						КонецПопытки; 
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
			//Если ПостроительЗапроса.Отбор.Количество() > 0 Тогда
				Выборка = ПостроительЗапроса.Результат.Выбрать();
				Если Выборка.Следующий() Тогда
					НепустоеЗначение = Выборка.Ссылка;
				КонецЕсли; 
			//КонецЕсли; 
		Иначе // Эта ветка - для ускорения. Можно оставить только основную ветку, но учесть в ней ЭтоГруппа.
			Если Перечисления.ТипВсеСсылки().СодержитТип(ВыбранныйТипЗначения) Тогда
				ОбъектМДТипа = Метаданные.НайтиПоТипу(ВыбранныйТипЗначения);
				НепустоеЗначение = Перечисления[ОбъектМДТипа.Имя][ОбъектМДТипа.ЗначенияПеречисления[0].Имя];
			Иначе
				МенеджерТипа = ирОбщий.ПолучитьМенеджерЛкс(МетаданныеТипа);
				Выборка = МенеджерТипа.Выбрать();
				Пока Выборка.Следующий() Цикл
					Попытка
						ЭтоГруппа = Выборка.ЭтоГруппа;
					Исключение
						ЭтоГруппа = Ложь;
					КонецПопытки; 
					Если Не ЭтоГруппа Тогда
						НепустоеЗначение = Выборка.Ссылка;
						Прервать;
					КонецЕсли;  
				КонецЦикла; 
			КонецЕсли; 
		КонецЕсли; 
		Если НепустоеЗначение = Неопределено Тогда
			КлючПоиска = Новый Структура("Метаданные, ПредставлениеСвойств", "", "");
			КлючПоиска.Метаданные = МетаданныеТипа.ПолноеИмя();
			Если СтруктураОтбора <> Неопределено Тогда
				КлючПоиска.ПредставлениеСвойств = ирОбщий.ПредставлениеСтруктурыЛкс(СтруктураОтбора);
			КонецЕсли; 
			Если НедостающиеОбъекты.НайтиСтроки(КлючПоиска).Количество() = 0 Тогда
				СтрокаНедостающегоОбъекта = НедостающиеОбъекты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНедостающегоОбъекта, КлючПоиска); 
			Иначе
				СтрокаНедостающегоОбъекта = Неопределено;
			КонецЕсли; 
			Если СтруктураОтбора <> Неопределено И СтруктураОтбора.Количество() > 0 Тогда
				Если СтрокаНедостающегоОбъекта <> Неопределено Тогда 
					СтрокаНедостающегоОбъекта.Свойства = СтруктураОтбора;
				КонецЕсли; 
			Иначе
				Массив = Новый Массив();
				Массив.Добавить(Новый УникальныйИдентификатор());
				НепустоеЗначение = Новый (ВыбранныйТипЗначения, Массив);
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		НепустоеЗначение = мНепустыеЗначения[ВыбранныйТипЗначения];
		Если НепустоеЗначение = Неопределено Тогда
			Попытка
				НепустоеЗначение = Новый (ВыбранныйТипЗначения);
			Исключение
			КонецПопытки; 
		КонецЕсли;
	КонецЕсли;
	Попытка
		ЗначениеЗаполнено = ЗначениеЗаполнено(НепустоеЗначение);
	Исключение
		// Цвет
		ЗначениеЗаполнено = Истина;
	КонецПопытки;
	Если ЗначениеЗаполнено Тогда
		мНепустыеЗначения[ВыбранныйТипЗначения] = НепустоеЗначение;
	КонецЕсли; 
	Возврат НепустоеЗначение;
	
КонецФункции

Функция ЕстьИгнориуемыеСигнатуры(ОписаниеОшибки)
	
	Для Каждого Сигнатура Из ИгнорируемыеСигнатуры Цикл
		Если Сигнатура.Пометка И Найти(ОписаниеОшибки, Сигнатура.Строка) > 0 Тогда
			Возврат Истина;
		КонецЕсли; 
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

Процедура ИнициализироватьНепустыеЗначения() Экспорт 
	
	мНепустыеЗначения = Новый Соответствие();
	мНепустыеЗначения.Вставить(Тип("Дата"), НачалоМесяца(ТекущаяДата()) + 33);
	мНепустыеЗначения.Вставить(Тип("Число"), 1);
	мНепустыеЗначения.Вставить(Тип("Строка"), "а");
	мНепустыеЗначения.Вставить(Тип("Булево"), Истина);
	мНепустыеЗначения.Вставить(Тип("ХранилищеЗначения"), Новый ХранилищеЗначения(Неопределено));
	мНепустыеЗначения.Вставить(Тип("ОписаниеТипов"), Новый ОписаниеТипов);
	мНепустыеЗначения.Вставить(Тип("УникальныйИдентификатор"), Новый УникальныйИдентификатор());

КонецПроцедуры

Ошибки.Колонки.Добавить("Метаданные", Новый ОписаниеТипов("Строка"));
Ошибки.Колонки.Добавить("Операция", Новый ОписаниеТипов("Строка"));
Ошибки.Колонки.Добавить("Контекст", Новый ОписаниеТипов("Строка"));
Ошибки.Колонки.Добавить("ОписаниеОшибки", Новый ОписаниеТипов("Строка"));
Ошибки.Колонки.Добавить("ПодробноеОписаниеОшибки", Новый ОписаниеТипов("Строка"));
Ошибки.Колонки.Добавить("ИнформацияОбОшибке");
НедостающиеОбъекты.Колонки.Добавить("Метаданные", Новый ОписаниеТипов("Строка"));
НедостающиеОбъекты.Колонки.Добавить("ПредставлениеСвойств", Новый ОписаниеТипов("Строка"));
НедостающиеОбъекты.Колонки.Добавить("Свойства");
НедостающиеОбъекты.Индексы.Добавить("Метаданные, ПредставлениеСвойств");
ИнициализироватьНепустыеЗначения();

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
