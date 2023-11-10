class Weather {
  String cityName;
  //double temperature;
  //String mainCondition;
  int sunrise;
  int sunset;

  Weather(
      {required this.cityName,
      //required this.temperature,
      //required this.mainCondition,
      required this.sunrise,
      required this.sunset});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      //temperature: json['main']['temp'].toDouble(),

      //mainCondition: json['weather'][0]['main'],
      // Get city name
      cityName: json['results'][0]['components']['city'],

      // Get sunrise
      sunrise: json['results'][0]['annotations']['sun']['rise']['astronomical'],

      // Get sunset
      sunset: json['results'][0]['annotations']['sun']['set']['astronomical'],
    );
  }
}
