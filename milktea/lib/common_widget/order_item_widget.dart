import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/common_widget/adjust_number_widget.dart';
import 'package:milktea/common_widget/network_image_widget.dart';
import 'package:milktea/model/order_item_model.dart';

import '../helper/format_helper.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItemModel value;
  final Function onDelete;
  final Function(int) onChange;
  final bool isEditable;
  const OrderItemWidget({
    Key? key,
    required this.value,
    required this.onChange,
    required this.onDelete,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  late String price;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price =
        ((widget.value.menuItem.price ?? 0) * widget.value.amount).toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: NetworkImageWidget(
            url: widget.value.menuItem.imageUrl,
            width: 80,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 105,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.value.menuItem.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Visibility(
                      visible: widget.isEditable,
                      child: InkWell(
                        onTap: () {
                          widget.onDelete.call();
                        },
                        child: const Icon(
                          Iconsax.trash,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Sugar: ${widget.value.sugarOption}, Ice: ${widget.value.iceOption}.',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 4),
                Text(
                  '${FormatHelper.formatNumber(widget.value.menuItem.price?.toString() ?? "")} VND',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${FormatHelper.formatNumber(price)} VND',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    AdjustNumberWidget(
                      onChange: (value) {
                        widget.onChange.call(value);
                        setState(() {
                          price = ((widget.value.menuItem.price ?? 0) * value)
                              .toString();
                        });
                      },
                      iconSize: 12,
                      initValue: widget.value.amount,
                      isEditable: widget.isEditable,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
