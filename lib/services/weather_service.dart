import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:wheather/models/wheather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<String> getCurrentCity() async {
    //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert location to list of placemark locations
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //get city name from placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
