import 'package:flutter/material.dart';
import 'package:giphy_search/views/home_view.dart';

void main() {
  runApp(GiphySearch());
}

class GiphySearch extends StatelessWidget {
  const GiphySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Search',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
