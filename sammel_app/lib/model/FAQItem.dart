import 'package:flutter/material.dart';

class FAQItem {
  int id;
  String title;
  Widget content;
  Widget shortContent;
  String plainText;
  List<String> tags;

  FAQItem(this.id, this.title, this.content, this.shortContent, this.plainText,
      this.tags);

  FAQItem.text(id, title, plainText, tags)
      : this.short(id, title, Text(plainText), plainText, tags);

  FAQItem.short(id, title, content, plainText, tags)
      : this(id, title, content, content, plainText, tags);
}
