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

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final urlController = TextEditingController();

  AddLinkDialog({this.viewModel});

  @override
  State<StatefulWidget> createState() => _AddLinkDialog();
}

class _AddLinkDialog extends State<AddLinkDialog> {

  List<int> _selected = [];

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
                return AlertDialog(
                    title: Text('Add Link'),
                    content: Form(
                        key: widget.formKey,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: widget.titleController,
                                decoration: InputDecoration(labelText: 'Title'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter some text';
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: widget.urlController,
                                decoration: InputDecoration(labelText: 'URL'),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter some text';
                                  return null;
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: GroupList(
                                      viewModel: serviceLocator<LinksViewModel>(),
                                      updateChoices: updateChoices
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textTheme:
                                  Theme.of(context).buttonTheme.textTheme,
                                  onPressed: () {
                                    if (widget.formKey.currentState.validate()) {
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
                                  child: Text("Add Link"),
                                ),
                              )
                            ],
                          ),
                        )));
              }),
        ));
  }

}