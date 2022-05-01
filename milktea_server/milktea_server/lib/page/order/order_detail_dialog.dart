import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/network_image_widget.dart';
import 'package:milktea_server/common_widgets/text_field_widget.dart';
import 'package:milktea_server/helper/format_helper.dart';
import 'package:milktea_server/model/order_model.dart';
import 'package:milktea_server/utils/toast_utils.dart';

class OrderDetailDialog extends StatefulWidget {
  final OrderModel orderModel;
  final DatabaseReference orderReference;
  const OrderDetailDialog({
    Key? key,
    required this.orderModel,
    required this.orderReference,
  }) : super(key: key);

  @override
  _OrderDetailDialogState createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends State<OrderDetailDialog> {
  TextEditingController customerName = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  late OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    customerName.text = widget.orderModel.userName ?? '';
    customerAddress.text = widget.orderModel.userAddress ?? '';
    customerPhone.text = widget.orderModel.userPhone ?? '';
    orderModel = widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: customerName,
                  label: 'Tên khách hàng',
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: TextFieldWidget(
                  controller: customerPhone,
                  label: 'SĐT khách hàng',
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: customerAddress,
            label: 'Địa chỉ khách hàng',
            readOnly: true,
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Danh sách sản phẩm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: NetworkImageWidget(
                          url: widget.orderModel.listOrderItem[index].menuItem
                                  .imageUrl ??
                              '',
                          width: 80,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          widget.orderModel.listOrderItem[index].toString(),
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
                );
              },
              itemCount: widget.orderModel.listOrderItem.length,
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Tổng giá trị: ${FormatHelper.formatNumber(calculateTotal().toString())} VND',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Thoát',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Visibility(
                visible: orderModel.status == 'Chờ xác nhận',
                child: TextButton(
                  onPressed: () async {
                    try {
                      orderModel.status = 'Đã hủy';
                      EasyLoading.show();
                      await widget.orderReference.update(orderModel.toJson());
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'Hủy thành công.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'Hủy thất bại, hãy thử lại.');
                    }
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Visibility(
                visible: orderModel.status == 'Chờ xác nhận',
                child: TextButton(
                  onPressed: () async {
                    try {
                      EasyLoading.show();
                      orderModel.status = 'Đã xác nhận';
                      await widget.orderReference.update(orderModel.toJson());
                      EasyLoading.dismiss();
                      ToastUtils.showToast(msg: 'Xác nhận thành công.');
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.dismiss();
                      ToastUtils.showToast(
                          msg: 'Xác nhận thất bại, hãy thử lại.');
                    }
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int calculateTotal() {
    int res = orderModel.listOrderItem
        .map((e) => e.amount * (e.menuItem.price ?? 0))
        .toList()
        .fold(0, (previousValue, element) => previousValue + element);
    return res;
  }
}
