///События экрана с информацией о погоде за три дня
///В данном случае нам нужно только событие старта для инициации подгрузки данных

part of 'long_forecast_bloc.dart';

abstract class LongForecastEvent extends Equatable {
  const LongForecastEvent();
}

class LongForecastStartedEvent extends LongForecastEvent {
  final String cityName;

  const LongForecastStartedEvent({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
