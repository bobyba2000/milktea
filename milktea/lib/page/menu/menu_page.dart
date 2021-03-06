import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:milktea/bloc/menu_bloc.dart';
import 'package:milktea/common_widget/category_widget.dart';
import 'package:milktea/helper/format_helper.dart';
import 'package:milktea/model/category_item_model.dart';
import 'package:milktea/model/order_model.dart';
import 'package:milktea/page/menu/order_detail_page.dart';
import 'package:milktea/service/api_service.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const listIcon = [
  Icons.cake,
  Icons.free_breakfast,
  Icons.local_cafe,
  Icons.local_bar,
  Icons.local_dining,
  Icons.local_drink,
  Icons.local_pizza,
  Icons.restaurant,
  Icons.restaurant_menu,
  Icons.room_service,
  Icons.widgets,
];

class MenuPage extends StatefulWidget {
  final OrderModel orderModel;
  final Function(OrderModel) onChangeOrder;
  const MenuPage({
    Key? key,
    required this.orderModel,
    required this.onChangeOrder,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late MenuBloc bloc;
  late OrderModel orderModel;
  int total = 0;
  List<CategoryItemModel> listCategory = [];

  @override
  void initState() {
    super.initState();
    bloc = MenuBloc();
    orderModel = widget.orderModel;
    getListCategoryItem();
  }

  Future<void> getListCategoryItem() async {
    EasyLoading.show();
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('category').get();
    EasyLoading.dismiss();
    List<CategoryItemModel> listCategoryItems = [];
    for (var element in response.children) {
      CategoryItemModel categoryItemModel =
          CategoryItemModel.fromJson(element.value);
      listCategoryItems.add(categoryItemModel);
    }
    setState(() {
      listCategory = listCategoryItems;
    });
    onBack();
  }

  Future<void> onBack() async {
    await bloc.getMenuItem();
    int total = await calculateTotal();
    setState(() {
      this.total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Menu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: BlocProvider<MenuBloc>(
          create: (BuildContext context) => bloc,
          child: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: FormBuilderDropdown<CategoryItemModel>(
                            name: '',
                            decoration: const InputDecoration(
                              labelText: 'Danh m???c',
                              hintText: 'Ch???n danh m???c',
                              border: InputBorder.none,
                            ),
                            allowClear: true,
                            items: listCategory
                                .map((menuCateogry) => DropdownMenuItem(
                                      value: menuCateogry,
                                      child: Text(menuCateogry.name ?? ''),
                                    ))
                                .toList(),
                            onChanged: (value) async {
                              if (value != null) {
                                int position = listCategory.indexOf(value);
                                if (position != -1) {
                                  itemScrollController.scrollTo(
                                    index: position,
                                    duration: const Duration(milliseconds: 700),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SearchWidget(
                          flex: 5,
                          onSearch: (value) {
                            bloc.search(value ?? '');
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemBuilder: (context, index) => CategoryWidget(
                        categoryTitle: listCategory[index].name ?? '',
                        listCategoryItems: state.listMenuItem
                            .where((element) =>
                                element.type == listCategory[index].name)
                            .toList(),
                        icon: listIcon[listCategory[index].icon ?? 0],
                        onSelect: (item) async {
                          orderModel.listOrderItem.add(item);
                          int tot = await calculateTotal();
                          setState(() {
                            total = tot;
                            widget.onChangeOrder(orderModel);
                          });
                        },
                        isShowIceOption: listCategory[index].isIceOption,
                        isShowSugarOption: listCategory[index].isSugarOption,
                      ),
                      itemCount: listCategory.length,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shrinkWrap: true,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        persistentFooterButtons: orderModel.listOrderItem.isNotEmpty
            ? [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: 200,
                    child: Text(
                      '${FormatHelper.formatNumber(total.toString())} VND',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    bool? isSuccess = await showModalBottomSheet<bool>(
                      context: context,
                      builder: (context) => OrderDetailPage(
                        orderModel: orderModel,
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useRootNavigator: true,
                    );
                    if (isSuccess != null && isSuccess) {
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
                      orderModel = OrderModel(
                        listOrderItem: [],
                        userID: FirebaseAuth.instance.currentUser?.uid ?? '',
                      );
                    }
                    int currentTotal = await calculateTotal();
                    setState(() {
                      total = currentTotal;
                      orderModel.listOrderItem
                          .removeWhere((element) => element.amount == 0);
                      widget.onChangeOrder(orderModel);
                    });
                  },
                ),
              ]
            : null,
      ),
    );
  }

  Future<int> calculateTotal() async {
    EasyLoading.show();
    final List<int> listProduct = orderModel.listOrderItem
        .map((e) => e.amount * (e.menuItem.price ?? 0))
        .toList();
    int res = await ApiService.calculateTotal({'listProduct': listProduct}) ??
        listProduct.fold(
            0, (previousValue, element) => previousValue + element);
    EasyLoading.dismiss();
    return res;
  }
}

class SearchWidget extends StatefulWidget {
  final bool isExpanded;
  final String? hintTextSearch;
  final int? flex;
  final Function(String?)? onSearch;
  const SearchWidget({
    Key? key,
    this.isExpanded = false,
    this.onSearch,
    this.flex,
    this.hintTextSearch,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
  late bool _isSearching;
  String? _value;

  @override
  void initState() {
    super.initState();
    _isSearching = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return _isSearching
        ? Expanded(
            flex: widget.flex ?? 1,
            child: FormBuilderTextField(
              name: '',
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Color.fromRGBO(41, 35, 63, 1.0),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              maxLength: 500,
              initialValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
                EasyDebounce.debounce(
                    'debounceTagSearch',
                    const Duration(milliseconds: 700),
                    () => widget.onSearch?.call(value));
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: _inputBorder(Colors.transparent),
                enabledBorder: _inputBorder(Colors.transparent),
                focusedBorder: _inputBorder(Theme.of(context).primaryColor),
                errorBorder: _inputBorder(Colors.red),
                focusedErrorBorder: _inputBorder(Colors.transparent),
                disabledBorder: _inputBorder(Colors.transparent),
                counterText: '',
                hintText: widget.hintTextSearch,
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(41, 35, 63, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(
                      () {
                        _isSearching = false;
                        if (_value != null && _value != '') {
                          EasyDebounce.debounce(
                              'debounceTagSearch',
                              const Duration(milliseconds: 700),
                              () => widget.onSearch?.call(null));
                        }
                        _value = null;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Iconsax.close_circle,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              setState(() {
                _isSearching = true;
              });
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Iconsax.search_normal,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
    ;
  }
}
