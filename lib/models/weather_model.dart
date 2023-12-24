class Weather {
  // название города
  final String cityName;
  // текущая температура
  final double temperature;
  // погода (солнечно, пасмурно)
  final String mainCondition;

  // конструктор класса Weather
  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });
  // ----------------> Разобраться с factory
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}
