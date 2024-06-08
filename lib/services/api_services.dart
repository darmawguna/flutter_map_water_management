// import '../consts/strings.dart';
import 'package:http/http.dart' as http;
import 'package:waterspring/models/current_weather_model.dart';
import 'package:waterspring/models/hourly_weather_model.dart';

var baseUrl = "https://api.openweathermap.org/data/2.5/weather";

var apiKey = "15571d02f11138f3c7f6dbc25e9d937d";

getCurrentWeather(lat, long) async {
  var link =
      "$baseUrl?lat=-8.182047681414021&lon=115.12168471209768&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = currentWeatherDataFromJson(res.body.toString());

    return data;
  }
}

getHourlyWeather(lat, long) async {
  var link =
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(res.body.toString());

    return data;
  }
}
