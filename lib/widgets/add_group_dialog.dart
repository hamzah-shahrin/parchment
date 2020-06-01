import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';

class AddGroupDialog extends StatelessWidget {

  final LinksViewModel viewModel;

  AddGroupDialog({this.viewModel});

  static final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          Text('Add a new group'),
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).cardColor,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
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
                    ],
                  ),
                )
            )
        )
    );
  }
}