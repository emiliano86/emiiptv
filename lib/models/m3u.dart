class TvChannel{
  String title, link;


  TvChannel({
    required this.title,
    required this.link,


  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,


    };
  }
}