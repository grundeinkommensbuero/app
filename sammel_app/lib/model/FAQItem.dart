class FAQItem {
  int id;
  String title;
  String teaser;
  String? rest;
  double order;
  List<String> tags;

  FAQItem(this.id, this.title, this.teaser, this.rest, this.order, this.tags);

  FAQItem.short(id, title, content, order, tags)
      : this(id, title, content, null, order, tags);

  String get full => '$teaser${rest ?? ''}';

  FAQItem.fromJson(json) :
      id = json['id'],
      title = json['title'],
      teaser = json['teaser'],
      rest = json['rest'],
      order = json['order'],
      tags = (json['tags'] as List).map((tag) => tag as String).toList();

  toJson() => {
    "id": id,
    "title": title,
    "teaser": teaser,
    "rest": rest,
    "order": order,
    "tags": tags
  };
}
