import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

import 'group_button.dart';

class GroupList extends StatelessWidget {

  final LinksViewModel viewModel;
  final Function updateChoices;

  GroupList({this.viewModel, this.updateChoices});

  @override
  Widget build(BuildContext context) {
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
                                  onPressed: () {
                                    this.updateChoices(groups[index].id);
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
}