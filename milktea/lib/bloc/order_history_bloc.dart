import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea/model/order_item_model.dart';
import 'package:milktea/model/order_model.dart';

class OrderHistoryState extends Equatable {
  final List<OrderModel> listOrder;
  @override
  List<Object?> get props => [listOrder];

  const OrderHistoryState({required this.listOrder});

  OrderHistoryState copyWith({List<OrderModel>? listOrder}) {
    return OrderHistoryState(listOrder: listOrder ?? this.listOrder);
  }
}

class OrderHistoryBloc extends Cubit<OrderHistoryState> {
  OrderHistoryBloc() : super(const OrderHistoryState(listOrder: []));

  Future<void> getOrderHistory() async {
    EasyLoading.show();
    DataSnapshot response = await FirebaseDatabase.instance.ref('order').get();
    EasyLoading.dismiss();
    final List<OrderModel> listOrder = [];
    for (var element in response.children) {
      listOrder.add(OrderModel.fromJson(element.value));
    }
    emit(
      state.copyWith(
        listOrder: listOrder
            .where((element) =>
                element.userID == FirebaseAuth.instance.currentUser?.uid)
            .toList(),
      ),
    );
  }
}
