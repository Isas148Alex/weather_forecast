///Всё описание очень похоже на блок второго экрана, так что я его скопирую
///BLoC экрана с информацией за три дня
///Позволяет управлять состояниями экрана и отрисовывать элементы заново, а так же реагировать на смену состояний

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../APIs/weather_api.dart';
import '../../models/weather_info_model.dart';

part 'long_forecast_event.dart';

part 'long_forecast_state.dart';

class LongForecastBloc extends Bloc<LongForecastEvent, LongForecastState> {
  //Количество точек отсчета. Выбрано 24, ибо именно столько их в трёх днях
  static const int count = 24;

  //Здесь привязываем событиям обработчики
  LongForecastBloc() : super(const LongForecastInitial()) {
    on<LongForecastStartedEvent>((event, emit) async {
      await _onLongForecastStartedEvent(event, emit);
    });
  }

  //Обработчик старта экрана
  Future<void> _onLongForecastStartedEvent(
      LongForecastStartedEvent event, Emitter emit) async {
    try {
      //Указываем, что начинается процесс загрузки данных (подключение к сети, запрос и т.д.)
      emit(const LongForecastLoading());
      List<WeatherInfo> weatherInfo =
          await WeatherAPI.fetchWeatherInfo(event.cityName, count);

      //Сейчас имеем 8 отсчетов, но не все за текущий день, нам надо поправить
      //Тут логика чуть интереснее, потому что информация может быть о 3 или 4 днях,
      //поэтому выбран Set, который бует содержать только уникальные даты (от трёх до четырёх)
      Set<String> dateTime = {};
      for (var element in weatherInfo) {
        dateTime.add(element.dtTxt.split(" ")[0]);
      }

      //Если даты четыре - удаляем последнюю, т.к. она и по дате последняя
      if (dateTime.length == 4) {
        dateTime.remove(dateTime.last);
      }

      //Удаляем все данные, которые нам не подходят
      weatherInfo.removeWhere(
          (element) => !dateTime.contains(element.dtTxt.split(" ")[0]));

      //Теперь поднимаем вверх данные о погоде с самой низкой температурой
      //первый элемент берем в качестве элемента с минимальной температурой
      var min = weatherInfo[0];

      //идем циклом и ищем минимальную температуру
      for (var inf in weatherInfo) {
        if (inf.temp < min.temp) {
          min = inf;
        }
      }

      //Сейчас имеем в min данные с самой низкой температурой, так что можем
      //удалить этот элемент из коллекции и вставить в самое начало
      weatherInfo.remove(min);
      weatherInfo.insert(0, min);

      //Теперь указываем, что данные успешно считались
      emit(LongForecastLoaded(weatherInfo: weatherInfo));
    } catch (e) {
      //Ошибки отлавливаем и выводим переходим в нужное состояние
      emit(LongForecastLoadingFailed(error: e));
    }
  }
}
