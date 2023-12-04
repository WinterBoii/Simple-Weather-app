import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather/models/temperature_model.dart';
import 'package:simple_weather/pages/weather_search_page.dart';
import 'package:simple_weather/services/temperature_service.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utilities/weather_animation.dart';

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

  late Future _fetchWeatherFuture;

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
      });
      return;
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

    _fetchWeatherFuture = _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchWeatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else {
          return Scaffold(
            key: Key('weather_scaffold'),
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color.fromARGB(255, 36, 36, 36),
            floatingActionButton: FloatingActionButton(
              key: Key('search_button'),
              onPressed: () {
                showSearchPage(context);
              },
              child: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 36, 36, 36),
                size: 29.0,
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Icon(
                        Icons.location_pin,
                        color: Color.fromARGB(255, 216, 215, 215),
                        size: 29.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                              width: 5), // Add space between icon and text
                          // city name
                          Text(
                            _weather?.cityName ?? "Loading city...",
                            key: Key('city_name'),
                            style: GoogleFonts.bebasNeue(
                              color: const Color.fromARGB(255, 216, 215, 215),
                              fontSize: 54,
                            ),
                          ),
                          const SizedBox(
                              width: 5), // Add space between text and icon
                          IconButton(
                            key: Key('refresh_button'),
                            onPressed: () async {
                              // TODO Add refresh functionality
                              await _fetchWeather();
                            },
                            icon: const Icon(
                              Icons.refresh, // Add refresh icon
                              color: Color.fromARGB(255, 216, 215, 215),
                              size: 29.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // animation
                  Lottie.asset(getWeatherAnimation(_temperature?.mainCondition,
                      _temperature?.sunrise, _temperature?.sunset)),
                  // temperature
                  TemperatureCard(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<dynamic> showSearchPage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 1.0,
          maxChildSize: 1.0,
          builder: (_, controller) => const WeatherSearchPage()),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  Column TemperatureCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("${_temperature?.temperature.round()}°".padLeft(4),
            style: GoogleFonts.bebasNeue(
              color: const Color.fromARGB(255, 216, 215, 215),
              fontSize: 87,
            ),
            key: Key('temperature_text')),

        // weather description
        Text(
          _temperature!.description,
          key: Key('weather_description'),
          style: const TextStyle(
            color: Color.fromARGB(255, 202, 202, 202),
          ),
        ),
        const Text(
          "> Winter",
          style: TextStyle(
              color: Color.fromARGB(255, 202, 202, 202),
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  String _formatTime(DateTime time, BuildContext context) {
    var format = DateFormat.jm();
    if (MediaQuery.alwaysUse24HourFormatOf(context)) {
      format = DateFormat.Hm();
    }
    return format.format(time);
  }
}
