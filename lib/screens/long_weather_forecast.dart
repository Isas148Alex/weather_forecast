///Экран с трехдневной информацией о погоде. Опять же - дазайн не лучший, но тут немного
///опирался на ответ API и постановку

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/bgi_app_background.jpg"),
          fit: BoxFit.cover,
        )),
        child: BlocBuilder<LongForecastBloc, LongForecastState>(
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
        }));
  }

  //Построение списка с информацией о погоде на три дня
  Widget _buildWeatherInfo(LongForecastLoaded state, BuildContext context) {
    List<WeatherInfo> info = state.weatherInfo;

    return ListView.builder(
      itemCount: info.length,
      itemBuilder: (context, index) {
        var item = info[index];
        return Card(
            color: const Color.fromRGBO(255, 255, 255, 0.7),
            child: ListTile(
              iconColor: Colors.black,
              leading: Icon(
                item.iconData,
              ),
              title: Text(
                  "${TextConstant.temperature}: ${item.temp}, ${TextConstant.wind}: ${item.windSpeed}, ${TextConstant.humidity}: ${item.humidity}"),
              subtitle: Text("${TextConstant.dateTime}: ${item.dtTxt}"),
            ));
      },
    );
  }
}
