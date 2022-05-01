class MenuItemModel {
  String? name;
  int? price;
  String? imageUrl;
  String? type;
  String? description;

  MenuItemModel({
    this.name,
    this.price,
    this.imageUrl,
    this.type,
    this.description,
  });

  factory MenuItemModel.fromJson(dynamic json) {
    return MenuItemModel(
      name: json['name'],
      price: int.tryParse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'type': type,
        'description': description,
      };

  @override
  String toString() {
    return name ?? '';
  }
}
