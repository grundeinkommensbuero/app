import 'package:flutter/foundation.dart';

class Help {
  int id;
  String title;
  String content;
  var shortContent;
  List<String> tags;

  Help(this.id, this.title, this.content, this.shortContent, this.tags);

  Help.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? '',
        content = json['content'] ?? '',
        shortContent = json['shortContent'] ?? '',
        tags =  List<String>.from(json['tags']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'shortContent': shortContent,
        'tags': tags,
      };

  bool equals(Help that) =>
      this.id == that.id &&
      this.title == that.title &&
      this.content == that.content &&
      this.shortContent == that.shortContent &&
      listEquals(this.tags, that.tags);
}
