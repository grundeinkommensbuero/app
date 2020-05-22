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
  final searchInputController = TextEditingController();
  int opened;
  List<Help> helps = HelpService.loadHelps('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        color: DweTheme.purple,
        child: SizedBox(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchInputController,
                      key: Key('faq search input'),
                      maxLines: 1,
                      decoration: InputDecoration(
//                        suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {***REMOVED***),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: InputBorder.none,
                          hintText: 'Durchsuchen'),
                      onChanged: (text) =>
                          setState(() => helps = HelpService.loadHelps(text)),
                    ),
                  ),
                  IconButton(
                      key: Key('search clear button'),
                      icon: Icon(Icons.close),
                      color: DweTheme.purple,
                      onPressed: () => setState(() {
                            searchInputController.text = '';
                            helps = HelpService.loadHelps('');
                          ***REMOVED***)),
                ]),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
            itemCount: helps.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () => setState(() {
                      if (opened == helps[index].id)
                        opened = null;
                      else
                        opened = helps[index].id;
                    ***REMOVED***),
                child: HelpTile(helps[index],
                    extended: opened == helps[index].id))),
      )
    ]));
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
      contentPadding: EdgeInsets.only(bottom: 2.0),
      title: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: extended ? DweTheme.yellowLight : DweTheme.yellowBright,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  spreadRadius: 1.0)
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            help.title,
            style: TextStyle(
                color: DweTheme.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10.0,
          ),
          extended ? help.content : help.shortContent
        ]),
      ),
    );
  ***REMOVED***
***REMOVED***
