import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/widgets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final searchController = TextEditingController();
  String cityName = 'islamabad';
  final formKey = GlobalKey<FormState>();

  Future getWeatherApi() async {
    try {
      final apiResponse = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$apiKey'));
      var data = jsonDecode(apiResponse.body);
      return data;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 5,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  cityName = 'islamabad';
                  searchController.text = 'islamabad';
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getWeatherApi(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final currentWeatherData = snapshot.data!['list'][0];
          final currentTempKelvin = currentWeatherData['main']['temp'];
          final currentTempC = (currentTempKelvin - 273.15).toStringAsFixed(2);
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final humidityLevel = currentWeatherData['main']['humidity'];
          final windSpeed = currentWeatherData['wind']['speed'];
          {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formKey,
                      child: TextFormField(
                        validator: (val){
          if (val == null || val.isEmpty) {
          return 'Please enter a city name';
          }
          return null;
          },
                        onChanged: (value) {},
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        textAlignVertical: TextAlignVertical.center,
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 3),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey
                            ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),

                          filled: true,
                          fillColor: Colors.black12,
                          hintText: 'Enter City Name',

                          suffixIcon: IconButton(
                            onPressed: () {

                              if(formKey.currentState!.validate()){
                                setState(() {
                                  cityName = searchController.text.trim();
                                });
                              }
                            },
                            icon: const Icon(Icons.search),
                            color: Colors.white54,
                          ),
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        color: Colors.blueGrey[500],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTempC °C",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,color: Colors.white,
                                      fontSize: 32),
                                ),
                                const SizedBox(height: 10),
                                Icon(
                                    currentSky == 'Clouds'
                                        ? Icons.cloud_sharp
                                        : currentSky == 'Clear'
                                            ? Icons.sunny
                                            : currentSky == 'Rain'
                                                ? Icons.cloudy_snowing
                                                : Icons.cloud_queue_sharp,
                                    size: 60,
                                    color: currentSky == 'Clear'
                                        ? Colors.yellow
                                        : Colors.blue[100]),
                                const SizedBox(height: 5),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 18,color: Colors.white, ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(' Weather Forecast',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final hourlyForecast =
                              snapshot.data['list'][index + 1];
                          final hourlySky =
                              hourlyForecast['weather'][0]['main'];
                          final hourlyTempKelvin =
                              hourlyForecast['main']['temp'];
                          final hourlyTempC =
                              (hourlyTempKelvin - 273.15).toStringAsFixed(2);
                final time = DateTime.parse(hourlyForecast['dt_txt']);
                          return ForecastCard(
                            time: DateFormat.j().format(time),
                            temperature: hourlyTempC + ' °C',
                            icon: hourlySky == 'Clouds'
                                ? Icons.cloud_sharp
                                : hourlySky == 'Clear'
                                    ? Icons.sunny
                                    : hourlySky == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : Icons.cloud_queue_sharp,
                            iconColor: currentSky == 'Clear'
                                ? Colors.yellow
                                : Colors.blue[100],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(' Additional Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdditionalInfo(
                          icon: Icons.water_drop_sharp,
                          forecast: 'Humidity',
                          value: humidityLevel.toString(),
                        ),
                        AdditionalInfo(
                          icon: Icons.air_sharp,
                          forecast: 'Wind speed',
                          value: windSpeed.toString(),
                        ),
                        AdditionalInfo(
                          icon: Icons.beach_access_sharp,
                          forecast: 'Pressure',
                          value: currentPressure.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
