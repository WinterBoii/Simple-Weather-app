class Weather {
  String cityName;
  int sunrise;
  int sunset;

  Weather(
      {required this.cityName,
      required this.sunrise,
      required this.sunset});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      // Get city name
      cityName: json['results'][0]['components']['city'],

      // Get sunrise
      sunrise: json['results'][0]['annotations']['sun']['rise']['astronomical'],

      // Get sunset
      sunset: json['results'][0]['annotations']['sun']['set']['astronomical'],
    );
  }
}
