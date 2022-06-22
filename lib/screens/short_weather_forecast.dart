///Экран с основной информацией о погоде на один день. Так как дизайн роли не имеет,
///а API возвращает информацию за каждые три часа, решил вывести незамысловатый список.
///В теории, если дорабатывать до полноценного приложения, можно выгружать больше данных в модель
///и реализовать проваливание по тапу на элемент списка.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/blocs/short_forecast/short_forecast_bloc.dart';
import 'package:weather_icons/weather_icons.dart';
import '../blocs/long_forecast/long_forecast_bloc.dart';
import '../text_constants.dart';
import 'long_weather_forecast.dart';

class ShortWeatherForecast extends StatelessWidget {
  static const int snackBarDuration = 1;

  final String city;

  //Принимает введенный текст для вывода в заголовок
  const ShortWeatherForecast({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildScaffoldAppBar(context),
      body: _buildScaffoldBody(context),
    );
  }

  //Построение AppBar'а
  AppBar _buildScaffoldAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(city),

      //Вообще говоря, эту кнопку можно было не прописывать явно, т.к. она подтягивается сама,
      //но если нам нужна будет дополнительная логика перед  выходом с экрана - надо будет её использовать
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        //Такая кнопка показалась интуитивно понятной
        IconButton(
            onPressed: () => _detailInfoPressed(context),
            icon: const Icon(Icons.format_list_bulleted))
      ],
    );
  }

  //Основная часть экрана - тело Scaffold'а. Прописан BlocConsumer для возможности
  //и строить виджет в зависимости от состояния и реагировать на смену состояния выводом SnackBar'а
  Widget _buildScaffoldBody(BuildContext context) {
    return BlocConsumer<ShortForecastBloc, ShortForecastState>(
        builder: (context, state) {
      //В зависимости от состояния различается отображаемый контент
      //В момент загрузки показываем прогресс индикатор
      if (state is ShortForecastInitial || state is ShortForecastLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }

      //Если загрузили данные успешно - строим список
      if (state is ShortForecastLoaded) {
        return _buildWeatherInfo(state, context);
      }

      //При ошибке выводим текст из постановки
      if (state is ShortForecastLoadingFailed) {
        return const Center(child: Text(TextConstant.error));
      }

      //В идеале этот текст не должен выводиться никогда, то есть все состояния
      //должы быть обработаны выше, но текст остается
      return const Center(child: Text(TextConstant.somethingWentWrong));
    }, listener: (context, state) {
      //На случай поимки ошибки, то есть смены состояния в ошибочное
      if (state is ShortForecastLoadingFailed) {
        //Выводим сообщение об ошибке в SnackBar. Длительность вынесена в константу, чтобы потом легче было найти
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: snackBarDuration),
          content: Text(state.error.toString()),
        ));
      }
    });
  }

  //Опять же - выносим логику обработки нажатия на кнопку для удобного ведения
  //и повышения читаемости кода
  void _detailInfoPressed(BuildContext context) {
    //Также добавляем событие в BLoC следующего экрана
    context
        .read<LongForecastBloc>()
        .add(LongForecastStartedEvent(cityName: city));
    //... и переходим к нему
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LongWeatherForecast(),
        ));
  }

  //Построение списка с информацией о погоде на текущий день
  Widget _buildWeatherInfo(ShortForecastLoaded state, BuildContext context) {
    return ListView.builder(
      itemCount: state.weatherInfo.length,
      itemBuilder: (context, index) {
        var item = state.weatherInfo[index];
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

    //Тут был выбор между условиями и switch case, но выбрал условия, потому что switch case
    //в данном случае был бы очень перегруженным
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
