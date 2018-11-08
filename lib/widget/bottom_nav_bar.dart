import 'dart:async';

import 'package:xkcd_reader/basal.dart';
import 'package:flutter/material.dart';
import 'package:xkcd_reader/api/xkcd.dart';
import 'package:xkcd_reader/model/app_state.dart';
import 'package:xkcd_reader/screen/go_to_page_screen.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Consumer(
        models: [AppState],
        builder: (context, models, [managers]) {
          final AppState appState = models != null ? models[0] : AppState();
          final Manager<AppState> appStateManager = managers[0];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  tooltip: "Newest Comic",
                  color: Theme.of(context).buttonColor,
                  icon: Icon(
                    Icons.first_page,
                  ),
                  onPressed: appState.currentComicNumber == null ||
                          appState.currentComicNumber ==
                              appState.latestComicNumber
                      ? null
                      : () => appStateManager.model = appState.copyWith(
                          currentComicNumber: appState.latestComicNumber)),
              IconButton(
                  tooltip: "Newer Comic",
                  color: Theme.of(context).buttonColor,
                  icon: Icon(
                    Icons.chevron_left,
                  ),
                  onPressed: appState.currentComicNumber == null ||
                          appState.currentComicNumber ==
                              appState.latestComicNumber
                      ? null
                      : () => nextComic(appState, appStateManager)),
              IconButton(
                tooltip: "Go to...",
                color: Theme.of(context).buttonColor,
                icon: Icon(Icons.search),
                onPressed: () => goToPage(context, appState, appStateManager),
              ),
              IconButton(
                tooltip: "Older Comic",
                color: Theme.of(context).buttonColor,
                icon: Icon(
                  Icons.chevron_right,
                ),
                onPressed: appState.currentComicNumber == null ||
                        appState.currentComicNumber == 1
                    ? null
                    : () => appStateManager.model = appState.copyWith(
                        currentComicNumber: appState.currentComicNumber - 1),
              ),
              IconButton(
                tooltip: "Oldest Comic",
                color: Theme.of(context).buttonColor,
                icon: Icon(
                  Icons.last_page,
                ),
                onPressed: appState.currentComicNumber == null ||
                        appState.currentComicNumber == 1
                    ? null
                    : () => appStateManager.model =
                        appState.copyWith(currentComicNumber: 1),
              ),
            ],
          );
        },
      ),
      elevation: 2.0,
      color: Theme.of(context).primaryColor,
    );
  }

  Future goToPage(BuildContext context, AppState appState,
      Manager<AppState> appStateManager) async {
    final int pageToGo = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GoToPageScreen();
      },
    );
    if (pageToGo == null) {
      return;
    }
    appStateManager.model = appState.copyWith(currentComicNumber: pageToGo);
  }

  void nextComic(AppState appState, Manager<AppState> appStateManager) async {
    int latestComicNumber;
    try {
      latestComicNumber = (await xkcd.api.getCurrentComic()).comicNumber;
    } catch (e) {}
    var shouldUpdateLatestComic = latestComicNumber != null &&
        appState.latestComicNumber != latestComicNumber;
    appStateManager.model = appState.copyWith(
        latestComicNumber: shouldUpdateLatestComic ? latestComicNumber : null,
        currentComicNumber: appState.currentComicNumber + 1);
  }
}
