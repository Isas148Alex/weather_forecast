///Модель данных информации о погоде. Если бы моделей данных было несколько, можно
///было бы объединить их в один файл models.dart, который представлял бы собой модель
///данных всего приложения

class WeatherInfo {
  final String dtTxt; //Дата+время
  final double temp; //Температура
  final int humidity; //Влажность
  final double windSpeed; //Скорость ветра

  const WeatherInfo(
      {required this.dtTxt,
      required this.temp,
      required this.humidity,
      required this.windSpeed});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    var main = json['main'];
    var wind = json['wind'];

    //Здесь выполнено явное приведение типов, чтобы в случае, когда скорость ветра, например,
    //представляется целым числом, программа не падала (в процессе отладки выяснил, что такое возможно)
    double temp = main['temp'].toDouble();
    int humidity = main['humidity'];
    double speed = wind['speed'].toDouble();

    return WeatherInfo(
      dtTxt: json['dt_txt'],
      temp: temp,
      humidity: humidity,
      windSpeed: speed,
    );
  }
}
