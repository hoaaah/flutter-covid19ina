import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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


class _HomeScreenState extends State<HomeScreen> {
  Future<CovidData> futureCovidData;

  @override
  void initState() {
    super.initState();
    futureCovidData = fetchCovidData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                            title: Text("COVID 19 Indonesia"),
                            subtitle: Text("Berikut informasi COVID19 di Indonesia."),
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
