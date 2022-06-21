///Селекционный экран для выбора города. BLoC здесь, по факту не нужен, но можно
///доработать приложение и предлагать пользователю подсказки с городами по введенным символам,
///тогда BLoC пригодится

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/blocs/short_forecast/short_forecast_bloc.dart';
import 'package:weather_forecast/screens/short_weather_forecast.dart';
import '../text_constants.dart';

class SelectionScreen extends StatelessWidget {
  //Контроллер к полю ввода, хранит введенный текст
  final city = TextEditingController();

  SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Основной виджет экрана. В одном из примеров кода увидел такой вынос
    //построения частей Scaffold'а и взял на вооружение.
    //Упрощает ведение и читаемость кода как и другая модуляризация
    return Scaffold(
      appBar: _buildScaffoldAppBar(),
      body: _buildScaffoldBody(context),
    );
  }

  //Построение AppBar.
  AppBar _buildScaffoldAppBar() {
    return AppBar(
      title: const Text(TextConstant.weatherForecast),
      centerTitle: true,
    );
  }

  //Построение тела Scaffold'а
  Widget _buildScaffoldBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: city,
          decoration:
              const InputDecoration(label: Text(TextConstant.cityInput)),
        ),
        ElevatedButton(
            onPressed: () {
              _buttonShowForecastPressed(context);
            },
            child: const Text(TextConstant.showForecast))
      ],
    );
  }

  //Обработчик нажатия на кнопку
  void _buttonShowForecastPressed(BuildContext context) {
    //Добавляем в BLoC второго экрана событие для загрузки информации о погоде
    context
        .read<ShortForecastBloc>()
        .add(ShortForecastStartedEvent(cityName: city.text));

    //Переход ко второму экрану с передачей введенного текста для заголовка
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShortWeatherForecast(city: city.text),
        ));
  }
}
