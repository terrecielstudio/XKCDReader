import 'package:xkcd_reader/basal.dart';
import 'package:flutter/material.dart';
import 'package:xkcd_reader/model/app_state.dart';
import 'package:xkcd_reader/model/comic_state.dart';
import 'package:xkcd_reader/screen/container_screen.dart';

void main() async {
  runApp(Provider(
    managers: [
      Manager<AppState>(AppState()),
      Manager<ComicState>(ComicState()),
    ],
    child: () => XKCDReader(),
  ));
}

class XKCDReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XKCD Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContainerScreen(),
    );
  }
}
