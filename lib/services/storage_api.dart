import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageApi {
  Future<FetchedDataFormat> fetchLinks();

  Future<void> saveLinks(List<Link> links);
}

class StorageApiImpl implements StorageApi {
  @override
  Future<FetchedDataFormat> fetchLinks() async {
    stderr.writeln('Fetching links...');
    final prefs = await SharedPreferences.getInstance();
    final List<Link> links = [];
    final List<Group> groups = [];
    prefs.getKeys().forEach((key) {
      var data = jsonDecode(prefs.get(key));
      data['groups'] =
          data['groups'].map((group) => Group.fromJson(jsonDecode(group)));
      stderr.writeln(data);
      data['groups'].forEach((group) {
        if (!groups.contains(group)) groups.add(group);
      });
      links.add(Link.fromJson(data));
      stderr.writeln('Link Added: $data');
    });
    return FetchedDataFormat(links: links, groups: groups);
  }

  @override
  Future<void> saveLinks(List<Link> links) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    links.asMap().forEach((index, value) {
      prefs.setString(index.toString(), jsonEncode(value.toJson()));
      stderr.writeln(jsonEncode(value.toJson()));
    });
    stderr.writeln(prefs.getKeys());
  }
}
