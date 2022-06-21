///Основа нашего приложения

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/blocs/long_forecast/long_forecast_bloc.dart';
import 'package:weather_forecast/blocs/short_forecast/short_forecast_bloc.dart';
import 'package:weather_forecast/screens/selection_screen.dart';
import 'package:weather_forecast/text_constants.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Указываем, какие BLoC'и должны храниться в контексте и добавляем немного настроек
    //таких как дебаг баннер, тема и т.д. В теории, понятное дело, можно много всего другого накрутить
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ShortForecastBloc()),
        BlocProvider(create: (_) => LongForecastBloc()),
      ],
      child: MaterialApp(
        title: TextConstant.weatherForecast,
        theme: ThemeData.light(),
        home: SelectionScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
