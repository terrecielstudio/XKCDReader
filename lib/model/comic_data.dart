class ComicData {
  int comicNumber;
  int month;
  int day;
  int year;
  String safeTitle;
  String imgUrl;
  String title;
  String altText;
  String transcript;
  String link;
  String news;

  ComicData.fromJson(Map<String, dynamic> json)
      : comicNumber = json["num"],
        title = json["title"],
        safeTitle = json["safe_title"],
        imgUrl = json["img"],
        altText = json["alt"],
        month = int.parse(json["month"]),
        day = int.parse(json["day"]),
        year = int.parse(json["year"]),
        link = json["link"],
        news = json["news"],
        transcript = json["transcript"];

  @override
  String toString() {
    return "Comic Data:  $title, $safeTitle, $imgUrl";
  }
}
