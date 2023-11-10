import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  final BASE_URL = 'https://api.opencagedata.com/geocode/v1/json';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather?> getWeather(Position position) async {
    final lat = position.latitude;
    final lon = position.longitude;

    final url = '$BASE_URL?q=$lat,$lon&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return null;
      }

      Map<String, dynamic> data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } catch (e) {
      throw Exception('Error getting weather data');
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

    // ignore: avoid_print
    return position;
  }
}