import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color defaultColor;
  final Color selectedColor;

  GroupButton({this.onPressed, this.defaultColor, this.selectedColor});

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
                  widget.onPressed();
                  this.setState(() {
                    _selected = !_selected;
                  });
                },
              )
          ),
        )
    );
  }
}