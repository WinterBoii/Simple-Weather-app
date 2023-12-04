String getWeatherAnimation(
    String? mainCondition, DateTime? sunriseTime, DateTime? sunsetTime) {
  DateTime now = DateTime.now();

  if (mainCondition == null) {
    return 'assets/loading.json';
  }

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
      if (now.isAfter(sunriseTime!) && now.isBefore(sunsetTime!)) {
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
      if (now.isAfter(sunriseTime!) && now.isBefore(sunsetTime!)) {
        return 'assets/rain.json';
      } else {
        return 'assets/rain-night.json';
      }
    case 'drizzle':
    case 'shower rain':
      if (now.isAfter(sunriseTime!) && now.isBefore(sunsetTime!)) {
        return 'assets/rain.json';
      } else {
        return 'assets/rain-night.json';
      }
    case 'thunderstorm':
      return 'assets/thunder.json';
    case 'snow':
      return 'assets/snow.json';
    default:
      if (now.isAfter(sunriseTime!) && now.isBefore(sunsetTime!)) {
        return 'assets/sun.json';
      } else {
        return 'assets/moon.json';
      }
  }
}
