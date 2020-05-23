import 'package:flutter/material.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class FAQ extends StatefulWidget {
  FAQ() : super(key: Key('faq page'));

  @override
  State<StatefulWidget> createState() => FAQState();
}

class FAQState extends State<FAQ> {
  final searchInputController = TextEditingController();
  int opened;
  List<FAQItem> items = FAQService.loadItems('');

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => setState(() {
                          searchInputController.clear();
                          items = FAQService.loadItems('');
                        })),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Durchsuchen'),
            onChanged: (text) =>
                setState(() => items = FAQService.loadItems(text)),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () => setState(() {
                      if (opened == items[index].id)
                        opened = null;
                      else
                        opened = items[index].id;
                      primaryFocus.unfocus();
                    }),
                child: FAQTile(items[index],
                    extended: opened == items[index].id))),
      )
    ]));
  }
}

// ignore: must_be_immutable
class FAQTile extends StatelessWidget {
  final FAQItem item;
  final bool extended;

  FAQTile(this.item, {this.extended}) : super(key: Key('item tile'));

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
          extended ? item.content : item.shortContent
        ]),
      ),
    );
  }
}
