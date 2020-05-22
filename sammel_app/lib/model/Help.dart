import 'package:flutter/cupertino.dart';

class Help {
  int id;
  String title;
  Widget content;
  Widget shortContent;
  List<String> tags;

  Help(this.id, this.title, this.content, this.shortContent, this.tags);
}
