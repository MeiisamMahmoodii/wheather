import 'package:flutter/material.dart';
import 'package:wheather/models/wheather_model.dart';
import 'package:wheather/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WheatherPage extends StatefulWidget {
  const WheatherPage({super.key});

  @override
  State<WheatherPage> createState() => _WheatherPageState();
}

class _WheatherPageState extends State<WheatherPage> {
  final _weatherService = WeatherService("96e82012477d930807e9cd3ffb121d70");
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print(cityName);

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) {
      return ('assets/clear sky.json');
    }

    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/few clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'Snow':
        return 'assets/snow.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      default:
        return 'assets/clear sky.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //city name
          Text(
            _weather?.cityName ?? "loading city ...",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),

          //Lottie.asset('assets/clear sky.json'),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          // temperature
          Text(
            '${_weather?.temperature.round()}ºC',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700]),
          ),
        ]),
      ),
    );
  }
}
