import 'package:milktea/model/menu_item_model.dart';

class OrderItemModel {
  MenuItemModel menuItem;
  String iceOption;
  String sugarOption;
  int amount;

  OrderItemModel({
    required this.menuItem,
    required this.iceOption,
    required this.sugarOption,
    this.amount = 0,
  });

  Map toJson() => {
        'menuItem': menuItem.toJson(),
        'iceOption': iceOption,
        'sugarOption': sugarOption,
        'amount': amount,
      };

  factory OrderItemModel.fromJson(Map json) {
    return OrderItemModel(
      menuItem: MenuItemModel.fromJson(json['menuItem']),
      iceOption: json['iceOption'] ?? '',
      sugarOption: json['sugarOption'] ?? '',
      amount: json['amount'] as int,
    );
  }
}
