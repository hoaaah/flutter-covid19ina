import 'dart:async';
import 'dart:convert';

import 'package:Covid19Ina/pages/home.dart';
import 'pages/about-us.dart';
import 'package:flutter/material.dart';
import 'pages/global.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'COVID19 di Indonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.cloud_circle)),
                  Tab(icon: Icon(Icons.info)),
                ],
              ),
              title: Text('COVID19 di Indonesia')
            ),
            body: TabBarView(
              children: [
                new HomeScreen(),
                new GlobalScreen(),
                new AboutScreen(),
              ],
            )
          ),
      ),
    );
  }
}