import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import 'giphy_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int offset = 0;

  String search = "";
  Future<Map>? data;

  Future<Map> getGiphys() async {
    http.Response response;
    String trending =
        "https://api.giphy.com/v1/gifs/trending?api_key=w1wFik4zu4mmoVEEZEYFrqI79XMmnAco&limit=49&offset=$offset&rating=g&bundle=messaging_non_clips";
    String searching =
        "https://api.giphy.com/v1/gifs/search?api_key=w1wFik4zu4mmoVEEZEYFrqI79XMmnAco&q=$search&limit=49&offset=$offset&rating=g&lang=en&bundle=messaging_non_clips";

    if (search == "") {
      response = await http.get(Uri.parse(trending));
    } else {
      response = await http.get(Uri.parse(searching));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    //data = getGiphys();
  }

  Widget giphyTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: snapshot.data['data'].length + 1,
      itemBuilder: (context, index) {
        if (index < snapshot.data['data'].length) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return GiphyView(giphyData: snapshot.data['data'][index]);
                }),
              );
            },
            onLongPress: () async {
              await Share.share(snapshot.data['data'][index]['images']
                  ['fixed_height']['url']);
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']
                  ['url'],
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            setState(() {
              offset += 49;
            });
          },
          child: Container(
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),
                Text(
                  'Load more...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                onSubmitted: (text) {
                  setState(() {
                    offset = 0;
                    search = text;
                  });
                },
                decoration: InputDecoration(
                    filled: true,
                    labelText: "Search Giphy",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    ))),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                cursorColor: Colors.white,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getGiphys(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) return Container();
                      return giphyTable(context, snapshot);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
