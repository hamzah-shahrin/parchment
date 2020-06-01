import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/services/storage_api.dart';

class LinksViewModel extends ChangeNotifier {
  Future<List<Link>> _searched;

  Future<List<Link>> get searched => _searched;

  Future<List<Link>> get links async =>
      serviceLocator<StorageApi>().fetchLinks().then((value) => value.links);

  Future<List<Group>> get groups async =>
      serviceLocator<StorageApi>().fetchLinks().then((value) => value.groups);

  Future<int> get topGroupId async =>
      groups.then((value) {
        var ids = value.map((e) => e.id).toList();
        ids.sort();
        return ids.last;});

  Group getGroup(List<Group> inGroups, int id) {
    return inGroups.firstWhere((element) => element.id == id);
  }

  Future<void> addLink(Link link) async {
    var _links = await links;
    _links.add(link);
    serviceLocator<StorageApi>().saveData(DataFormat(
      links: _links,
      groups: await groups
    ));
  }

  Future<void> addGroup(Group group) async {
    var _groups = await groups;
    _groups.add(group);
    serviceLocator<StorageApi>().saveData(DataFormat(
        links: await links,
        groups: _groups
    ));
  }

  Future<void> search({String term: '', List<int> groupIds}) async {
    stderr.writeln('Searching... + ${await topGroupId}');
    var temp =
        serviceLocator<StorageApi>().fetchLinks().then((value) => value.links);
    if (groupIds == null || groupIds.length == 0) {
      _searched = temp.then((value) => value
          .where((link) =>
              (link.title.contains(term)) || (link.url.contains(term)))
          .toList());
    } else {
      _searched = temp.then((value) => value
          .where((link) =>
              (link.groupIds.toSet().intersection(groupIds.toSet())).length ==
              groupIds.length).toList());
      _searched.then((value) => stderr.writeln(value.length));
    }
  }
}

class DataFormat {
  List<Link> links;
  List<Group> groups;

  DataFormat({this.links, this.groups});
}
