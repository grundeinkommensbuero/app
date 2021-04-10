import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQ extends StatefulWidget {
  FAQ() : super(key: Key('faq page'));

  @override
  State<StatefulWidget> createState() => FAQState();
***REMOVED***

class FAQState extends State<FAQ> {
  final searchInputController = TextEditingController();
  double? opened;
  List<FAQItem>? items;
  ScrollController? controller;

  late AbstractFAQService faqService;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      this.faqService = Provider.of<AbstractFAQService>(context);
      faqService.getSortedFAQ(null).then((faq) => setState(() => items = faq));
    ***REMOVED***

    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        color: DweTheme.purple,
        child: SizedBox(
          child: TextField(
            controller: searchInputController,
            key: Key('faq search input'),
            maxLines: 1,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                    key: Key('faq search clear button'),
                    icon: Icon(Icons.clear, color: DweTheme.purple),
                    onPressed: () => faqService
                        .getSortedFAQ(null)
                        .then((faq) => setState(() {
                              searchInputController.clear();
                              items = faq;
                            ***REMOVED***))),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Durchsuchen'.tr()),
            onChanged: (text) {
              controller?.jumpTo(0);
              faqService
                  .getSortedFAQ(text)
                  .then((faq) => setState(() => items = faq));
            ***REMOVED***,
          ),
        ),
      ),
      items == null
          ? Text('Lade...')
          : Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: items!.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                      onTap: () => setState(() {
                            if (opened == items![index].order)
                              opened = null;
                            else
                              opened = items![index].order;
                            primaryFocus?.unfocus();
                          ***REMOVED***),
                      child: FAQTile(items![index],
                          extended: opened == items![index].order))),
            )
    ]));
  ***REMOVED***
***REMOVED***

// ignore: must_be_immutable
class FAQTile extends StatelessWidget {
  final FAQItem item;
  final bool extended;

  FAQTile(this.item, {this.extended = false***REMOVED***) : super(key: Key('item tile'));

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
            item.title,
            style: TextStyle(
                color: DweTheme.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10.0,
          ),
          MarkdownBody(
              data: extended ? item.full : item.teaser,
              onTapLink: (_1, link, _2) => launch(link ?? ''),
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                  a: TextStyle(
                      color: DweTheme.purple,
                      decoration: TextDecoration.underline),
                  blockquoteDecoration:
                      BoxDecoration(color: DweTheme.yellowBright)))
        ]),
      ),
    );
  ***REMOVED***
***REMOVED***
