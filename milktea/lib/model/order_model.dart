import 'package:milktea/model/order_item_model.dart';

class OrderModel {
  List<OrderItemModel> listOrderItem;
  String? userAddress;
  String? userName;
  String? userPhone;
  String? paymentMethod;
  String? status;
  String userID;

  OrderModel({
    required this.listOrderItem,
    required this.userID,
    this.userAddress,
    this.paymentMethod,
    this.status,
    this.userName,
    this.userPhone,
  });

  Map toJson() {
    return {
      'listOrderItem': listOrderItem.map((e) => e.toJson()).toList(),
      'userAddress': userAddress,
      'paymentMethod': paymentMethod,
      'status': status ?? 'Chờ xác nhận',
      'userID': userID,
      'userName': userName,
      'userPhone': userPhone,
    };
  }

  factory OrderModel.fromJson(dynamic json) {
    return OrderModel(
      listOrderItem: (json['listOrderItem'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      userID: json['userID'],
      userAddress: json['userAddress'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      userName: json['userName'],
      userPhone: json['userPhone'],
    );
  }
}
