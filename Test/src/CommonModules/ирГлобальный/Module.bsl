#Если Клиент И Не ВебКлиент И Не МобильныйКлиент Тогда

// Вынесено сюда, чтобы у всех пользователей не компилировался тяжелый общий модуль ирОбщий в варианте Расширение
Процедура ОткрытьОднократноАдаптациюРасширенияЛкс(выхПерехватКлавиатуры = Неопределено) Экспорт 
	
	Если Ложь
		#Если ТонкийКлиент Тогда
			Или Не ирСервер.ЛиЕстьИнтерактивныйДоступКИнструментамЛкс() // 30мс
		#Иначе
			Или Не ПравоДоступа("Просмотр", Метаданные.Подсистемы.ИнструментыРазработчикаTormozit) 
		#КонецЕсли 
	Тогда
		Возврат;
	КонецЕсли;
	
	Если Найти(ПараметрЗапуска, "ОтключитьПерехватКлавиатурыИР") = 0 Тогда
		#Если Не ТолстыйКлиентОбычноеПриложение Тогда
			//ирОбщий.ПодключитьПерехватКлавиатурыЛкс(выхПерехватКлавиатуры); // Очень долго из-за инициализации всех модулей
			СисИнфо = Новый СистемнаяИнформация;
			Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда 
				Разрядность = "64";
			Иначе
				Разрядность = "32";
			КонецЕсли; 
			//Успех = ПодключитьВнешнююКомпоненту("Обработка.ирПлатформа.Макет.KeyboardHookZip", "ПерехватКлавиатуры", ТипВнешнейКомпоненты.Native); // На 8.2 работать не будет
			Успех = ПодключитьВнешнююКомпоненту("Обработка.ирПлатформа.Макет.KeyboardHookWin" + Разрядность, "ПерехватКлавиатуры", ТипВнешнейКомпоненты.Native); // 0.03сек
			Если Не Успех Тогда
				#Если ТонкийКлиент Тогда
					ирОбщий.ПослеУстановкиKeyboardHook();
				#КонецЕсли
			КонецЕсли; 
			Попытка
				выхПерехватКлавиатуры = Новый ("AddIn.ПерехватКлавиатуры.KeyboardHook");
			Исключение
			КонецПопытки;
			Если выхПерехватКлавиатуры <> Неопределено Тогда
				выхПерехватКлавиатуры.ЗахватПервым = Истина; // Используем не по назначению
				выхПерехватКлавиатуры.ЗахватРазрешен = Истина;
				выхПерехватКлавиатуры.СобытиеПриНажатии = Истина;
			КонецЕсли; 
		#КонецЕсли
	КонецЕсли; 
	
	#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда
	Если Истина
		И ПравоДоступа("Администрирование", Метаданные)
		И Метаданные.Справочники.Найти("ирАлгоритмы") = Неопределено 
	Тогда
		// Это вариант поставки Расширение
		//ИмяПродуктаЛкс = ирОбщий.ИмяПродуктаЛкс(); // !!! Так при начале каждого сеанса толстого клиента будет компилироваться ирОбщий
		ИмяПродуктаЛкс = "ИнструментыРазработчикаTormozit";
		ОткрытьАдаптациюИР = Ложь;
		ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс);
		Если ПометкиКоманд = Неопределено Тогда
			ПометкиКоманд = Новый Структура;
			ХранилищеОбщихНастроек.Сохранить(, "ирАдаптацияРасширения.ПометкиКоманд", ПометкиКоманд,, ИмяПродуктаЛкс);
			Если ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ИмяПродуктаЛкс) = Неопределено Тогда
				Возврат;
			КонецЕсли; 
			ОткрытьАдаптациюИР = Истина;
		КонецЕсли; 
		Если Найти(НРег(ПараметрЗапуска), НРег("ОткрытьАдаптациюИР")) > 0 Тогда
			ОткрытьАдаптациюИР = Истина;
		КонецЕсли; 
		Если ОткрытьАдаптациюИР Тогда
			ОткрытьФормуМодально("ОбщаяФорма.ирАдаптацияРасширения", Новый Структура("Автооткрытие", Истина));
		КонецЕсли; 
		// Пример пакетного запуска - /CАдаптироватьРасширениеИР;<ПарольПользователя>
		// http://devtool1c.ucoz.ru/forum/3-1695-1
		ИмяПараметра = "АдаптироватьРасширениеИР";
		Если Найти(НРег(ПараметрЗапуска), НРег(ИмяПараметра)) > 0 Тогда
			ПарольПользователя = ирОбщий.СтрокаМеждуМаркерамиЛкс(ПараметрЗапуска, ИмяПараметра + ";", ";");
			РезультатАдаптации = ирОбщий.АдаптироватьРасширениеЛкс(ИмяПользователя(), ПарольПользователя);
			//Если РезультатАдаптации Тогда 
				ПрекратитьРаботуСистемы();
				Возврат;
			//КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ОбработатьПараметрЗапускаДляВсехРежимовЛкс();
	#КонецЕсли
	
КонецПроцедуры

#КонецЕсли 

#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда

// Обертка. Добавляет глобальные переменные и методы в контекст поля текстового документа с контекстной подсказкой.
//
// Параметры
//  ПолеТекстаПрограммы - ОбработкаОбъект.ПолеТекстаПрограммы.
//
Процедура ИнициализироватьГлобальныйКонтекстПодсказки(ПолеТекстаПрограммы) Экспорт

	ирОбщий.ИнициироватьГлобальныйКонтекстПодсказкиЛкс(ПолеТекстаПрограммы);
	
КонецПроцедуры // ИнициализироватьГлобальныйКонтекстПодсказки()

Функция ЗначениеПеременнойИзТаблицыЛокальногоКонтекстаЛкс(ИмяПеременной, ТаблицаЛокальногоКонтекста) Экспорт

	СтруктураКлюча = Новый Структура("нСлово, ТипСлова", НРег(ИмяПеременной), "Свойство");
	НайденныеСтроки = ТаблицаЛокальногоКонтекста.НайтиСтроки(СтруктураКлюча);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].Значение;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

// Вычисляет тип значения функции УК по внутренним параметрам и аргументам.
// Предназначена для вызвова из ирКлсПолеТекстаПрограммы.
//
// Параметры:
//  ТаблицаЛокальногоКонтекста – ТаблицаЗначений – (см. ирКлсПолеТекстаПрограммы);
//  МассивПараметров - Массив - выражений параметров.
//
// Возвращаемое значение:
//  ТаблицаЗначений - ТаблицаСтруктурТипов (см. ирКлсПолеТекстаПрограммы).
//
Функция ПравилоВычисленияТипаЗначенияКПА(ТаблицаЛокальногоКонтекста, МассивПараметров) Экспорт

	лПлатформа = ирКэш.Получить(); 
	ТаблицаСтруктурТипов = лПлатформа.НоваяТаблицаСтруктурТипа();
	Алгоритм = ЗначениеПеременнойИзТаблицыЛокальногоКонтекстаЛкс(МассивПараметров[0], ТаблицаЛокальногоКонтекста);
	Если Алгоритм <> Неопределено Тогда
		Структура = ирКПА(Алгоритм);
		СтруктураТипа = лПлатформа.СтруктураТипаИзЗначения(Структура);
		ЗаполнитьЗначенияСвойств(ТаблицаСтруктурТипов.Добавить(), СтруктураТипа);
	КонецЕсли; 
	Возврат ТаблицаСтруктурТипов;

КонецФункции // ПравилоВычисленияТипаЗначенияУК()

// Конструктор Параметров Алгоритма.
//
// Параметры:
//  Алгоритм     – СправочникСсылка.ирАлгоритмы.
//
// Возвращаемое значение:
//  Структура - ключ - имя, значение - значение.
//
Функция ирКПА(Знач Алгоритм) Экспорт

	#Если Сервер И Не Сервер Тогда
	    Алгоритм = Справочники.ирАлгоритмы.ПустаяСсылка();
	#КонецЕсли
	СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из Алгоритм.Параметры Цикл
		СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
	КонецЦикла; 
	Возврат СтруктураПараметров;

КонецФункции // УК()

// Именованный Вызов Алгоритма. Передача параметров выполняется по имени. 
//
// Параметры:
//  Алгоритм     – СправочникСсылка.ирАлгоритмы, Строка - ссылка или GUID или имя сервиса;
//  *СтруктураПараметров – Структура, *Неопределено - ключи - имена параметров, значения - значения параметров;
//  *пНастройкаАлгоритма - СправочникСсылка.НаборыЗначенийПараметров2iS, *Неопределено - набор значений параметров,
//                 имеющий приоритет ниже, чем СтруктураПараметров;
//  *ПреобразоватьРезультатВСтрокуВнутр - Булево, *Ложь - преобразовать результат в строку внутреннюю (сериализовать)
//
// Возвращаемое значение:
//  Произвольный.
//
Функция ирИВА(Знач Алгоритм, Знач СтруктураПараметров = Неопределено) Экспорт

	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = Новый Структура;
	КонецЕсли;
	АлгоритмОбъект = ирОбщий.ПолучитьАлгоритмОбъектПоИдентификаторуЛкс(Алгоритм);
	Результат = ирКэш.Получить().ВыполнитьМетодАлгоритма(АлгоритмОбъект, 1, СтруктураПараметров);
	Возврат Результат;

КонецФункции // ирИВА()

// Позиционный Вызов Алгоритма. Передача параметров выполняется по позиции. 
//
// Параметры
//  Алгоритм     – СправочникСсылка.Сервисы2iS, Строка - ссылки или имя сервиса;
//  *П...        – Произвольный, *Null – параметры сервиса.
//
// Возвращаемое значение:
//   Произвольное.
//
Функция ирПВА(Знач Алгоритм, П0=Null, П1=Null, П2=Null, П3=Null,
	П4=Null, П5=Null, П6=Null, П7=Null, П8=Null, П9=Null) Экспорт
	
	АлгоритмОбъект = ирОбщий.ПолучитьАлгоритмОбъектПоИдентификаторуЛкс(Алгоритм);
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Результат = мПлатформа.ВыполнитьМетодАлгоритма(АлгоритмОбъект, 0, П0, П1, П2, П3, П4, П5, П6, П7, П8, П9);
	Возврат Результат;
	
КонецФункции // УФ()

#КонецЕсли 

//#Область ГлобальныеПортативныеМетоды

#Если Клиент Тогда

Процедура ВнешнееСобытиеЛкс(Источник, Событие, Данные) Экспорт
	
	#Если ТонкийКлиент Тогда
	Если Источник = "KeyboardHook" Тогда 
		КодыКлавиш = ирКэш.КодыКлавишЛкс();
		Если Ложь
			Или Найти(Данные, КодыКлавиш["CTRL+~"]) = 1
		Тогда
			АктивноеОкно = АктивноеОкно();
			Если АктивноеОкно <> Неопределено Тогда
				НавигационнаяСсылка = АктивноеОкно.ПолучитьНавигационнуюСсылку();
			КонецЕсли; 
			ирОбщий.ПроверитьЧтоСеансТолстогоКлиентаЛкс(НавигационнаяСсылка);
		КонецЕсли;
	КонецЕсли; 
	#КонецЕсли 

	#Если Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда
	Попытка
		Если Истина
			И Источник = "KeyboardHook" 
			И (Ложь
				Или ирКэш.ЛиПортативныйРежимЛкс()
				Или ПравоДоступа("Просмотр", Метаданные.Подсистемы.ИнструментыРазработчикаTormozit))
		Тогда
			ПередатьОбработку = Ложь; // Максимально отсрачиваем компиляцию общего модуля ирОбщий
			ПерехватКлавиатуры = ирКэш.ПерехватКлавиатурыЛкс();
			Если ПерехватКлавиатуры.ЗахватПервым = Истина Тогда // Используем не по назначению
				КодыКлавиш = ирКэш.КодыКлавишЛкс();
				КлавишиТриггеры = Новый Массив;
				КлавишиТриггеры.Добавить("CTRL+~");
				КлавишиТриггеры.Добавить("CTRL+C");
				КлавишиТриггеры.Добавить("CTRL+V");
				Для Каждого КлючКлавиши Из КлавишиТриггеры Цикл
					Если Найти(Данные, КодыКлавиш[КлючКлавиши]) = 1 Тогда 
						ПередатьОбработку = Истина;
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			Иначе
				ПередатьОбработку = Истина;
			КонецЕсли; 
			Если ПередатьОбработку Тогда
				ПерехватКлавиатуры.ЗахватПервым = Ложь; // Используем не по назначению
				СобытиеОбработано = Ложь;
				АктивнаяУправляемаяФорма = ирОбщий.АктивнаяУправляемаяФормаЛкс();
				Если АктивнаяУправляемаяФорма = Неопределено Тогда
					ирОбщий.УдалитьСсылкиНаЗакрытыеФормыЛкс();
					Для Каждого ПроверятьПолеHTML Из ирОбщий.БыстрыйМассивЛкс(Ложь, Истина) Цикл
						Для Каждого Форма Из ирКэш.ОткрытыеФормыЛкс() Цикл
							СлужебныеДанные = ирОбщий.СлужебныеДанныеФормыЛкс(Форма);
							Если ирОбщий.Форма_ВводДоступенЛкс(Форма, ПроверятьПолеHTML) Тогда 
								СобытиеОбработано = Истина;
								Если ирОбщий.ТекущееВремяВМиллисекундахЛкс() - СлужебныеДанные.ДатаОткрытия > 100 Тогда // https://www.hostedredmine.com/issues/892885
									Если ирОбщий.МетодРеализованЛкс(Форма, "ВнешнееСобытие") Тогда
										Форма.ВнешнееСобытие(Источник, Событие, Данные);
									Иначе
										ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонИменЛкс("У формы %1 отсутствует экспортный обработчик %2", 1, Форма.Заголовок, 2, "ВнешнееСобытие"));
									КонецЕсли; 
								КонецЕсли; 
								Прервать;
							КонецЕсли; 
						КонецЦикла;
						Если СобытиеОбработано Тогда
							Прервать;
						КонецЕсли; 
					КонецЦикла;
				КонецЕсли; 
				Если Не СобытиеОбработано Тогда
					ирОбщий.Форма_ВнешнееСобытиеЛкс(, Источник, Событие, Данные);
				КонецЕсли; 
			КонецЕсли; 
			//Сообщить(Данные); // Отладка
		КонецЕсли; 
	Исключение
		// Антибаг платформы https://www.hostedredmine.com/issues/890762
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки; 
	#КонецЕсли 
	
КонецПроцедуры

#КонецЕсли 

#Если Клиент И Не ТонкийКлиент И Не ВебКлиент И Не МобильныйКлиент Тогда

Процедура ОбработатьПараметрЗапускаДляВсехРежимовЛкс() Экспорт 
	
	МаркерОткрытьФорму = "ОткрытьФормуИР.";
	Если Найти(ПараметрЗапуска, МаркерОткрытьФорму) > 0 Тогда
		ИмяФормы = ирОбщий.СтрокаМеждуМаркерамиЛкс(ПараметрЗапуска, МаркерОткрытьФорму, ";");
		Форма = ирОбщий.ПолучитьФормуЛкс(ИмяФормы);
		Если Форма <> Неопределено Тогда
			Форма.Открыть();
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЖИДАНИЯ

Процедура ОсвободитьВсеИндикаторыПроцессовОтложенноЛкс() Экспорт
	
	ирОбщий.ОсвободитьВсеИндикаторыПроцессовЛкс();
	
КонецПроцедуры

Процедура СохранитьНастройкиПользователяОтложенноЛкс() Экспорт
	
	СохранитьНастройкиПользователя();
	
КонецПроцедуры

Процедура ВыполнитьПроверкуСовместимостиКонфигурацииЛкс() Экспорт 
	
	//мПлатформа = ирКэш.Получить();
	//#Если Сервер И Не Сервер Тогда
	//    мПлатформа = Обработки.ирПлатформа.Создать();
	//#КонецЕсли
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		Если ирОбщий.ВосстановитьЗначениеЛкс("ПроверятьПодпискиКонфигурации", Истина) <> Ложь Тогда 
			ирОбщий.ПроверитьПодпискиЛкс();
		КонецЕсли; 
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			Если Истина
				И Метаданные.ОсновнойРежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение
				И Не Метаданные.ИспользоватьУправляемыеФормыВОбычномПриложении 
			Тогда
				Сообщить("Рекомендуется включить в свойствах конфигурации флажок ""Использовать управляемые формы в обычном приложении""");
			КонецЕсли; 
		#КонецЕсли 
	#КонецЕсли
	//#Если ТолстыйКлиентУправляемоеПриложение Тогда
	//	ирОбщий.ПроверитьФлажокИспользоватьОбычныеФормыВУправляемомПриложенииЛкс();
	//#КонецЕсли
	//Если Метаданные.ВариантВстроенногоЯзыка = Метаданные.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский Тогда
	//	Сообщить("Подсистема не полностью поддерживает вариант встроенного языка Английский.", СтатусСообщения.Внимание);
	//КонецЕсли;

КонецПроцедуры

Процедура ГлобальныйОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();
	
КонецПроцедуры

Процедура ПроверитьОтмененныеФоновыеЗаданияОтложенноЛкс() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого Идентификатор Из мПлатформа.ОтмененныеФоновыеЗадания Цикл
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если ФоновоеЗадание <> Неопределено И ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			ирОбщий.СообщитьЛкс(ирОбщий.СтрШаблонИменЛкс("Фоновое задание %1, которому была отправлена команда отмены, продолжает выполняться",, ФоновоеЗадание.Наименование + ". " + ФоновоеЗадание.Ключ),
				СтатусСообщения.Внимание); 
		КонецЕсли;
	КонецЦикла; 
	мПлатформа.ОтмененныеФоновыеЗадания.Очистить();
	
КонецПроцедуры

Процедура ОткрытьСтруктуруАктивнойФормыЛкс(Параметры) Экспорт 
	
	ТекущаяФорма = Параметры.Форма;
	//ТекущаяФорма = ирОбщий.АктивнаяУправляемаяФормаЛкс();
	Если ТекущаяФорма <> Неопределено Тогда
		ирОбщий.ОткрытьСтруктуруФормыЛкс(ТекущаяФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура РедактироватьОбъектАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Неопределено;
	Ссылка = ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(Форма);
	Если Ссылка <> Неопределено Тогда
		КлючСтроки = Неопределено;
		ИмяПоляБД = ирОбщий.НайтиПутьКДаннымПоляТаблицыФормыЛкс(Ссылка, Форма.ТекущийЭлемент.Имя);
		Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
			ИмяТЧБД = ИмяПоляБД;
			ИмяПоляБД = "";
			Если Форма.ТекущийЭлемент.ТекущийЭлемент <> Неопределено Тогда
				ИмяПоляБД = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(Форма.ТекущийЭлемент);
			КонецЕсли; 
			ДанныеТаблицыФормы = ирОбщий.ДанныеЭлементаФормыЛкс(Форма.ТекущийЭлемент);
			Если Форма.ТекущийЭлемент.ТекущаяСтрока <> Неопределено И ирОбщий.ЛиДанныеФормыСВозможностьюПоискаЛкс(ДанныеТаблицыФормы) Тогда
				КлючСтроки = Новый Структура("НомерСтроки", ДанныеТаблицыФормы.Индекс(ДанныеТаблицыФормы.НайтиПоИдентификатору(Форма.ТекущийЭлемент.ТекущаяСтрока)) + 1);
			КонецЕсли; 
		КонецЕсли; 
		//Если ПоляТаблицы.Найти(ИмяТЧБД, "Имя") = Неопределено Тогда 
		//	ИмяТЧБД = "";
		//КонецЕсли; 
		//ИмяДочернейТаблицыБД = Ссылка.Метаданные().ПолноеИмя();
		//Если ЗначениеЗаполнено(ИмяТЧБД) Тогда
		//	ИмяДочернейТаблицыБД = ИмяДочернейТаблицыБД + "." + ИмяТЧБД;
		//КонецЕсли; 
		//ПоляТаблицы = ирОбщий.ПоляТаблицыБДЛкс(ИмяДочернейТаблицыБД);
		//Если ПоляТаблицы.Найти(ИмяПоляБД, "Имя") = Неопределено Тогда 
		//	ИмяПоляБД = "";
		//КонецЕсли; 
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(Ссылка,, ИмяТЧБД, ИмяПоляБД, КлючСтроки);
	КонецЕсли; 

КонецПроцедуры

Процедура КопироватьСсылкуАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Неопределено;
	Ссылка = ирОбщий.КлючОсновногоОбъектаУправляемойФормыЛкс(Форма);
	Если Ссылка <> Неопределено Тогда
		ирОбщий.БуферОбменаПриложения_УстановитьЗначениеЛкс(Ссылка);
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьОбъектСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	Форма = Параметры.Форма;
	ирОбщий.КлючиСтрокБДИзТаблицыФормыЛкс(Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(Форма.ТекущийЭлемент);
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючТекущейСтроки,,, ДанныеКолонки);
	КонецЕсли; 

КонецПроцедуры

Процедура РедактироватьОбъектТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 
	
	КлючТекущейСтроки = Неопределено;
	ирОбщий.СсылкиИзТекущейКолонкиВыделенныхСтрокТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючТекущейСтроки);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьОбъектТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 
	
	КлючТекущейСтроки = Неопределено;
	Ссылки = ирОбщий.СсылкиИзТекущейКолонкиВыделенныхСтрокТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ирОбщий.ОткрытьЗначениеЛкс(КлючТекущейСтроки);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработатьОбъектыАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	ТаблицаФормыДинамическогоСписка = Неопределено;
	Ссылки = ирОбщий.КлючиСтрокБДИзТаблицыФормыЛкс(Параметры.Форма, КлючТекущейСтроки, ТаблицаФормыДинамическогоСписка);
	Если Ссылки.Количество() > 0 Тогда
		Если ТаблицаФормыДинамическогоСписка <> Неопределено Тогда
			ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ТаблицаФормыДинамическогоСписка,, Ссылки);
		Иначе
			ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки,,,, КлючТекущейСтроки);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработатьОбъектыТекущегоПоляАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	Ссылки = ирОбщий.СсылкиИзТекущейКолонкиВыделенныхСтрокТаблицыЛкс(Параметры.Форма, КлючТекущейСтроки);
	Если Ссылки.Количество() > 0 Тогда
		ирОбщий.ОткрытьМассивОбъектовВПодбореИОбработкеОбъектовЛкс(Ссылки,,,, КлючТекущейСтроки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОткрытьТаблицуАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОткрытьТаблицуЗначенийИзАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьТабличныйДокументАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОткрытьТабличныйДокументИзАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура СравнитьТаблицуАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.СравнитьТаблицуИзАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьРазличныеЗначенияКолонкиАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОткрытьРазличныеЗначенияКолонкиАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура УстановитьЗначениеВКолонкеАктивнойФормыЛкс(Параметры) Экспорт 

	Форма = Параметры.Форма;
	ТекущийЭлемент = ирОбщий.ТекущийЭлементАктивнойФормыЛкс(Форма);
	Если Истина
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТаблицаФормы") 
		И ТипЗнч(ТекущийЭлемент) <> Тип("ТабличноеПоле")
	Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ТекущийЭлемент, Форма, "Обработка");

КонецПроцедуры

Процедура ОтладитьКомпоновкуДанныхАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОтладитьКомпоновкуДанныхАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура РедактироватьАктивныйСписокЗначенийЛкс(Параметры) Экспорт 

	ирОбщий.РедактироватьАктивныйСписокЗначенийУправляемыйЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НастроитьДинамическийСписокАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.НастроитьДинамическийСписокАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьДинамическийСписокАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОткрытьДинамическийСписокАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НайтиВыбратьСсылкуВДинамическомСпискеАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.НайтиВыбратьСсылкуВДинамическомСпискеАктивнойУправляемойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура ОткрытьМенеджерТабличногоПоляАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(, Параметры.Форма);

КонецПроцедуры

Процедура СообщитьКоличествоСтрокАктивнойТаблицыЛкс(Параметры) Экспорт 

	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(Параметры.Форма.ТекущийЭлемент);

КонецПроцедуры

Процедура Сравнить2СтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.ТабличноеПолеИлиТаблицаФормы_Сравнить2СтрокиЛкс(Параметры.Форма, Параметры.Форма.ТекущийЭлемент);

КонецПроцедуры

Процедура ВставитьСкопированнуюСсылкуАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.БуферОбмена_ВставитьЛкс(Параметры.Форма);

КонецПроцедуры

Процедура НайтиСкопированнуюСсылкуАктивнойФормыЛкс(Параметры) Экспорт 

	ирОбщий.НайтиСсылкуВТаблицеАктивнойФормыЛкс(Параметры.Форма);

КонецПроцедуры

Процедура КопироватьСсылкуАктивнойСтрокиАктивнойФормыЛкс(Параметры) Экспорт 

	КлючТекущейСтроки = Неопределено;
	Форма = Параметры.Форма;
	ирОбщий.КлючиСтрокБДИзТаблицыФормыЛкс(Форма, КлючТекущейСтроки);
	Если КлючТекущейСтроки <> Неопределено Тогда
		ирОбщий.БуферОбменаПриложения_УстановитьЗначениеЛкс(КлючТекущейСтроки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОткрытьТекстАктивнойФормыЛкс(Параметры) Экспорт 

	АктивнаяФорма = Параметры.Форма;
	Текст = ирОбщий.Форма_ЗначениеТекущегоПоляЛкс(АктивнаяФорма);
	ирОбщий.ОткрытьТекстЛкс(Текст,, "",, АктивнаяФорма.ТекущийЭлемент);

КонецПроцедуры

// Антибаг платформы https://www.hostedredmine.com/issues/929519
// В некоторых случаях не помогает. При проблемах заменить на УстановитьФокусВводаФормеЛкс()
// 8мс
Процедура ВосстановитьФокусВводаЛкс() Экспорт 
	
	ФормаПустышка = ирКэш.ФормаПустышкаЛкс();
	ФормаПустышка.Открыть();
	ФормаПустышка.Закрыть();
	
КонецПроцедуры

// Антибаг платформы https://www.hostedredmine.com/issues/926161
Процедура АктивироватьАктивнуюФормуЛкс() Экспорт 
	
	АктивнаяФорма = ирОбщий.АктивнаяФормаЛкс();
	Если АктивнаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ВосстановитьФокусВводаЛкс();
	ирОбщий.Форма_АктивироватьОткрытьЛкс(АктивнаяФорма);

КонецПроцедуры

#КонецЕсли 

////////////////////////////////////////////////////////////////////////////////
// ОТЛАДКА

// Обертка ирОбщий.ПрЛкс(). Присваивает первому параметру второй.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
//
// Параметры:
//  П1           – Произвольный – параметр1;
//  П2           – Произвольный – параметр2;
//
// Возвращаемое значение:
//  П2 – Не используется.
//
Функция Пр(п1, п2 = Неопределено) Экспорт
	
	Результат = ирОбщий.ПрЛкс(п1, п2);
	Возврат Результат;
	
КонецФункции // Присвоить()

// Обертка ирОбщий.ДуЛкс(). Выполняет программный код, переданный в параметре.
// Остальные параметры могут участвовать в теле этого кода. Вернуть результат можно через переменную Р.
// Удобно использовать в отладчике.
//
// Параметры:
//  П1           – Произвольный – параметр1;
//  П2           – Произвольный – параметр2;
//  П3           – Произвольный – параметр3;
//  П4           – Произвольный – параметр4;
//
// Возвращаемое значение:
//  Неопределено – Не используется.
//
Функция Ду(Знач ТекстПрограммы, п1 = 0, п2 = 0, п3 = 0, п4 = 0)  Экспорт
	
	Результат = ирОбщий.ДуЛкс(ТекстПрограммы, п1, п2, п3, п4);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ОперироватьЛкс(). На клиенте открывает консоль кода с передачей туда всех своих параметров. На сервере сразу выполняет код.
// Изменения параметров возвращаются в вызывающий контекст в модальном режиме.
//
// Параметры:
//  ТекстПрограммы    - Строка - программный код для передачи в консоль кода или выполнения;
//  РежимОперации     – Число - 0 - немодально, 1 - модально, 2 - неинтерактивно (на сервере всегда);
//  СтрокаИменПараметров – Строка - имена параметров для консоли кода через запятую, если не указаны, то будут оригинальные П*;
//  П*             – Произвольный - параметры для использования при выполнении программного кода;
//
// Возвращаемое значение:
//  Строка - описание ошибок.
//
Функция Оперировать(Знач ТекстПрограммы = "", Знач РежимОперации = 0, СтрокаИменПараметров= "",
	П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null, П6 = Null, П7 = Null, П8 = Null, П9 = Null) Экспорт

	Результат = ирОбщий.ОперироватьЛкс(ТекстПрограммы, РежимОперации, СтрокаИменПараметров, П1, П2, П3, П4, П5, П6, П7, П8, П9);
	Возврат Результат;

КонецФункции // РП()

// Обертка ирОбщий.ПерЛкс(). Подготавливает строку для помещения всех переменных в структуру с целью ее дальнейшего вычисления в отладчике "Вычислить(Пер())".
//
// Параметры:
//  ТекстПрограммы    - Строка, *"" - на клиенте можно не указывать и тогда текст будет браться из буфера обмена, можно вставить имена локальных переменных выведенных в табличный документ
//
// Возвращаемое значение:
//  Строка для вычисления в отладчике.
//
Функция Пер(Знач ТекстПрограммы =  "") Экспорт
	
	Результат = ирОбщий.ПерЛкс(ТекстПрограммы);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ПолВТЛкс(). Функция получает структуру (Имя временной таблицы; Таблица значений) из указанного запроса или менеджера временных таблиц.
// Полезна для просмотра временных таблиц из менеджера временных таблиц серверного контекста в отладчике.
// Параметры:
//   ЗапросИлиМенеджерВременныхТаблиц - Запрос, МенеджерВременныхТаблиц
//   ИменаВременныхТаблиц - Строка, *"" - имена существующих, но возможно не используемых в тексте запроса временных таблиц через запятую
//   ДопустимоеЧислоСтрок - Число, *500000 - выбирать из временной таблицы не более этого числа строк
//
// Результат - ТаблицаЗначений, Структура
//
Функция ПолВТ(ЗапросИлиМенеджерВременныхТаблиц, ИменаВременныхТаблиц = "", ДопустимоеЧислоСтрок = 500000) Экспорт
	
	Результат = ирОбщий.ПолВТЛкс(ЗапросИлиМенеджерВременныхТаблиц, ИменаВременныхТаблиц, ДопустимоеЧислоСтрок);
	Возврат Результат;
	
КонецФункции // ПолВТ()

// Обертка ирОбщий.ТехНЛкс(). Начать трассу в технологическом журнале. Сам технологический журнал надо заранее включить.
Функция ТехН() Экспорт
	
	Результат = ирОбщий.ТехНЛкс();
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ТехКЛкс(). Кончить трассу в технологическом журнале и показать ее анализ
Функция ТехК() Экспорт
	
	Результат = ирОбщий.ТехКЛкс();
	Возврат Результат;
	
КонецФункции

#Если Клиент Тогда

// Обертка ирОбщий.ПопЛкс(). Подготавливает строку для вызова Оперировать() в отладчике. Вызвается путем вычисления "Вычислить(Поп())".
// Изменения параметров возвращаются в вызывающий контекст.
//
// Параметры:
//  ТекстПрограммы    - Строка, *"" - программный код для передачи в консоль кода или выполнения, берется из буфера обмена если пустой;
//  РежимОперации     – Число - 0 - немодально, 1 - модально, 2 - неинтерактивно (на сервере всегда);
//
// Возвращаемое значение:
//  Строка для вычисления в отладчике.
//
Функция Поп(Знач ТекстПрограммы =  "", РежимОперации = 1) Экспорт
	
	Результат = ирОбщий.ПопЛкс(ТекстПрограммы, РежимОперации);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.ОпЛкс(). Модально открывает консоль кода с передачей туда всех своих параметров.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Изменения параметров возвращаются в вызывающий контекст.
//
// Параметры:
//  П*  – Произвольный;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Оп(П1 = Null, П2 = Null, П3 = Null, П4 = Null, П5 = Null) Экспорт

	Результат = ирОбщий.ОпЛкс(П1, П2, П3, П4, П5);
	Возврат Результат;

КонецФункции // Оп()

// Обертка ирОбщий.ОперироватьСтруктуройЛкс(). Открывает консоль кода с передачей туда структуры параметров.
// Изменения параметров возвращаются в структуру, но не в вызывающий контекст.
//
// Параметры:
//  ТекстПрограммы - Строка;
//  Модально     – Булево - открывать окно модально;
//  СтруктураПараметров – Структура - ключи соответсвуют именам параметов, а значения их значениям.
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ОперироватьСтруктурой(Знач ТекстПрограммы = "", Модально = Ложь, СтруктураПараметров) Экспорт

	Результат = ирОбщий.ОперироватьСтруктуройЛкс(ТекстПрограммы, Модально, СтруктураПараметров);
	Возврат Результат;

КонецФункции // РП()

// Обертка ирОбщий.ОпсЛкс(). Обертка ОперироватьСтруктурой. Модально открывает консоль кода с передачей туда всех своих параметров.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Изменения параметров возвращаются в структуру, но не в вызывающий контекст.
//
// Параметры:
//  СтруктураПараметров – Структура - ключи соответсвуют именам параметов, а значения их значениям.
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Опс(Знач СтруктураПараметров) Экспорт

	Результат = ирОбщий.ОпсЛкс(СтруктураПараметров);
	Возврат Результат;

КонецФункции // Опс()

// Обертка ирОбщий.НаблюдатьЛкс(). Выводит в окно сообщений переданное значение вместе с типом и заданным представлением.
//
// Параметры:
//  Значение     - Произвольный;
//  *Представление – Строка, *"" - представление наблюдаемого значения.
//
Процедура Наблюдать(Знач Значение, Представление = "") Экспорт

	ирОбщий.НаблюдатьЛкс(Значение, Представление);

КонецПроцедуры // Наблюдать()

#КонецЕсли 

// Обертка ирОбщий.ОтладитьЛкс(). Открывает нужную консоль для редактирования сложного объекта. 
// Варианты использования в зависимости от типа параметра Объект:
//   Запрос, COMОбъект - открывает Запрос или ADODB.Command или ADODB.Connection в консоли запросов
//   ПостроительЗапроса - открывает результирующий запрос построителя запросов в консоли запросов
//   ПостроительОтчета - открывает построитель отчета в консоли построителей отчетов, откуда можно открыть результирующий запрос построителя отчета в консоли запросов
//   СхемаКомпоновки - открывает схему компоновки в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//
// Параметры:
//  Объект       – Запрос, ПостроительЗапроса, ПостроительОтчета, СхемаКомпоновкиДанных, COMОбъект.ADODB.Command - исследуемый объект;
//  Модально     – Булево - открывать окно модально, должно быть Истина для использования функции в отладчике;
//  НастройкаКомпоновкиИлиТекстЗапроса - НастройкиКомпоновкиДанных, Строка, *Неопределено - настройки для схемы компоновки, текст запроса для WMI или ADODB.Connection;
//  ВнешниеНаборыДанных - Структура, *Неопределено - внешние наборы данных для схемы компоновки;
//  ОтложеннаяОтладка - Булево - на сервере игнорируется (равно Истина), вместо открытия инструмента отладки сразу выполняется помещение
//                      объектов отладки во временное хранилище;
//  ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки - Число, *500000 - допустимое количество строк во всех временных таблицах запроса
//                      для отложенной отладки, больше этого количества строки не сохраняются, о чем сообщается в результате;
//  Наименование - Строка - наименование сохраняемого объекта отложенной отладки;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция Отладить(Знач Объект, Модально = Ложь, Знач Объект2 = Неопределено, Знач ВнешниеНаборыДанных = Неопределено,
	ОтложенноеВыполнение = Ложь, ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки = 500000, Наименование = "") Экспорт 
	
	Результат = ирОбщий.ОтладитьЛкс(Объект, Модально, Объект2, ВнешниеНаборыДанных, ОтложенноеВыполнение, ДопустимоеЧислоСтрокВоВременнойТаблицеОтложеннойОтладки,, Наименование);
	Возврат Результат;
	
КонецФункции 

// Обертка ирОбщий.ОтЛкс(). Открывает или формирует снимок объекта для открытия в соответствующем инструменте.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
// Варианты использования в зависимости от типа параметра Объект:
//   Запрос, COMОбъект, HttpСоединение - открывает Запрос или ADODB.Command или ADODB.Connection в консоли запросов
//   ПостроительЗапроса - открывает результирующий запрос построителя запросов в консоли запросов
//   ПостроительОтчета - открывает построитель отчета в консоли построителей отчетов, откуда можно открыть результирующий запрос построителя отчета в консоли запросов
//   СхемаКомпоновки - открывает схему компоновки в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//   МакетКомпоновкиДанных - открытвает запросы макета компоновки в консоли запросов
//   ОтчетОбъект - открывает схему и настройки компоновки отчета в консоли компоновки данных, откуда можно открыть результирующие (из макета компоновки) запросы в консоли запросов
//   РегистрСведенийНаборЗаписей - открывает группировку таблицы набора записей по измерениям
//
// Параметры:
//  Объект       – Запрос, ПостроительЗапроса, ПостроительОтчета, СхемаКомпоновкиДанных, МакетКомпоновкиДанных, ОтчетОбъект, ADODB.Command, ADODB.Connection, HttpСоединение - исследуемый объект;
//  Объект2      - НастройкиКомпоновкиДанных, Строка, *Неопределено - 
//                      если первый параметр СхемаКомпоновкиДанных, то настройки компоновки,
//                      если первый параметр WMI или ADODB.Connection, то текст запроса,
//                      если первый параметр HttpСоединение, то HttpЗапрос,
//                      если первый параметр Запрос, имена временных таблиц разделенных запятыми;
//  ВнешниеНаборыДанных - Структура, *Неопределено - внешние наборы данных для схемы компоновки;
//  ОтложеннаяОтладка - Булево - на сервере игнорируется (равно Истина), вместо открытия инструмента отладки сразу выполняется помещение
//                      объектов отладки во временное хранилище;
//  Наименование - Строка - наименование сохраняемого объекта отложенной отладки;
//
// Возвращаемое значение:
//  Неопределено.
//
Функция От(Знач Объект, Знач Объект2 = Неопределено, Знач ВнешниеНаборыДанных = Неопределено, ОтложеннаяОтладка = Ложь, ПорогОбрезкиВременнойТаблицы = 500000, Наименование = "") Экспорт 

	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Пустышка = ПолучитьФорму(Неопределено); // Чтобы использовалась форма именно этого объекта
		КонецЕсли; 
	#КонецЕсли 
	Результат = ирОбщий.ОтЛкс(Объект, Объект2, ВнешниеНаборыДанных, ОтложеннаяОтладка, ПорогОбрезкиВременнойТаблицы, Наименование);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.УсловныйДеструктор();
	КонецЕсли; 
	Возврат Результат;

КонецФункции

// Обертка ирОбщий.ИсследоватьЛкс(). Открывает исследователь объектов.
//
// Параметры:
//  Объект       – Произвольный, *Неопределено - объект, который будет исследован;
//  Модально     – Булево - открывать окно модально;
//  КакКоллекцию – Булево, *Ложь - исследовать как коллекцию вместо объекта.
//
// Возвращаемое значение:
//  Сам объект.
//
Функция Исследовать(Знач Объект = Неопределено, Модально = Ложь, КакКоллекцию = Ложь, ОтложенноеВыполнение = Ложь) Экспорт

	Результат = ирОбщий.ИсследоватьЛкс(Объект, Модально, КакКоллекцию, ОтложенноеВыполнение);
	Возврат Результат;
	
КонецФункции // Исследовать()

// Обертка ирОбщий.ИсЛкс(). Открывает или формирует снимок объекта для открытия в исследователе объектов.
// Удобно вызывать из отладчика через диалог "Вычислить выражение". 
Функция Ис(Знач Объект = Неопределено, КакКоллекцию = Ложь, ОтложенноеВыполнение = Ложь) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Пустышка = ПолучитьФорму(Неопределено); // Чтобы использовалась форма именно этого объекта
		КонецЕсли; 
	#КонецЕсли 
	Результат = ирОбщий.ИсЛкс(Объект, КакКоллекцию, ОтложенноеВыполнение);
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ирПортативный.УсловныйДеструктор();
	КонецЕсли; 
	Возврат Результат;

КонецФункции // Ис()

// Обертка ирОбщий.ФайлЛкс(). Возвращает текст из файла
Функция Файл(Знач ИмяФайла, Знач Кодировка = "") Экспорт 
	
	Результат = ирОбщий.ФайлЛкс(ИмяФайла, Кодировка);
	Возврат Результат;
	
КонецФункции

// Обертка ирОбщий.СокрКолЛкс(). Удаляет все элементы коллекции кроме заданного или первого.
Функция СокрКол(Коллекция, ОставитьЭлементИлиКлюч = Неопределено) Экспорт 
	
	ирОбщий.СокрКолЛкс(Коллекция, ОставитьЭлементИлиКлюч);
	
КонецФункции

// Обертка ирОбщий.ИзмЛкс(). Проверяет что переданное значение отличается от предыдущего переданного с тем же именем.
// Удобно вызывать из отладчика в качестве условия точки останова. 
Функция Изм(Значение, ИмяЗначения = "п", Знач НужноеСтароеЗначение = "фйъх13м9", Знач НужноеНовоеЗначение = "фйъх13м9") Экспорт 
	Результат = ирОбщий.ИзмЛкс(Значение, ИмяЗначения, НужноеСтароеЗначение, НужноеНовоеЗначение);
	Возврат Результат;
КонецФункции

// Обертка ирОбщий.СткЛкс(). Создает из объекта структуру
Функция Стк(Объект) Экспорт 
	Возврат ирОбщий.СткЛкс(Объект);
КонецФункции 

// Обертка ирОбщий.КолЛкс(). Создает из объекта таблицу значений
Функция Кол(Объект) Экспорт 
	Возврат ирОбщий.КолЛкс(Объект);
КонецФункции

// Обертка ирОбщий.УслЛкс(). Формирует строку условия точки останова по значениям всех свойств объекта.
Функция Усл(Объект, ИмяПеременной, МаксДлинаСтроки = 20, МаксДробныхЗнаков = 6) Экспорт 
	Возврат ирОбщий.УслЛкс(Объект, ИмяПеременной, МаксДлинаСтроки, МаксДробныхЗнаков);
КонецФункции

//#КонецОбласти


