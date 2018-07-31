import 'package:xkcd_reader/api/xkcd_api.dart';

XKCD xkcd = XKCD();

class XKCD {
  final api = XKCDApi();
  static final _xkcd = XKCD._internal();

  factory XKCD() {
    return _xkcd;
  }

  XKCD._internal();
}
