import 'package:dio/dio.dart' as http;
import 'package:weather_app/models/weather_model.dart';
class WeatherApi {
  static const String apiKey = "2d02f066977b377b9de33a1f651ed31f";
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  Future fetchWeather(String city) async {
    var url = "$baseUrl?q=$city&appid=$apiKey";
    var response = await http.Dio().get(url);
    return WeatherData.fromJson(response.data);
  }
  Future fetchWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.Dio().get('$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

    if (response.statusCode == 200) {
      return WeatherData.fromJson(response.data);
    } else {
      throw Exception('Failed to load Location');
    }
  }
}

