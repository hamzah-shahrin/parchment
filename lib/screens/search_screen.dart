import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/all_links_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {

  LinksViewModel model = serviceLocator<LinksViewModel>();

  @override
  void initState() {
    model.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Parchment'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () {

              },
            )
          ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search for a link'
              ),
              onChanged: (query) {
                setState(() {
                  model.searchList(query);
                });
              },
            ),
          ),
          Expanded(
            child: _buildResults(model),
          )
        ],
      ),
    );
  }

  Widget _buildResults(LinksViewModel viewModel) {
    return ChangeNotifierProvider<LinksViewModel>(
      create: (context) => viewModel,
      child: Consumer<LinksViewModel>(
        builder: (context, model, child) => ListView.builder(
          itemCount: model.searched.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 6.5, right: 6.5),
              child: Card(
                child: ListTile(
                  title: Text('${model.searched[index].title}'),
                  subtitle: Text('${model.searched[index].url}'),
                  trailing: (model.searched[index].isFavourite)
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                  onTap: () {model.toggleFavouriteStatus(index);},
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}