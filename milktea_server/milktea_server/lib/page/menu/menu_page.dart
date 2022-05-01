import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/network_image_widget.dart';
import 'package:milktea_server/common_widgets/search_widget.dart';
import 'package:milktea_server/helper/format_helper.dart';
import 'package:milktea_server/model/menu_item_model.dart';
import 'package:milktea_server/page/menu/menu_item_dialog.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<MenuItemModel> listMenuItems;
  late List<DatabaseReference> listMenuItemsReference;

  @override
  void initState() {
    super.initState();
    listMenuItems = [];
    listMenuItemsReference = [];
    getListMenuItem();
  }

  Future<void> getListMenuItem({String textSearch = ''}) async {
    EasyLoading.show();
    DataSnapshot response = await FirebaseDatabase.instance.ref('menu').get();
    EasyLoading.dismiss();
    List<MenuItemModel> listMenuItems = [];
    List<DatabaseReference> listMenuItemsReference = [];
    for (var element in response.children) {
      MenuItemModel menuItemModel = MenuItemModel.fromJson(element.value);
      if (menuItemModel.name
              ?.toUpperCase()
              .contains(textSearch.toUpperCase()) ??
          false) {
        listMenuItems.add(MenuItemModel.fromJson(element.value));
        listMenuItemsReference.add(element.ref);
      }
    }
    setState(() {
      this.listMenuItems = listMenuItems;
      this.listMenuItemsReference = listMenuItemsReference;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      floatingActionButton: InkWell(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text(
                'Tạo món mới',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: MenuItemDialog(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          );
          getListMenuItem();
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SearchWidget(
                hintTextSearch: 'Tìm kiếm tên sản phẩm',
                onSearch: (value) {
                  getListMenuItem(textSearch: value ?? '');
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
                mainAxisExtent: 130,
              ),
              itemCount: listMenuItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Cập nhật món',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: MenuItemDialog(
                          menuItemModel: listMenuItems[index],
                          menuItemReference: listMenuItemsReference[index],
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    );
                    getListMenuItem();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: NetworkImageWidget(
                                    url: listMenuItems[index].imageUrl ?? '',
                                    width: 80,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              listMenuItems[index].name ?? '',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            listMenuItems[index].type ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${FormatHelper.formatNumber(listMenuItems[index].price?.toString() ?? '')} VND',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(
                                        listMenuItems[index].description ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
