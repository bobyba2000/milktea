import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea_server/common_widgets/search_widget.dart';
import 'package:milktea_server/model/category_item_model.dart';
import 'package:milktea_server/page/category/category_item_dialog.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<CategoryItemModel> listCategoryItems;
  late List<DatabaseReference> listCategoryItemsReference;

  @override
  void initState() {
    super.initState();
    listCategoryItems = [];
    listCategoryItemsReference = [];
    getListCategoryItem();
  }

  Future<void> getListCategoryItem({String textSearch = ''}) async {
    EasyLoading.show();
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('category').get();
    EasyLoading.dismiss();
    List<CategoryItemModel> listCategoryItems = [];
    List<DatabaseReference> listCategoryItemsReference = [];
    for (var element in response.children) {
      CategoryItemModel categoryItemModel =
          CategoryItemModel.fromJson(element.value);
      if (categoryItemModel.name
              ?.toUpperCase()
              .contains(textSearch.toUpperCase()) ??
          false) {
        listCategoryItems.add(categoryItemModel);
        listCategoryItemsReference.add(element.ref);
      }
    }
    setState(() {
      this.listCategoryItems = listCategoryItems;
      this.listCategoryItemsReference = listCategoryItemsReference;
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
                'Tạo danh mục mới',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: CategoryItemDialog(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          );
          getListCategoryItem();
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'DANH MỤC',
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
                  getListCategoryItem(textSearch: value ?? '');
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
                mainAxisExtent: 80,
              ),
              itemCount: listCategoryItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Cập nhật danh mục',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: CategoryItemDialog(
                          categoryItemModel: listCategoryItems[index],
                          categoryItemReference:
                              listCategoryItemsReference[index],
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    );
                    getListCategoryItem();
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
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    listIcon[
                                        listCategoryItems[index].icon ?? 0],
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
                                              listCategoryItems[index].name ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        listCategoryItems[index].description ??
                                            '',
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
