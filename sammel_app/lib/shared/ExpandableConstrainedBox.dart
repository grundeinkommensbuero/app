import 'package:flutter/material.dart';

class ExpandableConstrainedBox extends StatefulWidget {
  final Widget child;
  final double maxHeight;
  final bool expandableCondition;

  ExpandableConstrainedBox(
      {this.child, this.maxHeight = 40.0, this.expandableCondition = true}) {
    assert(child != null, 'child cannot be null');
  }

  @override
  State<StatefulWidget> createState() {
    return _ExpandableConstraintBox();
  }
}

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
  }
}
