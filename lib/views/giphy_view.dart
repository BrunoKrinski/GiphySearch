import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GiphyView extends StatelessWidget {
  const GiphyView({super.key, required this.giphyData});

  final Map giphyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(giphyData['title']),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Share.share(giphyData['images']['fixed_height']['url']);
            },
            icon: Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          giphyData['images']['fixed_height']['url'],
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
