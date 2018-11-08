import 'package:xkcd_reader/basal.dart';
import 'package:xkcd_reader/model/comic_data.dart';

class AppState extends Model {
  final int latestComicNumber;
  final int currentComicNumber;
  final List<ComicData> favorites;

  AppState({
    this.latestComicNumber,
    this.currentComicNumber,
    this.favorites,
  });

  AppState copyWith({
    int latestComicNumber,
    int currentComicNumber,
    String currentComicTitle,
    List<ComicData> favorites,
  }) {
    return AppState(
      latestComicNumber: latestComicNumber ?? this.latestComicNumber,
      currentComicNumber: currentComicNumber ?? this.currentComicNumber,
      favorites: favorites ?? this.favorites,
    );
  }
}
