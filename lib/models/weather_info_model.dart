import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

///Модель данных информации о погоде. Если бы моделей данных было несколько, можно
///было бы объединить их в один файл models.dart, который представлял бы собой модель
///данных всего приложения

enum WeatherIconDate { i, j }

class WeatherInfo {
  final String dtTxt; //Дата+время
  final double temp; //Температура
  final int humidity; //Влажность
  final double windSpeed; //Скорость ветра
  final int weatherId; //Код погоды
  late IconData iconData; //Код иконки для отображения

  WeatherInfo({
    required this.dtTxt,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.weatherId,
  }) {
    //Выбирает код иконки по id из API
    if (weatherId >= 200 && weatherId <= 232) {
      iconData = WeatherIcons.storm_showers;
    } else if (weatherId >= 300 && weatherId <= 321 ||
        weatherId >= 520 && weatherId <= 531) {
      iconData = WeatherIcons.rain_mix;
    } else if (weatherId >= 500 && weatherId <= 504) {
      iconData = WeatherIcons.day_rain_mix;
    } else if (weatherId == 511 || weatherId >= 600 && weatherId <= 622) {
      iconData = WeatherIcons.snowflake_cold;
    } else if (weatherId >= 701 && weatherId <= 781) {
      iconData = WeatherIcons.fog;
    } else if (weatherId == 800) {
      iconData = WeatherIcons.day_sunny;
    } else if (weatherId == 801) {
      iconData = WeatherIcons.day_sunny_overcast;
    } else if (weatherId == 802) {
      iconData = WeatherIcons.cloud;
    } else if (weatherId == 803 || weatherId == 804) {
      iconData = WeatherIcons.cloudy;
    } else {
      iconData = Icons.error;
    }
  }

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    var main = json['main'];
    var wind = json['wind'];
    var weather = json['weather'][0];

    //Здесь выполнено явное приведение типов, чтобы в случае, когда скорость ветра, например,
    //представляется целым числом, программа не падала (в процессе отладки выяснил, что такое возможно)
    double temp = main['temp'].toDouble();
    int humidity = main['humidity'];
    double speed = wind['speed'].toDouble();
    int id = weather['id'];

    return WeatherInfo(
      dtTxt: json['dt_txt'],
      temp: temp,
      humidity: humidity,
      windSpeed: speed,
      weatherId: id,
    );
  }
}
