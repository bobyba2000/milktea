import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/network_image_widget.dart';
import 'package:milktea_server/common_widgets/search_widget.dart';
import 'package:milktea_server/helper/format_helper.dart';
import 'package:milktea_server/model/menu_item_model.dart';
import 'package:milktea_server/model/order_model.dart';
import 'package:milktea_server/page/menu/menu_item_dialog.dart';
import 'package:milktea_server/page/order/order_detail_dialog.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<OrderModel> listOrder;
  late List<DatabaseReference> listOrderReference;

  @override
  void initState() {
    super.initState();
    listOrder = [];
    listOrderReference = [];
    getListOrder();
  }

  Future<void> getListOrder({String textSearch = ''}) async {
    EasyLoading.show();
    DataSnapshot response = await FirebaseDatabase.instance.ref('order').get();
    EasyLoading.dismiss();
    List<OrderModel> listOrder = [];
    List<DatabaseReference> listOrderReference = [];
    int count = 1;
    for (var element in response.children) {
      OrderModel orderModel = OrderModel.fromJson(element.value);
      if (orderModel.userName
              ?.toUpperCase()
              .contains(textSearch.toUpperCase()) ??
          true) {
        orderModel.index = count;
        listOrder.add(orderModel);
        listOrderReference.add(element.ref);
        count++;
      }
    }
    setState(() {
      this.listOrder = listOrder.reversed.toList();
      this.listOrderReference = listOrderReference.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'DANH SÁCH ĐƠN HÀNG',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SearchWidget(
                hintTextSearch: 'Tìm kiếm đơn hàng dựa trên tên khách hàng',
                onSearch: (value) {
                  getListOrder(textSearch: value ?? '');
                },
                flex: 1,
              ),
            ],
          ),
          const SizedBox(height: 36),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                mainAxisExtent: 190,
              ),
              itemCount: listOrder.length,
              itemBuilder: (context, index) {
                String listOrderItem =
                    '${listOrder[index].listOrderItem[0].amount} x ${listOrder[index].listOrderItem[0].menuItem.name}';
                if (listOrder[index].listOrderItem.length >= 2) {
                  listOrderItem = listOrderItem +
                      ' + ${listOrder[index].listOrderItem[1].amount} x ${listOrder[index].listOrderItem[1].menuItem.name}';
                  if (listOrder[index].listOrderItem.length > 2) {
                    listOrderItem = listOrderItem +
                        ' + ${listOrder[index].listOrderItem.length - 2} các sản phẩm khác.';
                  }
                }
                return GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Xác nhận đơn hàng',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: OrderDetailDialog(
                          orderModel: listOrder[index],
                          orderReference: listOrderReference[index],
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    );
                    getListOrder();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Đơn hàng ${listOrder[index].index}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                '${FormatHelper.formatNumber(
                                  calculateTotal(listOrder[index]).toString(),
                                )} VND',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listOrder[index].paymentMethod ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      listOrder[index].status == 'Chờ xác nhận'
                                          ? Colors.yellow
                                          : listOrder[index].status == 'Đã hủy'
                                              ? Colors.red
                                              : Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Text(
                                  listOrder[index].status?.toUpperCase() ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 12,
                            left: 12,
                          ),
                          child: Text(
                            'Khách hàng ${listOrder[index].userName}, số điện thoại là ${listOrder[index].userPhone} đặt giao tới địa chỉ ${listOrder[index].userAddress}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            listOrderItem,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  int calculateTotal(OrderModel orderModel) {
    int res = orderModel.listOrderItem
        .map((e) => e.amount * (e.menuItem.price ?? 0))
        .toList()
        .fold(0, (previousValue, element) => previousValue + element);
    return res;
  }
}
