import 'package:flutter/material.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/services/storage_api.dart';

class LinksViewModel extends ChangeNotifier {

  final StorageApi _storageService = serviceLocator<StorageApi>();

  List<Link> _links = [];
  List<Link> _searched = [];
  List<Link> _favourites = [];

  List<Link> get links => _links;
  List<Link> get searched => _searched;
  List<Link> get favourites => _favourites;

  void _addFavourite(Link link) {
    _favourites.add(link);
  }

  void _removeFavourite(Link link) {
    _favourites.remove(link);
  }

  loadData() async {
    _links = await _storageService.fetchLinks();
    searchList('');
    notifyListeners();
  }

  addLink(Link link) async {
    _links.add(link);
    if (link.isFavourite) _addFavourite(link);
    await _storageService.saveLinks(_links);
    notifyListeners();
  }

  toggleFavouriteStatus(int linkIndex) async {
    final isFavourite = !_links[linkIndex].isFavourite;
    _links[linkIndex].isFavourite = isFavourite;
    if (isFavourite) {
      _addFavourite(_links[linkIndex]);
    } else {
      _removeFavourite(_links[linkIndex]);
    }
    await _storageService.saveLinks(_links);
    notifyListeners();
  }

  void searchList(String term) {
    _searched = _links
        .where((element) =>
            (element.title.contains(term)) || (element.url.contains(term)))
        .toList();
    notifyListeners();
  }
}