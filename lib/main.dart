import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UZ(),
  ));
}

class UZ extends StatefulWidget {
  const UZ({super.key});

  @override
  State<UZ> createState() => _UZState();
}

class _UZState extends State<UZ> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Imtihon()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class Imtihon extends StatefulWidget {
  const Imtihon({super.key});

  @override
  State<Imtihon> createState() => _ImtihonState();
}

final List<Map<String, dynamic>> weatherData = [];

class _ImtihonState extends State<Imtihon> {
  final TextEditingController _cityController = TextEditingController();
  String city = "";
  String weather = "Loading...";
  String temp = "";
  String time = "";
  String lottieAsset = "";
  String windSpeed = "";
  String humidity = "";
  String cloudiness = "";

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    final url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=40b2851af21546fbbd294943232312&q=kokand&days=2&aqi=yes&alerts=yes");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["location"] != null) {
          setState(() {
            weather = data["current"]["condition"]["text"];
            temp = "${data["current"]["temp_c"]}°C";
            windSpeed = "${data["current"]["wind_kph"]} kph";
            humidity = "${data["current"]["humidity"]}%";
            cloudiness = "${data["current"]["cloud"]}%";
            String currentTime = data["location"]["localtime"];
            DateTime dateTime = DateTime.parse(currentTime);
            time = DateFormat('HH:mm').format(dateTime);

            lottieAsset = getLottieAnimation(weather);

            weatherData.clear();
            for (int i = 0; i < 5; i++) {
              weatherData.add({
                "temp":
                    "${data["forecast"]["forecastday"][0]["hour"][i * 3]["temp_c"]}°C",
                "time": DateFormat('HH:mm').format(DateTime.parse(
                    data["forecast"]["forecastday"][0]["hour"][i * 3]["time"])),
                "weather": data["forecast"]["forecastday"][0]["hour"][i * 3]
                    ["condition"]["text"],
                "icon": getLottieAnimation(data["forecast"]["forecastday"][0]
                    ["hour"][i * 3]["condition"]["text"]),
              });
            }
          });
        }
      } else {
        setState(() {
          weather = "Ma'lumot topilmadi";
          temp = "";
          time = "";
          windSpeed = "";
          humidity = "";
          cloudiness = "";
          lottieAsset = "";
        });
      }
    } catch (e) {
      setState(() {
        weather = "Xatolik!";
        temp = "";
        time = "";
        windSpeed = "";
        humidity = "";
        cloudiness = "";
        lottieAsset = "";
      });
    }
  }

  String getLottieAnimation(String condition) {
    if (condition.toLowerCase().contains("clear") ||
        condition.toLowerCase().contains("sunny")) {
      return "lotti/Animation - 1719045821454.json"; // Sunny animation
    } else if (condition.toLowerCase().contains("rain")) {
      return "lotti/Animation - 1719045923306.json"; // Rain animation
    } else if (condition.toLowerCase().contains("cloudy")) {
      return "lotti/Animation - 1719045821454.json"; // Cloudy animation
    } else if (condition.toLowerCase().contains("snow")) {
      return "lotti/Animation - 1719045728048.json"; // Snow animation
    } else if (condition.toLowerCase().contains("wind")) {
      return "lotti/Animation - 1719045821454.json"; // Wind animation
    } else {
      return "lotti/Animation - 1719210356429.json"; // Default animation for unclear weather
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 602,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 0.5, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: "Shahar nomi",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      Icon(Icons.location_on, color: Colors.white, size: 30),
                      Text(
                        city,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.more_vert, color: Colors.white, size: 30),
                    ],
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        city = _cityController.text;
                      });
                      fetchWeather(
                          city); // Make sure to call fetchWeather with the new city
                    },
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          Text(
                            "Updating",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 220,
                    width: 200,
                    child: Lottie.asset(lottieAsset, height: 200, width: 200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    temp,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    weather,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    time,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.blue[300],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 104,
                            width: 100,
                            child: Column(
                              children: [
                                Image.asset("rasm/1.png"),
                                Text(
                                  windSpeed.isNotEmpty ? windSpeed : "N/A",
                                  style: m,
                                ),
                                Text(
                                  "Windy",
                                  style: m1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 104,
                            width: 100,
                            child: Column(
                              children: [
                                Image.asset("rasm/1.png"),
                                Text(
                                  humidity.isNotEmpty ? humidity : "N/A",
                                  style: m,
                                ),
                                Text(
                                  "Humidity",
                                  style: m1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 104,
                            width: 100,
                            child: Column(
                              children: [
                                Image.asset("rasm/1.png"),
                                Text(
                                  cloudiness.isNotEmpty ? cloudiness : "N/A",
                                  style: m,
                                ),
                                Text(
                                  "Cloudy",
                                  style: m1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 270),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "24 Hours >",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: weatherData.map((data) {
                      return Container(
                        height: 108,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border:
                              Border.all(width: 1, color: Colors.grey.shade800),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                data["temp"],
                                style: m,
                              ),
                              Lottie.asset(data["icon"], height: 40),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                data["time"],
                                style: m1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get m => TextStyle(
        color: Colors.white,
        fontSize: 18,
      );
  TextStyle get m1 => TextStyle(
        color: Colors.grey,
        fontSize: 12,
      );
}
