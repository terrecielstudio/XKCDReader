import 'dart:math';

import 'package:basal/basal.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xkcd_reader/api/xkcd.dart';
import 'package:xkcd_reader/model/app_state.dart';
import 'package:xkcd_reader/model/comic_state.dart';
import 'package:xkcd_reader/screen/comic_screen.dart';
import 'package:xkcd_reader/widget/bottom_nav_bar.dart';

class ContainerScreen extends StatelessWidget {
  static Random _random = new Random();

  final List<OverflowMenuData> _overflowData = [
    OverflowMenuData(Icon(Icons.open_in_browser), "Open in browser"),
    OverflowMenuData(Icon(Icons.help_outline), "Explain XKCD"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          models: [ComicState],
          builder: (context, models, [managers]) {
            final ComicState comicState =
                models != null ? models[0] : ComicState();
            return Material(
              color: Theme.of(context).primaryColor,
              child: Text(
                comicState.comicTitle ?? "XKCD Reader",
                style: Theme.of(context).primaryTextTheme.title,
              ),
            );
          },
        ),
        actions: <Widget>[
          _buildRandomComicButton(context),
          _buildOverflowMenu(context),
        ],
      ),
      body: ComicScreen(),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildRandomComicButton(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        final Manager<AppState> appStateManager = managers[0];
        return IconButton(
          icon: Icon(Icons.casino),
          onPressed: () {
            var randNumber = _random.nextInt(appState.latestComicNumber + 1);
            appStateManager.model = appState.copyWith(
                currentComicNumber: randNumber == 0 ? 1 : randNumber);
          },
        );
      },
    );
  }

  Widget _buildOpenInBrowserButton() {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        return FlatButton.icon(
          icon: Icon(Icons.open_in_browser),
          label: Text("Open in browser"),
          onPressed: () async {
            final url =
                xkcd.api.provideUrlForComicNumber(appState.currentComicNumber);
            if (await canLaunch(url)) {
              await launch(url);
            } else {}
          },
        );
      },
    );
  }

  Widget _buildOverflowMenu(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        return PopupMenuButton<OverflowMenuData>(
          onSelected: (data) => _overflowMenuSelected(data, appState),
          itemBuilder: (context) {
            return _overflowData.map((data) {
              return PopupMenuItem<OverflowMenuData>(
                value: data,
                child: ListTile(
                  leading: data.icon,
                  title: Text(data.label),
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  void _overflowMenuSelected(OverflowMenuData data, AppState appState) async {
    if (data.icon.icon == Icons.open_in_browser) {
      final url =
          xkcd.api.provideUrlForComicNumber(appState.currentComicNumber);
      if (await canLaunch(url)) {
        await launch(url);
      } else {}
    } else if (data.icon.icon == Icons.help_outline) {
      final url =
          xkcd.api.provideUrlForExplainXkcd(appState.currentComicNumber);
      if (await canLaunch(url)) {
        await launch(url);
      } else {}
    }
  }
}

class OverflowMenuData {
  final Icon icon;
  final String label;
  OverflowMenuData(this.icon, this.label);
}
