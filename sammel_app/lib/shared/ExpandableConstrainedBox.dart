import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableConstrainedBox extends StatefulWidget {
  Widget child = Placeholder();
  double maxHeight = 40.0;
  bool expandableCondition = true;

  ExpandableConstrainedBox(
      {this.child, this.maxHeight, this.expandableCondition***REMOVED***);

  @override
  State<StatefulWidget> createState() {
    return _ExpandableConstraintBox();
  ***REMOVED***
***REMOVED***

class _ExpandableConstraintBox extends State<ExpandableConstrainedBox> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.expandableCondition
        ? FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight:
                    expanded ? double.infinity : widget.maxHeight,
                    maxWidth: 220.0,
                    minWidth: 220.0),
                child: widget.child),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ]),
      onPressed: () => setState(() => expanded = !expanded),
    )
        : ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: expanded ? double.infinity : widget.maxHeight,
            maxWidth: 250.0),
        child: widget.child);
  ***REMOVED***
***REMOVED***
