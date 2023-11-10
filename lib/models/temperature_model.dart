class Temperature {
  double temperature;
  String mainCondition;
  String description;

  Temperature(
      {required this.temperature,
      required this.mainCondition,
      required this.description});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
    );
  }
}
