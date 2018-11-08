import 'package:xkcd_reader/basal.dart';

class ComicState extends Model {
  final String comicTitle;

  ComicState({this.comicTitle});

  ComicState copyWith({comicTitle}) {
    return ComicState(
      comicTitle: comicTitle ?? this.comicTitle,
    );
  }
}
