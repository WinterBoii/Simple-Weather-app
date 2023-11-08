// Can successfully get weather data for a given city name
// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_weather/services/weather_service.dart';

void test_get_weather_data_for_city_name() async {
  final weatherService = WeatherService('API_KEY');
  final weather = await weatherService.getWeather('London');
  expect(weather.cityName, 'London');
}

// Can successfully get current city name based on user's location
void test_get_current_city_name() async {
  final weatherService = WeatherService('API_KEY');
  final currentCity = await weatherService.getCurrentCity();
  expect(currentCity, isNotEmpty);
}

// Can handle and throw exception if API key is invalid or missing
void test_handle_invalid_or_missing_api_key() async {
  final weatherService = WeatherService('');
  try {
    await weatherService.getWeather('London');
    fail('Exception not thrown');
  } catch (e) {
    expect(e, isException);
  }
}
