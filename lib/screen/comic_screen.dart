import 'dart:async';

import 'package:basal/basal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';
import 'package:flutter_advanced_networkimage/zoomable_widget.dart';
import 'package:xkcd_reader/api/xkcd.dart';
import 'package:xkcd_reader/model/app_state.dart';
import 'package:xkcd_reader/model/comic_data.dart';
import 'package:xkcd_reader/model/comic_state.dart';
import 'package:xkcd_reader/widget/alt_text_container.dart';
import 'package:xkcd_reader/widget/comic_navigation_gesture_container.dart';

class ComicScreen extends StatefulWidget {
  @override
  _ComicScreenState createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        final Manager<AppState> appStateManager = managers[0];
        return FutureBuilder(
          future: getLatestOrNumberedComic(appState),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: const CircularProgressIndicator(),
                );
              case ConnectionState.none:
                break;
              default:
                if (snapshot.hasError) {
                  return _buildErrorDisplay(appState, appStateManager);
                }
                final ComicData comicData = snapshot.data;
                if (appState.latestComicNumber == null) {
                  appStateManager.model = appState.copyWith(
                      latestComicNumber: comicData.comicNumber,
                      currentComicNumber: comicData.comicNumber);
                }
                final imageUrl = snapshot.data.imgUrl;
                final title =
                    "#${snapshot.data.comicNumber} ${snapshot.data.safeTitle}";
                final altText = comicData.altText;
                final transcript = comicData.transcript;
                return Stack(
                  children: [
                    _buildComicDisplay(context, imageUrl, title, transcript),
                    ComicNavigationGestureContainer(),
                    AltTextContainer(altText: altText),
                  ],
                );
            }
          },
        );
      },
    );
  }

  Future<ComicData> getLatestOrNumberedComic(AppState appState) {
    if (appState.latestComicNumber == null ||
        appState.latestComicNumber == appState.currentComicNumber) {
      return xkcd.api.getCurrentComic();
    }
    return xkcd.api.getComicNumber(appState.currentComicNumber);
  }

  Widget _buildComicDisplay(
      BuildContext context, String imageUrl, String title, String transcript) {
    return Consumer(
      models: [ComicState],
      builder: (context, models, [managers]) {
        final ComicState comicState = models != null ? models[0] : ComicState();
        final Manager<ComicState> comicStateManager = managers[0];
        comicStateManager.model = comicState.copyWith(comicTitle: title);
        return Center(
          child: ZoomableWidget(
            minScale: 0.3,
            maxScale: 3.0,
            panLimit: 2.5,
            enableZoom: true,
            singleFingerPan: true,
            child: new TransitionToImage(
              AdvancedNetworkImage(
                imageUrl,
                useDiskCache: true,
                timeoutDuration: Duration(seconds: 10),
              ),
              loadingWidget: const CircularProgressIndicator(),
              placeholder: Container(
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorDisplay(
      AppState appState, Manager<AppState> appStateManager) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Network Problem"),
          Container(height: 20.0),
          Consumer(
            models: [ComicState],
            builder: (context, models, [managers]) {
              managers[0].model = models != null
                  ? (models[0] as ComicState).copyWith(comicTitle: "Error")
                  : ComicState();
              return RaisedButton(
                child: Text("Retry"),
                onPressed: () => appStateManager.model = appState.copyWith(),
              );
            },
          ),
        ],
      ),
    );
  }
}
