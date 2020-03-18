import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.info, color: Colors.blueAccent,),
                title: Text("Tentang Aplikasi"),
                subtitle: Text("Aplikasi ini menggunakan data yang diunggah secara daring melalui https://covid19.mathdro.id/. Dikembangkan untuk memudahkan anda memperoleh informasi terbaru mengenai COVID19 secara global maupun di Indonesia"),
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: Colors.redAccent,),
                title: Text("Author"),
                subtitle: Text("Dikembangkan oleh @hoaaah"),
                onTap: () => launch('https://twitter.com/hoaaah'),
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: Colors.greenAccent,),
                title: Text("Thanks to"),
                subtitle: Text("Thanks to @mathdroid for their awesome work."),
                onTap: () => launch('https://github.com/mathdroid/covid-19-api'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
