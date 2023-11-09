import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/3.0/onecall';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(Position position) async {
    var lat = position.latitude;
    var lon = position.longitude;

    final response = await http.
      get(Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather data');
    }
  }

  Future<Position> getCurrentPosition() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}