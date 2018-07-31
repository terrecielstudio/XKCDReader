import 'dart:async';

import 'package:basal/basal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xkcd_reader/api/xkcd.dart';
import 'package:xkcd_reader/model/app_state.dart';
import 'package:xkcd_reader/model/comic_data.dart';
import 'package:xkcd_reader/model/comic_state.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ComicScreen extends StatefulWidget {
  @override
  _ComicScreenState createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  bool _shouldShowAltText = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        final Manager<AppState> appStateManager = managers[0];
        _shouldShowAltText = false;
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
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Network Problem"),
                        Container(height: 20.0),
                        RaisedButton(
                          child: Text("Retry"),
                          onPressed: () =>
                              appStateManager.model = appState.copyWith(),
                        ),
                      ],
                    ),
                  );
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
                return OrientationBuilder(
                  builder: (context, orientation) {
                    var widgets = [
                      _buildComicDisplay(context, imageUrl, title)
                    ];
                    if (_shouldShowAltText) {
                      widgets.add(
                        _buildAltTextDisplay(context, altText, orientation),
                      );
                    } else {
                      widgets.add(_buildToggleAltDisplay(context, orientation));
                    }
                    return Stack(
                      children: widgets,
                    );
                  },
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
      BuildContext context, String imageUrl, String title) {
    return Consumer(
      models: [ComicState],
      builder: (context, models, [managers]) {
        final ComicState comicState = models != null ? models[0] : ComicState();
        final Manager<ComicState> comicStateManager = managers[0];
        comicStateManager.model = comicState.copyWith(comicTitle: title);
        return Center(
          child: ZoomableImage(
            CachedNetworkImageProvider(imageUrl),
            backgroundColor: Colors.white,
            placeholder: Center(
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleAltDisplay(BuildContext context, Orientation orientation) {
    return Positioned(
      right: orientation == Orientation.landscape ? 0.0 : 0.0,
      bottom: orientation == Orientation.portrait ? 0.0 : null,
      child: IconButton(
        tooltip: "Show Alt Text",
        icon: Icon(Icons.info),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          _shouldShowAltText = true;
        },
      ),
    );
  }

  Widget _buildAltTextDisplay(
      BuildContext context, String altText, Orientation orientation) {
    return Positioned(
      right: orientation == Orientation.landscape ? 0.0 : null,
      bottom: orientation == Orientation.portrait ? 0.0 : null,
      child: GestureDetector(
        onTap: () {
          _shouldShowAltText = false;
        },
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.black54,
          width: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height / 2,
          height: orientation == Orientation.landscape
              ? MediaQuery.of(context).size.width
              : null,
          child: Text(
            altText,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.body1,
          ),
        ),
      ),
    );
  }
}
