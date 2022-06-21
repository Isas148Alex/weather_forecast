///Текстовые литералы вынесены для более простого ведения + возможности перевода
///Переменная dummy используется как заглушка, а её вынесение в класс позволяет
///без проблем найти её использование по всему коду. Используется на этапе
///разработки и в конечной версии её использований быть не должно.

class TextConstant {
  static const String weatherForecast = "Прогноз погоды";
  static const String cityInput = "Введите название города...";
  static const String showForecast = "Показать прогноз";
  static const String showLongForecast = "Показать прогноз на три дня";
  static const String dummy = "Заглушка";
  static const String error = "Ошибка получения данных";
  static const String somethingWentWrong = "Что-то пошло не так";
  static const String detailedInfo = "Подробная информация";
  static const String temperature = "Температура";
  static const String wind = "Скорость ветра";
  static const String humidity = "Влажность";
  static const String dateTime = "Дата и время";
}
