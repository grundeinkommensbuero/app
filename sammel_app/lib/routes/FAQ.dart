import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Help.dart';
import 'package:sammel_app/services/HelpService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class FAQ extends StatefulWidget {
  FAQ() : super(key: Key('faq page'));

  @override
  State<StatefulWidget> createState() => FAQState();
***REMOVED***

class FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: HelpService.helps.length,
            itemBuilder: (BuildContext context, int index) =>
                HelpTile(HelpService.helps[index], extended: false)));
  ***REMOVED***
***REMOVED***

// ignore: must_be_immutable
class HelpTile extends StatelessWidget {
  final Help help;
  final bool extended;

  HelpTile(this.help, {this.extended***REMOVED***) : super(key: Key('help tile'));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(2.0),
      title: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: DweTheme.yellowLight, boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 1.0)
        ]),
        child: Column(children: [
          Text(help.title),
          extended ? help.content : help.shortContent
        ]),
      ),
    );
  ***REMOVED***
***REMOVED***
