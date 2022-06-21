///События экрана с информацией о погоде за день
///В данном случае нам нужно только событие старта для инициации подгрузки данных

part of 'short_forecast_bloc.dart';

//Базовый класс иерархии
abstract class ShortForecastEvent extends Equatable {
  const ShortForecastEvent();
}

//Класс конкретного события. В данном случае - запуск экрана. Тут нам нужен текст,
//введенный пользователем, чтобы с ним идти в API
class ShortForecastStartedEvent extends ShortForecastEvent {
  final String cityName;

  const ShortForecastStartedEvent({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
