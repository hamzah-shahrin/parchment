import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parchment/models/link.dart';
import 'package:parchment/views/links_view_model.dart';
import 'package:provider/provider.dart';

class LinkList extends StatefulWidget {
  final LinksViewModel viewModel;
  final Function visitLink;

  LinkList({this.viewModel, this.visitLink});

  @override
  State<StatefulWidget> createState() => _LinkList();
}

class _LinkList extends State<LinkList>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LinksViewModel>.value(
        value: widget.viewModel,
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
                                onTap: widget.visitLink(),
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
                )
        )
    );
  }
}
