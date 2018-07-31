import 'dart:async';

import 'package:dio/dio.dart';
import 'package:xkcd_reader/model/comic_data.dart';

class XKCDApi {
  static final _baseUrl = "http://xkcd.com";
  static final _baseUrlExplain = "http://www.explainxkcd.com/wiki/index.php";
  static get _dio {
    var dio = new Dio(new Options(baseUrl: _baseUrl, connectTimeout: 10000));
    dio.interceptor.request.onSend = (Options options) {
      print("[Request] ${options.baseUrl}${options.path}");
      return options;
    };
    dio.interceptor.response.onSuccess = (Response response) {
      print(response.data);
    };
    dio.interceptor.response.onError = (DioError error) {
      print(error);
    };
    return dio;
  }

  Future<ComicData> getCurrentComic() async {
    Response result = await _dio.get("/info.0.json");
    return ComicData.fromJson(result.data);
  }

  Future<ComicData> getComicNumber(int comicNumber) async {
    Response result = await _dio.get("/$comicNumber/info.0.json");
    return ComicData.fromJson(result.data);
  }

  String provideUrlForComicNumber(int comicNumber) {
    return "$_baseUrl/$comicNumber";
  }

  String provideUrlForExplainXkcd(int comicNumber) {
    return "$_baseUrlExplain/$comicNumber";
  }
}
