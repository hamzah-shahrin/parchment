import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/link.dart';
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
          centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final urlController = TextEditingController();
              return AlertDialog(
                title: Text('Add Link'),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title'
                        ),
                      ),
                      TextFormField(
                        controller: urlController,
                        decoration: InputDecoration(
                            labelText: 'URL'
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: RaisedButton(
                          onPressed: () {
                            model.addLink(Link(
                              title: titleController.text,
                              url: urlController.text,
                              isFavourite: false
                            ));
                            setState(() => model.searchList(''));
                            Navigator.pop(context);
                          },
                          child: Text("Add Link"),
                        ),
                      )
                    ],
                  ),
                )
              );
            }
          );
        },
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
                  onTap: () => model.toggleFavouriteStatus(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}