import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageApi {
  Future<DataFormat> fetchLinks();

  Future<void> saveData(DataFormat data);
}

class StorageApiImpl implements StorageApi {
  @override
  Future<DataFormat> fetchLinks() async {
    stderr.writeln('Fetching data...');
    final prefs = await SharedPreferences.getInstance();
    List<Link> links = [];
    List<Group> groups = [];
    if (prefs.containsKey('links') && prefs.get('links').length > 0)
      jsonDecode(prefs.get('links')).forEach((key, value) {
        var tempLink = jsonDecode(value);
        var tempGroups = <Group>[];
        tempLink['groups'].forEach((group) => tempGroups.add(Group.fromJson(jsonDecode(group))));
        tempLink['groups'] = tempGroups;
        links.add(Link.fromJson(tempLink));
      });
    if (prefs.containsKey('groups'))
      jsonDecode(prefs.get('groups')).forEach((key, value) {
        groups.add(Group.fromJson(jsonDecode(value)));
        stderr.writeln('Groups: $groups');
      });
    return DataFormat(links: links, groups: groups);
  }

  @override
  Future<void> saveData(DataFormat data) async {
    stderr.writeln('Saving data...');
    final prefs = await SharedPreferences.getInstance();
    final linkData = jsonEncode(data.links.asMap().map((key, value) =>
        MapEntry(key.toString(), jsonEncode(value.toJson()))));
    final groupData = jsonEncode(data.groups.asMap().map((key, value) =>
        MapEntry(key.toString(), jsonEncode(value.toJson()))));
    prefs.clear();
    prefs.setString('links', linkData);
    prefs.setString('groups', groupData);
  }
}
