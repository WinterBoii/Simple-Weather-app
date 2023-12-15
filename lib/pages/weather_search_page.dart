import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather/models/temperature_model.dart';
import 'package:simple_weather/services/temperature_service.dart';
import 'package:simple_weather/utilities/weather_animation.dart';

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  bool _citySearched = false;
  String _searchedCity = '';
  // Define a FocusNode
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('search_page_scaffold'),
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 36, 36, 36),
          foregroundColor: const Color.fromARGB(255, 216, 215, 215),
          title: _citySearched
              ? null
              : TextField(
                  key: const Key('search_text_field'),
                  focusNode: myFocusNode,
                  controller: TextEditingController(text: _searchedCity.trim()),
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
                  onChanged: (city) {
                    _searchedCity = city.trim();
                  },
                  onSubmitted: (city) {
                    _searchedCity = city.trim();
                    setState(() {});
                  },
                  style: const TextStyle(
                      color: Color.fromARGB(255, 210, 192, 192)),
                ),
          actions: [
                  IconButton(
              key: Key(_citySearched ? 'edit_button' : 'search_button'),
              icon: Icon(_citySearched ? Icons.edit : Icons.search,
                  color: const Color.fromARGB(255, 216, 215, 215)),
                    onPressed: () {
                myFocusNode.unfocus();
                _citySearched = false;
                setState(() {});
                    },
                  )
                ]
              ),
      body: CurrentWeather(_searchedCity),
    );
  }
}

class CurrentWeather extends StatelessWidget {
  final String city;

  CurrentWeather(this.city, {super.key});

  final _temperatureService =
      TemperatureService('6cb67d7d502d5ceab0e7ffc381453e90');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        key: const Key('weather_future_builder'),
        future: fetchWeather(city),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.cityName.isNotEmpty) {
            Temperature? weather = snapshot.data;
            return Column(
              key: const Key('weather_column'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(29),
                    children: <Widget>[
                      Column(
                        key: const Key('location_column'),
                        children: <Widget>[
                          const Icon(
                            Icons.location_pin,
                            color: Color.fromARGB(255, 216, 215, 215),
                            size: 29.0,
                          ),
                          // city name
                          Text(
                            weather?.cityName ?? "Loading city...",
                            key: const Key('search_city_name'),
                            style: GoogleFonts.bebasNeue(
                              color: const Color.fromARGB(255, 216, 215, 215),
                              fontSize: 54,
                            ),
                          ),
                        ],
                      ),
                  
                      // animation
                      Lottie.asset(
                          getWeatherAnimation(weather?.mainCondition,
                              weather?.sunrise, weather?.sunset),
                          key: const Key('weather_animation')),
                  
                      // temperature
                      Column(
                        key: const Key('temperature_column'),
                        children: <Widget>[
                          Text("${weather?.temperature.round()}°".padLeft(4),
                              style: GoogleFonts.bebasNeue(
                                color: const Color.fromARGB(255, 216, 215, 215),
                                fontSize: 87,
                              ),
                              key: const Key('temperature_text')),
                  
                          // weather description
                          Text(
                            weather?.description ?? "ey",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 202, 202, 202),
                            ),
                            key: const Key('weather_description'),
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
                ),
              ],
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

