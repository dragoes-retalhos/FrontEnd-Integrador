class Item {
  final String nameItem;
  final int amount;
  final String? description;

  Item({required this.nameItem, required this.amount, this.description});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      nameItem: json['nameItem'],
      amount: json['amount'],
      description: json['description'],
    );
  }
}
