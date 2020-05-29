import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();

  LinksViewModel model = serviceLocator<LinksViewModel>();
  LinksViewModel dialogModel = serviceLocator<LinksViewModel>();

  @override
  void initState() {
    model.loadData();
    dialogModel.loadData();
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
              context: context, builder: (context) => _buildDialog(dialogModel));
          setState(() { model.searchList(''); });
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
                  hintText: 'Search for a link'),
              onChanged: (query) {
                setState(() {
                  model.searchList(query);
                });
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 6.5, right: 6.5, bottom: 6.5),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 3.0, left: 8.0, right: 3.0, bottom: 3.0),
                child: Row(
                  children: <Widget>[
                    Text('Filter by group:'),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            icon: Icon(Icons.adjust,
                                color: Colors.blueAccent, size: 1),
                            onPressed: () {},
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            icon: Icon(Icons.adjust,
                                color: Colors.redAccent, size: 1),
                            onPressed: () {},
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.greenAccent,
                          child: IconButton(
                            icon: Icon(Icons.adjust,
                                color: Colors.greenAccent, size: 1),
                            onPressed: () {},
                          )),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: _buildResults(model),
          )
        ],
      ),
    );
  }

  Widget _buildDialog(LinksViewModel viewModel) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    return new ChangeNotifierProvider<LinksViewModel>(
        create: (context) => viewModel,
        child: Consumer<LinksViewModel>(
            builder: (context, model, child) => AlertDialog(
                title: Text('Add Link'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter some text';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: urlController,
                        decoration: InputDecoration(labelText: 'URL'),
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter some text';
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textTheme: Theme.of(context).buttonTheme.textTheme,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              model.addLink(Link(
                                  title: titleController.text,
                                  url: urlController.text,
                                  groups: [
                                    Group(title: 'BBC', color: Colors.amber),
                                    Group(
                                        title: 'Test',
                                        color: Colors.greenAccent)
                                  ]));
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Add Link"),
                        ),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }

  Widget _buildResults(LinksViewModel viewModel) {
    return new ChangeNotifierProvider<LinksViewModel>(
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
                    trailing: Wrap(
                        spacing: 7,
                        children: List<Widget>.generate(
                            model.searched[index].groups.length,
                            (groupIndex) => CircleAvatar(
                                radius: 9,
                                backgroundColor: model.searched[index]
                                    .groups[groupIndex].color)))),
              ),
            );
          },
        ),
      ),
    );
  }
}
