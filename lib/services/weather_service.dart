import 'dart:convert';

import 'package:weather_app_api/models/weather_model.dart';
import 'package:http/http.dart' as http;
class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static const GEO_URL = 'http://api.openweathermap.org/geo/1.0/direct';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final respose = await http.get(Uri.parse('$BASE_URL?q=cityName&apiid=$apiKey&units=metric'));

    if(respose.statusCode ==200){
      return Weather.fromJson(jsonDecode(respose.body));

    }else{
      throw Exception('failed to load weather');
    }
  }


Future<List<String>> getCitySuggestions(String query) async{
  final response = await http.get(Uri.parse('$GEO_URL?q=$query&limit=5&apiid=$apiKey'));

      if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      
      return data.map<String>((json) => ['name'] as String).toList();
    } else {
      throw Exception("Failed to fetch city suggestions");
    }
  }}