import 'package:xkcd_reader/basal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xkcd_reader/model/app_state.dart';

class GoToPageScreen extends StatefulWidget {
  @override
  _GoToPageScreenState createState() => _GoToPageScreenState();
}

class _GoToPageScreenState extends State<GoToPageScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Go to comic number..."),
      content: _buildContent(context),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: Text("Go"),
          onPressed: () =>
              Navigator.of(context).pop(int.parse(_inputController.text)),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer(
      models: [AppState],
      builder: (context, models, [managers]) {
        final AppState appState = models != null ? models[0] : AppState();
        return TextField(
          controller: _inputController,
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(hintText: "1 - ${appState.latestComicNumber}"),
          onChanged: (text) => limitToLatestComicNumber(appState, text),
          inputFormatters: [
            LengthLimitingTextInputFormatter(
                "${appState.latestComicNumber}".length),
            WhitelistingTextInputFormatter(RegExp(r"\d")),
          ],
        );
      },
    );
  }

  void limitToLatestComicNumber(AppState appState, String text) {
    final int enteredNumber = int.parse(text);
    if (enteredNumber > appState.latestComicNumber) {
      _inputController.text = "${appState.latestComicNumber}";
    } else if (enteredNumber < 1) {
      _inputController.text = 1.toString();
    }
  }
}
