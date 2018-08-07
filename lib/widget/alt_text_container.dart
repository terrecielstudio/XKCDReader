import 'package:flutter/material.dart';

class AltTextContainer extends StatefulWidget {
  final String altText;

  const AltTextContainer({Key key, this.altText}) : super(key: key);

  @override
  _AltTextContainerState createState() => _AltTextContainerState();
}

class _AltTextContainerState extends State<AltTextContainer> {
  bool _shouldShowAltText = false;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        var widgets = <Widget>[];
        if (_shouldShowAltText) {
          widgets.add(_buildAltTextContainer(orientation));
        } else {
          widgets.add(_buildAltTextToggle(orientation));
        }
        return Stack(
          fit: StackFit.expand,
          children: widgets,
        );
      },
    );
  }

  Widget _buildAltTextToggle(Orientation orientation) {
    return Positioned(
      right: 0.0,
      top: orientation == Orientation.portrait ? null : 0.0,
      bottom: orientation == Orientation.portrait ? 0.0 : null,
      child: IconButton(
        tooltip: "Show Alt Text",
        icon: Icon(Icons.info),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            _shouldShowAltText = true;
          });
        },
      ),
    );
  }

  Widget _buildAltTextContainer(Orientation orientation) {
    return Positioned(
      right: orientation == Orientation.portrait ? null : 0.0,
      bottom: orientation == Orientation.portrait ? 0.0 : null,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _shouldShowAltText = false;
          });
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
            widget.altText,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.body1,
          ),
        ),
      ),
    );
  }
}
