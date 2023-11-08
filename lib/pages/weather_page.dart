import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      //print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    int hour = DateTime.now().hour;

    if (mainCondition == null) {
      if (hour > 8 && hour <= 16) {
        return 'assets/sun.json';
      } else {
        return 'assets/moon.json';
      }
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        if (hour > 8 && hour <= 16) {
          return 'assets/partly-cloudy.json';
        } else {
          return 'assets/partly-cloudy-night.json';
        }
      case 'mist':
        return 'assets/mist.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
        if (hour > 8 && hour <= 16) {
          return 'assets/rain.json';
        } else {
          return 'assets/rain-night.json';
        }
      case 'drizzle':
      case 'shower rain':
        if (hour > 8 && hour <= 16) {
          return 'assets/rain.json';
        } else {
          return 'assets/rain-night.json';
        }
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        if (hour > 8 && hour <= 16) {
          return 'assets/sun.json';
        } else {
          return 'assets/moon.json';
        }
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
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 12),
                  child: Icon(
                    Icons.location_pin,
                    color: Color.fromARGB(255, 216, 215, 215),
                    size: 29.0,
                  ),
                ),
                // city name
                Text(
                  _weather?.cityName ?? "Loading city...",
                  style: GoogleFonts.bebasNeue(
                    color: const Color.fromARGB(255, 216, 215, 215),
                    fontSize: 47,
                  ),
                ),
              ],
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text(
              "${_weather?.temperature.round()}°",
                style: GoogleFonts.bebasNeue(
                  color: const Color.fromARGB(255, 216, 215, 215),
                  fontSize: 87,
                )
            ),

            // weather condition
            /* Text(_weather?.mainCondition ?? "",
              style: const TextStyle(
                color: Color.fromARGB(255, 202, 202, 202),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
