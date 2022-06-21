///BLoC экрана с информацией за один день
///Позволяет управлять состояниями экрана и отрисовывать элементы заново, а так же реагировать на смену состояний

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../APIs/weather_api.dart';
import '../../models/weather_info_model.dart';

part 'short_forecast_event.dart';
part 'short_forecast_state.dart';

class ShortForecastBloc extends Bloc<ShortForecastEvent, ShortForecastState> {
  //Количество точек отсчета. Выбрано 8, ибо именно столько их в одном дне
  static const int count = 8;

  //Здесь привязываем событиям обработчики
  ShortForecastBloc() : super(const ShortForecastInitial()) {
    on<ShortForecastStartedEvent>((event, emit) async {
      await _onShortForecastStartedEvent(event, emit);
    });
  }

  //Опять же, можно было оставить выше, но некрасиво и тяжело сопровождать будет
  Future<void> _onShortForecastStartedEvent(ShortForecastStartedEvent event, Emitter emit) async {
    try{
      //Указываем, что начинается процесс загрузки данных (подключение к сети, запрос и т.д.)
      emit(const ShortForecastLoading());
      List<WeatherInfo> weatherInfo = await WeatherAPI.fetchWeatherInfo(event.cityName, count);
      //Сейчас имеем 8 отсчетов, но не все за текущий день, нам надо поправить
      //Т.к. данные идут по порядку, можем взять дату первого элемента...
      List<String> dateTime = weatherInfo[0].dtTxt.split(" ");

      //И удалить все данные, у которых дата отличается
      weatherInfo.removeWhere((element) => !element.dtTxt.contains(dateTime[0]));
      //Теперь указываем, что данные успешно считались
      emit(ShortForecastLoaded(weatherInfo: weatherInfo));
    } catch (e) {
      //Ошибки отлавливаем и выводим переходим в нужное состояние
      emit(ShortForecastLoadingFailed(error: e));
    }
  }
}
