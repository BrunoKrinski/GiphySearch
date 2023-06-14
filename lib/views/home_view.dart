import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int offset = 0;

  String search = "";

  Future<Map> getGiphys() async {
    http.Response response;
    String trending = "https://api.giphy.com/v1/gifs/trending?api_key=w1wFik4zu4mmoVEEZEYFrqI79XMmnAco&limit=25&offset=0&rating=g&bundle=messaging_non_clips";
    String searching = "https://api.giphy.com/v1/gifs/search?api_key=w1wFik4zu4mmoVEEZEYFrqI79XMmnAco&q=$search&limit=25&offset=$offset&rating=g&lang=en&bundle=messaging_non_clips";

    if(search == "") {
      response = await http.get(Uri.parse(trending));
    } else {
      response = await http.get(Uri.parse(searching));
    }
    return json.decode(response.body);
  }

  @override
  void initState(){
    super.initState();
    getGiphys().then((map) {
      //print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
    );
  }
}
