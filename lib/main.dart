import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

Future<Album> fetchAlbum() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<CovidData> fetchCovidData() async {
  final response =
      await http.get('https://covid19.mathdro.id/api/countries/indonesia');

  if(response.statusCode == 200){
    return CovidData.fromJson(json.decode(response.body));
  }else{
    throw Exception('Failed to connect to server');
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class CovidData {
  final int confirmed;
  final int recovered;
  final int deaths;
  final String lastUpdate;

  CovidData({this.confirmed, this.recovered, this.deaths, this.lastUpdate});

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return CovidData(
      confirmed: json['confirmed']['value'],
      recovered: json['recovered']['value'],
      deaths: json['deaths']['value'],
      lastUpdate: json['lastUpdate'].toString()
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;
  Future<CovidData> futureCovidData;


  final response = http.get('https://covid19.mathdro.id/api/countries/indonesia');

  // final data =  Album.fromJson(json.decode(response.body));

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    futureCovidData = fetchCovidData();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'COVID19 di Indonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('COVID19 di Indonesia'),
        ),
        body: Center(
          child: FutureBuilder<CovidData>(
            future: futureCovidData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                var data = [
                  ClicksPerYear('deaths ('+ snapshot.data.deaths.toString() + ')', snapshot.data.deaths, Colors.red),
                  ClicksPerYear('recovered ('+ snapshot.data.recovered.toString() + ')', snapshot.data.recovered, Colors.green),
                  ClicksPerYear('confirmed ('+ snapshot.data.confirmed.toString() + ')', snapshot.data.confirmed, Colors.yellow),
                ];

                var series = [
                  charts.Series(
                    domainFn: (ClicksPerYear clickData, _) => clickData.year,
                    measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                    colorFn: (ClicksPerYear clickData, _) => clickData.color,
                    id: 'Clicks',
                    data: data,
                  ),
                ];

                var chart = charts.BarChart(
                  series,
                  animate: true,
                );

                var chartWidget = Padding(
                  padding: EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 200.0,
                    child: chart,
                  ),
                );
                return Scaffold(
                  body: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.info, color: Colors.blueAccent,),
                            title: Text("Tentang Aplikasi"),
                            subtitle: Text("Aplikasi ini menggunakan data yang diunggah secara daring melalui https://covid19.mathdro.id/"),
                          ),
                          chartWidget,
                          ListTile(
                            leading: Icon(Icons.info, color: Colors.redAccent,),
                            title: Text("Data Updated at " +snapshot.data.lastUpdate),
                            subtitle: Text(""),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}