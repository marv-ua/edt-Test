///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обновляет индекс полнотекстового поиска.
Процедура ОбновлениеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Обновление индекса ППД'"), Ложь, Истина);
	
КонецПроцедуры

// Выполняет слияние индексов полнотекстового поиска.
Процедура СлияниеИндексаППД() Экспорт
	
	ОбновитьИндекс(НСтр("ru = 'Слияние индекса ППД'"), Истина);
	
КонецПроцедуры

// Возвращает, актуален ли индекс полнотекстового поиска.
//   Проверка функциональной опции "ИспользоватьПолнотекстовыйПоиск" выполняется в вызывающем коде.
//
// Возвращаемое значение: 
//   Булево - Истина - полнотекстовый поиск содержит актуальные данные.
//
Функция ИндексПоискаАктуален() Экспорт
	
	Состояние = СостояниеПолнотекстовогоПоиска();
	Возврат Состояние = "ПоискРазрешен";
	
КонецФункции

// Состояние флажка для формы настроек полнотекстового поиска.
//
// Возвращаемое значение: 
//   Число - 0 - не включен, 1 - включен, - 2 ошибка настройки, рассинхронизация настроек.
//
// Пример:
//	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
//		МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
//		ИспользоватьПолнотекстовыйПоиск = МодульПолнотекстовыйПоискСервер.ЗначениеФлажкаИспользоватьПоиск();
//	Иначе 
//		Элементы.ГруппаУправлениеПолнотекстовымПоиском.Видимость = Ложь;
//	КонецЕсли;
//
Функция ЗначениеФлажкаИспользоватьПоиск() Экспорт
	
	Состояние = СостояниеПолнотекстовогоПоиска();
	Если Состояние = "ПоискЗапрещен" Тогда
		Результат = 0;
	ИначеЕсли Состояние = "ОшибкаНастройкиПоиска" Тогда
		Результат = 2;
	Иначе
		Результат = 1;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текущее состояние полнотекстового поиска в зависимости от настроек и актуальности.
// Не выбрасывает исключений.
//
// Возвращаемое значение:
//  Строка - варианты:
//    "ПоискРазрешен"
//    "ПоискЗапрещен"
//    "ВыполняетсяОбновлениеИндекса"
//    "ВыполняетсяСлияниеИндекса"
//    "ТребуетсяОбновлениеИндекса"
//    "ОшибкаНастройкиПоиска"
//
Функция СостояниеПолнотекстовогоПоиска() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск") Тогда 
		
		Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда 
			
			Если ТекущаяДата() < (ПолнотекстовыйПоиск.ДатаАктуальности() + 300) Тогда 
				Возврат "ПоискРазрешен";
			Иначе
				Если ИндексПолнотекстовогоПоискаАктуален() Тогда 
					Возврат "ПоискРазрешен";
				ИначеЕсли ВыполняетсяФоновоеЗаданиеОбновлениеИндекса() Тогда 
					Возврат "ВыполняетсяОбновлениеИндекса";
				ИначеЕсли ВыполняетсяФоновоеЗаданиеСлияниеИндекса() Тогда 
					Возврат "ВыполняетсяСлияниеИндекса";
				Иначе
					Возврат "ТребуетсяОбновлениеИндекса";
				КонецЕсли;
			КонецЕсли;
			
		Иначе 
			// Рассинхронизация значения константы ИспользоватьПолнотекстовыйПоиск
			// и установленного режима полнотекстового поиска в информационной базе.
			Возврат "ОшибкаНастройкиПоиска";
		КонецЕсли;
		
	Иначе
		Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
			// Рассинхронизация значения константы ИспользоватьПолнотекстовыйПоиск
			// и установленного режима полнотекстового поиска в информационной базе.
			Возврат "ОшибкаНастройкиПоиска";
		Иначе 
			Возврат "ПоискЗапрещен";
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Объект метаданных с функциональной опцией использования полнотекстового поиска.
//
// Возвращаемое значение:
//   ОбъектМетаданныхФункциональнаяОпция - метаданные функциональной опции 
//
Функция ФункциональнаяОпцияИспользоватьПолнотекстовыйПоиск() Экспорт
	
	Возврат Метаданные.ФункциональныеОпции.ИспользоватьПолнотекстовыйПоиск;
	
КонецФункции

// Возвращает состояние функциональной опции использования полнотекстового поиска.
//
// Возвращаемое значение:
//   Булево - если Истина, то полнотекстовый поиск используется.
//
Функция ИспользоватьПолнотекстовыйПоиск() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск");
	
КонецФункции


#Область ОбработчикиСобытийПодсистемКонфигурации

// Параметры:
//   ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск")
		Или Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если МодульТекущиеДелаСервер.ДелоОтключено("ПолнотекстовыйПоискВДанных") Тогда
		Возврат;
	КонецЕсли;
	
	Состояние = СостояниеПолнотекстовогоПоиска();
	Если Состояние = "ПоискЗапрещен" Тогда 
		Возврат;
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.Найти("Администрирование");
	Если Раздел = Неопределено Тогда
		Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Обработки.ПолнотекстовыйПоискВДанных.ПолноеИмя());
		Если Разделы.Количество() = 0 Тогда 
			Возврат;
		Иначе 
			Раздел = Разделы[0];
		КонецЕсли;
	КонецЕсли;
	
	// Ошибка настройки поиска
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор = "ПолнотекстовыйПоискВДанныхОшибкаНастройкиПоиска";
	Дело.ЕстьДела = (Состояние = "ОшибкаНастройкиПоиска");
	Дело.Представление = НСтр("ru = 'Полнотекстовый поиск не настроен'");
	Дело.Форма = "Обработка.ПолнотекстовыйПоискВДанных.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов";
	Дело.Подсказка = 
		НСтр("ru = 'Рассинхронизация настройки программы и установленного режима полнотекстового поиска в информационной базе.
		           |Попробуйте выключить полнотекстовый поиск и снова включить.'");
	Дело.Владелец = Раздел;
	
	// Требуется обновление индекса
	
	Если Состояние = "ТребуетсяОбновлениеИндекса" Тогда 
		ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		ТекущаяДата = ТекущаяДата(); // Исключение, должна использоваться ТекущаяДата().
		
		Если ДатаАктуальностиИндекса > ТекущаяДата Тогда
			Интервал = НСтр("ru = 'менее одного дня назад'");
		Иначе
			Интервал = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 назад'"),
				ОбщегоНазначения.ИнтервалВремениСтрокой(ДатаАктуальностиИндекса, ТекущаяДата));
		КонецЕсли;
		
		ДнейСПоследнегоОбновления = Цел((ТекущаяДата - ДатаАктуальностиИндекса) / 60 / 60 / 24);
		ЕстьДела = (ДнейСПоследнегоОбновления >= 1);
	Иначе 
		Интервал = НСтр("ru = 'Никогда'");
		ЕстьДела = Ложь;
	КонецЕсли;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор = "ПолнотекстовыйПоискВДанныхТребуетсяОбновлениеИндекса";
	Дело.ЕстьДела = ЕстьДела;
	Дело.Представление = НСтр("ru = 'Индекс полнотекстового поиска устарел'");
	Дело.Форма = "Обработка.ПолнотекстовыйПоискВДанных.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов";
	Дело.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Последнее обновление %1'"),
		Интервал);
	Дело.Владелец = Раздел;
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ПолнотекстовыйПоискСервер.ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск";
	Обработчик.Версия = "1.0.0.1";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Зависимость = Настройки.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД;
	Зависимость.ФункциональнаяОпция = ФункциональнаяОпцияИспользоватьПолнотекстовыйПоиск();
	
	Зависимость = Настройки.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СлияниеИндексаППД;
	Зависимость.ФункциональнаяОпция = ФункциональнаяОпцияИспользоватьПолнотекстовыйПоиск();
	
КонецПроцедуры

#КонецОбласти

// Устанавливает значение константы ИспользоватьПолнотекстовыйПоиск.
//   Используется для синхронизации значения
//   функциональной опции "ИспользоватьПолнотекстовыйПоиск"
//   с "ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска()".
//
Процедура ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск() Экспорт
	
	ОперацииРазрешены = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	Константы.ИспользоватьПолнотекстовыйПоиск.Установить(ОперацииРазрешены);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиРегламентныхЗаданий

// Обработчик регламентного задания ОбновлениеИндексаППД.
Процедура ОбновлениеИндексаППДПоРасписанию() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД);
	
	Если ВыполняетсяФоновоеЗаданиеСлияниеИндекса() Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИндексаППД();
	
КонецПроцедуры

// Обработчик регламентного задания СлияниеИндексаППД.
Процедура СлияниеИндексаППДПоРасписанию() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.СлияниеИндексаППД);
	
	Если ВыполняетсяФоновоеЗаданиеОбновлениеИндекса() Тогда
		Возврат;
	КонецЕсли;
	
	СлияниеИндексаППД();
	
КонецПроцедуры

#КонецОбласти

#Область БизнесЛогикаПоиска

#Область СостояниеПоиска

Функция ВыполняетсяФоновоеЗаданиеОбновлениеИндекса()
	
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеИндексаППД;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ТекущиеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат ТекущиеФоновыеЗадания.Количество() > 0;
	
КонецФункции

Функция ВыполняетсяФоновоеЗаданиеСлияниеИндекса()
	
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.СлияниеИндексаППД;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ТекущиеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат ТекущиеФоновыеЗадания.Количество() > 0;
	
КонецФункции

Функция ИндексПолнотекстовогоПоискаАктуален()
	
	Актуален = Ложь;
	
	Попытка
		Актуален = ПолнотекстовыйПоиск.ИндексАктуален();
	Исключение
		ЗаписьЖурнала(
			УровеньЖурналаРегистрации.Предупреждение, 
			НСтр("ru = 'Не удалось проверить состояние индекса полнотекстового поиска'"),
			ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат Актуален;
	
КонецФункции

#КонецОбласти

#Область ВыполнениеПоиска

Функция ПараметрыПоиска() Экспорт 
	
	Параметры = Новый Структура;
	Параметры.Вставить("СтрокаПоиска", "");
	Параметры.Вставить("НаправлениеПоиска", "ПерваяЧасть");
	Параметры.Вставить("ТекущаяПозиция", 0);
	Параметры.Вставить("ИскатьВРазделах", Ложь);
	Параметры.Вставить("ОбластиПоиска", Новый Массив);
	
	Возврат Параметры;
	
КонецФункции

Функция ВыполнитьПолнотекстовыйПоиск(ПараметрыПоиска) Экспорт 
	
	СтрокаПоиска = ПараметрыПоиска.СтрокаПоиска;
	Направление = ПараметрыПоиска.НаправлениеПоиска;
	ТекущаяПозиция = ПараметрыПоиска.ТекущаяПозиция;
	ИскатьВРазделах = ПараметрыПоиска.ИскатьВРазделах;
	ОбластиПоиска = ПараметрыПоиска.ОбластиПоиска;
	
	РазмерПорции = 10;
	ОписаниеОшибки = "";
	КодОшибки = "";
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если ИскатьВРазделах И ОбластиПоиска.Количество() > 0 Тогда
		СписокПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
		
		Для Каждого Область Из ОбластиПоиска Цикл
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение, Ложь);
			Если ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданных") Тогда 
				СписокПоиска.ОбластьПоиска.Добавить(ОбъектМетаданных);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		Если Направление = "ПерваяЧасть" Тогда
			СписокПоиска.ПерваяЧасть();
		ИначеЕсли Направление = "ПредыдущаяЧасть" Тогда
			СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
		ИначеЕсли Направление = "СледующаяЧасть" Тогда
			СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
		Иначе 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Параметр %1 задан неверно. Ожидалось одно из значений: ""%2"", ""%3"" или ""%4"".'"),
				"НаправлениеПоиска", "ПерваяЧасть", "ПредыдущаяЧасть", "СледующаяЧасть");
		КонецЕсли;
	Исключение
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КодОшибки = "ОшибкаПоиска";
	КонецПопытки;
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда 
		ОписаниеОшибки = НСтр("ru = 'Слишком много результатов, уточните запрос'");
		КодОшибки = "СлишкомМногоРезультатов";
	КонецЕсли;
	
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	
	Если ПолноеКоличество = 0 Тогда
		ОписаниеОшибки = НСтр("ru = 'По запросу ничего не найдено'");
		КодОшибки = "НичегоНеНайдено";
	КонецЕсли;
	
	Если ПустаяСтрока(КодОшибки) Тогда 
		РезультатыПоиска = РезультатыПолнотекстовогоПоиска(СписокПоиска);
	Иначе 
		РезультатыПоиска = Новый Массив;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ТекущаяПозиция", СписокПоиска.НачальнаяПозиция());
	Результат.Вставить("Количество", СписокПоиска.Количество());
	Результат.Вставить("ПолноеКоличество", ПолноеКоличество);
	Результат.Вставить("КодОшибки", КодОшибки);
	Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	Результат.Вставить("РезультатыПоиска", РезультатыПоиска);
	
	Возврат Результат;
	
КонецФункции

Функция РезультатыПолнотекстовогоПоиска(СписокПоиска)
	
	// Разбор списка посредством выделения блока описания HTML.
	СтрокиПоискаHTML = СтрокиРезультатаПоискаHTML(СписокПоиска);
	
	Результат = Новый Массив;
	
	// Обход строк списка поиска.
	Для Индекс = 0 По СписокПоиска.Количество() - 1 Цикл
		
		ОписаниеHTML  = СтрокиПоискаHTML.ОписанияHTML.Получить(Индекс);
		Представление = СтрокиПоискаHTML.Представления.Получить(Индекс);
		СтрокаСпискаПоиска = СписокПоиска.Получить(Индекс);
		
		МетаданныеОбъекта = СтрокаСпискаПоиска.Метаданные;
		Значение = СтрокаСпискаПоиска.Значение;
		
		Переопределяемый_ПриПолученииПолнотекстовымПоиском(МетаданныеОбъекта, Значение, Представление);
		
		Ссылка = "";
		Попытка
			Ссылка = ПолучитьНавигационнуюСсылку(Значение);
		Исключение
			Ссылка = "#"; // Непредусмотренное для открытия.
		КонецПопытки;
		
		СтрокаРезультата = Новый Структура;
		СтрокаРезультата.Вставить("Ссылка",        Ссылка);
		СтрокаРезультата.Вставить("ОписаниеHTML",  ОписаниеHTML);
		СтрокаРезультата.Вставить("Представление", Представление);
		
		Результат.Добавить(СтрокаРезультата);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтрокиРезультатаПоискаHTML(СписокПоиска)
	
	ОтображениеСпискаHTML = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	// Получение DOM для отображения списка.
	// Нельзя выносить в отдельную функцию получения DOM из-за ошибки платформы в стеке вызовов потока чтения DOM.
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ОтображениеСпискаHTML);
	ПостроительDOM = Новый ПостроительDOM;
	ОтображениеСпискаDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	ЧтениеHTML.Закрыть();
	
	СписокЭлементовDivDOM = ОтображениеСпискаDOM.ПолучитьЭлементыПоИмени("div");
	СтрокиОписанияHTML = СтрокиОписанияHTML(СписокЭлементовDivDOM);
	
	СписокЭлементовAnchorDOM = ОтображениеСпискаDOM.ПолучитьЭлементыПоИмени("a");
	СтрокиПредставления = СтрокиПредставления(СписокЭлементовAnchorDOM);
	
	Результат = Новый Структура;
	Результат.Вставить("ОписанияHTML", СтрокиОписанияHTML);
	Результат.Вставить("Представления", СтрокиПредставления);
	
	Возврат Результат;
	
КонецФункции

Функция СтрокиОписанияHTML(СписокЭлементовDivDOM)
	
	СтрокиОписанияHTML = Новый Массив;
	Для Каждого ЭлементDOM Из СписокЭлементовDivDOM Цикл 
		
		Если ЭлементDOM.ИмяКласса = "textPortion" Тогда 
			
			ЗаписьDOM = Новый ЗаписьDOM;
			ЗаписьHTML = Новый ЗаписьHTML;
			ЗаписьHTML.УстановитьСтроку();
			ЗаписьDOM.Записать(ЭлементDOM, ЗаписьHTML);
			
			ОписаниеHTMLСтрокиРезультата = ЗаписьHTML.Закрыть();
			
			СтрокиОписанияHTML.Добавить(ОписаниеHTMLСтрокиРезультата);
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокиОписанияHTML;
	
КонецФункции

Функция СтрокиПредставления(СписокЭлементовAnchorDOM)
	
	СтрокиПредставления = Новый Массив;
	Для Каждого ЭлементDOM Из СписокЭлементовAnchorDOM Цикл
		
		Представление = ЭлементDOM.ТекстовоеСодержимое;
		СтрокиПредставления.Добавить(Представление);
		
	КонецЦикла;
	
	Возврат СтрокиПредставления;
	
КонецФункции

// Позволяет переопределить:
// - Значение
// - Представление
//
// См. тип данных ЭлементСпискаПолнотекстовогоПоиска 
//
Процедура Переопределяемый_ПриПолученииПолнотекстовымПоиском(МетаданныеОбъекта, Значение, Представление)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда 
		
		// Для дополнительных сведений открывается форма объекта, которому принадлежит значение,
		// а не формы записи в регистре сведений.
		
		Если МетаданныеОбъекта = Метаданные.РегистрыСведений["ДополнительныеСведения"] Тогда 
			
			Значение = Значение.Объект;
			МетаданныеОбъекта = Значение.Метаданные();
			
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1: %2'"), 
				ОбщегоНазначения.ПредставлениеОбъекта(МетаданныеОбъекта), 
				Строка(Значение));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИндексаПоиска

// Общая процедура для обновления и слияния индекса ППД.
Процедура ОбновитьИндекс(ПредставлениеПроцедуры, РазрешитьСлияние = Ложь, Порциями = Ложь)
	
	Если (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() <> РежимПолнотекстовогоПоиска.Разрешить) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	ЗаписьЖурнала(
		Неопределено, 
		НСтр("ru = 'Запуск процедуры ""%1"".'"),,
		ПредставлениеПроцедуры);
	
	Попытка
		ПолнотекстовыйПоиск.ОбновитьИндекс(РазрешитьСлияние, Порциями);
		ЗаписьЖурнала(
			Неопределено, 
			НСтр("ru = 'Успешное завершение процедуры ""%1"".'"),, 
			ПредставлениеПроцедуры);
	Исключение
		ЗаписьЖурнала(
			УровеньЖурналаРегистрации.Предупреждение, 
			НСтр("ru = 'Не удалось выполнить процедуру ""%1"":'"),
			ИнформацияОбОшибке(), 
			ПредставлениеПроцедуры);
	КонецПопытки;
	
КонецПроцедуры

// Создает запись в журнале регистрации и сообщениях пользователю;
//
// Параметры:
//   УровеньЖурнала - УровеньЖурналаРегистрации - важность сообщения для администратора.
//   КомментарийСПараметрами - Строка - комментарий, который может содержать параметры %1.
//   ИнформацияОбОшибке - ИнформацияОбОшибке
//                      - Строка - информация об ошибке, которая будет размещена после комментария.
//   Параметр - Строка - для подстановки в КомментарийСПараметрами вместо %1.
//
Процедура ЗаписьЖурнала(
	УровеньЖурнала,
	КомментарийСПараметрами,
	ИнформацияОбОшибке = Неопределено,
	Параметр = Неопределено)
	
	// Определение уровня журнала регистрации на основе типа переданного сообщения об ошибке.
	Если ТипЗнч(УровеньЖурнала) <> Тип("УровеньЖурналаРегистрации") Тогда
		Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
			УровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
		Иначе
			УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	КонецЕсли;
	
	// Комментарий для журнала регистрации.
	ТекстДляЖурнала = КомментарийСПараметрами;
	Если Параметр <> Неопределено Тогда
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДляЖурнала, Параметр);
	КонецЕсли;
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
		ТекстДляЖурнала = ТекстДляЖурнала + Символы.ПС + ИнформацияОбОшибке;
	КонецЕсли;
	ТекстДляЖурнала = СокрЛП(ТекстДляЖурнала);
	
	// Запись в журнал регистрации.
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Полнотекстовое индексирование'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурнала, , , 
		ТекстДляЖурнала);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
