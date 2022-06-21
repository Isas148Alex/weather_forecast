///Список состояний экрана с информацией о погоде за три дня. Тут уже интереснее, чем с событиями
///Помимо базового класса, есть: начальное состояние, состояние загрузки,
///состояние завершённой загрузки, состояние ошибки. Названия говорящие.

part of 'long_forecast_bloc.dart';

abstract class LongForecastState extends Equatable {
  const LongForecastState();
}

class LongForecastInitial extends LongForecastState {
  const LongForecastInitial();

  @override
  List<Object> get props => [];
}

class LongForecastLoading extends LongForecastState {
  const LongForecastLoading();

  @override
  List<Object> get props => [];
}

class LongForecastLoaded extends LongForecastState {
  final List<WeatherInfo> weatherInfo;

  const LongForecastLoaded({required this.weatherInfo});

  @override
  List<Object> get props => [weatherInfo];
}

class LongForecastLoadingFailed extends LongForecastState {
  final Object error;

  const LongForecastLoadingFailed({required this.error});

  @override
  List<Object> get props => [error];
}
