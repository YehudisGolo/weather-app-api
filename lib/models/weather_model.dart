class Weather {
  final String cityName;
  final double temperture;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temperture,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperture: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
