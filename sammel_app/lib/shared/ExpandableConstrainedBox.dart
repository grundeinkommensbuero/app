import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableConstrainedBox extends StatefulWidget {
  Widget child;
  double maxHeight = 40.0;
  bool expandableCondition = true;

  ExpandableConstrainedBox({this.child, maxHeight, expandableCondition***REMOVED***) {
    assert(child != null, 'child cannot be null');
    if (maxHeight != null) this.maxHeight = maxHeight;
    if (expandableCondition != null)
      this.expandableCondition = expandableCondition;
  ***REMOVED***

  @override
  State<StatefulWidget> createState() {
    return _ExpandableConstraintBox();
  ***REMOVED***
***REMOVED***

class _ExpandableConstraintBox extends State<ExpandableConstrainedBox>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.expandableCondition
        ? GestureDetector(
            child: Container(
              padding: EdgeInsets.zero,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSize(
                        curve: Curves.decelerate,
                        vsync: this,
                        alignment: Alignment.topCenter,
                        duration: Duration(milliseconds: 250),
                        child: ConstrainedBox(
                            key: Key('ExpandableConstraintBox constrained box'),
                            constraints: BoxConstraints(
                                maxHeight: expanded
                                    ? double.infinity
                                    : widget.maxHeight,
                                maxWidth: 220.0,
                                minWidth: 220.0),
                            child: widget.child)),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      key: Key('ExpandableConstraintBox icon'),
                    ),
                  ]),
            ),
            onTap: () => setState(() => expanded = !expanded),
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: expanded ? double.infinity : widget.maxHeight,
                maxWidth: 250.0),
            child: widget.child);
  ***REMOVED***
***REMOVED***
