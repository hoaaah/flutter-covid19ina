import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';
import 'package:dropdownfield/dropdownfield.dart';

class GlobalScreen extends StatefulWidget {
  @override
  _GlobalScreenState createState() => _GlobalScreenState();
}

Future<CovidData> fetchCovidData(country) async {
  String baseUrl = 'https://covid19.mathdro.id/api';
  String url = baseUrl;
  if(country != 'All'){
    url = baseUrl + '/countries/' + country;
  }
  final response =
  await http.get(url);

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

//class Countries{
//  String name;
//  String iso;
//
//  Countries(this.name, this.iso);
//
////  @override
////  String toString() {
////    return '{ ${this.name}, ${this.iso} }';
////  }
//  Map<String, dynamic> toJson() => {
//    "name": name,
//    "iso": iso,
//  };
//}

class _GlobalScreenState extends State<GlobalScreen> {
  Future<CovidData> futureCovidData;

  String _baseCountriesUrl = 'https://covid19.mathdro.id/api/countries';
  String _valCountries = 'All';
//  List<dynamic> _dataCountries = List();
  List<dynamic> _dataCountries = [
    "All",
    "Indonesia",
    "Malaysia",
    "Thailand",
    "Singapore",
    "Vietnam",
    "Hongkong",
    "China",
    "Iran",
    "Italy",
  ];

//  void getCountries() async {
//    final response = await http.get(_baseCountriesUrl);
//    Map<String, dynamic> mapData = jsonDecode(response.body);
//    var listData = [];
//    mapData['countries'].forEach((k, v) => listData.add(Countries(k, v)));
//
//    setState(() {
//      _dataCountries = listData;
//    });
////    debugPrint(listData);
//  }

  @override
  void initState() {
    super.initState();
    futureCovidData = fetchCovidData(_valCountries);
//    getCountries();
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
                  ClicksPerYear('deaths', snapshot.data.deaths, Colors.red),
                  ClicksPerYear('recovered', snapshot.data.recovered, Colors.green),
                  ClicksPerYear('confirmed', snapshot.data.confirmed, Colors.yellow),
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
                          DropdownButton(
                            hint: Text("Select Countries"),
                            value: _valCountries,
                            items: _dataCountries.map((item){
                              return DropdownMenuItem(
                                child: Text(item),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _valCountries = value;
                                futureCovidData = fetchCovidData(_valCountries);
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.info, color: Colors.blueAccent,),
                            title: Text("Global Info: $_valCountries"),
                            subtitle:
                            Text("Here update on global Pandemic of COVID19. Data updated at " +snapshot.data.lastUpdate),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 100.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: new Center(
                                    child: new Text(snapshot.data.deaths.toString(), style: TextStyle(fontSize: 22, color: Colors.white), textAlign: TextAlign.center,),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30.0,
                                width: 100.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: new Center(
                                    child: new Text(snapshot.data.recovered.toString(), style: TextStyle(fontSize: 22, color: Colors.white), textAlign: TextAlign.center,),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30.0,
                                width: 100.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellowAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: new Center(
                                    child: new Text(snapshot.data.confirmed.toString(), style: TextStyle(fontSize: 22, color: Colors.black), textAlign: TextAlign.center,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          chartWidget,
                          ListTile(
                            leading: Icon(Icons.info, color: Colors.redAccent,),
                            title: Text("Graph of Pandemic"),
                            subtitle: Text(""),
                          ),
                          Image.network('https://covid19.mathdro.id/api/og'),
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
