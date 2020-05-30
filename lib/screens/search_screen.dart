import 'dart:io';

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
  final titleController = TextEditingController();
  final urlController = TextEditingController();

  final searchModel = serviceLocator<LinksViewModel>();

  var selectedGroups = <int>[];

  @override
  void initState() {
    searchModel.initialise();
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
          setState(() {
            showDialog(
                context: context,
                builder: (context) =>
                    _buildDialog(serviceLocator<LinksViewModel>()));
          });
          setState(() {
            searchModel.search(term: '');
          });
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
                  searchModel.search(term: query);
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
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('Filter by group:'),
                    Spacer(),
                    Container(
                      height: 30.0,
                      child: _buildFilterList(serviceLocator<LinksViewModel>()),
                    )
                  ],
                ),
              )),
          Expanded(
            child: _buildResults(searchModel),
          )
        ],
      ),
    );
  }

  Widget _buildDialog(LinksViewModel viewModel) {
    return ListenableProvider<LinksViewModel>(
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
                              serviceLocator<LinksViewModel>().addLink(Link(
                                  title: titleController.text,
                                  url: urlController.text,
                                  groups: [
                                    Group(
                                        title: 'Test Group 3',
                                        color: Colors.amber,
                                        id: 7)
                                  ]));
                              titleController.clear();
                              urlController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Add Link"),
                        ),
                      )
                    ],
                  ),
                ))));
  }

  Widget _buildFilterList(LinksViewModel viewModel) {
    return ChangeNotifierProvider<LinksViewModel>(
      create: (context) => viewModel,
      child: Consumer<LinksViewModel>(
        builder: (context, model, child) => FutureBuilder<List<Group>>(
          future: model.groups,
          builder: (context, snapshot) {
            List<Group> groups = snapshot.data ?? [];
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  var filterButton = FilterButton(
                    defaultColor: groups[index].color,
                    selectedColor: Colors.black,
                    tap: () {
                      setState(() {
                        !selectedGroups.contains(groups[index].id)
                            ? selectedGroups.add(groups[index].id)
                            : selectedGroups.remove(groups[index].id);
                        searchModel.search(groupIds: selectedGroups);
                      });
                    },
                  );
                  return filterButton;
                });
          },
        ),
      ),
    );
  }

  Widget _buildResults(LinksViewModel viewModel) {
    return ChangeNotifierProvider<LinksViewModel>(
        create: (context) => viewModel,
        child: Consumer<LinksViewModel>(
            builder: (context, model, child) => FutureBuilder<List<Link>>(
                  future: model.searched,
                  builder: (context, snapshot) {
                    List<Link> links = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 6.5, right: 6.5),
                          child: Card(
                            child: ListTile(
                                title: Text('${links[index].title}'),
                                subtitle: Text('${links[index].url}'),
                                dense: true,
                                trailing: Wrap(
                                    spacing: 7,
                                    children: List<Widget>.generate(
                                        links[index].groups.length,
                                        (groupIndex) => CircleAvatar(
                                            radius: 9,
                                            backgroundColor: links[index]
                                                .groups[groupIndex]
                                                .color)
                                    )
                                )
                            ),
                          ),
                        );
                      },
                    );
                  },
            )
        )
    );
  }
}

// ignore: must_be_immutable
class FilterButton extends StatefulWidget {
  VoidCallback tap;
  Color defaultColor;
  Color selectedColor;

  FilterButton({this.tap, this.defaultColor, this.selectedColor});

  @override
  State<StatefulWidget> createState() => _FilterButton();
}

class _FilterButton extends State<FilterButton> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: CircleAvatar(
          radius: 9,
          backgroundColor:
              _selected ? widget.selectedColor : widget.defaultColor,
          child: CircleAvatar(
              radius: 7,
              backgroundColor: widget.defaultColor,
              child: IconButton(
                icon: Icon(Icons.adjust, color: widget.defaultColor, size: 1),
                onPressed: () {
                  widget.tap();
                  this.setState(() {
                    _selected = !_selected;
                  });
                },
              )),
        )
    );
  }
}
