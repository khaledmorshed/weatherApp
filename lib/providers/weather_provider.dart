import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:weather/globals/constans_values.dart';
import 'package:weather/models/current_weather_response.dart';
import 'package:weather/models/forecast_response.dart';

class WeatherProvider with ChangeNotifier{
  double latitude = 0.0;
  double longitude = 0.0;
  CurrentWeatherResponse? currentWeatherResponse;
  ForecastResponse? forecastResponse;
  void setNewLatLong(double lat, double lng){
      latitude = lat;
      longitude = lng;
      _getWeatherData();
  }

  bool get hasDataLoaded => currentWeatherResponse != null && forecastResponse != null ;

  void _getWeatherData() {
    _getCurrentWeatherData();
    _getForecastData();
  }

  void _getCurrentWeatherData() async{
    final foreCastUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey';
    try{
      //we get value in json inside of response.
      final  response = await get(Uri.parse(foreCastUrl));
      if(response.statusCode == 200){
        //so we have convert the json value into map
        final map = json.decode(response.body);
        currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
        print("Currrent data : ${currentWeatherResponse!.main!.temp}");
        notifyListeners();
      }
    }catch(error){
      throw error;
    }
  }

  void _getForecastData() async{
    final foreCastUrl = 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$weatherApiKey';
    try{
      //we get value in json inside of response.
       final  response = await get(Uri.parse(foreCastUrl));
       if(response.statusCode == 200){
         //so we have convert the json value into map
         final map = json.decode(response.body);
         forecastResponse = ForecastResponse.fromJson(map);
         print("forecas : ${forecastResponse!.list!.length}");
         notifyListeners();
       }
    }catch(error){
      throw error;
    }
  }
}
