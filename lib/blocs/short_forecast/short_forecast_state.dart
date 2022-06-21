///Список состояний экрана с информацией о погоде за день. Тут уже интереснее, чем с событиями
///Помимо базового класса, есть: начальное состояние, состояние загрузки,
///состояние завершённой загрузки, состояние ошибки. Названия говорящие.

part of 'short_forecast_bloc.dart';

abstract class ShortForecastState extends Equatable {
  const ShortForecastState();
}

//При запуске никакая информация не требуется
class ShortForecastInitial extends ShortForecastState {
  const ShortForecastInitial();

  @override
  List<Object> get props => [];
}

//В процессе загрузки тоже
class ShortForecastLoading extends ShortForecastState {
  const ShortForecastLoading();

  @override
  List<Object> get props => [];
}

//А после успешной загрузки данных имеем информацию о погоде до конца дня
class ShortForecastLoaded extends ShortForecastState {
  final List<WeatherInfo> weatherInfo;

  const ShortForecastLoaded({required this.weatherInfo});

  @override
  List<Object> get props => [weatherInfo];
}

//При неудачной - ошибку
class ShortForecastLoadingFailed extends ShortForecastState {
  final Object error;

  const ShortForecastLoadingFailed({required this.error});

  @override
  List<Object> get props => [error];
}