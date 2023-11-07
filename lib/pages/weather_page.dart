import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('6cb67d7d502d5ceab0e7ffc381453e90');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sun.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 36, 36),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Icon(
                    Icons.location_pin,
                    color: Color.fromARGB(255, 216, 215, 215),
                    size: 28.0,
                  ),
                ),
                // city name
                Text(
                  _weather?.cityName ?? "Loading city...",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 216, 215, 215),
                  ),
                ),
              ],
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text("${_weather?.temperature.round()}°C",
              style: const TextStyle(
                  color: Color.fromARGB(255, 202, 202, 202),
                ),
            ),

            // weather condition
            Text(_weather?.mainCondition ?? "",
              style: const TextStyle(
                color: Color.fromARGB(255, 202, 202, 202),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
