///Экран с трехдневной информацией о погоде. Опять же - дазайн не лучший, но тут немного
///опирался на ответ API и постановку

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_icons/weather_icons.dart';
import '../blocs/long_forecast/long_forecast_bloc.dart';
import '../models/weather_info_model.dart';
import '../text_constants.dart';

class LongWeatherForecast extends StatelessWidget {
  const LongWeatherForecast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildScaffoldAppBar(),
      body: _buildScaffoldBody(),
    );
  }

  //Построение AppBar'а
  AppBar _buildScaffoldAppBar() {
    return AppBar(
      title: const Text(TextConstant.detailedInfo),
    );
  }

  //Построение тела Scaffold'а
  Widget _buildScaffoldBody() {
    return BlocBuilder<LongForecastBloc, LongForecastState>(
        builder: (context, state) {
      if (state is LongForecastInitial || state is LongForecastLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }

      if (state is LongForecastLoaded) {
        return _buildWeatherInfo(state, context);
      }

      if (state is LongForecastLoadingFailed) {
        return const Center(child: Text(TextConstant.error));
      }

      return const Center(child: Text(TextConstant.somethingWentWrong));
    });
  }

  //Построение списка с информацией о погоде на три дня
  Widget _buildWeatherInfo(LongForecastLoaded state, BuildContext context) {
    List<WeatherInfo> info = state.weatherInfo;

    return ListView.builder(
      itemCount: info.length,
      itemBuilder: (context, index) {
        var item = info[index];
        return Card(
            child: ListTile(
          leading: _getIconById(item.weatherId),
          title: Text(
              "${TextConstant.temperature}: ${item.temp}, ${TextConstant.wind}: ${item.windSpeed}, ${TextConstant.humidity}: ${item.humidity}"),
          subtitle: Text("${TextConstant.dateTime}: ${item.dtTxt}"),
        ));
      },
    );
  }

  //Получение иконки для погоды по id из API
  Icon _getIconById(int id) {
    IconData iconData = Icons.error;
    Color color = Colors.black;

    if (id >= 200 && id <= 232) {
      iconData = WeatherIcons.storm_showers;
    } else if (id >= 300 && id <= 321 || id >= 520 && id <= 531) {
      iconData = WeatherIcons.rain_mix;
    } else if (id >= 500 && id <= 504) {
      iconData = WeatherIcons.day_rain_mix;
    } else if (id == 511 || id >= 600 && id <= 622) {
      iconData = WeatherIcons.snowflake_cold;
    } else if (id >= 701 && id <= 781) {
      iconData = WeatherIcons.fog;
    } else if (id == 800) {
      iconData = WeatherIcons.day_sunny;
    } else if (id == 801) {
      iconData = WeatherIcons.day_sunny_overcast;
    } else if (id == 802) {
      iconData = WeatherIcons.cloud;
    } else if (id == 803 || id == 804) {
      iconData = WeatherIcons.cloudy;
    }

    Icon icon = Icon(
      iconData,
      color: color,
    );

    return icon;
  }
}
