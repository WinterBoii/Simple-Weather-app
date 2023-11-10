import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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

  DateTime sunriseTime = DateTime.now();
  DateTime sunsetTime = DateTime.now();

  // fetch weather
  _fetchWeather() async {
    // get current position
    Position position = await _weatherService.getCurrentPosition();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(position);

      // get current city
      String cityName = weather!.cityName;

      final temperature = await _temperatureService.getWeatherByCity(cityName);
      setState(() {
        _weather = weather;
        _temperature = temperature;

        sunriseTime =
            DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);
        sunsetTime = DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);
      });
    }

    // any errors
    catch (e) {
      print(e);
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
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
                      fontSize: 54,
                    ),
                  ),
                ],
              ),
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_temperature?.mainCondition)),

            // temperature
            Column(
              children: <Widget>[
                Text("${_temperature?.temperature.round()}°".padLeft(4),
                    style: GoogleFonts.bebasNeue(
                      color: const Color.fromARGB(255, 216, 215, 215),
                      fontSize: 87,
                    )
                ),

                // weather description
                Text(
                  _temperature?.description ?? "ey",
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

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    DateTime now = DateTime.now();

    if (mainCondition == null) {
      return 'assets/loading.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        if (now.isAfter(sunriseTime) && now.isBefore(sunsetTime)) {
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
        if (now.isAfter(sunriseTime) && now.isBefore(sunsetTime)) {
          return 'assets/rain.json';
        } else {
          return 'assets/rain-night.json';
        }
      case 'drizzle':
      case 'shower rain':
        if (now.isAfter(sunriseTime) && now.isBefore(sunsetTime)) {
          return 'assets/rain.json';
        } else {
          return 'assets/rain-night.json';
        }
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        if (now.isAfter(sunriseTime) && now.isBefore(sunsetTime)) {
          return 'assets/sun.json';
        } else {
          return 'assets/moon.json';
        }
    }
  }

  String _formatTime(DateTime time, BuildContext context) {
    var format = DateFormat.jm();
    if (MediaQuery.alwaysUse24HourFormatOf(context)) {
      format = DateFormat.Hm();
    }
    return format.format(time);
  }
}
