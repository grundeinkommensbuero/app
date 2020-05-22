import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class FAQ extends StatefulWidget {
  FAQ() : super(key: Key('faq page'));

  @override
  State<StatefulWidget> createState() => FAQState();
}

class FAQState extends State<FAQ> {
  var helps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: helps.map((help) => HelpCard(help)).toList()));
  }
}

class HelpCard extends StatelessWidget {
  final help;

  HelpCard(this.help) : super(key: Key('help tile'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: DweTheme.yellowLight, boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
            spreadRadius: 1.0)
      ]),
      child: Column(
        children: [Text('Title')],
      ),
    );
  }
}
