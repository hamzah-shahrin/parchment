import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/group.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:parchment/widgets/group_button.dart';

class AddGroupDialog extends StatefulWidget {

  final LinksViewModel viewModel;

  AddGroupDialog({this.viewModel});

  @override
  State<StatefulWidget> createState() => _AddGroupDialog();

}

class _AddGroupDialog extends State<AddGroupDialog>{

  static final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  int _selectedColor = 0;

  void selectItem(int index) {
    setState(() {
      _selectedColor = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: Future.wait([widget.viewModel.topGroupId, widget.viewModel.numberOfGroups]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var groupId = snapshot.data[0] ?? -1;
          groupId = groupId + 1;
          var numberOfGroups = snapshot.data[1];
          if (numberOfGroups <= 10)
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
                                  Text('Add a new group: $numberOfGroups'),
                                  FlatButton(
                                    color: Theme.of(context).primaryColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    textColor: Theme.of(context).cardColor,
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        widget.viewModel.addGroup(
                                            Group(
                                                id: groupId,
                                                title: titleController.text,
                                                color: Colors.accents[_selectedColor]
                                            )
                                        );
                                        titleController.clear();
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
                                controller: titleController,
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
                              Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child:  Text('Select group color'),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Container(
                                      height: 30,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: Colors.accents.length,
                                          itemBuilder: (context, index) {
                                            var newButton = GroupRadio(
                                              defaultColor: Colors.accents[index],
                                              selectedColor: Colors.black,
                                              isSelected: _selectedColor == index ? true : false,
                                              onPressed: () {
                                                selectItem(index);
                                              },
                                            );
                                            return newButton;
                                          })
                                  )
                              )
                            ],
                          ),
                        )
                    )
                )
            );
          else
            return Container(
                height: 200,
                child: Center(child: Text('You have reached the maximum number of groups!')));
        } else if (snapshot.hasError) {
          return Container(
              height: 200,
              child: Center(child: Text('Error retrieving existing groups')));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}