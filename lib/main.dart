import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/screens/settings_screen.dart';
import 'package:weather/screens/weather_home_screen.dart';

import 'providers/weather_provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WeatherHomeScreen.path,
      routes: {
        WeatherHomeScreen.path: (context)=> WeatherHomeScreen(),
        SettingsScreen.path: (context) => SettingsScreen(),
      },
    );
  }
}
