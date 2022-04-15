//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем ТаблицаАктивныхФоновыхЗаданий Экспорт;
Перем мПлатформа Экспорт;

Функция РеквизитыДляСервера(Параметры) Экспорт  
	
	Результат = ирОбщий.РеквизитыОбработкиЛкс(ЭтотОбъект);
	Результат.Вставить("ТаблицаАктивныхФоновыхЗаданий", ТаблицаАктивныхФоновыхЗаданий);
	Возврат Результат;
	
КонецФункции

Функция ДлительностьФоновогоЗадания(ФоновоеЗадание) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору();
	#КонецЕсли
	Если Не ЗначениеЗаполнено(ФоновоеЗадание.Конец) Тогда
		Длительность = ирОбщий.ТекущаяДатаЛкс(Истина, Истина) - ФоновоеЗадание.Начало;
	Иначе
		Длительность = ФоновоеЗадание.Конец - ФоновоеЗадание.Начало;
	КонецЕсли; 
	Возврат Длительность;
	
КонецФункции

Процедура ОбновитьСтрокуФоновогоЗадания(Знач СтрокаСпискаФоновыхЗаданий, Знач ФоновоеЗадание = Неопределено, Знач Длительность = Неопределено) Экспорт 
	
	Если ФоновоеЗадание = Неопределено Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(СтрокаСпискаФоновыхЗаданий.Идентификатор));
	КонецЕсли; 
	Если Длительность = Неопределено Тогда
		Длительность = ДлительностьФоновогоЗадания(ФоновоеЗадание);
	КонецЕсли; 
	СтрокаСпискаФоновыхЗаданий.Наименование = ФоновоеЗадание.Наименование;
	СтрокаСпискаФоновыхЗаданий.Ключ = ФоновоеЗадание.Ключ;
	СтрокаСпискаФоновыхЗаданий.ИмяМетода = ФоновоеЗадание.ИмяМетода;
	СтрокаСпискаФоновыхЗаданий.Начало = ФоновоеЗадание.Начало;
	СтрокаСпискаФоновыхЗаданий.Конец = ФоновоеЗадание.Конец;
	СтрокаСпискаФоновыхЗаданий.Длительность = Длительность;
	СтрокаСпискаФоновыхЗаданий.Сервер = ФоновоеЗадание.Расположение;
	Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
		СтрокаСпискаФоновыхЗаданий.Ошибка = ирОбщий.ПодробноеПредставлениеОшибкиЛкс(ФоновоеЗадание.ИнформацияОбОшибке);
	КонецЕсли;
	Если Истина
		И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно 
		И ТаблицаАктивныхФоновыхЗаданий <> Неопределено
	Тогда
		СтрокаАктивногоФоновогоЗадания = ТаблицаАктивныхФоновыхЗаданий.Найти(ФоновоеЗадание.УникальныйИдентификатор, "Идентификатор");
		Если СтрокаАктивногоФоновогоЗадания <> Неопределено Тогда
			СтрокаСпискаФоновыхЗаданий.НомерСеанса = СтрокаАктивногоФоновогоЗадания.НомерСеанса;
			СтрокаСпискаФоновыхЗаданий.НомерСоединения = СтрокаАктивногоФоновогоЗадания.НомерСоединения;
		КонецЕсли; 
	КонецЕсли; 
	СтрокаСпискаФоновыхЗаданий.Идентификатор = ФоновоеЗадание.УникальныйИдентификатор;
	СтрокаСпискаФоновыхЗаданий.СостояниеЗадания = ФоновоеЗадание.Состояние;
	СтрокаСпискаФоновыхЗаданий.СостояниеПредставление = ФоновоеЗадание.Состояние;
	СтрокаСпискаФоновыхЗаданий.РазделениеДанных = ФоновоеЗадание.РазделениеДанных;
	СтрокаСпискаФоновыхЗаданий.РазделениеДанныхПредставление = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ФоновоеЗадание.РазделениеДанных);

КонецПроцедуры

Функция ОтборДляЖурналаПоФоновымЗаданиям(Знач ТекущаяСтрока = Неопределено) Экспорт 
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяПриложения", "BackgroundJob");
	Если Истина
		И ТекущаяСтрока <> Неопределено 
		И ЗначениеЗаполнено(ТекущаяСтрока.НомерСеанса) 
	Тогда
		СтруктураОтбора.Вставить("Сеанс", ТекущаяСтрока.НомерСеанса);
	КонецЕсли;
	Возврат СтруктураОтбора;

КонецФункции

Процедура ОткрытьОшибкиЖРПоЗаданию(Знач ВыбраннаяСтрока) Экспорт 
	
	СтруктураОтбора = ОтборДляЖурналаПоФоновымЗаданиям(ВыбраннаяСтрока);
	СтруктураОтбора.Вставить("Уровень", "Ошибка");
	АнализЖурналаРегистрации = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСОтбором(ВыбраннаяСтрока.Начало, ВыбраннаяСтрока.Конец, СтруктураОтбора);

КонецПроцедуры

Функция ПолучитьФоновыеЗадания(Знач КонечныйОтбор) Экспорт 
	
	Попытка
		Фоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(КонечныйОтбор);
	Исключение
		Фоновые = Новый Массив;
	КонецПопытки;
	Возврат Фоновые;

КонецФункции

Функция КоличествоОшибокВЖурнале(Знач Начало, Знач Конец, СтруктураОтбора, МаксимальныйРазмерВыгрузки = 100) Экспорт 
	
	Если ЗначениеЗаполнено(Конец) Тогда
		КоличествоОшибокВЖурнале = ирКэш.КоличествоОшибокВЖурналеЛкс(Начало, Конец, СтруктураОтбора, МаксимальныйРазмерВыгрузки);
	Иначе
		КоличествоОшибокВЖурнале = ирОбщий.КоличествоОшибокВЖурналеЛкс(Начало, Конец, СтруктураОтбора, МаксимальныйРазмерВыгрузки);
	КонецЕсли; 
	Возврат КоличествоОшибокВЖурнале;

КонецФункции

Функция ФоновыеЗаданияПодробно(Параметры) Экспорт 
	
	ТаблицаЗаданий = Параметры.ТаблицаЗаданий;
	ДляСбораСтатистики = Параметры.ДляСбораСтатистики;
	КонечныйОтбор = Параметры.КонечныйОтбор;
	ОтображатьИндикатор = Параметры.ОтображатьИндикатор;
	Фоновые = ПолучитьФоновыеЗадания(КонечныйОтбор);
	#Если Сервер И Не Сервер Тогда
		Фоновые = Новый Массив;
	#КонецЕсли
	Если ОтборФоновыхЗаданий.Свойство("Начало") Тогда
		КонечныйОтбор.Удалить("Начало");
		КонечныйОтбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		АктивныеФоновыеЗадания = ПолучитьФоновыеЗадания(КонечныйОтбор);
		Для Каждого АктивноеФоновоеЗадание Из АктивныеФоновыеЗадания Цикл
			Если АктивноеФоновоеЗадание.Начало < ОтборФоновыхЗаданий.Начало Тогда
				Фоновые.Добавить(АктивноеФоновоеЗадание);
			КонецЕсли;  
		КонецЦикла;
	КонецЕсли; 
	Если ОтображатьИндикатор Тогда
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Фоновые.Количество(), "Чтение фоновых заданий");
	КонецЕсли; 
	ОтключитьПолучатьОшибкиИзЖурнала = Ложь;
	МоментНачалаОбновления = ТекущаяДата();
	Для Каждого Фоновое из Фоновые Цикл
		#Если Сервер И Не Сервер Тогда
		    Фоновое = ФоновыеЗадания.НайтиПоУникальномуИдентификатору();
		#КонецЕсли
		Если Индикатор <> Неопределено Тогда
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		КонецЕсли; 
		Длительность = ДлительностьФоновогоЗадания(Фоновое);
		Если Не ДляСбораСтатистики Тогда
			// https://www.hostedredmine.com/issues/905460
			//Если ОтборПоПустомуРегламентномуЗаданию Тогда 
			//	Если ТекущаяДата() - МоментНачалаОбновления > 5 Тогда 
			//		Сообщить("Заполнение списка запущенных из кода фоновых заданий прервано из-за большой длительности. При необходимости снимите отбор по текущему регламентному заданию.");
			//		Прервать;
			//	КонецЕсли; 
			//	// Очень тяжелая (бывает 0.3 секунды) операция в некоторых случаях http://www.hostedredmine.com/issues/850228
			//	Если Фоновое.РегламентноеЗадание <> Неопределено Тогда
			//		Продолжить;
			//	КонецЕсли; 
			//КонецЕсли; 
			Если Истина
				И КонечныйОтбор.Свойство("ДлительностьМин") 
			Тогда
				Если Ложь
					Или КонечныйОтбор.ДлительностьМин > Длительность
					Или (Истина
						И КонечныйОтбор.ДлительностьМакс > 0
						И КонечныйОтбор.ДлительностьМакс < Длительность)
				Тогда
					Продолжить;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
		НоваяСтрока = ТаблицаЗаданий.Добавить();
		ОбновитьСтрокуФоновогоЗадания(НоваяСтрока, Фоновое, Длительность);
		Если Не ДляСбораСтатистики Тогда
			Если ПолучатьСообщенияПользователю Тогда
				МассивСообщений = ирОбщий.СообщенияПользователюОтФоновогоЗаданияЛкс(Фоновое);
				НоваяСтрока.СообщенияПользователю = МассивСообщений.Количество();
			КонецЕсли; 
			Если ПолучатьОшибкиИзЖурнала Тогда
				СтруктураОтбора = ОтборДляЖурналаПоФоновымЗаданиям(НоваяСтрока);
				СтруктураОтбора.Вставить("Уровень", "Ошибка"); // Передаем в виде строки, т.к. кэширование не допускает родной тип
				МоментНачалаСтроки = ирОбщий.ТекущееВремяВМиллисекундахЛкс();
				НоваяСтрока.ОшибкиЖР = КоличествоОшибокВЖурнале(Фоновое.Начало, Фоновое.Конец, СтруктураОтбора);
				ДлительностьСтроки = ирОбщий.ТекущееВремяВМиллисекундахЛкс() - МоментНачалаСтроки;
				Если ДлительностьСтроки * Фоновые.Количество() > 30000 Тогда
					ОтключитьПолучатьОшибкиИзЖурнала = Истина;
					ирОбщий.СообщитьЛкс("Подсчет числа ошибок в журнале регистрации отключен из-за большой длительности");
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	Если Индикатор <> Неопределено Тогда
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли;
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаЗаданий", ТаблицаЗаданий);
	Результат.Вставить("ДляСбораСтатистики", ДляСбораСтатистики);
	Результат.Вставить("ОтключитьПолучатьОшибкиИзЖурнала", ОтключитьПолучатьОшибкиИзЖурнала);
	Результат.Вставить("ВызовВнутриОбновленияРегламентныхЗаданий", Параметры.ВызовВнутриОбновленияРегламентныхЗаданий);
	Возврат Результат;
	
КонецФункции

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

мПлатформа = ирКэш.Получить();
