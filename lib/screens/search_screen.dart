import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final urlController = TextEditingController();

  final searchModel = serviceLocator<LinksViewModel>();

  var selectedGroups = <int>[];
  var dialogChoices = <int>[];

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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        onOpen: () => stderr.writeln('Opening dial'),
        onClose: () => stderr.writeln('Closing dial'),
        elevation: 8.0,
        shape: CircleBorder(),
        children: <SpeedDialChild>[
          SpeedDialChild(
              child: Icon(Icons.edit),
              backgroundColor: Colors.redAccent,
              label: 'Edit links',
              onTap: () => stderr.writeln('Edit pressed')),
          SpeedDialChild(
              child: Icon(Icons.folder),
              backgroundColor: Colors.redAccent,
              label: 'Edit groups',
              onTap: () => stderr.writeln('Groups pressed')),
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.redAccent,
              label: 'Add link',
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) =>
                        _buildDialog(serviceLocator<LinksViewModel>()));
                setState(() {
                  searchModel.search();
                });
              }),
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
    dialogChoices = [];
    return ListenableProvider<LinksViewModel>(
        create: (_) => viewModel,
        child: Consumer<LinksViewModel>(
          builder: (context, model, child) => FutureBuilder<List<Group>>(
              future: model.groups,
              builder: (context, snapshot) {
                List<Group> groups = snapshot.data ?? [];
                return AlertDialog(
                    title: Text('Add Link'),
                    content: Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: titleController,
                                decoration: InputDecoration(labelText: 'Title'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter some text';
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: urlController,
                                decoration: InputDecoration(labelText: 'URL'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter some text';
                                  return null;
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: _buildGroupList(
                                      serviceLocator<LinksViewModel>())),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textTheme:
                                      Theme.of(context).buttonTheme.textTheme,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      serviceLocator<LinksViewModel>()
                                          .addLink(Link(
                                        title: titleController.text,
                                        url: urlController.text,
                                        groups: dialogChoices
                                            .map((id) => Group(
                                                  title: model
                                                      .getGroup(groups, id)
                                                      .title,
                                                  color: model
                                                      .getGroup(groups, id)
                                                      .color,
                                                  id: id,
                                                ))
                                            .toList(),
                                      ));
                                      titleController.clear();
                                      urlController.clear();
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Add Link"),
                                ),
                              )
                            ],
                          ),
                        )));
              }),
        ));
  }

  Widget _buildGroupList(LinksViewModel viewModel) {
    return ChangeNotifierProvider<LinksViewModel>(
      create: (context) => viewModel,
      child: Consumer<LinksViewModel>(
        builder: (context, model, child) => FutureBuilder<List<Group>>(
          future: model.groups,
          builder: (context, snapshot) {
            List<Group> groups = snapshot.data ?? [];
            if (groups.length > 0)
              return Column(children: [
                Text('Add to group'),
                Container(
                  height: 30.0,
                  width: double.maxFinite,
                  child: Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Center(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                return GroupButton(
                                  defaultColor: groups[index].color,
                                  selectedColor: Colors.black,
                                  tap: () {
                                    setState(() {
                                      !dialogChoices.contains(groups[index].id)
                                          ? dialogChoices.add(groups[index].id)
                                          : dialogChoices
                                              .remove(groups[index].id);
                                    });
                                  },
                                );
                              }))),
                )
              ]);
            return Text('Add to groups: No groups exist',
                style: TextStyle(fontSize: 15.0));
          },
        ),
      ),
    );
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
                  return GroupButton(
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
                                                .color)))),
                          ),
                        );
                      },
                    );
                  },
                )));
  }
}

// ignore: must_be_immutable
class GroupButton extends StatefulWidget {
  VoidCallback tap;
  Color defaultColor;
  Color selectedColor;

  GroupButton({this.tap, this.defaultColor, this.selectedColor});

  @override
  State<StatefulWidget> createState() => _GroupButton();
}

class _GroupButton extends State<GroupButton> {
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
        ));
  }
}
