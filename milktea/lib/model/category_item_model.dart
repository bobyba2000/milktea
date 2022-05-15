class CategoryItemModel {
  String? name;
  int? icon;
  String? description;
  bool isIceOption;
  bool isSugarOption;

  CategoryItemModel({
    this.name,
    this.icon,
    this.description,
    this.isIceOption = false,
    this.isSugarOption = false,
  });

  factory CategoryItemModel.fromJson(dynamic json) {
    return CategoryItemModel(
      name: json['name'],
      icon: int.tryParse(json['icon'].toString()),
      description: json['description'],
      isIceOption: json['isIceOption'].toString() == 'true',
      isSugarOption: json['isSugarOption'].toString() == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'description': description,
        'isIceOption': isIceOption,
        'isSugarOption': isSugarOption,
      };

  @override
  String toString() {
    return name ?? '';
  }
}
