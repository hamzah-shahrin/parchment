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

  void initialise() {
    search();
  }

  Future<void> addLink(Link link) async {
    links.then((value) {
      value.add(link);
      serviceLocator<StorageApi>().saveLinks(value);
    });
  }

  Future<void> search({String term: '', List<int> groupIds}) async {
    var temp =
        serviceLocator<StorageApi>().fetchLinks().then((value) =>
        value
            .links);
    if (groupIds == null || groupIds.length == 0) {
      _searched = temp.then((value) =>
          value
              .where((link) =>
          (link.title.contains(term)) || (link.url.contains(term)))
              .toList());
    } else {
      _searched = temp.then((value) =>
          value
              .where((link) => (listEquals(link.groupIds, groupIds)))
              .toList());
      stderr.writeln('Searched: $_searched');
    }
  }
}

class FetchedDataFormat {
  List<Link> links;
  List<Group> groups;

  FetchedDataFormat({this.links, this.groups});
}