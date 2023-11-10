import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;
  final String apiKeyReverse;

  WeatherService(this.apiKey, this.apiKeyReverse);

  Future<Weather> getWeather(Position position) async {
    var lat = position.latitude;
    var lon = position.longitude;

    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$lat+$lon&key=$apiKeyReverse';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      String city = data['results'][0]['components']['city'];
      print(city);

      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to get weather data (position)');
    }
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather data (city name)');
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

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);

    // extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ??
        placemarks[0].subLocality ??
        placemarks[0].administrativeArea ??
        placemarks[0].subAdministrativeArea ??
        "";
  }
}