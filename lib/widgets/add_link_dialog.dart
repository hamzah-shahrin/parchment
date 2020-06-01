import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

import 'group_list.dart';

class AddLinkDialog extends StatefulWidget {
  final LinksViewModel viewModel;

  final titleController = TextEditingController();
  final urlController = TextEditingController();

  AddLinkDialog({this.viewModel});

  @override
  State<StatefulWidget> createState() => _AddLinkDialog();
}

class _AddLinkDialog extends State<AddLinkDialog> {

  List<int> _selected = [];
  static final formKey = GlobalKey<FormState>();

  void updateChoices(int groupId) {
    setState(() {
      !_selected.contains(groupId)
          ? _selected.add(groupId)
          : _selected.remove(groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<LinksViewModel>(
        create: (_) => widget.viewModel,
        child: Consumer<LinksViewModel>(
          builder: (context, model, child) => FutureBuilder<List<Group>>(
              future: model.groups,
              builder: (context, snapshot) {
                List<Group> groups = snapshot.data ?? [];
                return Container(
                    child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Form(
                            key: formKey,
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Add a new link'),
                                      FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        textColor: Theme.of(context).cardColor,
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            serviceLocator<LinksViewModel>()
                                                .addLink(Link(
                                              title: widget.titleController.text,
                                              url: widget.urlController.text,
                                              groups: _selected
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
                                            widget.titleController.clear();
                                            widget.urlController.clear();
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Save",
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  TextFormField(
                                    controller: widget.titleController,
                                    decoration:
                                        InputDecoration(labelText: 'Title', labelStyle: TextStyle(
                                          fontSize: 14
                                        )),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Please enter some text';
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: widget.urlController,
                                    decoration:
                                        InputDecoration(labelText: 'URL', labelStyle: TextStyle(
                                            fontSize: 14
                                        )),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Please enter some text';
                                      return null;
                                    },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: GroupList(
                                          viewModel:
                                              serviceLocator<LinksViewModel>(),
                                          updateChoices: updateChoices)),
                                ],
                              ),
                            ))));
              }),
        ));
  }
}
