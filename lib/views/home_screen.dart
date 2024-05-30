import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/viewmodels/weather_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              context.read<WeatherViewModel>().fetchWeatherByLocation();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      context.read<WeatherViewModel>().fetchWeather(_cityController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<WeatherViewModel>(
              builder: (context, weatherViewModel, child) {
                if (weatherViewModel.isLoading) {
                  return const CircularProgressIndicator();
                } else if (weatherViewModel.errorMessage != null) {
                  return Text(
                    weatherViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (weatherViewModel.currentWeather != null) {
                  return Column(
                    children: [
                      Text(
                        weatherViewModel.currentWeather.name??"",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${weatherViewModel.currentWeather.main!.temp}°C',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weatherViewModel.currentWeather.weather![0].description??"",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Humidity: ${weatherViewModel.currentWeather.main!.humidity}%',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Wind Speed: ${weatherViewModel.currentWeather.wind!.speed} m/s',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return const Text('Enter a city or use your location to get weather information.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
