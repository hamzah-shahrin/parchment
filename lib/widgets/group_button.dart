import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color defaultColor;
  final Color selectedColor;
  final String groupName;

  GroupButton({
    this.onPressed,
    this.defaultColor,
    this.selectedColor,
    this.groupName,
  });

  @override
  State<StatefulWidget> createState() => _GroupButton();
}

class _GroupButton extends State<GroupButton> {
  bool _selected = false;

  void flipState() {
    setState(() => _selected = !_selected);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: widget.groupName,
        child: Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              radius: 9,
              backgroundColor:
                  _selected ? widget.selectedColor : widget.defaultColor,
              child: CircleAvatar(
                  radius: 7,
                  backgroundColor: widget.defaultColor,
                  child: IconButton(
                    icon:
                        Icon(Icons.adjust, color: widget.defaultColor, size: 1),
                    onPressed: () {
                      widget.onPressed();
                      flipState();
                    },
                  )),
            )));
  }
}

class GroupRadio extends StatefulWidget {
  final VoidCallback onPressed;
  final Color defaultColor;
  final Color selectedColor;
  final bool isSelected;

  GroupRadio({
    this.onPressed,
    this.defaultColor,
    this.selectedColor,
    this.isSelected,
  });

  @override
  State<StatefulWidget> createState() => _GroupRadio();
}

class _GroupRadio extends State<GroupRadio> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: CircleAvatar(
          radius: 9,
          backgroundColor:
              widget.isSelected ? widget.selectedColor : widget.defaultColor,
          child: CircleAvatar(
              radius: 7,
              backgroundColor: widget.defaultColor,
              child: IconButton(
                icon: Icon(Icons.adjust, color: widget.defaultColor, size: 1),
                onPressed: () {
                  widget.onPressed();
                },
              )),
        ));
  }
}
