import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Link {

  String title;
  String url;
  List<dynamic> groups;
  List<dynamic> groupIds;

  Link(
    {this.title, this.url, this.groups});

  Link.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'],
        groups = json['groups'].toList() {
    groupIds = groups.map((e) => e.id).toList();
  }

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'url': url,
        'groups': groups.map((e) => jsonEncode(e.toJson())).toList()
      };
}