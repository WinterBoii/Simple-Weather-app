class Weather {
  String cityName;

  Weather(
      {required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      // Get city name
      cityName: json['results'][0]['components']['city'] ??
          json['results'][0]['components']['town'] ??
          json['results'][0]['components']['village'] ??
          json['results'][0]['components']['isolated_dwelling'],
    );
  }
}
