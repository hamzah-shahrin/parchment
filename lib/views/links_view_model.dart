import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/services/storage_api.dart';

class LinksViewModel extends ChangeNotifier {

  final StorageApi _storageService = serviceLocator<StorageApi>();
  FetchedDataFormat _fetchedData = FetchedDataFormat();

  List<Link> _links = [];
  List<Link> _searched = [];
  List<Group> _groups = [];

  List<Link> get links => _links;
  List<Link> get searched => _searched;
  List<Group> get groups =>_groups;

  loadData() async {
    _fetchedData = await _storageService.fetchLinks();
    _links = _fetchedData.links;
    _groups = _fetchedData.groups;
    searchList('');
    notifyListeners();
  }

  addToGroup(Link link, Group group) async {
    link.groups.add(group);
    await _storageService.saveLinks(links);
    notifyListeners();
  }

  removeFromGroup(Link link, Group group) async {
    link.groups.remove(group);
    await _storageService.saveLinks(links);
    notifyListeners();
  }

  addLink(Link link) async {
    _links.add(link);
    await _storageService.saveLinks(_links);
    notifyListeners();
  }

  removeLink(Link link) async {
    _links.remove(link);
    await _storageService.saveLinks(links);
    notifyListeners();
  }

  void searchList(String term) {
    loadData();
    _searched = _links
        .where((element) =>
            (element.title.contains(term)) || (element.url.contains(term)))
        .toList();
    notifyListeners();
  }
}

class FetchedDataFormat {
  List<Link> links;
  List<Group> groups;

  FetchedDataFormat({this.links, this.groups});
}