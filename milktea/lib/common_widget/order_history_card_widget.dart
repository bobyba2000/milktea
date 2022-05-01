import 'package:flutter/material.dart';
import 'package:milktea/helper/format_helper.dart';
import 'package:milktea/model/order_model.dart';
import 'package:milktea/page/menu/order_detail_page.dart';

class OrderHistoryCardWidget extends StatelessWidget {
  final OrderModel orderModel;
  const OrderHistoryCardWidget({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showModalBottomSheet<bool>(
          context: context,
          builder: (context) => OrderDetailPage(
            orderModel: orderModel,
            isEditable: false,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          useRootNavigator: true,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    orderModel.listOrderItem.length > 1
                        ? '${orderModel.listOrderItem[0].menuItem.name} + ${orderModel.listOrderItem.length - 1} sản phẩm khác.'
                        : '${orderModel.listOrderItem[0].menuItem.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    '${FormatHelper.formatNumber(calculateTotal().toString())} VND',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              orderModel.status.toString(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(thickness: 2),
          ],
        ),
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
