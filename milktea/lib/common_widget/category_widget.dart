import 'package:flutter/material.dart';
import 'package:milktea/model/menu_item_model.dart';
import 'package:milktea/model/order_item_model.dart';
import 'package:milktea/page/menu/menu_item_detail_page.dart';

import 'menu_item_widget.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryTitle;
  final List<MenuItemModel> listCategoryItems;
  final IconData icon;

  final bool isShowIceOption;
  final bool isShowSugarOption;
  final Function(OrderItemModel) onSelect;
  const CategoryWidget({
    Key? key,
    required this.categoryTitle,
    required this.listCategoryItems,
    required this.icon,
    required this.onSelect,
    this.isShowIceOption = false,
    this.isShowSugarOption = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                categoryTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          itemBuilder: (context, index) => InkWell(
            onTap: () async {
              final OrderItemModel? item =
                  await showModalBottomSheet<OrderItemModel>(
                context: context,
                builder: (context) => MenuItemDetailPage(
                  menuItem: listCategoryItems[index],
                  isShowIceOption: isShowIceOption,
                  isShowSugarOption: isShowSugarOption,
                ),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                useRootNavigator: true,
              );
              if (item != null && item.amount != 0) {
                onSelect.call(item);
              }
            },
            child: MenuItemWidget(
              value: listCategoryItems[index],
            ),
          ),
          itemCount: listCategoryItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemExtent: 150,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
