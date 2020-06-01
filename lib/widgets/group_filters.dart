import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

import 'group_button.dart';

class GroupFilters extends StatefulWidget {

  final LinksViewModel viewModel;
  final Function search;

  GroupFilters({this.viewModel, this.search});

  @override
  State<StatefulWidget> createState() => _GroupFilters();
}

class _GroupFilters extends State<GroupFilters> {

  var selectedGroups = <int>[];

  void updateFilterChoices(int groupId) {
    setState(() {
      !selectedGroups.contains(groupId)
          ? selectedGroups.add(groupId)
          : selectedGroups.remove(groupId);
      widget.search(selectedGroups);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LinksViewModel>(
      create: (context) => widget.viewModel,
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
                    onPressed: () => updateFilterChoices(groups[index].id),
                  );
                });
          },
        ),
      ),
    );
  }
}