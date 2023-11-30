class Temperature {
  double temperature;
  String mainCondition;
  String description;
  DateTime sunrise;
  DateTime sunset;
  String cityName;

  Temperature(
      {required this.temperature,
      required this.mainCondition,
      required this.description,
      required this.sunrise,
      required this.sunset,
      required this.cityName});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      cityName: json['name'],
    );
  }
}
