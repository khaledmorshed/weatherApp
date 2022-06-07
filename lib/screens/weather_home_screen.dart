import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/globals/get_user_location.dart';
import 'package:weather/providers/weather_provider.dart';

class WeatherHomeScreen extends StatefulWidget {
  static const String path = '/';

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late WeatherProvider _weatherProvider;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
      if(_isInit){
        _weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
        _getUserLocation();
      }
      _isInit = false;
  }

  _getUserLocation(){
    determinePosition().then((position){
      setState((){
        final latitude = position.latitude;
        final longitude = position.longitude;
        _weatherProvider.setNewLatLong(latitude, longitude);
        print(" ${position.latitude}  + ${position.longitude}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: _weatherProvider.hasDataLoaded != null ?  ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _weatherSection(),
          _forecastSection(),
        ],
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  Widget _weatherSection() {
    return Column();
  }

  Widget _forecastSection() {
    return Container();
  }
}
