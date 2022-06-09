import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String weatherApiKey = '2e765d67283a0a801e0600bbd56cdfc2';
//te get icon url : https://openweathermap.org/weather-conditions
const String iconPrefix = 'https://openweathermap.org/img/wn/';
const String iconSuffix = '@2x.png';

const cities = ['Athens', 'Dhaka', 'Delhi', 'Colombo', 'Karachi', 'London', 'Sydney', 'Los Angeles', 'New York'];

Future<bool> setTempStatus(bool status)async{
  //if we call SharedPreferences.getInstance() multiple times though it return value only one time
  final prefs = await SharedPreferences.getInstance();
  return prefs.setBool('status', status);
}
Future<bool> getTempStatus()async{
  final prefs = await SharedPreferences.getInstance();
  //if prefs.getBool('status') is null then it will return false
  return prefs.getBool('status') ?? false;
}

const txtTempBig80Style = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.bold,
    color: Colors.white
);

const txtTempNormal16Style = TextStyle(
    fontSize: 16,
    color: Colors.white70
);

const txtDateStyle = TextStyle(
    fontSize: 16,
    letterSpacing: 1.2,
    color: Colors.white70
);

const txtAddressStyle = TextStyle(
    fontSize: 18,
    letterSpacing: 1.2,
    color: Colors.white
);

const txtDefaultStyleWhite54 = TextStyle(
    fontSize: 14,
    letterSpacing: 1.0,
    color: Colors.white70
);

const txtDefaultStyle = TextStyle(
    fontSize: 14,
    letterSpacing: 1.0,
    color: Colors.white
);