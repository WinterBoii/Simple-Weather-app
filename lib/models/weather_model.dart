class Weather {
  //final String cityName;
  final double temperature;
  final String mainCondition;
  final String sunrise;
  final String sunset;

  Weather({
    //required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.sunrise,
    required this.sunset,
    });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      //cityName: json['name'],
      temperature: json['current']['temp'].toDouble(),
      mainCondition: json['current']['weather'][0]['main'],
      sunrise: json['current']['sunrise'],
      sunset: json['current']['sunset'],
    );
  }
}
