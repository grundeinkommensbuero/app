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

  String get full => '$teaser${rest ?? ''***REMOVED***';
***REMOVED***
