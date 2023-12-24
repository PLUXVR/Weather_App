import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // Создаем службу погоды и добавляем апи ключ с сайта
  final _weatherService = WeatherService('0522df6fba2d925a11bdf0fcf1458029');
  Weather? _weather;
  // Получаем информацию о погоде (Разобраться с async хотябы немного для начала)
  _fetchWeather() async {
    // Получаем текущий город
    String cityName = await _weatherService.getCurrentCity();

    // Получаем информацию о погоде в этом городе
    try {
      final weather = await _weatherService.getWeather(cityName);
      // Если получилось получить информацию то присваиваем полученное
      // значение переменной _weather
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Анимация погоды

  String getWeatherAnimation(String? condtion) {
    if (condtion == null) return 'assets/sunny.json';

    switch (condtion.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/rain.json';
      case "thunderstorm":
        return 'assets/thunder.json';
      case "clear":
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Установим начальное состояние
  @override
  void initState() {
    super.initState();
    // Когда приложение запустится  мы узнаем погоду
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Отобразитм название города
          Text(_weather?.cityName ?? 'Загрузка города...'),
          // Анимация с видами погоды
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          // Отобразим температуру
          Text(
              "Температура в ${_weather?.cityName}:  ${_weather?.temperature.round()} C*, погода: ${_weather?.mainCondition}"),
        ]),
      ),
    );
  }
}
