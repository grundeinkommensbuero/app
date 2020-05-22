import 'package:flutter/foundation.dart';

class Help {
  int id;
  String title;
  String content;
  List<String> tags;

  Help(this.id, this.title, this.content, this.tags);

  Help.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        tags =  List<String>.from(json['tags']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'tags': tags,
      ***REMOVED***

  bool equals(Help that) =>
      this.id == that.id &&
      this.title == that.title &&
      this.content == that.content &&
      listEquals(this.tags, that.tags);
***REMOVED***
