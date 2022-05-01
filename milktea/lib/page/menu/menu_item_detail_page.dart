import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/common_widget/adjust_number_widget.dart';
import 'package:milktea/common_widget/list_select_items.dart';
import 'package:milktea/common_widget/network_image_widget.dart';
import 'package:milktea/constants/order_item_option.dart';
import 'package:milktea/model/menu_item_model.dart';
import 'package:milktea/model/order_item_model.dart';

import '../../helper/format_helper.dart';

class MenuItemDetailPage extends StatefulWidget {
  final MenuItemModel menuItem;
  final bool isShowIceOption;
  final bool isShowSugarOption;
  const MenuItemDetailPage({
    Key? key,
    required this.menuItem,
    this.isShowIceOption = false,
    this.isShowSugarOption = false,
  }) : super(key: key);

  @override
  _MenuItemDetailPageState createState() => _MenuItemDetailPageState();
}

class _MenuItemDetailPageState extends State<MenuItemDetailPage> {
  late OrderItemModel _orderItem;

  @override
  void initState() {
    super.initState();
    _orderItem = OrderItemModel(
      menuItem: widget.menuItem,
      iceOption: widget.isShowIceOption ? OrderItemOption.iceOption[0] : '',
      sugarOption:
          widget.isShowSugarOption ? OrderItemOption.sugarOption[0] : '',
      amount: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              height: size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImageWidget(
                      url: widget.menuItem.imageUrl,
                      width: size.width,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            widget.menuItem.name ?? '',
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${FormatHelper.formatNumber(widget.menuItem.price?.toString() ?? "")} VND',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.menuItem.description ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Visibility(
                            visible: widget.isShowIceOption,
                            child: ListSelectItemWidget(
                              title: 'Chọn mức đá',
                              listOptions: OrderItemOption.iceOption,
                              onChange: (value) {
                                _orderItem.iceOption = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Visibility(
                            visible: widget.isShowSugarOption,
                            child: ListSelectItemWidget(
                              title: 'Chọn mức đường',
                              listOptions: OrderItemOption.sugarOption,
                              onChange: (value) {
                                _orderItem.sugarOption = value;
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              AdjustNumberWidget(
                onChange: (value) {
                  _orderItem.amount = value;
                },
                initValue: 1,
              ),
              Container(
                width: size.width - 160 - 230,
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: 200,
                  child: const Text(
                    'Thêm vào đơn hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, _orderItem);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: InkWell(
              child: const Icon(
                Iconsax.arrow_left,
                color: Colors.white,
                size: 35,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
