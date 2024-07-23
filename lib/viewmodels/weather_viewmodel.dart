import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/api/weather_api.dart';

class WeatherViewModel with ChangeNotifier {
  late WeatherData _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;
  bool isSearchOpen = false;
  WeatherData get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentWeather = await WeatherApi().fetchWeather(city);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Error fetching weather data: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    //notifyListeners();
    try {
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permissions are denied.');
        }
      }

      LocationData locationData = await location.getLocation();

      _currentWeather = await WeatherApi().fetchWeatherByCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Error fetching weather data: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  String getWeatherAnimation() {
    if (_currentWeather.weather![0].main == 'Clouds') {
      return 'assets/fog.json';
    } else if (_currentWeather.weather![0].main == 'Rain') {
      return 'assets/rain.json';
    } else if (_currentWeather.weather![0].main == 'Thunderstorm') {
      return 'assets/storm.json';
    } else {
      return 'assets/sunny.json';
    }
  }
}