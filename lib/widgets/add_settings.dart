import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/services/service_locator.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:parchment/widgets/add_group_dialog.dart';
import 'package:parchment/widgets/add_link_dialog.dart';

class AddSettings extends StatelessWidget {

  final Function displayFunction;

  AddSettings({this.displayFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('Add a new item', style: TextStyle(
                  fontSize: 20,
              )),
            ),
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Add link'),
            onTap: () => displayFunction(
              AddLinkDialog(viewModel: serviceLocator<LinksViewModel>())
            ),
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('Add group'),
            onTap: () => displayFunction(
              AddGroupDialog()
            ),
          ),
        ],
      ),
    );
  }
}
