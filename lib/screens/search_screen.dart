import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:parchment/widgets/add_link_dialog.dart';
import 'package:parchment/widgets/add_settings.dart';
import 'package:parchment/widgets/group_filters.dart';
import 'package:parchment/widgets/link_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {

  final searchModel = serviceLocator<LinksViewModel>();

  void updateGroupSearch(List<int> selectedGroups) {
    setState(() {
      searchModel.search(groupIds: selectedGroups);
    });
  }

  void showModal(Widget modalContents) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (context) {
          return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: modalContents,
              )
          );
        }
    );
    searchModel.search();
  }

  @override
  void initState() {
    searchModel.search();
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
              label: 'Add item',
              onTap: () => showModal(AddSettings(displayFunction: showModal))
          ),
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
                      child: GroupFilters(viewModel: serviceLocator<LinksViewModel>(),
                      search: updateGroupSearch),
                    )
                  ],
                ),
              )),
          Expanded(
            child: LinkList(viewModel: searchModel, visitLink: (){}),
          )
        ],
      ),
    );
  }
}
