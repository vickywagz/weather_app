import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      String cityName = 'Lagos';
      final result = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      setState(() {
        temp = (data['list'][0]['main']['temp']);
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '$temp K',
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          const Text(
                            'Rain',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Weather Forcast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                HourlyForcastItem(
                  time: '00:00',
                  icon: Icons.cloud,
                  temperature: '301.22',
                ),
                HourlyForcastItem(
                  time: '03:00',
                  icon: Icons.sunny,
                  temperature: '300.52',
                ),
                HourlyForcastItem(
                  time: '06:00',
                  icon: Icons.cloud,
                  temperature: '302.22',
                ),
                HourlyForcastItem(
                  time: '09:00',
                  icon: Icons.sunny,
                  temperature: '300.12',
                ),
                HourlyForcastItem(
                  time: '12:00',
                  icon: Icons.cloud,
                  temperature: '304.12',
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '91',
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '7.5',
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
