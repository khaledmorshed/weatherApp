import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather/globals/date_convertion.dart';
import 'package:weather/globals/get_user_location.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/screens/settings_screen.dart';

import '../globals/constans_values.dart';

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
        _weatherProvider = Provider.of<WeatherProvider>(context);
        _getUserLocation();
        _isInit = false;
      }

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
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text("Welcome"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              _getUserLocation();
            },
              icon: Icon(Icons.my_location),),
          IconButton(
            onPressed: ()async{
              final result = await showSearch(context: context, delegate: _CitySearchDelegate());
              if(result != null){
                _convetCityToLatLong(result);
              }
            },
            icon: Icon(Icons.search),),
          IconButton(
            onPressed: ()=>Navigator.pushNamed(context, SettingsScreen.path),
            icon: Icon(Icons.settings),),
        ],
      ),
      body: _weatherProvider.hasDataLoaded ?  ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _weatherSection(),
          SizedBox(height: 25,),
          _forecastSection(),
        ],
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  Widget _weatherSection() {
    return Column(
      children: [
        Text(getFormattedDate(_weatherProvider.currentResponse!.dt!, 'MMM dd, yyyy hh:mm a'),style: txtDateStyle,),
        Text('${_weatherProvider.currentResponse!.name}, ${_weatherProvider.currentResponse!.sys!.country}', style: txtAddressStyle,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_weatherProvider.currentResponse!.main!.temp!.round()}\u00B0', style: txtTempBig80Style),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('${_weatherProvider.currentResponse!.main!.tempMin!.round()}/${_weatherProvider.currentResponse!.main!.tempMin!.round()}\u00B0', style: txtTempNormal16Style),
              ),
            ],
          ),
        ),
        Text("feels like ${_weatherProvider.currentResponse!.main!.feelsLike!.round()}", style: txtTempNormal16Style,),
        Image.network("$iconPrefix${_weatherProvider.currentResponse!.weather![0].icon}$iconSuffix", color: Colors.white60,),
        Text(_weatherProvider.currentResponse!.weather!.first.description!, style: txtAddressStyle,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Text('humidity ', style: txtDefaultStyleWhite54,),
              Text('${_weatherProvider.currentResponse!.main!.humidity}%', style: txtDefaultStyle,),
              Text(' pressure ', style: txtDefaultStyleWhite54,),
              Text('${_weatherProvider.currentResponse!.main!.pressure}hPa', style: txtDefaultStyle,),
              Text(' speed ', style: txtDefaultStyleWhite54,),
              Text('${_weatherProvider.currentResponse!.wind!.speed}m/s', style: txtDefaultStyle,),
              Text(' visibility ', style: txtDefaultStyleWhite54,),
              Text('${_weatherProvider.currentResponse!.visibility}km', style: txtDefaultStyle,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _forecastSection() {
    return Card(
      elevation: 10,
      child: Container(
        color: Colors.blueAccent,
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _weatherProvider.forecastResponse!.list!.length,
          itemBuilder: (context, index){
            final item = _weatherProvider.forecastResponse!.list![index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(getFormattedDate(item.dt!, 'EEE HH:mm'), style: txtDateStyle,),
                  Image.network("$iconPrefix${item.weather![0].icon}$iconSuffix", height: 40, width: 40,),
                  Text(item.weather!.first.description!, style: txtAddressStyle,),
                  Text('${item.main!.tempMin!.round()}/${item.main!.tempMin!.round()}\u00B0', style: txtTempNormal16Style),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _convetCityToLatLong(String result)async {
    try{
      //locationFromAddress will return list of location.
      final  locationList = await locationFromAddress(result);
      if(locationList.isNotEmpty){
        final location = locationList.first;
        _weatherProvider.setNewLatLong(location.latitude, location.longitude);
      }
    }catch(error){
      ScaffoldMessenger.of(context).
      showSnackBar(
          SnackBar(
            content: const Text("Invalid city", style: TextStyle(color: Colors.red),),
            backgroundColor: Colors.white,
      ),
      );
      throw error;
    }
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {

  //clear action
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        //query is the property of SearchDelegate. in search what we type all stay inside of
        //query..now we are inputting inside of query just empty
        query = '';
      },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    IconButton(onPressed: (){
      //what we will type in search option it will return that value which is inside of query
      close(context, query);
    },
        icon: Icon(Icons.arrow_back));
  }

  //here user what will search it will show
  //have to return a widget
  @override
  Widget buildResults(BuildContext context) {

    return ListTile(
      leading: Icon(Icons.search),
      title: Text(query),
      onTap: (){
        close(context, query);
      },
    );
  }

  //what we will show  in suggestion
  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty ? cities :
        cities.where((city) => city.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: filteredList.map((city) =>
          ListTile(
            onTap: (){
              close(context, city);
            },
        title: Text(city),
      )).toList(),
    );
  }

}
