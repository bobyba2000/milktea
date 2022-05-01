import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:milktea/common_widget/list_select_items.dart';
import 'package:milktea/common_widget/order_item_widget.dart';
import 'package:milktea/common_widget/text_field_widget.dart';
import 'package:milktea/model/order_model.dart';
import 'package:milktea/utils/toast_utils.dart';

import '../../helper/format_helper.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel orderModel;
  final bool isEditable;
  const OrderDetailPage({
    Key? key,
    required this.orderModel,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _nameController;
  late OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: widget.orderModel.userAddress);
    _phoneController = TextEditingController(text: widget.orderModel.userPhone);
    _nameController = TextEditingController(text: widget.orderModel.userName);
    orderModel = widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                widget.isEditable ? 'Xác nhận đơn hàng' : 'Đơn hàng của bạn',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: !widget.isEditable,
                        child: Row(
                          children: [
                            Text(
                              orderModel.status ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              controller: _addressController,
                              label: 'Địa chỉ của bạn',
                              hintText: 'Nhập địa chỉ của bạn.',
                              readOnly: !widget.isEditable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              controller: _nameController,
                              label: 'Tên của bạn',
                              hintText: 'Nhập tên của bạn.',
                              readOnly: !widget.isEditable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              controller: _phoneController,
                              label: 'SĐT',
                              hintText: 'Nhập số điện thoại của bạn.',
                              readOnly: !widget.isEditable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Đơn hàng của bạn',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderItemWidget(
                            value: widget.orderModel.listOrderItem[index],
                            onChange: (value) {
                              setState(() {
                                orderModel.listOrderItem[index].amount = value;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                orderModel.listOrderItem.removeAt(index);
                              });
                            },
                            isEditable: widget.isEditable,
                          ),
                        ),
                        itemCount: widget.orderModel.listOrderItem.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      const SizedBox(height: 12),
                      widget.isEditable
                          ? ListSelectItemWidget(
                              title: 'Payment',
                              initValue: orderModel.paymentMethod ==
                                      'Thanh toán online (PAYPAL)'
                                  ? 0
                                  : 1,
                              listOptions: const [
                                'Thanh toán online (PAYPAL)',
                                'Thanh toán khi nhận hàng'
                              ],
                              onChange: (value) {
                                orderModel.paymentMethod = value;
                              },
                              isShowSubtitle: false,
                            )
                          : Text(
                              orderModel.paymentMethod ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Text(
            'Tổng cộng: ${FormatHelper.formatNumber(calculateTotal().toString())} VND',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: widget.isEditable,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () async {
                if (_addressController.text != '' &&
                    _nameController.text != '' &&
                    _phoneController.text != '') {
                  orderModel.userAddress = _addressController.text;
                  orderModel.userName = _nameController.text;
                  orderModel.userPhone = _phoneController.text;
                  orderModel.paymentMethod ??= 'Thanh toán khi nhận hàng';

                  if (orderModel.paymentMethod ==
                      'Thanh toán online (PAYPAL)') {
                    var request = BraintreeDropInRequest(
                      tokenizationKey: 'sandbox_fw2r8mcj_7f6b8zzqqkfttth8',
                      collectDeviceData: true,
                      paypalRequest: BraintreePayPalRequest(
                        amount: (calculateTotal() / 23000).toString(),
                        displayName: 'MilkTea',
                        currencyCode: 'USD',
                      ),
                    );

                    BraintreeDropInResult? result =
                        await BraintreeDropIn.start(request);
                    if (result == null) {
                      ToastUtils.showToast(
                          msg: 'Thanh toán thất bại', isError: true);
                    } else {
                      ToastUtils.showToast(
                        msg:
                            'Thanh toán thành công, mong bạn chờ trong giây lát để quán xác nhận đơn hàng',
                      );
                      DatabaseReference ref =
                          FirebaseDatabase.instance.ref('order');
                      await ref.push().set(orderModel.toJson());

                      Navigator.pop(context, true);
                    }
                  } else {
                    ToastUtils.showToast(
                      msg:
                          'Thanh toán thành công, mong bạn chờ trong giây lát để quán xác nhận đơn hàng',
                    );
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref('order');
                    await ref.push().set(orderModel.toJson());

                    Navigator.pop(context, true);
                  }
                } else {
                  ToastUtils.showToast(
                    msg: 'Hãy nhập thông tin của bạn.',
                    isError: true,
                  );
                }
              },
            ),
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
