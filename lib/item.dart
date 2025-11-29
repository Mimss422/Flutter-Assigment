class Item {
  final String title;
  final bool isDone;

  Item({required this.title, this.isDone = false});

  // Convert Item → Map
  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  // Convert Map → Item
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(title: json['title'], isDone: json['isDone']);
  }
}
