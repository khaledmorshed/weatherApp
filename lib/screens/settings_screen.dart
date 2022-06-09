import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals/constans_values.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String path = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isChecked = false;

  @override
  void initState() {
    getTempStatus().then((value) {
      setState((){
        _isChecked = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => SwitchListTile(
                activeColor: Colors.amber,
                title: const Text('Show temperature in Fahrenheit'),
                subtitle: const Text('Default is Celsius'),
                value: _isChecked,
                onChanged: (value) async {
                  setState(() {
                    _isChecked = value;
                  });
                  await setTempStatus(value);
                  provider.reload();
                }
            ),
          )
        ],
      ),
    );
  }
}
