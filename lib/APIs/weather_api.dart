///API для подгрузки информации о погоде. Реализация прослойки между внешним
///источником и внутренней моделью.
///
///Здесь важно отметить - пока тестировал API на этом сайте, вспомнил, что разные города
///могут называться одинакого. Например, две Тюмени. Для упрощения задачи выбирается первый город,
///но в идеале, надо было бы сделать подсказку при наборе текста, в которой бы отображалась страна
///или область\край\что-то ещё для более точной идентификации места

import 'dart:convert';
import 'package:http/http.dart';
import '../api_key.dart';
import '../models/weather_info_model.dart';

class WeatherAPI {
  static Future<List<WeatherInfo>> fetchWeatherInfo(
      String cityName, int count) async {
    final response = await get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&cnt=$count&units=metric&appid=$API_KEY'));
    //Если запрос успешно отработал  парсим данные в модель и возвращаем
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['list'];
      List<WeatherInfo> weatherInfo =
          body.map((dynamic item) => WeatherInfo.fromJson(item)).toList();

      return weatherInfo;
      //Иначе - триггерим ошибку, которую ловим выше
    } else {
      throw Exception('Failed to load cities names');
    }
  }
}
