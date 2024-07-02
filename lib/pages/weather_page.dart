import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_api/models/weather_model.dart';

import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleDarkMode;

  const WeatherPage({required this.isDarkMode, required this.toggleDarkMode});

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _WeatherService = WeatherService('bac491aa4eef7c9e8d2ae32b7502cbce');

  Weather? _weather;

  final TextEditingController _controller = TextEditingController();

  _fetchWeather([String cityName = 'Jerusalem']) async {
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'cloud':
      case 'mist':
      case 'fug':
      case 'smoke':
      case 'haze':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunder storm':
        return 'assets/thunder.json';
      case 'clear':
      default:
        return 'assets/sunny.json';
    }
  }

  void initState() {
    super.initState();
    _fetchWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            onPressed: widget.toggleDarkMode as void Function(),
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Setting',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.toggleDarkMode();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter city name",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(
                        12.0), // Adjust the padding as needed
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                  filled: true, // Adds a background color to the text field
                  fillColor:
                      Colors.grey[200], // Adjust the fill color as needed
                ),
                style: TextStyle(color: Colors.black),
                onSubmitted: (String cityName) {
                  _fetchWeather(cityName);
                },
              ),
              SizedBox(height: 20),
              Text(
                _weather?.cityName ?? 'loading...',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text(
                '${_weather?.temperture?.round() ?? ''}C',
                style: TextStyle(
                  fontSize: 32,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                _weather?.mainCondition ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
