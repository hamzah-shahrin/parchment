import 'package:flutter/material.dart';
import 'package:parchment/models/link.dart';

class LinksViewModel extends ChangeNotifier {

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

  void loadData() async {
    addLink(Link(
        id: 0,
        title: 'BBC News',
        url: 'https://www.bbc.co.uk/news',
        isFavourite: true
    ));
    addLink(Link(
          id: 0,
          title: 'BBC Sports',
          url: 'https://www.bbc.co.uk/sport',
          isFavourite: false
    ));
    searchList('');
    notifyListeners();
  }

  void addLink(Link link) {
    _links.add(link);
    if (link.isFavourite) _addFavourite(link);
    notifyListeners();
  }

  void toggleFavouriteStatus(int linkIndex) {
    final isFavourite = !_links[linkIndex].isFavourite;
    _links[linkIndex].isFavourite = isFavourite;
    if (isFavourite) {
      _addFavourite(_links[linkIndex]);
    } else {
      _removeFavourite(_links[linkIndex]);
    }
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