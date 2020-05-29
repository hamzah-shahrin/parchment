class Link {
  String title;
  String url;
  bool isFavourite;

  Link(
    {this.title, this.url, isFavourite : false}) : this.isFavourite = isFavourite ?? false;

  Link.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'],
        isFavourite = json['isFavourite'];

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'url': url,
        'isFavourite': isFavourite
      };
}