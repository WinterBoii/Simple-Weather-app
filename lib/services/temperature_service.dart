import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/temperature_model.dart';

class TemperatureService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  TemperatureService(this.apiKey);

  Future<Temperature> getWeatherByCity(String cityName) async {

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Temperature.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather data (city name)');
    }
  }
}
