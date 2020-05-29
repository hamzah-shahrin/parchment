import 'dart:convert';
import 'dart:io';

import 'package:parchment/models/link.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageApi {
  Future<List<Link>> fetchLinks();
  Future<void> saveLinks(List<Link> links);
}

class StorageApiImpl implements StorageApi {

  @override
  Future<List<Link>> fetchLinks() async {
    stderr.writeln('Fetching links...');
    final prefs = await SharedPreferences.getInstance();
    stderr.writeln(prefs.getKeys());
    final List<Link> links = [];
    prefs.getKeys().forEach((key) {
      var data = jsonDecode(prefs.get(key));
      links.add(Link.fromJson(data));
    });
    return links;
  }

  @override
  Future<void> saveLinks(List<Link> links) async {
    stderr.writeln('Saving links...');
    final prefs = await SharedPreferences.getInstance();
    links.asMap().forEach((index, value) =>
        prefs.setString(index.toString(), jsonEncode(value.toJson())));
    stderr.writeln(prefs.getKeys());
  }
}