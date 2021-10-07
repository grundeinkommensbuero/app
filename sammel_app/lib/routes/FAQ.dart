import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
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
      listenToFAQ();
    ***REMOVED***

    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        color: CampaignTheme.secondary,
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
                    icon: Icon(Icons.clear, color: CampaignTheme.secondary),
                    onPressed: () {
                      listenToFAQ(search: null);
                      setState(() => searchInputController.clear());
                    ***REMOVED***),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Durchsuchen'.tr()),
            onChanged: (text) {
              controller?.jumpTo(0);
              listenToFAQ(search: text);
            ***REMOVED***,
          ),
        ),
      ),
      items == null
          ? Expanded(child: Center(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      color: CampaignTheme.secondary)))
)          : Expanded(
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

  listenToFAQ({String? search***REMOVED***) => faqService
      .getSortedFAQ(search)
      .listen((faq) => setState(() => items = faq));
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
            color: extended ? CampaignTheme.primaryLight : CampaignTheme.primaryBright,
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
                color: CampaignTheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10.0,
          ),
          MarkdownBody(
              data: extended ? item.full : item.teaser,
              onTapLink: (_a, link, _b) => launch(link ?? ''),
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                  a: TextStyle(
                      color: CampaignTheme.secondary,
                      decoration: TextDecoration.underline),
                  blockquoteDecoration:
                      BoxDecoration(color: CampaignTheme.primaryBright))),
          (item.rest != null && !extended
              ? Text(
                  'Weiterlesen',
                  style: TextStyle(color: CampaignTheme.secondary),
                ).tr()
              : Container())
        ]),
      ),
    );
  ***REMOVED***
***REMOVED***
