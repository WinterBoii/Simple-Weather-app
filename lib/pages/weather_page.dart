import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather/models/temperature_model.dart';
import 'package:simple_weather/services/temperature_service.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // ? api key
  final _weatherService = WeatherService('c1cd135b14944312acecb0fbba0d32f4');
  final _temperatureService =
      TemperatureService('6cb67d7d502d5ceab0e7ffc381453e90');

  Weather? _weather;
  Temperature? _temperature;

  // fetch weather
  _fetchWeather() async {
    // get current position
    Position position = await _weatherService.getCurrentPosition();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(position);

      // get current city
      String cityName = weather.cityName;
      final temperature = await _temperatureService.getWeatherByCity(cityName);
      setState(() {
        _weather = weather;
        _temperature = temperature;
      });
    }

    // any errors
    catch (e) {
      print(e);
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

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
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
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_temperature?.mainCondition)),

            // temperature
            Column(
              children: [
                Text("${_temperature?.temperature.round()}°",
                    style: GoogleFonts.bebasNeue(
                      color: const Color.fromARGB(255, 216, 215, 215),
                      fontSize: 87,
                    )
                ),

                // weather description
                Text(
                  _temperature?.description ?? "",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 202, 202, 202),
                  ),
                ),
                /* Text(
                  _weather!.sunrise.toString(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 202, 202, 202),
                  ),
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
