import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
// ----------------> Разобраться почему пишется as
import 'package:http/http.dart' as http;

class WeatherService {
  // ----------------> Разобраться
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";

  final String apiKey;

  WeatherService(this.apiKey);
  // ----------------> Разобраться с Future
  Future<Weather> getWeather(String cityName) async {
    final response = await http
        // переходим по базовому url сайта openweather, затем переходим в конкретный город, используя свой ключ api с сайта
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      // если статус код равен 200 то мы можем расшифровать полученные данные
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // Если нет то выкинуть ошибку
      throw Exception('Загрузка погоды не удалась');
    }
  }

  // Метод возвращает название  города, если пользователь дал разрешение на использование геопозиции
  Future<String> getCurrentCity() async {
    // Запрос разрешения у пользователя (выглядит круто)))
    LocationPermission permission = await Geolocator.checkPermission();
    // Если разрешения нет
    if (permission == LocationPermission.denied) {
      // Запрашиваем его у пользователя
      permission = await Geolocator.requestPermission();
    }
    // Если разрешение дано, то определяем текущее местоположение
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Указываем координаты (ширина и долгота)
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Зная координаты определяем наименования города
    String? city = placemarks[0].locality;
    return city ?? "Null";
  }
}
