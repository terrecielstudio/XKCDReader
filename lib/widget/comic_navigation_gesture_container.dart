import 'package:basal/basal.dart';
import 'package:flutter/material.dart';
import 'package:xkcd_reader/api/xkcd.dart';
import 'package:xkcd_reader/model/app_state.dart';

class ComicNavigationGestureContainer extends StatefulWidget {
  @override
  ComicNavigationGestureContainerState createState() {
    return new ComicNavigationGestureContainerState();
  }
}

class ComicNavigationGestureContainerState
    extends State<ComicNavigationGestureContainer> {
  bool _shouldShowRightArrow = false;
  bool _shouldShowLeftArrow = false;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        final Manager<AppState> appStateManager = managers[0];
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.white70,
                splashColor: Colors.white24,
                excludeFromSemantics: true,
                enableFeedback: false,
                onHighlightChanged: (changed) {
                  setState(() {
                    _shouldShowLeftArrow = changed;
                  });
                },
                onTap: appState.currentComicNumber == null ||
                        appState.currentComicNumber ==
                            appState.latestComicNumber
                    ? null
                    : () => nextComic(appState, appStateManager),
                child: Container(
                  width: 72.0,
                  color: Colors.transparent,
                  child: Center(
                    child: _shouldShowLeftArrow
                        ? Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                            size: 40.0,
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.white70,
                splashColor: Colors.white24,
                excludeFromSemantics: true,
                enableFeedback: false,
                onHighlightChanged: (changed) {
                  setState(() {
                    _shouldShowRightArrow = changed;
                  });
                },
                onTap: appState.currentComicNumber == null ||
                        appState.currentComicNumber == 1
                    ? null
                    : () => appStateManager.model = appState.copyWith(
                        currentComicNumber: appState.currentComicNumber - 1),
                child: Container(
                  width: 72.0,
                  color: Colors.transparent,
                  child: Center(
                    child: _shouldShowRightArrow
                        ? Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                            size: 40.0,
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
