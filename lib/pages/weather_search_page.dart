import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather/models/temperature_model.dart';
import 'package:simple_weather/services/temperature_service.dart';
import 'package:simple_weather/utiliities/weather_animation.dart';

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  bool _citySearched = false;
  String _searchedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 36, 36, 36),
          foregroundColor: const Color.fromARGB(255, 216, 215, 215),
          title: _citySearched
              ? Text(_searchedCity,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 216, 215, 215)))
              : TextField(
                  cursorColor: const Color.fromARGB(255, 216, 215, 215),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 216, 215, 215)),
                    ),
                    hintText: 'Enter city',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 210, 192, 192)),
                  ),
                  onSubmitted: (city) {
                    _searchedCity = city.trim();
                    _citySearched = true;
                    setState(() {});
                  },
                  style: const TextStyle(
                      color: Color.fromARGB(255, 210, 192, 192)),
                ),
          actions: _citySearched
              ? [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Color.fromARGB(255, 216, 215, 215)),
                    onPressed: () {
                      _citySearched = false;
                      setState(() {});
                    },
                  )
                ]
              : []),
      body: CurrentWeather(_searchedCity),
    );
  }
}

class CurrentWeather extends StatelessWidget {
  final String city;

  CurrentWeather(this.city);

  final _temperatureService =
      TemperatureService('6cb67d7d502d5ceab0e7ffc381453e90');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchWeather(city),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.cityName.isNotEmpty) {
            Temperature? weather = snapshot.data;
            return Center(
              child: ListView(
                padding: const EdgeInsets.all(19),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(
                        Icons.location_pin,
                        color: Color.fromARGB(255, 216, 215, 215),
                        size: 29.0,
                      ),
                      // city name
                      Text(
                        weather?.cityName ?? "Loading city...",
                        style: GoogleFonts.bebasNeue(
                          color: const Color.fromARGB(255, 216, 215, 215),
                          fontSize: 54,
                        ),
                      ),
                    ],
                  ),

                  // animation
                  Lottie.asset(getWeatherAnimation(weather?.mainCondition,
                      weather?.sunrise, weather?.sunset)),

                  // temperature
                  Column(
                    children: <Widget>[
                      Text("${weather?.temperature.round()}°".padLeft(4),
                          style: GoogleFonts.bebasNeue(
                            color: const Color.fromARGB(255, 216, 215, 215),
                            fontSize: 87,
                          )),

                      // weather description
                      Text(
                        weather?.description ?? "ey",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 202, 202, 202),
                        ),
                      ),
                      const Text(
                        "*Winter",
                        style: TextStyle(
                            color: Color.fromARGB(255, 202, 202, 202),
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (city.isNotEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center();
          }
        });
  }

  Future<Temperature> fetchWeather(String city) async {
    // API call to get weather data
    return await _temperatureService.getWeatherByCity(city);
  }
}
