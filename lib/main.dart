import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "Mumbai";
  String weather = "";
  String temperature = "";
  final String apiKey = "c1f5187177a454880933789a73a4fc02";

  Future<void> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
      ));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          weather = data['weather'][0]['description'];
          temperature = data['main']['temp'].toString();
        });
      } else {
        setState(() {
          weather = "City not found";
          temperature = "";
        });
      }
    } catch (e) {
      setState(() {
        weather = "Error fetching weather data";
        temperature = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter city name",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  cityName = value.trim();
                });
                fetchWeather(cityName);
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),
            Text(
              cityName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              weather,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              temperature.isNotEmpty ? '$temperature°C' : "",
              style: const TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
